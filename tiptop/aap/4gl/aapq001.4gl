# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aapq001.4gl
# Descriptions...: 暂估未冲料件明细查询
# Date & Author..: 10/12/23 By Elva No.FUN-AC0064
# Modify.........: No.MOD-BC0232 By elva sql错误           
# Modify.........: No.TQC-BB0107 By yinhy 增加匯出excel功能
# Modify.........: No.TQC-C20510 By yinhy 重新過單
# Modify.........: No.TQC-C30326 12/03/29 By zhangll 修改l_sum定义
# Modify.........: No.MOD-C40001 By yinhy 只顯示審核碼為Y的單據
# Modify.........: No.MOD-C50192 By Polly 排除apb21是null的條件

DATABASE ds

GLOBALS "../../config/top.global"


DEFINE g_apa   DYNAMIC ARRAY OF RECORD
                  apa06      LIKE apa_file.apa06,
                  apa07      LIKE apa_file.apa07,
                  apa02      LIKE apa_file.apa02,
                  apb21      LIKE apb_file.apb21,
                  apa01      LIKE apa_file.apa01,
                  apb12      LIKE apb_file.apb12,
                  apb27      LIKE apb_file.apb27,
                  apb09      LIKE apb_file.apb09,
                  apb23      LIKE apb_file.apb23,
                  apb24      LIKE apb_file.apb24,
                  apb08      LIKE apb_file.apb08,
                  apb10      LIKE apb_file.apb10
               END RECORD,
       g_apa_t RECORD
                  apa06      LIKE apa_file.apa06,
                  apa07      LIKE apa_file.apa07,
                  apa02      LIKE apa_file.apa02,
                  apb21      LIKE apb_file.apb21,
                  apa01      LIKE apa_file.apa01,
                  apb12      LIKE apb_file.apb12,
                  apb27      LIKE apb_file.apb27,
                  apb09      LIKE apb_file.apb09,
                  apb23      LIKE apb_file.apb23,
                  apb24      LIKE apb_file.apb24,
                  apb08      LIKE apb_file.apb08,
                  apb10      LIKE apb_file.apb10
               END RECORD,
       g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,
       g_rec_b1       LIKE type_file.num5,
       l_ac1          LIKE type_file.num5,
       l_ac1_t        LIKE type_file.num5,
       l_ac           LIKE type_file.num5
DEFINE p_row,p_col    LIKE type_file.num5
DEFINE g_msg          LIKE type_file.chr1000
DEFINE g_cnt          LIKE type_file.num10
DEFINE g_sheet        LIKE smy_file.smyslip

MAIN  #FUN-AC0064

   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 2 LET p_col = 3

   OPEN WINDOW q001_w AT p_row,p_col WITH FORM "aap/42f/aapq001"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()


   CALL q001_menu()

   CLOSE WINDOW q001_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN

FUNCTION q001_menu()

   WHILE TRUE
      CALL q001_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q001_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #No.TQC-BB0107  --Begin  #TQC-C20510
         WHEN "exporttoexcel"
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_apa),'','')
         #No.TQC-BB0107  --End
      END CASE
   END WHILE

END FUNCTION

FUNCTION q001_q()

   CALL q001_b_askkey()

END FUNCTION

