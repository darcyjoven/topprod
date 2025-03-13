# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: ctc_pmi265.4gl
# Descriptions...: 委外采购待参数核价作业	
# Date & Author..: 2016/10/12 BY huanglf


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE
    g_tc_pmi           RECORD LIKE tc_pmi_file.*,
    g_tc_pmi_t         RECORD LIKE tc_pmi_file.*,
    g_tc_pmi_o         RECORD LIKE tc_pmi_file.*,
    g_tc_pmi01_t       LIKE tc_pmi_file.tc_pmi01,    #簽核等級 (舊值)
    g_t1            LIKE oay_file.oayslip,  #No.FUN-550060  #No.FUN-680136 VARCHAR(05)
    l_cnt           LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    g_tc_pmj           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
        tc_pmj02       LIKE tc_pmj_file.tc_pmj02,   #項次
        tc_pmj03       LIKE tc_pmj_file.tc_pmj03,   #料件編號
        tc_pmj031      LIKE tc_pmj_file.tc_pmj031,  #品名規格
        tc_pmj032      LIKE tc_pmj_file.tc_pmj032,  #規格
        tc_pmj11      LIKE tc_pmj_file.tc_pmj11,
        tc_pmj04       LIKE tc_pmj_file.tc_pmj04,   #廠商料號
        ima44       LIKE ima_file.ima44,   #FUN-560193
        ima908      LIKE ima_file.ima908,  #FUN-560193
        tc_pmj10       LIKE tc_pmj_file.tc_pmj10,   #作業編號 NO:7178 add
        ecd02       LIKE ecd_file.ecd02,   #作業名稱 #No.FUN-930061
        ecbud02     LIKE ecb_file.ecbud02, #add by guanyao160730
        tc_pmj13       LIKE tc_pmj_file.tc_pmj13,   #單元編號 No.FUN-810017
        tc_pmjicd14    LIKE tc_pmj_file.tc_pmjicd14,  #FUN-A30072
        tc_pmj05       LIKE tc_pmj_file.tc_pmj05,   #幣別
        tc_pmj06       LIKE tc_pmj_file.tc_pmj06,   #原單價
        tc_pmj06t      LIKE tc_pmj_file.tc_pmj06t,  #原含稅單價     No.FUN-550019
        tc_pmj07       LIKE tc_pmj_file.tc_pmj07,   #新單價
        tc_pmj07t      LIKE tc_pmj_file.tc_pmj07t,  #新含稅單價     No.FUN-550019
        tc_pmj08       LIKE tc_pmj_file.tc_pmj08,   #原核准日
        tc_pmj09       LIKE tc_pmj_file.tc_pmj09,   #新核准日
        tc_pmj14       LIKE tc_pmj_file.tc_pmj14,   #電子採購序號   No.FUN-9C0046 ---add
        tc_pmj15       LIKE tc_pmj_file.tc_pmj15,  #add by huanglf161025
        tc_pmj16       LIKE tc_pmj_file.tc_pmj16,  #add by huanglf161025
        tc_pmj17       LIKE tc_pmj_file.tc_pmj17,  #add by huanglf161025
        tc_pmj18       LIKE tc_pmj_file.tc_pmj18,  #add by huanglf161025
        tc_pmj19       LIKE tc_pmj_file.tc_pmj19,  #add by huanglf161025
        tc_pmj20       LIKE tc_pmj_file.tc_pmj20,  #add by huanglf161025
        tc_pmj21       LIKE tc_pmj_file.tc_pmj21   #add by huanglf161025
                    END RECORD,
    g_tc_pmj_t         RECORD                 #程式變數 (舊值)
        tc_pmj02       LIKE tc_pmj_file.tc_pmj02,   #項次
        tc_pmj03       LIKE tc_pmj_file.tc_pmj03,   #料件編號
        tc_pmj031      LIKE tc_pmj_file.tc_pmj031,  #品名規格
        tc_pmj032      LIKE tc_pmj_file.tc_pmj032,  #規格
        tc_pmj11      LIKE tc_pmj_file.tc_pmj11,
        tc_pmj04       LIKE tc_pmj_file.tc_pmj04,   #廠商料號
        ima44       LIKE ima_file.ima44,   #FUN-560193   
        ima908      LIKE ima_file.ima908,  #FUN-560193
        tc_pmj10       LIKE tc_pmj_file.tc_pmj10,   #作業編號 NO:7178 add
        ecd02       LIKE ecd_file.ecd02,   #作業名稱 #No.FUN-930061
        ecbud02     LIKE ecb_file.ecbud02, #add by guanyao160730
        tc_pmj13       LIKE tc_pmj_file.tc_pmj13,   #單元編號 No.FUN-810017
        tc_pmjicd14    LIKE tc_pmj_file.tc_pmjicd14,  #FUN-A30072
        tc_pmj05       LIKE tc_pmj_file.tc_pmj05,   #幣別
        tc_pmj06       LIKE tc_pmj_file.tc_pmj06,   #原單價
        tc_pmj06t      LIKE tc_pmj_file.tc_pmj06t,  #原含稅單價     No.FUN-550019
        tc_pmj07       LIKE tc_pmj_file.tc_pmj07,   #新單價
        tc_pmj07t      LIKE tc_pmj_file.tc_pmj07t,  #新含稅單價     No.FUN-550019
        tc_pmj08       LIKE tc_pmj_file.tc_pmj08,   #原核准日
        tc_pmj09       LIKE tc_pmj_file.tc_pmj09,   #新核准日
        tc_pmj14       LIKE tc_pmj_file.tc_pmj14,   #電子採購序號   No.FUN-9C0046 ---add
        tc_pmj15       LIKE tc_pmj_file.tc_pmj15,  #add by huanglf161025
        tc_pmj16       LIKE tc_pmj_file.tc_pmj16,  #add by huanglf161025
        tc_pmj17       LIKE tc_pmj_file.tc_pmj17,  #add by huanglf161025
        tc_pmj18       LIKE tc_pmj_file.tc_pmj18,  #add by huanglf161025
        tc_pmj19       LIKE tc_pmj_file.tc_pmj19,  #add by huanglf161025
        tc_pmj20       LIKE tc_pmj_file.tc_pmj20,  #add by huanglf161025
        tc_pmj21       LIKE tc_pmj_file.tc_pmj21   #add by huanglf161025
                    END RECORD,
    g_tc_pmj_o         RECORD                 #程式變數 (舊值)
        tc_pmj02       LIKE tc_pmj_file.tc_pmj02,   #項次
        tc_pmj03       LIKE tc_pmj_file.tc_pmj03,   #料件編號
        tc_pmj031      LIKE tc_pmj_file.tc_pmj031,  #品名規格
        tc_pmj032      LIKE tc_pmj_file.tc_pmj032,  #規格
        tc_pmj11      LIKE tc_pmj_file.tc_pmj11,
        tc_pmj04       LIKE tc_pmj_file.tc_pmj04,   #廠商料號
        ima44       LIKE ima_file.ima44,   #FUN-560193  
        ima908      LIKE ima_file.ima908,  #FUN-560193
        tc_pmj10       LIKE tc_pmj_file.tc_pmj10,   #作業編號 NO:7178 add
        ecd02       LIKE ecd_file.ecd02,   #作業名稱 #No.FUN-930061
        ecbud02     LIKE ecb_file.ecbud02, #add by guanyao160730
        tc_pmj13       LIKE tc_pmj_file.tc_pmj13,   #單元編號 No.FUN-810017
        tc_pmjicd14    LIKE tc_pmj_file.tc_pmjicd14,  #FUN-A30072
        tc_pmj05       LIKE tc_pmj_file.tc_pmj05,   #幣別
        tc_pmj06       LIKE tc_pmj_file.tc_pmj06,   #原單價
        tc_pmj06t      LIKE tc_pmj_file.tc_pmj06t,  #原含稅單價     No.FUN-550019
        tc_pmj07       LIKE tc_pmj_file.tc_pmj07,   #新單價
        tc_pmj07t      LIKE tc_pmj_file.tc_pmj07t,  #新含稅單價     No.FUN-550019
        tc_pmj08       LIKE tc_pmj_file.tc_pmj08,   #原核准日
        tc_pmj09       LIKE tc_pmj_file.tc_pmj09,   #新核准日
        tc_pmj14       LIKE tc_pmj_file.tc_pmj14,   #電子採購序號   No.FUN-9C0046 ---add
        tc_pmj15       LIKE tc_pmj_file.tc_pmj15,  #add by huanglf161025
        tc_pmj16       LIKE tc_pmj_file.tc_pmj16,  #add by huanglf161025
        tc_pmj17       LIKE tc_pmj_file.tc_pmj17,  #add by huanglf161025
        tc_pmj18       LIKE tc_pmj_file.tc_pmj18,  #add by huanglf161025
        tc_pmj19       LIKE tc_pmj_file.tc_pmj19,  #add by huanglf161025
        tc_pmj20       LIKE tc_pmj_file.tc_pmj20,  #add by huanglf161025
        tc_pmj21       LIKE tc_pmj_file.tc_pmj21   #add by huanglf161025
                    END RECORD,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,   #單身筆數  #No.FUN-680136 SMALLINT
    g_rec_bc        LIKE type_file.num5,   #No.FUN-680136 SMALLINT  #單身筆數(分量計價)
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
    g_sta           LIKE type_file.chr20,  #No.FUN-680136 VARCHAR(20)
    g_gec07         LIKE gec_file.gec07,   #No.Fun-550019
    tm              RECORD
                    wc    LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(500)
                    END RECORD,
    g_message       LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(80)
 
DEFINE g_argv1         LIKE tc_pmi_file.tc_pmi01    #核價單號.  #FUN-580120
DEFINE g_argv2           STRING               #指定執行的功能 #TQC-630074
DEFINE g_laststage   LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)                    #FUN-580120
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE g_chr          LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE g_chr2         LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE g_chr3         LIKE type_file.chr1    #FUN-580120  #No.FUN-680136 VARCHAR(1)
DEFINE g_cnt          LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_cnt1         LIKE type_file.num10   #MOD-710094 add
DEFINE g_i            LIKE type_file.num5    #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE g_msg          LIKE ze_file.ze03      #No.FUN-680136 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_jump         LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_no_ask      LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE g_cmd          LIKE type_file.chr1000 #MOD-530616    #MOD-590361  #No.FUN-680136 VARCHAR(300)
DEFINE g_tmp01        LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE g_tmp_file     STRING
DEFINE g_argv3        LIKE tc_pmj_file.tc_pmj12  #No.FUN-670099
DEFINE g_tc_pmj12        LIKE tc_pmj_file.tc_pmj12  #No.FUN-670099
DEFINE g_tc_pmi10        LIKE tc_pmi_file.tc_pmi10  #No.CHI-880028
DEFINE g_buf          string               #No.TQC-9A0145
 
MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS                                #改變一些系統預設值
         INPUT NO WRAP
      DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   END IF
  
   LET g_argv3 = ARG_VAL(1)   #No.TQC-740122 LET g_argv3=ARG_VAL(3) 
   LET g_argv1 = ARG_VAL(2)
   LET g_argv2 = ARG_VAL(3)
   
   IF g_argv3 = "1" THEN
      LET g_prog="cpmi255"
      LET g_tc_pmj12 = "1"
   ELSE
      LET g_prog="cpmi265"
      LET g_tc_pmj12= "2"
   END IF 
   LET g_tc_pmi10=g_tc_pmj12                   #No.CHI-880028 Add
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CPM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM tc_pmi_file WHERE tc_pmi01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i255_cl CURSOR FROM g_forupd_sql
 
    IF fgl_getenv('EASYFLOW') = "1" THEN
          LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
    END IF
 
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
    
        OPEN WINDOW i255_w WITH FORM "cpm/42f/cpmi255"
           ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
        CALL cl_set_locale_frm_name("cpmi255")   #No.FUN-670099
        CALL cl_ui_init()
    
        IF g_tc_pmj12 = "1" THEN
            CALL cl_set_comp_visible("tc_pmj10,ecd02,ecbud02",FALSE)#No.FUN-930061 add ecd02 #add ecbud02 by guanyao160730
        END IF


        #FUN-A30072--begin--add----------------
        IF g_tc_pmj12 = '1' OR NOT s_industry('icd') THEN
           CALL cl_set_comp_visible("tc_pmjicd14",FALSE)
        END IF
        IF g_tc_pmj12 = '2' AND s_industry('icd') THEN
           CALL cl_set_comp_required("tc_pmjicd14",TRUE)
        END IF
        #FUN-A30072--end--add------------------

        IF g_tc_pmj12 = "1" THEN
            CALL cl_set_comp_visible("tc_pmj13",FALSE)
        END IF

        #TQC-D50088---add--begin-------------
        IF g_aza.aza95 = 'N' THEN
           CALL cl_set_comp_visible("tc_pmj14",FALSE)
        END IF
        #TQC-D50088---add--end---------------

        #FUN-D50104--add-begin--
        IF g_tc_pmj12 = "2" THEN
           CALL cl_set_comp_bgcolor("tc_pmj10,tc_pmj13", "achromatism")#背景色設置成無色
        END IF
        #FUN-D50104--add-end--
    
    END IF
 
    #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
    #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
    CALL aws_efapp_toolbar()    #FUN-580120
    
   #將aws_gpmcli_toolbar()移到aws_efapp_toolbar()之後
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
       IF g_aza.aza71 MATCHES '[Yy]' THEN 
          CALL aws_gpmcli_toolbar()
          CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
       ELSE
          CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
       END IF
   END IF
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i255_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i255_a()
            END IF
         WHEN "efconfirm"
            LET g_action_choice = "efconfirm"        #FUN-A10043 add
            CALL i255_q()
            CALL i255sub_y_chk(g_tc_pmi.tc_pmi01)          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               CALL i255sub_y_upd(g_tc_pmi.tc_pmi01, g_action_choice, g_tc_pmj12)    #CALL 原確認的 update 段
            END IF
            EXIT PROGRAM
         OTHERWISE
            CALL i255_q()
 
      END CASE
   END IF
 
   #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
   #CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, #FUN-D20025 mark
   #locale, void, confirm, undo_confirm,easyflow_approval") #FUN-D20025 mark
   #FUN-D20025 add
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, 
   locale, void, undo_void, confirm, undo_confirm,easyflow_approval")
   #FUN-D20025 add 
          RETURNING g_laststage
 
   IF (g_sma.sma116 MATCHES '[02]') THEN   #No.FUN-610076
      CALL cl_set_comp_visible("ima908",FALSE)
   END IF
 
   CALL i255_menu()
   CLOSE WINDOW i255_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i255_cs()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031  HCN
 
IF NOT cl_null(g_argv1) THEN
   LET g_wc = " tc_pmi01 = '",g_argv1,"'"  #FUN-580120
   LET g_wc2= ' 1=1'
ELSE
 
   CLEAR FORM                             #清除畫面
   CALL g_tc_pmj.clear()
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_tc_pmi.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON tc_pmi01,tc_pmi02,tc_pmi09,tc_pmi03,tc_pmi08,tc_pmi081,tc_pmi04, #FUN-630044
                             tc_pmi05,tc_pmi07,tc_pmi06,
                             tc_pmiconf,tc_pmiuser,tc_pmigrup,tc_pmimodu,tc_pmidate,tc_pmiacti,
                             tc_pmioriu,tc_pmiorig   #TQC-B80231  add
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON ACTION controlp
         CASE
 
            WHEN INFIELD(tc_pmi01) #核價單號
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_tc_pmi"
               LET g_qryparam.default1 = g_tc_pmi.tc_pmi01
               LET g_qryparam.where = " tc_pmi10 ='",g_tc_pmi10,"'" #MOD-C10044 add
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_pmi01
               NEXT FIELD tc_pmi01
 
            WHEN INFIELD(tc_pmi09) #申請人
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_pmi09
               NEXT FIELD tc_pmi09
 
            WHEN INFIELD(tc_pmi03) #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_pmc1"
               LET g_qryparam.default1 = g_tc_pmi.tc_pmi03
               CALL cl_create_qry() RETURNING g_tc_pmi.tc_pmi03
               DISPLAY BY NAME g_tc_pmi.tc_pmi03
               CALL i255_tc_pmi03('d')
               NEXT FIELD tc_pmi03
            WHEN INFIELD(tc_pmi08)   #稅別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gec"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " gec011='1' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_pmi08
                 NEXT FIELD tc_pmi08
            OTHERWISE EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
		#No.FUN-580031 --end--       HCN
 
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
   LET g_wc = g_wc CLIPPED," AND tc_pmi10 ='",g_tc_pmi10,"'"         #No.CHI-880028 Add
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_pmiuser', 'tc_pmigrup')
 
 
   CONSTRUCT g_wc2 ON tc_pmj02,tc_pmj03,tc_pmj031,tc_pmj032,tc_pmj11,tc_pmj04,tc_pmj10,tc_pmjicd14,tc_pmj05,		 #FUN-A30072
                      tc_pmj06,tc_pmj06t,tc_pmj07,tc_pmj07t,    #No.FUN-550019
                      tc_pmj08,tc_pmj09,tc_pmj13,tc_pmj14,tc_pmj15,tc_pmj16,tc_pmj17,tc_pmj18,tc_pmj19,tc_pmj20,tc_pmj21  #add by huanglf161031   #add by huanglf161025             #No.FUN-810017 Add tc_pmj13
           FROM s_pmj[1].tc_pmj02,s_pmj[1].tc_pmj03,s_pmj[1].tc_pmj031,s_pmj[1].tc_pmj032,s_pmj[1].tc_pmj11,
                s_pmj[1].tc_pmj04,s_pmj[1].tc_pmj10,s_pmj[1].tc_pmjicd14,s_pmj[1].tc_pmj05,	 #FUN-A30072
                s_pmj[1].tc_pmj06,s_pmj[1].tc_pmj06t,    #No.FUN-550019
                s_pmj[1].tc_pmj07,s_pmj[1].tc_pmj07t,    #No.FUN-550019
                s_pmj[1].tc_pmj08,s_pmj[1].tc_pmj09,s_pmj[1].tc_pmj13,s_pmj[1].tc_pmj14, #No.FUN-810017 
                s_pmj[1].tc_pmj15,s_pmj[1].tc_pmj16,s_pmj[1].tc_pmj17,s_pmj[1].tc_pmj18,
                s_pmj[1].tc_pmj19,s_pmj[1].tc_pmj20,s_pmj[1].tc_pmj21  #add by huanglf161031
     #No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION controlp
           CASE
              WHEN INFIELD(tc_pmj03) #料件編號
#FUN-AA0059 --Begin--
                #   CALL cl_init_qry_var()
                #   LET g_qryparam.state ="c"
                #   LET g_qryparam.form ="q_ima"
                #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                   DISPLAY g_qryparam.multiret TO tc_pmj03
                   NEXT FIELD tc_pmj03
              WHEN INFIELD(tc_pmj05)     #幣別
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_azi"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tc_pmj05
                   NEXT FIELD tc_pmj05
              WHEN INFIELD(tc_pmj13)                                                                                               
                CALL cl_init_qry_var()                                                                                          
                LET g_qryparam.state = 'c'                                                                                      
                LET g_qryparam.form ="q_sga"                                                                                    
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                DISPLAY g_qryparam.multiret TO tc_pmj13                                                                            
                NEXT FIELD tc_pmj13                                                                                                
              WHEN INFIELD(tc_pmj10)     #作業編號
                 CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_pmj10
                 NEXT FIELD tc_pmj10
              WHEN INFIELD(tc_pmj11)                                                                                               
                CALL cl_init_qry_var()                                                                                          
                LET g_qryparam.state = 'c'                                                                                      
                LET g_qryparam.form ="q_ecb12"                                                                                    
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                DISPLAY g_qryparam.multiret TO tc_pmj11                                                                            
                NEXT FIELD tc_pmj11 
              OTHERWISE EXIT CASE
           END CASE
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
   END CONSTRUCT
END IF  #FUN-580120
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF cl_null(g_wc2) THEN LET g_wc2 = ' 1=1' END IF 
   
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  tc_pmi_file.tc_pmi01 FROM tc_pmi_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY tc_pmi01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE  tc_pmi_file.tc_pmi01 ",
                  "  FROM tc_pmi_file, tc_pmj_file ",
                  " WHERE tc_pmi01 = tc_pmj01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " AND tc_pmj12='",g_tc_pmj12,"'",
                  " ORDER BY tc_pmi01"
   END IF
 
   PREPARE i255_prepare FROM g_sql
   DECLARE i255_cs                         #CURSOR
       SCROLL CURSOR WITH HOLD FOR i255_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM tc_pmi_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(UNIQUE tc_pmi01) FROM tc_pmi_file,tc_pmj_file WHERE ",
                "tc_pmj01=tc_pmi01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " AND tc_pmj12='",g_tc_pmj12,"'"     #MOD-7A0085-add
   END IF
   PREPARE i255_precount FROM g_sql
   DECLARE i255_count CURSOR FOR i255_precount
 
END FUNCTION
 
