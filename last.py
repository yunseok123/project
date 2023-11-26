# -*- coding: utf-8 -*-
"""Untitled26.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1iaUzhQg12b4igNN09woC7di0Cd9ZMRYF
"""

# -*- coding: utf-8 -*-
"""Untitled26.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1iaUzhQg12b4igNN09woC7di0Cd9ZMRYF
"""

#!/usr/bin/env python
# coding: utf-8

import sys
import io
import pymysql
import pandas as pd
import textdistance
from surprise import Reader, Dataset, SVD

# 데이터베이스에서 모든 가게의 이름을 가져오는 함수
def get_all_stores(connection):
    with connection.cursor() as cursor:
        tables = ['store_ch', 'store_jp', 'store_han']
        all_stores = set()
        for table in tables:
            sql = f"SELECT DISTINCT store_namecol FROM {table}"
            cursor.execute(sql)
            stores = cursor.fetchall()
            for store in stores:
                all_stores.add(store[0])
        return list(all_stores)

# 출력 인코딩 설정
sys.stdout = io.TextIOWrapper(sys.stdout.detach(), encoding='utf-8')

# 사용자로부터 받은 데이터
visit_purpose = sys.argv[1]
features = sys.argv[2:-1]
kakao_id = sys.argv[-1]  # 카카오 아이디 받기

# 만약 로그인하지 않았거나 새로운 사용자인 경우, kakao_id는 빈 문자열일 것입니다.
if not kakao_id:
    kakao_id = None

# new_food_info 데이터베이스에 연결
new_food_info_connection = pymysql.connect(host='localhost',
                                           user='root',
                                           password='0000',
                                           database='new_food_info',
                                           charset='utf8mb4')

# 모든 가게 목록 가져오기
all_stores_list = get_all_stores(new_food_info_connection)
new_food_info_connection.close()

# 데이터베이스 연결
connection = pymysql.connect(host='localhost',
                             user='root',
                             password='0000',
                             database='food_keyword',
                             charset='utf8mb4')

# 콘텐츠 기반 필터링을 수행하여 목적과 특징에 맞는 가게들을 찾는다.
purpose_matched_stores = set()
feature_matched_stores = [set() for _ in features]
try:
    with connection.cursor() as cursor:
        sql = "SELECT DISTINCT store_namecol, text FROM store_info"
        cursor.execute(sql)
        all_stores = cursor.fetchall()

        for store in all_stores:
            store_name = store[0]
            text = store[1]

            purpose_similarity = textdistance.jaccard(visit_purpose, text)
            if purpose_similarity >= 0.8:
                purpose_matched_stores.add(store_name)

            for i, feature in enumerate(features):
                feature_similarity = textdistance.jaccard(feature, text)
                if feature_similarity >= 0.8:
                    feature_matched_stores[i].add(store_name)
except Exception as e:
    print("An error occurred:", e)
    sys.exit()
finally:
    connection.close()

# 특징에 따라 필터링된 가게들의 교집합을 구하고, 목적에 맞는 가게들과의 교집합을 구한다.
feature_matched_stores_intersection = set.intersection(*feature_matched_stores)
final_matched_stores = purpose_matched_stores.intersection(feature_matched_stores_intersection)

# 협업 필터링을 위해 리뷰 데이터베이스에서 데이터 가져오기
if kakao_id:
    review_connection = pymysql.connect(host='localhost',
                                        user='root',
                                        password='0000',
                                        database='review',
                                        charset='utf8mb4')
    try:
        with review_connection.cursor() as cursor:
            sql = "SELECT user_id, store_namecol, user_rating FROM user_review1"
            cursor.execute(sql)
            review_data = cursor.fetchall()
    finally:
        review_connection.close()

    # 리뷰 데이터를 사용하여 SVD 모델 학습
    df = pd.DataFrame(review_data, columns=['user_id', 'store_namecol', 'user_rating'])
    reader = Reader(rating_scale=(1, 5))
    data = Dataset.load_from_df(df[['user_id', 'store_namecol', 'user_rating']], reader)
    trainset = data.build_full_trainset()
    svd = SVD()
    svd.fit(trainset)

    # 콘텐츠 기반 필터링 결과에 대해 협업 필터링을 적용하여 예상 평점 계산
    collab_filtering_scores = {store_namecol: svd.predict(kakao_id, store_namecol).est for store_namecol in final_matched_stores}

    # 예상 평점이 높은 순으로 가게를 정렬합니다.
    sorted_stores = sorted(collab_filtering_scores, key=collab_filtering_scores.get, reverse=True)

    print("모든 추천 가게 목록 (예상 평점 순):")
    for store in sorted_stores:
        print(f"{store}: 예상 평점 {collab_filtering_scores[store]:.2f}")
else:
    print("최종 추천 가게:")
    for store in final_matched_stores:
        print(store)