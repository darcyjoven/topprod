# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmp201.4gl
# Descriptions...: 工單轉請采購作業
# Date & Author..: No.FUN-960071 07/03/26 By chenmoyan
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980006 09/09/03 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.           09/10/20 By lilingyu r.c2 fail
# Modify.........: No:FUN-9A0065 09/11/02 By baofei 寫入請購單身時，也要一併寫入"電子採購否(pml92)"='N'
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No.TQC-9B0203 09/11/24 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:TQC-9B0214 09/11/25 By Sunyanchun  s_defprice --> s_defprice_new
# Modify.........: No:FUN-A30021 10/03/10 By Smapmin 串查明細資料後,要回到原來record筆數上
# Modify.........: No:FUN-A30059 10/03/22 By rainy 拋請購單取號模組別應傳 apm ，非 asf
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No:CHI-A30039 10/03/31 By Smapmin 1.若工單為委外工單,則由工單拋到採購單時,單頭是由工單轉入,單身是工單單號.
#                                                      若工單非委外工單,則由工單拋到採購單時,單頭是由請購轉入,單身是請購單號.
#                                                    2.請/採購單的到庫/到廠/交貨日期皆未產生,應該由工單的預計開工日defalut到庫日,再由到庫日回推到廠/交貨日.
# Modify.........: No:MOD-A40025 10/04/07 By Smapmin 請購單號有產生, 但請購項次未產生
# Modify.........: No:TQC-A70004 10/07/01 By yinhy  INSERT INTO pmn_file時，如果pmn012為null則給‘ ’
# Modify.........: No.FUN-AB0067 10/11/19 by destiny  增加倉庫的權限控管 
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B70015 11/07/07 By yangxf 經營方式默認給值'1'經銷
# Modify.........: No.FUN-BB0085 11/11/22 By xianghui 增加數量欄位小數取位
# Modify.........: No.FUN-910088 11/11/25 By chenjing 增加數量欄位小數取位 
# Modify.........: No:MOD-B90093 12/01/17 By Vampire '拋轉採購單'無法產生採購單.因為Transaction架構錯誤
# Modify.........: No:TQC-BC0027 12/01/20 By SunLM 修正工單轉採購單,請購單賦初值錯誤的問題
# Modify.........: No:FUN-C10002 12/02/01 By bart 作業編號pmn78帶預設值
# Modify.........: No:TQC-C10062 12/02/16 By suncx 請/採購單拋轉成功後顯示請/採購單號
# Modify.........: No:TQC-C10063 12/02/20 By suncx 若拋轉後所得到的請採購單身無資料則不用拋轉
# Modify.........: No:MOD-C30597 12/03/15 By yuhuabao 資料換筆時先刪除apm_p470的資料
# Modify.........: No:TQC-C40253 12/04/26 By zhuhao 資料換筆時先刪除apm_p470的資料
# Modify.........: No:MOD-C80116 12/08/15 By SunLM  對pmn13超/短交限率,進行賦值
# Modify.........: No:MOD-C80245 12/09/03 By Vampire 增加預設值pmkprsw='Y'
# Modify.........: No:TQC-D20024 13/02/19 By xuxz 單身單號和單據性質查詢時候開放給用於錄入條件
# Modify.........: No:MOD-D20115 13/03/11 By Elise apmp201 排除轉委外採購單
# Modify.........: No:FUN-D40042 13/04/17 By fengrui 轉採購時，工單備註sfb96入採購單備註pmn100
# Modify.........: No:MOD-D60195 13/06/24 By SunLM 對工單轉採購單賦初值"1"  
# Modify.........: No:MOD-D70165 13/07/24 By SunLM  調用SUB函數對pmn13超/短交限率,進行賦值


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
      #g_wc2,g_sql    LIKE type_file.chr1000,#TQC-D20024 mark
       g_wc2,g_sql    STRING,#TQC-D20024 add
       g_ws1          LIKE type_file.chr1000,
       g_wc3          STRING,#TQC-D20024 add
       g_wc_pmm       LIKE type_file.chr1000,
       g_seq          LIKE type_file.num5,
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
DEFINE g_msg          LIKE type_file.chr1000       
DEFINE mi_need_cons     LIKE type_file.num5
DEFINE g_dbs2          LIKE type_file.chr30   
DEFINE tm RECORD			     
          slip         LIKE oay_file.oayslip, #單據別
          dt           LIKE oeb_file.oeb16,   #出通/出貨日期
          g            LIKE type_file.chr1    #匯總方式
      END RECORD,
      g_pmn02          LIKE pmn_file.pmn02    #採購單號