FUNCTION i255_menu()
   DEFINE l_creator     LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)  #FUN-580120
   DEFINe l_flowuser    LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)         # 是否有指定加簽人員      #FUN-580120
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
 
   LET l_flowuser = "N"
 
   WHILE TRUE
      CALL i255_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i255_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i255_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i255_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i255_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i255_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               #CALL i255_b()   #mark by guanyao160525
               CALL i255_b('i') #add by guanyao160525
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i255_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "pricing_by_qty"
            IF cl_chk_act_auth() THEN
               IF g_tc_pmi.tc_pmi05 = 'Y' THEN
                  #控管單身未輸入資料
                  LET g_cnt=0
                  SELECT COUNT(*) INTO g_cnt
                    FROM tc_pmj_file
                    WHERE tc_pmj01=g_tc_pmi.tc_pmi01 #MOD-540067 變數寫錯,修正
                  IF g_cnt>=1 THEN
                     LET g_tmp_file = FGL_GETPID() USING '<<<<<<<<<<'
                     LET g_tmp_file = "tmp_",g_tmp_file CLIPPED,"_file"  #MOD-560241
                     LET g_cmd = "tc_pmi255c '",g_tc_pmi.tc_pmi01 CLIPPED,"' ", #MOD-530616
                                 "'", g_tc_pmj[l_ac].tc_pmj02, "' '", g_tc_pmj[l_ac].tc_pmj03 ,"' ",
                                 "'", g_tc_pmj[l_ac].tc_pmj031,"' '", g_tc_pmj[l_ac].tc_pmj032,"' ",
                                 "'", g_tc_pmj[l_ac].tc_pmj11,"' '", g_tc_pmj[l_ac].tc_pmj05, "' ",
                                 "'", g_prog CLIPPED,"' '", ##MOD-560241
                                 g_tmp_file CLIPPED,"' '",g_tc_pmj[l_ac].tc_pmj10,"'"  #No.FUN-670099
                     CALL cl_cmdrun_wait(g_cmd) #MOD-530612
 
                     IF g_tc_pmi.tc_pmiconf='N' AND g_tc_pmi.tc_pmi06 NOT MATCHES '[Ss]' THEN
                        LET g_sql = "SELECT tmp01 FROM ",g_tmp_file CLIPPED
                        PREPARE tmp_prep FROM g_sql
                        IF STATUS THEN CALL cl_err('tmp_prep:',status,1) RETURN -1 END IF
                        DECLARE tmp_curs CURSOR FOR tmp_prep
                        OPEN tmp_curs
                        FETCH tmp_curs INTO g_tmp01
 
                        IF g_tmp01 <> g_tc_pmi.tc_pmi06 THEN
                           UPDATE tc_pmi_file set tc_pmi06=g_tmp01 where tc_pmi01= g_tc_pmi.tc_pmi01
                        END IF
 
                     END IF
                     LET g_sql = "DROP TABLE ",g_tmp_file CLIPPED   #TQC-8C0068
                     PREPARE drop_prep FROM g_sql   #TQC-8C0068
                     EXECUTE drop_prep   #TQC-8C0068
                     SELECT tc_pmi06 INTO g_tc_pmi.tc_pmi06 FROM tc_pmi_file where tc_pmi01 = g_tc_pmi.tc_pmi01
                     DISPLAY BY NAME g_tc_pmi.tc_pmi06
                     CALL i255_pic()            #FUN-920106
                  ELSE
                     CALL cl_err('','arm-034',1)
                  END IF
               ELSE
                  #不是分量計價資料
                  CALL cl_err(g_tc_pmi.tc_pmi01,'apm-286',1)
               END IF
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i255sub_y_chk(g_tc_pmi.tc_pmi01)          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                   CALL i255sub_y_upd(g_tc_pmi.tc_pmi01, g_action_choice, g_tc_pmj12)      #CALL 原確認的 update 段
                   CALL i255sub_refresh(g_tc_pmi.tc_pmi01) RETURNING g_tc_pmi.*   #FUN-920106 重新讀取g_tc_pmi
                   CALL i255_show()                                      #FUN-920106         
                END IF
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i255_z()
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL i255_x() #FUN-D20025 mark
               CALL i255_x(1) #FUN-D20025 add
            END IF
         #FUN-D20025 add
         WHEN "undo_void"          #"取消作廢"
            IF cl_chk_act_auth() THEN
               CALL i255_x(2)
            END IF
         #FUN-D20025 add      
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_pmj),'','')
            END IF
       #@WHEN "簽核狀況"
          WHEN "approval_status"               # BUG-4C0041   #MOD-4A0299
            IF cl_chk_act_auth() THEN  #DISPLAY ONLY
               IF aws_condition2() THEN
                    CALL aws_efstat2()     #MOD-560007
               END IF
            END IF
 
 #@WHEN "准"
         WHEN "agree"
              IF g_laststage = "Y" AND l_flowuser = 'N' THEN #最後一關
                 CALL i255sub_y_upd(g_tc_pmi.tc_pmi01, g_action_choice, g_tc_pmj12)      #CALL 原確認的 update 段
                 CALL i255sub_refresh(g_tc_pmi.tc_pmi01) RETURNING g_tc_pmi.*   #FUN-920106 重新讀取g_tc_pmi
                 CALL i255_show()                                      #FUN-920106         
              ELSE
                 LET g_success = "Y"
                 IF NOT aws_efapp_formapproval() THEN
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
                    IF cl_confirm('aws-081') THEN
                       IF aws_efapp_getnextforminfo() THEN
                          LET l_flowuser = 'N'
                          LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                          IF NOT cl_null(g_argv1) THEN
                                CALL i255_q()
                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                                CALL aws_efapp_flowaction("insert, modify,
                                delete, reproduce, detail, query, locale,
                                void,undo_void,confirm, undo_confirm,easyflow_approval")#FUN-D20025 add undo_void
                                      RETURNING g_laststage
                          ELSE
                              EXIT WHILE
                          END IF
                        ELSE
                              EXIT WHILE
                        END IF
                    ELSE
                       EXIT WHILE
                    END IF
              END IF
 
         #@WHEN "不准"
         WHEN "deny"
             IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN
                IF aws_efapp_formapproval() THEN
                   IF l_creator = "Y" THEN
                      LET g_tc_pmi.tc_pmi06 = 'R'
                      DISPLAY BY NAME g_tc_pmi.tc_pmi06
                   END IF
                   IF cl_confirm('aws-081') THEN
                      IF aws_efapp_getnextforminfo() THEN
                          LET l_flowuser = 'N'
                          LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                          IF NOT cl_null(g_argv1) THEN
                                CALL i255_q()
                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                                CALL aws_efapp_flowaction("insert, modify,
                                delete,reproduce, detail, query, locale,void,undo_void,
                                confirm, undo_confirm,easyflow_approval") #FUN-D20025 add undo_void
                                      RETURNING g_laststage
                          ELSE
                                EXIT WHILE
                          END IF
                      ELSE
                            EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                END IF
              END IF
 
         #@WHEN "加簽"
         WHEN "modify_flow"
              IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                 LET l_flowuser = 'Y'
              ELSE
                 LET l_flowuser = 'N'
              END IF
 
         #@WHEN "撤簽"
         WHEN "withdraw"
              IF cl_confirm("aws-080") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
         #@WHEN "抽單"
         WHEN "org_withdraw"
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
        #@WHEN "簽核意見"
         WHEN "phrase"
              CALL aws_efapp_phrase()
 
 
         WHEN "easyflow_approval"     #MOD-4A0299
           IF cl_chk_act_auth() THEN
               #FUN-C20026 add str---
                SELECT * INTO g_tc_pmi.* FROM tc_pmi_file
                 WHERE tc_pmi01 = g_tc_pmi.tc_pmi01
                CALL i255_show()
                CALL i255_b_fill(' 1=1')
               #FUN-C20026 add end---
                CALL i255_ef()
                CALL i255_show()  #FUN-C20026 add
           END IF

#str---add by guanyao160525
         WHEN "price_u"
            IF cl_chk_act_auth() THEN
               CALL i255_b('p')
            END IF 
#end---add by guanyao160525
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_pmi.tc_pmi01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_pmi01"
                 LET g_doc.value1 = g_tc_pmi.tc_pmi01
                 CALL cl_doc()
               END IF
         END IF
 
         #@WHEN GPM規範顯示   
         WHEN "gpm_show"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_partnum = g_tc_pmj[l_ac].tc_pmj03 END IF
              LET l_supplierid = g_tc_pmi.tc_pmi03
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
         #@WHEN GPM規範查詢
         WHEN "gpm_query"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_partnum = g_tc_pmj[l_ac].tc_pmj03 END IF
              LET l_supplierid = g_tc_pmi.tc_pmi03
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i255_a()
DEFINE li_result LIKE type_file.num5                     #No.FUN-550060  #No.FUN-680136 SMALLINT
 DEFINE l_tc_pmi01  LIKE tc_pmi_file.tc_pmi01
   MESSAGE ""
   CLEAR FORM
   CALL g_tc_pmj.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_tc_pmi.* LIKE tc_pmi_file.*             #DEFAULT 設定
   LET g_tc_pmi01_t = NULL
   LET g_tc_pmi.tc_pmi02 = g_today
   #預設值及將數值類變數清成零
   LET g_tc_pmi_t.* = g_tc_pmi.*
   LET g_tc_pmi_o.* = g_tc_pmi.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_tc_pmi.tc_pmiuser=g_user
      LET g_tc_pmi.tc_pmioriu = g_user #FUN-980030
      LET g_tc_pmi.tc_pmiorig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_tc_pmi.tc_pmigrup=g_grup
      LET g_tc_pmi.tc_pmidate=g_today
      LET g_tc_pmi.tc_pmi06  ='0'              #開立
      LET g_tc_pmi.tc_pmiacti='Y'              #資料有效
      LET g_tc_pmi.tc_pmi10=g_tc_pmi10            #CHI-880028 Add
 
      LET g_tc_pmi.tc_pmi09=g_user                            
      CALL i255_tc_pmi09('d')
      IF NOT cl_null(g_errno) THEN
         LET g_tc_pmi.tc_pmi09 = ''
      END IF
 
      LET g_tc_pmi.tc_pmiconf='N'              #確認碼
      LET g_tc_pmi.tc_pmi05  ='N'              #分量計價 NO:7178
      LET g_tc_pmi.tc_pmiplant = g_plant  #FUN-980006 add
      LET g_tc_pmi.tc_pmilegal = g_legal  #FUN-980006 add
 
      CALL i255_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_tc_pmi.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_tc_pmi.tc_pmi01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      BEGIN WORK               #No.TQC-970093   dxfwo  add   
#      CALL s_auto_assign_no("apm",g_tc_pmi.tc_pmi01,g_tc_pmi.tc_pmi02,"5","tc_pmi_file","tc_pmi01","","","")
#        RETURNING li_result,g_tc_pmi.tc_pmi01
#      IF (NOT li_result) THEN
#         CONTINUE WHILE
#      END IF
      SELECT MAX(tc_pmi01) INTO l_tc_pmi01 FROM tc_pmi_file 
      LET g_tc_pmi.tc_pmi01=l_tc_pmi01[1,8]
      LET l_tc_pmi01=l_tc_pmi01[9,12]+1 USING '&&&&'
      LET g_tc_pmi.tc_pmi01=g_tc_pmi.tc_pmi01,l_tc_pmi01
      DISPLAY BY NAME g_tc_pmi.tc_pmi01
 
      INSERT INTO tc_pmi_file VALUES (g_tc_pmi.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("ins","tc_pmi_file",g_tc_pmi.tc_pmi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129  #No.FUN-B80088---上移一行調整至回滾事務前---
         ROLLBACK WORK #No:7857
         CONTINUE WHILE
      ELSE
         COMMIT WORK #No:7857
         CALL cl_flow_notify(g_tc_pmi.tc_pmi01,'I')
      END IF
 
      SELECT tc_pmi01 INTO g_tc_pmi.tc_pmi01 FROM tc_pmi_file
       WHERE tc_pmi01 = g_tc_pmi.tc_pmi01
      LET g_tc_pmi01_t = g_tc_pmi.tc_pmi01        #保留舊值
      LET g_tc_pmi_t.* = g_tc_pmi.*
      LET g_tc_pmi_o.* = g_tc_pmi.*
      CALL g_tc_pmj.clear()
 
       LET g_rec_b=0  #No.MOD-490280
      #CALL i255_b()                   #輸入單身   #mark by guanyao160525
       CALL i255_b('i') #add by guanyao160525
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i255_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_pmi.tc_pmi01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_tc_pmi.* FROM tc_pmi_file
    WHERE tc_pmi01=g_tc_pmi.tc_pmi01
 
   #檢查資料是否已確認
   IF g_tc_pmi.tc_pmiconf='Y' THEN
      CALL cl_err(g_tc_pmi.tc_pmiconf,'9003',0)
      RETURN
   END IF
 
   #檢查資料是否已作廢
   IF g_tc_pmi.tc_pmiconf='X' THEN
      CALL cl_err(g_tc_pmi.tc_pmiconf,'9024',0)
      RETURN
   END IF
 
   IF g_tc_pmi.tc_pmiacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tc_pmi.tc_pmi01,'mfg1000',0)
      RETURN
   END IF
 
    IF g_tc_pmi.tc_pmi06 matches '[Ss]' THEN          #MOD-4A0299
         CALL cl_err('','apm-030',0)
         RETURN
   END IF
 
#TQC-B40215 --begin--
#   IF g_tc_pmi.tc_pmi07 = 'Y' AND (g_tc_pmi.tc_pmi06 = '1' OR g_tc_pmi.tc_pmi06 = 'S') THEN #MOD-960211   
#      CALL cl_err(g_tc_pmi.tc_pmi01,'agl-160',0)
#      RETURN
#   END IF
#TQC-B40215 --end--
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tc_pmi01_t = g_tc_pmi.tc_pmi01
   BEGIN WORK
 
   OPEN i255_cl USING g_tc_pmi.tc_pmi01
   IF STATUS THEN
      CALL cl_err("OPEN i255_cl:", STATUS, 1)
      CLOSE i255_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i255_cl INTO g_tc_pmi.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_tc_pmi.tc_pmi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE i255_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i255_show()
 
   WHILE TRUE
      LET g_tc_pmi01_t = g_tc_pmi.tc_pmi01
      LET g_tc_pmi_o.* = g_tc_pmi.*
      LET g_tc_pmi.tc_pmimodu=g_user
      LET g_tc_pmi.tc_pmidate=g_today
      LET g_tc_pmi.tc_pmi10=g_tc_pmi10            #CHI-880028 Add
 
      CALL i255_i("u")                      #欄位更改
      SELECT COUNT(*) INTO g_cnt FROM tc_pmj_file
        WHERE tc_pmj01 = g_tc_pmi.tc_pmi01
 
      IF g_cnt > 0 THEN
         IF g_tc_pmi.tc_pmi05 ="Y" THEN
            CALL i255_update_price1()     
         ELSE
            CALL i255_update_price()  
         END IF		
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tc_pmi.*=g_tc_pmi_t.*
         CALL i255_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_tc_pmi.tc_pmi01 != g_tc_pmi01_t THEN            # 更改單號
#No.TQC-960300 ---start---
         UPDATE pmr_File SET pmr01 = g_tc_pmi.tc_pmi01
          WHERE pmr01 = g_tc_pmi01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pmr_file",g_tc_pmi01_t,"",SQLCA.sqlcode,"","pmr",1)
            CONTINUE WHILE 
         END IF
#No.TQC-960300 ---end---    
         UPDATE tc_pmj_file SET tc_pmj01 = g_tc_pmi.tc_pmi01
          WHERE tc_pmj01 = g_tc_pmi01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tc_pmj_file",g_tc_pmi01_t,"",SQLCA.sqlcode,"","tc_pmj",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      LET g_tc_pmi.tc_pmi06 = '0'
      UPDATE tc_pmi_file SET tc_pmi_file.* = g_tc_pmi.*
       WHERE tc_pmi01 = g_tc_pmi01_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","tc_pmi_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
   DISPLAY BY NAME g_tc_pmi.tc_pmi06              #MOD-4A0299
   CALL i255_pic()               #FUN-920106
 
   CLOSE i255_cl
   COMMIT WORK
   CALL i255_b_fill(g_wc2)                 #No.TQC-960300  
   CALL cl_flow_notify(g_tc_pmi.tc_pmi01,'U')
 
END FUNCTION
 
FUNCTION i255_i(p_cmd)
DEFINE
   l_pmc05   LIKE pmc_file.pmc05,
   l_pmc30   LIKE pmc_file.pmc30,
   l_n       LIKE type_file.num5,    #No.FUN-680136 SMALLINT
   li_result LIKE type_file.num5,    #No.FUN-550060  #No.FUN-680136 SMALLINT
   p_cmd     LIKE type_file.chr1     #a:輸入 u:更改  #No.FUN-680136 VARCHAR(1)
 
   DISPLAY BY NAME g_tc_pmi.tc_pmi02,g_tc_pmi.tc_pmiconf,g_tc_pmi.tc_pmiuser,g_tc_pmi.tc_pmimodu,
       g_tc_pmi.tc_pmigrup,g_tc_pmi.tc_pmidate,g_tc_pmi.tc_pmiacti,g_tc_pmi.tc_pmi07,g_tc_pmi.tc_pmi06
 
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT BY NAME g_tc_pmi.tc_pmioriu,g_tc_pmi.tc_pmiorig,g_tc_pmi.tc_pmi01,g_tc_pmi.tc_pmi02,g_tc_pmi.tc_pmi09,g_tc_pmi.tc_pmi03,#FUN-630044
                 g_tc_pmi.tc_pmi08,g_tc_pmi.tc_pmi081,g_tc_pmi.tc_pmi04,g_tc_pmi.tc_pmi05
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i255_set_entry(p_cmd)
         CALL i255_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("tc_pmi01")        #No.FUN-550060
 
      AFTER FIELD tc_pmi01
         #IF NOT cl_null(g_tc_pmi.tc_pmi01) THEN   #MOD-A10179
         IF NOT cl_null(g_tc_pmi.tc_pmi01) AND   #MOD-A10179
            (g_tc_pmi.tc_pmi01 <> g_tc_pmi_t.tc_pmi01 OR cl_null(g_tc_pmi_t.tc_pmi01))THEN   #MOD-A10179
             LET g_t1 = s_get_doc_no(g_tc_pmi.tc_pmi01)                          #TQC-960300
             CALL s_check_no("apm",g_tc_pmi.tc_pmi01,g_tc_pmi_t.tc_pmi01,"5","tc_pmi_file","tc_pmi01","")
               RETURNING li_result,g_tc_pmi.tc_pmi01
             DISPLAY BY NAME g_tc_pmi.tc_pmi01
             IF (NOT li_result) THEN
    	        NEXT FIELD tc_pmi01
             END IF
            SELECT smyapr INTO g_smy.smyapr FROM smy_file
             WHERE smyslip = g_t1
            IF cl_null(g_tc_pmi_t.tc_pmi01) OR (g_tc_pmi.tc_pmi01 != g_tc_pmi_t.tc_pmi01) THEN
               LET g_tc_pmi.tc_pmi07 = g_smy.smyapr
               DISPLAY g_tc_pmi.tc_pmi07 TO tc_pmi07
            END IF
         END IF
 
      AFTER FIELD tc_pmi09
          IF NOT cl_null(g_tc_pmi.tc_pmi09) THEN
             CALL i255_tc_pmi09('a')
             IF NOT cl_null(g_errno) THEN
                LET g_tc_pmi.tc_pmi09 = g_tc_pmi_t.tc_pmi09
                CALL cl_err(g_tc_pmi.tc_pmi09,g_errno,0)
                DISPLAY BY NAME g_tc_pmi.tc_pmi09 #
                NEXT FIELD tc_pmi09
             END IF
          ELSE
             DISPLAY '' TO FORMONLY.gen02
          END IF
 
      AFTER FIELD tc_pmi03                       #廠商編號
         IF NOT cl_null(g_tc_pmi.tc_pmi03) THEN
                IF (g_tc_pmi.tc_pmi03 != g_tc_pmi_o.tc_pmi03 ) THEN #MOD-570057
                   LET g_chr=NULL #MOD-570057
                END IF #MOD-570057
               CALL i255_tc_pmi03(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tc_pmi.tc_pmi03,g_errno,0)
                  LET g_tc_pmi.tc_pmi03 = g_tc_pmi_o.tc_pmi03
                  DISPLAY BY NAME g_tc_pmi.tc_pmi03
                  NEXT FIELD tc_pmi03
               END IF
               CALL i255_tc_pmi08(p_cmd)   #MOD-6B0005 add                                          
               IF NOT cl_null(g_errno) THEN
                  #TQC-C40022 mod str---------------------
                  #CALL cl_err(g_tc_pmi.tc_pmi03,g_errno,0)
                  #LET g_tc_pmi.tc_pmi03 = g_tc_pmi_o.tc_pmi03
                  #DISPLAY BY NAME g_tc_pmi.tc_pmi03
                  #NEXT FIELD tc_pmi03
                  CALL cl_err(g_tc_pmi.tc_pmi08,g_errno,0)
                  LET g_tc_pmi.tc_pmi08 = g_tc_pmi_o.tc_pmi08
                  DISPLAY BY NAME g_tc_pmi.tc_pmi08
                  NEXT FIELD tc_pmi08
                  #TQC-C40022 mod end---------------------
               END IF
            LET g_tc_pmi_o.tc_pmi03 = g_tc_pmi.tc_pmi03
         END IF
 
      AFTER FIELD tc_pmi08                  #稅別
         IF NOT cl_null(g_tc_pmi.tc_pmi08) THEN
            IF g_tc_pmi_o.tc_pmi08 IS NULL OR
               (g_tc_pmi_o.tc_pmi08 != g_tc_pmi.tc_pmi08 ) THEN
               IF p_cmd='u' THEN
                  IF cl_confirm2('axm-415',g_tc_pmi.tc_pmi08) THEN
                     CALL i255_tc_pmi08(p_cmd)
                  ELSE
                     LET g_tc_pmi.tc_pmi08 = g_tc_pmi_o.tc_pmi08
                     DISPLAY BY NAME g_tc_pmi.tc_pmi08
                     NEXT FIELD tc_pmi08
                  END IF
               ELSE
                  CALL i255_tc_pmi08(p_cmd)
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tc_pmi.tc_pmi08,g_errno,0)
                  LET g_tc_pmi.tc_pmi08 = g_tc_pmi_o.tc_pmi08
                  DISPLAY BY NAME g_tc_pmi.tc_pmi08
                  NEXT FIELD tc_pmi08
               END IF
            END IF
            LET g_tc_pmi_o.tc_pmi08 = g_tc_pmi.tc_pmi08
         END IF
 
      AFTER FIELD tc_pmi05 #分量計價
         IF NOT cl_null(g_tc_pmi.tc_pmi05) THEN
            IF g_tc_pmi.tc_pmi05 NOT MATCHES "[YN]" THEN     #欄位必須輸入Y或N,請重新輸入
               LET g_tc_pmi.tc_pmi05 = g_tc_pmi_t.tc_pmi05
               DISPLAY BY NAME g_tc_pmi.tc_pmi05
               CALL cl_err('','9061',0)
               NEXT FIELD tc_pmi05
            END IF
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION supplier_data
                  LET g_cmd = "atc_pmi600 ",g_tc_pmi.tc_pmi03 CLIPPED #MOD-530616 #FUN-7C0050
                 CALL cl_cmdrun(g_cmd)
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(tc_pmi01) #單據編號
               LET g_t1=s_get_doc_no(g_tc_pmi.tc_pmi01)     #No.FUN-550060
               CALL q_smy(FALSE,FALSE,g_t1,'APM','5') RETURNING g_t1 #TQC-670008
               LET g_tc_pmi.tc_pmi01=g_t1                   #No.FUN-550060
               DISPLAY BY NAME g_tc_pmi.tc_pmi01
               CALL i255_tc_pmi01('d')
               NEXT FIELD tc_pmi01
 
            WHEN INFIELD(tc_pmi09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_tc_pmi.tc_pmi09
                 CALL cl_create_qry() RETURNING g_tc_pmi.tc_pmi09
                 DISPLAY BY NAME g_tc_pmi.tc_pmi09
                 NEXT FIELD tc_pmi09
 
            WHEN INFIELD(tc_pmi03) #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc1"
               LET g_qryparam.default1 = g_tc_pmi.tc_pmi03
               CALL cl_create_qry() RETURNING g_tc_pmi.tc_pmi03
               DISPLAY BY NAME g_tc_pmi.tc_pmi03
               CALL i255_tc_pmi03('d')
               NEXT FIELD tc_pmi03
            WHEN INFIELD(tc_pmi08) #稅別
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gec"
               LET g_qryparam.default1 = g_tc_pmi.tc_pmi08
               LET g_qryparam.arg1     = '1'
               CALL cl_create_qry() RETURNING g_tc_pmi.tc_pmi08
               DISPLAY BY NAME g_tc_pmi.tc_pmi08
               CALL i255_tc_pmi08('d')
               NEXT FIELD tc_pmi08
            OTHERWISE EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT
 
END FUNCTION
 
FUNCTION i255_tc_pmi01(p_cmd)  #單據編號
    DEFINE l_smydesc   LIKE smy_file.smydesc,
           l_smyacti LIKE smy_file.smyacti,
           l_t1      LIKE smy_file.smyslip, #No.FUN-550060 #No.FUN-680136 VARCHAR(5)
           p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   LET g_chr = ' '
   LET l_t1 = s_get_doc_no(g_tc_pmi.tc_pmi01)    #No.FUN-550060
   IF g_tc_pmi.tc_pmi01 IS NULL THEN
      LET g_chr = 'E'
      LET l_smydesc=NULL
   ELSE
      SELECT smydesc,smyacti
        INTO l_smydesc,l_smyacti
        FROM smy_file WHERE smyslip = l_t1
      IF SQLCA.sqlcode THEN
         LET g_chr = 'E'
         LET l_smydesc = NULL
      ELSE
         IF l_smyacti matches'[nN]' THEN
            LET g_chr = 'E'
         END IF
      END IF
   END IF
 
   IF cl_null(g_chr) OR p_cmd = 'd' THEN
      DISPLAY l_smydesc TO FORMONLY.smydesc
   END IF
 
END FUNCTION
 
FUNCTION i255_tc_pmi03(p_cmd)  #廠商編號
    DEFINE l_pmc03 LIKE pmc_file.pmc03,
           l_pmc05 LIKE pmc_file.pmc05,
           l_pmc47 LIKE pmc_file.pmc47,        #No.FUN-550019
           l_pmcacti LIKE pmc_file.pmcacti,
           l_pmc30 LIKE pmc_file.pmc30,   #MOD-920024
           p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   LET g_errno = " "
   SELECT pmc03,pmc05,pmc47,pmcacti,pmc30   #MOD-920024
     INTO l_pmc03,l_pmc05,l_pmc47,l_pmcacti,l_pmc30   #MOD-920024
     FROM pmc_file
    WHERE pmc01 = g_tc_pmi.tc_pmi03
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
                                  LET l_pmc03 = NULL
        WHEN l_pmcacti='N' LET g_errno = '9028'
        WHEN l_pmcacti MATCHES '[PH]'  LET g_errno = '9038'    #No.FUN-690024
        WHEN l_pmc30 = "2" LET g_errno='mfg3290'   #MOD-920024       
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF p_cmd='s' THEN
      DISPLAY l_pmc03 TO FORMONLY.pmc03
      RETURN
   END IF
 
   CASE
        WHEN l_pmc05 = '0'   #尚待核准           #No.FUN-690025
             CALL cl_getmsg('mfg3174',g_lang) RETURNING g_msg
             WHILE g_chr IS NULL OR g_chr NOT MATCHES'[YyNn]'
            LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED FOR CHAR g_chr
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
                IF g_chr MATCHES '[Nn]' THEN LET g_errno='apm-132' END IF #MOD-570056
             END WHILE
        WHEN l_pmc05 = '3'    #No.FUN-690025
             LET g_errno='mfg3042'
        OTHERWISE EXIT CASE
   END CASE
 
   IF p_cmd = 'a' THEN
      LET g_tc_pmi.tc_pmi08 = l_pmc47
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO FORMONLY.pmc03
   END IF
 
END FUNCTION
 
FUNCTION i255_tc_pmi08(p_cmd)  #稅別
    DEFINE  l_gec04   LIKE gec_file.gec04,
            l_gecacti LIKE gec_file.gecacti,
            p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
	
    LET g_errno = " "
    SELECT gec04,gecacti,gec07 INTO l_gec04,l_gecacti,g_gec07
      FROM gec_file
     WHERE gec01 = g_tc_pmi.tc_pmi08 AND gec011='1'  #進項
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                                   LET l_gec04 = 0
         WHEN l_gecacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_gec07) THEN
       LET g_gec07 = 'N'
    END IF
 
    IF p_cmd = 'a' OR p_cmd='u' THEN   #MOD-710094 mod                                                       
       LET g_tc_pmi.tc_pmi081 = l_gec04
       DISPLAY BY NAME g_tc_pmi.tc_pmi081
    END IF
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY g_gec07 TO FORMONLY.gec07
    END IF
 
 
END FUNCTION
 
FUNCTION i255_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_tc_pmi.* TO NULL                  #No.FUN-6A0162
 
   CALL cl_msg("")                              #FUN-640184
 
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tc_pmj.clear()
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i255_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_tc_pmi.* TO NULL
      RETURN
   END IF
 
   OPEN i255_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tc_pmi.* TO NULL
   ELSE
      OPEN i255_count
      FETCH i255_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i255_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i255_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680136 VARCHAR(1)
 
   CASE p_flag
       WHEN 'N' FETCH NEXT     i255_cs INTO g_tc_pmi.tc_pmi01
       WHEN 'P' FETCH PREVIOUS i255_cs INTO g_tc_pmi.tc_pmi01
       WHEN 'F' FETCH FIRST    i255_cs INTO g_tc_pmi.tc_pmi01
       WHEN 'L' FETCH LAST     i255_cs INTO g_tc_pmi.tc_pmi01
       WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i255_cs INTO g_tc_pmi.tc_pmi01
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_pmi.tc_pmi01,SQLCA.sqlcode,0)
      INITIALIZE g_tc_pmi.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_tc_pmi.* FROM tc_pmi_file WHERE tc_pmi01 = g_tc_pmi.tc_pmi01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","tc_pmi_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      INITIALIZE g_tc_pmi.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_tc_pmi.tc_pmiuser      #FUN-4C0056 add
   LET g_data_group = g_tc_pmi.tc_pmigrup      #FUN-4C0056 add
   LET g_data_plant = g_tc_pmi.tc_pmiplant #FUN-980030
 
   CALL i255_show()
 
END FUNCTION
 
FUNCTION i255_show()
 
   LET g_tc_pmi_t.* = g_tc_pmi.*                #保存單頭舊值
   LET g_tc_pmi_o.* = g_tc_pmi.*                #保存單頭舊值
   DISPLAY BY NAME g_tc_pmi.tc_pmioriu,g_tc_pmi.tc_pmiorig, g_tc_pmi.tc_pmi01,g_tc_pmi.tc_pmi02,g_tc_pmi.tc_pmi09,g_tc_pmi.tc_pmi03,g_tc_pmi.tc_pmi04,g_tc_pmi.tc_pmi05,#FUN-630044
                   g_tc_pmi.tc_pmi07,g_tc_pmi.tc_pmi06,g_tc_pmi.tc_pmiconf,g_tc_pmi.tc_pmiuser,
                   g_tc_pmi.tc_pmigrup,g_tc_pmi.tc_pmimodu,g_tc_pmi.tc_pmidate,g_tc_pmi.tc_pmiacti,
                   g_tc_pmi.tc_pmi08,g_tc_pmi.tc_pmi081             #No.FUN-550019
    
    CALL i255_pic()         #FUN-920106
   CALL i255_tc_pmi01('d')
    CALL i255_tc_pmi03('s') #MOD-570056
   CALL i255_tc_pmi08('d')                    #No.FUN-550019
   CALL i255_tc_pmi09('d')                      #FUN-630044  
 
   CALL i255_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i255_r()
   DEFINE i         LIKE type_file.num10    #No.FUN-9C0046  ..Add
   DEFINE l_len     LIKE type_file.num10    #No.FUN-9C0046  ..Add
   DEFINE l_chr     LIKE type_file.chr1     #No.FUN-9C0046  ..Add
   DEFINE l_ac      LIKE type_file.num5     #No.FUN-9C0046  ..Add
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_tc_pmi.tc_pmi01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_tc_pmi.* FROM tc_pmi_file
    WHERE tc_pmi01=g_tc_pmi.tc_pmi01
 
   #檢查資料是否已確認
   IF g_tc_pmi.tc_pmiconf='Y' THEN
      CALL cl_err(g_tc_pmi.tc_pmiconf,'9003',0)
      RETURN
   END IF
 
   #檢查資料是否已作廢
   IF g_tc_pmi.tc_pmiconf='X' THEN
      CALL cl_err(g_tc_pmi.tc_pmiconf,'9024',0)
      RETURN
   END IF
 
   IF g_tc_pmi.tc_pmiacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tc_pmi.tc_pmi01,'mfg1000',0)
      RETURN
   END IF
 
    IF g_tc_pmi.tc_pmi06 matches '[Ss]' THEN
        CALL cl_err('','apm-030',0)
        RETURN
    END IF
 
