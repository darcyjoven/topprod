# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_ar_s3.4gl
# Descriptions...: 帳款部門應收帳款比例
# Date & Author..: No.FUN-BA0095 2011/11/21 By linlin
# Input Parameter: p_loc        圖表位置
#                  p_ym         年月
#                  p_tranclass  帳款類別
#                  p_oma08      內銷/外銷
#                  p_custno     收款客戶
# Usage..........: CALL s_chart_ar_s3(p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_ar_s3(p_ym, p_tranclass, p_oma08, p_custno,p_loc)
DEFINE p_loc                  LIKE type_file.chr10
DEFINE ar_s3                  LIKE oma_file.oma56t #帳款金額
DEFINE p_ym                   LIKE type_file.chr6  #年月
DEFINE p_oma08                LIKE oma_file.oma08  #內銷/外銷
DEFINE p_tranclass            LIKE oma_file.oma00  #帳款類別
DEFINE p_custno               LIKE oma_file.oma68  #收款客戶
DEFINE l_sql                  STRING
DEFINE l_str1                 STRING
DEFINE l_substr               STRING               #子標題
DEFINE l_oma08                LIKE oma_file.oma08  #內銷/外銷
DEFINE l_oma15                LIKE oma_file.oma15  #部门编号
DEFINE l_gem02                LIKE gem_file.gem02  #员工姓名
DEFINE l_occ02                LIKE occ_file.occ02  #客户名稱
DEFINE l_oma00                LIKE oma_file.oma13  #帳款類別
DEFINE l_chk_auth             STRING
DEFINE l_oma08_str            STRING

   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc) #初始WebComponent的資料

   IF NOT s_chart_auth("s_chart_ar_s3",g_user) THEN 
      LET l_chk_auth = cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)  
      RETURN 
   END IF                                            #判斷權限

   #抓取金額
   LET l_sql = " SELECT oma15,SUM(oma56t-oma57) ",
               "   FROM oma_file ",
               "  WHERE oma56t>oma57 ",
               "    AND omaconf='Y' ",
               "    AND oma00 LIKE '1%' ",
               "    AND ",cl_tp_tochar('oma02','YYYYMM')," = '",p_ym,"' " 
               
   IF NOT cl_null(p_oma08) THEN 
      LET l_sql = l_sql CLIPPED, "AND oma08= '",p_oma08 CLIPPED,"'"
   END IF
   IF NOT cl_null(p_tranclass) THEN 
      LET l_sql = l_sql CLIPPED, "AND oma13 = '",p_tranclass CLIPPED,"'"
   END IF
   IF NOT cl_null(p_custno) THEN 
      LET l_sql = l_sql CLIPPED, "AND oma68 = '",p_custno CLIPPED,"'"
   END IF
   LET l_sql = l_sql CLIPPED," GROUP BY oma15 "
   PREPARE sel_oma_pre FROM l_sql
   DECLARE sel_oma_cs CURSOR FOR sel_oma_pre
   FOREACH sel_oma_cs INTO l_oma15,ar_s3
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(ar_s3) THEN 
         LET ar_s3 = 0  
      END IF
   #帳款部門應收帳款比例
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_oma15
   LET l_str1 = l_oma15 CLIPPED,"(",l_gem02 CLIPPED,")"  #部門編號(部門名稱)
   CALL cl_chart_array_data(p_loc,"dataset",l_str1,ar_s3)
   INITIALIZE l_oma15,ar_s3 TO NULL
   END FOREACH
   
   INITIALIZE l_substr TO NULL
   LET l_substr = TODAY USING 'YYYYMM'
   LET l_substr = cl_getmsg('azz1133',g_lang),":",p_ym   #年月
   IF NOT cl_null( p_tranclass ) THEN                     #帳款類別
      SELECT oma00 INTO l_oma00 FROM oma_file WHERE oma01 = p_tranclass 
      LET l_substr = l_substr CLIPPED, " / ",  cl_getmsg('azz1127',g_lang),"：",p_tranclass CLIPPED, "(", l_oma00 , ")"
   END IF
   IF NOT cl_null( p_oma08 ) THEN                     #內銷/外銷
      SELECT oma08 INTO l_oma08 FROM oma_file WHERE oma01 = p_oma08 
      CASE p_oma08
         WHEN '1' LET l_oma08_str = cl_getmsg('aws-023',g_lang)  #內銷
         WHEN '2' LET l_oma08_str = cl_getmsg('aws-024',g_lang)  #外銷
         WHEN '3' LET l_oma08_str = cl_getmsg('aws-025',g_lang)  #視同外銷
      END CASE
      LET l_substr = l_substr CLIPPED, " / ",  cl_getmsg('azz-196',g_lang),"：", p_oma08 CLIPPED,"(",l_oma08_str,")" 
   END IF
   IF NOT cl_null( p_custno ) THEN                     #收款客戶
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = p_custno
      LET l_substr = l_substr CLIPPED, " / ", cl_getmsg('azz1126',g_lang) ,"：", p_custno CLIPPED,"(",l_occ02,")"
   END IF
   IF NOT cl_null(l_substr) THEN
   CALL cl_chart_attr(p_loc,"subcaption",l_substr)    #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_ar_s3")
   CALL cl_chart_clear(p_loc) #清除p_loc相關變數資料(釋放記憶體)
   
END FUNCTION

#FUN-BA0095