DEFINE g_pmk  RECORD LIKE pmk_file.*
DEFINE g_pml2 RECORD LIKE pml_file.*
DEFINE g_pmn  RECORD LIKE pmn_file.*
DEFINE t_aza41   LIKE type_file.num5        #單別位數 (by aza41)
DEFINE slip      LIKE oay_file.oayslip
DEFINE g_no      STRING #TQC-C10062 請/採購單號存放字符串 
 
 
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
 
   #OPEN WINDOW p200_w AT p_row,p_col WITH FORM "asf/42f/asfp200"  #No.FUN-AB0067  
   OPEN WINDOW p201_w AT p_row,p_col WITH FORM "apm/42f/apmp201"   #No.FUN-AB0067  
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CREATE TEMP TABLE apm_p470(
       part     LIKE sfa_file.sfa03,
       sfa26    LIKE sfa_file.sfa26,
       sfb25    LIKE sfb_file.sfb25,    #實際開工日
       req_qty  LIKE sfa_file.sfa04,
       al_qty   LIKE sfa_file.sfa04,
       pr_qty   LIKE sfa_file.sfa04,
       po_qty   LIKE sfa_file.sfa04,
       qc_qty   LIKE sfa_file.sfa04,
       wo_qty   LIKE sfa_file.sfa04)
 
   CREATE UNIQUE INDEX p470_t1 
       ON apm_p470 (part,sfa26,sfb25)
 
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
      LET g_no = NULL #TQC-C10062
      IF INT_FLAG THEN EXIT WHILE END IF
      CASE g_action_choice
         WHEN "select_all"   #全部選取
           CALL p200_sel_all('Y')
 
         WHEN "select_non"   #全部不選
           CALL p200_sel_all('N')
         
         WHEN "view_wo"      #工單明細
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
             LET g_msg = ' asfi301 ', g_sfb1_t.sfb01 CLIPPED
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
 
         WHEN "carry_pr"       #轉請購
           IF cl_chk_act_auth() THEN
              IF g_sma.sma31 = "Y" THEN
                 DELETE FROM apm_p470 
                 CALL p201_carry_pr()
                 #TQC-C10062 add begin----------
                 IF NOT cl_null(g_no) THEN
                    CALL cl_err(g_no,'axm-559',1)
                 END IF
                 #TQC-C10062 add end------------
              END IF
           END IF
 
         WHEN "carry_po"
           IF cl_chk_act_auth() THEN
              IF g_sma.sma32 = 'N' THEN
                 DELETE FROM apm_p470 
                 LET g_totsuccess = 'Y'
                 CALL p201_carry_po()
                 IF g_totsuccess = 'Y' THEN
                    COMMIT WORK
                    #CALL cl_err('','axm-560',1)
                    #TQC-C10062 add begin----------
                    IF NOT cl_null(g_no) THEN
                       CALL cl_err(g_no,'axm-560',1)
                    END IF
                    #TQC-C10062 add end------------
                 ELSE
                    ROLLBACK WORK
                 END IF
              END IF
         END IF
 
         WHEN "detail_pr"
           IF cl_chk_act_auth() THEN
              CALL p201_detail_pr()
           END IF
 
         WHEN "detail_po"
           IF cl_chk_act_auth() THEN
              CALL p201_detail_po()
           END IF
 
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
         #-----FUN-A30021---------
         BEFORE INPUT
            IF g_rec_b1 != 0 THEN
               CALL fgl_set_arr_curr(l_ac1)
            END IF
         #-----END FUN-A30021-----

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
  
         ON ACTION carry_pr
            LET g_action_choice="carry_pr"
            EXIT INPUT
 
         ON ACTION carry_po
            LET g_action_choice="carry_po"
            EXIT INPUT
 
         ON ACTION detail_pr
            LET g_action_choice="detail_pr"
            EXIT INPUT
 
         ON ACTION detail_po
            LET g_action_choice="detail_po"
            EXIT INPUT
 
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
   CONSTRUCT g_wc2 ON sfb98,sfb82
                 FROM FORMONLY.sfb98,FORMONLY.sfb82
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
  #TQC-D20024--add--str
  #添加單身sfb01和sfb02在查詢時候的錄入
   CONSTRUCT g_wc3 ON sfb01,sfb02 
      FROM  s_sfb[1].sfb01,s_sfb[1].sfb02
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      
      ON ACTION controlp
         CASE  
            WHEN INFIELD(sfb01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_sfb"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfb01 
               NEXT FIELD sfb01 
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
  #TQC-D20024--add--end
   LET g_wc2 = g_wc3 CLIPPED," AND ",g_wc2 CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030#TQC-D20024 add g_wc CLIPPED,"AND" ,
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   CALL p200_b1_fill(g_wc2)
 
   LET l_ac1 = 1
   LET g_sfb1_t.* = g_sfb1[l_ac1].*
 
END FUNCTION
 
FUNCTION p200_b1_fill(p_wc2)
   DEFINE p_wc2     STRING
 
   LET g_sql = " SELECT 'N',sfb01,sfb81,sfb02,sfb221,sfb05,'','',",
               "            sfb08,sfb13,sfb15,sfb25 ,sfb081,sfb09,",
               "            sfb12,sfb87,sfb04", 
               "  FROM sfb_file ",
               "  WHERE ",p_wc2 CLIPPED,
               "    AND sfb02 NOT IN ('7','8') ", #排除委外工單 MOD-D20115 add
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
 
  FOR l_i = 1 TO g_rec_b1
    IF g_sfb1[l_i].a = 'Y' THEN
 
          CALL i301sub_firm1_chk(g_sfb1[l_i].sfb01,FALSE)   
          IF g_success = 'Y' THEN
             CALL i301sub_firm1_upd(g_sfb1[l_i].sfb01,"confirm",FALSE)  
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
 
  LET g_msg = " asfr201",                                                                                                   
      " '",g_today CLIPPED,"' ''",                                                                                         
      " '",g_lang CLIPPED,"' 'Y' '' '1'",                                                                                  
      " '",l_wc CLIPPED,"' ",
      " '",g_user CLIPPED,"' ",
      " '",g_grup CLIPPED,"' "
       
  CALL cl_cmdrun(g_msg)
 
END FUNCTION
FUNCTION p201_cur(p_sfb01)
  DEFINE l_sql    LIKE type_file.chr1000
  DEFINE p_sfb01  LIKE sfb_file.sfb01
    #--->讀取備料量(應發量-已發量)
     LET l_sql = " SELECT sum((sfa05-sfa06-sfa065)*sfa13) ",
                 " FROM sfa_file,sfb_file",   
                 " WHERE sfa03 = ? ",
                 "   AND sfa01 = sfb01 ",
                 "   AND sfb01 = '",p_sfb01,"'",
                 "   AND sfb04 != '8' ",
                 "   AND sfb02 != '2' AND sfb02 != '11' AND sfb87!='X' "
     PREPARE p201_presfa  FROM l_sql
     DECLARE p201_cssfa  CURSOR WITH HOLD FOR p201_presfa
 
    #--->讀取獨立性需求量(工單最晚完工日)
     LET l_sql = " SELECT sum((rpc13-rpc131)*rpc16_fac) ", 
                 "   FROM rpc_file WHERE rpc01 = ? "
     PREPARE p201_prerpc  FROM l_sql
     DECLARE p201_csrpc  CURSOR WITH HOLD FOR p201_prerpc
 
    #--->讀取請購量(請購量-已轉採購量)(日期區間)
     LET l_sql = " SELECT sum((pml20-pml21)*pml09) FROM pml_file,pmk_file ",
                 " WHERE pmk01=pml01 AND pmk18 != 'X' ",
                 "   AND pml04 = ? ",
                 "   AND (pml16 < '6' OR pml16 = 'S' OR pml16 = 'R' OR pml16 = 'W') ",
                 "   AND (pml011 = 'REG' OR pml011 = 'IPO') ",
                 "   AND pml01 != '",g_pmk.pmk01,"'"
 
     PREPARE p201_prepml  FROM l_sql
     DECLARE p201_cspml  CURSOR WITH HOLD FOR p201_prepml
 
    #--->讀取採購量(採購量-已交量)/檢驗量(pmn51)(日期區間)
     LET l_sql = " SELECT sum(((pmn20-(pmn50-pmn55))/pmn62)*pmn09) ",   
                 "   FROM pmn_file,pmm_file ",
                 "  WHERE pmm01=pmn01 AND pmm18 != 'X' ",
                 "    AND pmn61 = ? ",
                 "    AND (pmn16 < '6' OR pmn16 = 'S' OR pmn16 = 'R' OR pmn16 = 'W') ",   
                 "    AND (pmn011 = 'REG' OR pmn011 = 'IPO') ",
                 "    AND (pmn20-(pmn50-pmn55)) > 0 "
     PREPARE p201_prepmn  FROM l_sql
     DECLARE p201_cspmn  CURSOR WITH HOLD FOR p201_prepmn
 
     LET l_sql = " SELECT sum((rvb31)*pmn09) ",     
                 "   FROM rvb_file,rva_file,pmn_file   ",   
                 "  WHERE rva01=rvb01 AND rvaconf = 'Y' ",
                 "   AND rvb04=pmn01 ",      
                 "   AND rvb03=pmn02 ",      
                 "    AND rvb05 = ?  "
     PREPARE p201_prervb FROM l_sql
     DECLARE p201_csrvb  CURSOR WITH HOLD FOR p201_prervb
 
    #--->讀取工單量(生產數量-入庫量-報廢量)(日期區間)
     LET l_sql = " SELECT sum((sfb08-sfb09-sfb12)*ima55_fac) ",  
                 "   FROM sfb_file,ima_file ", 
                 "  WHERE sfb05 = ? ",
                 "    AND ima01=sfb05 ",       
                 "    AND sfb04 != '8' ",
                 "    AND sfb02 != '2' AND sfb02 != '11' AND sfb87!='X' "
     PREPARE p470_p_sfb  FROM l_sql
     DECLARE p470_c_sfb  CURSOR WITH HOLD FOR p470_p_sfb
END FUNCTION
 
FUNCTION p201_carry_pr()
DEFINE l_cnt        LIKE type_file.num5
DEFINE i            LIKE type_file.num5
DEFINE l_pmk01      LIKE pmk_file.pmk01
DEFINE l_pmm01      LIKE pmm_file.pmm01
   LET i=1
   LET g_pmk.pmk02="REG"
   LET g_pmk.pmk03 = 0
   LET g_pmk.pmk04 = g_today
   LET g_pmk.pmk05 = ''     
   LET g_pmk.pmk12 = g_user
   LET g_pmk.pmk13 = g_grup
   SELECT azn02,azn04 INTO g_pmk.pmk31,g_pmk.pmk32 FROM azn_file
    WHERE azn01 = g_pmk.pmk04
   LET g_pmk.pmk18 = 'N'
   LET g_pmk.pmk25 = '0'
   LET g_pmk.pmk27 = g_today
   LET g_pmk.pmk30 = 'Y'
   LET g_pmk.pmk40 = 0
   LET g_pmk.pmk401= 0
   LET g_pmk.pmk42 = 1
   LET g_pmk.pmk43 = 0
   LET g_pmk.pmk45 = 'Y'
   LET g_pmk.pmkdays = 0
   LET g_pmk.pmkprno = 0
   LET g_pmk.pmksmax = 0
   LET g_pmk.pmksseq = 0
   LET g_pmk.pmk22 = g_aza.aza17
   LET g_pmk.pmkacti ='Y'
   LET g_pmk.pmkuser = g_user
   LET g_pmk.pmkgrup = g_grup
   LET g_pmk.pmkdate = g_today
   LET g_pmk.pmk46   = '1'
   LET g_pmk.pmkmksg = 'N' #TQC-BC0027
   LET g_pmk.pmkcrat = g_today #TQC-BC0027
   LET g_pmk.pmkprsw = 'Y' #MOD-C80245 add
   CALL p201_slip('1')
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   BEGIN WORK
   CALL s_check_no("apm",slip,"",'1',"pmk_file","pmk01","")                                                      
        RETURNING li_result,slip
   IF (NOT li_result) THEN                                                                                                      
      LET g_success = 'N'
   END IF
   FOR i = 1 TO g_rec_b1
      DELETE FROM apm_p470                           #MOD-C30597 add
      IF g_sfb1[i].a = 'Y' THEN 
         SELECT DISTINCT pmk01 INTO l_pmk01
           FROM pmk_file,pml_file,sfb_file
          WHERE sfb01 = pml24
            AND sfb01 = g_sfb1[i].sfb01
            AND pmk01 = pml01 
            AND pmk18 != 'X'
         IF NOT cl_null(l_pmk01) THEN
            CALL cl_err(g_sfb1[i].sfb01,'axm-001',0)
            RETURN
         END IF
         SELECT DISTINCT pmm01 INTO l_pmm01
           FROM pmm_file,pmn_file,sfb_file
          WHERE pmm01 = pmn01
            AND pmn24 = sfb01
            AND sfb01=g_sfb1[i].sfb01
         IF NOT cl_null(l_pmm01) THEN
            CALL cl_err(g_sfb1[i].sfb01,'axm-581',0)
            RETURN
         END IF
         LET g_success = 'Y'
         CALL s_auto_assign_no("apm",slip,g_today,"1","pmk_file","pmk01","","","")   #FUN-A30059 asf->apm
            RETURNING li_result,g_pmk.pmk01
 
         #FUN-980006 add plant & legal 
         LET g_pmk.pmkplant = g_plant 
         LET g_pmk.pmklegal = g_legal 
         #FUN-980006 end plant & legal 
 
         LET g_pmk.pmkoriu = g_user      #No.FUN-980030 10/01/04
         LET g_pmk.pmkorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO pmk_file VALUES(g_pmk.*)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
             CALL cl_err3("ins","pmk_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","ins pmk",1)  
             LET g_success = 'N'
         END IF         
         IF g_success = 'Y' THEN
            #COMMIT WORK    #TQC-C10063 mark
            #BEGIN WORK     #MOD-B90093 mark
            CALL p201_dis_detail(g_sfb1[i].sfb01,'1','','')
            #TQC-C10063 add begin------------------------
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM pml_file
             WHERE pml01 = g_pmk.pmk01
            IF l_cnt = 0 THEN
               CALL cl_err3("ins","pml_file",g_pmk.pmk01,"","mfg0066","","ins pml",1)
               LET g_success = 'N'
            END IF
            #TQC-C10063 add end--------------------------
         ELSE
            ROLLBACK WORK
         END IF
         IF g_success = 'Y' THEN
           #TQC-C10062 add begin---------------------
            IF cl_null(g_no) THEN
               LET g_no = g_pmk.pmk01
            ELSE
               LET g_no = g_no,'|',g_pmk.pmk01
            END IF
            #TQC-C10062 add end-----------------------
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
      END IF
   END FOR
END FUNCTION
 
FUNCTION p201_carry_po()
DEFINE i       LIKE type_file.num5
DEFINE l_pmm01 LIKE pmm_file.pmm01
   IF g_sma.sma32 = 'N' THEN
      CALL p201_slip('2')
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_totsuccess = 'N'
         RETURN
      END IF
      FOR i = 1 TO g_rec_b1
         DELETE FROM apm_p470         #TQC-C40253 add
         IF g_sfb1[i].a = 'Y' THEN 
            SELECT DISTINCT pmm01 INTO l_pmm01
              FROM pmm_file,pmn_file,sfb_file
             WHERE pmm01 = pmn01
               AND pmn24 = g_sfb1[i].sfb01
            IF NOT cl_null(l_pmm01) THEN
               CALL cl_err(g_sfb1[i].sfb01,'axm-581',0)
               LET g_totsuccess = 'N'
               RETURN
            END IF
            LET g_success = 'Y'
            CALL t201sub_exp_po(g_sfb1[i].sfb01)
         END IF
      END FOR
   END IF
END FUNCTION
 
FUNCTION p201_slip(p_type)
DEFINE p_type        LIKE type_file.chr1
DEFINE l_cnt         LIKE type_file.num5
   LET slip = ' '
 
   OPEN WINDOW p201_exp WITH FORM "apm/42f/apmp201a"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("apmp201a")
   INPUT BY NAME slip WITHOUT DEFAULTS
   AFTER FIELD slip
      IF NOT cl_null(slip) THEN
         LET l_cnt = 0
         IF p_type = '1' THEN
            SELECT COUNT(*) INTO l_cnt FROM smy_file
             WHERE smyslip = slip AND smysys = 'apm' AND smykind = '1'
         ELSE
            SELECT COUNT(*) INTO l_cnt FROM smy_file
             WHERE smyslip = slip AND smysys = 'apm' AND smykind = '2'
         END IF
         IF SQLCA.sqlcode OR cl_null(slip) THEN
            LET l_cnt = 0
         END IF
         IF l_cnt = 0 THEN
            CALL cl_err(slip,'aap-010',0)
            NEXT FIELD slip
         END IF
      END IF
   ON ACTION controlp
      CASE
         WHEN INFIELD(slip)
            IF p_type = '1' THEN
               CALL q_smy(FALSE,TRUE,slip,'APM','1')
                       RETURNING slip
            ELSE
               CALL q_smy(FALSE,TRUE,slip,'APM','2')
                       RETURNING slip
            END IF
            DISPLAY BY NAME slip
            NEXT FIELD slip
            OTHERWISE EXIT CASE
      END CASE
 
   ON IDLE g_idle_seconds                                                                                                        
      CALL cl_on_idle()
      CONTINUE INPUT
                                                                                                                                    
   ON ACTION about
      CALL cl_about()
                                                                                                                                    
   ON ACTION help
      CALL cl_show_help()
   ON ACTION controlg
      CALL cl_cmdask()
   END INPUT
   IF INT_FLAG THEN                                                                                                                 
      CLOSE WINDOW p201_exp                                                                                                         
      RETURN                                                                                                                        
   END IF                                                                                                                           
   CLOSE WINDOW p201_exp
END FUNCTION
 
FUNCTION p201_dis_detail(p_sfb01,p_type,p_sfa03,p_pmm01)
DEFINE p_sfb01    LIKE sfb_file.sfb01
DEFINE p_type     LIKE type_file.chr1
DEFINE p_sfa03    LIKE sfa_file.sfa03
DEFINE p_pmm01    LIKE pmm_file.pmm01
DEFINE l_pmm13    LIKE pmm_file.pmm13
DEFINE l_sql      LIKE type_file.chr1000
DEFINE l_sql1     LIKE type_file.chr1000
DEFINE l_sfa03    LIKE sfa_file.sfa03
DEFINE l_sfa08    LIKE sfa_file.sfa08
DEFINE g_where    LIKE type_file.chr1000
DEFINE l_sfa26    LIKE sfa_file.sfa26,
       l_sfb25    LIKE sfb_file.sfb25,
       l_sfb13    LIKE sfb_file.sfb13,   #CHI-A30039
       l_sfb02    LIKE sfb_file.sfb02,   #CHI-A30039
          req_qty    LIKE pml_file.pml20,
          al_qty     LIKE pml_file.pml20,
          rpc_qty    LIKE pml_file.pml20,
          pr_qty     LIKE pml_file.pml20,
          po_qty     LIKE pml_file.pml20,
          qc_qty     LIKE pml_file.pml20,
          wo_qty     LIKE pml_file.pml20,
          su_qty     LIKE pml_file.pml20,
          sh_qty     LIKE pml_file.pml20,
#          l_ima262   LIKE ima_file.ima262,#FUN-A20044 
          l_avl_stk   LIKE type_file.num15_3,#FUN-A20044 
          l_ima27    LIKE ima_file.ima27,
          l_ima45    LIKE ima_file.ima45,
          l_ima46    LIKE ima_file.ima46,
          l_supply   LIKE pml_file.pml20,
          l_pan      LIKE type_file.num10,
          l_double   LIKE type_file.num10
   IF s_industry('slk') THEN
      LET l_sql = "SELECT UNIQUE sfa03,sfa08,sfa26,sfb25,sfb13,sum((sfa05-sfa06-sfa065)*sfa13) ",        #CHI-A30039 add sfb13
                  "  FROM sfa_file,sfb_file,ima_file,sfci_file",
                  " WHERE sfa01 = sfb01 ",
                  "   AND sfb01 = '",p_sfb01,"'",
                  "   AND sfb04 != '8' ",
                  "  AND sfb02 != '2'  AND sfb02 != '11' AND sfb87!='X' ",
                  "  AND sfa065 = 0 ", 
                  "  AND sfci01 = sfb85 ",
                  "   AND sfa03 = ima01 " 
   ELSE
      LET l_sql = "SELECT UNIQUE sfa03,sfa08,sfa26,sfb25,sfb13,sum((sfa05-sfa06-sfa065)*sfa13) ",      #CHI-A30039 add sfb13
                  "  FROM sfa_file,sfb_file,ima_file",
                  " WHERE sfa01 = sfb01 ",
                  "   AND sfb01 = '",p_sfb01,"'",
                  "   AND sfb04 != '8' ",
                  "  AND sfb02 != '2'  AND sfb02 != '11' AND sfb87!='X' ",
                  "  AND sfa065 = 0 ",
                  "   AND sfa03 = ima01 "
   END IF
   IF p_type = '2' THEN
      LET l_sql = l_sql," AND sfa03 = '",p_sfa03,"'"
   END IF
   LET l_sql1 = "   GROUP BY sfa03,sfa08,sfa26,sfb25,sfb13 ",   #CHI-A30039 add sfb13
                "   ORDER BY 1,2,3 "
   LET l_sql = l_sql,l_sql1
   PREPARE p201_prepare FROM l_sql
   DECLARE p201_cs                         
       CURSOR WITH HOLD FOR p201_prepare
   #-->相關數量讀取
   CALL p201_cur(p_sfb01)
   #-->請購單身預設值
   CALL p201_detailini(p_type,p_pmm01)
   IF p_type = '1' THEN
      LET g_pml2.pml24 = p_sfb01
      SELECT max(pml02)+1 INTO g_seq FROM pml_file WHERE pml01 = g_pmk.pmk01
      #-----MOD-A40025---------
      IF g_seq IS NULL OR g_seq = ' ' OR g_seq = 0 THEN
         LET g_seq = 1
      END IF
      #-----END MOD-A40025-----
   ELSE 
      SELECT pmm13 INTO l_pmm13 FROM pmm_file WHERE pmm01=p_pmm01
      SELECT max(pmn02)+1 INTO g_seq FROM pmn_file WHERE pmn01 = p_pmm01
      #-----MOD-A40025---------
      IF g_seq IS NULL OR g_seq = ' ' OR g_seq = 0 THEN
         LET g_seq = 1
      END IF
      #-----END MOD-A40025-----
      #-----CHI-A30039---------
      #LET g_pmn.pmn24 = p_sfb01
      LET l_sfb02 = ''
      LET g_pmn.pmn24 = ''
      LET g_pmn.pmn25 = ''   #MOD-A40025
      SELECT sfb02 INTO l_sfb02 FROM sfb_file WHERE sfb01=p_sfb01
     #MOD-D20115 mark start -----
     #IF l_sfb02 = '7' OR l_sfb02 = '8' THEN
     #   LET g_pmn.pmn24 = p_sfb01
     #ELSE
     #MOD-D20115 mark end    -----
         DECLARE pml_c SCROLL CURSOR FOR 
           SELECT DISTINCT pml01 FROM pml_file
             WHERE pml24 = p_sfb01
         OPEN pml_c
         FETCH FIRST pml_c INTO g_pmn.pmn24
         IF cl_null(g_pmn.pmn24) THEN
            LET g_pmn.pmn24 = p_sfb01
            UPDATE pmm_file SET pmm909='5' WHERE pmm01 = p_pmm01
         #-----MOD-A40025---------
         ELSE
            LET g_pmn.pmn25 = g_seq
         #-----END MOD-A40025-----
         END IF
     #END IF  #MOD-D20115 mark
      #-----END CHI-A30039-----
   END IF
   #-----MOD-A40025---------
   #IF g_seq IS NULL OR g_seq = ' ' OR g_seq = 0 THEN
   #   LET g_seq = 1
   #END IF
   #-----END MOD-A40025-----
   CALL s_showmsg_init()
   FOREACH p201_cs INTO l_sfa03,l_sfa08,l_sfa26,l_sfb25,l_sfb13,req_qty   #CHI-A30039 add sfb13
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         IF g_bgerr THEN
             CALL s_errmsg("","","p201_cs",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","p201_cs",0)
         END IF
         EXIT FOREACH
      END IF
      #--->產生備料數量
      OPEN p201_cssfa USING l_sfa03
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","p210_cssfa",SQLCA.sqlcode,1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","p210_cssfa",0)
            EXIT FOREACH
         END IF
      END IF
      FETCH p201_cssfa INTO al_qty
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","p210_cssfa",SQLCA.sqlcode,1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","p210_cssfa",0)
            EXIT FOREACH
         END IF
      END IF
      #--->產生獨立性數量
      OPEN p201_csrpc USING l_sfa03
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","p201_csrpc",SQLCA.sqlcode,1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","p201_csrpc",0)
            EXIT FOREACH
         END IF
      END IF
      FETCH p201_csrpc INTO rpc_qty
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg("","","p201_csrpc",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","p201_csrpc",0)
               EXIT FOREACH
            END IF
         END IF
         #--->產生請購數量
      OPEN p201_cspml USING l_sfa03
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg("","","p201_cspml",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","p201_cspml",0)
               EXIT FOREACH
            END IF
         END IF
      FETCH p201_cspml INTO pr_qty
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg("","","p201_cspml",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","p201_cspml",0)
               EXIT FOREACH
            END IF
         END IF
         #--->產生採購數量
      OPEN p201_cspmn USING l_sfa03
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg("","","p201_cspmn",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","p201_cspmn",0)
               EXIT FOREACH
            END IF
         END IF
      FETCH p201_cspmn INTO po_qty
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg("","","p201_cspmn",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","p201_cspmn",0)
               EXIT FOREACH
            END IF
         END IF
      #--->產生採購檢驗量
      OPEN p201_csrvb  USING l_sfa03
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg("","","p201_csrvb",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","p201_csrvb",0)
               EXIT FOREACH
            END IF
         END IF
      FETCH p201_csrvb INTO qc_qty
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg("","","p201_csrvb",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","p201_csrvb",0)
               EXIT FOREACH
            END IF
         END IF
      #--->產生工單數量
      OPEN p470_c_sfb USING l_sfa03
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg("","","p470_c_sfb",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","p470_c_sfb",0)
               EXIT FOREACH
            END IF
         END IF
      FETCH p470_c_sfb INTO wo_qty
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg("","","p470_c_sfb",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("","","","",SQLCA.sqlcode,"","p470_c_sfb",0)
               EXIT FOREACH
            END IF
         END IF
      IF req_qty IS NULL OR req_qty = ' ' THEN LET req_qty = 0 END IF
      IF al_qty  IS NULL OR al_qty = ' '  THEN LET al_qty = 0  END IF
      IF rpc_qty IS NULL OR rpc_qty = ' ' THEN LET rpc_qty = 0 END IF
      IF pr_qty  IS NULL OR pr_qty = ' '  THEN LET pr_qty = 0  END IF
      IF po_qty  IS NULL OR po_qty = ' '  THEN LET po_qty = 0  END IF
      IF qc_qty  IS NULL OR qc_qty = ' '  THEN LET qc_qty = 0  END IF
      IF wo_qty  IS NULL OR wo_qty = ' '  THEN LET wo_qty = 0  END IF
      LET al_qty = (al_qty + rpc_qty) - req_qty
      INSERT INTO apm_p470 VALUES(l_sfa03,l_sfa26,l_sfb25,req_qty,al_qty,   
                                  pr_qty,po_qty,qc_qty,wo_qty)
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         IF g_bgerr THEN
            CALL s_errmsg("sfa03",l_sfa03,"insert",SQLCA.sqlcode,1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("ins","apm_p470",l_sfa03,"",SQLCA.sqlcode,"","insert",0)
            EXIT FOREACH
         END IF
      END IF
      #--->產生請購單身檔
      IF NOT s_industry('slk') THEN
         LET g_where = NULL
      END IF
      CALL p201_ins_detail(p_type,p_pmm01,l_pmm13,l_sfa08,l_sfa03,l_sfa26,l_sfb13,req_qty,qc_qty,    #CHI-A30039 sfb25-->sfb13
                        po_qty,pr_qty,wo_qty,al_qty,g_where)  
      IF g_success = 'N' THEN EXIT FOREACH END IF
   END FOREACH	
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   CALL s_showmsg()
END FUNCTION 
FUNCTION p201_detailini(p_type,p_pmm01)                                                                                                              
DEFINE p_type     LIKE type_file.chr1
DEFINE p_pmm01    LIKE pmm_file.pmm01
   IF p_type = '1' THEN
      SELECT pmk02,pmk25,pmk45,pmk13 INTO g_pmk.pmk02,g_pmk.pmk25,g_pmk.pmk45 ,g_pmk.pmk13
                         FROM pmk_file WHERE pmk01 = g_pmk.pmk01
      LET g_pml2.pml01 = g_pmk.pmk01
      LET g_pml2.pml011 =g_pmk.pmk02
      LET g_pml2.pml16 = g_pmk.pmk25
      LET g_pml2.pml14 = g_sma.sma886[1,1]
      LET g_pml2.pml15  =g_sma.sma886[2,2]
      LET g_pml2.pml23 = 'Y'
      LET g_pml2.pml38 = g_pmk.pmk45
      LET g_pml2.pml43 = 0
      LET g_pml2.pml431 = 0
      LET g_pml2.pml11 = 'N'
      LET g_pml2.pml13  = 0
      LET g_pml2.pml21  = 0
      LET g_pml2.pml16 = g_pmk.pmk25
      LET g_pml2.pml30 = 0
      LET g_pml2.pml32 = 0
      LET g_pml2.pml18 = ' '
      LET g_pml2.pml49 = ' '
      LET g_pml2.pml50 = '1'
      LET g_pml2.pml53 = ' '
      LET g_pml2.pml54 = ' '
      LET g_pml2.pml56 = ' '
      LET g_pml2.pml91 = ' '
   ELSE
      SELECT pmm02,pmm25,pmm45 INTO g_pmn.pmn011,g_pmn.pmn16,g_pmn.pmn38
        FROM pmm_file WHERE pmm01 = p_pmm01
      LET g_pmn.pmn01 = p_pmm01
      LET g_pmn.pmn14 = g_sma.sma886[1,1]
      LET g_pmn.pmn15 = g_sma.sma886[2,2]
      LET g_pmn.pmn23 = 'Y'
      LET g_pmn.pmn43 = 0
      LET g_pmn.pmn431 = 0
      LET g_pmn.pmn11 = 'N'
      #LET g_pmn.pmn13 = 0 MOD-C80116
      LET g_pmn.pmn30 = 0
      LET g_pmn.pmn32 = 0
      LET g_pmn.pmn18 = ' '
      LET g_pmn.pmn50 = 0
      LET g_pmn.pmn51 = 0
      LET g_pmn.pmn53 = 0
      LET g_pmn.pmn55 = 0
      LET g_pmn.pmn57 = 0
      LET g_pmn.pmn58 = 0       #TQC-9B0203 add
      LET g_pmn.pmn62 = 1
      LET g_pmn.pmn73 = ' '
      LET g_pmn.pmn76 = ' '
      LET g_pmn.pmn65 ='1' #MOD-D60195 add
   END IF
END FUNCTION
 
FUNCTION p201_ins_detail(p_type,p_pmm01,p_pmm13,p_sfa08,p_sfa03,
                      p_sfa26,p_sfb13,p_req_qty,p_qc_qty,p_po_qty,   #CHI-A30039 sfb25-->sfb13
                      p_pr_qty,p_wo_qty,p_al_qty,p_sfcislk01)  
  DEFINE p_sfa03     LIKE sfa_file.sfa03,
         p_pmm01     LIKE pmm_file.pmm01,
         p_pmm13     LIKE pmm_file.pmm13,
         p_sfa08     LIKE sfa_file.sfa08,
         p_type      LIKE type_file.chr1,
         p_sfa26     LIKE type_file.chr1,
         p_sfb13     LIKE sfb_file.sfb13,   #CHI-A30039 sfb25-->sfb13
         p_sfcislk01 LIKE sfci_file.sfcislk01,
         p_req_qty   LIKE pml_file.pml20,
         p_qc_qty    LIKE pml_file.pml20,
         p_po_qty    LIKE pml_file.pml20,
         p_pr_qty    LIKE pml_file.pml20,
         p_wo_qty    LIKE pml_file.pml20,
         p_al_qty    LIKE pml_file.pml20,
         su_qty      LIKE pml_file.pml20,
         sh_qty      LIKE pml_file.pml20,
         l_ima01     LIKE ima_file.ima01,
         l_ima02     LIKE ima_file.ima02,
         l_ima05     LIKE ima_file.ima05,
         l_ima25     LIKE ima_file.ima25,
         l_ima27     LIKE ima_file.ima27,
#         l_ima262    LIKE ima_file.ima262, #FUN-A20044
         l_avl_stk,l_avl_stk_mpsmrp,l_unavl_stk    LIKE type_file.num15_3, #FUN-A20044
         l_ima44     LIKE ima_file.ima44,
         l_ima44_fac LIKE ima_file.ima44_fac,
         l_ima45     LIKE ima_file.ima45,
         l_ima46     LIKE ima_file.ima46,
         l_ima49     LIKE ima_file.ima49,
         l_ima491    LIKE ima_file.ima491,
         l_ima55     LIKE ima_file.ima55,
         l_factor    LIKE ima_file.ima31_fac,
         l_flag      LIKE type_file.chr1,
         l_supply    LIKE pml_file.pml20,
         l_demand    LIKE pml_file.pml20,
         l_pan       LIKE type_file.num10,
         l_double    LIKE type_file.num10,
         l_term      LIKE pmc_file.pmc49,
         l_payment   LIKE pmc_file.pmc17
DEFINE   l_cnt       LIKE type_file.num5
DEFINE   l_ima906    LIKE ima_file.ima906
DEFINE   l_ima907    LIKE ima_file.ima907
DEFINE   l_ima908    LIKE ima_file.ima908
DEFINE   l_pmli      RECORD LIKE pmli_file.*
DEFINE   l_pmm       RECORD LIKE pmm_file.*
DEFINE   l_cnt2      LIKE type_file.num5, #TQC-BC0027
         l_pml20     LIKE pml_file.pml20  #TQC-BC0027
DEFINE   l_ima07     LIKE ima_file.ima07 #MOD-C80116         
 
#   SELECT ima01,ima02,ima05,ima25,ima262,ima27,ima44,ima44_fac, #FUN-A20044
   SELECT ima01,ima02,ima05,ima25,0,ima27,ima44,ima44_fac, #FUN-A20044
          ima45,ima46,ima49,ima491,ima25,ima908
#     INTO l_ima01,l_ima02,l_ima05,l_ima25,l_ima262,l_ima27, #FUN-A20044
     INTO l_ima01,l_ima02,l_ima05,l_ima25,l_avl_stk,l_ima27, #FUN-A20044
          l_ima44,l_ima44_fac,l_ima45,l_ima46,
          l_ima49,l_ima491,l_ima25,l_ima908
     FROM ima_file
    WHERE ima01 = p_sfa03
       CALL s_getstock(p_sfa03,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ima_file",p_sfa03,"",SQLCA.sqlcode,"","sel ima",1)  
      LET g_success = 'N'
      RETURN
   END IF
   
   IF p_type = '1' THEN
      LET g_pml2.pml02 = g_seq
      LET g_pml2.pml04 = l_ima01
      LET g_pml2.pml041= l_ima02
      LET g_pml2.pml05 = NULL 
      LET g_pml2.pml07 = l_ima44
      LET g_pml2.pml08 = l_ima25
      CALL s_umfchk(g_pml2.pml04,g_pml2.pml07,l_ima25) RETURNING l_cnt,g_pml2.pml09
      IF l_cnt = 1 THEN LET g_pml2.pml09=1 END IF
      LET g_pml2.pml42 = p_sfa26
      IF g_pml2.pml42  = '2' THEN LET g_pml2.pml42 = '1' END IF
      IF g_pml2.pml42  = 'S' THEN LET g_pml2.pml42 = '0' END IF
      IF g_pml2.pml42  = 'U' THEN LET g_pml2.pml42 = '0' END IF
   ELSE 
      LET g_pmn.pmn02  = g_seq
      LET g_pmn.pmn04  = l_ima01
      LET g_pmn.pmn041 = l_ima02
      LET g_pmn.pmn05  = NULL
      LET g_pmn.pmn07  = l_ima44
      LET g_pmn.pmn08  = l_ima25
      LET g_pmn.pmn61  = g_pmn.pmn04
      CALL s_umfchk(g_pmn.pmn04,g_pmn.pmn07,l_ima25) RETURNING l_cnt,g_pmn.pmn09
      IF l_cnt = 1 THEN LET g_pmn.pmn09 = 1 END IF
      LET g_pmn.pmn42  = p_sfa26
      IF g_pmn.pmn42   = '2' THEN LET g_pmn.pmn42 = '1' END IF
      IF g_pmn.pmn42   = 'S' THEN LET g_pmn.pmn42 = '0' END IF
      IF g_pmn.pmn42   = 'U' THEN LET g_pmn.pmn42 = '0' END IF
      #MOD-D70165 mark beg-------- 
    #MOD-C80116 add beg----
#      LET l_ima07=' '
#      SELECT ima07 INTO l_ima07 FROM ima_file
#       WHERE ima01=g_pmn.pmn04
#      CASE l_ima07
#           WHEN 'A' LET g_pmn.pmn13=g_sma.sma341/100
#           WHEN 'B' LET g_pmn.pmn13=g_sma.sma342/100
#           WHEN 'C' LET g_pmn.pmn13=g_sma.sma343/100
#           OTHERWISE LET g_pmn.pmn13=0
#      END CASE   
    #MOD-C80116 add end----  
    #MOD-D70165 mark end-------- 
    CALL s_overate(g_pmn.pmn04) RETURNING g_pmn.pmn13  #MOD-D70165 add    
   END IF
#   LET l_ima262 = 0  #FUN-A20044
   LET l_avl_stk = 0  #FUN-A20044
   LET p_qc_qty = 0 
   LET p_pr_qty = 0 
   LET p_po_qty = 0 
   LET p_wo_qty = 0 
   LET p_al_qty = 0 
   LET sh_qty = p_req_qty + p_al_qty -
#                (l_ima262 + p_qc_qty + p_po_qty + p_pr_qty + p_wo_qty )#FUN-A20044
                (l_avl_stk + p_qc_qty + p_po_qty + p_pr_qty + p_wo_qty )#FUN-A20044
 
   #-->缺料量如大於本次需求則以本次需求為主
   IF sh_qty > p_req_qty THEN
      LET su_qty = p_req_qty
   ELSE 
      LET su_qty = sh_qty
   END IF
 
   #-->建議量 = 缺料量 + 安全庫存量
   IF tm.g = 'Y' AND su_qty > 0 THEN 
      LET su_qty = su_qty  +  l_ima27
   END IF
 
   #-->考慮最少採購量/倍量
   IF su_qty > 0 THEN
      IF su_qty < l_ima46 THEN
         IF p_type = '1' THEN
            LET g_pml2.pml20 = l_ima46
         ELSE
            LET g_pmn.pmn20 = l_ima46
         END IF
      ELSE
         IF l_ima45 > 0 THEN
            LET l_pan = (su_qty*1000) MOD (l_ima45 *1000)
            IF l_pan !=0
            THEN LET l_double = (su_qty/l_ima45) + 1
            ELSE LET l_double = su_qty/l_ima45
            END IF
            IF p_type = '1' THEN
               LET g_pml2.pml20  = l_double * l_ima45
            ELSE
               LET g_pmn.pmn20 = l_double * l_ima45
            END IF
         ELSE
            IF p_type = '1' THEN
               LET g_pml2.pml20 = su_qty
            ELSE
               LET g_pmn.pmn20 = su_qty
            END IF
         END IF
      END IF
   ELSE
      IF p_type = '1' THEN
         LET g_pml2.pml20 = 0
      ELSE 
         LET g_pmn.pmn20 = 0
      END IF
   END IF

    #TQC-BC0027 begin #如果此工單已經轉過請購單,則採購數量依據請購單的數量
   IF p_type != '1' THEN      
       SELECT COUNT(*) INTO l_cnt2 
         FROM pml_file 
        WHERE pml01 = g_pmn.pmn24
          AND pml02 = g_pmn.pmn25 
       IF l_cnt2 > 0 THEN  #此工單已經轉過請購單
          SELECT pml20 INTO l_pml20
            FROM pml_file 
           WHERE pml01 = g_pmn.pmn24
             AND pml02 = g_pmn.pmn25
          LET g_pmn.pmn20 =  l_pml20   
       END IF 
   END IF                    
    #TQC-BC0027  end 
 
   CALL s_umfchk(l_ima01,l_ima25,l_ima44) RETURNING l_flag,l_factor    
   IF l_flag THEN
      CALL cl_err(l_ima44,'mfg1206',0)
   ELSE
      IF p_type = '1' THEN
         LET g_pml2.pml20=g_pml2.pml20*l_factor
      ELSE
         LET g_pmn.pmn20 = g_pmn.pmn20*l_factor
      END IF
   END IF
   LET g_pml2.pml20= s_digqty(g_pml2.pml20 ,g_pml2.pml07)  #FUN-910088--add--
   LET g_pmn.pmn20 = s_digqty(g_pmn.pmn20,g_pmn.pmn07)     #FUN-BB0085
   IF p_type = '1' THEN
      LET g_pml2.pml35 = p_sfb13   #CHI-A30039 sfb25-->sfb13
      CALL s_aday(g_pml2.pml35,-1,l_ima491) RETURNING g_pml2.pml34
      CALL s_aday(g_pml2.pml34,-1,l_ima49) RETURNING g_pml2.pml33
   ELSE
      LET g_pmn.pmn35 = p_sfb13   #CHI-A30039 sfb25-->sfb13
      CALL s_aday(g_pmn.pmn35,-1,l_ima491) RETURNING g_pmn.pmn34
      CALL s_aday(g_pmn.pmn34,-1,l_ima49) RETURNING g_pmn.pmn33
   END IF
 
   IF g_sma.sma115 = 'Y' THEN
      SELECT ima44,ima906,ima907 INTO l_ima44,l_ima906,l_ima907
        FROM ima_file 
       WHERE ima01 = p_sfa03
      IF p_type = '1' THEN
         LET g_pml2.pml80 = g_pml2.pml07
         LET l_factor = 1
         CALL s_umfchk(g_pml2.pml04,g_pml2.pml80,l_ima44)
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET g_pml2.pml81=l_factor
         LET g_pml2.pml82=g_pml2.pml20
         LET g_pml2.pml83=l_ima907
         LET l_factor = 1
         CALL s_umfchk(g_pml2.pml04,g_pml2.pml83,l_ima44)
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET g_pml2.pml84=l_factor
         LET g_pml2.pml85=0
         IF l_ima906 = '3' THEN
            LET g_pml2.pml84=l_factor
            LET l_factor = 1
            CALL s_umfchk(g_pml2.pml04,g_pml2.pml80,g_pml2.pml83)
                 RETURNING l_cnt,l_factor
            IF l_cnt = 1 THEN
               LET l_factor = 1
            END IF
            LET g_pml2.pml85=g_pml2.pml82*l_factor
            LET g_pml2.pml85 = s_digqty(g_pml2.pml85,g_pml2.pml83)   #FUN-910088--add--
         END IF
      ELSE
         LET g_pmn.pmn80 = g_pmn.pmn07
         LET l_factor = 1
         CALL s_umfchk(g_pmn.pmn04,g_pmn.pmn80,l_ima44)
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET g_pmn.pmn81=l_factor
         LET g_pmn.pmn82=g_pmn.pmn20
         LET g_pmn.pmn83=l_ima907
         LET l_factor = 1
         CALL s_umfchk(g_pmn.pmn04,g_pmn.pmn83,l_ima44)
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET g_pmn.pmn84=l_factor
         LET g_pmn.pmn85=0
         IF l_ima906 = '3' THEN
            LET g_pmn.pmn84=l_factor
            LET l_factor = 1
            CALL s_umfchk(g_pmn.pmn04,g_pmn.pmn80,g_pmn.pmn83)
                 RETURNING l_cnt,l_factor
            IF l_cnt = 1 THEN
               LET l_factor = 1
            END IF
            LET g_pmn.pmn85=g_pmn.pmn82*l_factor
            LET g_pmn.pmn85=s_digqty(g_pmn.pmn85,g_pmn.pmn83)   #FUN-BB0085
         END IF
      END IF
   END IF
   IF p_type = '1' THEN
      IF cl_null(l_ima908) THEN LET l_ima908 = g_pml2.pml07 END IF   
      IF g_sma.sma116 NOT MATCHES '[13]' THEN
         LET g_pml2.pml86 = g_pml2.pml07
      ELSE
         LET g_pml2.pml86 = l_ima908
      END IF
      CALL p470_set_pml87(g_pml2.pml04,g_pml2.pml07,
                          g_pml2.pml86,g_pml2.pml20) RETURNING g_pml2.pml87
      LET g_pml2.pml87 = s_digqty(g_pml2.pml87,g_pml2.pml86)   #FUN-910088--add--
      #預設統購否pml190
      IF cl_null(g_pml2.pml190) THEN
           SELECT ima913,ima914 INTO g_pml2.pml190,g_pml2.pml191
            FROM ima_file
           WHERE ima01 = g_pml2.pml04
          IF STATUS = 100 THEN
              LET g_pml2.pml190 = 'N'
          END IF
      END IF
      LET g_pml2.pml930=s_costcenter(g_pmk.pmk13)
      LET g_pml2.pml192 = 'N'#拋轉否
      INITIALIZE g_pml2.pml25 TO NULL
 
      #FUN-980006 add plant & legal 
      LET g_pml2.pmlplant = g_plant 
      LET g_pml2.pmllegal = g_legal 
      #FUN-980006 end plant & legal 
      LET g_pml2.pml92 = 'N' #FUN-9A0065 
      INSERT INTO pml_file VALUES(g_pml2.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","pml_file",g_pml2.pml01,g_pml2.pml02,SQLCA.sqlcode,"","ins pml2",1)  
         LET g_success = 'N'
      END IF
      IF NOT s_industry('std') THEN
         INITIALIZE l_pmli.* TO NULL
         LET l_pmli.pmli01 = g_pml2.pml01
         LET l_pmli.pmli02 = g_pml2.pml02
         LET l_pmli.pmlislk01 = p_sfcislk01
         IF NOT s_ins_pmli(l_pmli.*,'') THEN
            LET g_success='N'
         END IF
      END IF
   ELSE
      IF cl_null(l_ima908) THEN LET l_ima908 = g_pmn.pmn07 END IF
   
      IF g_sma.sma116 NOT MATCHES '[13]' THEN
         LET g_pmn.pmn86 = g_pmn.pmn07
      ELSE
         LET g_pmn.pmn86 = l_ima908
      END IF
      CALL p470_set_pml87(g_pmn.pmn04,g_pmn.pmn07,
                          g_pmn.pmn86,g_pmn.pmn20) RETURNING g_pmn.pmn87
      LET g_pmn.pmn87=s_digqty(g_pmn.pmn87,g_pmn.pmn86)   #FUN-BB0085
      SELECT * INTO l_pmm.* FROM pmm_file WHERE pmm01=p_pmm01
      SELECT pmc17,pmc49 INTO l_payment,l_term FROM pmc_file
       WHERE pmc01=l_pmm.pmm09
      #CALL s_defprice(g_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,   #TQC-9B0214--mark--
      CALL s_defprice_new(g_pmn.pmn04,l_pmm.pmm09,l_pmm.pmm22,l_pmm.pmm04,    #TQC-9B0214--add--
                      g_pmn.pmn87,p_sfa08,l_pmm.pmm21,l_pmm.pmm43,"2",
                      g_pmn.pmn86,'',l_term,l_payment,g_plant)  #TQC-9B0214--add g_plant
         RETURNING g_pmn.pmn31,g_pmn.pmn31t,g_pmn.pmn73,g_pmn.pmn74   #TQC-AC0257 add g_pmn.pmn73,g_pmn.pmn74
      IF cl_null(g_pmn.pmn31) THEN
         LET g_pmn.pmn31=0
         LET g_pmn.pmn31t=0
      END IF
      IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF   #TQC-AC0257 add
      LET g_pmn.pmn930=s_costcenter(p_pmm13)
      #INITIALIZE g_pmn.pmn25 TO NULL   #MOD-A40025
 
      #FUN-980006 add plant & legal 
      LET g_pmn.pmnplant = g_plant 
      LET g_pmn.pmnlegal = g_legal 
      #FUN-980006 end plant & legal 

      #TQC-BC0027 begin #F對採購單含稅,未稅總價進行賦值
      LET g_pmn.pmn88  = g_pmn.pmn87 * g_pmn.pmn31  #未稅總價 = 計價數量 * 未稅單價 
      LET g_pmn.pmn88t = g_pmn.pmn87 * g_pmn.pmn31t #含稅總價 = 計價數量 * 含稅單價
      IF cl_null(g_pmn.pmn88) THEN LET g_pmn.pmn88 = 0 END IF  
      IF cl_null(g_pmn.pmn88t) THEN LET g_pmn.pmn88t = 0 END IF 
      IF cl_null(g_pmn.pmn63) THEN LET g_pmn.pmn63 = 'N' END IF #TQC-BC0027 #急料否
      IF cl_null(g_pmn.pmn64) THEN LET g_pmn.pmn64 = 'N' END IF #TQC-BC0027 #保稅否
      IF cl_null(g_pmn.pmn89) THEN LET g_pmn.pmn89 = 'N' END IF #TQC-BC0027 #VMI採購否
      #TQC-BC0027  end
       
      IF cl_null(g_pmn.pmn58) THEN LET g_pmn.pmn58 = 0 END IF   #TQC-9B0203
      IF cl_null(g_pmn.pmn012) THEN LET g_pmn.pmn012 = ' ' END IF   #TQC-A70004
#No.FUN-AB0067--begin   
      IF NOT s_chk_ware(g_pmn.pmn52) THEN
         LET g_success = 'N'
         RETURN 
      END IF  
#No.FUN-AB0067--end  
      CALL s_schdat_pmn78(g_pmn.pmn41,g_pmn.pmn012,g_pmn.pmn43,g_pmn.pmn18,   #FUN-C10002
                                      g_pmn.pmn32) RETURNING g_pmn.pmn78      #FUN-C10002    
      SELECT sfb96 INTO g_pmn.pmn100 FROM sfb_file WHERE sfb01 = g_pmn.pmn24  #FUN-D40042 add

      INSERT INTO pmn_file VALUES(g_pmn.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","pmn_file",g_pmn.pmn01,g_pmn.pmn02,SQLCA.sqlcode,"","ins pmn",1)  
         LET g_success = 'N'
      END IF
      
   END IF
      
 
   LET g_seq = g_seq + 1
END FUNCTION
FUNCTION t201sub_exp_po(p_sfb01)
  DEFINE p_sfb01  LIKE sfb_file.sfb01,
         l_buf    LIKE oay_file.oayslip
  DEFINE l_pmm  RECORD LIKE pmm_file.*
  DEFINE l_pmm01  LIKE pmm_file.pmm01,
         l_sfb40  LIKE sfb_file.sfb40
  DEFINE l_sql    STRING 
  DEFINE l_cnt    LIKE type_file.num5 
  DEFINE li_cnt   LIKE type_file.num5
  DEFINE l_ima54  LIKE ima_file.ima54
  DEFINE l_pmm01_conf DYNAMIC ARRAY OF  LIKE pmm_file.pmm01
  DEFINE l_i,l_n      LIKE type_file.num5
  DEFINE l_gfa   RECORD LIKE gfa_file.*
  DEFINE l_sfb   RECORD LIKE sfb_file.*
  DEFINE l_slip  LIKE oay_file.oayslip
  DEFINE p_row,p_col LIKE type_file.num5
  DEFINE l_prog_t STRING
 
   WHENEVER ERROR CONTINUE                #忽略一切錯誤
 
   #重新讀取資料
   SELECT * INTO l_sfb.* FROM sfb_file
    WHERE sfb01=p_sfb01
   IF cl_null(l_sfb.sfb01) THEN RETURN END IF
   #截取單據別                                                                                                                   
   LET l_buf = s_get_doc_no(l_sfb.sfb01)                                                                                         
   #取自動化設定值                                                                                                               
   SELECT * INTO l_gfa.*  FROM gfa_file                                                                                          
     WHERE gfa01 = '1'   #1:axmt410                                                                                              
       AND gfa02 = l_buf                                                                                                         
       AND gfa03 = 'apmt540'                                                                                                     
       AND gfaacti = 'Y'                                                                                                         
 
 
   LET li_cnt = 0
  #檢查是否都有設定主供應商
   SELECT COUNT(*) INTO li_cnt 
     FROM sfa_file,sfb_file,ima_file
    WHERE ima01 = sfa27 
      AND sfa01 = sfb01
      AND (ima54 IS NULL OR ima54 = '')
      AND sfb01 = l_sfb.sfb01
   IF li_cnt > 0 THEN
      CALL cl_err('','apm-571',0)
      LET g_totsuccess = 'N'
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_cnt = 0 
   LET l_sql ="SELECT COUNT(*)",
                 "  FROM pmm_file,pmn_file,sfb_file",
                 " WHERE sfb01 = pmn01",
                 "   AND pmm01 = pmn01 ", #TQC-BC0027 add
                 "   AND sfb01 = '",l_sfb.sfb01,"'",
                 "   AND pmm18 != 'X' "
   PREPARE t201sub_sel_pmn FROM l_sql
   EXECUTE t201sub_sel_pmn INTO l_cnt
   IF l_cnt >0  THEN
      CALL cl_err('','axm-581',0)
      LET g_totsuccess = 'N'
      LET g_success = 'N'
      RETURN
   END IF
 
   LET g_success = 'Y'
   BEGIN WORK        
   LET l_i = 0 
   LET l_sql = "SELECT DISTINCT ima54 FROM ima_file,sfa_file,sfb_file ",
               " WHERE ima01 = sfa27 ",
               "   AND sfb01 = sfa01 ",
               "   AND sfb01 = '",l_sfb.sfb01 CLIPPED,"'"
   PREPARE ima_pre  FROM l_sql
   DECLARE ima_cur CURSOR FOR ima_pre
   CALL s_showmsg_init()
   FOREACH ima_cur INTO l_ima54
      IF g_success = "N" THEN                                                                                                        
         LET g_totsuccess = "N"                                                                                                      
         LET g_success = "Y"                                                                                                         
      END IF                                                                                                                         
      CALL t201sub_ins_pmm(slip,l_ima54,l_sfb.*) RETURNING l_pmm01
      IF g_success = 'Y' THEN
         CALL t201sub_ins_pmn_exp(l_pmm01,l_ima54,l_sfb.*)
         IF g_success = 'N' THEN  EXIT FOREACH  END IF
         #TQC-C10063 add begin---------------------
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM pmn_file
          WHERE pmn01 = l_pmm01
         IF l_cnt = 0 THEN
            DELETE FROM pmm_file WHERE pmm01=l_pmm01
            CONTINUE FOREACH
         END IF
         #TQC-C10063 add end-----------------------

         #TQC-C10062 add begin---------------------
         IF cl_null(g_no) THEN
            LET g_no = l_pmm01
         ELSE
            LET g_no = g_no,'|',l_pmm01
         END IF
         #TQC-C10062 add end-----------------------
          IF l_gfa.gfa06 = 'Y' THEN
            LET l_i = l_i + 1
            LET l_pmm01_conf[l_i] = l_pmm01 
          END IF
      ELSE
        EXIT FOREACH
      END IF
   END FOREACH
   #採購單自動確認段
   IF l_gfa.gfa06 = 'Y' THEN
      FOR l_n = 1 TO l_i
         SELECT pmm_file.* INTO l_pmm.* 
           FROM pmm_file
          WHERE pmm01 = l_pmm01_conf[l_n]
         CALL t540sub_y_chk(l_pmm.*)          
         IF g_success = "Y" THEN
            CALL t540sub_y_upd(l_pmm.pmm01,'') 
         END IF
      END FOR
   END IF
   IF g_totsuccess="N" THEN                                                                                                       
      LET g_success="N"                                                                                                           
   END IF                                      
   CALL s_showmsg()                                                                                   
   IF g_success = 'Y' THEN
      #COMMIT WORK                #MOD-B90093 mark
      LET l_prog_t = g_prog
      LET g_prog = 'apmt540'
      CALL cl_flow_notify(l_pmm01,'I')
      LET g_prog = l_prog_t
   ELSE
      LET g_totsuccess = 'N'
      #ROLLBACK WORK               #MOD-B90093 mark
   END IF
END FUNCTION
 
FUNCTION t201sub_ins_pmm(p_slip,p_ima54,l_sfb)
   DEFINE p_ima54  LIKE ima_file.ima54
   DEFINE l_pmm    RECORD LIKE pmm_file.*
   DEFINE li_result LIKE type_file.num5  
   DEFINE l_t1     LIKE type_file.chr5
   DEFINE l_sfb    RECORD LIKE sfb_file.*
   DEFINE l_gec07  LIKE gec_file.gec07
   DEFINE p_slip   LIKE type_file.chr5
   DEFINE l_formid LIKE smy_file.smyslip
   
   WHENEVER ERROR CONTINUE                #忽略一切錯誤
   INITIALIZE l_pmm.* TO NULL
          
   CALL s_check_no("apm",p_slip,"","2","pmm_file","pmm01","")
      RETURNING li_result,l_pmm.pmm01
   CALL s_auto_assign_no("apm",l_pmm.pmm01,g_today,"","pmm_file","pmm01","","","")             
        RETURNING li_result,l_pmm.pmm01
  #MOD-D20115 mark start -----
  ##TQC-BC0027 add begin
  ##LET l_pmm.pmm02 = 'REG'       #單號性質 #TQC-BC0027 mark
  #IF l_sfb.sfb02 MATCHES '[78]' THEN 
  #   LET l_pmm.pmm02 = 'SUB'
  #ELSE 
  #MOD-D20115 mark end   -----
   	  LET l_pmm.pmm02 = 'REG'
  #END IF  #MOD-D20115 mark 
   #TQC-BC0027 add end   
   LET l_pmm.pmm03 = '0'         #更動序號
   LET l_pmm.pmm04 = g_today     #採購日期
   LET l_pmm.pmm05 = l_sfb.sfb27 #專案號碼
   LET l_pmm.pmm09 = p_ima54     #供應商
#  LET l_pmm.pmm51 = ' '         #FUN-B70015 mark
   LET l_pmm.pmm51 = '1'         #FUN-B70015
   LET l_pmm.pmmpos= 'N'
   LET l_pmm.pmmcrat= g_today
   SELECT azn02,azn04 INTO l_pmm.pmm31,l_pmm.pmm32
     FROM azn_file WHERE azn01 = l_pmm.pmm04
   SELECT pmc15,pmc16,pmc17,pmc47,pmc22,pmc49            
     INTO l_pmm.pmm10,l_pmm.pmm11,l_pmm.pmm20,l_pmm.pmm21,l_pmm.pmm22,l_pmm.pmm41
     FROM pmc_file                                                                                                            
          WHERE pmc01=l_pmm.pmm09
   LET l_pmm.pmm18 ='N'
   LET l_pmm.pmm25 ='0'
 
   IF g_aza.aza17 = l_pmm.pmm22 THEN   #本幣
      LET l_pmm.pmm42 = 1
   ELSE
      CALL s_curr3(l_pmm.pmm22,l_pmm.pmm04,'S')
         RETURNING l_pmm.pmm42
   END IF
 
   SELECT gec04,gec07 INTO l_pmm.pmm43,l_gec07 FROM gec_file  
          WHERE gec01= l_pmm.pmm21 AND gec011='1'
   IF SQLCA.SQLCODE THEN LET l_pmm.pmm43 = 0
   ELSE IF cl_null(l_pmm.pmm43) THEN LET l_pmm.pmm43 = 0 END IF END IF
   LET l_pmm.pmm30 = 'N' 
   LET l_pmm.pmm45 ='N'   
   LET l_formid = s_get_doc_no(l_sfb.sfb01)
      SELECT smyapr INTO l_pmm.pmmmksg FROM smy_file
      WHERE smyslip=l_formid
   LET l_pmm.pmmacti ='Y'
   LET l_pmm.pmmprsw ='Y'
   LET l_pmm.pmmuser =g_user
   LET l_pmm.pmmgrup =g_grup
   LET l_pmm.pmmdate =TODAY
   LET l_pmm.pmm12 =g_user #TQC-BC0027
   LET l_pmm.pmm13 =g_grup #TQC-BC0027
   #-----CHI-A30039---------
   #LET l_pmm.pmm909  ='5'
  #MOD-D20115 mark start -----
  #IF l_sfb.sfb02 = '7' OR l_sfb.sfb02 = '8' THEN
  #   LET l_pmm.pmm909 = '5'
  #ELSE
  #MOD-D20115 mark start -----
      LET l_pmm.pmm909 = '2'
  #END IF  #MOD-D20115 mark
   #-----END CHI-A30039-----
   LET l_pmm.pmm905  ='N'
 
   #FUN-980006 add plant & legal 
   LET l_pmm.pmmplant = g_plant 
   LET l_pmm.pmmlegal = g_legal 
   #FUN-980006 end plant & legal 
 
   LET l_pmm.pmmoriu = g_user      #No.FUN-980030 10/01/04
   LET l_pmm.pmmorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO pmm_file VALUES(l_pmm.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
       CALL cl_err3("ins","pmm_file",l_pmm.pmm01,"",SQLCA.sqlcode,"","ins pmm",1)  
       LET g_success = 'N'
   END IF         
   RETURN l_pmm.pmm01
END FUNCTION      
 
FUNCTION t201sub_ins_pmn_exp(l_pmm01,l_ima54,l_sfb)
 DEFINE l_pmm01  LIKE pmm_file.pmm01,
        l_ima54  LIKE ima_file.ima54   
 DEFINE l_qty    LIKE oeb_file.oeb12
 DEFINE l_sfa    RECORD LIKE sfa_file.*
 DEFINE l_sfb    RECORD LIKE sfb_file.*
 DEFINE l_oea    RECORD LIKE oea_file.*
 DEFINE l_sql    STRING
 
   WHENEVER ERROR CONTINUE                #忽略一切錯誤
  
   LET l_sql = "SELECT sfa_file.* FROM sfa_file,sfb_file,ima_file",
               "   WHERE sfb01 = '",l_sfb.sfb01,"'",
               "     AND ima01 = sfa27 ",
               "     AND ima54 = '",l_ima54,"'",
               "     AND sfb01 = sfa01 "
   PREPARE t201sub_sfb_pre2 FROM l_sql
   DECLARE t201sub_sfb_curs2 CURSOR FOR t201sub_sfb_pre2 
   FOREACH t201sub_sfb_curs2 INTO l_sfa.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','',"foreach:",SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      CALL p201_dis_detail(l_sfb.sfb01,'2',l_sfa.sfa03,l_pmm01)
   END FOREACH
   IF g_success = 'Y' THEN
      CALL t201sub_upd_pmm_amount(l_pmm01)
   END IF
END FUNCTION
FUNCTION t201sub_upd_pmm_amount(l_pmm01)
  DEFINE l_pmm01  LIKE pmm_file.pmm01
  DEFINE l_tot_pmm40   LIKE pmm_file.pmm40,
         l_tot_pmm40t  LIKE pmm_file.pmm40t
  DEFINE l_pmm22  LIKE pmm_file.pmm22
  DEFINE t_azi04  LIKE azi_file.azi04
 
  SELECT pmm22 INTO l_pmm22 FROM pmm_file WHERE pmm01 = l_pmm01
 
  SELECT SUM(pmn88),SUM(pmn88t)
    INTO l_tot_pmm40,l_tot_pmm40t
    FROM pmn_file
   WHERE pmn01 = l_pmm01
  IF SQLCA.sqlcode OR l_tot_pmm40 IS NULL THEN
     LET l_tot_pmm40 = 0
     LET l_tot_pmm40t= 0   
  END IF
 
  SELECT azi04 INTO t_azi04 FROM azi_file
   WHERE azi01 = l_pmm22 AND aziacti = 'Y'
 
  CALL cl_digcut(l_tot_pmm40,t_azi04) RETURNING l_tot_pmm40  
  CALL cl_digcut(l_tot_pmm40t,t_azi04) RETURNING l_tot_pmm40t  
 
  UPDATE pmm_file SET pmm40 = l_tot_pmm40,  #未稅總金額
                      pmm40t= l_tot_pmm40t  #含稅總金額
    WHERE pmm01 = l_pmm01
  IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","pmm_file",l_pmm01,"",SQLCA.sqlcode,"","update pmm40",0)
      LET g_success = 'N'
  END IF
END FUNCTION
FUNCTION p201_detail_pr()
DEFINE l_pmk01 LIKE pmk_file.pmk01
   LET l_pmk01 = ' '
   SELECT DISTINCT pmk01 INTO l_pmk01
     FROM pmk_file,pml_file,sfb_file
    WHERE pmk01 = pml01 
      AND pml24 = g_sfb1[l_ac1].sfb01
      AND pmk18 != 'X'
   IF NOT cl_null(l_pmk01) THEN
      LET g_msg = " apmt420 '",l_pmk01 CLIPPED,"'"                                                               
            CALL cl_cmdrun_wait(g_msg CLIPPED)
   END IF
END FUNCTION 
FUNCTION p201_detail_po()
DEFINE l_pmm01   LIKE pmm_file.pmm01
DEFINE l_wc      LIKE type_file.chr1000
DEFINE i         LIKE type_file.num5
   LET i = 0
   LET l_pmm01 = ' '
   DECLARE p201_pmm01_cs CURSOR FOR
   SELECT DISTINCT pmm01
     FROM pmm_file,pmn_file
    WHERE pmn01 = pmm01
      AND pmn24 = g_sfb1[l_ac1].sfb01
   FOREACH p201_pmm01_cs INTO l_pmm01
      LET i = i+1
      IF i=1 THEN
         LET l_wc = l_pmm01
      ELSE
         LET l_wc = l_wc,"' OR pmm01='",l_pmm01
      END IF
   END FOREACH
   IF NOT cl_null(l_pmm01) THEN
      LET g_msg = " apmt540 '",l_wc CLIPPED,"'"                                                                        
         CALL cl_cmdrun_wait(g_msg CLIPPED)
   END IF
END FUNCTION
#No.FUN-960071
