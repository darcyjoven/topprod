# Prog. Version..: '5.30.06-13.03.12(00004)'     #
# Pattern name...: apst821.4gl
# Descriptions...: APS工單建議調整維護作業
# Date & Author..: #FUN-9C0081 09/12/16 By Mandy
# Modify.........: No:FUN-A10134 10/01/27 By Mandy 增加 預計開工時間和預計完工時間
# Modify.........: No:FUN-A30101 10/03/26 By Lilan BEGIN WORK --- COMMIT WORK 內去執行asfp301導致程式HOLD住
# Modify.........: No:FUN-B50020 11/05/09 By Lilan APS GP5.1追版至GP5.25
# Modify.........: No:FUN-B80122 11/11/03 By Abby 工單單身要如apst811可以做挑選,有選的才做異動
# Modify.........: No.FUN-BC0008 11/12/02 By zhangll s_cralc4整合成s_cralc,s_cralc增加傳參
# Modify.........: No.FUN-910088 12/01/16 By chenjing 增加數量欄位小數取位

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_vod01         LIKE vod_file.vod01, #FUN-9C0081
    g_vod02         LIKE vod_file.vod01,
    g_vod37         LIKE vod_file.vod37,
    g_vod05         LIKE vod_file.vod05,
    g_vod09         LIKE vod_file.vod09,
    g_vod37_t       LIKE vod_file.vod37,
    g_vod05_t       LIKE vod_file.vod05,
    g_vod09_t       LIKE vod_file.vod09,
    g_vod01_t       LIKE vod_file.vod01,
    g_vod02_t       LIKE vod_file.vod02,
    g_vod           DYNAMIC ARRAY OF RECORD
        vod37_1          LIKE vod_file.vod37,     #變更否
        status           LIKE type_file.chr1,     #狀態(f.status):  A:工單調整  B:工單變更 C:不予調整 D:作廢調整 E:建議結案
        voh07            LIKE voh_file.voh07,     #APS變更碼(voh07):    0：無變更﹔1：廠內工單轉外包﹔2：外包工單轉廠內工單﹔3：委外工單供應商變更﹔4：工單作業轉外包作業﹔5：委外作業轉廠內作業﹔6：委外作業供應商變更﹔7：工單製程變更﹔8：作業編號變更
        isoutsource      LIKE type_file.chr1,     #建議委外否 
        vod05_1          LIKE vod_file.vod05,     #工單號碼
        issue            LIKE type_file.chr1,     #
        sfb04            LIKE sfb_file.sfb04,     #
        vod09_1          LIKE vod_file.vod09,     #料號
        ima02            LIKE ima_file.ima02,     #品名
        chang            LIKE type_file.chr1,     #來源己異動  
        sfb13            LIKE sfb_file.sfb13,     #
        sfb14            LIKE sfb_file.sfb14,     #FUN-A10134 add
        vod11            LIKE type_file.chr100,   
        sfb15            LIKE sfb_file.sfb15,
        sfb16            LIKE sfb_file.sfb16,     #FUN-A10134 add
        vod10            LIKE type_file.chr100,   
        sfb08            LIKE sfb_file.sfb08,     #
        vod35            LIKE vod_file.vod35,     #APS生產量
        qty              LIKE vod_file.vod35,     #建議調整數量
        vod34            LIKE vod_file.vod34,     #
        vod39            LIKE vod_file.vod39,     #是否使用製程
        sfb87            LIKE sfb_file.sfb87,     #
        vod20            LIKE vod_file.vod20,     #
        isgenerate       LIKE type_file.num5,     #產生變更單
        gen_po           LIKE type_file.chr1,     #
        sfb09            LIKE sfb_file.sfb09,
        sfb081           LIKE sfb_file.sfb081,
        vod03            LIKE vod_file.vod03
                    END RECORD,
    #FUN-B80122---add----str---
    g_vod_t         RECORD                        #程式變數 (舊值)
        vod37_1          LIKE vod_file.vod37,     #變更否
        status           LIKE type_file.chr1,     #狀態(f.status):  A:工單調整  B:工單變更 C:不予調整 D:作廢調整 E:建議結案
        voh07            LIKE voh_file.voh07,     #APS變更碼(voh07):    0：無變更﹔1：廠內工單轉外包﹔2：外包工單轉廠內工單﹔3：委外工單供應商變更﹔4：工單作業轉外包作業﹔5：委外作業轉廠內作業﹔6：委外作業供應商變更﹔7：工單製程變更﹔8：作業編號變更
        isoutsource      LIKE type_file.chr1,     #建議委外否 
        vod05_1          LIKE vod_file.vod05,     #工單號碼
        issue            LIKE type_file.chr1,     #
        sfb04            LIKE sfb_file.sfb04,     #
        vod09_1          LIKE vod_file.vod09,     #料號
        ima02            LIKE ima_file.ima02,     #品名
        chang            LIKE type_file.chr1,     #來源己異動  
        sfb13            LIKE sfb_file.sfb13,     #
        sfb14            LIKE sfb_file.sfb14,     #FUN-A10134 add
        vod11            LIKE type_file.chr100,   
        sfb15            LIKE sfb_file.sfb15,
        sfb16            LIKE sfb_file.sfb16,     #FUN-A10134 add
        vod10            LIKE type_file.chr100,   
        sfb08            LIKE sfb_file.sfb08,     #
        vod35            LIKE vod_file.vod35,     #APS生產量
        qty              LIKE vod_file.vod35,     #建議調整數量
        vod34            LIKE vod_file.vod34,     #
        vod39            LIKE vod_file.vod39,     #是否使用製程
        sfb87            LIKE sfb_file.sfb87,     #
        vod20            LIKE vod_file.vod20,     #
        isgenerate       LIKE type_file.num5,     #產生變更單
        gen_po           LIKE type_file.chr1,     #
        sfb09            LIKE sfb_file.sfb09,
        sfb081           LIKE sfb_file.sfb081,
        vod03            LIKE vod_file.vod03
                    END RECORD,
    #FUN-B80122---add----end---
        tm  RECORD  
            wc      LIKE type_file.chr1000,
            wc2     LIKE type_file.chr1000
            END RECORD,
    g_rec_b         LIKE type_file.num5,            #單身筆數
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000,
    g_t1            LIKE type_file.chr5,
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT

#主程式開始
DEFINE  p_row,p_col          LIKE type_file.num5
DEFINE  l_action_flag        STRING
DEFINE  g_forupd_sql         STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE  g_before_input_done  LIKE type_file.num5
DEFINE  g_cnt                LIKE type_file.num10
DEFINE  g_msg                LIKE ze_file.ze03
DEFINE  g_msg2               LIKE ze_file.ze03 
DEFINE  lc_qbe_sn            LIKE gbm_file.gbm01      
DEFINE  g_row_count          LIKE type_file.num10
DEFINE  g_curs_index         LIKE type_file.num10
DEFINE  g_jump               LIKE type_file.num10
DEFINE  mi_no_ask            LIKE type_file.num5
DEFINE  g_argv1              LIKE vod_file.vod01,
        g_argv2              LIKE vod_file.vod02
DEFINE  g_argv_flag          LIKE type_file.chr1  
DEFINE  hstatus              LIKE type_file.chr1      #單頭建議狀態
DEFINE  g_change_lang        LIKE type_file.chr1
DEFINE  l_pmm      RECORD LIKE pmm_file.*
DEFINE  l_pmn      RECORD LIKE pmn_file.*
DEFINE  l_pna      RECORD LIKE pna_file.*
DEFINE  l_pnb      RECORD LIKE pnb_file.*
DEFINE  l_pna02    LIKE pna_file.pna02
DEFINE  l_cnt      LIKE type_file.num5
DEFINE  l_sfb      RECORD LIKE sfb_file.*
DEFINE  l_vod      RECORD LIKE vod_file.*
DEFINE  l_voh      RECORD LIKE voh_file.*
DEFINE  l_voo      RECORD LIKE voo_file.*
DEFINE  l_vnf      RECORD LIKE vnf_file.*
DEFINE  l_voi      RECORD LIKE voi_file.*
DEFINE  l_vop      RECORD LIKE vop_file.*
DEFINE  l_vom      RECORD LIKE vom_file.*
DEFINE  l_vnd      RECORD LIKE vnd_file.*
DEFINE  l_sfe16    LIKE sfe_file.sfe16
DEFINE  l_ecm      RECORD LIKE ecm_file.*
DEFINE  l_ecb      RECORD LIKE ecb_file.*
DEFINE  l_sfa      RECORD LIKE sfa_file.*
DEFINE  l_sna      RECORD LIKE sna_file.*
DEFINE  l_snb      RECORD LIKE snb_file.*
DEFINE  l_vof      RECORD LIKE vof_file.*
DEFINE  l_cons     VARCHAR(1)
DEFINE  g_i        LIKE type_file.num5  
DEFINE  i,l_num    SMALLINT
DEFINE g_show_msg      DYNAMIC ARRAY OF RECORD
       fld01           LIKE  type_file.chr100,
       fld02           LIKE  type_file.chr100,
       fld03           LIKE  type_file.chr100,
       fld04           LIKE  type_file.chr100
                       END RECORD
DEFINE g_fld01         LIKE  gaq_file.gaq03
DEFINE g_fld02         LIKE  gaq_file.gaq03
DEFINE g_fld03         LIKE  gaq_file.gaq03
DEFINE g_fld04         LIKE  gaq_file.gaq03
DEFINE g_tmp1          LIKE  type_file.chr100
DEFINE g_tmp2          LIKE  type_file.chr100
DEFINE g_err_cnt       LIKE  type_file.num5   
DEFINE g_status1       LIKE  ze_file.ze03
DEFINE g_status2       LIKE  ze_file.ze03
DEFINE g_status3       LIKE  ze_file.ze03

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

    LET g_argv1   = ARG_VAL(1)          # 參數值(1)
    LET g_argv2   = ARG_VAL(2)          # 參數值(2)
    LET g_vod01   = NULL                #清除鍵值
    LET g_vod02   = NULL                #清除鍵值
    LET g_vod01_t = NULL
    LET g_vod02_t = NULL



    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time


    LET p_row = 4 LET p_col = 5

    OPEN WINDOW t821_w AT 2,2 WITH FORM "aps/42f/apst821"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()

    CALL t821_default()

    IF NOT cl_null(g_argv1) THEN
       CALL t821_q()
    END IF
    #lock 是否委外,有無製程
    CALL cl_set_comp_entry("status,sfb04,vod09,chang,vod10,vod35,qty,gen_po,isoutsource,vod39",FALSE)

    CALL cl_set_comp_visible("vod37,vod05, vod09",FALSE)
   #CALL cl_set_comp_entry("vod37_1",FALSE) #FUN-B80122 mark
    CALL cl_set_comp_visible("hstatus",TRUE)
    CALL cl_getmsg('abm-020',g_lang) RETURNING g_status1 #執行失敗
    CALL cl_getmsg('abm-019',g_lang) RETURNING g_status2 #執行成功
    CALL cl_getmsg('aps-803',g_lang) RETURNING g_status3 #已異動過,不可重覆執行

    CALL t821_menu()

    CLOSE WINDOW t821_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t821_default()
  CALL cl_set_comp_visible("vod03",FALSE) 

