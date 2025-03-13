# Prog. Version..: '5.30.06-13.03.27(00010)'     #
#
# Pattern name...: asfp200.4gl
# Descriptions...: 工單整批處理作業
# Date & Author..: No.TQC-730022 07/03/26 By rainy
# Modify.........: No.TQC-760183 07/06/26 By rainy 按放棄程式會當掉不會結束
# Modify.........: No.MOD-840335 08/04/21 By Pengu 無法執行整批確認
# Modify.........: No.FUN-870117 08/08/01 By ve007 i301sub_firm1()增加兩個參數
# Modify.........: No.MOD-880016
# Modify.........: No.FUN-8C0081 09/03/09 By sabrina 原i301sub_firm1拆為i301sub_firm1_chk和i301sub_firm1_upd，所以此程式也一併調整
# Modify.........: No.FUN-950021 09/05/26 By Carrier 呼叫i301sub時，加傳一個是否在transaction的參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-840121 09/11/16 By 單身提供QBE的功能 
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No:MOD-9B0157 09/11/25 By lilingyu asfp200整批審核時,選擇多筆單身資料,仍然需一筆一筆的確認
# Modify.........: No:FUN-A80150 10/09/07 By sabrina 單身新增"計劃批號"欄位
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.TQC-C80084 12/08/14 By chenjing 修改工單料表列印後臺報錯信息
# Modify.........: No.MOD-D30236 13/03/27 By bart 依產業別傳遞對應的參數
# Modify.........: No:TQC-D70080 13/07/23 By yangtt CR轉GRW

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_renew   LIKE type_file.num5        
DEFINE g_sfb1    DYNAMIC ARRAY OF RECORD
                  a         LIKE type_file.chr1,   #選擇
                  sfb01     LIKE sfb_file.sfb01,        
                  sfb81     LIKE sfb_file.sfb81, 
                  sfb02     LIKE sfb_file.sfb02, 
                  sfb221    LIKE sfb_file.sfb221, 
                  sfb05     LIKE sfb_file.sfb05,
                  ima02     LIKE ima_file.ima02,
                  ima021    LIKE ima_file.ima021,
                  sfb08     LIKE sfb_file.sfb08,
                  sfb919    LIKE sfb_file.sfb919,     #FUN-A80150 add
                  sfb13     LIKE sfb_file.sfb13,
                  sfb15     LIKE sfb_file.sfb15,
                  sfb25     LIKE sfb_file.sfb25,
                  sfb081    LIKE sfb_file.sfb081,
                  sfb09     LIKE sfb_file.sfb09,
                  sfb12     LIKE sfb_file.sfb12,
                  sfb87     LIKE sfb_file.sfb87,
                  sfb04     LIKE sfb_file.sfb04
               END RECORD,
       g_sfb1_t RECORD
                  a         LIKE type_file.chr1,   #選擇
                  sfb01     LIKE sfb_file.sfb01,        
                  sfb81     LIKE sfb_file.sfb81, 
                  sfb02     LIKE sfb_file.sfb02, 
                  sfb221    LIKE sfb_file.sfb221, 
                  sfb05     LIKE sfb_file.sfb05,
                  ima02     LIKE ima_file.ima02,
                  ima021    LIKE ima_file.ima021,
                  sfb08     LIKE sfb_file.sfb08,
                  sfb919    LIKE sfb_file.sfb919,     #FUN-A80150 add
                  sfb13     LIKE sfb_file.sfb13,
                  sfb15     LIKE sfb_file.sfb15,
                  sfb25     LIKE sfb_file.sfb25,
                  sfb081    LIKE sfb_file.sfb081,
                  sfb09     LIKE sfb_file.sfb09,
                  sfb12     LIKE sfb_file.sfb12,
                  sfb87     LIKE sfb_file.sfb87,
                  sfb04     LIKE sfb_file.sfb04
               END RECORD,
 
       begin_no,end_no     LIKE oga_file.oga01,
       lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*,
       g_wc2,g_sql    STRING,
       g_ws1          STRING,
       g_wc_pmm       STRING,
       g_rec_b        LIKE type_file.num5,         
       g_rec_b1       LIKE type_file.num5,         
       l_ac1          LIKE type_file.num5,         
       l_ac1_t        LIKE type_file.num5,         
       l_ac           LIKE type_file.num5,          
       l_ac_t         LIKE type_file.num5          
