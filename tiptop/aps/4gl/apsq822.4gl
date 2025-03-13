# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: apsq822.4gl
# Descriptions...: APS建議現況查詢作業-工單
# Date & Author..: #FUN-960168 10/01/04 By Lilan
# Modify.........: #FUN-A10134 10/01/27 By Mandy 增加 預計開工時間和預計完工時間
# Modify.........: No.FUN-B50050 11/05/12 By Mandy---GP5.25 追版:---------------------end--

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_vod01         LIKE vod_file.vod01,          #FUN-960168
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
        voh07            LIKE voh_file.voh07,     #APS變更碼(voh07):    0：無變更﹔1：廠內工單轉外包﹔2：外包工單轉廠內工單﹔3：委外工單供應商變更﹔4：工單作業轉外包作業﹔5：委外作業轉廠內作業﹔6：委外作業供應商變更﹔7：工單製程變更﹔8：作業編號變更
        isoutsource      LIKE type_file.chr1,     #建議委外否 
        vod05            LIKE vod_file.vod05,     #工單號碼
        issue            LIKE type_file.chr1,     #
        sfb04            LIKE sfb_file.sfb04,     #
        vod09            LIKE vod_file.vod09,     #料號
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
        tm  RECORD  
            wc      LIKE type_file.chr1000,       #單頭CONSTRUCT結果
            wc2     LIKE type_file.chr1000        #單身CONSTRUCT結果
            END RECORD,
    g_rec_b         LIKE type_file.num5,          #單身筆數
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000,
    g_t1            LIKE type_file.chr5,
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT

#主程式開始
DEFINE  p_row,p_col          LIKE type_file.num5
DEFINE  l_action_flag        STRING
DEFINE  g_forupd_sql         STRING                   #SELECT ... FOR UPDATE NOWAIT NOWAIT SQL
DEFINE  g_before_input_done  LIKE type_file.num5
DEFINE  g_cnt                LIKE type_file.num10
DEFINE  g_msg                LIKE ze_file.ze03
DEFINE  g_msg2               LIKE ze_file.ze03 
DEFINE  lc_qbe_sn            LIKE gbm_file.gbm01      
DEFINE  g_row_count          LIKE type_file.num10
DEFINE  g_curs_index         LIKE type_file.num10
DEFINE  g_jump               LIKE type_file.num10
DEFINE  mi_no_ask            LIKE type_file.num5
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
    #FUN-B50050---mod---str---
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
    #FUN-B50050---mod---end---

    LET g_vod01   = NULL                #清除鍵值
    LET g_vod02   = NULL                #清除鍵值

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time


    LET p_row = 4 LET p_col = 5

    OPEN WINDOW q822_w AT 2,2 WITH FORM "aps/42f/apsq822"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()

    CALL cl_set_comp_visible("vod05_1, vod09_1",FALSE)
    CALL cl_set_comp_visible("vod03",FALSE)

   #CALL q822_q()

   #lock 是否委外,有無製程
   #CALL cl_set_comp_entry("status,sfb04,vod09,chang,vod10,vod35,qty,gen_po,isoutsource,vod39",FALSE)

    CALL q822_menu()

    CLOSE WINDOW q822_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN


#QBE 查詢資料
FUNCTION q822_cs()
   DEFINE l_vzy01   LIKE vzy_file.vzy01  
   DEFINE l_vzy02   LIKE vzy_file.vzy02 
   DEFINE l_type    LIKE type_file.chr2

   CLEAR FORM                             #清除畫面
   CALL g_vod.clear()
   CALL cl_set_head_visible("","YES")     #單頭區塊隱藏功能,配合畫面檔

   INITIALIZE g_vod01 TO NULL
   INITIALIZE g_vod02 TO NULL

   CONSTRUCT BY NAME tm.wc ON vod01,vod02,vod37     
       BEFORE CONSTRUCT
          CALL cl_qbe_init()

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

   CALL q822_b_askkey()

   IF INT_FLAG THEN
      RETURN
   END IF

   LET g_sql = "SELECT UNIQUE vod01,vod02 ",
               "  FROM vod_file,voh_file,sfb_file",
               " WHERE vod00 ='",g_plant,"'", 
               "   AND vod01 = voh01 AND vod02=voh02 AND vod03=voh03 ",
               "   AND vod05 = sfb01",
               "   AND vod08 = '0' ",
               "   AND (voh04<>'0' or voh05<>'0') AND  voh07 in ('0','9') "

   IF tm.wc2 = " 1=1 " THEN
      LET g_sql = g_sql ,
                  "   AND ",tm.wc CLIPPED,
                  " ORDER BY vod01,vod02"
   ELSE
      LET g_sql = g_sql ,
                 "   AND ",tm.wc CLIPPED,
                 "   AND ",tm.wc2 CLIPPED,
                 " ORDER BY vod01,vod02"
   END IF

   PREPARE q822_prepare FROM g_sql
   DECLARE q822_cs SCROLL CURSOR WITH HOLD FOR q822_prepare

   LET g_sql = " SELECT UNIQUE vod01,vod02 ",
               " FROM vod_file,voh_file,sfb_file",
               " WHERE vod00 ='",g_plant,"'",
               "   AND vod01 =voh01 AND vod02=voh02 AND vod03=voh03 ",
               "   AND vod05=sfb01",
               "   AND vod08='0' "

   LET g_sql = g_sql,
               "   AND (voh04<>'0' or voh05<>'0') AND  voh07 in ('0','9') ",
               "   AND ",tm.wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "  INTO TEMP x "
   DROP TABLE x          
   PREPARE q822_precount_x FROM g_sql
   EXECUTE q822_precount_x
        
   LET g_sql="SELECT COUNT(*) FROM x "

   PREPARE q822_precount FROM g_sql
   DECLARE q822_count CURSOR FOR q822_precount
END FUNCTION

FUNCTION q822_menu()

   WHILE TRUE
      CALL q822_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q822_q()
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         #工單明細表
         WHEN "wo_detail"  
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF cl_chk_act_auth() THEN                             
                  IF g_rec_b > 0 AND l_ac > 0 THEN
                  LET g_msg = " asfi301 '", g_vod[l_ac].vod05,"'"
                  CALL cl_cmdrun_wait(g_msg CLIPPED)                     
                  END IF
               END IF
            END IF

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vod),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION


FUNCTION q822_q()
   LET g_row_count = 0
   LET g_curs_index = 0

   CALL cl_navigator_setting(g_curs_index, g_row_count)

   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_vod.clear()
   DISPLAY '   ' TO FORMONLY.cnt

   CALL q822_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

   MESSAGE " SEARCHING ! "

   OPEN q822_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL g_vod.clear()
      INITIALIZE g_vod01 TO NULL
      INITIALIZE g_vod02 TO NULL
   ELSE
      OPEN q822_count
      FETCH q822_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q822_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF

   MESSAGE ""
END FUNCTION


#處理資料的讀取
FUNCTION q822_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        

   CASE p_flag
      WHEN 'N' FETCH NEXT     q822_cs INTO g_vod01,g_vod02
      WHEN 'P' FETCH PREVIOUS q822_cs INTO g_vod01,g_vod02
      WHEN 'F' FETCH FIRST    q822_cs INTO g_vod01,g_vod02
      WHEN 'L' FETCH LAST     q822_cs INTO g_vod01,g_vod02
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
         FETCH ABSOLUTE g_jump q822_cs INTO g_vod01,g_vod02
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
   SELECT UNIQUE vod01,vod02 INTO g_vod01,g_vod02 
     FROM vod_file 
    WHERE vod01 = g_vod01 
      AND vod02 = g_vod02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","vod_file",g_vod01,g_vod02,SQLCA.sqlcode,"","",1)
      INITIALIZE g_vod01 TO NULL
      INITIALIZE g_vod02 TO NULL
      CALL g_vod.clear()
      RETURN
   END IF
   CALL q822_show()