FUNCTION q001_b_askkey()
   CLEAR FORM

   CALL g_apa.clear()

   CONSTRUCT g_wc2 ON apa06,apa02,apb21,apa01,apb12
                 FROM s_apa[1].apa06,s_apa[1].apa02,s_apa[1].apb21,
                      s_apa[1].apa01,s_apa[1].apb12

         BEFORE CONSTRUCT
             CALL cl_qbe_init()
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(apa06)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa06
            WHEN INFIELD(apb21)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_rvu01_2"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apb21
            WHEN INFIELD(apa01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_apa01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apa01
            WHEN INFIELD(apb12)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ima01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apb12
            OTHERWISE EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_select
         CALL cl_qbe_select()

   END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

   CALL q001_b1_fill(g_wc2)

END FUNCTION

FUNCTION q001_b1_fill(p_wc2)
   DEFINE p_wc2,l_sql     STRING
  #DEFINE l_sum   LIKE type_file.num10
   DEFINE l_sum   LIKE apb_file.apb10  #TQC-C30326 add
   DEFINE l_sum1   LIKE apb_file.apb24  #TQC-C30326 add
   #MOD-BC0232 --begin
   DEFINE l_apb09 LIKE apb_file.apb09
   DEFINE l_apb21 LIKE apb_file.apb21
   DEFINE l_apb22 LIKE apb_file.apb22

   DROP TABLE aa
   DROP TABLE bb
   LET g_sql = " SELECT apa00,apa01 ,apa02,apa06 ,apa07 ,apb21 ,apb22 ,apb12 , ",   #add by hehw 210312 apa00
               "        apb27 ,apb23,apb08 ,apb28 , ",
               "        case when apa00='26' then -1*apb09 else apb09 end apb09, ", 
               "        case when apa00='26' then -1*apb10 else apb10 end apb10, ",
               "        case when apa00='26' then -1*apb24 else apb24 end apb24  ",
               "   FROM apb_file,apa_file  ",
               "  WHERE (apa00='16' or apa00='26') ",
               "    AND ", g_wc2,
               "    AND apa01 NOT LIKE '%P87%' ",   #add by hehw 210310
               "    AND apa01 NOT LIKE '%P86%' ",   #add by hehw 210310
               "    AND apa01=apb01 ", 
               "    AND apa41='Y' ",               #MOD-C40001
               "    AND apb21 IS NOT NULL ",       #MOD-C50192 add
               " INTO TEMP aa "      
   PREPARE q001_precount_aa  FROM g_sql
   EXECUTE q001_precount_aa
   IF SQLCA.SQLERRD[3] = 0 THEN
      RETURN
   END IF
   #SELECT apa00,SUM(apb_file.apb09) apb09a,SUM(apb_file.apb10) apb10a,SUM(apb_file.apb24) apb24a,apb_file.apb21 , apb_file.apb22    #mark by hehw 210312
    SELECT apa_file.apa00,SUM(apb_file.apb09) apb09a,SUM(apb_file.apb10) apb10a,SUM(apb_file.apb24) apb24a,apb_file.apb21 , apb_file.apb22    #add by hehw 210312
     FROM apb_file,apa_file,aa  
    #WHERE (apa00='11' or apa00='21') AND apa_file.apa01=apb_file.apb01    #mark by hehw 210312
     WHERE (apa_file.apa00='11' or apa_file.apa00='21') AND apa_file.apa01=apb_file.apb01    #add by hehw 210312
      AND apb34='Y' 
      AND aa.apb21=apb_file.apb21 and aa.apb22=apb_file.apb22 
      # AND apa_file.apa41 = 'Y' #darcy:2022/05/07 add 排除未审核项 #darcy:2022/05/07 还原
    #GROUP BY apa00,apb_file.apb21,apb_file.apb22   #mark by hehw 210312
     GROUP BY apa_file.apa00,apb_file.apb21,apb_file.apb22   #add by hehw 210312
     INTO TEMP bb
   UPDATE bb SET apb09a=-apb09a,apb10a=-apb10a,apb24a=-apb24a
    WHERE apa00='21'
   {DECLARE bb_curs CURSOR FOR SELECT apb09a,apb21,apb22 FROM bb
   FOREACH bb_curs INTO l_apb09,l_apb21,l_apb22
      UPDATE aa SET apb09=apb09-l_apb09
       WHERE apb21=l_apb21 AND apb22=l_apb22
   END FOREACH}#mark by liyjf181228
   #add by liyjf181226 str
    LET l_sql= " MERGE INTO aa o ",
               #"      USING (SELECT apb09a,apb21,apb22 FROM bb ) x ",   #mark by hehw 210308
                "      USING (SELECT apb09a,apb10a,apb21,apb22,apb24a FROM bb ) x ",   #add by hehw 210308
               "         ON (o.apb21=x.apb21 AND o.apb22=x.apb22) ",   
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.apb09=o.apb09-x.apb09a "    
              ,"          ,o.apb10=o.apb10-x.apb10a "   #add by hehw 210308
              ,"          ,o.apb24=o.apb24-x.apb24a "   #add by hehw 210308
     PREPARE q021_pre2 FROM l_sql
     EXECUTE q021_pre2  
  #add by liyjf181226 end
   LET g_sql = " select  apa06 ,apa07,apa02,aa.apb21,apa01,apb12,apb27,aa.apb09, ", 
               #"        apb23,aa.apb09*apb23,  ",     #mark by hehw 210308
               #"        apb08,aa.apb09*apb08  ",     #mark by hehw 210308
               "         apb23,aa.apb24,       ",     #add by hehw 210308
               "         apb08,aa.apb10        ",     #add by hehw 210308
               "   FROM aa  ",
              # "  WHERE aa.apb09<>0 "   #mark by guanyao160912
               #"   WHERE aa.apb09*apb08<>0" #add by guanyao160913      #mark by hehw 210308
               "   WHERE aa.apb12 = 'MISC' AND aa.apa00 = '26' AND aa.apb10 <> 0 ",    #add by hehw 210308
               #add by hehw 210312 ---s
               " UNION ALL ",
               " select apa06 ,apa07,apa02,aa.apb21,apa01,apb12,apb27,aa.apb09, ", 
               "        apb23,aa.apb09*apb23,  ",
               "        apb08,aa.apb09*apb08  ", 
               "   FROM aa  ",
              # "  WHERE aa.apb09<>0 "   #mark by guanyao160912
               "   WHERE aa.apb09*apb08<>0", #add by guanyao160913 
               "   AND (aa.apa00 <> '26' OR aa.apb12 <> 'MISC')"   #add by hehw 210312
               #add by hehw 210312 ---e   
  #LET g_sql = " select apa06 ,apa07,apa02,apb21,apa01,apb12,apb27,(aa.apb09-nvl(bb.apb09a,0)), ",
  #            "        apb08,round(((aa.apb09-nvl(bb.apb09a,0))*apb08),2)  ",
  #            "   from ",
  #            "      (select apa01 ,apa02,apa06 ,apa07 ,apb21 ,apb22 ,apb12 , ",
  #            "              apb27 ,apb08 ,apb28 , ",
  #            "              case when apa00='26' then -1*apb09 else apb09 end apb09, ",
  #            "              case when apa00='26' then -1*apb10 else apb10 end apb10,apb06 ",
  #            "         from apb_file,apa_file  ",
  #            "        where (apa00='16' or apa00='26') ",
  #            "          and  ",g_wc2,
  #            "          and apa01=apb01 ",
  #            "       ) aa ",      
  #            "      LEFT OUTER JOIN (  ",
  #            "       select apa01 apa01a,apa02 apa02a,apa06 apa06a,apa07 apa07a,apb21 apb21a,apb22 apb22a,apb12 apb12a, ",
  #            "              apb27 apb27a,apb08 apb08a,apb28 apb28a, ",
  #            "              case when apa00='21' then -1*nvl(apb09,0) else nvl(apb09,0) end apb09a, ",
  #            "              case when apa00='21' then -1*nvl(apb10,0) else nvl(apb10,0) end apb10a ",
  #            "         from apb_file,apa_file  ",
  #            "        where (apa00='11' or apa00='21') ",
  #            "          and  ",g_wc2,
  #            "           and apa01=apb01 ",
  #            "           and apb34='Y' ",
  #            "       )bb ",
  #            "  ON (aa.apb21=bb.apb21a and aa.apb22=bb.apb22a ",
  #            "    and  (aa.apb09-nvl(bb.apb09a,0)) <> 0) "
   #MOD-BC0232 --end

   PREPARE q001_pb1 FROM g_sql
   DECLARE apa_curs CURSOR FOR q001_pb1
  
   CALL g_apa.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"
   LET l_sum = 0
   LET l_sum1 = 0
   FOREACH apa_curs INTO g_apa[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)   #No.FUN-660167
         EXIT FOREACH
      END IF

      #MOD-BC0232 --begin
      IF cl_null(g_apa[g_cnt].apb10) THEN 
         LET g_apa[g_cnt].apb10 = 0
      END IF
      #MOD-BC0232 --end
      LET l_sum =l_sum+g_apa[g_cnt].apb10   
      LET l_sum1 =l_sum1+g_apa[g_cnt].apb24  

      LET g_cnt = g_cnt + 1 
     # IF g_cnt > g_max_rec THEN   #ly171212
     #    CALL cl_err("",9035,0)
     #    EXIT FOREACH
     # END IF
   END FOREACH

   CALL g_apa.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt 
   LET g_apa[g_rec_b1].apb10 =l_sum
   LET g_apa[g_rec_b1].apb24=l_sum1
   CALL cl_getmsg("ggl-223",g_lang) RETURNING g_msg
 #  LET g_apa[g_rec_b1].apb27 = "合计"
   LET g_apa[g_rec_b1].apb27 = g_msg
   DISPLAY g_rec_b1-1 TO FORMONLY.cnt
   LET g_cnt = 0

END FUNCTION

FUNCTION q001_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1         

   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_apa TO s_apa.* ATTRIBUTE(COUNT=g_rec_b1,KEEP CURRENT ROW)  

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         IF l_ac1 = 0 THEN
            LET l_ac1 = 1
         END IF
         CALL cl_show_fld_cont()
      

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      #No.TQC-BB0107  --Begin
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #No.TQC-BB0107  --End

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION


