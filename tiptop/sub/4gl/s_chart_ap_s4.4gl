# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_chart_ap_s4.4gl
# Descriptions...: 帳款部門應收帳款比例
# Date & Author..: No.FUN-BA0095 2011/11/22 By linlin
# Input Parameter: p_loc        圖表位置
#                  p_ym         年月
#                  p_tranclass  帳款類別
#                  p_deptno     請款部門
#                  p_empno      請款人員
#                  p_vendno     付款廠商
# Usage..........: CALL s_chart_ap_s4(p_loc)
# Modify.........: 

DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION s_chart_ap_s4(p_ym, p_tranclass, p_deptno, p_empno,p_vendno,p_loc)
DEFINE p_loc                  LIKE type_file.chr10
DEFINE ap_s4                  LIKE apa_file.apa31  #帳款金額
DEFINE p_ym                   LIKE type_file.chr6  #年月
DEFINE p_tranclass            LIKE apa_file.apa36  #請款類別
DEFINE p_deptno               LIKE apa_file.apa22  #付款部門
DEFINE p_empno                LIKE apa_file.apa21  #請款人員
DEFINE p_vendno               LIKE apa_file.apa06  #付款廠商
DEFINE l_sql                  STRING
DEFINE l_str1                 STRING
DEFINE l_substr               STRING               #子標題
DEFINE l_pmc03                LIKE pmc_file.pmc03  #厂商名稱
DEFINE l_gen02                LIKE gen_file.gen02  #员工姓名
DEFINE l_gem02                LIKE gem_file.gem02  #部門名稱
DEFINE l_pma02                LIKE pma_file.pma02  #付款方式说明
DEFINE l_pma11                LIKE pma_file.pma11  #类别 
DEFINE l_apr02                LIKE apr_file.apr02  #請款類別
DEFINE l_chk_auth             STRING

   WHENEVER ERROR CONTINUE
   CALL cl_chart_init(p_loc) #初始WebComponent的資料

   IF NOT s_chart_auth("s_chart_ap_s4",g_user) THEN
      LET l_chk_auth=cl_getmsg('azz1135',g_lang) CLIPPED
      CALL cl_chart_set_empty(p_loc, l_chk_auth)
      RETURN
   END IF #判斷權限


   #抓取金額
   LET l_sql = " SELECT pma11,SUM(apa34-apa35) ",
               "   FROM apa_file ",
               "   LEFT OUTER JOIN pma_file ON pma01 = apa11 ",
               "  WHERE apa34>apa35 ",
               "    AND apa41= 'Y' ",
               "    AND ",cl_tp_tochar('apa02','YYYYMM')," = '",p_ym,"' "
               
   IF NOT cl_null(p_vendno) THEN 
      LET l_sql = l_sql CLIPPED, "AND apa06= '",p_vendno CLIPPED,"'"
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
   LET l_sql = l_sql CLIPPED," GROUP BY pma11 "
   PREPARE sel_apa_pre FROM l_sql
   DECLARE sel_apa_cs CURSOR FOR sel_apa_pre
   FOREACH sel_apa_cs INTO l_pma11,ap_s4
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF cl_null(ap_s4) THEN 
         LET ap_s4 = 0  
      END IF
   #各付款方式應付帳款比例
   SELECT pma02 INTO l_pma02 FROM pma_file WHERE pma01 = l_pma11
   LET l_str1 = l_pma11 CLIPPED,"(",l_pma02 CLIPPED,")"     #付款方式(付款方式說明)
   CALL cl_chart_array_data(p_loc,"dataset",l_str1,ap_s4)
   INITIALIZE l_pma11,ap_s4 TO NULL
   END FOREACH
   
   INITIALIZE l_substr TO NULL
   LET l_substr = TODAY USING 'YYYYMM'
   LET l_substr = cl_getmsg('azz1133',g_lang),":",p_ym    #年月
   IF NOT cl_null( p_tranclass ) THEN                     #帳款類別
      SELECT apr02 INTO l_apr02 FROM apr_file WHERE apr01 = p_tranclass 
      LET l_substr = l_substr CLIPPED, " / ",  cl_getmsg('azz1127',g_lang),"：",p_tranclass CLIPPED, "(", l_apr02 , ")"
   END IF   
   IF NOT cl_null( p_deptno ) THEN                        #收款部門
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = p_deptno
      LET l_substr = l_substr CLIPPED, " / ", cl_getmsg('azz1134',g_lang),"：",p_deptno CLIPPED, "(", l_gem02 , ")"
   END IF
   IF NOT cl_null( p_empno ) THEN                         #收款人員
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = p_empno
      LET l_substr = l_substr CLIPPED, " / ",cl_getmsg('azz1128',g_lang) , "：", p_empno CLIPPED,"(",l_gen02,")"
   END IF
   IF NOT cl_null( p_vendno ) THEN                        #付款廠商
      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = p_vendno
      LET l_substr = l_substr CLIPPED, " / ", cl_getmsg('azz1129',g_lang) ,"：", p_vendno CLIPPED,"(",l_pmc03,")"
   END IF
   IF NOT cl_null(l_substr) THEN
   CALL cl_chart_attr(p_loc,"subcaption",l_substr)    #設定子標題
   END IF
   CALL cl_chart_create(p_loc,"s_chart_ap_s4")
   CALL cl_chart_clear(p_loc) #清除p_loc相關變數資料(釋放記憶體)
   
END FUNCTION

#FUN-BA0095