DEFINE p_row,p_col    LIKE type_file.num5          
DEFINE g_cnt          LIKE type_file.num10         
DEFINE g_forupd_sql   STRING
DEFINE g_before_input_done STRING
DEFINE li_result      LIKE type_file.num5          
#DEFINE g_msg          LIKE type_file.chr1000      #TQC-C80084 mark 
DEFINE g_msg           STRING                      #TQC-C80084 add
DEFINE mi_need_cons     LIKE type_file.num5
DEFINE g_dbs2          LIKE type_file.chr30   #TQC-680074
DEFINE tm RECORD			      #
          slip         LIKE oay_file.oayslip, #單據別
          dt           LIKE oeb_file.oeb16,   #出通/出貨日期
          g            LIKE type_file.chr1    #匯總方式
      END RECORD,
      g_pmn02          LIKE pmn_file.pmn02    #採購單號
DEFINE t_aza41   LIKE type_file.num5        #單別位數 (by aza41)
 
 
 
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW p200_w AT p_row,p_col WITH FORM "asf/42f/asfp200"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible('sfb919',g_sma.sma1421='Y')      #FUN-A80150 add
 
   CALL p200_init() 
   LET mi_need_cons = 1  #讓畫面一開始進去就停在查詢
   LET g_renew = 1
   CALL p200()
 
   CLOSE WINDOW p200_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
 
 
FUNCTION p200()
 
   CLEAR FORM
   WHILE TRUE
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL p200_q()
      END IF
      CALL p200_p1()
      IF INT_FLAG THEN EXIT WHILE END IF
      CASE g_action_choice
         WHEN "select_all"   #全部選取
           CALL p200_sel_all('Y')
 
         WHEN "select_non"   #全部不選
           CALL p200_sel_all('N')
         
         WHEN "view_wo"      #工單明細
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
             #MOD-D30236---begin
             IF s_industry('slk') THEN  
                LET g_msg = ' asfi301_slk ', g_sfb1_t.sfb01 CLIPPED
             END IF 
             IF s_industry('icd') THEN  
                LET g_msg = ' asfi301_icd ', g_sfb1_t.sfb01 CLIPPED 
             ELSE  
             #MOD-D30236---end
                LET g_msg = ' asfi301 ', g_sfb1_t.sfb01 CLIPPED
             END IF  #MOD-D30236
             CALL cl_cmdrun_wait(g_msg CLIPPED)
           END IF
 
         WHEN "batch_confirm"  #工單確認
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
             CALL p200_batch_confirm()
           END IF
 
         WHEN "release_wo"     #工單發放
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
             CALL p200_release_wo()
           END IF
 
         WHEN "undo_release"   #發放還原
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
             CALL p200_undo_release()
           END IF
 
         WHEN "batch_print"    #列印工單
           IF cl_chk_act_auth() THEN
              CALL p200_batch_print()
           END IF

         #str----add by guanyao160801
         WHEN "ins_ecm"
            IF cl_chk_act_auth() THEN
               CALL p200_ins_ecm()
            END IF
         #end----add by guanyao160801
 
         WHEN "exporttoexcel" #匯出excel
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfb1),'','')
            END IF
     
         WHEN "exit"
           EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
 
 
 
 