#TQC-B40215 --begin--
#    IF g_tc_pmi.tc_pmi07 = 'Y' AND (g_tc_pmi.tc_pmi06 = '1' OR g_tc_pmi.tc_pmi06 = 'S')#MOD-4A0299
#   THEN
#      CALL cl_err(g_tc_pmi.tc_pmi01,'agl-160',0)
#      RETURN
#   END IF
#TQC-B40215 --end--
 
   BEGIN WORK
 
   OPEN i255_cl USING g_tc_pmi.tc_pmi01
   IF STATUS THEN
      CALL cl_err("OPEN i255_cl:", STATUS, 1)
      CLOSE i255_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i255_cl INTO g_tc_pmi.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_pmi.tc_pmi01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i255_show()

      LET i=1
      LET l_len = g_tc_pmj.getLength()
      FOR i=1 TO l_len
         IF g_tc_pmj[i].tc_pmj14 IS NOT NULL THEN
            SELECT COUNT(*) INTO l_ac FROM tc_pmj_file WHERE tc_pmj01=g_tc_pmi.tc_pmi01 AND tc_pmj14=g_tc_pmj[i].tc_pmj14
            IF l_ac > 0 THEN
               CALL cl_confirm("apm1025") RETURNING l_chr
               IF l_chr THEN
                  UPDATE wpd_file SET wpd10='',wpd11='N' WHERE wpd01=g_tc_pmj[i].tc_pmj14
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL cl_err3("upd","wpd_file","","",SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK
                     RETURN
                  END IF
                  UPDATE wpc_file SET wpc09='N' WHERE wpc01=g_tc_pmj[i].tc_pmj14
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL cl_err3("upd","wpc_file","","",SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK
                     RETURN
                  END IF
               ELSE
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF
         END IF
      END FOR
   
   IF cl_null(l_chr) THEN
      IF NOT cl_delh(0,0) THEN
         RETURN
      END IF
      INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "tc_pmi01"         #No.FUN-9B0098 10/02/24
      LET g_doc.value1 = g_tc_pmi.tc_pmi01      #No.FUN-9B0098 10/02/24
      CALL cl_del_doc()                              #No.FUN-9B0098 10/02/24
   END IF

      DELETE FROM tc_pmi_file WHERE tc_pmi01 = g_tc_pmi.tc_pmi01
      DELETE FROM tc_pmj_file WHERE tc_pmj01 = g_tc_pmi.tc_pmi01
      IF g_tc_pmi.tc_pmi05 = 'Y' THEN
         DELETE FROM pmr_file WHERE pmr01 = g_tc_pmi.tc_pmi01
      END IF
      CLEAR FORM
      CALL g_tc_pmj.clear()
      OPEN i255_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE i255_cs
         CLOSE i255_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH i255_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i255_cs
         CLOSE i255_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i255_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i255_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i255_fetch('/')
      END IF
 
   CLOSE i255_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tc_pmi.tc_pmi01,'D')
 
END FUNCTION
 
#FUNCTION i255_b()  #mark by guanyao160525
FUNCTION i255_b(p_cmd_1)#add by guanyao160525
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用  #No.FUN-680136 SMALLINT
    l_n1            LIKE type_file.num5,    #No.FUN-810017
    l_n2            LIKE type_file.num5,    #No.FUN-810017
    l_n3            LIKE type_file.num5,    #No.FUN-810017
    l_cnt           LIKE type_file.num5,    #檢查重複用  #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態  #No.FUN-680136 VARCHAR(1)
    l_misc          LIKE gfe_file.gfe01,    #No.FUN-680136 VARCHAR(04)
    l_cmd           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(100)
    l_tc_pmj01         LIKE tc_pmj_file.tc_pmj01,
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否  #No.FUN-680136 SMALLINT
    l_tc_pmi06         LIKE tc_pmi_file.tc_pmi06
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000                                                                                             
DEFINE  l_m      LIKE type_file.chr1000                                                                                             
DEFINE  i        LIKE type_file.num5                                                                                                
DEFINE  l_s1     LIKE type_file.chr1000                                                                                             
DEFINE  l_m1     LIKE type_file.chr1000                                                                                             
DEFINE  i1       LIKE type_file.num5                                                                                                
DEFINE  l_cnt1   LIKE type_file.num5  #MOD-920027
DEFINE  l_flag   LIKE type_file.chr1  #MOD-920027
DEFINE  l_pmhacti   LIKE pmh_file.pmhacti   #MOD-930327
DEFINE  l_pmr02  LIKE pmr_file.pmr02  #MOD-980166
DEFINE  l_chr    LIKE type_file.chr1  #No.FUN-9C0046
DEFINE  l_cnt2   LIKE type_file.num5  #MOD-CA0057 add
DEFINE  l_pmc22  LIKE pmc_file.pmc22  #CHI-C10008 add
DEFINE  p_cmd_1   LIKE type_file.chr1 #add by guanyao160525    
DEFINE  l_COUNT    INT

    LET g_action_choice = ""
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_tc_pmi.tc_pmi01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_tc_pmi.* FROM tc_pmi_file
     WHERE tc_pmi01=g_tc_pmi.tc_pmi01
 
    LET l_tc_pmi06 = g_tc_pmi.tc_pmi06     #MOD-4A0299
 
   #檢查資料是否已確認
   IF g_tc_pmi.tc_pmiconf='Y' THEN
      CALL cl_err(g_tc_pmi.tc_pmiconf,'9003',0)
      RETURN
   END IF
 
   #檢查資料是否已作廢
   IF g_tc_pmi.tc_pmiconf='X' THEN
      CALL cl_err(g_tc_pmi.tc_pmiconf,'9024',0)
      RETURN
   END IF
 
    IF g_tc_pmi.tc_pmi06 matches '[Ss]' THEN          #MOD-4A0299
         CALL cl_err('','apm-030',0)
         RETURN
   END IF
 
   IF g_tc_pmi.tc_pmiacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tc_pmi.tc_pmi01,'mfg1000',0)
      RETURN
   END IF
   #str----add by guanyao160525
   IF p_cmd_1 = 'p' THEN 
      CALL cl_set_comp_entry('tc_pmj02,tc_pmj03,tc_pmj05',FALSE)
   ELSE 
      CALL cl_set_comp_entry('tc_pmj02,tc_pmj03,tc_pmj05',TRUE)
   END IF 
   #end----add by guanyao160525
 
   LET l_cnt1 = 0
   LET l_flag = ' '
   SELECT COUNT(*) INTO l_cnt1 FROM tc_pmj_file
    WHERE tc_pmj01 = g_tc_pmi.tc_pmi01
   IF l_cnt1 = 0 THEN
      LET l_flag = 'Y'
   END IF
   #NO:7178自動由詢價單轉入產生單身
   #str----mark by guanyao160711
   #IF g_tc_pmi.tc_pmi05 = 'N' THEN
   #   CALL i255_b_g()
   #END IF
   #end----mark by guanyao160711
 
   CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tc_pmj02,tc_pmj03,tc_pmj031,tc_pmj032,tc_pmj11,tc_pmj04,'','',tc_pmj10,'','',tc_pmj13,tc_pmjicd14,tc_pmj05,tc_pmj06,",  #FUN-560193 add '','' #FUN-930061 add ''	 #FUN-A30072   
                       "       tc_pmj06t,tc_pmj07,tc_pmj07t,tc_pmj08,tc_pmj09,tc_pmj14,tc_pmj15,tc_pmj16,tc_pmj17,tc_pmj18,tc_pmj19,tc_pmj20,tc_pmj21 ", #add by huanglf161031 #No.FUN-550019  #No.FUN-9C0046 ..Add tc_pmj14
                       "  FROM tc_pmj_file",
                       " WHERE tc_pmj01=? AND tc_pmj02=? AND tc_pmj12='",g_tc_pmj12,"' FOR UPDATE"  #No.FUN-670099
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i255_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tc_pmj WITHOUT DEFAULTS FROM s_pmj.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
           OPEN i255_cl USING g_tc_pmi.tc_pmi01
           IF STATUS THEN
              CALL cl_err("OPEN i255_cl:", STATUS, 1)
              CLOSE i255_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i255_cl INTO g_tc_pmi.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_tc_pmi.tc_pmi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i255_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_tc_pmj_t.* = g_tc_pmj[l_ac].*  #BACKUP
              LET g_tc_pmj_o.* = g_tc_pmj[l_ac].*  #BACKUP
              OPEN i255_bcl USING g_tc_pmi.tc_pmi01,g_tc_pmj_t.tc_pmj02
              IF STATUS THEN
                 CALL cl_err("OPEN i255_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i255_bcl INTO g_tc_pmj[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tc_pmj_t.tc_pmj02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                LET g_errno = ' '
             SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
               FROM ima_file WHERE ima01=g_tc_pmj[l_ac].tc_pmj03
             CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                            LET l_ima02 = NULL
                                            LET l_ima021= NULL
                  WHEN l_imaacti='N' LET g_errno = '9028'
                  WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022
                  OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            SELECT ecd02 INTO g_tc_pmj[l_ac].ecd02
              FROM ecd_file
             WHERE ecd01 = g_tc_pmj[l_ac].tc_pmj10
            IF SQLCA.sqlcode = 100 THEN
               LET g_tc_pmj[l_ac].ecd02 = ''
            END IF
            #str----add by guanyao160730
            SELECT ecbud02 INTO g_tc_pmj[l_ac].ecbud02 
              FROM ecb_file 
             WHERE ecb01 = g_tc_pmj[l_ac].tc_pmj03 
               AND ecb06 = g_tc_pmj[l_ac].tc_pmj10
            IF SQLCA.sqlcode = 100 THEN
               LET g_tc_pmj[l_ac].ecbud02 = ''
            END IF
            #end----add by guanyao160730
            LET l_m1 = ' '
            IF g_sma.sma120 = 'Y' THEN                 
               IF NOT cl_null(g_errno) THEN 
                  LET g_buf = g_tc_pmj[l_ac].tc_pmj03
                  LET l_s1 = g_buf.trim()
                  FOR i1=1 TO length(l_s1)                                                                                                  
                  IF l_s1[i1,i1] = '_' THEN                                                                                              
                     LET l_m1 = l_s1[1,i1-1]                                                                                             
                     EXIT FOR                                                                                                         
                  ELSE                                                                                                                
                     CONTINUE FOR                                                                                                     
                  END IF                                                                                                              
                  IF l_s1[i1,i1] = '-' THEN                                                                                               
                     LET l_m1 = l_s1[1,i1-1]                                                                                              
                     EXIT FOR                                                                                                          
                  ELSE                                                                                                                 
                    CONTINUE FOR                                                                                                       
                  END IF                                                                                                               
                  IF l_s1[i1,i1] = ' ' THEN                                                                                               
                     LET l_m1 = l_s1[1,i1-1]                                                                                              
                     EXIT FOR                                                                                                          
                  ELSE                                                                                                                 
                     CONTINUE FOR                                                                                                       
                  END IF                                                                                                               
                  END FOR
               END IF
            END IF
            IF NOT cl_null(l_m1) THEN
               SELECT ima44,ima908 INTO g_tc_pmj[l_ac].ima44,g_tc_pmj[l_ac].ima908   
                FROM ima_file WHERE ima01=l_m1
            ELSE
               SELECT ima44,ima908 INTO g_tc_pmj[l_ac].ima44,g_tc_pmj[l_ac].ima908   
                 FROM ima_file WHERE ima01=g_tc_pmj[l_ac].tc_pmj03
            END IF
                 IF SQLCA.sqlcode THEN
                    LET g_tc_pmj[l_ac].ima44 =NULL   
                    LET g_tc_pmj[l_ac].ima908=NULL
                 END IF
              END IF
              CALL i255_set_entry_b(p_cmd)      #No.FUN-610018
              CALL i255_set_no_entry_b(p_cmd)   #No.FUN-610018
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tc_pmj[l_ac].* TO NULL      #900423
           LET g_tc_pmj[l_ac].tc_pmj07 = 0        #Body default
           LET g_tc_pmj[l_ac].tc_pmj07t= 0            #No.FUN-550019
           LET g_tc_pmj[l_ac].tc_pmj09 = g_today      #Body default
           LET g_tc_pmj_t.* = g_tc_pmj[l_ac].*         #新輸入資料
           LET g_tc_pmj_o.* = g_tc_pmj[l_ac].*         #新輸入資料
           LET g_tc_pmj[l_ac].tc_pmj13 = " "           #No.FUN-810017
           IF g_tc_pmj12 = '2' AND s_industry('icd') THEN
              LET g_tc_pmj[l_ac].tc_pmjicd14 = '0'
           END IF
           CALL i255_set_entry_b(p_cmd)      #No.FUN-610018
           CALL i255_set_no_entry_b(p_cmd)   #No.FUN-610018
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD tc_pmj02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              DELETE FROM pmr_file
               WHERE pmr01 = g_tc_pmi.tc_pmi01
                 AND pmr02 = g_tc_pmj_t.tc_pmj02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","pmr_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
              END IF
              CANCEL INSERT
           END IF
           IF cl_null(g_tc_pmj[l_ac].tc_pmj10) THEN
              LET g_tc_pmj[l_ac].tc_pmj10=' '
              LET g_tc_pmj[l_ac].ecd02=' '        #No.FUN-930061
              LET g_tc_pmj[l_ac].ecbud02 = '' #add by guanyao160730
           END IF
            #FUN-A30072--begin--add-------
            IF g_tc_pmj12 = '2' AND s_industry('icd') THEN
            SELECT COUNT(*) INTO l_n FROM tc_pmj_file
             WHERE tc_pmj03=g_tc_pmj[l_ac].tc_pmj03
               AND tc_pmj01=g_tc_pmi.tc_pmi01
               AND tc_pmj02!=g_tc_pmj[l_ac].tc_pmj02
               AND tc_pmj03[1,4] !='MISC'
               AND tc_pmj05=g_tc_pmj[l_ac].tc_pmj05
               AND tc_pmj10=g_tc_pmj[l_ac].tc_pmj10
               AND tc_pmj13=g_tc_pmj[l_ac].tc_pmj13     #No.TQC-930072 add
               AND tc_pmj12=g_tc_pmj12  #No.FUN-670099
               AND tc_pmjicd14 = g_tc_pmj[l_ac].tc_pmjicd14
            ELSE
            #FUN-A30072--end--add-------------
               SELECT COUNT(*) INTO l_n FROM tc_pmj_file
                WHERE tc_pmj03=g_tc_pmj[l_ac].tc_pmj03
                  AND tc_pmj01=g_tc_pmi.tc_pmi01
                  AND tc_pmj02!=g_tc_pmj[l_ac].tc_pmj02
                  AND tc_pmj03[1,4] !='MISC'
                  AND tc_pmj05=g_tc_pmj[l_ac].tc_pmj05
                  AND tc_pmj10=g_tc_pmj[l_ac].tc_pmj10
                  AND tc_pmj13=g_tc_pmj[l_ac].tc_pmj13     #No.TQC-930072 add
                  AND tc_pmj12=g_tc_pmj12  #No.FUN-670099
            END IF
            IF l_n>0 THEN
               CALL cl_err(g_tc_pmj[l_ac].tc_pmj03,'apm-296',1)
               CANCEL INSERT
               NEXT FIELD tc_pmj03
            END IF
           INSERT INTO tc_pmj_file(tc_pmj01,tc_pmj02,tc_pmj03,tc_pmj031,tc_pmj032,tc_pmj11,tc_pmj04,tc_pmj05,
                                tc_pmj06,tc_pmj06t,tc_pmj07,tc_pmj07t,tc_pmj09,tc_pmj10,tc_pmj08,       #No.FUN-550019  
                                tc_pmj12,tc_pmj13,tc_pmjicd14,tc_pmjplant,tc_pmjlegal,tc_pmj15,tc_pmj16,
                                tc_pmj17,tc_pmj18,tc_pmj19,tc_pmj20,tc_pmj21)  #add by huanglf161031#No.FUN-670099 #No.FUN-810017 #FUN-980006 add tc_pmjplant,tc_pmjlegal  #FUN-A30072
                VALUES(g_tc_pmi.tc_pmi01,g_tc_pmj[l_ac].tc_pmj02,
                       g_tc_pmj[l_ac].tc_pmj03,g_tc_pmj[l_ac].tc_pmj031,
                       g_tc_pmj[l_ac].tc_pmj032,g_tc_pmj[l_ac].tc_pmj11,g_tc_pmj[l_ac].tc_pmj04,
                       g_tc_pmj[l_ac].tc_pmj05,g_tc_pmj[l_ac].tc_pmj06,
                       g_tc_pmj[l_ac].tc_pmj06t,g_tc_pmj[l_ac].tc_pmj07,    #No.FUN-550019
                       g_tc_pmj[l_ac].tc_pmj07t,g_tc_pmj[l_ac].tc_pmj09,    #No.FUN-550019
                       g_tc_pmj[l_ac].tc_pmj10,g_tc_pmj[l_ac].tc_pmj08,
                       g_tc_pmj12,g_tc_pmj[l_ac].tc_pmj13,g_tc_pmj[l_ac].tc_pmjicd14,g_plant,g_legal,
                       g_tc_pmj[l_ac].tc_pmj15,g_tc_pmj[l_ac].tc_pmj16,
                       g_tc_pmj[l_ac].tc_pmj17,g_tc_pmj[l_ac].tc_pmj18,
                       g_tc_pmj[l_ac].tc_pmj19,g_tc_pmj[l_ac].tc_pmj20,g_tc_pmj[l_ac].tc_pmj21) #add by huanglf161031  #No.FUN-670099 #No.FUN-810017 #FUN-980006 add g_plant,g_legal  #FUN-A30072
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("ins","tc_pmj_file",g_tc_pmi.tc_pmi01,g_tc_pmj[l_ac].tc_pmj02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD tc_pmj02                        #default 序號
           IF g_tc_pmj[l_ac].tc_pmj02 IS NULL OR g_tc_pmj[l_ac].tc_pmj02 = 0 THEN
              SELECT max(tc_pmj02)+1 INTO g_tc_pmj[l_ac].tc_pmj02 FROM tc_pmj_file
               WHERE tc_pmj01 = g_tc_pmi.tc_pmi01
              IF g_tc_pmj[l_ac].tc_pmj02 IS NULL THEN
                 LET g_tc_pmj[l_ac].tc_pmj02 = 1
              END IF
           END IF
 
        AFTER FIELD tc_pmj02       #check 序號是否重複
           IF NOT cl_null(g_tc_pmj[l_ac].tc_pmj02) THEN
#MOD-C30161 ----- add ----- begin
              IF g_tc_pmj[l_ac].tc_pmj02 <=0 THEN
                 CALL cl_err('','aec-994',0)
                 LET g_tc_pmj[l_ac].tc_pmj02 = g_tc_pmj_t.tc_pmj02
                 NEXT FIELD tc_pmj02
              END IF
#MOD-C30161 ----- add ----- end
              IF g_tc_pmj[l_ac].tc_pmj02 != g_tc_pmj_t.tc_pmj02 OR g_tc_pmj_t.tc_pmj02 IS NULL THEN
                 SELECT COUNT(*) INTO l_cnt FROM tc_pmj_file
                  WHERE tc_pmj01 = g_tc_pmi.tc_pmi01
                    AND tc_pmj02 = g_tc_pmj[l_ac].tc_pmj02
                 IF l_cnt > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tc_pmj[l_ac].tc_pmj02 = g_tc_pmj_t.tc_pmj02
                    NEXT FIELD tc_pmj02
                 END IF
              END IF
           END IF
 
        BEFORE FIELD tc_pmj03
           CALL i255_set_entry_b(p_cmd)
 
        AFTER FIELD tc_pmj03                  #料件編號
           IF NOT cl_null(g_tc_pmj[l_ac].tc_pmj03) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_tc_pmj[l_ac].tc_pmj03,"") THEN
                 CALL cl_err(g_tc_pmj[l_ac].tc_pmj03,g_errno,1)
                 LET g_tc_pmj[l_ac].tc_pmj03= g_tc_pmj_t.tc_pmj03
                 NEXT FIELD tc_pmj03
              END IF
#FUN-AA0059 ---------------------end-------------------------------
#MOD-CA0057 add begin------------------------------
              SELECT COUNT(*) INTO l_cnt2 FROM ima_file 
               WHERE ima01 = g_tc_pmj[l_ac].tc_pmj03
                 AND ima08 = 'X' 
              IF l_cnt2 > 0 THEN 
              	 CALL cl_err(g_tc_pmj[l_ac].tc_pmj03,'mfg9022',0)
              	 NEXT FIELD tc_pmj03
              END IF  	   
#MOD-CA0057 add end--------------------------------
              LET l_misc=g_tc_pmj[l_ac].tc_pmj03[1,4]
              IF g_tc_pmj[l_ac].tc_pmj03[1,4]='MISC' THEN
                 SELECT COUNT(*) INTO l_n FROM ima_file
                  WHERE ima01=l_misc
                    AND ima01='MISC'
                 IF l_n=0 THEN
                    CALL cl_err('','aim-806',0)
                    NEXT FIELD tc_pmj03
                 END IF
              END IF                                  #NO:6808
              IF g_tc_pmj_o.tc_pmj03 IS NULL OR g_tc_pmj_o.tc_pmj031 IS NULL OR
                (g_tc_pmj[l_ac].tc_pmj03 != g_tc_pmj_o.tc_pmj03) THEN
                 CALL i255_tc_pmj03('a')
               LET l_m = ' '
              IF g_sma.sma120 = 'Y' THEN                 
                IF NOT cl_null(g_errno) THEN                                                                        
                  SELECT count(*) INTO l_n3                                                                                    
                    FROM imx_file,sma_file                                                                                     
                   WHERE (imx00||sma46||imx01||sma46||imx02||sma46||imx03||sma46||imx04=g_tc_pmj[l_ac].tc_pmj03)                     
                      OR (imx00||sma46||imx01||sma46||imx02||sma46||imx03=g_tc_pmj[l_ac].tc_pmj03)                                   
                      OR (imx00||sma46||imx01||sma46||imx02=g_tc_pmj[l_ac].tc_pmj03)                                                 
                      OR (imx00||sma46||imx01=g_tc_pmj[l_ac].tc_pmj03)                                                               
                      OR imx00=g_tc_pmj[l_ac].tc_pmj03                                                                               
                  IF l_n3 > 0 THEN   
                     LET g_errno = ' '
                     LET g_buf = g_tc_pmj[l_ac].tc_pmj03
                     LET l_s = g_buf.trim()
                    FOR i=1 TO length(l_s)                                                                                          
                        IF l_s[i,i] = '_' THEN                                                                                      
                           LET l_m = l_s[1,i-1]                                                                                     
                           CALL i255_tc_pmj03_1('a',l_m)                                                                               
                           EXIT FOR                                                                                                 
                        ELSE                                                                                                        
                           CONTINUE FOR                                                                                             
                        END IF                                                                                                      
                        IF l_s[i,i] = '-' THEN                                                                                      
                           LET l_m = l_s[1,i-1]                                                                                     
                           CALL i255_tc_pmj03_1('a',l_m)                                                                               
                           EXIT FOR                                                                                                 
                        ELSE                                                                                                        
                           CONTINUE FOR                                                                                             
                        END IF                                                                                                      
                        IF l_s[i,i] = ' ' THEN                                                                                      
                           LET l_m = l_s[1,i-1]                                                                                     
                           CALL i255_tc_pmj03_1('a',l_m)                                                                               
                           EXIT FOR                                                                                                 
                        ELSE                                                                                                        
                           CONTINUE FOR                                                                                             
                        END IF                                                                                                      
                    END FOR                                                                                                         
                  ELSE                                                                                          
                     CALL cl_err('','apm-828',0)                                                                               
                     NEXT FIELD tc_pmj03                                                                                          
                  END IF                                                                                                       
                END IF                                                                                                          
              END IF                                                                                                             
                 IF NOT cl_null(g_errno) AND g_tc_pmj[l_ac].tc_pmj03[1,4] !='MISC' THEN #NO:6808
                    CALL cl_err(g_tc_pmj[l_ac].tc_pmj03,g_errno,0)
                    LET g_tc_pmj[l_ac].tc_pmj03 = g_tc_pmj_o.tc_pmj03
                    DISPLAY BY NAME g_tc_pmj[l_ac].tc_pmj03
                    NEXT FIELD tc_pmj03
                 END IF
              END IF
              LET g_tc_pmj_o.tc_pmj03 = g_tc_pmj[l_ac].tc_pmj03
              #CHI-C10008 ----- add start -----
              IF p_cmd = 'a' THEN
                 SELECT pmc22 INTO l_pmc22 FROM pmc_file WHERE pmc01 = g_tc_pmi.tc_pmi03
                 LET g_tc_pmj[l_ac].tc_pmj05 = l_pmc22
                 DISPLAY BY NAME g_tc_pmj[l_ac].tc_pmj05
              END IF       
              #CHI-C10008 ----- add end -----
           END IF

           IF NOT cl_null(l_m) THEN
              SELECT ima44,ima908 INTO g_tc_pmj[l_ac].ima44,g_tc_pmj[l_ac].ima908    
                FROM ima_file WHERE ima01=l_m
           ELSE
              SELECT ima44,ima908 INTO g_tc_pmj[l_ac].ima44,g_tc_pmj[l_ac].ima908      
                FROM ima_file WHERE ima01=g_tc_pmj[l_ac].tc_pmj03
           END IF     #No.FUN-830114
           IF SQLCA.sqlcode THEN
              LET g_tc_pmj[l_ac].ima44 =NULL   
              LET g_tc_pmj[l_ac].ima908=NULL
           END IF
           #str-----add by guanyao160730
            IF NOT cl_null(g_tc_pmj[l_ac].tc_pmj03) AND NOT cl_null(g_tc_pmj[l_ac].tc_pmj10) THEN 
               SELECT ecbud02 INTO g_tc_pmj[l_ac].ecbud02 
                 FROM ecb_file 
                WHERE ecb01 = g_tc_pmj[l_ac].tc_pmj03
                  AND ecb06 = g_tc_pmj[l_ac].tc_pmj10
               DISPLAY BY NAME g_tc_pmj[l_ac].ecbud02
            END IF 
            #end-----add by guanyao160730
           CALL i255_set_no_entry_b(p_cmd)
 
        BEFORE FIELD tc_pmj05
           CALL i255_set_entry_b(p_cmd)
 
        AFTER FIELD tc_pmj05
           IF cl_null(g_tc_pmj[l_ac].tc_pmj05) THEN
              NEXT FIELD tc_pmj05
           ELSE
              CALL i255_tc_pmj05('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_tc_pmj[l_ac].tc_pmj05,g_errno,0)
                 NEXT FIELD tc_pmj05
              ELSE
                 #FUN-A30072--begin--add-----------
                 IF g_tc_pmj12 = '2' AND s_industry('icd') THEN
                 SELECT COUNT(*) INTO l_n FROM tc_pmj_file
                  WHERE tc_pmj03=g_tc_pmj[l_ac].tc_pmj03
                    AND tc_pmj01=g_tc_pmi.tc_pmi01
                    AND tc_pmj02!=g_tc_pmj[l_ac].tc_pmj02
                    AND tc_pmj03[1,4] !='MISC'
                    AND tc_pmj05=g_tc_pmj[l_ac].tc_pmj05
                    AND tc_pmj10=g_tc_pmj[l_ac].tc_pmj10
                    AND tc_pmj13=g_tc_pmj[l_ac].tc_pmj13    #No.TQC-930072 add
                    AND tc_pmj12=g_tc_pmj12  #No.FUN-670099
                       AND tc_pmjicd14=g_tc_pmj[l_ac].tc_pmjicd14
                 ELSE
                 #FUN-A30072--end--add-----------------
                    SELECT COUNT(*) INTO l_n FROM tc_pmj_file
                     WHERE tc_pmj03=g_tc_pmj[l_ac].tc_pmj03
                       AND tc_pmj01=g_tc_pmi.tc_pmi01
                       AND tc_pmj02!=g_tc_pmj[l_ac].tc_pmj02
                       AND tc_pmj03[1,4] !='MISC'
                       AND tc_pmj05=g_tc_pmj[l_ac].tc_pmj05
                       AND tc_pmj10=g_tc_pmj[l_ac].tc_pmj10
                       AND tc_pmj13=g_tc_pmj[l_ac].tc_pmj13    #No.TQC-930072 add
                       AND tc_pmj12=g_tc_pmj12  #No.FUN-670099
                 END IF
                 IF l_n>0 THEN
                    CALL cl_err(g_tc_pmj[l_ac].tc_pmj03,'apm-296',0)
                    LET g_tc_pmj_o.tc_pmj03 = g_tc_pmj[l_ac].tc_pmj03
                    LET g_tc_pmj[l_ac].tc_pmj031= NULL
                    LET g_tc_pmj[l_ac].tc_pmj032= NULL
                    NEXT FIELD tc_pmj05
                 END IF
                 LET l_tc_pmj01 = NULL
                 SELECT tc_pmj01 INTO l_tc_pmj01 FROM tc_pmi_file,tc_pmj_file
                  WHERE tc_pmi03=g_tc_pmi.tc_pmi03
                    AND tc_pmi08=g_tc_pmi.tc_pmi08        #No.FUN-550019
                    AND tc_pmiconf='N'
                    AND tc_pmi01!=g_tc_pmi.tc_pmi01
                    AND tc_pmj01=tc_pmi01
                    AND tc_pmj03=g_tc_pmj[l_ac].tc_pmj03
                    AND tc_pmj03[1,4] != 'MISC'
                    AND tc_pmj05=g_tc_pmj[l_ac].tc_pmj05
                    AND tc_pmj10=g_tc_pmj[l_ac].tc_pmj10
                    AND tc_pmj12=g_tc_pmj12  #No.FUN-670099
                 IF NOT cl_null(l_tc_pmj01) THEN
                     LET g_message = NULL
                     LET g_message = 'NO:',l_tc_pmj01,'==>',g_tc_pmj[l_ac].tc_pmj03 CLIPPED
                     LET g_message = g_message CLIPPED
                     #(廠商+料號+幣別+作業編號)尚有未確認之核價單
                     CALL cl_err(g_message,'apm-262',0)
                     NEXT FIELD tc_pmj03
                 END IF
                IF g_tc_pmj[l_ac].tc_pmj03[1,4] !='MISC' THEN  #料號非為MISC才check    
                   IF cl_null(g_tc_pmj[l_ac].tc_pmj10) THEN
                   SELECT COUNT(*) INTO l_cnt FROM pmh_file   #check存在pmh
                    WHERE pmh01=g_tc_pmj[l_ac].tc_pmj03 AND pmh02=g_tc_pmi.tc_pmi03
                      AND pmh02 = g_tc_pmi.tc_pmi03   #TQC-740117
                      AND pmh13=g_tc_pmj[l_ac].tc_pmj05
                      AND pmh22=g_tc_pmj12  #No.FUN-670099
                   ELSE
                   SELECT COUNT(*) INTO l_cnt FROM pmh_file   #check存在pmh
                    WHERE pmh01=g_tc_pmj[l_ac].tc_pmj03 AND pmh02=g_tc_pmi.tc_pmi03
                      AND pmh02 = g_tc_pmi.tc_pmi03   #TQC-740117
                      AND pmh13=g_tc_pmj[l_ac].tc_pmj05
                      AND pmh21=g_tc_pmj[l_ac].tc_pmj10  #No.FUN-670099
                      AND pmh23=g_tc_pmj[l_ac].tc_pmj13  #No.FUN-870124
                      AND pmh22=g_tc_pmj12  #No.FUN-670099
                   END IF
                   IF l_cnt=0 THEN
                      CALL i255sub_tc_pmj03_add(g_tc_pmj[l_ac].tc_pmj03,g_tc_pmj[l_ac].tc_pmj05,g_tc_pmj12,g_tc_pmj[l_ac].tc_pmj10,g_tc_pmi.*,g_tc_pmj[l_ac].tc_pmj13)#NO:7100  #No.FUN-670099
                      CALL ui.interface.refresh()  #NO.MOD-590519
                      CALL i255_tc_pmj06_def()
                   ELSE
                     IF cl_null(g_tc_pmj[l_ac].tc_pmj10) THEN
                        SELECT pmhacti INTO l_pmhacti FROM pmh_file       
                           WHERE pmh01 = g_tc_pmj[l_ac].tc_pmj03
                             AND pmh02 = g_tc_pmi.tc_pmi03
                             AND pmh13 = g_tc_pmj[l_ac].tc_pmj05
                             AND pmh22 = g_tc_pmj12            
                     ELSE
                        SELECT pmhacti INTO l_pmhacti FROM pmh_file       
                           WHERE pmh01 = g_tc_pmj[l_ac].tc_pmj03
                             AND pmh02 = g_tc_pmi.tc_pmi03
                             AND pmh13 = g_tc_pmj[l_ac].tc_pmj05
                             AND pmh21 = g_tc_pmj[l_ac].tc_pmj10  
                             AND pmh22 = g_tc_pmj12            
                     END IF
                     IF l_pmhacti = 'N' THEN 
                        CALL cl_err('','apm-068',0)
                        LET g_tc_pmj[l_ac].tc_pmj05 = g_tc_pmj_t.tc_pmj05 
                        NEXT FIELD tc_pmj03
                     END IF 
                      CALL i255_tc_pmj06_def()
                   END IF
                END IF
              END IF
           END IF
 
           IF g_tc_pmi.tc_pmi05 = 'Y' THEN
              #當分量計價沒有輸入資料,才需要自動跳出畫面要求User輸入
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM pmr_file 
               WHERE pmr01 = g_tc_pmi.tc_pmi01 AND pmr02=g_tc_pmj[l_ac].tc_pmj02
              IF l_n = 0 THEN 
                 LET g_tmp_file = FGL_GETPID() USING '<<<<<<<<<<'
                 LET g_tmp_file = "tmp_",g_tmp_file CLIPPED,"_file"
                 LET g_cmd = "tc_pmi255c '",g_tc_pmi.tc_pmi01 CLIPPED,"' ", g_tc_pmj[l_ac].tc_pmj02 CLIPPED," '",
                              g_tc_pmj[l_ac].tc_pmj03 CLIPPED,"' ", #MOD-530616
                              " '",g_tc_pmj[l_ac].tc_pmj031 CLIPPED,"' ", #MOD-530616
                              " '",g_tc_pmj[l_ac].tc_pmj032 CLIPPED,"' ", #MOD-530616
                              " '",g_tc_pmj[l_ac].tc_pmj05 CLIPPED,"' ", #MOD-530616
                             " '",g_prog CLIPPED,"' '",g_tmp_file CLIPPED,"' '",
                             g_tc_pmj[l_ac].tc_pmj10 CLIPPED,"'"  #No.FUN-670099
 
                 CALL cl_cmdrun_wait(g_cmd)                  #MOD-530612
 
                 IF g_tc_pmi.tc_pmiconf='N' AND g_tc_pmi.tc_pmi06 NOT MATCHES '[Ss]' THEN
                    LET g_sql = "SELECT tmp01 FROM ",g_tmp_file CLIPPED
                    PREPARE tmp_prep2 FROM g_sql
                    IF STATUS THEN CALL cl_err('tmp_prep2:',status,1) RETURN -1 END IF
                    DECLARE tmp_curs2 CURSOR FOR tmp_prep2
                    OPEN tmp_curs2
                    FETCH tmp_curs2 INTO g_tmp01
                    LET l_tc_pmi06 = g_tmp01
 
                    IF g_tmp01 <> g_tc_pmi.tc_pmi06 THEN
                       UPDATE tc_pmi_file set tc_pmi06=l_tc_pmi06 where tc_pmi01= g_tc_pmi.tc_pmi01
                    END IF
 
                 END IF
                 LET g_sql = "DROP TABLE ",g_tmp_file CLIPPED   #TQC-8C0068
                 PREPARE drop_prep2 FROM g_sql   #TQC-8C0068
                 EXECUTE drop_prep2   #TQC-8C0068
 
                 SELECT tc_pmi06 INTO g_tc_pmi.tc_pmi06 FROM tc_pmi_file where tc_pmi01 = g_tc_pmi.tc_pmi01
                 DISPLAY BY NAME g_tc_pmi.tc_pmi06
                 CALL i255_pic()     #FUN-920106
 
                 SELECT COUNT(*) INTO g_cnt
                   FROM pmr_file
                  WHERE pmr01 = g_tc_pmi.tc_pmi01
                    AND pmr02 = g_tc_pmj[l_ac].tc_pmj02
                 IF g_cnt <=0 THEN
                    #請輸入分量計價資料!
                    CALL cl_err('','apm-289',0)
                    NEXT FIELD tc_pmj05
                 END IF
              END IF   #MOD-640441 add
           END IF
           CALL i255_set_no_entry_b(p_cmd)
 
        AFTER FIELD tc_pmj07                 #新單價
           IF g_tc_pmi.tc_pmi05 != 'Y' THEN
              IF cl_null(g_tc_pmj[l_ac].tc_pmj07) OR g_tc_pmj[l_ac].tc_pmj07 <=0 THEN
                 CALL cl_err(g_tc_pmj[l_ac].tc_pmj07,'mfg5034',0)
                 NEXT FIELD tc_pmj07
              END IF
#str----add by guanyao160525
              IF p_cmd_1 = 'i' THEN
                 IF g_tc_pmj[l_ac].tc_pmj07<>g_tc_pmj_t.tc_pmj07 AND  g_tc_pmj_t.tc_pmj07<>0 THEN 
                    IF g_tc_pmj[l_ac].tc_pmj07 >g_tc_pmj[l_ac].tc_pmj06 THEN 
                       CALL cl_err('','cpm-016',0)
                       NEXT FIELD tc_pmj07
                    END IF 
                 END IF                  
              END IF 
#end----add by guanyao160525
              SELECT azi03 INTO t_azi03 FROM azi_file   #MOD-910036
                  WHERE azi01 = g_tc_pmj[l_ac].tc_pmj05   #MOD-910036
              LET g_tc_pmj[l_ac].tc_pmj07 = cl_digcut(g_tc_pmj[l_ac].tc_pmj07,t_azi03) #No.FUN-550019  #No.CHI-6A0004
              LET g_tc_pmj_o.tc_pmj07 = g_tc_pmj[l_ac].tc_pmj07
              LET g_tc_pmj[l_ac].tc_pmj07t= g_tc_pmj[l_ac].tc_pmj07 * (1 + g_tc_pmi.tc_pmi081/100)
              LET g_tc_pmj[l_ac].tc_pmj07t = cl_digcut(g_tc_pmj[l_ac].tc_pmj07t,t_azi03)  #No.CHI-6A0004
              LET g_tc_pmj_o.tc_pmj07t = g_tc_pmj[l_ac].tc_pmj07t
           END IF
 
        AFTER FIELD tc_pmj07t                 #新含稅單價
           IF g_tc_pmi.tc_pmi05 != 'Y' THEN
              IF cl_null(g_tc_pmj[l_ac].tc_pmj07t) OR g_tc_pmj[l_ac].tc_pmj07t <=0 THEN
                 CALL cl_err(g_tc_pmj[l_ac].tc_pmj07t,'mfg5034',0)
                 NEXT FIELD tc_pmj07t
              END IF
              SELECT azi03 INTO t_azi03 FROM azi_file   #MOD-910036
                  WHERE azi01 = g_tc_pmj[l_ac].tc_pmj05   #MOD-910036
              LET g_tc_pmj[l_ac].tc_pmj07t = cl_digcut(g_tc_pmj[l_ac].tc_pmj07t,t_azi03)  #No.CHI-6A0004
              LET g_tc_pmj_o.tc_pmj07t = g_tc_pmj[l_ac].tc_pmj07t
 
              LET g_tc_pmj[l_ac].tc_pmj07 = g_tc_pmj[l_ac].tc_pmj07t / (1 + g_tc_pmi.tc_pmi081/100)
              LET g_tc_pmj[l_ac].tc_pmj07 = cl_digcut(g_tc_pmj[l_ac].tc_pmj07,t_azi03)   #No.CHI-6A0004
              LET g_tc_pmj_o.tc_pmj07 = g_tc_pmj[l_ac].tc_pmj07
           END IF
 
        AFTER FIELD tc_pmj09                 #新核准日
           IF NOT cl_null(g_tc_pmj[l_ac].tc_pmj09) THEN
              LET g_tc_pmj_o.tc_pmj09 = g_tc_pmj[l_ac].tc_pmj09
           END IF
           
        AFTER FIELD tc_pmj11                 #工艺说明
           IF NOT cl_null(g_tc_pmj[l_ac].tc_pmj11) THEN
              SELECT COUNT(*) INTO l_COUNT FROM ECB_FILE 
                 WHERE ECB01=g_tc_pmj[l_ac].tc_pmj03  AND ECB02=g_tc_pmj[l_ac].tc_pmj11
                 
                 IF l_COUNT=0 THEN
                   CALL cl_err( g_tc_pmj[l_ac].tc_pmj02,'mfg5102',1)
                   NEXT FIELD tc_pmj11
                 END IF
              LET g_tc_pmj_o.tc_pmj11 = g_tc_pmj[l_ac].tc_pmj11
           END IF
           
        AFTER FIELD tc_pmj10
            IF NOT cl_null(g_tc_pmj[l_ac].tc_pmj10) THEN
               SELECT COUNT(*) INTO g_cnt FROM ecd_file
                WHERE ecd01=g_tc_pmj[l_ac].tc_pmj10
               IF g_cnt=0 THEN
                  CALL cl_err('sel ecd_file',100,0)
                  NEXT FIELD tc_pmj10
               END IF
            END IF
            IF cl_null(g_tc_pmj[l_ac].tc_pmj10) THEN
               LET g_tc_pmj[l_ac].tc_pmj10=' '
            END IF
            IF NOT cl_null(g_tc_pmj[l_ac].tc_pmj13) AND g_tc_pmj[l_ac].tc_pmj13 != " " THEN
               IF g_tc_pmj[l_ac].tc_pmj10 IS NULL OR g_tc_pmj[l_ac].tc_pmj10 = " " THEN
                  CALL cl_err('','aap-099',0)
                  NEXT FIELD tc_pmj10
               END IF
            END IF
 
            SELECT ecd02 INTO g_tc_pmj[l_ac].ecd02
              FROM ecd_file
             WHERE ecd01 = g_tc_pmj[l_ac].tc_pmj10
            IF SQLCA.sqlcode = 100 THEN
               LET g_tc_pmj[l_ac].ecd02 = ''
            END IF
            #str-----add by guanyao160730
            IF NOT cl_null(g_tc_pmj[l_ac].tc_pmj03) AND NOT cl_null(g_tc_pmj[l_ac].tc_pmj10) THEN 
               SELECT ecbud02 INTO g_tc_pmj[l_ac].ecbud02 
                 FROM ecb_file 
                WHERE ecb01 = g_tc_pmj[l_ac].tc_pmj03
                  AND ecb06 = g_tc_pmj[l_ac].tc_pmj10
               DISPLAY BY NAME g_tc_pmj[l_ac].ecbud02
            END IF 
            #end-----add by guanyao160730

            #str----add by huanglf161025
           IF NOT cl_null(g_tc_pmj[l_ac].tc_pmj10) THEN 
               SELECT tc_ecn03,tc_ecn04,tc_ecn05,tc_ecn06,tc_ecn07,tc_ecn08,tc_ecnud06 INTO 
                      g_tc_pmj[l_ac].tc_pmj15,g_tc_pmj[l_ac].tc_pmj16,g_tc_pmj[l_ac].tc_pmj17,
                      g_tc_pmj[l_ac].tc_pmj18,g_tc_pmj[l_ac].tc_pmj19,g_tc_pmj[l_ac].tc_pmj20,g_tc_pmj[l_ac].tc_pmj21
               FROM tc_ecn_file 
               WHERE tc_ecn01 = g_tc_pmj[l_ac].tc_pmj03 AND tc_ecn02 = g_tc_pmj[l_ac].tc_pmj10
                 AND tc_ecn09 = (SELECT MAX(tc_ecn09) FROM tc_ecn_file WHERE
                                  tc_ecn01 = g_tc_pmj[l_ac].tc_pmj03 AND tc_ecn02 = g_tc_pmj[l_ac].tc_pmj10 )
           END IF 
            #str----end by huanglf161025
        AFTER FIELD tc_pmj13
           IF cl_null(g_tc_pmj[l_ac].tc_pmj13) THEN 
              LET g_tc_pmj[l_ac].tc_pmj13 = " "
           END IF
           IF NOT cl_null(g_tc_pmj[l_ac].tc_pmj13) AND g_tc_pmj[l_ac].tc_pmj13 != " " THEN
              SELECT count(*) INTO l_n1 FROM sga_file
               WHERE sga01 = g_tc_pmj[l_ac].tc_pmj13
                 AND sgaacti = 'Y'
              IF l_n1 = 0 THEN
                 CALL cl_err('','apm-105',0)
                 NEXT FIELD tc_pmj13
              END IF
              IF g_tc_pmj[l_ac].tc_pmj10 IS NULL OR g_tc_pmj[l_ac].tc_pmj10 = " " THEN
                 CALL cl_err('','aap-099',0)
                 NEXT FIELD tc_pmj10
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_tc_pmj_t.tc_pmj02 > 0 AND g_tc_pmj_t.tc_pmj02 IS NOT NULL THEN
              IF g_tc_pmj_t.tc_pmj14 IS NOT NULL THEN
                 CALL cl_confirm("apm1025") RETURNING l_chr
                 IF NOT l_chr THEN
                    CANCEL DELETE
                 END IF
              ELSE
                 IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                 END IF
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM tc_pmj_file
               WHERE tc_pmj01=g_tc_pmi.tc_pmi01
                 AND tc_pmj02=g_tc_pmj_t.tc_pmj02
                 AND tc_pmj10=g_tc_pmj_t.tc_pmj10          #FUN-870124
                 AND tc_pmj12=g_tc_pmj12                #FUN-870124
                 AND tc_pmj13=g_tc_pmj_t.tc_pmj13          #FUN-870124
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tc_pmj_file",g_tc_pmi.tc_pmi01,g_tc_pmj_t.tc_pmj02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              IF g_tc_pmi.tc_pmi05 = 'Y' THEN
                 DELETE FROM pmr_file
                  WHERE pmr01 = g_tc_pmi.tc_pmi01
                    AND pmr02 = g_tc_pmj_t.tc_pmj02
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","pmr_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
              END IF
              IF g_tc_pmj_t.tc_pmj14 IS NOT NULL THEN
                 UPDATE wpd_file SET wpd10='',wpd11='N' WHERE wpd01=g_tc_pmj_t.tc_pmj14
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                    CALL cl_err3("upd","wpd_file","","",SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
                 UPDATE wpc_file SET wpc09='N' WHERE wpc01=g_tc_pmj_t.tc_pmj14
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                    CALL cl_err3("upd","wpc_file","","",SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_tc_pmj[l_ac].* = g_tc_pmj_t.*
              CLOSE i255_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tc_pmj[l_ac].tc_pmj02,-263,1)
              LET g_tc_pmj[l_ac].* = g_tc_pmj_t.*
           ELSE
              IF cl_null(g_tc_pmj[l_ac].tc_pmj10) THEN
                 LET g_tc_pmj[l_ac].tc_pmj10 = " "
              END IF
              UPDATE tc_pmj_file SET tc_pmj02 = g_tc_pmj[l_ac].tc_pmj02,
                                  tc_pmj03 = g_tc_pmj[l_ac].tc_pmj03,
                                  tc_pmj031 = g_tc_pmj[l_ac].tc_pmj031,
                                  tc_pmj032 = g_tc_pmj[l_ac].tc_pmj032,
                                  tc_pmj11= g_tc_pmj[l_ac].tc_pmj11,
                                  tc_pmj04 = g_tc_pmj[l_ac].tc_pmj04,
                                  tc_pmj05 = g_tc_pmj[l_ac].tc_pmj05,
                                  tc_pmj06 = g_tc_pmj[l_ac].tc_pmj06,
                                  tc_pmj06t= g_tc_pmj[l_ac].tc_pmj06t,     #No.FUN-550019
                                  tc_pmj07 = g_tc_pmj[l_ac].tc_pmj07,
                                  tc_pmj07t= g_tc_pmj[l_ac].tc_pmj07t,     #No.FUN-550019
                                  tc_pmj08 = g_tc_pmj[l_ac].tc_pmj08,
                                  tc_pmj09 = g_tc_pmj[l_ac].tc_pmj09,
                                  tc_pmj13 = g_tc_pmj[l_ac].tc_pmj13,      #No.FUN-810017
                                  tc_pmjicd14 = g_tc_pmj[l_ac].tc_pmjicd14, #FUN-A30072
                                  tc_pmj10 = g_tc_pmj[l_ac].tc_pmj10,
                                  tc_pmj15 = g_tc_pmj[l_ac].tc_pmj15,     #add by huanglf161025 
                                  tc_pmj16 = g_tc_pmj[l_ac].tc_pmj16,     #add by huanglf161025 
                                  tc_pmj17 = g_tc_pmj[l_ac].tc_pmj17,     #add by huanglf161025 
                                  tc_pmj18 = g_tc_pmj[l_ac].tc_pmj18,     #add by huanglf161025 
                                  tc_pmj19 = g_tc_pmj[l_ac].tc_pmj19,     #add by huanglf161025 
                                  tc_pmj20 = g_tc_pmj[l_ac].tc_pmj20,     #add by huanglf161025 
                                  tc_pmj21 = g_tc_pmj[l_ac].tc_pmj21      #add by huanglf161031 
               WHERE tc_pmj01=g_tc_pmi.tc_pmi01
                 AND tc_pmj02=g_tc_pmj_t.tc_pmj02
                 AND tc_pmj10=g_tc_pmj_t.tc_pmj10          #TQC-810025
                 AND tc_pmj12=g_tc_pmj12                #TQC-7B0089
                 AND tc_pmj13=g_tc_pmj_t.tc_pmj13          #No.FUN-810017
               
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err3("upd","tc_pmj_file",g_tc_pmi.tc_pmi01,g_tc_pmj_t.tc_pmj02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_tc_pmj[l_ac].* = g_tc_pmj_t.*
              ELSE
#No.TQC-960300---start---
                 IF g_tc_pmj[l_ac].tc_pmj02 != g_tc_pmj_t.tc_pmj02 THEN
                    UPDATE pmr_file SET pmr02 = g_tc_pmj[l_ac].tc_pmj02
                     WHERE pmr01 = g_tc_pmi.tc_pmi01
                       AND pmr02 = g_tc_pmj_t.tc_pmj02
                 END IF
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","pmr_file",g_tc_pmi.tc_pmi01,g_tc_pmj_t.tc_pmj02,SQLCA.sqlcode,"","",1)
                 LET g_tc_pmj[l_ac].* = g_tc_pmj_t.*
                 ELSE   
#No.TQC-960300---end---
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                 END IF                          #No.TQC-960300  
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac          #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_tc_pmj[l_ac].* = g_tc_pmj_t.*
              #FUN-D30034---add---str---
              ELSE
                 CALL g_tc_pmj.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034---add---end---
              END IF
              LET l_tc_pmi06 = g_tc_pmi.tc_pmi06  #FUN-C30293
              CLOSE i255_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_tc_pmi06 = '0'  #FUN-C30293
           LET l_ac_t = l_ac          #FUN-D30034 add
           CLOSE i255_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tc_pmj02) AND l_ac > 1 THEN
              LET g_tc_pmj[l_ac].* = g_tc_pmj[l_ac-1].*
              LET g_tc_pmj[l_ac].tc_pmj02 = NULL   #MOD-B60087 add
              NEXT FIELD tc_pmj02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION pricing_by_qty
           IF g_tc_pmi.tc_pmi05 = 'Y' THEN
              LET g_tmp_file = "tmp_",g_tmp_file CLIPPED,"_file"
              LET g_cmd = "tc_pmi255c '",g_tc_pmi.tc_pmi01 CLIPPED,"' ", g_tc_pmj[l_ac].tc_pmj02 CLIPPED," '",
                           g_tc_pmj[l_ac].tc_pmj03 CLIPPED,"' ", #MOD-530616
                           " '",g_tc_pmj[l_ac].tc_pmj031 CLIPPED,"' ", #MOD-530616
                           " '",g_tc_pmj[l_ac].tc_pmj032 CLIPPED,"' ", #MOD-530616
                           " '",g_tc_pmj[l_ac].tc_pmj11 CLIPPED,"' ", #MOD-530616
                           " '",g_tc_pmj[l_ac].tc_pmj05 CLIPPED,"' ", #MOD-530616
                          " '",g_prog CLIPPED,"' '",g_tmp_file CLIPPED,"' '",
                             g_tc_pmj[l_ac].tc_pmj10 CLIPPED,"'"  #No.FUN-670099
              CALL cl_cmdrun_wait(g_cmd)                  #MOD-530612
 
              IF g_tc_pmi.tc_pmiconf='N' AND g_tc_pmi.tc_pmi06 NOT MATCHES '[Ss]' THEN
                 LET g_sql = "SELECT tmp01 FROM ",g_tmp_file CLIPPED
                 PREPARE tmp_prep3 FROM g_sql
                 IF STATUS THEN CALL cl_err('tmp_prep3:',status,1) RETURN -1 END IF
                 DECLARE tmp_curs3 CURSOR FOR tmp_prep3
                 OPEN tmp_curs3
                 FETCH tmp_curs3 INTO g_tmp01
                 LET l_tc_pmi06 = g_tmp01
 
                 IF g_tmp01 <> g_tc_pmi.tc_pmi06 THEN
                    UPDATE tc_pmi_file set tc_pmi06=l_tc_pmi06 where tc_pmi01= g_tc_pmi.tc_pmi01
                 END IF
 
              END IF
              LET g_sql = "DROP TABLE ",g_tmp_file CLIPPED   #TQC-8C0068
              PREPARE drop_prep3 FROM g_sql   #TQC-8C0068
              EXECUTE drop_prep3   #TQC-8C0068
              SELECT tc_pmi06 INTO g_tc_pmi.tc_pmi06 FROM tc_pmi_file where tc_pmi01 = g_tc_pmi.tc_pmi01
              DISPLAY BY NAME g_tc_pmi.tc_pmi06
              CALL i255_pic()    #FUN-920106 add
           ELSE
              #不是分量計價資料
              CALL cl_err(g_tc_pmi.tc_pmi01,'apm-286',1)
           END IF
 
        ON ACTION item
           CASE
              WHEN INFIELD(tc_pmj03) #料件編號
                 IF g_sma.sma38 matches'[Yy]' THEN
                    CALL cl_cmdrun("aimi109 ")
                 ELSE
                    CALL cl_err(g_sma.sma38,'mfg0035',1)
                 END IF
              OTHERWISE EXIT CASE
           END CASE
#str-----add by guanyao160525
        ON ACTION pltj
           CALL i255_pl('b')      
#end-----add by guanyao160525
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_pmj03) #料件編號
#FUN-AA0059 --Begin--
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.form ="q_ima"
              #   LET g_qryparam.default1 = g_tc_pmj[l_ac].tc_pmj03
              #   CALL cl_create_qry() RETURNING g_tc_pmj[l_ac].tc_pmj03
                  CALL q_sel_ima(FALSE, "q_ima", "", g_tc_pmj[l_ac].tc_pmj03, "", "", "", "" ,"",'' )  RETURNING g_tc_pmj[l_ac].tc_pmj03
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_tc_pmj[l_ac].tc_pmj03           #No.MOD-490371
                 IF NOT cl_null(g_tc_pmj[l_ac].tc_pmj03) AND
                    g_tc_pmj[l_ac].tc_pmj03[1,4] !='MISC' THEN
                    CALL i255_tc_pmj03('d')
                    NEXT FIELD tc_pmj03
                 END IF
              WHEN INFIELD(tc_pmj05)     #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = ''
                 CALL cl_create_qry() RETURNING g_tc_pmj[l_ac].tc_pmj05
                  DISPLAY BY NAME g_tc_pmj[l_ac].tc_pmj05           #No.MOD-490371
                 NEXT FIELD tc_pmj05
              WHEN INFIELD(tc_pmj13)                                                                                                   
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form ="q_sga"                                                                                       
                 LET g_qryparam.default1 = g_tc_pmj[l_ac].tc_pmj13                                                                        
                 CALL cl_create_qry() RETURNING g_tc_pmj[l_ac].tc_pmj13                                                                   
                 DISPLAY BY NAME g_tc_pmj[l_ac].tc_pmj13                                                                                  
              WHEN INFIELD(tc_pmj10)     #作業編號
                 CALL q_ecd(FALSE,TRUE,'') RETURNING g_tc_pmj[l_ac].tc_pmj10
                  DISPLAY BY NAME g_tc_pmj[l_ac].tc_pmj10           #No.MOD-490371
                 SELECT ecd02 INTO g_tc_pmj[l_ac].ecd02
                   FROM ecd_file
                  WHERE ecd01 = g_tc_pmj[l_ac].tc_pmj10
                 IF SQLCA.sqlcode = 100 THEN
                    LET g_tc_pmj[l_ac].ecd02 = ''
                 END IF
                 NEXT FIELD tc_pmj10
               WHEN INFIELD(tc_pmj11) #工艺说明
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ecb12"
                 LET g_qryparam.default1 =''
                 #LET g_qryparam.default1 = g_pmj[l_ac].pmj03
                 CALL cl_create_qry() RETURNING g_tc_pmj[l_ac].tc_pmj11
                 NEXT FIELD tc_pmj11
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION query_supplier_item
           CASE
              WHEN INFIELD(tc_pmj03) #料件編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmh"
                 LET g_qryparam.arg1 = g_tc_pmi.tc_pmi03 #MOD-980012   
                 LET g_qryparam.default1 = g_tc_pmj[l_ac].tc_pmj03
                 CALL cl_create_qry() RETURNING g_tc_pmj[l_ac].tc_pmj03
                 CALL i255_tc_pmj03('d')
                 NEXT FIELD tc_pmj03
                 WHEN INFIELD(tc_pmj11) #工艺说明
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ecb12"
                 LET g_qryparam.default1 =''
                 #LET g_qryparam.default1 = g_pmj[l_ac].pmj03
                 CALL cl_create_qry() RETURNING g_tc_pmj[l_ac].tc_pmj11
                 NEXT FIELD tc_pmj11
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    END INPUT
 
   IF l_flag != 'Y' THEN     #MOD-920027
      LET g_tc_pmi.tc_pmimodu = g_user
      LET g_tc_pmi.tc_pmidate = g_today
      UPDATE tc_pmi_file SET tc_pmimodu = g_tc_pmi.tc_pmimodu,tc_pmidate = g_tc_pmi.tc_pmidate
       WHERE tc_pmi01 = g_tc_pmi.tc_pmi01
      DISPLAY BY NAME g_tc_pmi.tc_pmimodu,g_tc_pmi.tc_pmidate
   END IF             #MOD-920027   
 
        UPDATE tc_pmi_file SET tc_pmi06 = l_tc_pmi06
           WHERE tc_pmi01=g_tc_pmi.tc_pmi01
        LET g_tc_pmi.tc_pmi06 = l_tc_pmi06
        DISPLAY BY NAME g_tc_pmi.tc_pmi06
        CALL i255_pic()      #FUN-920106
 
    IF g_tc_pmi.tc_pmi05 = 'Y' THEN
       LET g_sql = "SELECT DISTINCT pmr02 ",   
                   " FROM pmr_file",
                   " WHERE pmr01 ='",g_tc_pmi.tc_pmi01,"'"      
       PREPARE pmrchk_pre FROM g_sql
       DECLARE pmrchk_cs                       #CURSOR
           CURSOR FOR pmrchk_pre
       LET g_cnt = 0
       FOREACH pmrchk_cs INTO l_pmr02
          IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
          END IF
          SELECT COUNT(*) INTO g_cnt
            FROM tc_pmj_file
           WHERE tc_pmj01 = g_tc_pmi.tc_pmi01 AND tc_pmj02 = l_pmr02
          IF g_cnt = 0 THEN
             DELETE FROM pmr_file 		
             WHERE pmr01 = g_tc_pmi.tc_pmi01 AND pmr02 = l_pmr02	
          END IF
       END FOREACH
    END IF 
 
    CLOSE i255_bcl
    COMMIT WORK
 
#   CALL i255_delall() #MOD-7A0085-add  #CHI-C30002 mark
    CALL i255_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i255_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_tc_pmi.tc_pmi01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM tc_pmi_file ",
                  "  WHERE tc_pmi01 LIKE '",l_slip,"%' ",
                  "    AND tc_pmi01 > '",g_tc_pmi.tc_pmi01,"'"
      PREPARE i255_pb1 FROM l_sql 
      EXECUTE i255_pb1 INTO l_cnt      
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         #CALL i255_x() #FUN-D20025 mark
         CALL i255_x(1) #FUN-D20025 add
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM tc_pmi_file WHERE tc_pmi01 = g_tc_pmi.tc_pmi01
         INITIALIZE g_tc_pmi.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i255_delall()
#
#   LET g_cnt= 0
#   SELECT COUNT(*) INTO g_cnt FROM tc_pmj_file
#    WHERE tc_pmj01 = g_tc_pmi.tc_pmi01 
#
#   IF g_cnt = 0 THEN 
#      			# 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM tc_pmi_file WHERE tc_pmi01 = g_tc_pmi.tc_pmi01 
#      CLEAR FORM        #MOD-C30482 add
#   END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i255_tc_pmj03_def()  #帶出料件廠商之資料

   SELECT pmh04,pmh06,pmh12,pmh19,pmh13
     INTO g_tc_pmj[l_ac].tc_pmj04,g_tc_pmj[l_ac].tc_pmj08,g_tc_pmj[l_ac].tc_pmj06,
          g_tc_pmj[l_ac].tc_pmj06t,g_tc_pmj[l_ac].tc_pmj05
     FROM pmh_file
    WHERE pmh01 = g_tc_pmj[l_ac].tc_pmj03
      AND pmh02=g_tc_pmi.tc_pmi03
      AND pmh13 = g_tc_pmj[l_ac].tc_pmj05
      AND pmhacti = 'Y'                                           #CHI-910021
 
   IF cl_null(g_tc_pmj[l_ac].tc_pmj06) THEN
      LET g_tc_pmj[l_ac].tc_pmj06 = 0
   END IF
 
   IF cl_null(g_tc_pmj[l_ac].tc_pmj08) THEN
      LET g_tc_pmj[l_ac].tc_pmj08 = ' '
   END IF
   #要重show,不然會影響ON ROW CHANGE
   DISPLAY g_tc_pmj[l_ac].tc_pmj04,g_tc_pmj[l_ac].tc_pmj08,g_tc_pmj[l_ac].tc_pmj06,
           g_tc_pmj[l_ac].tc_pmj06t,g_tc_pmj[l_ac].tc_pmj05                      #No.FUN-610018   
        TO tc_pmj04,tc_pmj08,tc_pmj06,tc_pmj06t,tc_pmj05                          
 
   IF cl_null(g_tc_pmj[l_ac].tc_pmj06t) THEN
      LET g_tc_pmj[l_ac].tc_pmj06t = g_tc_pmj[l_ac].tc_pmj06 * ( 1 + g_tc_pmi.tc_pmi081/100)
   END IF
 
END FUNCTION
 
FUNCTION i255_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON tc_pmj02,tc_pmj03,tc_pmj04,tc_pmj10 ,tc_pmjicd14,tc_pmj05,	   #FUN-A30072
                       tc_pmj06,tc_pmj06t,tc_pmj07,tc_pmj07t,tc_pmj08,tc_pmj09,tc_pmj13,tc_pmj14,
                       tc_pmj15,tc_pmj16,tc_pmj17,tc_pmj18,tc_pmj19,tc_pmj20,tc_pmj21  #add by huanglf161031      #No.FUN-810017 add tc_pmj13   #No.FUN-9C0046 add tc_pmj14
            FROM s_pmj[1].tc_pmj02,s_pmj[1].tc_pmj03,s_pmj[1].tc_pmj04,s_pmj[1].tc_pmj10,
                 s_pmj[1].tc_pmjicd14,s_pmj[1].tc_pmj05,s_pmj[1].tc_pmj06,s_pmj[1].tc_pmj06t,  #FUN-A30072
                 s_pmj[1].tc_pmj07,s_pmj[1].tc_pmj07t,
                 s_pmj[1].tc_pmj08,s_pmj[1].tc_pmj09,s_pmj[1].tc_pmj13,s_pmj[1].tc_pmj14,
                 s_pmj[1].tc_pmj15,s_pmj[1].tc_pmj16,s_pmj[1].tc_pmj17,s_pmj[1].tc_pmj18,
                 s_pmj[1].tc_pmj19,s_pmj[1].tc_pmj20,s_pmj[1].tc_pmj21 #add by huanglf161031        #NO.FUN-810017 add tc_pmj13  #No.FUN-9C0046 add tc_pmj14 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
 
    CALL i255_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i255_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   #p_wc2           LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200) #TQC-BA0191
    p_wc2           STRING #TQC-BA0191
DEFINE l_ima02    LIKE ima_file.ima02,                                                                                              
       l_ima021   LIKE ima_file.ima021,                                                                                             
       l_imaacti  LIKE ima_file.imaacti                                                                                             
DEFINE  l_s      LIKE type_file.chr1000                                                                                             
DEFINE  l_m      LIKE type_file.chr1000                                                                                             
DEFINE  i        LIKE type_file.num5                                                                                                
 
    IF cl_null(p_wc2) THEN
       LET p_wc2='1=1 '
    END IF
 
    LET g_sql = "SELECT tc_pmj02,tc_pmj03,tc_pmj031,tc_pmj032,tc_pmj11,tc_pmj04,ima44,ima908,tc_pmj10,ecd02,'',",#No.FUN-930061 add ecd02 #add ecbud02 by guanyao160730
                "       tc_pmj13,tc_pmjicd14,tc_pmj05,tc_pmj06,tc_pmj06t,",  #FUN-560193  add ima44,ima908 #No.FUN-810017 add tc_pmj13   #FUN-A30072
                " tc_pmj07,tc_pmj07t,tc_pmj08,tc_pmj09,tc_pmj14,tc_pmj15,tc_pmj16,tc_pmj17,tc_pmj18,tc_pmj19,tc_pmj20,tc_pmj21",  #add by huanglf161031     #end No.FUN-550019    #No.FUN-9C0046 add tc_pmj14
#TQC-AB0025------------------mod-----------------str------------------
#               " FROM tc_pmj_file,OUTER ima_file,OUTER ecd_file",  #FUN-560193 add OUTER ima_file#No.FUN-930061 add ecd_file
#               " WHERE tc_pmj01 ='",g_tc_pmi.tc_pmi01,"' AND ",  #單頭
#               p_wc2 CLIPPED,                           #單身
#               " AND tc_pmj_file.tc_pmj03=ima_file.ima01 ",  #FUN-560193
#               " AND tc_pmj10=ecd_file.ecd01 ",  #FUN-930061
                #" FROM tc_pmj_file,ima_file ON tc_pmj_file.tc_pmj03=ima_file.ima01 ",
                " FROM tc_pmj_file,ima_file,ecd_file,ecb_file WHERE tc_pmj_file.tc_pmj03=ima_file.ima01 ",
                " AND tc_pmj_file.tc_pmj10 = ecd_file.ecd01 ",
              #  " LEFT JOIN ecb_file ON ecb01 = tc_pmj03 AND ecb06 = tc_pmj10",     #add by guanyao160730
                " AND ecb01(+) = tc_pmj_file.tc_pmj03 AND ecb06(+) = tc_pmj_file.tc_pmj10 and nvl(tc_pmj_file.tc_pmj11,'a')=ecb02(+)", 
                " AND tc_pmj01 ='",g_tc_pmi.tc_pmi01,"' AND ",p_wc2 CLIPPED, 
#TQC-AB0025------------------mod-----------------end------------------                
                " ORDER BY 1"
    PREPARE i255_pb FROM g_sql
    DECLARE tc_pmj_cs                       #CURSOR
        CURSOR FOR i255_pb
 
    CALL g_tc_pmj.clear()
    LET g_cnt = 1
    FOREACH tc_pmj_cs INTO g_tc_pmj[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_errno = ' '

        SELECT ecbud02 INTO g_tc_pmj[g_cnt].ecbud02 FROM  ecb_file,ecu_file 
        WHERE ecb01 = g_tc_pmj[g_cnt].tc_pmj03 AND ecb06 = g_tc_pmj[g_cnt].tc_pmj10 
          AND ecu01 = ecb01 AND ecu02 = ecb02
          AND ecu02 = (SELECT MAX(ecu02)  FROM  ecb_file,ecu_file 
                       WHERE ecb01 = g_tc_pmj[g_cnt].tc_pmj03 AND ecb06 = g_tc_pmj[g_cnt].tc_pmj10 
                       AND ecu01 = ecb01 AND ecu02 = ecb02)
        SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
          FROM ima_file WHERE ima01=g_tc_pmj[g_cnt].tc_pmj03
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                      LET l_ima02 = NULL
                                      LET l_ima021= NULL
            WHEN l_imaacti='N' LET g_errno = '9028'
            WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
        LET l_m = ' '
        IF g_sma.sma120 = 'Y' THEN                 
           IF NOT cl_null(g_errno) THEN 
              LET g_buf = g_tc_pmj[g_cnt].tc_pmj03
              LET l_s = g_buf.trim()
             FOR i=1 TO length(l_s)                                                                                                  
                IF l_s[i,i] = '_' THEN                                                                                              
                   LET l_m = l_s[1,i-1]                                                                                             
                   EXIT FOR                                                                                                         
                ELSE                                                                                                                
                   CONTINUE FOR                                                                                                     
                END IF                                                                                                              
               IF l_s[i,i] = '-' THEN                                                                                               
                  LET l_m = l_s[1,i-1]                                                                                              
                  EXIT FOR                                                                                                          
               ELSE                                                                                                                 
                 CONTINUE FOR                                                                                                       
               END IF                                                                                                               
               IF l_s[i,i] = ' ' THEN                                                                                               
                  LET l_m = l_s[1,i-1]                                                                                              
                  EXIT FOR                                                                                                          
               ELSE                                                                                                                 
                 CONTINUE FOR                                                                                                       
               END IF                                                                                                               
            END FOR
           END IF
        END IF
          IF NOT cl_null(l_m) THEN                                                                                                     
          SELECT ima44,ima908 INTO g_tc_pmj[g_cnt].ima44,g_tc_pmj[g_cnt].ima908        
            FROM ima_file                                                                                                           
           WHERE ima01 = l_m
          END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tc_pmj.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i255_update_price()              #CHANGE tc_pmi08
 
    DEFINE  l_tc_pmj02   LIKE tc_pmj_file.tc_pmj02,                                      
            l_tc_pmj07   LIKE tc_pmj_file.tc_pmj07,                                      
            l_tc_pmj07t  LIKE tc_pmj_file.tc_pmj07t,
            l_tc_pmj05   LIKE tc_pmj_file.tc_pmj05   #MOD-910036   增加tc_pmj05                                    
 
    IF g_tc_pmj[l_ac].tc_pmj02 IS NULL THEN
       RETURN
    END IF
 
    LET g_sql = "SELECT tc_pmj02,tc_pmj07,tc_pmj07t,tc_pmj05 ",   #MOD-910036   增加tc_pmj05
                " FROM tc_pmj_file",
                " WHERE tc_pmj01 ='",g_tc_pmi.tc_pmi01,"'"          #單頭
 
    PREPARE i255_upd FROM g_sql
 
    DECLARE upd_cs                       #CURSOR
        CURSOR FOR i255_upd
 
    LET g_cnt = 1
    FOREACH upd_cs INTO l_tc_pmj02,l_tc_pmj07,l_tc_pmj07t,l_tc_pmj05  #單身    #MOD-910036   增加tc_pmj05
 
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       SELECT azi03 INTO t_azi03 FROM azi_file
         WHERE azi01=l_tc_pmj05
       #含稅單價                                                                  
       IF g_gec07 = 'N' THEN
           LET l_tc_pmj07t= l_tc_pmj07 * (1 + g_tc_pmi.tc_pmi081/100)
           LET l_tc_pmj07t = cl_digcut(l_tc_pmj07t,t_azi03)   #MOD-910036   g_azi03-->t_azi03
       ELSE
           LET l_tc_pmj07 = l_tc_pmj07t / (1 + g_tc_pmi.tc_pmi081/100)
           LET l_tc_pmj07 = cl_digcut(l_tc_pmj07,t_azi03)    #MOD-910036   g_azi03-->t_azi03
       END IF
    
       UPDATE tc_pmj_file SET tc_pmj07 = l_tc_pmj07,
                           tc_pmj07t = l_tc_pmj07t
       WHERE tc_pmj01=g_tc_pmi.tc_pmi01 AND tc_pmj02=l_tc_pmj02 
 
       IF SQLCA.SQLCODE THEN
          LET g_success = FALSE
          ROLLBACK WORK
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_tc_pmj.deleteElement(g_cnt)
    CALL i255_show()
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i255_update_price1()       #CHANGE tc_pmi08  WHEN tc_pmi05="Y" 分量計價
 
    DEFINE  l_tc_pmj02   LIKE tc_pmj_file.tc_pmj02,                                      
            l_pmr03   LIKE pmr_file.pmr03,                                      
            l_pmr04   LIKE pmr_file.pmr04,                                      
            l_pmr05   LIKE pmr_file.pmr05,                                      
            l_pmr05t  LIKE pmr_file.pmr05t,                                    
            l_tc_pmj05   LIKE tc_pmj_file.tc_pmj05   #MOD-910036
 
    IF g_tc_pmj[l_ac].tc_pmj02 IS NULL THEN
       RETURN
    END IF
#第一層
 
    LET g_sql = "SELECT tc_pmj02,tc_pmj05 ",   #MOD-910036  增加tc_pmj05
                " FROM tc_pmj_file",
                " WHERE tc_pmj01 ='",g_tc_pmi.tc_pmi01,"'"          #單頭
 
    PREPARE i255_upd1 FROM g_sql
 
    DECLARE upd_cs1                       #CURSOR
        CURSOR FOR i255_upd1
 
    LET g_cnt1 = 1
    FOREACH upd_cs1 INTO l_tc_pmj02,l_tc_pmj05   #單身 ARRAY 填充   #MOD-910036  增加tc_pmj05
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
#第二層
    LET g_forupd_sql=
        "SELECT pmr03,pmr04,pmr05,pmr05t ", 
        "  FROM pmr_file ",
        " WHERE pmr01 ='",g_tc_pmi.tc_pmi01,"'", 
        "   AND pmr02 = ",l_tc_pmj02,
        " ORDER BY pmr03,pmr04,pmr05 "
 
    PREPARE i255_upd2 FROM g_forupd_sql
 
    DECLARE upd_cs2                      #CURSOR
        CURSOR FOR i255_upd2
 
    LET g_cnt = 1
    FOREACH upd_cs2 INTO l_pmr03,l_pmr04,l_pmr05,l_pmr05t   #分量計價 單身 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #分量計價                                                                 
        SELECT azi03 INTO t_azi03 FROM azi_file
          WHERE azi01 = l_tc_pmj05
        IF g_gec07 = 'N' THEN
            LET l_pmr05t = l_pmr05 * (1 + g_tc_pmi.tc_pmi081/100)
            LET l_pmr05t = cl_digcut(l_pmr05t,t_azi03)   #MOD-910036   g_azi03-->t_azi03
        ELSE
            LET l_pmr05 = l_pmr05t / (1 + g_tc_pmi.tc_pmi081/100)
            LET l_pmr05 = cl_digcut(l_pmr05,t_azi03)   #MOD-910036   g_azi03-->t_azi03
        END IF
 
        UPDATE pmr_file SET  pmr05  = l_pmr05,
                             pmr05t = l_pmr05t  
        WHERE pmr01=g_tc_pmi.tc_pmi01 
          AND pmr02=l_tc_pmj02
          AND pmr03=l_pmr03
          AND pmr04=l_pmr04
 
        IF SQLCA.SQLCODE THEN
           LET g_success = FALSE
           ROLLBACK WORK
        END IF
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tc_pmj.deleteElement(g_cnt)
    LET g_cnt = 0
#第二層結束
        IF SQLCA.SQLCODE THEN
           LET g_success = FALSE
           ROLLBACK WORK
        END IF
        LET g_cnt1 = g_cnt1 + 1
        IF g_cnt1 > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tc_pmj.deleteElement(g_cnt1)
    LET g_cnt = 0
#第一層結束
 
END FUNCTION
 
 
FUNCTION i255_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_pmj TO s_pmj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i255_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i255_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i255_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i255_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i255_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF 
         CALL i255_pic()     #FUN-920106
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION 分量計價資料
      ON ACTION pricing_by_qty
         LET g_action_choice="pricing_by_qty"
         EXIT DISPLAY
#str----add by guanyao160525
      ON ACTION pltj
         LET g_action_choice="pltj"
         EXIT DISPLAY
#end----add by guanyao160525
#@    ON ACTION 送簽
      ON ACTION easyflow_approval     #MOD-4A0299
         LET g_action_choice="easyflow_approval"
         EXIT DISPLAY
#str----add by guanyao160525
      ON ACTION price_u
         LET g_action_choice="price_u"
         EXIT DISPLAY
#end----add by guanyao160525
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
#FUN-D20025 add
#@    ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
#FUN-D20025 add 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      #@ON ACTION 簽核狀況
       ON ACTION approval_status     #MOD-4C0041
         LET g_action_choice="approval_status"
         EXIT DISPLAY
 
      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY
 
      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY
 
      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY
 
      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY
 
      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY
 
      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
         
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i255_copy()
DEFINE
    l_newno         LIKE tc_pmi_file.tc_pmi01,
    l_newdate       LIKE tc_pmi_file.tc_pmi02,
    l_tc_pmi03         LIKE tc_pmi_file.tc_pmi03, #MOD-570060
    l_oldno         LIKE tc_pmi_file.tc_pmi01,
    li_result       LIKE type_file.num5   #No.FUN-550060  #No.FUN-680136 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_pmi.tc_pmi01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
     LET l_newno   = NULL              #MOD-480231
     LET l_newdate = NULL              #MOD-480231
     LET l_tc_pmi03   = NULL              #MOD-570060
     LET g_before_input_done = FALSE   #MOD-480231
     CALL i255_set_entry('a')          #MOD-480231
     LET g_before_input_done = TRUE    #MOD-480231
 
     CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
     INPUT l_newno,l_newdate,l_tc_pmi03 FROM tc_pmi01,tc_pmi02,tc_pmi03 #MOD-570060 add tc_pmi03
 
        BEFORE INPUT
            CALL cl_set_docno_format("tc_pmi01")      #No.FUN-550060
 
        AFTER FIELD tc_pmi01
                CALL s_check_no("apm",l_newno,"","5","tc_pmi_file","tc_pmi01","")
                   RETURNING li_result,l_newno
                DISPLAY l_newno to tc_pmi01
                IF (NOT li_result) THEN
                    NEXT FIELD tc_pmi01
                END IF
 
        AFTER FIELD tc_pmi02
             IF cl_null(l_newdate) THEN NEXT FIELD tc_pmi02 END IF  #MOD-790163 modify
                BEGIN WORK
                CALL s_auto_assign_no("apm",l_newno,l_newdate,"5","tc_pmi_file","tc_pmi01","","","")
                  RETURNING li_result,l_newno
                IF (NOT li_result) THEN
                  NEXT FIELD tc_pmi01
                END IF
                DISPLAY l_newno to tc_pmi01
 
        AFTER FIELD tc_pmi03                       #廠商編號
           IF NOT cl_null(l_tc_pmi03) THEN
               LET g_chr=NULL
               LET g_tc_pmi.tc_pmi03=l_tc_pmi03
               CALL i255_tc_pmi03('a')
               LET g_tc_pmi.tc_pmi03=NULL
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(l_tc_pmi03,g_errno,0)
                  NEXT FIELD tc_pmi03
               END IF
           END IF
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(tc_pmi01) #單據編號
                    LET g_t1=s_get_doc_no(l_newno)     #No.FUN-550060
                    CALL q_smy(FALSE,FALSE,g_t1,'APM','5') RETURNING g_t1 #TQC-670008
                    LET l_newno=g_t1                   #No.FUN-550060
                    DISPLAY l_newno TO tc_pmi01
                    CALL i255_tc_pmi01('d')
                    NEXT FIELD tc_pmi01
               WHEN INFIELD(tc_pmi03) #廠商編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pmc1"
                  LET g_qryparam.default1 = l_tc_pmi03
                  CALL cl_create_qry() RETURNING l_tc_pmi03
                  DISPLAY l_tc_pmi03 TO tc_pmi03
                  NEXT FIELD tc_pmi03
               OTHERWISE EXIT CASE
            END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       ROLLBACK WORK         #No.FUN-550060
       DISPLAY BY NAME g_tc_pmi.tc_pmi01
       DISPLAY BY NAME g_tc_pmi.tc_pmi02  #TQC-AC0402
       DISPLAY BY NAME g_tc_pmi.tc_pmi03  #TQC-AC0402
       RETURN
    END IF
 
     #MOD-4B0197(整段的羅輯重新組合過,因為要1.將複製過程包Transaction
    #                                      2.複製時要一併複製分量計價檔)
    #單頭
    DROP TABLE y
    SELECT * FROM tc_pmi_file
        WHERE tc_pmi01=g_tc_pmi.tc_pmi01
        INTO TEMP y
 
    #單身
    DROP TABLE x
    SELECT * FROM tc_pmj_file
     WHERE tc_pmj01=g_tc_pmi.tc_pmi01
      INTO TEMP x
 
    #分量計價檔
    DROP TABLE z
    SELECT * FROM pmr_file
     WHERE pmr01=g_tc_pmi.tc_pmi01
      INTO TEMP z
 
    BEGIN WORK
    LET g_success = 'Y'
 
    #==>單頭複製
    UPDATE y SET tc_pmi01=l_newno,    #新的鍵值
                 tc_pmi02=l_newdate,  #新的鍵值
                  tc_pmi03=l_tc_pmi03,    #MOD-570060
                 tc_pmiuser=g_user,   #資料所有者
                 tc_pmigrup=g_grup,   #資料所有者所屬群
                 tc_pmimodu=NULL,     #資料修改日期
                 tc_pmidate=g_today,  #資料建立日期
                 tc_pmiacti='Y',      #有效資料
                 tc_pmiconf='N',       #確認
                  tc_pmi07 = g_smy.smyapr,      #MOD-4A0299
                  tc_pmi06 = '0'               #MOD-4A0299
 
    INSERT INTO tc_pmi_file SELECT * FROM y
 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","tc_pmi_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
        LET g_success = 'N'
        ROLLBACK WORK
        RETURN
     ELSE
        COMMIT WORK
     END IF
 
    IF g_success = 'Y' AND g_tc_pmi.tc_pmi05 = 'Y' THEN
        #==>分量計價檔複製
        UPDATE z SET pmr01=l_newno
        INSERT INTO pmr_file SELECT * FROM z
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pmr_file","","",SQLCA.sqlcode,"","INSERT INTO pmr_file",1)  #No.FUN-660129
            LET g_success = 'N'
        END IF
    END IF
    IF g_success = 'Y' THEN
        #==>單身複製
        UPDATE x SET tc_pmj01=l_newno
        INSERT INTO tc_pmj_file SELECT * FROM x
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tc_pmj_file","","",SQLCA.sqlcode,"","INSERT INTO tc_pmj_file",1)  #No.FUN-660129
            LET g_success = 'N'
        ELSE
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
        END IF
    END IF
 
    IF g_success = 'Y' THEN
        COMMIT WORK
        LET l_oldno = g_tc_pmi.tc_pmi01
        SELECT tc_pmi_file.* INTO g_tc_pmi.* FROM tc_pmi_file WHERE tc_pmi01 = l_newno
        CALL i255_u()
        #CALL i255_b()   #mark by guanyao160525
        CALL i255_b('i') #add by guanyao160525
    ELSE
        ROLLBACK WORK
    END IF
 
    #SELECT tc_pmi_file.* INTO g_tc_pmi.* FROM tc_pmi_file WHERE tc_pmi01 = l_oldno  #FUN-C80046
 
    CALL i255_show()
 
END FUNCTION
 
FUNCTION i255_out()
   DEFINE l_cmd        LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
          l_wc,l_wc2   LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(50)
          l_prtway     LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
 
   SELECT COUNT(*) INTO l_cnt
     FROM tc_pmj_file
    WHERE tc_pmj01=g_tc_pmi.tc_pmi01
 
   IF l_cnt = 0 OR l_cnt IS NULL THEN
      CALL cl_err('','arm-034',1)
      RETURN
   END IF
 
   CALL cl_wait()
 
   LET l_wc='tc_pmi01="',g_tc_pmi.tc_pmi01,'"'
 
   SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'apmr255'
   IF SQLCA.sqlcode OR l_wc2 IS NULL THEN
      LET l_wc2 = " '3' 'N' "
   END IF
 
   LET l_cmd = "apmr255",
                " '",g_today CLIPPED,"' ''",
                " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                " '",l_wc CLIPPED,"' '3'"    #,l_wc2   #No.TQC-610085 mark   #TQC-740117 add '3'(tm.a)
 
   CALL cl_cmdrun(l_cmd)
 
   ERROR ' '
 
END FUNCTION
#---確認
 
FUNCTION i255_z()
   DEFINE  l_tc_pmj           RECORD LIKE tc_pmj_file.*
 
   IF g_tc_pmi.tc_pmi01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tc_pmi.* FROM tc_pmi_file
     WHERE tc_pmi01=g_tc_pmi.tc_pmi01
   IF g_tc_pmi.tc_pmiconf='X' THEN CALL cl_err(g_tc_pmi.tc_pmiconf,'9024',0) RETURN END IF
   IF g_tc_pmi.tc_pmiconf='N' THEN RETURN END IF
   IF g_tc_pmi.tc_pmi06 = 'S' THEN
      CALL cl_err(g_tc_pmi.tc_pmi06,'apm-030',1)
      RETURN
   END IF
 
   #(廠商+料號+幣別+作業編號)尚有未確認之核價單
   DECLARE i255_chk_tc_pmj CURSOR FOR
       SELECT tc_pmj03,tc_pmj05,tc_pmj10 FROM tc_pmj_file
        WHERE tc_pmj01 = g_tc_pmi.tc_pmi01
 
   INITIALIZE l_tc_pmj.* TO NULL
 
   FOREACH i255_chk_tc_pmj INTO l_tc_pmj.tc_pmj03,l_tc_pmj.tc_pmj05,l_tc_pmj.tc_pmj10
      SELECT tc_pmj01 INTO l_tc_pmj.tc_pmj01 FROM tc_pmi_file,tc_pmj_file
       WHERE tc_pmi03=g_tc_pmi.tc_pmi03
         AND tc_pmi08=g_tc_pmi.tc_pmi08        #No.FUN-550019
         AND tc_pmiconf='N'
         AND tc_pmi01!=g_tc_pmi.tc_pmi01
         AND tc_pmj01=tc_pmi01
         AND tc_pmj03[1,4] != 'MISC'
         AND tc_pmj03 = l_tc_pmj.tc_pmj03
         AND tc_pmj05 = l_tc_pmj.tc_pmj05
         AND tc_pmj10 = l_tc_pmj.tc_pmj10
         AND tc_pmj12=g_tc_pmj12  #No.FUN-670099
      IF NOT cl_null(l_tc_pmj.tc_pmj01) THEN
         LET g_message = NULL
         LET g_message = 'NO:',l_tc_pmj.tc_pmj01,'==>',l_tc_pmj.tc_pmj03 CLIPPED
         LET g_message = g_message CLIPPED
         CALL cl_err(g_message,'apm-262',0)
         RETURN
      END IF
      INITIALIZE l_tc_pmj.* TO NULL
   END FOREACH
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
   OPEN i255_cl USING g_tc_pmi.tc_pmi01
   IF STATUS THEN
      CALL cl_err("OPEN i255_cl:", STATUS, 1)
      CLOSE i255_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i255_cl INTO g_tc_pmi.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_pmi.tc_pmi01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
   LET g_tc_pmi.tc_pmi06 = '0'
 
    UPDATE tc_pmi_file SET tc_pmiconf='N',
                        tc_pmi06 = g_tc_pmi.tc_pmi06
                        #,tc_pmimodu=g_user,     #MOD-920027 add #MOD-C90034 mark
                        #tc_pmidate=g_today      #MOD-920027 add #MOD-C90034 mark
                WHERE tc_pmi01=g_tc_pmi.tc_pmi01
 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","tc_pmi_file",g_tc_pmi.tc_pmi01,"","apm-266","","upd tc_pmi_file",1)  #No.FUN-660129
      LET g_success='N'
   END IF
 
   IF g_tc_pmi.tc_pmi07 = 'N' AND g_tc_pmi.tc_pmi06 = '1' THEN
      LET g_tc_pmi.tc_pmi06 = '0'
      UPDATE tc_pmi_file SET tc_pmi06 = g_tc_pmi.tc_pmi06 WHERE tc_pmi01 = g_tc_pmi.tc_pmi01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","tc_pmi_file",g_tc_pmi.tc_pmi01,"","apm-266","","upd tc_pmi_file",1)  #No.FUN-660129
         LET g_success = 'N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      LET g_tc_pmi.tc_pmiconf='N'
      #LET g_tc_pmi.tc_pmimodu=g_user  #MOD-920027 add #MOD-C90034 mark
      #LET g_tc_pmi.tc_pmidate=g_today #MOD-920027 add #MOD-C90034 mark
      COMMIT WORK
      #DISPLAY BY NAME g_tc_pmi.tc_pmimodu    #MOD-920027 add #MOD-C90034 mark
      #DISPLAY BY NAME g_tc_pmi.tc_pmidate    #MOD-920027 add #MOD-C90034 mark
      DISPLAY BY NAME g_tc_pmi.tc_pmiconf
      DISPLAY BY NAME g_tc_pmi.tc_pmi06
   ELSE
      LET g_tc_pmi.tc_pmiconf='Y'
      DISPLAY BY NAME g_tc_pmi.tc_pmiconf
      DISPLAY BY NAME g_tc_pmi.tc_pmi06
      ROLLBACK WORK
   END IF
  
   CALL i255_pic()       #FUN-920106
END FUNCTION
 
#FUNCTION i255_x() #FUN-D20025 mark
FUNCTION i255_x(p_type) #FUN-D20025 add
   DEFINE  l_tc_pmj           RECORD LIKE tc_pmj_file.*
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20025 add  
   IF g_tc_pmi.tc_pmi01 IS NULL THEN RETURN END IF
   SELECT * INTO g_tc_pmi.* FROM tc_pmi_file
    WHERE tc_pmi01=g_tc_pmi.tc_pmi01
   IF g_tc_pmi.tc_pmiconf='Y' THEN CALL cl_err('','atm-046',1) RETURN END IF   #No.TQC-740144
   #非開立狀態，不可異動！   
   #FUN-D20025---begin 
   IF p_type = 1 THEN 
      IF g_tc_pmi.tc_pmiconf='X' THEN RETURN END IF
   ELSE
      IF g_tc_pmi.tc_pmiconf<>'X' THEN RETURN END IF
   END IF 
   #FUN-D20025---end       
   BEGIN WORK
   LET g_success = 'Y'
    IF g_tc_pmi.tc_pmi06 matches '[Ss1]' THEN          #MOD-4A0299
         CALL cl_err("","mfg3557",0)
         RETURN
   END IF
 
   OPEN i255_cl USING g_tc_pmi.tc_pmi01
   IF STATUS THEN
      CALL cl_err("OPEN i255_cl:", STATUS, 1)
      CLOSE i255_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i255_cl INTO g_tc_pmi.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_pmi.tc_pmi01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_tc_pmi.tc_pmiconf) THEN
      IF g_tc_pmi.tc_pmiconf ='N' THEN
         LET g_tc_pmi.tc_pmiconf='X'
          LET g_tc_pmi.tc_pmi06='9'           #MOD-4A0299
      ELSE
         LET g_tc_pmi.tc_pmiconf='N'
          LET g_tc_pmi.tc_pmi06='0'           #MOD-4A0299
      END IF
      UPDATE tc_pmi_file SET
             tc_pmiconf=g_tc_pmi.tc_pmiconf,
             tc_pmimodu=g_user,
             tc_pmidate=g_today,
              tc_pmi06 =g_tc_pmi.tc_pmi06          #MOD-4A0299
       WHERE tc_pmi01=g_tc_pmi.tc_pmi01
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","tc_pmi_file",g_tc_pmi.tc_pmi01,"","apm-266","","upd tc_pmi_file",1)  #No.FUN-660129
         LET g_success='N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_tc_pmi.tc_pmi01,'V')
      DISPLAY BY NAME g_tc_pmi.tc_pmiconf
      DISPLAY BY NAME g_tc_pmi.tc_pmi06
   ELSE
      LET g_tc_pmi.tc_pmiconf= g_tc_pmi_t.tc_pmiconf
      LET g_tc_pmi.tc_pmi06 = g_tc_pmi_t.tc_pmi06
      DISPLAY BY NAME g_tc_pmi.tc_pmiconf
      DISPLAY BY NAME g_tc_pmi.tc_pmi06
      ROLLBACK WORK
   END IF
 
   SELECT tc_pmiconf,tc_pmimodu,tc_pmidate
     INTO g_tc_pmi.tc_pmiconf,g_tc_pmi.tc_pmimodu,g_tc_pmi.tc_pmidate FROM tc_pmi_file
    WHERE tc_pmi01=g_tc_pmi.tc_pmi01
 
    DISPLAY BY NAME g_tc_pmi.tc_pmiconf,g_tc_pmi.tc_pmimodu,g_tc_pmi.tc_pmidate
    CALL i255_pic()      #FUN-920106
END FUNCTION
 
FUNCTION i255_pmh13(l_pmh13)  #幣別
    DEFINE l_azi02   LIKE azi_file.azi02             #No.FUN-550019
    DEFINE l_aziacti LIKE azi_file.aziacti           #No.FUN-550019
    DEFINE l_pmh13   LIKE pmh_file.pmh13
 
    LET g_errno = ' '
    SELECT azi02,aziacti INTO l_azi02,l_aziacti      #No.FUN-550019
      FROM azi_file
     WHERE azi01 = l_pmh13
 
    CASE WHEN STATUS=100          LET g_errno = 'mfg3008' #No.7926
         WHEN l_aziacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION i255_tc_pmj03(p_cmd)  #料件編號
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_imaacti  LIKE ima_file.imaacti,
           p_cmd      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
      FROM ima_file WHERE ima01=g_tc_pmj[l_ac].tc_pmj03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                   LET l_ima02 = NULL
                                   LET l_ima021= NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' OR g_tc_pmj[l_ac].tc_pmj03[1,4]='MISC' THEN #6808
       LET g_tc_pmj[l_ac].tc_pmj031= l_ima02
       LET g_tc_pmj[l_ac].tc_pmj032= l_ima021
       DISPLAY BY NAME g_tc_pmj[l_ac].tc_pmj031   #No.FUN-830114
       DISPLAY BY NAME g_tc_pmj[l_ac].tc_pmj032   #No.FUN-830114
    END IF
 
END FUNCTION
FUNCTION i255_tc_pmj03_1(p_cmd,l_m)  #料件編號
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_imaacti  LIKE ima_file.imaacti,
           p_cmd      LIKE type_file.chr1   
    DEFINE l_m        LIKE type_file.chr1000
    LET g_errno = ' '
    SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
      FROM ima_file WHERE ima01=l_m
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                   LET l_ima02 = NULL
                                   LET l_ima021= NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' OR g_tc_pmj[l_ac].tc_pmj03[1,4]='MISC' THEN #6808
       LET g_tc_pmj[l_ac].tc_pmj031= l_ima02
       LET g_tc_pmj[l_ac].tc_pmj032= l_ima021
       DISPLAY BY NAME g_tc_pmj[l_ac].tc_pmj031
       DISPLAY BY NAME g_tc_pmj[l_ac].tc_pmj032
    END IF
 
END FUNCTION
 
FUNCTION i255_tc_pmj05(p_cmd)  #幣別
    DEFINE p_cmd      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
    DEFINE l_azi02   LIKE azi_file.azi02             #No.FUN-550019
    DEFINE l_aziacti LIKE azi_file.aziacti           #No.FUN-550019
 
    LET g_errno = ' '
    SELECT azi02,azi03,aziacti INTO l_azi02,t_azi03,l_aziacti  #No.FUN-550019    #No.CHI-6A0004
        FROM azi_file
        WHERE azi01 = g_tc_pmj[l_ac].tc_pmj05
    CASE WHEN STATUS=100          LET g_errno = 'mfg3008' #No.7926
         WHEN l_aziacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION i255_1(p_pmr02,p_flag)
DEFINE
    p_pmr02         LIKE pmr_file.pmr02,           #項次
    p_flag          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    l_pmr           DYNAMIC ARRAY OF RECORD
                    pmr03     LIKE pmr_file.pmr03, #起始數量
                    pmr04     LIKE pmr_file.pmr04, #截止數量
                    pmr05     LIKE pmr_file.pmr05, #單價
                    pmr05t     LIKE pmr_file.pmr05t    #No.FUN-550019
                    END RECORD,
    l_tc_pmj03         LIKE tc_pmj_file.tc_pmj03,           #料件編號
    l_tc_pmj031        LIKE tc_pmj_file.tc_pmj031,          #品名
    l_tc_pmj032        LIKE tc_pmj_file.tc_pmj032,          #規格
    l_tc_pmj05         LIKE tc_pmj_file.tc_pmj05,           #幣別
    l_pmr_t         RECORD
                    pmr03     LIKE pmr_file.pmr03,
                    pmr04     LIKE pmr_file.pmr04,
                    pmr05     LIKE pmr_file.pmr05,
                    pmr05t     LIKE pmr_file.pmr05t    #No.FUN-550019
                    END RECORD,
    l_chr           LIKE type_file.num5,      #No.FUN-680136 SMALLINT
    l_acc,l_n       LIKE type_file.num5,      #No.FUN-680136 SMALLINT
    l_acc_t         LIKE type_file.num5,      #No.FUN-680136 SMALLINT   #未取消的ARRAY CNT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680136 SMALLINT
 
    IF cl_null(g_tc_pmi.tc_pmi01) THEN RETURN END IF
    IF g_tc_pmi.tc_pmi05 = 'N' THEN
       #分量計價='N'
       CALL cl_err('','apm-286',0)
       RETURN
    END IF
 
    OPEN WINDOW i255c WITH FORM "apm/42f/apmi255c"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmi255c")
 
    DISPLAY g_tc_pmi.tc_pmi01 TO pmr01
 
    IF p_flag ='Y' THEN
       INPUT p_pmr02 FROM pmr02
 
           AFTER FIELD pmr02
              IF NOT cl_null(p_pmr02) THEN
                 SELECT COUNT(*) INTO l_n FROM tc_pmj_file
                  WHERE tc_pmj01=g_tc_pmi.tc_pmi01
                    AND tc_pmj02=p_pmr02
                 IF l_n=0 THEN
                    #無此項次資料，請重新輸入！
                    CALL cl_err('','axm-141',0)
                    NEXT FIELD pmr02
                 END IF
              END IF
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       END INPUT
    END IF
 
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW i255c
       RETURN
    END IF
 
    SELECT tc_pmj03,tc_pmj031,tc_pmj032,tc_pmj05
      INTO l_tc_pmj03,l_tc_pmj031,l_tc_pmj032,l_tc_pmj05
      FROM tc_pmj_file
     WHERE tc_pmj01=g_tc_pmi.tc_pmi01
       AND tc_pmj02=p_pmr02
 
    IF cl_null(l_tc_pmj03)  THEN LET l_tc_pmj03 =g_tc_pmj[l_ac].tc_pmj03  END IF
    IF cl_null(l_tc_pmj031) THEN LET l_tc_pmj031=g_tc_pmj[l_ac].tc_pmj031 END IF
    IF cl_null(l_tc_pmj032) THEN LET l_tc_pmj032=g_tc_pmj[l_ac].tc_pmj032 END IF
    IF cl_null(l_tc_pmj05)  THEN LET l_tc_pmj05 =g_tc_pmj[l_ac].tc_pmj05  END IF
    DISPLAY p_pmr02     TO pmr02
    DISPLAY l_tc_pmj03     TO tc_pmj03
    DISPLAY l_tc_pmj031    TO tc_pmj031
    DISPLAY l_tc_pmj032    TO tc_pmj032
    DISPLAY l_tc_pmj05     TO tc_pmj05
    SELECT azi03 INTO t_azi03 FROM azi_file
      WHERE azi01 = l_tc_pmj05
 
    #顯示單身舊值
    LET g_sql = " SELECT pmr03,pmr04,pmr05,pmr05t",     #No.FUN-550019
                "   FROM pmr_file",
                "  WHERE pmr01 = ? ",
                "    AND pmr02 = ? ",
                " ORDER BY 1 "
    PREPARE i255c   FROM g_sql
    DECLARE pmr_curs CURSOR FOR i255c
    CALL l_pmr.clear()
    LET g_cnt = 1
    FOREACH pmr_curs USING g_tc_pmi.tc_pmi01,p_pmr02
       INTO l_pmr[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
            CALL cl_err('pmr_curs:',STATUS,1)
            EXIT FOREACH
        END IF
        IF cl_null(l_pmr[g_cnt].pmr03) THEN
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL l_pmr.deleteElement(g_cnt)
    LET g_rec_bc = g_cnt - 1
 
    IF g_tc_pmi.tc_pmiconf='Y' THEN
       DISPLAY ARRAY l_pmr TO s_pmr.* ATTRIBUTE(COUNT=g_rec_bc,UNBUFFERED)
       #已確認, 不可更改或取消 !
       CLOSE WINDOW i255c
       RETURN
    END IF
 
    LET g_forupd_sql = "SELECT pmr03,pmr04,pmr05,pmr05t FROM pmr_file",  #No.FUN-550019
                       "  WHERE pmr01 = ? AND pmr02 = ? AND pmr03 = ?",
                       "   AND pmr04 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i255c_bc CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET l_acc = 1
    INPUT ARRAY l_pmr WITHOUT DEFAULTS FROM s_pmr.*
          ATTRIBUTE(COUNT=g_rec_bc,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_bc != 0 THEN
                CALL fgl_set_arr_curr(l_acc)
            END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_acc = ARR_CURR()
           LET l_lock_sw = 'N'                   #DEFAULT
           BEGIN WORK
           LET g_success = 'Y'
           OPEN i255_cl USING g_tc_pmi.tc_pmi01
           IF STATUS THEN
              CALL cl_err("OPEN i255_cl:", STATUS, 1)
              CLOSE i255_cl
              LET g_success = 'N'
              RETURN
           END IF
           FETCH i255_cl INTO g_tc_pmi.*  # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_tc_pmi.tc_pmi01,SQLCA.sqlcode,0)     # 資料被他人LOCK
              CLOSE i255_cl
              LET g_success = 'N'
              RETURN
           END IF
           IF g_rec_bc >= l_acc THEN
              LET p_cmd='u'
              LET l_pmr_t.* = l_pmr[l_acc].*  #BACKUP
              OPEN i255c_bc USING g_tc_pmi.tc_pmi01,p_pmr02,l_pmr_t.pmr03,l_pmr_t.pmr04
              IF STATUS THEN
                  CALL cl_err("OPEN i255c_bc:", STATUS, 1)
                  LET l_lock_sw = "Y"
              ELSE
                  FETCH i255c_bc INTO l_pmr[l_acc].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock pmr',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
              END IF
           END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE l_pmr[l_acc].* TO NULL      #900423
          LET l_pmr_t.* = l_pmr[l_acc].*         #新輸入資料
          NEXT FIELD pmr03
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          IF cl_null(g_tc_pmj[l_ac].tc_pmj10) THEN
             LET g_tc_pmj[l_ac].tc_pmj10 = " "
          END IF
          INSERT INTO pmr_file(pmr01,pmr02,pmr03,pmr04,pmr05,pmr05t,pmrplant,pmrlegal) #FUN-980006 add pmrplant,pmrlegal
          VALUES(g_tc_pmi.tc_pmi01,p_pmr02,l_pmr[l_acc].pmr03,l_pmr[l_acc].pmr04,
                 l_pmr[l_acc].pmr05,l_pmr[l_acc].pmr05t,g_plant,g_legal) #FUN-980006 add g_plant,g_legal
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","pmr_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_bc=g_rec_bc+1
          END IF
 
       BEFORE FIELD pmr03               #default 起始數量
          IF cl_null(l_pmr[l_acc].pmr03) THEN
             SELECT MAX(pmr04)+1 INTO l_pmr[l_acc].pmr03
               FROM pmr_file
              WHERE pmr01 = g_tc_pmi.tc_pmi01 #核價單號
                AND pmr02 = p_pmr02     #項次
             IF cl_null(l_pmr[l_acc].pmr03) THEN
                LET l_pmr[l_acc].pmr03 = 1
             END IF
          END IF
          CALL i255c_set_entry_b(p_cmd)       #No.FUN-550019
 
       AFTER FIELD pmr03
          IF p_cmd='a' OR (p_cmd='u' AND l_pmr_t.pmr03 !=l_pmr[l_acc].pmr03) THEN
             SELECT COUNT(*) INTO g_i
               FROM pmr_file
              WHERE pmr01 = g_tc_pmi.tc_pmi01 #核價單號
                AND pmr02 = p_pmr02     #項次
                AND l_pmr[l_acc].pmr03 BETWEEN pmr03 AND pmr04
             IF g_i >=1 THEN
                #起始數量重疊到已輸入的起迄數量
                CALL cl_err('','axm-362',0)
                LET l_pmr[l_acc].pmr03 = l_pmr_t.pmr03
                NEXT FIELD pmr03
             END IF
          END IF
          CALL i255c_set_no_entry_b(p_cmd)       #No.FUN-550019
 
       AFTER FIELD pmr04 #截止數量
          IF NOT cl_null(l_pmr[l_acc].pmr03) AND NOT cl_null(l_pmr[l_acc].pmr04) THEN
             IF p_cmd='a' OR (p_cmd='u' AND (l_pmr_t.pmr03 !=l_pmr[l_acc].pmr03 OR
                l_pmr_t.pmr04 !=l_pmr[l_acc].pmr04)) THEN
                SELECT COUNT(*) INTO l_n
                  FROM pmr_file
                 WHERE pmr01=g_tc_pmi.tc_pmi01
                   AND pmr02=p_pmr02
                   AND pmr03=l_pmr[l_acc].pmr03
                   AND pmr04=l_pmr[l_acc].pmr04
                IF l_n > 0  THEN
                   #資料重覆，請重新輸入!
                   CALL cl_err('sel-pmr','axm-298',0)
                   NEXT FIELD pmr04
                END IF
             END IF
          END IF
 
       AFTER FIELD pmr05
          IF NOT cl_null(l_pmr[l_ac].pmr05) THEN
             LET l_pmr[l_ac].pmr05 = cl_digcut(l_pmr[l_ac].pmr05,t_azi03)   #No.CHI-6A0004
          END IF
 
       AFTER FIELD pmr05t
          IF NOT cl_null(l_pmr[l_ac].pmr05t) THEN
             LET l_pmr[l_ac].pmr05t = cl_digcut(l_pmr[l_ac].pmr05t,t_azi03)  #No.CHI-6A0004
             LET l_pmr[l_ac].pmr05 = l_pmr[l_ac].pmr05t / (1 + g_tc_pmi.tc_pmi081/100)
             LET l_pmr[l_ac].pmr05 = cl_digcut(l_pmr[l_ac].pmr05,t_azi03)    #No.CHI-6A0004
          END IF
 
        BEFORE DELETE                            #是否取消單身
           IF l_pmr_t.pmr03 > 0 AND l_pmr_t.pmr04 > 0 THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
 
 
              DELETE FROM pmr_file
               WHERE pmr01 = g_tc_pmi.tc_pmi01
                 AND pmr02 = p_pmr02
                 AND pmr03 = l_pmr_t.pmr03
                 AND pmr04 = l_pmr_t.pmr04
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","pmr_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_success = 'N'
                 CANCEL DELETE
              ELSE
                 LET g_rec_bc=g_rec_bc-1
              END IF
           END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET l_pmr[l_acc].* = l_pmr_t.*
             CLOSE i255c_bc
             LET g_success = 'N'
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(l_pmr[l_acc].pmr03,-263,1)
             LET l_pmr[l_acc].* = l_pmr_t.*
          ELSE
             UPDATE pmr_file SET pmr01=g_tc_pmi.tc_pmi01,
                                 pmr02=p_pmr02,
                                 pmr03=l_pmr[l_acc].pmr03,
                                 pmr04=l_pmr[l_acc].pmr04,
                                 pmr05=l_pmr[l_acc].pmr05,
                                 pmr05t=l_pmr[l_acc].pmr05t    #No.FUN-550019
              WHERE pmr01=g_tc_pmi.tc_pmi01
                AND pmr02=p_pmr02
                AND pmr03=l_pmr_t.pmr03
                AND pmr04=l_pmr_t.pmr04
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","pmr_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                LET l_pmr[l_acc].* = l_pmr_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_acc = ARR_CURR()
          LET l_acc_t = l_acc
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                 LET l_pmr[l_acc].* = l_pmr_t.*
             END IF
             CLOSE i255c_bc
             ROLLBACK WORK
             LET g_success = 'N'
             EXIT INPUT
          END IF
          CLOSE i255c_bc
          COMMIT WORK
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    CLOSE i255c_bc
    CLOSE WINDOW i255c
 
END FUNCTION
 
FUNCTION i255_b_g()
  DEFINE  l_pmx           RECORD LIKE pmx_file.*, #詢價單單身
          l_tc_pmj           RECORD LIKE tc_pmj_file.*, #核價單單身
          l_ima44         LIKE ima_file.ima44,    #採購單位
          l_pmx09_fac     LIKE ima_file.ima31_fac,  #No.FUN-680136 dec(16,8)   #詢價單位/庫存單位轉換率
          l_pmw04         LIKE pmw_file.pmw04,
          l_pmw01         LIKE pmw_file.pmw01,
          l_sql           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000)
          l_tc_pmj01         LIKE tc_pmj_file.tc_pmj01,
          l_lineno        LIKE type_file.num5     #No.FUN-680136 SMALLINT      #項次
  DEFINE  l_pmhacti       LIKE pmh_file.pmhacti   #MOD-930327
 
    SELECT COUNT(*) INTO g_cnt
      FROM tc_pmj_file
     WHERE tc_pmj01 = g_tc_pmi.tc_pmi01
    IF g_cnt > 0 THEN RETURN END IF
 
    #單身輸入方式:(1)直接輸入 (2)詢價單轉入
    #CALL cl_conf2(0,0,'apm-287','12') RETURNING g_i  #mark by guanyao160525
    CALL cl_conf2(0,0,'cpm-015','123') RETURNING g_i  #add by guanyao160524
    IF g_i = 1 THEN RETURN END IF
    #str----add by guanyao160525
    IF g_i = 3 THEN 
       CALL i255_pl('a')
    ELSE 
    #end----add by guanyao160525
    OPEN WINDOW i255b_w WITH FORM "apm/42f/apmi255b"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("tc_pmi255b")
 
    CONSTRUCT BY NAME tm.wc ON pmw01,pmw06
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ## No.TQC-640068 原順序顛倒,調整回來即可
       ON ACTION controlp
          CASE
             WHEN INFIELD(pmw01)    #詢價單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pmw02"                 #MOD-640441
                  LET g_qryparam.default1 = l_pmw01,'',''
                  LET g_qryparam.arg1 = g_tc_pmi.tc_pmi03              #MOD-640441 add
                  LET g_qryparam.arg2 = g_tc_pmi.tc_pmi08              #MOD-640441 add
                  LET g_qryparam.arg3 = g_tc_pmj12     #No.FUN-670099 
                  CALL cl_create_qry() RETURNING l_pmw01
                  DISPLAY l_pmw01 TO pmw01
             OTHERWISE EXIT CASE
          END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
       
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
       
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
       
       ON ACTION qbe_select
          CALL cl_qbe_select()
       
       ON ACTION qbe_save
          CALL cl_qbe_save()
 
    END CONSTRUCT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW i255b_w
       RETURN
    END IF
    CLOSE WINDOW i255b_w
    LET l_sql = "SELECT pmx_file.*,pmw04 ",
                "  FROM pmw_file,pmx_file",
                " WHERE ",tm.wc CLIPPED,
                "   AND pmw01 = pmx01 ",
                "   AND pmx12 = '",g_tc_pmi.tc_pmi03,"'", #廠商編號     #FUN-650191 pmw03->pmx12
                "   AND pmw05 = '",g_tc_pmi.tc_pmi08,"'", #稅別    No.FUN-550019
                "   AND pmx11 = '",g_tc_pmj12,"'", #No.FUN-740041
                 "   AND pmwacti = 'Y' ", #MOD-530570
                " ORDER BY pmx01,pmx02 "
 
    PREPARE i255b_pre FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('i255b_pre:',SQLCA.sqlcode,1)
       RETURN
    END IF
 
    DECLARE i255b_curs CURSOR FOR i255b_pre
 
    BEGIN WORK
    LET l_lineno = 0
    INITIALIZE l_pmx.* TO NULL
    INITIALIZE l_tc_pmj.* TO NULL
    LET l_pmw04 = NULL
    LET g_success = 'Y'
 
    FOREACH i255b_curs INTO l_pmx.*,l_pmw04
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT ima44 INTO l_ima44
         FROM ima_file
        WHERE ima01 = l_pmx.pmx08
       IF l_pmx.pmx09 <> l_ima44 THEN #詢價單位<>採購單位
          #檢查該詢價單位與採購單位是否可以轉換
          CALL s_umfchk(l_pmx.pmx08,l_pmx.pmx09,l_ima44)
               RETURNING g_i,l_pmx09_fac
          IF g_i = 1 THEN
             #單位無法與料件主檔之採購單位轉換,請重新輸入
             CALL cl_err('','apm-288',1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
       ELSE
          LET l_pmx09_fac = 1
       END IF
 
      #LET l_lineno= l_lineno + 1     #MOD-C30260 mark
       LET l_tc_pmj.tc_pmj01  = g_tc_pmi.tc_pmi01
      #MOD-C30260 -- add -- begin
       SELECT MAX(tc_pmj02)+1 INTO l_lineno FROM tc_pmj_file 
        WHERE tc_pmj01 = g_tc_pmi.tc_pmi01
       IF cl_null(l_lineno) THEN
          LET l_lineno = 1
       END IF
      #MOD-C30260 -- add -- end
       LET l_tc_pmj.tc_pmj02  = l_lineno         #項次
       LET l_tc_pmj.tc_pmj03  = l_pmx.pmx08
       LET l_tc_pmj.tc_pmj031 = l_pmx.pmx081
       LET l_tc_pmj.tc_pmj032 = l_pmx.pmx082
       LET l_tc_pmj.tc_pmj11 =  l_pmx.pmx11
       LET l_tc_pmj.tc_pmj04  = ''
       LET l_tc_pmj.tc_pmj05  = l_pmw04
       LET l_tc_pmj.tc_pmj07  = l_pmx.pmx06/l_pmx09_fac
       LET l_tc_pmj.tc_pmj07t = l_pmx.pmx06t/l_pmx09_fac     #No.FUN-550019
       LET l_tc_pmj.tc_pmj09  = l_pmx.pmx04
       LET l_tc_pmj.tc_pmj10  = l_pmx.pmx10  #No.FUN-670099
       LET l_tc_pmj.tc_pmj12  = l_pmx.pmx11  #No.FUN-670099
       LET l_tc_pmj.tc_pmj13  = l_pmx.pmx13  #No.FUN-810017
       LET l_tc_pmj.tc_pmjplant  = g_plant  #FUN-980006 add
       LET l_tc_pmj.tc_pmjlegal  = g_legal  #FUN-980006 add
       SELECT pmh06,pmh12,pmh19,pmhacti  #No.FUN-610018   #MOD-930327 add pmhacti
         INTO l_tc_pmj.tc_pmj08,l_tc_pmj.tc_pmj06,l_tc_pmj.tc_pmj06t,l_pmhacti    #No.FUN-610018   #MOD-930327 add pmhacti
         FROM pmh_file
        WHERE pmh01 = l_tc_pmj.tc_pmj03
          AND pmh02 = g_tc_pmi.tc_pmi03
          AND pmh13 = l_tc_pmj.tc_pmj05
          AND pmh21 = l_tc_pmj.tc_pmj10  #No.FUN-670099
          AND pmh22 = l_tc_pmj.tc_pmj12  #No.FUN-670099
          AND pmh23 = l_tc_pmj.tc_pmj13  #No.FUN-870124
       IF l_pmhacti = 'N' THEN 
          CONTINUE FOREACH
       END IF 
       IF cl_null(l_tc_pmj.tc_pmj06) THEN LET l_tc_pmj.tc_pmj06=0 END IF
       IF cl_null(l_tc_pmj.tc_pmj08) THEN LET l_tc_pmj.tc_pmj08=' ' END IF
       IF cl_null(l_tc_pmj.tc_pmj06t) THEN
          LET l_tc_pmj.tc_pmj06t = l_tc_pmj.tc_pmj06 * (1 + g_tc_pmi.tc_pmi081/100)
       END IF
       IF cl_null(l_tc_pmj.tc_pmj06t) THEN LET l_tc_pmj.tc_pmj06t=0 END IF
       SELECT COUNT(*) INTO g_cnt FROM tc_pmj_file
        WHERE tc_pmj01 = l_tc_pmj.tc_pmj01
          AND tc_pmj03 = l_tc_pmj.tc_pmj03
          AND tc_pmj05 = l_tc_pmj.tc_pmj05
          AND tc_pmj10 = l_tc_pmj.tc_pmj10
          AND tc_pmj12 = l_tc_pmj.tc_pmj12  #No.FUN-670099
       IF g_cnt >= 1 THEN
          #不可同時存在相同的"料件編號"+"幣別"+"作業編號"
          #所以當詢價單是分量計價的資料時,只抓到第一筆
          INITIALIZE l_pmx.* TO NULL
          INITIALIZE l_tc_pmj.* TO NULL
          LET l_pmw04 = NULL
          CONTINUE FOREACH
       END IF
 
       LET l_tc_pmj01 = NULL
       SELECT tc_pmj01 INTO l_tc_pmj01 FROM tc_pmi_file,tc_pmj_file
        WHERE tc_pmi03=g_tc_pmi.tc_pmi03
          AND tc_pmi08=g_tc_pmi.tc_pmi08        #No.FUN-550019
          AND tc_pmiconf='N'
          AND tc_pmi01!=g_tc_pmi.tc_pmi01
          AND tc_pmj01=tc_pmi01
          AND tc_pmj03=l_tc_pmj.tc_pmj03
          AND tc_pmj03[1,4] != 'MISC'
          AND tc_pmj05=l_tc_pmj.tc_pmj05
          AND tc_pmj10=l_tc_pmj.tc_pmj10
          AND tc_pmj12=l_tc_pmj.tc_pmj12  #No.FUN-670099
       IF NOT cl_null(l_tc_pmj01) THEN
          LET g_message = NULL
          LET g_message = 'NO:',l_tc_pmj01,'==>',l_tc_pmj.tc_pmj03 CLIPPED
          LET g_message = g_message CLIPPED
          #(廠商+料號+幣別+作業編號)尚有未確認之核價單
          CALL cl_err(g_message,'apm-262',1)
          #詢價單轉入未成功!
          CALL cl_err('','apm-128',1)
 
          LET g_success = 'N'
          EXIT FOREACH
       END IF
 
       INSERT INTO tc_pmj_file VALUES (l_tc_pmj.*)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
          CALL cl_err3("ins","tc_pmj_file",l_tc_pmj.tc_pmj01,l_tc_pmj.tc_pmj02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       INITIALIZE l_pmx.* TO NULL
       INITIALIZE l_tc_pmj.* TO NULL
       LET l_pmw04 = NULL
    END FOREACH
 
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
    CALL i255_show()
    END IF 
 
END FUNCTION
 
FUNCTION i255_ef()
 
  CALL i255sub_y_chk(g_tc_pmi.tc_pmi01)
  IF g_success = "N" THEN
     RETURN
  END IF
 
   CALL aws_condition()                            #判斷送簽資料
   IF g_success = 'N' THEN
         RETURN
   END IF
 
##########
# CALL aws_efcli()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
   IF aws_efcli2(base.TypeInfo.create(g_tc_pmi),base.TypeInfo.create(g_tc_pmj),'','','','')
   THEN
      LET g_success = 'Y'
      LET g_tc_pmi.tc_pmi06 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
      DISPLAY BY NAME g_tc_pmi.tc_pmi06
   ELSE
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
FUNCTION i255_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tc_pmi01",TRUE)
    END IF
    CALL cl_set_comp_entry("tc_pmi05",TRUE) #MOD-530602 add tc_pmi05
 
END FUNCTION
 
FUNCTION i255_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   #No.FUN-680136 VARCHAR(1)
  DEFINE l_n     LIKE type_file.num5   #MOD-530602  #No.FUN-680136 SMALLINT
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tc_pmi01",FALSE)
    END IF
 
    IF p_cmd = 'u' THEN
       SELECT COUNT(*) INTO l_n
         FROM tc_pmj_file
        WHERE tc_pmj01 = g_tc_pmi.tc_pmi01
       IF l_n >=1 THEN
          CALL cl_set_comp_entry("tc_pmi05",FALSE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i255_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF INFIELD(tc_pmj03) THEN
       CALL cl_set_comp_entry("tc_pmj031,tc_pmj032",TRUE)
    END IF
 
    IF INFIELD(tc_pmj05) THEN
       CALL cl_set_comp_entry("tc_pmj07,tc_pmj07t",TRUE)   #No.FUN-550019  #FUN-560204 拿掉tc_pmj08
    END IF
 
    CALL cl_set_comp_entry("tc_pmj07,tc_pmj07t",TRUE)     #No.FUN-610018
 
END FUNCTION
 
FUNCTION i255_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF INFIELD(tc_pmj03) THEN
       IF g_tc_pmj[l_ac].tc_pmj03[1,4] <> 'MISC' THEN
          CALL cl_set_comp_entry("tc_pmj031,tc_pmj032",FALSE)
       END IF
    END IF
 
    IF INFIELD(tc_pmj05) THEN
       IF g_tc_pmi.tc_pmi05 = 'Y' THEN
          CALL cl_set_comp_entry("tc_pmj07,tc_pmj07t",FALSE)  #No.FUN-550019 #FUN-560204 拿掉tc_pmj08
       END IF
    END IF
 
    IF g_tc_pmi.tc_pmi05 = 'Y' THEN
       CALL cl_set_comp_entry("tc_pmj07,tc_pmj07t",FALSE)  #No.FUN-550019 #FUN-560204 拿掉tc_pmj08
    ELSE
       IF g_gec07 = 'N' THEN           #No.FUN-560102
          CALL cl_set_comp_entry("tc_pmj07t",FALSE)
       ELSE
          CALL cl_set_comp_entry("tc_pmj07",FALSE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i255c_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF INFIELD(pmr03) THEN
       CALL cl_set_comp_entry("pmr05,pmr05t",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i255c_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF g_gec07 = 'Y' THEN             #No.FUN-560102
       CALL cl_set_comp_entry("pmr05",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i255_tc_pmi09(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,             #No:7381
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti    #No:7381
      FROM gen_file
     WHERE gen01 = g_tc_pmi.tc_pmi09
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                LET l_gen02 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION
FUNCTION i255_tc_pmj06_def()  #帶出料件廠商之資料
 DEFINE l_cnt      LIKE type_file.num5
 
    IF cl_null(g_tc_pmj[l_ac].tc_pmj10) THEN
       LET g_tc_pmj[l_ac].tc_pmj10 = ' '
       LET g_tc_pmj[l_ac].ecd02 = ' '     #No.FUN-930061
    END IF
 
    #先找看有沒有以確認的估價檔，若沒有則default pmh_file
    SELECT COUNT(*) INTO l_cnt FROM tc_pmi_file,tc_pmj_file
       WHERE tc_pmj01=tc_pmi01 AND tc_pmiconf = 'Y'
          AND tc_pmi03 = g_tc_pmi.tc_pmi03 AND tc_pmj05 = g_tc_pmj[l_ac].tc_pmj05
          AND tc_pmj03 = g_tc_pmj[l_ac].tc_pmj03
          AND tc_pmj10 = g_tc_pmj[l_ac].tc_pmj10  #MOD-960182
          AND tc_pmj12 = g_tc_pmj12            #MOD-960182
          AND tc_pmj13 = g_tc_pmj[l_ac].tc_pmj13  #MOD-960182
 
    IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
    IF l_cnt <= 0 THEN
       IF cl_null(g_tc_pmj[l_ac].tc_pmj10) THEN
          LET g_tc_pmj[l_ac].tc_pmj10 = ' '
          LET g_tc_pmj[l_ac].ecd02 = ' '     #No.FUN-930061
       END IF
       DECLARE tc_pmj06_cur1 CURSOR FOR
          SELECT pmh04,pmh06,pmh12,pmh19,pmh13       
             FROM pmh_file
             WHERE pmh01 = g_tc_pmj[l_ac].tc_pmj03
               AND pmh02=g_tc_pmi.tc_pmi03
               AND pmh13 = g_tc_pmj[l_ac].tc_pmj05
               AND pmh21 = g_tc_pmj[l_ac].tc_pmj10  #No.MOD-840074
               AND pmh22 = g_tc_pmj12            #No.MOD-840074
               AND pmh23 = g_tc_pmj[l_ac].tc_pmj13  #No.FUN-870124
               AND pmhacti = 'Y'                                           #CHI-910021
       OPEN tc_pmj06_cur1
       FETCH tc_pmj06_cur1 INTO g_tc_pmj[l_ac].tc_pmj04,g_tc_pmj[l_ac].tc_pmj08,
                             g_tc_pmj[l_ac].tc_pmj06,
                             g_tc_pmj[l_ac].tc_pmj06t,g_tc_pmj[l_ac].tc_pmj05
       CLOSE tc_pmj06_cur1
    ELSE 
       DECLARE tc_pmj06_cur2 CURSOR FOR
          SELECT tc_pmj04,tc_pmj09,tc_pmj07,tc_pmj07t,tc_pmj05
             FROM tc_pmj_file,tc_pmi_file
             WHERE tc_pmj01=tc_pmi01 AND tc_pmiconf = 'Y'
                AND tc_pmi03 = g_tc_pmi.tc_pmi03 AND tc_pmj05 = g_tc_pmj[l_ac].tc_pmj05
                AND tc_pmj03 = g_tc_pmj[l_ac].tc_pmj03
                AND tc_pmj10 = g_tc_pmj[l_ac].tc_pmj10  #MOD-960182
                AND tc_pmj12 = g_tc_pmj12            #MOD-960182
                AND tc_pmj13 = g_tc_pmj[l_ac].tc_pmj13  #MOD-960182
                AND tc_pmj09 = (SELECT MAX(tc_pmj09) FROM tc_pmi_file,tc_pmj_file
                WHERE tc_pmj01=tc_pmi01 AND tc_pmiconf = 'Y'
                AND tc_pmi03 = g_tc_pmi.tc_pmi03 AND tc_pmj05 = g_tc_pmj[l_ac].tc_pmj05
                AND tc_pmj03 = g_tc_pmj[l_ac].tc_pmj03
                AND tc_pmj10 = g_tc_pmj[l_ac].tc_pmj10  #MOD-960182
                AND tc_pmj12 = g_tc_pmj12            #MOD-960182
                AND tc_pmj13 = g_tc_pmj[l_ac].tc_pmj13) #MOD-960182
                ORDER BY tc_pmi01 desc
       OPEN tc_pmj06_cur2
       FETCH tc_pmj06_cur2 INTO g_tc_pmj[l_ac].tc_pmj04,g_tc_pmj[l_ac].tc_pmj08,
                             g_tc_pmj[l_ac].tc_pmj06,
                             g_tc_pmj[l_ac].tc_pmj06t,g_tc_pmj[l_ac].tc_pmj05
       CLOSE tc_pmj06_cur2
    END IF
 
   
     IF cl_null(g_tc_pmj[l_ac].tc_pmj06) THEN
        LET g_tc_pmj[l_ac].tc_pmj06 = 0
     END IF
   
     IF cl_null(g_tc_pmj[l_ac].tc_pmj08) THEN
        LET g_tc_pmj[l_ac].tc_pmj08 = ' '
     END IF
     #要重show,不然會影響ON ROW CHANGE
     DISPLAY g_tc_pmj[l_ac].tc_pmj04,g_tc_pmj[l_ac].tc_pmj08,g_tc_pmj[l_ac].tc_pmj06,
             g_tc_pmj[l_ac].tc_pmj06t,g_tc_pmj[l_ac].tc_pmj05
          TO tc_pmj04,tc_pmj08,tc_pmj06,tc_pmj06t,tc_pmj05
   
     IF cl_null(g_tc_pmj[l_ac].tc_pmj06t) THEN
        LET g_tc_pmj[l_ac].tc_pmj06t = g_tc_pmj[l_ac].tc_pmj06 * ( 1 + g_tc_pmi.tc_pmi081/100)
     END IF
END FUNCTION
 
FUNCTION i255_pic()
 
 IF g_tc_pmi.tc_pmiconf='X' THEN
    LET g_chr='Y'
 ELSE
    LET g_chr='N'
 END IF
 
 IF g_tc_pmi.tc_pmi06='1' THEN
    LET g_chr2='Y'
 ELSE
    LET g_chr2='N'
 END IF
 
 CALL cl_set_field_pic(g_tc_pmi.tc_pmiconf,g_chr2,"",g_chr3,g_chr,g_tc_pmi.tc_pmiacti)
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

#str----add by guanyao160525
FUNCTION i255_pl(p_cmd)
DEFINE l_price     LIKE type_file.num15_3
DEFINE l_sql       STRING 
DEFINE l_tc_pmj       RECORD LIKE tc_pmj_file.*
DEFINE l_c,l_b     LIKE type_file.num5
DEFINE l_tc_pmj01     LIKE tc_pmj_file.tc_pmj01
DEFINE p_cmd       LIKE type_file.chr1
    IF cl_null(g_tc_pmi.tc_pmi01) THEN 
       RETURN 
    END IF 

    LET l_c = 0
    SELECT COUNT(*) INTO l_c
      FROM tc_pmj_file
     WHERE tc_pmj01 = g_tc_pmi.tc_pmi01
    IF l_c > 0 THEN RETURN END IF
    LET l_c = 0
    SELECT COUNT(*) INTO l_c FROM pmh_file 
     WHERE pmh02 = g_tc_pmi.tc_pmi03
       AND pmhacti = 'Y'
       AND pmh22 = g_argv3
    IF cl_null(l_c) OR l_c = 0 THEN 
       CALL cl_err('','cpm-014',0)
       RETURN 
    END IF 
    OPEN WINDOW i255_w_2 WITH FORM "cpm/42f/cpmi255_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("cpmi255_1")
 
    DISPLAY 0 TO price
 
    INPUT l_price FROM price 
 
       AFTER FIELD price
          IF NOT cl_null(l_price) THEN
             IF l_price <-100 THEN
                CALL cl_err('','cpm-013',0)
                NEXT FIELD price
             END IF    
          END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW i255_w_2
       RETURN
    END IF
    CLOSE WINDOW i255_w_2

    IF cl_null(l_price) THEN
       LET l_price = 0
    END IF  
    LET g_success = 'Y'
    BEGIN WORK 

    LET l_sql = " SELECT pmh01,ima02,ima021,pmh04,pmh13,pmh12,pmh19,pmh06",
                "   FROM pmh_file LEFT JOIN ima_file ON ima01 = pmh01",
                "  WHERE pmh02 = '",g_tc_pmi.tc_pmi03,"'",
                "    AND pmhacti = 'Y'",
                "    AND pmh22 = '",g_argv3,"'"
    PREPARE i255_pmh FROM l_sql
 
    DECLARE pmh_cs CURSOR WITH HOLD FOR i255_pmh
 
    LET l_b = 1
    FOREACH pmh_cs INTO l_tc_pmj.tc_pmj03,l_tc_pmj.tc_pmj031,l_tc_pmj.tc_pmj032,l_tc_pmj.tc_pmj04,
                        l_tc_pmj.tc_pmj05,l_tc_pmj.tc_pmj06,l_tc_pmj.tc_pmj06t,l_tc_pmj.tc_pmj08
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       EXIT FOREACH
    END IF

    LET l_tc_pmj.tc_pmj01 = g_tc_pmi.tc_pmi01
    LET l_tc_pmj.tc_pmj02 =l_b
    LET l_tc_pmj.tc_pmj10=' '
    IF g_argv3 = "1" THEN
       LET l_tc_pmj.tc_pmj12 ='1'
    ELSE
       LET l_tc_pmj.tc_pmj12 ='2' 
    END IF 
    LET l_tc_pmj.tc_pmj13 = " "
    IF l_tc_pmj.tc_pmj12 = '2' AND s_industry('icd') THEN
       LET l_tc_pmj.tc_pmjicd14 = '0'
    END IF 
    LET l_tc_pmj.tc_pmj06 = (1+l_price/100)*l_tc_pmj.tc_pmj06
    LET l_tc_pmj.tc_pmj06t = (1+l_price/100)*l_tc_pmj.tc_pmj06t
    LET l_tc_pmj.tc_pmj09 = ' '
    
    LET l_tc_pmj01 = NULL
    SELECT tc_pmj01 INTO l_tc_pmj01 FROM tc_pmi_file,tc_pmj_file
     WHERE tc_pmi03=g_tc_pmi.tc_pmi03
       AND tc_pmi08=g_tc_pmi.tc_pmi08        #No.FUN-550019
       AND tc_pmiconf='N'
       AND tc_pmi01!=g_tc_pmi.tc_pmi01
       AND tc_pmj01=tc_pmi01
       AND tc_pmj03=l_tc_pmj.tc_pmj03
       AND tc_pmj03[1,4] != 'MISC'
       AND tc_pmj05=l_tc_pmj.tc_pmj05
       AND tc_pmj10=l_tc_pmj.tc_pmj10
       AND tc_pmj12=l_tc_pmj.tc_pmj12  #No.FUN-670099
    IF NOT cl_null(l_tc_pmj01) THEN
       LET g_message = NULL
       LET g_message = 'NO:',l_tc_pmj01,'==>',l_tc_pmj.tc_pmj03 CLIPPED
       LET g_message = g_message CLIPPED
       #(廠商+料號+幣別+作業編號)尚有未確認之核價單
       CALL cl_err(g_message,'apm-262',1)
       #詢價單轉入未成功!
       CALL cl_err('','apm-128',1)
       LET g_success = 'N'
       EXIT FOREACH
    END IF
    INSERT INTO tc_pmj_file(tc_pmj01,tc_pmj02,tc_pmj03,tc_pmj031,tc_pmj032,tc_pmj11,tc_pmj04,tc_pmj05,
                         tc_pmj06,tc_pmj06t,tc_pmj07,tc_pmj07t,tc_pmj09,tc_pmj10,tc_pmj08,      
                         tc_pmj12,tc_pmj13,tc_pmjicd14,tc_pmjplant,tc_pmjlegal,tc_pmj15,tc_pmj16,
                         tc_pmj17,tc_pmj18,tc_pmj19,tc_pmj20,tc_pmj21)#add by huanglf161031#add by huanglf161025
    VALUES(g_tc_pmi.tc_pmi01,l_tc_pmj.tc_pmj02,
           l_tc_pmj.tc_pmj03,l_tc_pmj.tc_pmj031,
           l_tc_pmj.tc_pmj032,l_tc_pmj.tc_pmj11,l_tc_pmj.tc_pmj04,
           l_tc_pmj.tc_pmj05,l_tc_pmj.tc_pmj06,
           l_tc_pmj.tc_pmj06t,'0',   
           '0',l_tc_pmj.tc_pmj09,    
           l_tc_pmj.tc_pmj10,l_tc_pmj.tc_pmj08,
           l_tc_pmj.tc_pmj12,l_tc_pmj.tc_pmj13,l_tc_pmj.tc_pmjicd14,g_plant,g_legal,
           l_tc_pmj.tc_pmj15,l_tc_pmj.tc_pmj16,
           l_tc_pmj.tc_pmj17,l_tc_pmj.tc_pmj18,
           l_tc_pmj.tc_pmj19,l_tc_pmj.tc_pmj20,l_tc_pmj.tc_pmj21)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
       CALL s_errmsg("ins tc_pmj_file",g_tc_pmi.tc_pmi01||';'||l_tc_pmj.tc_pmj02,'',SQLCA.sqlcode,1)
       LET g_success = 'N' 
    END IF    
    LET l_b = l_b+1
    INITIALIZE l_tc_pmj.* TO NULL
    END FOREACH 

    IF g_success = 'Y' THEN
       COMMIT WORK 
    ELSE 
       ROLLBACK WORK 
       CALL s_showmsg()
    END IF 
    CALL i255_show()
    CALL i255_b('i')
   
END FUNCTION 
#end----add by guanyao160525