END FUNCTION

#QBE 查詢資料
FUNCTION t821_cs()
DEFINE l_vzy01   LIKE vzy_file.vzy01  
DEFINE l_vzy02   LIKE vzy_file.vzy02 


 DEFINE  l_type          LIKE type_file.chr2

   CLEAR FORM                             #清除畫面
   CALL g_vod.clear()

   INITIALIZE g_vod01 TO NULL
   INITIALIZE g_vod02 TO NULL

   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = " vod01 = '",g_argv1,"'"
      IF NOT cl_null(g_argv2) THEN
        LET tm.wc = tm.wc, " AND vod02 ='",g_argv2,"'"
      END IF
      LET tm.wc2=" 1=1 "
      LET g_sql = "SELECT UNIQUE vod01,vod02 ",
                   "  FROM vod_file,voh_file,sfb_file ",
                   " WHERE vod00 ='",g_plant,"'", 
                   "   AND vod01=voh01 ",
                   "   AND vod02=voh02 ",
                   "   AND vod03=voh03 ",
                   "   AND vod05=sfb01",
                   "   AND vod08='0' ",
                   "   AND (voh04<>'0' OR voh05<>'0') ", 
                   "   AND voh07 IN ('0','9') ", 
                   "   AND (vod37 IS NULL OR vod37='N') ",
                   "   AND ",tm.wc CLIPPED, 
                   "   AND ",tm.wc2 CLIPPED 
       IF g_argv_flag = 'Y' THEN
          LET g_argv1 = ''
       END IF
   ELSE
      CONSTRUCT BY NAME tm.wc ON vod01,vod02     
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
          IF g_vod01_t IS NOT NULL THEN
             DISPLAY g_vod01_t TO FORMONLY.vod01
             DISPLAY g_vod02_t TO FORMONLY.vod02
          END IF

       AFTER FIELD vod01
          LET g_vod01 =  GET_FLDBUF(vod01)
          IF cl_null(g_vod01) THEN
             CALL cl_err('','aps-521',1)
             NEXT FIELD vod01
          END IF

     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(vod01)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_vod03"
              LET g_qryparam.arg1 = g_plant
              CALL cl_create_qry() RETURNING g_vod01,g_vod02
              DISPLAY g_vod01 TO vod01
              DISPLAY g_vod02 TO vod02
              NEXT FIELD vod01

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
           CALL cl_qbe_list() RETURNING lc_qbe_sn
           CALL cl_qbe_display_condition(lc_qbe_sn)
     END CONSTRUCT

     IF INT_FLAG THEN
          RETURN
     END IF

     LET g_vod01_t = g_vod01
     LET g_vod02_t = g_vod02

     LET hstatus = 'A'

      INPUT hstatus,g_vod37 WITHOUT DEFAULTS FROM hstatus,vod37

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        ON ACTION about
           CALL cl_about()
        ON ACTION help
           CALL cl_show_help()
        ON ACTION controlg
           CALL cl_cmdask()
        ON ACTION qbe_save
           CALL cl_qbe_save()
        ON ACTION locale
          LET g_change_lang = TRUE
          EXIT INPUT
     END INPUT


     CALL cl_set_head_visible("","YES")
   END IF
   IF tm.wc IS NULL THEN 
      LET tm.wc=" 1=1 "
   END IF
   LET tm.wc2 = " 1=1 "

  LET g_sql = "SELECT UNIQUE vod01,vod02 ",
              " FROM vod_file,voh_file,sfb_file",
              " WHERE vod00 ='",g_plant,"'", 
              "  AND  vod01 =voh01 AND vod02=voh02 AND vod03=voh03 ",
              "   AND vod05=sfb01",
              "   AND vod08='0' ",
              "   AND (voh04<>'0' or voh05<>'0') AND  voh07 in ('0','9') ",
              "   AND ",tm.wc CLIPPED, 
              "   AND ",tm.wc2 CLIPPED, 
              " ORDER BY vod01,vod02"

   PREPARE t821_prepare FROM g_sql
   DECLARE t821_cs SCROLL CURSOR WITH HOLD FOR t821_prepare

    LET g_sql = " SELECT UNIQUE vod01,vod02 ", 
                " FROM vod_file,voh_file,sfb_file",
                " WHERE vod00 ='",g_plant,"'", 
                "   AND  vod01 =voh01 AND vod02=voh02 AND vod03=voh03 ",
                "   AND vod05=sfb01",
                "   AND vod08='0' "
                IF g_vod37 = 'N'  THEN
                   LET g_sql = g_sql,"   AND (vod37 IS NULL OR vod37='N') "
                ELSE
                   LET g_sql = g_sql," AND (vod37='Y') "
                END IF
                LET g_sql = g_sql,
                "   AND (voh04<>'0' or voh05<>'0') AND  voh07 in ('0','9') ", 
                "   AND ",tm.wc CLIPPED, 
                "   AND ",tm.wc2 CLIPPED,
                "  INTO TEMP x " 
   DROP TABLE x
   PREPARE t821_precount_x FROM g_sql
   EXECUTE t821_precount_x

   LET g_sql="SELECT COUNT(*) FROM x "

   PREPARE t821_precount FROM g_sql
   DECLARE t821_count CURSOR FOR t821_precount
END FUNCTION

FUNCTION t821_menu()

   WHILE TRUE
      CALL t821_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t821_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #FUN-B80122---add----str---
         #全選
         WHEN "pick_all"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF cl_chk_act_auth() THEN
                  IF t821_pick('A') THEN
                     MESSAGE 'No Rows can be chosen'
                  END IF
               END IF
            END IF

         #全不選
         WHEN "drop_all"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF cl_chk_act_auth() THEN
                  IF t821_pick('E') THEN
                     MESSAGE 'No Rows can be chosen'
                  END IF
               END IF
            END IF
         #FUN-B80122---add----end---
         #APS建議工單檢視
         WHEN "view_aps_wo"      
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF cl_chk_act_auth() THEN                              
                  IF g_rec_b > 0 AND l_ac > 0 THEN
                      LET g_msg = " apsq821 '", g_vod[l_ac].vod05_1,"'  '", g_vod01,"' '", g_vod02,"'"
                      CALL cl_cmdrun(g_msg CLIPPED)                   
                  END IF
               END IF
            END IF
         #工單維護
         WHEN "maint_w_o"  
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF cl_chk_act_auth() THEN                             
                  IF g_rec_b > 0 AND l_ac > 0 THEN
                  LET g_msg = " asfi301 '", g_vod[l_ac].vod05_1,"'"
                  CALL cl_cmdrun(g_msg CLIPPED)                     
                  END IF
               END IF
            END IF

         WHEN "batch_wo_adjust"   #整批工單調整
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
              IF hstatus<>'A' THEN
                 CALL cl_err('','aps-774',1)
              END IF 
              IF cl_chk_act_auth() AND hstatus='A'  THEN
                  LET g_success = 'Y'
                  CALL t821_batch_wo_adjust()
                  CALL t821_b_fill("1=1")    #單身
              END IF
           END IF

         WHEN "batch_wo_upgrade"  #整批產生變更單
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
              IF hstatus<>'B'THEN
                 CALL cl_err('','aps-774',1)
              END IF
              IF cl_chk_act_auth() AND hstatus='B' THEN
                  LET g_success = 'Y'
                  CALL t821_batch_wo_upgrade()
                  CALL t821_b_fill("1=1")    #單身 
              END IF
            END IF
  
         #作廢自動調整
         WHEN "chg_void"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF hstatus<>'D'THEN
                  CALL cl_err('','aps-774',1)
               END IF
               IF cl_chk_act_auth() AND hstatus='D' THEN
                   LET g_success = 'Y'
                   CALL t821_chg_void()
                   CALL t821_b_fill("1=1")    #單身
               END IF
            END IF 

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vod),'','')
            END IF
         #FUN-B80122----add----str----
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL t821_b()
            END IF
         #FUN-B80122----add----end----
      END CASE
   END WHILE
END FUNCTION


FUNCTION t821_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_vod01 TO NULL
   INITIALIZE g_vod02 TO NULL
   CALL g_vod.clear()

   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY '   ' TO FORMONLY.cnt

   CALL t821_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t821_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      INITIALIZE g_vod01 TO NULL
      INITIALIZE g_vod02 TO NULL
      CALL g_vod.clear()
   ELSE
      OPEN t821_count
      FETCH t821_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t821_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION


#處理資料的讀取
FUNCTION t821_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        

   CASE p_flag
      WHEN 'N' FETCH NEXT     t821_cs INTO g_vod01,g_vod02
      WHEN 'P' FETCH PREVIOUS t821_cs INTO g_vod01,g_vod02
      WHEN 'F' FETCH FIRST    t821_cs INTO g_vod01,g_vod02
      WHEN 'L' FETCH LAST     t821_cs INTO g_vod01,g_vod02
      WHEN '/'
         IF NOT mi_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
               ON ACTION about
                  CALL cl_about()
               ON ACTION help
                  CALL cl_show_help()
               ON ACTION controlg
                  CALL cl_cmdask()
            END PROMPT

            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump t821_cs INTO g_vod01,g_vod02
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vod01,SQLCA.sqlcode,0)
      INITIALIZE g_vod01 TO NULL
      INITIALIZE g_vod02 TO NULL
      CLEAR FORM
      CALL g_vod.clear()
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
   SELECT UNIQUE vod01,vod02 INTO g_vod01,g_vod02 FROM vod_file WHERE vod01 = g_vod01 AND vod02 = g_vod02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","vod_file",g_vod01,g_vod02,SQLCA.sqlcode,"","",1)
      INITIALIZE g_vod01 TO NULL
      INITIALIZE g_vod02 TO NULL
      CALL g_vod.clear()
      RETURN
   END IF
   CALL t821_show()