FUNCTION p200_p1()
      LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)
 
      INPUT ARRAY g_sfb1 WITHOUT DEFAULTS FROM s_sfb.*  #顯示並進行選擇
        ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
         BEFORE ROW
             IF g_renew THEN
               LET l_ac1 = ARR_CURR()
               IF l_ac1 = 0 THEN
                  LET l_ac1 = 1
               END IF
             END IF
             CALL fgl_set_arr_curr(l_ac1)
             CALL cl_show_fld_cont()
             LET l_ac1_t = l_ac1
             LET g_sfb1_t.* = g_sfb1[l_ac1].*
             LET g_renew = 1
 
             IF g_rec_b1 > 0 THEN
               CALL cl_set_act_visible("select_all,select_non,view_wo,batch_confirm,
                                        release_wo,undo_release,batch_print", TRUE)
             ELSE
               CALL cl_set_act_visible("select_all,select_non,view_wo,batch_confirm,
                                        release_wo,undo_release,batch_print", FALSE)
             END IF
 
         ON CHANGE a
            IF cl_null(g_sfb1[l_ac1].a) THEN 
               LET g_sfb1[l_ac1].a = 'Y'
            END IF
 
         ON ACTION query
            LET mi_need_cons = 1
            EXIT INPUT
 
         ON ACTION select_all   #全部選取
            LET g_action_choice="select_all"
            EXIT INPUT
 
         ON ACTION select_non   #全部不選
            LET g_action_choice="select_non"
            EXIT INPUT
 
         ON ACTION view_wo      #工單明細
            LET g_action_choice="view_wo"
            EXIT INPUT
 
         ON ACTION batch_confirm    #整批確認
            LET g_action_choice="batch_confirm"
            EXIT INPUT
 
         ON ACTION release_wo       #工單發出
            LET g_action_choice="release_wo"
            EXIT INPUT
 
         ON ACTION undo_release     #發出還原
            LET g_action_choice="undo_release"
            EXIT INPUT
 
         ON ACTION batch_print      #工單列印 
            LET g_action_choice="batch_print"
            EXIT INPUT

    #str----add by guanyao160801
         ON ACTION ins_ecm
            LET g_action_choice = "ins_ecm"
            EXIT INPUT 
    #end----add by guanyao160801
 
         ON ACTION exporttoexcel
            LET g_action_choice = "exporttoexcel"
            EXIT INPUT     
 
         ON ACTION help
            CALL cl_show_help()
            EXIT INPUT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
      END INPUT
      CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p200_q()
   CLEAR FORM
   CALL g_sfb1.clear()
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CONSTRUCT g_wc2 ON sfb98,sfb82,
                      sfb01,sfb81,sfb02,sfb221,sfb05,sfb08,sfb919,sfb13, #FUN-840121   #FUN-A80150 add sfb919
                      sfb15,sfb25,sfb081,sfb09,sfb12,sfb87,sfb04  #FUN-840121
                 FROM FORMONLY.sfb98,FORMONLY.sfb82,
                      s_sfb[1].sfb01,s_sfb[1].sfb81,s_sfb[1].sfb02,s_sfb[1].sfb221, #FUN-840121
                      s_sfb[1].sfb05,s_sfb[1].sfb08,s_sfb[1].sfb919,s_sfb[1].sfb13,s_sfb[1].sfb15,  #FUN-840121  #FUN-A80150 add sfb919
                      s_sfb[1].sfb25,s_sfb[1].sfb081,s_sfb[1].sfb09,s_sfb[1].sfb12, #FUN-840121
                      s_sfb[1].sfb87,s_sfb[1].sfb04                                 #FUN-840121
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(sfb98)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  IF g_aaz.aaz90='Y' THEN  
                    LET g_qryparam.form = "q_gem4"  
                  ELSE
                    LET g_qryparam.form = "q_gem"
                  END IF
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb98  
                  NEXT FIELD sfb98
 
               WHEN INFIELD(sfb82)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     = "q_gem"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sfb82
                    NEXT FIELD sfb82
               #FUN-840121--begin--add---------
               WHEN INFIELD(sfb01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     = "q_sfb"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sfb01
                    NEXT FIELD sfb01
               WHEN INFIELD(sfb05)
#FUN-AA0059---------mod------------str-----------------               
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form     = "q_ima18"
#                    LET g_qryparam.state = 'c'
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima18","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY g_qryparam.multiret TO sfb05
                    NEXT FIELD sfb05
               #FUN-840121--end--add-------------- 
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
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      #RETURN        #TQC-760183
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM   #TQC-760183
   END IF
 
   CALL p200_b1_fill(g_wc2)
 
   LET l_ac1 = 1
   LET g_sfb1_t.* = g_sfb1[l_ac1].*
 
END FUNCTION
 
FUNCTION p200_b1_fill(p_wc2)
   DEFINE p_wc2     STRING
 
   LET g_sql = " SELECT 'N',sfb01,sfb81,sfb02,sfb221,sfb05,'','',",
               "            sfb08,sfb919,sfb13,sfb15,sfb25 ,sfb081,sfb09,",    #FUN-A80150 add sfb919
               "            sfb12,sfb87,sfb04", 
               "  FROM sfb_file ",
               "  WHERE ",p_wc2 CLIPPED,
               " AND sfb87!='X'",
               " ORDER BY sfb81 DESC,sfb01 "  #依開單日期降冪
              
 
   PREPARE p200_pb1 FROM g_sql
   DECLARE sfb_curs CURSOR FOR p200_pb1
  
   CALL g_sfb1.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH sfb_curs INTO g_sfb1[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)   
         EXIT FOREACH
      END IF
 
      SELECT ima02,ima021 INTO g_sfb1[g_cnt].ima02,g_sfb1[g_cnt].ima021
        FROM ima_file
       WHERE ima01 = g_sfb1[g_cnt].sfb05
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL  g_sfb1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b1 TO FORMONLY.cntb
   LET g_cnt = 0
END FUNCTION
 
 
#全部選取/全部不選
FUNCTION p200_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i      LIKE type_file.num5
  FOR l_i = 1 TO g_rec_b1 
    LET g_sfb1[l_i].a = p_flag
    DISPLAY BY NAME g_sfb1[l_i].a
  END FOR
END FUNCTION
 
 
FUNCTION p200_init()
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)   #FUN-9B0106
   CASE g_aza.aza41
     WHEN "1"
       LET t_aza41 = 3
     WHEN "2"
       LET t_aza41 = 4
     WHEN "3"
       LET t_aza41 = 5 
   END CASE
END FUNCTION
 
 
#整批確認
FUNCTION p200_batch_confirm()
  DEFINE l_i,l_n       LIKE type_file.num5
  DEFINE l_sfb RECORD  LIKE sfb_file.*
 
  LET l_n = 0 
  FOR l_i = 1 TO g_rec_b1
    IF g_sfb1[l_i].a = 'Y' THEN
       IF g_sfb1[l_i].sfb87 <> 'N' THEN
          LET g_sfb1[l_i].a = 'N' 
       ELSE
          LET l_n = l_n + 1
       END IF
    END IF
  END FOR
 
  IF l_n > 0 THEN
    IF NOT cl_confirm('axm-596') THEN
      RETURN
    END IF
  ELSE 
     RETURN
  END IF
 
  LET g_b_confirm = 'N'  #MOD-9B0157
  FOR l_i = 1 TO g_rec_b1
    IF g_sfb1[l_i].a = 'Y' THEN
 
          CALL i301sub_firm1_chk(g_sfb1[l_i].sfb01,FALSE)   #CALL原asfi301確認的check段  #No.FUN-950021
           LET g_b_confirm = 'Y'  #MOD-9B0157
          IF g_success = 'Y' THEN
             CALL i301sub_firm1_upd(g_sfb1[l_i].sfb01,"confirm",FALSE)  #CALL原asfi301確認的update段  #No.FUN-950021
          END IF

          SELECT * INTO l_sfb.* FROM sfb_file 
           WHERE sfb01 = g_sfb1[l_i].sfb01
          LET g_sfb1[l_i].sfb87 = l_sfb.sfb87
          LET g_sfb1[l_i].sfb04 = l_sfb.sfb04
          LET g_sfb1_t.* = g_sfb1[l_i].*
    END IF
  END FOR
END FUNCTION
 
#工單發放
FUNCTION p200_release_wo()
  DEFINE l_i,l_n       LIKE type_file.num5
  DEFINE l_wc   STRING
  DEFINE l_sfb  RECORD LIKE sfb_file.*
 
  LET l_n = 0 
  FOR l_i = 1 TO g_rec_b1
    IF g_sfb1[l_i].a = 'Y' THEN
       IF g_sfb1[l_i].sfb87 = 'X' OR g_sfb1[l_i].sfb04 <> '1' 
        OR g_sfb1[l_i].sfb02 = '2' OR g_sfb1[l_i].sfb02 = '7' 
 THEN
          LET g_sfb1[l_i].a = 'N' 
       ELSE
          LET l_n = l_n + 1
       END IF
    END IF
  END FOR
 
  IF l_n > 0 THEN
    IF NOT cl_confirm('asf-590') THEN
      RETURN
    END IF
  ELSE
    RETURN
  END IF
  
  LET l_wc = NULL
  FOR l_i = 1 TO g_rec_b1
    IF g_sfb1[l_i].a = 'Y' THEN
       IF cl_null(l_wc) THEN
         LET l_wc = " sfb01 IN ('", g_sfb1[l_i].sfb01 CLIPPED,"'"
       ELSE
         LET l_wc = l_wc CLIPPED,",'", g_sfb1[l_i].sfb01 CLIPPED,"'"
       END IF   
    END IF
  END FOR
  LET l_wc = l_wc CLIPPED,")"
  LET l_wc = cl_replace_str(l_wc,"'","\"")
  LET g_msg = " asfp620 '", l_wc,"'"
  CALL cl_cmdrun_wait(g_msg CLIPPED)
 
  
  FOR l_i = 1 TO g_rec_b1
    IF g_sfb1[l_i].a = 'Y' THEN
       SELECT * INTO l_sfb.* FROM sfb_file
        WHERE sfb01 = g_sfb1[l_i].sfb01
       LET g_sfb1[l_i].sfb081 = l_sfb.sfb081
       LET g_sfb1[l_i].sfb87 = l_sfb.sfb87
       LET g_sfb1[l_i].sfb04 = l_sfb.sfb04
    END IF
  END FOR
END FUNCTION
 
#發放還原
FUNCTION p200_undo_release()
  DEFINE l_i,l_n       LIKE type_file.num5
  DEFINE l_wc   STRING
  DEFINE l_sfb  RECORD LIKE sfb_file.*
 
  LET l_n = 0 
  FOR l_i = 1 TO g_rec_b1
    IF g_sfb1[l_i].a = 'Y' THEN
       IF g_sfb1[l_i].sfb87 <> 'Y' THEN
          LET g_sfb1[l_i].a = 'N' 
       ELSE
          LET l_n = l_n + 1
       END IF
    END IF
  END FOR
 
  IF l_n > 0 THEN
    IF NOT cl_confirm('asf-591') THEN
      RETURN
    END IF
  ELSE
    RETURN
  END IF
  
  LET l_wc = NULL
  FOR l_i = 1 TO g_rec_b1
    IF g_sfb1[l_i].a = 'Y' THEN
       IF cl_null(l_wc) THEN
         LET l_wc = " sfb01 IN ('", g_sfb1[l_i].sfb01 CLIPPED,"'"
       ELSE
         LET l_wc = l_wc CLIPPED,",'", g_sfb1[l_i].sfb01 CLIPPED,"'"
       END IF   
    END IF
  END FOR
  LET l_wc = l_wc CLIPPED,")"
  LET l_wc = cl_replace_str(l_wc,"'","\"")
  LET g_msg = " asfp322 '", l_wc,"'"
  CALL cl_cmdrun_wait(g_msg CLIPPED)
 
  
  FOR l_i = 1 TO g_rec_b1
    IF g_sfb1[l_i].a = 'Y' THEN
       SELECT * INTO l_sfb.* FROM sfb_file
        WHERE sfb01 = g_sfb1[l_i].sfb01
       LET g_sfb1[l_i].sfb081 = l_sfb.sfb081
       LET g_sfb1[l_i].sfb87 = l_sfb.sfb87
       LET g_sfb1[l_i].sfb04 = l_sfb.sfb04
    END IF
  END FOR
END FUNCTION
 
 
 
#工單料表列印
FUNCTION p200_batch_print()
  DEFINE l_wc STRING
  DEFINE l_i,l_n  LIKE type_file.num5
         
  LET l_n = 0
  FOR l_i = 1 TO g_rec_b1
    IF g_sfb1[l_i].a = 'Y' THEN
      LET l_n = l_n + 1
    END IF
  END FOR 
 
  IF l_n = 0 THEN RETURN END IF  #都沒勾選
  
  LET l_n = 0 
  LET l_wc = " sfb01 IN ("
  FOR l_i = 1 TO g_rec_b1
     IF g_sfb1[l_i].a = 'Y' THEn
        LET l_n = l_n + 1
        IF l_n = 1 THEN
           LET l_wc = l_wc CLIPPED,"'",g_sfb1[l_i].sfb01 CLIPPED,"'"
        ELSE
           LET l_wc = l_wc CLIPPED,",'",g_sfb1[l_i].sfb01 CLIPPED,"'"
        END IF
     END IF
  END FOR
  LET l_wc = l_wc CLIPPED,")"                                                                                     
  LET l_wc = cl_replace_str( l_wc , "'" , "\"" )
 
 #LET g_msg = " asfr201",   #TQC-D70080 
  LET g_msg = " asfg201",   #TQC-D70080 
      " '",g_today CLIPPED,"' ''",                                                                                         
      " '",g_lang CLIPPED,"' 'Y' '' '1'",                                                                                  
      " '",l_wc CLIPPED,"' ",
      " '",g_user CLIPPED,"' ",
      " '",g_grup CLIPPED,"' "
       
  CALL cl_cmdrun(g_msg)
 
END FUNCTION
 
#TQC-730022
#MOD-880016
#str--------add by guanyao160801
FUNCTION p200_ins_ecm()
  DEFINE l_i,l_n       LIKE type_file.num5
  DEFINE l_sfb RECORD  LIKE sfb_file.*
  DEFINE l_flag1       LIKE type_file.num5
  DEFINE g_ecu01       LIKE ecu_file.ecu01
  DEFINE l_sfb1        DYNAMIC ARRAY OF RECORD
         sfb01      LIKE sfb_file.sfb01
         END RECORD 
 
    LET l_n = 0 
    FOR l_i = 1 TO g_rec_b1
       IF g_sfb1[l_i].a = 'Y' THEN
         # IF g_sfb1[l_i].sfb87 <> 'N' THEN    #mark by jixf 160802 已审核工单也可以产生工艺资料
         #    LET g_sfb1[l_i].a = 'N' 
         # ELSE
             LET l_n = l_n + 1
             LET l_sfb1[l_n].sfb01 = g_sfb1[l_i].sfb01
         # END IF
       END IF
    END FOR
 
    IF l_n > 0 THEN
       IF NOT cl_confirm('axm-596') THEN
          RETURN
       END IF
    ELSE 
       RETURN
    END IF
    LET  g_success = 'Y'
    BEGIN WORK 
    FOR l_i =1 TO l_n  

       INITIALIZE l_sfb.* TO NULL 
       SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01 =l_sfb1[l_i].sfb01
       #生產日報已有資料
       SELECT COUNT(*) INTO g_cnt FROM shb_file WHERE shb05 = l_sfb.sfb01
                                                  AND shbconf = 'Y'     
       IF g_cnt > 0 THEN 
          LET g_success = 'N' 
          CALL cl_err('','asf-025',1)
          EXIT FOR  
       END IF
 
       SELECT COUNT(*) INTO g_cnt FROM ecm_file WHERE ecm01=l_sfb.sfb01
       IF g_cnt > 0 THEN
          DELETE FROM ecm_file WHERE ecm01=l_sfb.sfb01
          IF SQLCA.sqlerrd[3]=0 THEN
             LET g_success = 'N' 
             CALL cl_err3("del","ecm_file",l_sfb.sfb01,"","asf-026","","",1)  #No.FUN-660128
             EXIT FOR 
          END IF
       END IF
       #TQC-B80089 add str-----
       IF g_sma.sma901='Y' THEN
          DELETE FROM vmn_file
           WHERE vmn02 = l_sfb.sfb01
          DELETE FROM vnm_file
           WHERE vnm01 = l_sfb.sfb01
       END IF
       #TQC-B80089 add end-----
       SELECT COUNT(*) INTO g_cnt FROM sgd_file where sgd00=l_sfb.sfb01
       IF g_cnt > 0 THEN
          DELETE FROM sgd_file WHERE sgd00=l_sfb.sfb01
          IF SQLCA.sqlerrd[3]=0 THEN
             LET g_success = 'N' 
             CALL cl_err3("del","sgd_file",l_sfb.sfb01,"","asf-024","","",1)
             EXIT FOR 
          END IF
       END IF
       CALL s_schdat_sel_ima571(l_sfb.sfb01) RETURNING l_flag1,g_ecu01
       IF l_flag1 = 0 THEN 
          LET g_success = 'N' 
          CALL cl_err3("sel","ecu_file",l_sfb.sfb01,l_sfb.sfb06,STATUS,"","sel ecu:",1) 
          EXIT FOR 
       END IF

 
       CALL s_schdat(0,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb071,l_sfb.sfb01,
                     l_sfb.sfb06,l_sfb.sfb02,g_ecu01,l_sfb.sfb08,2)
       RETURNING g_cnt,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb32,l_sfb.sfb24
       SELECT count(*) INTO g_cnt FROM ecm_file WHERE ecm01 = l_sfb.sfb01
       IF g_cnt >0 THEN 
       ELSE 
          LET g_success = 'N'
          CALL cl_err('','csf-059',0)  
          EXIT FOR 
       END IF 
       IF g_cnt > 0 THEN LET l_sfb.sfb24 = 'Y' ELSE LET l_sfb.sfb24 = 'N' END IF
       SELECT count(*) INTO g_cnt FROM sfb_file
        WHERE sfb01=l_sfb.sfb01
          AND (sfb13 IS NOT NULL AND sfb15 IS NOT NULL )
       IF g_cnt > 0 THEN
          UPDATE sfb_file SET sfb24=l_sfb.sfb24 WHERE sfb01=l_sfb.sfb01
          SELECT sfb13,sfb15 INTO l_sfb.sfb13,l_sfb.sfb15 FROM sfb_file
           WHERE sfb01=l_sfb.sfb01
       ELSE
          UPDATE sfb_file SET sfb13=l_sfb.sfb13,
                              sfb15=l_sfb.sfb15,
                              sfb24=l_sfb.sfb24
           WHERE sfb01=l_sfb.sfb01
       END IF
    END FOR 

    IF g_success = 'Y' THEN 
       COMMIT WORK 
       CALL cl_getmsg('asf-386',g_lang) RETURNING g_msg
       CALL cl_msgany(0,0,g_msg)
    ELSE 
       ROLLBACK WORK 
    END IF 
    
END FUNCTION 
#end--------add by guanyao160801
