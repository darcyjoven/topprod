# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_ap_s5.4gl
# Descriptions...: 帳款部門應收帳款比例
# Date & Author..: No.FUN-BA0095 2011/11/22 By linlin
# Input Parameter: p_loc        圖表位置
#                  p_ym         年月
#                  p_tranclass  帳款類別
#                  p_deptno     請款部門
#                  p_empno      請款人員
#                  p_payment    付款方式
# Usage..........: CALL s_chart_ap_s5(p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_ap_s5(p_ym, p_tranclass, p_deptno, p_empno,p_payment,p_loc)
DEFINE p_loc                  LIKE type_file.chr10
DEFINE ap_s5                  LIKE apa_file.apa31  #帳款金額
DEFINE ap_s6                  LIKE apa_file.apa31f #已沖金額
DEFINE p_ym                   LIKE type_file.chr6  #年月
DEFINE p_tranclass            LIKE apa_file.apa36  #請款類別
DEFINE p_deptno               LIKE apa_file.apa22  #付款部門
DEFINE p_empno                LIKE apa_file.apa21  #請款人員
DEFINE p_payment              LIKE pma_file.pma01  #付款方式
DEFINE l_sql                  STRING
DEFINE l_str1                 STRING
DEFINE l_str2                 STRING
DEFINE l_str3                 STRING
DEFINE l_substr               STRING               #子標題
DEFINE l_pma02                LIKE pma_file.pma02  #廠商簡稱
DEFINE l_gen02                LIKE gen_file.gen02  #员工姓名
DEFINE l_gem02                LIKE gem_file.gem02  #部門名稱
DEFINE l_pmc03                LIKE pmc_file.pmc03  #厂商名稱
DEFINE l_apa06                LIKE apa_file.apa06  #付款厂商编号
DEFINE l_apr02                LIKE apr_file.apr02  #請款類別
DEFINE l_chk_auth             STRING

   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc) #初始WebComponent的資料

   IF NOT s_chart_auth("s_chart_ap_s5",g_user) THEN
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN
   END IF #判斷權限


   #抓取金額
   LET l_sql = " SELECT apa06,SUM(apa34),SUM(apa35) ",
               "   FROM apa_file ",
               "   LEFT OUTER JOIN pma_file ON pma01 = apa11 ",
               "  WHERE apa34>apa35 ",
               "    AND apa41= 'Y' ",
               "    AND ",cl_tp_tochar('apa02','YYYYMM')," = '",p_ym,"' "
               
   IF NOT cl_null(p_payment ) THEN 
      LET l_sql = l_sql CLIPPED, "AND pma11 = '",p_payment  CLIPPED,"'"
   END IF
      IF NOT cl_null(p_empno) THEN 
      LET l_sql = l_sql CLIPPED, "AND apa21 = '",p_empno CLIPPED,"'"
   END IF
   IF NOT cl_null(p_deptno) THEN 
      LET l_sql = l_sql CLIPPED, "AND apa22 = '",p_deptno  CLIPPED,"'"
   END IF
   IF NOT cl_null(p_tranclass ) THEN 
      LET l_sql = l_sql CLIPPED, "AND apa36 = '",p_tranclass  CLIPPED,"'"
   END IF
   LET l_sql = l_sql CLIPPED," GROUP BY apa06 "
   PREPARE sel_apa_pre FROM l_sql
   DECLARE sel_apa_cs CURSOR FOR sel_apa_pre
   FOREACH sel_apa_cs INTO l_apa06,ap_s5,ap_s6 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(ap_s5) THEN 
         LET ap_s5 = 0  
      END IF
      IF cl_null(ap_s6) THEN 
         LET ap_s6 = 0  
      END IF
   #付款廠商應付帳款狀況
   SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = l_apa06
   LET l_str1 = l_apa06 CLIPPED,"(",l_pmc03 CLIPPED,")"     #廠商編號(廠商名稱)
   LET l_str2 = cl_getmsg('axc-214',g_lang) CLIPPED                 #應付金額
   LET l_str3 = cl_getmsg('azz1124',g_lang) CLIPPED                 #已付金額
   
   CALL cl_chart_array_data( p_loc ,"categories","", l_str1)
   CALL cl_chart_array_data(p_loc,"dataset",l_str2,ap_s5)
   CALL cl_chart_array_data(p_loc,"dataset",l_str3,ap_s6)
   INITIALIZE l_apa06,ap_s5,ap_s6 TO NULL
   END FOREACH
   
   INITIALIZE l_substr TO NULL
   LET l_substr = TODAY USING 'YYYYMM'
   LET l_substr = cl_getmsg('azz1133',g_lang),":",p_ym    #年月
   IF NOT cl_null( p_tranclass ) THEN                     #帳款類別
     SELECT apr02 INTO l_apr02 FROM apr_file WHERE apr01 = p_tranclass 
      LET l_substr = l_substr CLIPPED, " / ",  cl_getmsg('azz1127',g_lang),"：",p_tranclass CLIPPED, "(", l_apr02 , ")"
   END IF  
     IF NOT cl_null( p_deptno ) THEN                      #收款部門
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = p_deptno
      LET l_substr = l_substr CLIPPED, " / ", cl_getmsg('azz1134',g_lang),"：",p_deptno CLIPPED, "(", l_gem02 , ")"
   END IF
   IF NOT cl_null( p_empno ) THEN                     #收款人員
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = p_empno
      LET l_substr = l_substr CLIPPED, " / ",cl_getmsg('azz1128',g_lang) , "：", p_empno CLIPPED,"(",l_gen02,")"
   END IF
   IF NOT cl_null( p_payment ) THEN                       #付款方式
      SELECT pma02 INTO l_pma02 FROM pma_file WHERE pma01 = p_payment
      LET l_substr = l_substr CLIPPED, " / ", cl_getmsg('azz1129',g_lang) ,"：", p_payment CLIPPED,"(",l_pma02,")"
   END IF
   IF NOT cl_null(l_substr) THEN
   CALL cl_chart_attr(p_loc,"subcaption",l_substr)    #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_ap_s5")
   CALL cl_chart_clear(p_loc) #清除p_loc相關變數資料(釋放記憶體)
   
END FUNCTION

#FUN-BA0095