END FUNCTION


#將資料顯示在畫面上
FUNCTION t821_show()
   DISPLAY g_vod01 TO FORMONLY.vod01
   DISPLAY g_vod02 TO FORMONLY.vod02
   LET g_vod01_t = g_vod01
   LET g_vod02_t = g_vod02

   CALL t821_b_fill("1=1")    #單身
   CALL cl_show_fld_cont()
END FUNCTION


FUNCTION t821_b_fill(p_wc1)
DEFINE
   p_wc1           LIKE type_file.chr1000,
   l_sfb04         LIKE sfb_file.sfb04,
   l_sfb081        LIKE sfb_file.sfb081,
   l_vod04         LIKE vod_file.vod04,  
   l_vod06         LIKE vod_file.vod06,  
   l_vod23         LIKE vod_file.vod23,  
   l_vod25         LIKE vod_file.vod25,  
   l_sfb08         LIKE sfb_file.sfb08,  
   l_sfb15         LIKE sfb_file.sfb15,  
   l_sfb09         LIKE sfb_file.sfb09, 
   l_sfb12         LIKE sfb_file.sfb12, 
   l_gen           LIKE type_file.num5  

   IF cl_null(p_wc1) THEN LET p_wc1 = ' 1=1' END IF

   # add voo_file
   LET g_sql = "SELECT case when vod37 is null then 'N' else vod37 end vod37,'',voh07, ",
                 "     case when voo03 is null then 'N' else 'Y' end isoutsource, vod05,",
                 "     '', sfb04,vod09,ima02,'',",          
                 "     sfb13,sfb14,vod11,sfb15,sfb16,vod10, ", #FUN-A10134 add sfb14,sfb16
                 "     sfb08,vod35,vod35-sfb08, ", 
                 "     vod34,",
                 "     vod39,sfb87,vod20,'','N',sfb09,sfb081,vod03  ", 
                #"  FROM vod_file,voh_file,sfb_file,OUTER voo_file,OUTER ima_file ", #FUN-B50020 mark
                #FUN-B50020---add---str---
                 "  FROM vod_file ",
                 "    LEFT OUTER JOIN voo_file ",
                 "    ON vod00 = voo00 ",
                 "   AND vod01 = voo01 ",
                 "   AND vod02 = voo02 ",
                 "   AND vod03 = voo03 ",
                 "    LEFT OUTER JOIN ima_file ",
                 "    ON vod09 = ima01 ",
                 " ,voh_file,sfb_file  ",
                #FUN-B50020---add---end---
                 " WHERE vod00 ='",g_plant,"'", 
                 "   AND vod01 ='",g_vod01,"'",
                 "   AND vod02 ='",g_vod02,"'",
                #FUN-B50020---mark--str---
                #"   AND vod00 = voo00 ", 
                #"   AND vod01 = voo01 ",
                #"   AND vod02 = voo02 ",
                #"   AND vod03 = voo03 ",
                #"   AND vod09 = ima01 ",
                #FUN-B50020---mark--end---
                 "   AND vod01 = voh01 ",
                 "   AND vod02 = voh02 ",
                 "   AND vod03 = voh03 ",
                 "   AND vod05 = sfb01",
                 "   AND vod08 = '0' ",
                 "   AND (vod37 IS NULL OR vod37='N') ",
                 "   AND sfb08 <> sfb09 ",
                 "   AND sfb87 <> 'X' ",  #作廢
                 "   AND sfb04 <> '8' ",
                 "   AND (voh04 <> '0' OR voh05 <> '0') ",    #voh04:是否數量變更 voh05:是否日期變更
                 "   AND voh07 IN ('0','9') ",                #變更碼=>'0':無變更 '9':外包時間類型變更
                 "   AND ",tm.wc CLIPPED, 
                 "   AND ",tm.wc2 CLIPPED 
   CASE  hstatus
      WHEN 'A' #工單調整
         LET  g_sql = g_sql , " AND sfb04 = '1' ",            #工單狀態碼=>'1':開立
                              " AND vod35 > 0 ",              #建議開立量
                              " AND (SUBSTR(vod10, 1,10) <> sfb15 ",  #預計完工日
                              "  OR  SUBSTR(vod10,12,16) <> sfb16 ",  #預計完工時間 #FUN-A10134 add
                              "  OR  SUBSTR(vod11, 1,10) <> sfb13 ",  #預計開工日
                              "  OR  SUBSTR(vod11,12,16) <> sfb14 ",  #預計開工時間 #FUN-A10134 add
                              "  OR  vod35 < sfb08 ) "        #生產數量
      WHEN 'B' #工單變更
         LET  g_sql = g_sql , " AND sfb04 NOT IN ('1','8') ", #工單狀態碼=>非開立及結案之工單
                              " AND vod35 > 0 ",              #建議開立量
                              " AND (SUBSTR(vod10, 1,10) <> sfb15 ",  #預計完工日
                              "  OR  SUBSTR(vod10,12,16) <> sfb16 ",  #預計完工時間 #FUN-A10134 add
                              "  OR  SUBSTR(vod11, 1,10) <> sfb13 ",  #預計開工日
                              "  OR  SUBSTR(vod11,12,16) <> sfb14 ",  #預計開工時間 #FUN-A10134 add
                              "  OR  vod35 < sfb08 )      ",  #生產數量
                              " AND (vod35 >= sfb09 ",        #完工入庫數量
                              " AND  vod35 >= sfb081 ) "      #已發套數
      WHEN 'C' #不予調整
         LET  g_sql = g_sql , " AND vod35 > 0 ",              #建議開立量
                              " AND (vod35 < sfb09 ",         #完工入庫數量
                              "  OR  vod35 < sfb081 ",        #已發套數
                              "  OR  sfb04 = '8' ) "          #工單狀態碼=>結案
      WHEN 'D' #作廢調整
         LET  g_sql = g_sql , " AND sfb04 = '1' ",            #工單狀態碼=>'1':開立
                              " AND vod35 = 0 "               #建議開立量
      WHEN 'E' #建議結案
         LET  g_sql = g_sql , " AND sfb04 <> '1' ",           #工單狀態碼=>'1':開立
                              " AND vod35 = 0 "               #建議開立量
   END CASE
   LET g_sql = g_sql, " ORDER BY vod01,vod02,vod05 "
   PREPARE t821_pb1 FROM g_sql
   DECLARE vod_curs1 CURSOR FOR t821_pb1

   CALL g_vod.clear()
   LET g_cnt= 1
   FOREACH vod_curs1 INTO g_vod[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

      #==>發料否
      SELECT COUNT(*) 
        INTO l_cnt
        FROM sfe_file
       WHERE sfe01 = g_vod[g_cnt].vod05_1
         AND sfe16 > 0
      IF l_cnt > 0 THEN
         LET g_vod[g_cnt].issue = 'Y'
      ELSE
         LET g_vod[g_cnt].issue = 'N'
      END IF

      #==>已產生委外PO否
      SELECT COUNT(*) INTO l_cnt
        FROM pmn_file
       WHERE pmn41 = g_vod[g_cnt].vod05_1
      IF l_cnt > 0 THEN
         LET g_vod[g_cnt].gen_po = 'Y'
      END IF

      #==>狀態
      LET g_vod[g_cnt].status = hstatus

      #==>產生變更單
      SELECT COUNT(*) INTO l_gen 
        FROM snb_file
       WHERE snb01 = g_vod[g_cnt].vod05_1
         AND snbconf = 'N'
      IF l_gen > 0 THEN
         LET g_vod[g_cnt].isgenerate=1 #已產生
      ELSE
         LET g_vod[g_cnt].isgenerate=0 #未產生
      END IF

      SELECT vod04,vod06,vod23,vod25 
        INTO l_vod04,l_vod06,l_vod23,l_vod25
        FROM vod_file
       WHERE vod01 = g_vod01
         AND vod02 = g_vod02
         AND vod05 = g_vod[g_cnt].vod05_1
         AND vod09 = g_vod[g_cnt].vod09_1

      SELECT sfb08,sfb15,sfb09,sfb12 
        INTO l_sfb08,l_sfb15,l_sfb09,l_sfb12
        FROM sfb_file
       WHERE sfb01=g_vod[g_cnt].vod05_1
      #==>來源已變動
      IF (l_sfb08 <> l_vod04) OR     #生產數量
         (l_sfb15 <> l_vod06) OR     #預計完工日
         (l_sfb09 <> l_vod23) OR     #完工入庫數量
         (l_sfb12 <> l_vod25) THEN   #報廢數量
         LET  g_vod[g_cnt].chang='Y'
      ELSE
         LET  g_vod[g_cnt].chang='N'
      END IF
      LET g_cnt=g_cnt+1
   END FOREACH
   CALL g_vod.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION


FUNCTION t821_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF


   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)


   DISPLAY ARRAY g_vod TO s_vod.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_set_act_visible("batch_wo_adjust,batch_wo_upgrade,chg_void,view_aps_wo,maint_w_o",TRUE)           
      #FUN-B80122---add----str---
      #110906
          CALL cl_set_action_active("pick_all,drop_all,detail,accept,batch_wo_adjust,batch_wo_upgrade,chg_void,detail",FALSE)
      CASE
         WHEN hstatus='A' #batch_wo_adjust工單調整
            CALL cl_set_action_active("pick_all,drop_all,detail,accept,batch_wo_adjust",TRUE)
         WHEN hstatus='B' #batch_wo_upgrade工單變更
            CALL cl_set_action_active("pick_all,drop_all,detail,accept,batch_wo_upgrade",TRUE)
         WHEN hstatus='D' #chg_void作廢調整
            CALL cl_set_action_active("pick_all,drop_all,detail,accept,chg_void",TRUE)
      END CASE
      #FUN-B80122---add----end---

      BEFORE ROW
         LET l_ac = ARR_CURR()

      #FUN-B80122---add----str---
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION pick_all
         LET g_action_choice="pick_all"
         EXIT DISPLAY

      ON ACTION drop_all
         LET g_action_choice="drop_all"
         EXIT DISPLAY
      #FUN-B80122---add----end---

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL t821_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY

      ON ACTION previous
         CALL t821_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL t821_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL t821_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL t821_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
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

      ON ACTION close
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

      #APS建議工單檢視
      ON ACTION view_aps_wo      
         LET g_action_choice = "view_aps_wo"
         EXIT DISPLAY

      #工單維護
      ON ACTION maint_w_o   
         LET g_action_choice = "maint_w_o"
         EXIT DISPLAY

      #整批工單調整
      ON ACTION batch_wo_adjust   
         LET g_action_choice = "batch_wo_adjust"
         EXIT DISPLAY

      #整批產生工單變更單
      ON ACTION batch_wo_upgrade   
         LET g_action_choice = "batch_wo_upgrade"
         EXIT DISPLAY

      #作廢自動調整
      ON ACTION chg_void          
         LET g_action_choice="chg_void"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


