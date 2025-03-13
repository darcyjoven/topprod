# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apsp850.4gl
# Descriptions...: APS規劃結果鎖定設備/鎖定設備時間自動更新
# Date & Author..: No.FUN-960127 09/07/29 By Duke
# Modify.........: No:TQC-A10163 10/01/26 By Mandy SQL調整,因為=>資料重覆出現,EX:28-1102-A / 01 建議狀態"B:已報工不調整"
# Modify.........: No:FUN-A70038 10/08/10 By Mandy (1)鎖定設備當異動碼建議為新增時(von11='1'),若ERP資料已存在,則作update動作
#                                                  (2)鎖定時間異動碼建議為新增時(vom14='1'),若ERP資料已存在,則作update動作
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版:以下為GP5.25的單號---str---
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版----------------------end---

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE g_up         LIKE type_file.chr1         #FUN-960127
DEFINE g_vzu01      LIKE vzu_file.vzu01
DEFINE g_vzu02      LIKE vzu_file.vzu02
DEFINE g_adjust     LIKE type_file.chr1
DEFINE
    g_von_a         DYNAMIC ARRAY OF RECORD
                    von10     LIKE von_file.von10,
                    von11     LIKE von_file.von11,
                    von03     LIKE von_file.von03,
                    von04     LIKE von_file.von04,
                    von05     LIKE von_file.von05,
                    von06     LIKE von_file.von06,
                    von07     LIKE von_file.von07,
                    von08     LIKE von_file.von08,
                    von09     LIKE von_file.von09,
                    datakind  LIKE type_file.chr1
                    END RECORD,
    g_von_b         DYNAMIC ARRAY OF RECORD
                    vom13     LIKE vom_file.vom13,
                    vom14     LIKE vom_file.vom14,
                    vom03     LIKE vom_file.vom03,
                    vom04     LIKE vom_file.vom04,
                    vom05     LIKE vom_file.vom05,
                    vom06     LIKE vom_file.vom06, 
                    vom07     LIKE vom_file.vom07,
                    vom08     LIKE vom_file.vom08,
                    vom09     DATETIME YEAR TO MINUTE,
                    vom10     DATETIME YEAR TO MINUTE,
                    vom11     LIKE vom_file.vom11,
                    vom12     LIKE vom_file.vom12
                    END RECORD,
    g_plant_1       DYNAMIC ARRAY OF RECORD
                    no        LIKE azp_file.azp01,
                    db_name   LIKE azp_file.azp03
                    END RECORD,
    g_wc1           STRING,
    g_oga99_wc      STRING,
    g_rec_b1        LIKE type_file.num5,          #單身筆數        
    g_rec_b2        LIKE type_file.num5,          #單身筆數        
    g_sql           STRING,
    l_ac,l_ac_t     LIKE type_file.num5,          
    p_row,p_col     LIKE type_file.num5           

MAIN  
#FUN-B50022---mod---str---
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT	 
#FUN-B50022---mod---end---

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 

   IF (NOT cl_setup("APS")) THEN   
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間)  

   #顯示畫面
   LET p_row = 3 LET p_col = 2
   OPEN WINDOW p850_w AT p_row,p_col WITH FORM "aps/42f/apsp850"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible('datakind',FALSE)

   CALL p850_menu()
   CLOSE WINDOW p850_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #計算使用時間 (退出使間)   
END MAIN