END FUNCTION


#將資料顯示在畫面上
FUNCTION q822_show()
   DISPLAY g_vod01 TO FORMONLY.vod01
   DISPLAY g_vod02 TO FORMONLY.vod02
   DISPLAY g_vod37 TO FORMONLY.vod37

   LET g_vod01_t = g_vod01
   LET g_vod02_t = g_vod02
   LET g_vod37_t = g_vod37

   CALL q822_b_fill("1=1")    #單身
   CALL cl_show_fld_cont()
END FUNCTION


FUNCTION q822_b_fill(p_wc1)
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
   LET g_sql = "SELECT case when vod37 is null then 'N' else vod37 end vod37,voh07, ",
               "       case when voo03 is null then 'N' else 'Y' end isoutsource, vod05,",
               "       '', sfb04,vod09,ima02,'',",          
              #"       sfb13,vod11,sfb15,vod10, ",            #FUN-A10134 mark
               "       sfb13,sfb14,vod11,sfb15,sfb16,vod10, ",#FUN-A10134 add
               "       sfb08,vod35,vod35-sfb08, ", 
               "       vod34,",
               "       vod39,sfb87,vod20,'','N',sfb09,sfb081,vod03  ", 
               "  FROM vod_file,voh_file,sfb_file,OUTER voo_file,OUTER ima_file ",
               " WHERE vod00 ='",g_plant,"'", 
               "   AND vod01 ='",g_vod01,"'",
               "   AND vod02 ='",g_vod02,"'",
               "   AND vod00 = voo_file.voo00 ",
               "   AND vod01 = voo_file.voo01 ",
               "   AND vod02 = voo_file.voo02 ",
               "   AND vod03 = voo_file.voo03 ",
               "   AND vod09 = ima_file.ima01 ",
               "   AND vod01 = voh01 ",
               "   AND vod02 = voh02 ",
               "   AND vod03 = voh03 ",
               "   AND vod05 = sfb01",
               "   AND vod08 = '0' ",
               "   AND sfb08 <> sfb09 ",
               "   AND sfb04 <> '8' ",
               "   AND (voh04 <> '0' OR voh05 <> '0') ",    #voh04:是否數量變更 voh05:是否日期變更
               "   AND voh07 IN ('0','9') ",                #變更碼=>'0':無變更 '9':外包時間類型變更
               "   AND ",tm.wc CLIPPED, 
               "   AND ",tm.wc2 CLIPPED 

   LET g_sql = g_sql, " ORDER BY vod01,vod02,vod05 "

   PREPARE q822_pb1 FROM g_sql
   DECLARE vod_curs1 CURSOR FOR q822_pb1

   CALL g_vod.clear()
   LET g_cnt= 1
   FOREACH vod_curs1 INTO g_vod[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

      #==>發料否
      SELECT COUNT(*) 
        INTO l_cnt
        FROM sfe_file
       WHERE sfe01 = g_vod[g_cnt].vod05
         AND sfe16 > 0
      IF l_cnt > 0 THEN
         LET g_vod[g_cnt].issue = 'Y'
      ELSE
         LET g_vod[g_cnt].issue = 'N'
      END IF

      #==>已產生委外PO否
      SELECT COUNT(*) INTO l_cnt
        FROM pmn_file
       WHERE pmn41 = g_vod[g_cnt].vod05
      IF l_cnt > 0 THEN
         LET g_vod[g_cnt].gen_po = 'Y'
      END IF

      #==>產生變更單
      SELECT COUNT(*) INTO l_gen 
        FROM snb_file
       WHERE snb01 = g_vod[g_cnt].vod05
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
         AND vod05 = g_vod[g_cnt].vod05
         AND vod09 = g_vod[g_cnt].vod09

      SELECT sfb08,sfb15,sfb09,sfb12 
        INTO l_sfb08,l_sfb15,l_sfb09,l_sfb12
        FROM sfb_file
       WHERE sfb01=g_vod[g_cnt].vod05
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


FUNCTION q822_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_vod TO s_vod.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_set_act_visible("wo_detail",TRUE)           

      BEFORE ROW
         LET l_ac = ARR_CURR()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL q822_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY

      ON ACTION previous
         CALL q822_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY

      ON ACTION jump
         CALL q822_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY

      ON ACTION next
         CALL q822_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
           END IF
         EXIT DISPLAY

      ON ACTION last
         CALL q822_fetch('L')
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

      #工單明細
      ON ACTION wo_detail   
         LET g_action_choice = "wo_detail"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


#單身段挑選處理
FUNCTION q822_pick(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,       #決定全選("A",表示全選)或全不選("E",表示全不選)
       l_i        LIKE type_file.num5,
       l_max_b    LIKE type_file.num5
   LET l_max_b = g_rec_b
   CASE p_cmd
      WHEN 'A'
         FOR l_i = 1 TO l_max_b
            LET g_vod[l_i].vod37_1 = 'Y'
            UPDATE vod_file SET vod37 = g_vod[l_i].vod37_1
             WHERE vod00=g_plant 
               AND vod01=g_vod01
               AND vod02=g_vod02
               AND vod03=g_vod[l_i].vod03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","vod_file",g_vod01,g_vod02,SQLCA.sqlcode,"","",1)
            END IF
         END FOR
      WHEN 'E'
         FOR l_i = 1 TO l_max_b
            LET g_vod[l_i].vod37_1 = 'N'
            UPDATE vod_file SET vod37 = g_vod[l_i].vod37_1
             WHERE vod00=g_plant 
               AND vod01=g_vod01
               AND vod02=g_vod02
               AND vod03=g_vod[l_i].vod03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","vod_file",g_vod01,g_vod02,SQLCA.sqlcode,"","",1)
            END IF
         END FOR
      OTHERWISE EXIT CASE
   END CASE
   RETURN false
END FUNCTION


FUNCTION q822_getmsg(p_feld1,p_feld2,p_feld3,p_feld4,p_feld5,p_feld6,p_feld7,p_feld8,p_feld9,p_feld10,p_feld11,p_feld12)
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

FUNCTION q822_show_msg()
  CALL cl_getmsg('apm-574',g_lang) RETURNING g_msg
  CALL cl_get_feldname('sfb01',g_lang) RETURNING g_fld01
  CALL cl_get_feldname('azo06',g_lang) RETURNING g_fld02
  CALL cl_get_feldname('fbh05',g_lang) RETURNING g_fld03
  CALL cl_get_feldname('aab03',g_lang) RETURNING g_fld04
  LET g_msg2 = g_fld01 CLIPPED,'|',g_fld02 CLIPPED,'|',
               g_fld03 CLIPPED,'|',g_fld04 CLIPPED
  CALL cl_show_array(base.TypeInfo.create(g_show_msg),g_msg,g_msg2)
END FUNCTION


FUNCTION q822_b_askkey()
   CONSTRUCT tm.wc2 ON voh07,vod05,vod09,vod11,vod10,vod35,vod39,vod20
                  FROM s_vod[1].voh07,s_vod[1].vod05,s_vod[1].vod09,s_vod[1].vod11,
                       s_vod[1].vod10,s_vod[1].vod35,s_vod[1].vod39,s_vod[1].vod20
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(vod05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_vod05"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO vod05
                 NEXT FIELD vod05

             WHEN INFIELD(vod09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_ima"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO vod09
                 NEXT FIELD vod09

             OTHERWISE
                   EXIT CASE
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
END FUNCTION
#FUN-B50050