#工單作廢自動調整
FUNCTION t821_chg_void()
DEFINE l_i        LIKE type_file.num5   
DEFINE l_update   VARCHAR(1),
       l_cnt      SMALLINT,
       l_str      STRING

   #詢問是否確定執行
   IF NOT cl_confirm('aap-017') THEN
      LET g_success = 'N'
      LET l_cons = 'N'
      RETURN
   END IF

   LET l_str = cl_getmsg('aps-738',g_lang)
   MESSAGE l_str
   LET l_cons = 'Y'
   CALL g_show_msg.clear()
   LET g_err_cnt = 0
   FOR l_i = 1 TO g_rec_b

      #FUN-B80122--add---str---
       IF g_vod[l_i].vod37_1 = 'N' THEN
           CONTINUE FOR
       END IF
      #FUN-B80122--add---end---

        SELECT * INTO l_vod.*
          FROM vod_file
         WHERE vod00 = g_plant
           AND vod01 = g_vod01
           AND vod02 = g_vod02
           AND vod03 = g_vod[l_i].vod03
        SELECT * INTO l_sfb.*
          FROM sfb_file
         WHERE sfb01 = g_vod[l_i].vod05_1
  
       #FUN-B80122--mark---str-----
       #IF g_vod[l_i].vod37_1 = 'Y' THEN
       #    LET g_err_cnt = g_err_cnt + 1
       #    LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
       #    LET g_show_msg[g_err_cnt].fld02 = g_status3
       #    CONTINUE FOR
       #END IF
       #FUN-B80122--mark---end-----
        BEGIN WORK
        LET g_success = 'Y'

        UPDATE sfb_file 
           SET sfb87   = 'X',
               sfbmodu = 'aps',
               sfbdate = g_today   
         WHERE sfb01 = l_sfb.sfb01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            LET g_success = 'N'
            ROLLBACK WORK
            LET g_err_cnt = g_err_cnt + 1
            LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
            LET g_show_msg[g_err_cnt].fld02 = g_status1
            LET g_show_msg[g_err_cnt].fld03 = 'UPDATE sfb_file Error !' #091127
            CALL t821_getmsg('sfb01',l_sfb.sfb01,'','','','','','','','','','')   #FUN-940030 ADD
            LET g_show_msg[g_err_cnt].fld04 = g_msg
            CONTINUE FOR
        END IF
        IF g_success = 'Y' THEN
           LET l_cnt = l_cnt + 1 
           UPDATE vod_file
              SET vod37 = 'Y' 
            WHERE vod00 = l_vod.vod00
              AND vod01 = l_vod.vod01
              AND vod02 = l_vod.vod02
              AND vod03 = l_vod.vod03
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              LET g_success = 'N'
              LET g_err_cnt = g_err_cnt + 1
              LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
              LET g_show_msg[g_err_cnt].fld02 = g_status1
              LET g_show_msg[g_err_cnt].fld03 = 'UPDATE vod37 Error !' 
              CALL t821_getmsg('vod00',l_vod.vod00,'vod01',l_vod.vod01,'vod02',l_vod.vod02,'vod03',l_vod.vod03,'','','','')   #FUN-940030 ADD
              LET g_show_msg[g_err_cnt].fld04 = g_msg
              ROLLBACK WORK  
              CONTINUE FOR
           ELSE
               LET g_err_cnt = g_err_cnt + 1
               LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
               LET g_show_msg[g_err_cnt].fld02 = g_status2 #成功
           END IF
           COMMIT WORK
        END IF
    END FOR     
    CALL t821_show_msg() 
END FUNCTION

FUNCTION t821_batch_wo_upgrade2(l_sfb,l_vod,p_cmd)
DEFINE l_vod10    LIKE type_file.chr100 
DEFINE l_vod11    LIKE type_file.chr100
DEFINE  l_t1      LIKE pmm_file.pmm01,
        l_sna06a  LIKE sna_file.sna06a,
        l_ima64   LIKE ima_file.ima64,
        l_ima641  LIKE ima_file.ima641,
        l_gfe03   LIKE gfe_file.gfe03,
        l_sfaqty  LIKE sna_file.sna05a,
        l_subqty  LIKE sfa_file.sfa05,   #主料被替代量
        l_double  LIKE type_file.num10,
        l_cmd     STRING,
        p_cmd     VARCHAR(01),
        l_sfb     RECORD  LIKE  sfb_file.*,
        l_vod     RECORD  LIKE  vod_file.*

     #產生工單變更單單頭
     INITIALIZE l_snb.* LIKE snb_file.*             #DEFAULT 設定
     LET l_snb.snb01  = l_sfb.sfb01
     LET l_snb.snb02  = ''
    #SELECT snb02 INTO l_snb.snb02 FROM snb_file        #FUN-B50020 mark
     SELECT MAX(snb02) INTO l_snb.snb02 FROM snb_file   #FUN-B50020 add
      WHERE snb01 = l_snb.snb01
     IF cl_null(l_snb.snb02) THEN
        LET l_snb.snb02 = 1
     ELSE
        LET l_snb.snb02 = l_snb.snb02 + 1
     END IF
     LET l_snb.snb022 = g_today
     LET l_snb.snb04 = '2'
     LET l_snb.snb08b=l_sfb.sfb08
     LET l_snb.snb13b=l_sfb.sfb13
     LET l_snb.snb15b=l_sfb.sfb15
     LET l_snb.snb82b=l_sfb.sfb82
     SELECT vod10,vod11 INTO l_vod10,l_vod11
       FROM vod_file
      WHERE vod00 = l_vod.vod00
        AND vod01 = l_vod.vod01
        AND vod02 = l_vod.vod02
        AND vod03 = l_vod.vod03
     LET l_snb.snb13a = l_vod11[1 ,10]
     LET l_snb.snb14a = l_vod11[12,16] #FUN-A10134 add
     LET l_snb.snb15a = l_vod10[1 ,10]
     LET l_snb.snb16a = l_vod10[12,16] #FUN-A10134 add
     LET l_snb.snb08a = l_vod.vod35
     IF l_snb.snb13b = l_snb.snb13a THEN
         LET l_snb.snb13a = NULL
     END IF
     IF l_snb.snb15b = l_snb.snb15a THEN
         LET l_snb.snb15a = NULL
     END IF
     #FUN-A10134---add----str---
     IF l_snb.snb14b = l_snb.snb14a THEN
         LET l_snb.snb14a = NULL
     END IF
     IF l_snb.snb16b = l_snb.snb16a THEN
         LET l_snb.snb16a = NULL
     END IF
     #FUN-A10134---add----end---
     IF l_snb.snb08b = l_snb.snb08a THEN
         LET l_snb.snb08a = NULL
     END IF
     LET l_snb.snbconf = 'N'                    #發出否
     LET l_snb.snbgrup=g_grup
     LET l_snb.snbdate=g_today
     LET l_snb.snbuser='aps'  
     IF cl_null(l_sfb.sfbmksg) THEN LET l_sfb.sfbmksg = 'N' END IF #FUN-B50020 add
     LET l_snb.snbmksg= l_sfb.sfbmksg
     LET l_snb.snbplant = g_plant  #FUN-B50020 add所屬營運中心
     LET l_snb.snblegal = g_legal  #FUN-B50020 add所屬法人
     LET l_snb.snborig=g_grup      #FUN-B50020 add
     LET l_snb.snboriu=g_user      #FUN-B50020 add
     IF cl_null(l_snb.snb14b) THEN LET l_snb.snb14b = '00:00' END IF #FUN-B50020 add
     IF cl_null(l_snb.snb16b) THEN LET l_snb.snb16b = '00:00' END IF #FUN-B50020 add

     INSERT INTO snb_file VALUES(l_snb.*)
     IF SQLCA.sqlcode THEN
        LET g_success = 'N'
        LET g_err_cnt = g_err_cnt + 1
        LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
        LET g_show_msg[g_err_cnt].fld02 = g_status1
        LET g_show_msg[g_err_cnt].fld03 = "INSERT INTO snb_file Error!"
        CALL t821_getmsg('snb01',l_snb.snb01,'snb02',l_snb.snb02,'','','','','','','','') 
        LET g_show_msg[g_err_cnt].fld04 = g_msg
        RETURN
     END IF
     #若是變更數量則需產生單身
     IF NOT cl_null(l_snb.snb08a) THEN
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM sfa_file WHERE sfa01=l_snb.snb01
        IF l_cnt > 0 THEN
           LET g_sql = "SELECT * FROM sfa_file ",
                       " WHERE sfa01 = ? "
           PREPARE ct821_prepare FROM g_sql
           DECLARE ct821_cl CURSOR FOR ct821_prepare

           LET l_cnt = 0
           FOREACH ct821_cl USING l_snb.snb01 INTO l_sfa.*
               INITIALIZE l_sna.* LIKE sna_file.*             #DEFAULT 設定
               LET l_cnt=l_cnt+1
               LET l_sna.sna01  =l_snb.snb01
               LET l_sna.sna02  =l_snb.snb02
               LET l_sna.sna022 =l_snb.snb022
               LET l_sna.sna04  =l_cnt
               LET l_sna.sna10  ='2'
               LET l_sna.sna03b =l_sfa.sfa03
               LET l_sna.sna05b =l_sfa.sfa05
               LET l_sna.sna06b =l_sfa.sfa06
               LET l_sna.sna062b=l_sfa.sfa062
               LET l_sna.sna065b=l_sfa.sfa065
               LET l_sna.sna07b =l_sfa.sfa07
               LET l_sna.sna08b =l_sfa.sfa08
               LET l_sna.sna100b=l_sfa.sfa100
               LET l_sna.sna11b =l_sfa.sfa11
               LET l_sna.sna12b =l_sfa.sfa12
               LET l_sna.sna13b =l_sfa.sfa13
               LET l_sna.sna161b=l_sfa.sfa161
               LET l_sna.sna26b =l_sfa.sfa26
               LET l_sna.sna27b =l_sfa.sfa27
               LET l_sna.sna28b =l_sfa.sfa28
               LET l_sna.sna30b =l_sfa.sfa30
               LET l_sna.sna31b =l_sfa.sfa31
               LET l_sna.sna05a =l_sfa.sfa05*l_snb.snb08a/l_snb.snb08b
               LET l_sna.sna05a = s_digqty(l_sna.sna05a,l_sna.sna12b)   #FUN-910088--add--
               LET l_sna.sna06a =l_sna.sna05a  #記錄原發數量
               LET l_sna06a = l_sna.sna05a
               #考慮變更生產數量時,備料的最小發料數量及發料單位批量
               #Inflate With Minimum Issue Qty And Issue Pansize
               SELECT ima64,ima641 INTO l_ima64,l_ima641
                 FROM ima_file
                WHERE ima01=l_sfa.sfa03
               IF l_ima641 != 0 AND l_sna.sna05a < l_ima641 THEN
                  LET l_sna.sna05a=l_ima641
               END IF
               IF l_ima64!=0 THEN
                  LET l_double=(l_sna.sna05a/l_ima64)+ 0.999999
                  LET l_sna.sna05a=l_double*l_ima64
               END IF

               #-->考慮單位小數取位
               SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = l_sfa.sfa12
               IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
               CALL cl_digcut(l_sna.sna05a,l_gfe03) RETURNING l_sfaqty
               LET l_sna.sna05a =  l_sfaqty
               #-->重新計算QPA
               LET l_subqty=0
               SELECT SUM(sfa05/sfa28) INTO l_subqty FROM sfa_file
                WHERE sfa01 = l_snb.snb01
                  AND sfa27 = l_sna.sna03b
                  AND sfa26 IN ('S','U')
               IF cl_null(l_subqty) THEN
                  LET l_subqty=0
               END IF
               IF NOT cl_null(l_snb.snb08a) THEN #考慮單頭變更的狀況
                  LET l_subqty=l_subqty*l_snb.snb08a/l_snb.snb08b
               END IF
               IF l_sfa.sfa26 MATCHES '[SUTsut]' THEN #替代料只能變更替代率
                  LET l_sna.sna161a = 0
                  LET l_sna.sna28a=l_sna.sna05a/l_sna06a*l_sna.sna28b #考慮單頭變更的狀況
               ELSE
                  LET l_sna.sna161a=(l_sna.sna05a+l_subqty)/l_snb.snb08a
               END IF
               #FUN-B50020--add----str---
               LET l_sna.snaplant = g_plant #所屬營運中心
               LET l_sna.snalegal = g_legal #所屬法人
               IF cl_null(l_sfa.sfa012) THEN LET l_sfa.sfa012 = ' ' END IF
               IF cl_null(l_sfa.sfa013) THEN LET l_sfa.sfa013 = 0 END IF
               LET l_sna.sna012b=l_sfa.sfa012  #變更前製程段號
               LET l_sna.sna013b=l_sfa.sfa013  #變更前製程序
               LET l_sna.sna012a=l_sfa.sfa012  #變更後製程段號
               LET l_sna.sna013a=l_sfa.sfa013  #變更後製程序
               #FUN-B50020--add----end---

               INSERT INTO sna_file VALUES(l_sna.*)
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N'
                  LET g_err_cnt = g_err_cnt + 1
                  LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
                  LET g_show_msg[g_err_cnt].fld02 = g_status1
                  LET g_show_msg[g_err_cnt].fld03 = "INSERT INTO sna_file Error!"
                  CALL t821_getmsg('sna01',l_sna.sna01,'sna02',l_sna.sna02,'sna04',l_sna.sna04,'','','','','','') 
                  LET g_show_msg[g_err_cnt].fld04 = g_msg
                  RETURN
               END IF
           END FOREACH
        END IF
     END IF
