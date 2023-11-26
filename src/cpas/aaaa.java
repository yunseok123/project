package cpas;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class aaaa {
  public static void main(String[] args) {
    try {
      // ���̽� ���������� ��ο� ��ũ��Ʈ ���� ���
      String pythonPath = "C:\\Python\\python.exe";
      String scriptPath = "C:\\Program Files\\ss\\20.py";
      
      // ���μ��� ������ ����Ͽ� ��ɾ�� �μ� �и�
      ProcessBuilder processBuilder = new ProcessBuilder(pythonPath, scriptPath);
      Process p = processBuilder.start();
      
      // ǥ�� ��� ��Ʈ��
      BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
      String line;
      while ((line = in.readLine()) != null) {
        System.out.println(line);
      }
      
      // ǥ�� ���� ��Ʈ�� (�ɼ�)
      BufferedReader err = new BufferedReader(new InputStreamReader(p.getErrorStream()));
      while ((line = err.readLine()) != null) {
        System.err.println(line);
      }
      
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
}