#QBE 查詢資料
FUNCTION p850_cs()
   CLEAR FORM                             #清除畫面
  #LET g_vzu01 = NULL
  #LET g_vzu02 = NULL
   LET g_adjust = 'A'
   INPUT g_vzu01,g_vzu02,g_adjust WITHOUT DEFAULTS FROM vzu01,vzu02,adjust

     AFTER INPUT
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              RETURN      
           END IF
     ON ACTION controlp
        CASE
           WHEN INFIELD(vzu01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_vlz01"
              CALL cl_create_qry() RETURNING g_vzu01,g_vzu02
              DISPLAY BY NAME g_vzu01,g_vzu02
              NEXT FIELD vzu01

           OTHERWISE
              EXIT CASE
           END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
   END INPUT
  CALL g_von_a.clear()
  CALL g_von_b.clear()
 #CONSTRUCT g_wc1 ON von10,von11,von03,von04,von05,von06,von07,von08,von09
 #              FROM s_von_a[1].von10,s_von_a[1].von11,s_von_a[1].von03,
 #                   s_von_a[1].von04,s_von_a[1].von05,s_von_a[1].von06,
 #                   s_von_a[1].von07,s_von_a[1].von08,s_von_a[1].von09

 #      ON IDLE g_idle_seconds
 #         CALL cl_on_idle()
 #         CONTINUE CONSTRUCT

 #      ON ACTION about
 #         CALL cl_about()

 #      ON ACTION help
 #         CALL cl_show_help()

 #      ON ACTION controlg
 #         CALL cl_cmdask()
 
 #END CONSTRUCT

  IF INT_FLAG THEN
     RETURN
  END IF

END FUNCTION

FUNCTION p850_menu()
   WHILE TRUE
      CALL p850_bp()
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p850_q()
            END IF
    
         WHEN "batch_adjust"
            IF cl_chk_act_auth() THEN
               IF g_rec_b1 = 0 THEN
                  #無單身資料可啟動
                  CALL cl_err('','aps-702',1)
               ELSE
                  IF g_adjust='A' THEN
                      BEGIN WORK
                      LET g_success = 'Y'
                      CALL p850_btadjust()
                      IF g_success = 'Y' THEN
                          COMMIT WORK
                          CALL cl_err('','lib-022',1)  #異動更新完成!
                          CALL p850_b1_fill(" 1=1")
                      ELSE
                          ROLLBACK WORK
                          IF cl_null(g_errno) THEN
                              LET g_errno = 'lib-028' #異動更新不成功
                          END IF
                          CALL cl_err('',g_errno,1)
                      END IF
                  ELSE
                      CALL cl_err('','aps-774',1)
                  END IF
               END IF
         END IF

         WHEN "view1"
              CALL p850_bp2()

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()
            LET g_up = 'R'

      END CASE
   END WHILE
END FUNCTION

#Query 查詢
FUNCTION p850_q()
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_von_a.clear()
    CALL g_von_b.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    DISPLAY '   ' TO FORMONLY.cn2
    CALL p850_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL p850_b1_fill(g_wc1)
 
    LET l_ac = 1
END FUNCTION


FUNCTION p850_b1_fill(p_wc1)
DEFINE  p_wc1        STRING
DEFINE  l_last       LIKE poy_file.poy02,
        l_last_plant LIKE poy_file.poy04

    IF cl_null(p_wc1) THEN
       LET p_wc1 = ' 1=1'
    END IF

    IF g_adjust ='A' THEN
      #LET g_sql = "SELECT UNIQUE von10,von11,von03,von04,von05,von06,von07,von08,von09,'1' ", #TQC-A10163 mark
       LET g_sql = "SELECT UNIQUE von10,von11,von03,von04,von05,von06,von07,von08,von09,'A' ", #TQC-A10163 add
                   "  FROM von_file,ecm_file ",
                   " WHERE ",p_wc1 CLIPPED,
                   "   AND von00 = '",g_plant,"'", 
                   "   AND von01 = '",g_vzu01,"'",
                   "   AND von02 = '",g_vzu02,"'",
                   "   AND von03 = ecm01 ",
                   "   AND von04 = ecm01 ",
                   "   AND to_number(von05) = ecm03 ",
                   "   AND von06 = ecm04 ",
                   "   AND von11 in ('1','2','3') ",
                   "   AND (ecm311+ecm312+ecm313+ecm314+ecm315+ecm316) = 0 ",
                   " UNION ", #********* 
                  #" SELECT UNIQUE von10,von11,von03,von04,von05,von06,von07,von08,von09,'2' ", #TQC-A10163 mark
                   " SELECT UNIQUE von10,von11,von03,von04,von05,von06,von07,von08,von09,'A' ", #TQC-A10163 add
                   "  FROM von_file,ecm_file, ",
                   "  (SELECT vne01,vne02,vne03,COUNT(*) vneqty ",
                   "     FROM vne_file ",
                   "    GROUP BY vne01,vne02,vne03 ",
                   "   HAVING COUNT(*) = 1) vne_tmp, ",
                   "  (SELECT von00 von00s,von01 von01s,von02 von02s,von03 von03s,von04 von04s,von05 von05s,COUNT(*) vonqty ",
                   "     FROM von_file ",
                   "    GROUP BY von00,von01,von02,von03,von04,von05 ",
                   "   HAVING COUNT(*) = 1) von_tmp",  
                   " WHERE ",p_wc1 CLIPPED,
                   "   AND von00 = '",g_plant,"'", 
                   "   AND von01 = '",g_vzu01,"'",
                   "   AND von02 = '",g_vzu02,"'",
                   "   AND von03 = ecm01 ",
                   "   AND von04 = ecm01 ",
                   "   AND to_number(von05) = ecm03 ",
                   "   AND von06 = ecm04 ",
                   "   AND von11 in ('3') ", #修改
                   "   AND (ecm311+ecm312+ecm313+ecm314+ecm315+ecm316) >0 ",
                   "   AND von00 = von_tmp.von00s ",
                   "   AND von01 = von_tmp.von01s ",
                   "   AND von02 = von_tmp.von02s ",
                   "   AND von03 = von_tmp.von03s ",
                   "   AND von04 = von_tmp.von04s ",
                   "   AND von05 = von_tmp.von05s ",
                   "   AND von03 = vne_tmp.vne01  ",
                   "   AND von04 = vne_tmp.vne02  ",
                   "   AND to_number(von05) = vne_tmp.vne03 ",
                   " UNION ", #********* 
                  #"SELECT UNIQUE von10,von11,von03,von04,von05,von06,von07,von08,von09,'3' ", #TQC-A10163 mark
                   "SELECT UNIQUE von10,von11,von03,von04,von05,von06,von07,von08,von09,'A' ", #TQC-A10163 add
                   "  FROM von_file,ecm_file,vom_file ",
                   " WHERE ",p_wc1 CLIPPED,
                   "   AND von00 = '",g_plant,"'", 
                   "   AND von01 = '",g_vzu01,"'",
                   "   AND von02 = '",g_vzu02,"'",
                   "   AND von03 = ecm01 ",
                   "   AND von04 = ecm01 ",
                   "   AND to_number(von05) = ecm03 ",
                   "   AND von06 = ecm04 ",
                   "   AND von00 = vom00 ",
                   "   AND von01 = vom01 ",
                   "   AND von02 = vom02 ",
                   "   AND von04 = vom04 ",
                   "   AND von05 = vom05 ",
                   "   AND von06 = vom06 ",
                   "   AND von07 = vom07 ",
                   "   AND von11 in ('0') ",
                   "   AND vom14 in ('1','2','3') ", 
                   " ORDER BY von10, von11 "
    END IF 
    IF g_adjust ='B' THEN
       LET g_sql = "SELECT UNIQUE von10,von11,von03,von04,von05,von06,von07,von08,von09,'B' ", 
                   "  FROM von_file,ecm_file, ",
                   "  (SELECT von00 von00s,von01 von01s,von02 von02s,von03 von03s,von04 von04s,von05 von05s,COUNT(*) vonqty ",
                   "     FROM von_file GROUP BY von00,von01,von02,von03,von04,von05 HAVING COUNT(*) >= 2) von_tmp ",  
                   " WHERE ",p_wc1 CLIPPED,
                   "   AND von00 = '",g_plant,"'", 
                   "   AND von01 = '",g_vzu01,"'",
                   "   AND von02 = '",g_vzu02,"'",
                   "   AND von03 = ecm01 ",
                   "   AND von04 = ecm01 ",
                   "   AND to_number(von05) = ecm03 ",
                   "   AND von06 = ecm04 ",
                   "   AND (ecm311+ecm312+ecm313+ecm314+ecm315+ecm316) >0 ",
                   "   AND von00 = von_tmp.von00s ",
                   "   AND von01 = von_tmp.von01s ",
                   "   AND von02 = von_tmp.von02s ",
                   "   AND von03 = von_tmp.von03s ",
                   "   AND von04 = von_tmp.von04s ",
                   "   AND von05 = von_tmp.von05s ",
                   " UNION ", #********* 
                  #"SELECT UNIQUE von10,von11,von03,von04,von05,von06,von07,von08,von09,'b' ", #TQC-A10163 mark
                   "SELECT UNIQUE von10,von11,von03,von04,von05,von06,von07,von08,von09,'B' ", #TQC-A10163 add
                   "  FROM von_file,ecm_file, ",
                   "  (SELECT vne01,vne02,vne03,COUNT(*) vneqty FROM vne_file GROUP BY vne01,vne02,vne03 HAVING COUNT(*) >= 2) vne_tmp ",
                   " WHERE ",p_wc1 CLIPPED,
                   "   AND von00 = '",g_plant,"'", 
                   "   AND von01 = '",g_vzu01,"'",
                   "   AND von02 = '",g_vzu02,"'",
                   "   AND von03 = ecm01 ",
                   "   AND von04 = ecm01 ",
                   "   AND to_number(von05) = ecm03 ",
                   "   AND von06 = ecm04 ",
                   "   AND (ecm311+ecm312+ecm313+ecm314+ecm315+ecm316) >0 ",
                   "   AND ecm01 = vne_tmp.vne01 ",
                   "   AND ecm01 = vne_tmp.vne02 ",
                   "   AND ecm03 = vne_tmp.vne03 ",
                   " ORDER BY von10, von11 "
    END IF
    PREPARE p850_pre1 FROM g_sql
    DECLARE p850_cs1 CURSOR FOR p850_pre1

    CALL g_von_a.clear()
    LET g_rec_b1 = 1
    DISPLAY ' ' TO FORMONLY.cnt

    FOREACH p850_cs1 INTO g_von_a[g_rec_b1].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
           CALL cl_err('b1_fill foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF

        LET g_rec_b1 = g_rec_b1 + 1
        IF g_rec_b1 > g_max_rec THEN
           CALL cl_err('', 9035, 0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_von_a.deleteElement(g_rec_b1)
    LET g_rec_b1 = g_rec_b1 - 1
    DISPLAY g_rec_b1 TO FORMONLY.cnt
END FUNCTION

FUNCTION p850_b2_fill()
DEFINE  l_i      LIKE type_file.num5          

    CALL g_von_b.clear()
    LET g_rec_b2 = 1
    DISPLAY ' ' TO FORMONLY.cn2


        LET g_sql = "SELECT vom13,vom14,vom03,vom04,vom05,vom06,vom07,vom08, ",  
                    "       vom09,vom10,vom11,vom12 ",
                    "  FROM von_file,vom_file ",
                    " WHERE von00 = '",g_plant,"'",
                    "   AND von01 = '",g_vzu01,"'",
                    "   AND von02 = '",g_vzu02,"'",
                    "   AND von03 = '",g_von_a[l_ac].von03,"'",
                    "   AND von04 = '",g_von_a[l_ac].von04,"'",
                    "   AND von05 = '",g_von_a[l_ac].von05,"'",
                    "   AND von06 = '",g_von_a[l_ac].von06,"'",
                    "   AND von07 = '",g_von_a[l_ac].von07,"'",
                    "   AND von00 = vom00 ",
                    "   AND von01 = vom01 ",
                    "   AND von02 = vom02 ",
                    "   AND von04 = vom04 ",
                    "   AND von05 = vom05 ",
                    "   AND von06 = vom06 ",
                    "   AND von07 = vom07 ",
                    " ORDER BY vom13,vom14"
        PREPARE p850_pre2 FROM g_sql
        DECLARE p850_cs2 CURSOR FOR p850_pre2


        IF NOT(g_rec_b2 > g_max_rec) THEN
           FOREACH p850_cs2 INTO g_von_b[g_rec_b2].*
              IF SQLCA.SQLCODE THEN
                 CALL cl_err('b2_fill foreach1:',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              LET g_rec_b2 = g_rec_b2 + 1
              IF g_rec_b2 > g_max_rec THEN
                 CALL cl_err('',9035,0)
                 EXIT FOREACH
              END IF
           END FOREACH
        END IF
    CALL g_von_b.deleteElement(g_rec_b2)
    LET g_rec_b2 = g_rec_b2 - 1
    DISPLAY g_rec_b2 TO FORMONLY.cn2

END FUNCTION


FUNCTION p850_bp()
   DEFINE   p_ud   LIKE type_file.chr1          

   IF g_up = "V" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_von_a TO s_von_a.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)

      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         #當選擇"B:已報工不調整"時,讓Action "整批調整"灰階
         IF NOT cl_null(g_adjust) AND g_adjust = 'B' THEN
             CALL cl_set_action_active("batch_adjust",FALSE)
         ELSE
             CALL cl_set_action_active("batch_adjust",TRUE)
         END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF l_ac = 0 THEN
            LET l_ac = 1
         END IF
         CALL p850_b2_fill()
         CALL p850_bp2_refresh()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 

      ON ACTION batch_adjust
         LET g_action_choice = "batch_adjust"
         EXIT DISPLAY

      ON ACTION view1
         LET g_action_choice = "view1"
         EXIT DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION p850_bp2_refresh()
   DISPLAY ARRAY g_von_b TO s_vom_b.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()
 
   END DISPLAY
END FUNCTION



FUNCTION p850_bp2()
   DEFINE   p_ud   LIKE type_file.chr1          

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_von_b TO s_vom_b.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)

      BEFORE ROW
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_up = "V"
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()

      #將focus指回單頭
      ON ACTION return
         LET g_up = "R"
         LET g_action_choice="return"
         EXIT DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#整批調整
FUNCTION p850_btadjust()
DEFINE l_ecm61 LIKE ecm_file.ecm61
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_von   RECORD LIKE von_file.*
DEFINE l_vom   RECORD LIKE vom_file.*
DEFINE l_vne03 LIKE ecm_file.ecm03
DEFINE l_vnd03 LIKE ecm_file.ecm03
DEFINE l_sfb   RECORD LIKE sfb_file.* 
DEFINE l_vom09  DATETIME YEAR TO MINUTE    
DEFINE l_vom10  DATETIME YEAR TO MINUTE

   #(1)ERP製程未報工,APS回饋回來的鎖定使用設備von_file及鎖定設備時間vom_file資料可全部直接更新
   #(2)ERP製程已報工,且ERP及APS回饋都只有單一設備,可直接更新
   #(3)APS回饋回來的鎖定設備不變,只變動鎖定設備時間

   #==>APS鎖定使用設備檔
   LET g_sql = "SELECT von_file.*,von05,'1' ",
               "  FROM von_file,ecm_file ",
               " WHERE von00 = '",g_plant,"'", 
               "   AND von01 = '",g_vzu01,"'",
               "   AND von02 = '",g_vzu02,"'",
               "   AND von03 = ecm01 ",
               "   AND von04 = ecm01 ",
               "   AND to_number(von05) = ecm03 ",
               "   AND von06 = ecm04 ",
               "   AND von11 in ('1','2','3') ",
               "   AND (ecm311+ecm312+ecm313+ecm314+ecm315+ecm316) = 0 ",
               " UNION ", #********* 
               "SELECT von_file.*,von05,'2' ",
               "  FROM von_file,ecm_file, ",
               "  (SELECT vne01,vne02,vne03,COUNT(*) vneqty ",
               "     FROM vne_file ",
               "    GROUP BY vne01,vne02,vne03 ",
               "   HAVING COUNT(*) = 1) vne_tmp, ",
               "  (SELECT von00 von00s,von01 von01s,von02 von02s,von03 von03s,von04 von04s,von05 von05s,COUNT(*) vonqty ",
               "     FROM von_file ",
               "    GROUP BY von00,von01,von02,von03,von04,von05 ",
               "   HAVING COUNT(*) = 1) von_tmp",  
               " WHERE von00 = '",g_plant,"'", 
               "   AND von01 = '",g_vzu01,"'",
               "   AND von02 = '",g_vzu02,"'",
               "   AND von03 = ecm01 ",
               "   AND von04 = ecm01 ",
               "   AND to_number(von05) = ecm03 ",
               "   AND von06 = ecm04 ",
               "   AND von11 in ('3') ", #修改
               "   AND (ecm311+ecm312+ecm313+ecm314+ecm315+ecm316) >0 ",
               "   AND von00 = von_tmp.von00s ",
               "   AND von01 = von_tmp.von01s ",
               "   AND von02 = von_tmp.von02s ",
               "   AND von03 = von_tmp.von03s ",
               "   AND von04 = von_tmp.von04s ",
               "   AND von05 = von_tmp.von05s ",
               "   AND von03 = vne_tmp.vne01  ",
               "   AND von04 = vne_tmp.vne02  ",
               "   AND to_number(von05) = vne_tmp.vne03 ",
               " UNION ", #********* 
               "SELECT von_file.*,von05,'3' ",
               "  FROM von_file,ecm_file,vom_file ",
               " WHERE von00 = '",g_plant,"'", 
               "   AND von01 = '",g_vzu01,"'",
               "   AND von02 = '",g_vzu02,"'",
               "   AND von03 = ecm01 ",
               "   AND von04 = ecm01 ",
               "   AND to_number(von05) = ecm03 ",
               "   AND von06 = ecm04 ",
               "   AND von00 = vom00 ",
               "   AND von01 = vom01 ",
               "   AND von02 = vom02 ",
               "   AND von04 = vom04 ",
               "   AND von05 = vom05 ",
               "   AND von06 = vom06 ",
               "   AND von07 = vom07 ",
               "   AND von11 in ('0') ",
               "   AND vom14 in ('1','2','3') "
   PREPARE p850_preA1 FROM g_sql
   DECLARE p850_csA1 CURSOR FOR p850_preA1
   LET l_vne03 = NULL
   INITIALIZE l_von.* TO NULL
   FOREACH p850_csA1 INTO l_von.*, l_vne03
       IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           RETURN
       END IF
       IF l_von.von10 = 1 THEN
           #已異動過,不可重覆執行
           LET g_errno = 'aps-803'
           LET g_success = 'N'
           RETURN
       END IF
       SELECT * INTO l_sfb.*
         FROM sfb_file
        WHERE sfb01 = l_von.von03
       #von11 /*異動碼 0:不變，1:新增，2:刪除，3:修改  */
       CASE l_von.von11 
            WHEN 1 #新增
                 #FUN-A70038---add------str---
                 #鎖定設備當異動碼建議為新增時(von11='1'),若ERP資料已存在,則作update動作
                 SELECT COUNT(*) INTO l_cnt 
                   FROM vne_file
                  WHERE vne01 = l_von.von03 
                    AND vne02 = l_von.von04 
                    AND vne03 = l_vne03
                    AND vne04 = l_von.von06 
                    AND vne05 = l_von.von07       
                 IF l_cnt >=1 THEN
                     UPDATE vne_file  
                        SET vne05 = l_von.von07, #資源編號
                            vne06 = l_von.von08, #末完成量
                            vne07 = l_von.von09  #是否排程
                      WHERE vne01 = l_von.von03 
                        AND vne02 = l_von.von04 
                        AND vne03 = l_vne03
                        AND vne04 = l_von.von06 
                        AND vne05 = l_von.von07       
                 ELSE
                     INSERT INTO vne_file(vne01      ,vne02      ,vne03      ,vne04      ,vne05      ,vne06      ,vne07      ,vne50      ,vne51      ,
                                          vne311     ,vne312     ,vne313     ,vne314     ,vne315     ,vne316     ,
                                          vnelegal   ,vneplant   ,vne012) #FUN-B50022 add
                                   VALUES(l_von.von03,l_von.von04,l_vne03,l_von.von06,l_von.von07,l_von.von08,l_von.von09,l_sfb.sfb13,l_sfb.sfb15,     
                                          0,0,0,0,0,0,
                                          g_legal,g_plant,l_von.von012) #FUN-B50022 add
                 END IF
            WHEN 2 #刪除
                 DELETE FROM vne_file 
                   WHERE vne01 = l_von.von03
                     AND vne02 = l_von.von04
                     AND vne03 = l_vne03
                     AND vne04 = l_von.von06 
                     AND vne05 = l_von.von07
            WHEN 3 #修改
                 UPDATE vne_file  
                    SET vne05 = l_von.von07, #資源編號
                        vne06 = l_von.von08, #末完成量
                        vne07 = l_von.von09  #是否排程
                  WHERE vne01 = l_von.von03 
                    AND vne02 = l_von.von04 
                    AND vne03 = l_vne03
                    AND vne04 = l_von.von06 
                    AND vne05 = l_von.von07       
       END CASE
       IF l_von.von11 MATCHES '[123]' THEN
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_success = 'N'
               RETURN
           END IF
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM vne_file
            WHERE vne01 = l_von.von03 
              AND vne02 = l_von.von04 
              AND vne03 = l_vne03
              AND vne04 = l_von.von06 
           IF l_cnt >=1 THEN
               LET l_ecm61 = 'Y'
           ELSE
               LET l_ecm61 = 'N'
           END IF
           UPDATE ecm_file 
              SET ecm61 = l_ecm61 #鎖定設備否
            WHERE ecm01 = l_von.von03
              AND ecm03 = l_vne03
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_success = 'N' 
               RETURN
           END IF
       END IF
       UPDATE von_file 
          SET von10 = 1 #更新否
        WHERE von00 = l_von.von00
          AND von01 = l_von.von01
          AND von02 = l_von.von02
          AND von03 = l_von.von03
          AND von04 = l_von.von04
          AND von05 = l_von.von05
          AND von06 = l_von.von06     
          AND von07 = l_von.von07
          AND von012 = l_von.von012 #FUN-B50022 add
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           LET g_success = 'N'
           RETURN
       END IF
      
       #==>鎖定設備時間vom_file
       LET g_sql = " SELECT vom00, ",
                   "        vom01,vom02,vom03,vom04,vom05, ",
                   "        vom06,vom07,vom08,vom09,vom10, ",
                   "        vom11,vom12,vom13,vom14,vom05 ",
                   "   FROM vom_file ",
                   " WHERE vom00 = '",g_plant,"'", 
                   "   AND vom01 = '",g_vzu01,"'",
                   "   AND vom02 = '",g_vzu02,"'",
                   "   AND vom03 = '",l_von.von03,"'",
                   "   AND vom04 = '",l_von.von04,"'",
                   "   AND vom05 = '",l_von.von05,"'",
                   "   AND vom06 = '",l_von.von06,"'",
                   "   AND vom07 = '",l_von.von07,"'",
                   "   AND vom012= '",l_von.von012,"'", #FUN-B50022 add
                   "   AND vom14 IN ('1','2','3') "
       PREPARE p850_preA11 FROM g_sql
       DECLARE p850_csA11 CURSOR FOR p850_preA11
       LET l_vnd03 = NULL
       INITIALIZE l_vom.* TO NULL
       FOREACH p850_csA11 
          INTO l_vom.vom00,
               l_vom.vom01,l_vom.vom02,l_vom.vom03,l_vom.vom04,l_vom.vom05,
               l_vom.vom06,l_vom.vom07,l_vom.vom08,l_vom09    ,l_vom10,
               l_vom.vom11,l_vom.vom12,l_vom.vom13,l_vom.vom14,l_vnd03
           IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               RETURN
           END IF
           #vom14 /*異動碼 0:不變，1:新增，2:刪除，3:修改  */
           CASE l_vom.vom14
                WHEN 1 #新增
                     #FUN-A70038 add---str---
                     #鎖定時間異動碼建議為新增時(vom14='1'),若ERP資料已存在,則作update動作
                     SELECT COUNT(*) INTO l_cnt
                       FROM vnd_file
                      WHERE vnd01 = l_vom.vom03
                        AND vnd02 = l_vom.vom04
                        AND vnd03 = l_vnd03
                        AND vnd04 = l_vom.vom06
                        AND vnd05 = l_vom.vom07
                     IF l_cnt >=1 THEN
                         UPDATE vnd_file
                            SET vnd05 = l_vom.vom07,
                                vnd06 = l_vom.vom08,
                                vnd07 = l_vom09,
                                vnd08 = l_vom10,
                                vnd09 = l_vom.vom11,
                                vnd10 = l_vom.vom12 
                          WHERE vnd01 = l_vom.vom03
                            AND vnd02 = l_vom.vom04
                            AND vnd03 = l_vnd03
                            AND vnd04 = l_vom.vom06
                            AND vnd05 = l_vom.vom07
                     ELSE
                     #FUN-A70038 add---end---
                         INSERT INTO vnd_file(vnd01,vnd02,vnd03,vnd04,vnd05,
                                              vnd06,vnd07,vnd08,vnd09,vnd10,vnd11,
                                              vndlegal,vndplant,vnd012) #FUN-B50022 add
                         VALUES(l_vom.vom03,l_vom.vom04,l_vnd03    ,l_vom.vom06,l_vom.vom07,
                                l_vom.vom08,l_vom09    ,l_vom10    ,l_vom.vom11,l_vom.vom12,0,
                                g_legal,g_plant,l_von.von012 )#FUN-B50022 add
                     END IF #FUN-A70035 add
                WHEN 2 #刪除
                     DELETE FROM vnd_file
                     WHERE vnd01 = l_vom.vom03
                       AND vnd02 = l_vom.vom04
                       AND vnd03 = l_vnd03
                       AND vnd04 = l_vom.vom06
                       AND vnd05 = l_vom.vom07
                WHEN 3 #修改
                     UPDATE vnd_file
                        SET vnd05 = l_vom.vom07,
                            vnd06 = l_vom.vom08,
                            vnd07 = l_vom09,
                            vnd08 = l_vom10,
                            vnd09 = l_vom.vom11,
                            vnd10 = l_vom.vom12 
                      WHERE vnd01 = l_vom.vom03
                        AND vnd02 = l_vom.vom04
                        AND vnd03 = l_vnd03
                        AND vnd04 = l_vom.vom06
                        AND vnd05 = l_vom.vom07
           END CASE
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_success = 'N'
               RETURN
           END IF
           UPDATE vom_file 
              SET vom13 = 1
            WHERE vom00 = l_vom.vom00
              AND vom01 = l_vom.vom01
              AND vom02 = l_vom.vom02
              AND vom03 = l_vom.vom03
              AND vom04 = l_vom.vom04
              AND vom05 = l_vom.vom05
              AND vom06 = l_vom.vom06
              AND vom07 = l_vom.vom07
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_success = 'N'
               RETURN
           END IF
           LET l_vnd03 = NULL
           INITIALIZE l_vom.* TO NULL
       END FOREACH
       LET l_vne03 = NULL
       INITIALIZE l_von.* TO NULL
   END FOREACH
END FUNCTION