END FUNCTION


FUNCTION t821_cralc(l_sfb01)
   DEFINE l_minopseq   LIKE type_file.num5    
   DEFINE l_btflg   LIKE type_file.chr1    
   DEFINE l_ima910     LIKE ima_file.ima910   
   DEFINE l_n          LIKE type_file.num5
   DEFINE l_sfb01      LIKE sfb_file.sfb01
  
   SELECT * INTO l_sfb.*
     FROM sfb_file 
    WHERE sfb01 = l_sfb01

   IF l_sfb.sfb02 !=15 THEN   #此判斷應剔除 '15'試產性工單
      IF cl_null(l_sfb.sfb95 ) THEN
         LET l_sfb.sfb95 = ' '
      END IF
      SELECT COUNT(*) INTO l_n FROM bma_file
       WHERE bma05 IS NOT NULL 
         AND bma05 <= l_sfb.sfb071
         AND bma01 =  l_sfb.sfb05
         AND bma06 =  l_sfb.sfb95
      IF l_n =0 THEN
         LET g_err_cnt = g_err_cnt + 1
         LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
         LET g_show_msg[g_err_cnt].fld02 = g_status1
         #有效日期不可小於發放日期,或此BOM的發放日期為空白,請查核..!
         CALL cl_getmsg('abm-005',g_lang) RETURNING g_show_msg[g_err_cnt].fld03
         CALL t821_getmsg('bma01',l_sfb.sfb05,'bma06',l_sfb.sfb95,'bma05',l_sfb.sfb071,'','','','','','')   #FUN-940030 ADD
         LET g_show_msg[g_err_cnt].fld04 = g_msg
         LET g_success = 'N'
      END IF

      IF g_success <> 'N' THEN
         SELECT COUNT(*) INTO l_n FROM bma_file
          WHERE bma05 IS NOT NULL 
            AND bma05 <=l_sfb.sfb81
            AND bma01 = l_sfb.sfb05
            AND bma06 = l_sfb.sfb95 
         IF l_n =0 THEN
            LET g_err_cnt = g_err_cnt + 1
            LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
            LET g_show_msg[g_err_cnt].fld02 = g_status1
            #開單日期不可小於發放日期,或此BOM的發放日期為空白,請查核..!
            CALL cl_getmsg('abm-006',g_lang) RETURNING g_show_msg[g_err_cnt].fld03
            CALL t821_getmsg('bma01',l_sfb.sfb05,'bma06',l_sfb.sfb95,'bma05',l_sfb.sfb81,'','','','','','')  
            LET g_show_msg[g_err_cnt].fld04 = g_msg
            LET g_success = 'N'
         END IF
      END IF
   END IF

   IF g_success <> 'N' THEN
      SELECT COUNT(*) INTO l_n FROM sfa_file
       WHERE sfa01=l_sfb.sfb01
         AND (sfa06<>0 OR sfa062<>0 OR sfa063<>0 OR sfa064<>0)

      IF l_n>0 THEN 
         LET g_err_cnt = g_err_cnt + 1
         LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
         LET g_show_msg[g_err_cnt].fld02 = g_status1
         #已發料,不得更改
         CALL cl_getmsg('asf-413',g_lang) RETURNING g_show_msg[g_err_cnt].fld03
         LET  g_success = 'N'
      END IF
   END IF

   IF g_success <> 'N' THEN
      DELETE FROM sfa_file WHERE sfa01=l_sfb.sfb01
      IF SQLCA.sqlcode THEN
         LET g_err_cnt = g_err_cnt + 1
         LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
         LET g_show_msg[g_err_cnt].fld02 = g_status1
         LET g_show_msg[g_err_cnt].fld03 = 'DELETE sfa_file Error!'
         CALL t821_getmsg('sfa01',l_sfb.sfb01,'','','','','','','','','','') 
         LET g_show_msg[g_err_cnt].fld04 = g_msg
         LET  g_success = 'N'
      END IF
   END IF

   IF g_success <>'N' THEN
      CALL s_minopseq(l_sfb.sfb05,l_sfb.sfb06,l_sfb.sfb071) RETURNING l_minopseq

      CASE
         WHEN l_sfb.sfb02='13'     #預測工單展至尾階
              CALL s_cralc2(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                            l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,
                            ' 1=1',l_sfb.sfb95)   
              RETURNING l_n
         WHEN l_sfb.sfb02='15'     #試產性工單
              CALL s_cralc3(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                            l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,
                            l_sfb.sfb07,g_sma.sma883,l_sfb.sfb95) 
              RETURNING l_n
         OTHERWISE                 #一般工單展單階
             IF l_sfb.sfb02 = 11 THEN
                LET l_btflg = 'N'
             ELSE
                LET l_btflg = 'Y'
             END IF
             CALL s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,l_btflg,
                         #l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,l_sfb.sfb95) 
                          l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,'',l_sfb.sfb95)  #FUN-BC0008 mod
                RETURNING l_n
               #判斷sfb02若為'5，11'時不產生子工單
                  IF l_sfb.sfb02 != '5' AND l_sfb.sfb02 != '11' THEN
                      LET g_msg="asfp301 '",l_sfb.sfb01,"' '",   # for top40
                                 l_sfb.sfb81,"' '99' 'N'"
                      CALL cl_cmdrun_wait(g_msg)
                  END IF
      END CASE
   END IF
END FUNCTION

