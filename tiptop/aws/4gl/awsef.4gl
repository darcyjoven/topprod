# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# TIPTOP 整合 EasyFlow, 開單用
# Descriptions...: 主要為定義 AWS 模組的GLOBAL變數
#                  因此 ORACLE   版定義為 VARCHAR
#                       INFORMIX 版定義為 CHAR
# Modify........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.........: No.FUN-680130 06/09/01 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960057 10/09/15 By Jay 增加g_progID變數記錄程式代號
 
DATABASE ds
 
GLOBALS
  DEFINE g_strXMLInput	STRING        	#傳入 EasyFlow 的 XML 字串
  DEFINE g_title	STRING,     	#表單名稱
         g_formID       LIKE oay_file.oayslip, #表單單別              #No.FUN-680130 VARCHAR(5)
         g_formNum	LIKE type_file.chr1000, #表單單號               #No.FUN-680130 VARCHAR(100)  #MOD-690128
         g_key1		LIKE wse_file.wse03,   #SQL key 值(假使需要)   #No.FUN-680130 VARCHAR(20)	
         g_key2		LIKE wse_file.wse04,   #SQL key 值(假使需要)   #No.FUN-680130 VARCHAR(20)	
         g_key3		LIKE wse_file.wse05,   #SQL key 值(假使需要)   #No.FUN-680130 VARCHAR(20)	
         g_key4		LIKE wse_file.wse06,   #SQL key 值(假使需要)   #No.FUN-680130 VARCHAR(20)	
         g_key5		LIKE wse_file.wse07    #SQL key 值(假使需要)   #No.FUN-680130 VARCHAR(20)	
  DEFINE g_msg          LIKE type_file.chr1000 #p_ze 訊息              #No.FUN-680130 VARCHAR(255)
  DEFINE g_chr          LIKE type_file.chr1                            #No.FUN-680130 VARCHAR(1)  
  DEFINE g_progID       LIKE wse_file.wse01     #程式代號              #FUN-960057
END GLOBALS