#整批工單調整
FUNCTION t821_batch_wo_adjust()
DEFINE l_i        LIKE type_file.num5   
DEFINE l_vod10    LIKE type_file.chr100 
DEFINE l_vod11    LIKE type_file.chr100 
DEFINE l_sfb13    LIKE sfb_file.sfb13   
DEFINE l_sfb14    LIKE sfb_file.sfb14   
DEFINE l_sfb15    LIKE sfb_file.sfb15   
DEFINE l_sfb16    LIKE sfb_file.sfb16   
DEFINE l_update   VARCHAR(1),
       l_cnt2     SMALLINT,
       l_str      STRING,
       l_name     LIKE type_file.chr1000

  #詢問是否確定執行
  IF NOT cl_confirm('lib-012') THEN
     LET g_success = 'N'
     LET l_cons = 'N'
     RETURN
  END IF
  LET l_cons = 'Y'
  LET l_str = cl_getmsg('aps-738',g_lang)
  MESSAGE l_str

  CALL g_show_msg.clear()
  LET g_err_cnt = 0
  FOR l_i = 1 TO g_rec_b 
       
      #FUN-B80122--add---str---
       IF g_vod[l_i].vod37_1 = 'N' THEN
           CONTINUE FOR
       END IF
      #FUN-B80122--add---end---
       SELECT * INTO l_vod.*
         FROM vod_file
        WHERE vod00 = g_plant
          AND vod01 = g_vod01
          AND vod02 = g_vod02
          AND vod03 = g_vod[l_i].vod03
       SELECT * INTO l_sfb.* 
         FROM sfb_file
        WHERE sfb01 = g_vod[l_i].vod05_1

       LET l_vod10 = g_vod[l_i].vod10
       LET l_vod11 = g_vod[l_i].vod11
      #FUN-B80122--mark--str---
      #IF g_vod[l_i].vod37_1 = 'Y' THEN
      #    LET g_err_cnt = g_err_cnt + 1
      #    LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
      #    LET g_show_msg[g_err_cnt].fld02 = g_status3
      #    CONTINUE FOR
      #END IF
      #FUN-B80122--mark--end---
       BEGIN WORK
       LET g_success = 'Y'   
   
       LET l_sfb13 = l_vod11[1,10]   #預計開工日
       LET l_sfb14 = l_vod11[12,16] 
       LET l_sfb15 = l_vod10[1,10]   #預計完工日
       LET l_sfb16 = l_vod10[12,16] 
       UPDATE sfb_file 
          SET sfb13   = l_sfb13,
              sfb14   = l_sfb14,
              sfb15   = l_sfb15,
              sfb16   = l_sfb16,
              sfb08   = l_vod.vod35,
              sfbmodu = 'aps',
              sfbdate = g_today   
        WHERE sfb01 = l_sfb.sfb01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           LET g_success = 'N'
           LET g_err_cnt = g_err_cnt + 1
           LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
           LET g_show_msg[g_err_cnt].fld02 = g_status1
           LET g_show_msg[g_err_cnt].fld03 = 'UPDATE sfb_file Error !'
           CALL t821_getmsg('sfb01',l_sfb.sfb01,'','','','','','','','','','') 
           LET g_show_msg[g_err_cnt].fld04 = g_msg
           ROLLBACK WORK
           CONTINUE FOR
        END IF

       DECLARE ecm_cs CURSOR FOR 
         SELECT * FROM ecm_file
          WHERE ecm01 = l_sfb.sfb01
       FOREACH ecm_cs INTO l_ecm.*
          SELECT *
           INTO l_ecb.*
           FROM ecb_file
          WHERE ecb01 = l_sfb.sfb05
            AND ecb02 = l_sfb.sfb06
            AND ecb03 = l_ecm.ecm03

          LET l_ecm.ecm14   =  l_ecb.ecb19 * l_vod.vod35    #標準工時(秒)
          LET l_ecm.ecm16   =  l_ecb.ecb21 * l_vod.vod35    #標準機時(秒)
          LET l_ecm.ecm49   =  l_ecb.ecb38 * l_vod.vod35    #製程人力

          UPDATE ecm_file SET ecm14 = l_ecm.ecm14,
                              ecm16 = l_ecm.ecm16,
                              ecm49 = l_ecm.ecm49,
                              ecmuser = 'aps',
                              ecmdate = g_today
             WHERE ecm01 = l_sfb.sfb01
               AND ecm03 = l_ecm.ecm03
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              LET g_success = 'N'
              LET g_err_cnt = g_err_cnt + 1
              LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
              LET g_show_msg[g_err_cnt].fld02 = g_status1
              LET g_show_msg[g_err_cnt].fld03 = 'UPDATE ecm_file Error !'
              CALL t821_getmsg('ecm01',l_sfb.sfb01,'ecm03',l_ecm.ecm03,'','','','','','','','')   
              LET g_show_msg[g_err_cnt].fld04 = g_msg
              ROLLBACK WORK  
              EXIT FOREACH  
          END IF
       END FOREACH 
  
       IF g_success = 'N'  THEN
          CONTINUE FOR
       END IF

      #FUN-A30101 mark---add---      
      ##備料檔重新產生
      #CALL t821_cralc(l_sfb.sfb01) 
      #IF g_success = 'N'  THEN
      #   ROLLBACK WORK
      #   CONTINUE FOR
      #END IF
      #FUN-A30101 mark---end---

       CALL t821_submo_upgrade()   ##委外製程相關處理
       IF g_success = 'Y' THEN
          LET l_cnt2 = l_cnt2 + 1
          UPDATE vod_file
             SET vod37 = 'Y' 
           WHERE vod00 = l_vod.vod00
             AND vod01 = l_vod.vod01
             AND vod02 = l_vod.vod02
             AND vod03 = l_vod.vod03
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             LET g_success = 'N'
             LET g_err_cnt = g_err_cnt + 1
             LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
             LET g_show_msg[g_err_cnt].fld02 = g_status1
             LET g_show_msg[g_err_cnt].fld03 = 'UPDATE vod37 Error !' #091127
             CALL t821_getmsg('vod00',l_vod.vod00,'vod01',l_vod.vod01,'vod02',l_vod.vod02,'vod03',l_vod.vod03,'','','','')   #FUN-940030 ADD
             LET g_show_msg[g_err_cnt].fld04 = g_msg
             ROLLBACK WORK  
             CONTINUE FOR
          ELSE
              LET g_err_cnt = g_err_cnt + 1
              LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
              LET g_show_msg[g_err_cnt].fld02 = g_status2 #成功
          END IF
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF

       #FUN-A30101--add---str---
       #備料檔重新產生
       CALL t821_cralc(l_sfb.sfb01)
       IF g_success = 'N'  THEN
          ROLLBACK WORK
          CONTINUE FOR
       END IF
       #FUN-A30101--add---end---
    END FOR     
    CALL t821_show_msg() 
END FUNCTION


#整批自動產生變更單
FUNCTION t821_batch_wo_upgrade()
DEFINE l_i        LIKE type_file.num5   
DEFINE l_update   VARCHAR(1),
       l_cnt,l_n  SMALLINT,
       l_cnt2     SMALLINT,
       l_str      STRING,
       l_name     LIKE type_file.chr1000
DEFINE l_count    LIKE sfa_file.sfa06
DEFINE p_cmd VARCHAR(1)

   #詢問是否確定執行
   IF NOT cl_confirm('lib-012') THEN
      LET g_success = 'N'
      LET l_cons = 'N'
      RETURN
   END IF

   LET l_cons = 'Y'
   CALL g_show_msg.clear()
   LET g_err_cnt = 0
   FOR l_i = 1 TO g_rec_b

      #FUN-B80122--add---str---
       IF g_vod[l_i].vod37_1 = 'N' THEN
           CONTINUE FOR
       END IF
      #FUN-B80122--add---end---

      SELECT * INTO l_vod.*
        FROM vod_file
       WHERE vod00 = g_plant
         AND vod01 = g_vod01
         AND vod02 = g_vod02
         AND vod03 = g_vod[l_i].vod03
      SELECT * INTO l_sfb.*
        FROM sfb_file
       WHERE sfb01 = g_vod[l_i].vod05_1
     #FUN-B80122--mark--str---
     #IF g_vod[l_i].vod37_1 = 'Y' THEN
     #    LET g_err_cnt = g_err_cnt + 1
     #    LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
     #    LET g_show_msg[g_err_cnt].fld02 = g_status3
     #    CONTINUE FOR
     #END IF
     #FUN-B80122--mark--end---
      BEGIN WORK
      LET g_success = 'Y'
      
      #檢查輸入之工單若有尚未做發出確認的工單變更單資料
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM snb_file
       WHERE snb01 = l_sfb.sfb01
         AND snbconf = 'N'
      IF l_n > 0 THEN
         LET g_success = 'N'
         LET g_err_cnt = g_err_cnt + 1
         LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
         LET g_show_msg[g_err_cnt].fld02 = g_status1
         #尚有未發出確認的工單變更單，請重新輸入！
         CALL cl_getmsg('asf-050',g_lang) RETURNING g_show_msg[g_err_cnt].fld03
         ROLLBACK WORK
         CONTINUE FOR
      END IF
      
      #==>產生工單變更單
      CALL t821_batch_wo_upgrade2(l_sfb.*, l_vod.*,p_cmd)
      IF g_success = 'N' THEN 
          ROLLBACK WORK
          CONTINUE FOR
      END IF
      CALL t821_submo_upgrade()   ##委外製程相關處理
      IF g_success = 'Y' THEN
         LET l_cnt2 = l_cnt2 + 1 
         UPDATE vod_file
            SET vod37 = 'Y'  
          WHERE vod00 = l_vod.vod00
            AND vod01 = l_vod.vod01
            AND vod02 = l_vod.vod02
            AND vod03 = l_vod.vod03
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            LET g_success = 'N'
            LET g_err_cnt = g_err_cnt + 1
            LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
            LET g_show_msg[g_err_cnt].fld02 = g_status1
            LET g_show_msg[g_err_cnt].fld03 = 'UPDATE vod37 Error !' 
            CALL t821_getmsg('vod00',l_vod.vod00,'vod01',l_vod.vod01,'vod02',l_vod.vod02,'vod03',l_vod.vod03,'','','','')   
            LET g_show_msg[g_err_cnt].fld04 = g_msg
            ROLLBACK WORK
            CONTINUE FOR
         ELSE
             LET g_err_cnt = g_err_cnt + 1
             LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
             LET g_show_msg[g_err_cnt].fld02 = g_status2 #成功
         END IF
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END FOR     
   CALL t821_show_msg() 

END FUNCTION

##委外變更
FUNCTION t821_submo_upgrade()
DEFINE   l_sfb41   LIKE sfb_file.sfb41
DEFINE   l_gen_po  LIKE type_file.chr1 #委外工單已產生委外採購單否

  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt
    FROM pmn_file
   WHERE pmn41 = l_vod.vod05
  IF l_cnt >=1  THEN
      LET l_gen_po = 'Y'
  ELSE
      LET l_gen_po = 'N'
  END IF

  SELECT pmm_file.*, pmn_file.*  
    INTO l_pmm.*, l_pmn.*
    FROM pmm_file,pmn_file
   WHERE pmm01 = pmn01 
     AND pmn41 = l_vod.vod05

  SELECT pnb_file.* INTO l_pnb.*
    FROM pnb_file,pna_file
   WHERE pnb01 = l_pmm.pmm01
     AND pnb01 = pna01
     AND pna05 = 'N'

  ##取出目前採購變更單之最大變更版次
  SELECT max(pna02) INTO l_pna02
    FROM pnb_file,pna_file
   WHERE pnb01=l_pmm.pmm01
     AND pnb01=pna01
  
  IF cl_null(l_pna02)  THEN
     LET l_pna02 = 0
  END IF

  ##委外採購單異動
  IF l_vod.vod42<>'0' AND l_gen_po = 'Y' AND #委外工單若已產生委外採購單
     l_vod.vod10 <> l_sfb.sfb15 AND    #預計完工日有調整
     g_success = 'Y' AND hstatus = 'B' THEN
     CASE    
        #未確認之單據可直接調整日期  
        WHEN  l_pmm.pmm25 = '0' OR l_pmm.pmm25 ='R' OR l_pmm.pmm25 ='W'
              UPDATE pmn_file 
                 SET pmn33 = l_vod.vod10,
                     pmn34 = l_vod.vod10,
                     pmn35 = l_vod.vod10
               WHERE pmn41 = l_sfb.sfb01
                 AND pmn04 = l_sfb.sfb05
              IF SQLCA.sqlcode THEN
                 LET g_success = 'N'  
                 LET g_err_cnt = g_err_cnt + 1
                 LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
                 LET g_show_msg[g_err_cnt].fld02 = g_status1
                 LET g_show_msg[g_err_cnt].fld03 = 'UPDATE pmn_file Error !'
                 CALL t821_getmsg('pmn41',l_sfb.sfb01,'pmn04',l_sfb.sfb05,'','','','','','','','')   
                 LET g_show_msg[g_err_cnt].fld04 = g_msg
              END IF
        #已發出之單據,需產生採購變更單
        WHEN l_pmm.pmm25 = '2'       #發出採購單
             SELECT count(*) INTO g_cnt FROM pna_file
              WHERE pna01 = l_pmm.pmm01
                AND pnaconf IN ('N','n')   
                AND pna05 <> 'X' #未作廢的 
             IF g_cnt > 0 THEN    # 代表尚有未發出的採購變更單
                 LET g_success = 'N'
                 LET g_err_cnt = g_err_cnt + 1
                 LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
                 LET g_show_msg[g_err_cnt].fld02 = g_status1
                 #尚有未發出之採購變更單,因此不允許異動
                 CALL cl_getmsg('aps-042',g_lang) RETURNING g_show_msg[g_err_cnt].fld03
                 CALL t821_getmsg('pnb01',l_pmm.pmm01,'','','','','','','','','','')   
                 LET g_show_msg[g_err_cnt].fld04 = g_msg
             ELSE
                 INITIALIZE l_pna.* TO NULL
                 LET l_pna.pna01   = l_pmm.pmm01
                 LET l_pna.pna02   = l_pna02+1
                 LET l_pna.pna04   = g_today
                 LET l_pna.pna05   = 'N'                    #發出否
                 LET l_pna.pna13   = '0'                    #開立       #No.6686
                 LET l_pna.pna14   = l_pmm.pmmmksg         
                 LET l_pna.pnaconf = 'N'                    #發出否
                 LET l_pna.pnaacti = 'Y'
                 LET l_pna.pnagrup=g_grup
                 LET l_pna.pnadate=g_today
                 LET l_pna.pnauser=g_user
                 LET l_pna.pnaplant = g_plant #FUN-B50020 add 所屬營運中心
                 LET l_pna.pnalegal = g_legal #FUN-B50020 add 所屬法人
                 INSERT INTO pna_file VALUES(l_pna.*)
                 IF SQLCA.sqlcode THEN
                    LET g_success = 'N'
                    LET g_err_cnt = g_err_cnt + 1
                    LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
                    LET g_show_msg[g_err_cnt].fld02 = g_status1
                    LET g_show_msg[g_err_cnt].fld03 = 'INSERT INTO pna_file Error !'
                    CALL t821_getmsg('pna01',l_pmm.pmm01,'pna02',l_pna02+1,'pna04',g_today,'pna05','N','','','','')   
                    LET g_show_msg[g_err_cnt].fld04 = g_msg
                 ELSE
                    INITIALIZE l_pnb.* TO NULL
                    LET l_pnb.pnb01  = l_pmm.pmm01
                    LET l_pnb.pnb02  = l_pna02 + 1
                    LET l_pnb.pnb03  = 1
                    LET l_pnb.pnb04b = l_pmn.pmn04 
                    LET l_pnb.pnb07b = l_pmn.pmn07
                    LET l_pnb.pnb20b = l_pmn.pmn20 
                    LET l_pnb.pnb83b = l_pmn.pmn83 
                    LET l_pnb.pnb84b = l_pmn.pmn84
                    LET l_pnb.pnb85b = l_pmn.pmn85
                    LET l_pnb.pnb80b = l_pmn.pmn80
                    LET l_pnb.pnb81b = l_pmn.pmn81
                    LET l_pnb.pnb82b = l_pmn.pmn82
                    LET l_pnb.pnb86b = l_pmn.pmn86
                    LET l_pnb.pnb87b = l_pmn.pmn87
                    LET l_pnb.pnb31b = l_pmn.pmn31 
                    LET l_pnb.pnb32b = l_pmn.pmn31t
                    LET l_pnb.pnb33b = l_pmn.pmn33   
                    LET l_pnb.pnb33a = l_vod.vod10
                    LET l_pnb.pnb041b= l_pmn.pmn041
                    LET l_pnb.pnbplant = g_plant #FUN-B50020 add所屬營運中心
                    LET l_pnb.pnblegal = g_legal #FUN-B50020 add 所屬法人
                    INSERT INTO pnb_file VALUES(l_pnb.*)
                    IF SQLCA.sqlcode THEN
                       LET g_success = 'N'
                       LET g_err_cnt = g_err_cnt + 1
                       LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
                       LET g_show_msg[g_err_cnt].fld02 = g_status1
                       LET g_show_msg[g_err_cnt].fld03 = 'INSERT INTO pnb_file Error !'
                       CALL t821_getmsg('pnb01',l_pmm.pmm01,'pnb02',l_pna02+1,'pnb33',1,'pnb33a',l_vod.vod10,'','','','')   
                       LET g_show_msg[g_err_cnt].fld04 = g_msg
                    END IF
                 END IF
             END IF

        #已確認及簽核中單據,不更新
        WHEN l_pmm.pmm25 = '1' OR l_pmm.pmm25 = 'S'
           LET g_success = 'N'
           LET g_err_cnt = g_err_cnt + 1
           LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
           LET g_show_msg[g_err_cnt].fld02 = g_status1
           CALL cl_getmsg('aps-798',g_lang) RETURNING g_show_msg[g_err_cnt].fld03
           CALL t821_getmsg('pmm01',l_pmm.pmm01,'pmm25',l_pmm.pmm25,'','','','','','','','')   
           LET g_show_msg[g_err_cnt].fld04 = g_msg
     END CASE
  END IF

  ##變更製令外包檔 vnf_file
  IF (hstatus = 'A' OR hstatus = 'B') AND g_success = 'Y' THEN
      INITIALIZE l_voh.* LIKE voh_file.*
      INITIALIZE l_voo.* LIKE voo_file.*
      INITIALIZE l_vnf.* LIKE vnf_file.*       
      SELECT * INTO l_voh.*
        FROM voh_file
       WHERE voh00 = l_vod.vod00
         AND voh01 = l_vod.vod01
         AND voh02 = l_vod.vod02
         AND voh03 = l_vod.vod05
      IF l_voh.voh07 = '9' THEN #9:外包時間類型變更
         SELECT voo_file.* 
           INTO l_voo.*
           FROM voo_file
          WHERE voo00=l_vod.vod00
            AND voo01=l_vod.vod01
            AND voo02=l_vod.vod02
            AND voo03=l_vod.vod05
         SELECT * INTO l_vnf.*
           FROM vnf_file
          WHERE vnf01 = l_voo.voo03
         IF NOT cl_null(l_vnf.vnf01) THEN
            UPDATE vnf_file
               SET vnf03 = l_voo.voo05,
                   vnf07 = l_voo.voo09
             WHERE vnf01 = l_voo.voo03
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                LET g_success = 'N'
                LET g_err_cnt = g_err_cnt + 1
                LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
                LET g_show_msg[g_err_cnt].fld02 = g_status1
                LET g_show_msg[g_err_cnt].fld03 = 'UPDATE vnf03,vnf07 Error !'
                CALL t821_getmsg('vnf01',l_voo.voo03,'','','','','','','','','','')   
                LET g_show_msg[g_err_cnt].fld04 = g_msg
            END IF
         ELSE
            INSERT INTO vnf_file(vnf01,vnf03,vnf07,vnflegal,vnfplant)      #FUN-B50020 add legal,plant
             VALUES(l_voo.voo03,l_voo.voo05,l_voo.voo09,g_legal,g_plant)   #FUN-B50020 add legal,plant
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                LET g_success = 'N'
                LET g_err_cnt = g_err_cnt + 1
                LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
                LET g_show_msg[g_err_cnt].fld02 = g_status1
                LET g_show_msg[g_err_cnt].fld03 = 'INSERT INTO vnf_file Error !'
                CALL t821_getmsg('vnf01',l_voo.voo03,'vnf03',l_voo.voo05,'vnf07',l_voo.voo09,'','','','','','')   
                LET g_show_msg[g_err_cnt].fld04 = g_msg
            END IF
         END IF 
         IF g_success = 'Y' THEN 
             IF l_voo.voo05 = '2' THEN #2:固定開始結束時間
                 LET l_sfb41 = 'Y'     #凍結碼
             ELSE                      #1:固定期間
                 LET l_sfb41 = 'N'     #凍結碼
             END IF
             UPDATE sfb_file
                SET sfb41 = l_sfb41
              WHERE sfb01 = l_sfb.sfb01
             IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                LET g_err_cnt = g_err_cnt + 1
                LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
                LET g_show_msg[g_err_cnt].fld02 = g_status1
                LET g_show_msg[g_err_cnt].fld03 = 'UPDATE sfb41 Error !'
                CALL t821_getmsg('sfb01',l_sfb.sfb01,'','','','','','','','','','')   
                LET g_show_msg[g_err_cnt].fld04 = g_msg
             END IF
         END IF
      END IF      
  END IF

  ##變更製程外包檔
  IF (hstatus = 'A' OR hstatus='B') AND g_success = 'Y' THEN
     INITIALIZE l_voi.* LIKE voi_file.*
     INITIALIZE l_vop.* LIKE vop_file.*
     INITIALIZE l_vom.* LIKE vom_file.*
     INITIALIZE l_vnd.* LIKE vnd_file.* 
     LET l_sfe16 = 0
 
     SELECT COUNT(*) INTO l_sfe16
       FROM sfe_file
      WHERE sfe01 = l_sfb.sfb01
        AND sfe16 > 0

     LET g_sql = " SELECT  vof_file.*, voi_file.*, ecm_file.*  ",
                 " FROM  vof_file,voi_file,ecm_file ",
                 " WHERE  vof00='",l_vod.vod00,"'",
                 "   AND  vof01='",l_vod.vod01,"'",
                 "   AND  vof02='",l_vod.vod02,"'",
                 "   AND  vof03='",l_vod.vod03,"'",
                 "   AND  vof00=voi00 ",
                 "   AND  vof01=voi01 ",
                 "   AND  vof02=voi02 ",
                 "   AND  vof03=voi03 ",
                 "   AND  vof04=voi04 ",
                 "   AND  vof05=voi05 ",
                 "   AND  vof03=ecm01 ",
                 "   AND  vof05=ecm03 "
     PREPARE t821_sub_p FROM g_sql
     DECLARE t821_sub_c SCROLL CURSOR WITH HOLD FOR t821_sub_p
     FOREACH t821_sub_c INTO l_vof.*,l_voi.*, l_ecm.*
       IF STATUS THEN
          LET g_success = 'N'
          LET g_err_cnt = g_err_cnt + 1
          LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
          LET g_show_msg[g_err_cnt].fld02 = g_status1
          LET g_show_msg[g_err_cnt].fld03 = 'FOREACH t821_sub_c Error!'
          EXIT FOREACH
       END IF
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt
         FROM pmn_file
        WHERE pmn41=l_ecm.ecm01
          AND pmn46=l_ecm.ecm03

       IF l_ecm.ecm52='Y' AND (l_cnt>0 ) THEN
          LET g_success = 'N'
          LET g_err_cnt = g_err_cnt + 1
          LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
          LET g_show_msg[g_err_cnt].fld02 = g_status1
          #製程外包且已開委外採購單，不變更
          CALL cl_getmsg('aps-799',g_lang) RETURNING g_show_msg[g_err_cnt].fld03
          CALL t821_getmsg('pmn41',l_ecm.ecm01,'pmn46',l_ecm.ecm03,'','','','','','','','')   
          LET g_show_msg[g_err_cnt].fld04 = g_msg
          EXIT FOREACH
       ELSE
          IF l_voi.voi10='0' AND l_voi.voi08='1' AND 
             (cl_null(l_sfe16) OR l_sfe16=0) THEN #工單未發料前
             UPDATE ecm_file
                SET ecm50 = l_vof.vof08,
                    ecm51 = l_vof.vof09
              WHERE ecm01 = l_ecm.ecm01
                AND ecm03 = l_ecm.ecm03
             IF SQLCA.sqlcode THEN
                LET g_success = 'N'
                LET g_err_cnt = g_err_cnt + 1
                LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
                LET g_show_msg[g_err_cnt].fld02 = g_status1
                LET g_show_msg[g_err_cnt].fld03 = 'UPDATE ecm50,ecm51 Error !'
                CALL t821_getmsg('ecm01',l_ecm.ecm01,'ecm03',l_ecm.ecm03,'','','','','','','','')   
                LET g_show_msg[g_err_cnt].fld04 = g_msg
                EXIT FOREACH
             END IF
          END IF
       END IF  
     END FOREACH
  END IF

END FUNCTION

FUNCTION t821_getmsg(p_feld1,p_feld2,p_feld3,p_feld4,p_feld5,p_feld6,p_feld7,p_feld8,p_feld9,p_feld10,p_feld11,p_feld12)
  DEFINE p_feld1,p_feld3,p_feld5,p_feld7,p_feld9,p_feld11   LIKE  gaq_file.gaq01
  DEFINE p_feld2,p_feld4,p_feld6,p_feld8,p_feld10,p_feld12  LIKE  gaq_file.gaq03
  DEFINE l_feld1,l_feld3,l_feld5,l_feld7,l_feld9,l_feld11   LIKE  gaq_file.gaq03
  LET  l_feld1=NULL   LET  l_feld3=NULL  LET  l_feld5=NULL  
  LET  l_feld7=NULL   LET  l_feld9=NULL  LET  l_feld11=NULL
  CALL cl_get_feldname(p_feld1,g_lang) RETURNING l_feld1
  CALL cl_get_feldname(p_feld3,g_lang) RETURNING l_feld3
  CALL cl_get_feldname(p_feld5,g_lang) RETURNING l_feld5
  CALL cl_get_feldname(p_feld7,g_lang) RETURNING l_feld7
  CALL cl_get_feldname(p_feld9,g_lang) RETURNING l_feld9
  CALL cl_get_feldname(p_feld11,g_lang) RETURNING l_feld11
  LET g_msg = l_feld1 CLIPPED,':',p_feld2 CLIPPED
  IF NOT cl_null(l_feld3)  THEN
     LET g_msg = g_msg,' + ',l_feld3 CLIPPED,':',p_feld4  CLIPPED
  END IF
  IF NOT cl_null(l_feld5)  THEN
     LET g_msg = g_msg,' + ',l_feld5 CLIPPED,':',p_feld6  CLIPPED
  END IF
  IF NOT cl_null(l_feld7)  THEN
     LET g_msg = g_msg,' + ',l_feld7 CLIPPED,':',p_feld8  CLIPPED
  END IF
  IF NOT cl_null(l_feld9)  THEN
     LET g_msg = g_msg,' + ',l_feld9 CLIPPED,':',p_feld10  CLIPPED
  END IF
  IF NOT cl_null(l_feld11) THEN
     LET g_msg = g_msg,' + ',l_feld11 CLIPPED,':',p_feld12  CLIPPED
  END IF

END FUNCTION

FUNCTION t821_show_msg()
  CALL cl_getmsg('apm-574',g_lang) RETURNING g_msg
  CALL cl_get_feldname('sfb01',g_lang) RETURNING g_fld01
  CALL cl_get_feldname('azo06',g_lang) RETURNING g_fld02
  CALL cl_get_feldname('fbh05',g_lang) RETURNING g_fld03
  CALL cl_get_feldname('aab03',g_lang) RETURNING g_fld04
  LET g_msg2 = g_fld01 CLIPPED,'|',g_fld02 CLIPPED,'|',
               g_fld03 CLIPPED,'|',g_fld04 CLIPPED
  CALL cl_show_array(base.TypeInfo.create(g_show_msg),g_msg,g_msg2)
END FUNCTION

#FUN-B80122---add----str---
FUNCTION t821_b()
   DEFINE   l_ac_t           LIKE type_file.num5,       #未取消的ARRAY CNT                          
            l_n              LIKE type_file.num5,       #檢查重複用                                
            l_lock_sw        LIKE type_file.chr1,       #單身鎖住否                               
            p_cmd            LIKE type_file.chr1,       #處理狀態                                 
            l_allow_insert   LIKE type_file.num5,       #可新增否                                  
            l_allow_delete   LIKE type_file.num5,       #可刪除否                                  
            ls_cnt           LIKE type_file.num5      

   LET g_action_choice = ""

   IF g_vod01 IS NULL AND g_vod02 IS NULL THEN
      RETURN
   END IF
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   CALL cl_opmsg('b')

   LET g_forupd_sql =
                     "SELECT vod37 ",
                     "  FROM vod_file    ",
                     " WHERE vod00=? AND vod01=? AND vod02=? AND vod03=? FOR UPDATE "

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)    #FUN-B80122
   DECLARE t821_b_curl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY g_vod WITHOUT DEFAULTS FROM s_vod.*
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

         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET g_vod_t.* = g_vod[l_ac].*  #BACKUP
            LET p_cmd='u'
            OPEN t821_b_curl USING g_plant,g_vod01,g_vod02,g_vod[l_ac].vod03 
            IF STATUS THEN
               CALL cl_err("OPEN t821_b_cur1:",STATUS,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t821_b_curl INTO g_vod[l_ac].vod37_1
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_vod_t.vod37_1,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()                      
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_vod[l_ac].* = g_vod_t.*
            CLOSE t821_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_vod[l_ac].vod37_1,-263,1)
            LET g_vod[l_ac].* = g_vod_t.*
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_vod[l_ac].* = g_vod_t.*
            END IF
            CLOSE t821_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE t821_b_curl
         COMMIT WORK

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about                    
         CALL cl_about()                 
 
      ON ACTION help                     
         CALL cl_show_help()             
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","YES")                                                                                        

   END INPUT

   CLOSE t821_b_curl
   COMMIT WORK
 
END FUNCTION

#單身段挑選處理
FUNCTION t821_pick(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,       #決定全選("A",表示全選)或全不選("E",表示全不選)
       l_i        LIKE type_file.num5,
       l_max_b    LIKE type_file.num5
   LET l_max_b = g_rec_b
   CASE p_cmd
      WHEN 'A'
         FOR l_i = 1 TO l_max_b
            LET g_vod[l_i].vod37_1 = 'Y'
         END FOR
      WHEN 'E'
         FOR l_i = 1 TO l_max_b
            LET g_vod[l_i].vod37_1 = 'N'
         END FOR
      OTHERWISE EXIT CASE
   END CASE
   RETURN false
END FUNCTION
#FUN-B80122---add----end---
#FUN-B50020 
