# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: cxmt520.4gl
# Descriptions...: 產品價格維護作業
# Date & Author..: 16/06/12 By huanglf
# Modify.........: 160613 16/06/13 By guanyao录入退出的时候报错，审核不能录入
# Modify.........: 160614 16/06/14 By guanyao审核的时候生成产品价格，如果有数据，单身的数据是当天的额是则更新，如果不是则新增，没有取消审核
# Modify.........: 160715 16/07/15 By guanyao增加税前单价

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_tc_xme        RECORD LIKE tc_xme_file.*,  #NO.FUN-9b0016
    g_tc_xme_t      RECORD LIKE tc_xme_file.*,
    g_tc_xme_o         RECORD LIKE tc_xme_file.*,
    g_tc_xme00_t       LIKE tc_xme_file.tc_xme00,
    g_tc_xmf           DYNAMIC ARRAY OF RECORD
        tc_xmf01       LIKE tc_xmf_file.tc_xmf01,
        tc_xmf03       LIKE tc_xmf_file.tc_xmf03, 
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        tc_xmf04       LIKE tc_xmf_file.tc_xmf04, 
        tc_xmf05       LIKE tc_xmf_file.tc_xmf05,
        tc_xmf06       LIKE tc_xmf_file.tc_xmf06,   #add by guanyao160715
        tc_xmf07       LIKE tc_xmf_file.tc_xmf07,   #add by huanglf170317
        tc_xmf08       LIKE tc_xmf_file.tc_xmf08,   #add by huanglf170317
        tc_xmf10       LIKE tc_xmf_file.tc_xmf10,   #add by huanglf170405
        tc_xmf09       LIKE tc_xmf_file.tc_xmf09    #add by huanglf170317
        ,tc_xmf11     LIKE tc_xmf_file.tc_xmf11 #darcy:2023/04/06 add
                    END RECORD,
    g_tc_xmf_o         RECORD
        tc_xmf01       LIKE tc_xmf_file.tc_xmf01,
        tc_xmf03       LIKE tc_xmf_file.tc_xmf03, 
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        tc_xmf04       LIKE tc_xmf_file.tc_xmf04, 
        tc_xmf05       LIKE tc_xmf_file.tc_xmf05,
        tc_xmf06       LIKE tc_xmf_file.tc_xmf06,   #add by guanyao160715
        tc_xmf07       LIKE tc_xmf_file.tc_xmf07,   #add by huanglf170317
        tc_xmf08       LIKE tc_xmf_file.tc_xmf08,   #add by huanglf170317
        tc_xmf10       LIKE tc_xmf_file.tc_xmf10,   #add by huanglf170405
        tc_xmf09       LIKE tc_xmf_file.tc_xmf09    #add by huanglf170317
        ,tc_xmf11     LIKE tc_xmf_file.tc_xmf11 #darcy:2023/04/06 add
                    END RECORD,
    g_tc_xmf_t         RECORD
        tc_xmf01       LIKE tc_xmf_file.tc_xmf01,
        tc_xmf03       LIKE tc_xmf_file.tc_xmf03, 
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        tc_xmf04       LIKE tc_xmf_file.tc_xmf04, 
        tc_xmf05       LIKE tc_xmf_file.tc_xmf05,
        tc_xmf06       LIKE tc_xmf_file.tc_xmf06,   #add by guanyao160715
        tc_xmf07       LIKE tc_xmf_file.tc_xmf07,   #add by huanglf170317
        tc_xmf08       LIKE tc_xmf_file.tc_xmf08,   #add by huanglf170317
        tc_xmf10       LIKE tc_xmf_file.tc_xmf10,   #add by huanglf170405
        tc_xmf09       LIKE tc_xmf_file.tc_xmf09    #add by huanglf170317
        ,tc_xmf11     LIKE tc_xmf_file.tc_xmf11 #darcy:2023/04/06 add
                    END RECORD,
   #g_wc,g_wc2,g_sql    LIKE type_file.chr1000,  #No.FUN-680137 VARCHAR(800)
    g_wc,g_wc2,g_sql    STRING,   #TQC-630166  
    g_wd                LIKE type_file.chr1,     #No.FUN-680137 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,         #單身筆數     #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT   #No.FUN-680137 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_oayslip    LIKE type_file.chr10
DEFINE g_chr  LIKE type_file.chr1
DEFINE g_chr2  LIKE type_file.chr1
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL   
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680137 SMALLINT
DEFINE   g_gec07         LIKE gec_file.gec07         #add by guanyao160715
DEFINE g_t1         LIKE oay_file.oayslip
 
MAIN
#   DEFINE l_time        LIKE type_file.chr8          #No.FUN-680137 VARCHAR(8) #NO.FUN-6A0094 
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)     #No.MOD-580088  HCN 20050818   #NO.FUN-6A0094
      RETURNING g_time                            #NO.FUN-6A0094 
 
   LET g_wd = " "
 
  #LET g_forupd_sql = "SELECT * FROM tc_xme_file WHERE tc_xme01=? AND tc_xme02=?  FOR UPDATE"    #FUN-9C0163 MARK
   LET g_forupd_sql = "SELECT * FROM tc_xme_file WHERE tc_xme00=?  FOR UPDATE"  #FUN-9C0163 ADD 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t520_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 3 LET p_col = 3
   OPEN WINDOW t520_w AT p_row,p_col
     WITH FORM "cxm/42f/cxmt520" ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   CALL t520_menu()
 
   CLOSE WINDOW t520_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094 
      RETURNING g_time                                  #NO.FUN-6A0094 
 
END MAIN
 
FUNCTION t520_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面

   CALL g_tc_xmf.clear()
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_tc_xme.* TO NULL      #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON tc_xme00,tc_xme01,tc_xme02,tc_xme03,tc_xme04,tc_xme06,tc_xmeconf,   #add tc_xme06 by guanyao160711
                             tc_xmeuser,tc_xmegrup,tc_xmemodu,tc_xmedate
                             ,tc_xmeoriu,tc_xmeorig    #TQC-B80198
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(tc_xme00)
#               CALL q_oah1(0,0,g_tc_xme.tc_xme01) RETURNING g_tc_xme.tc_xme01
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oqt"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tc_xme00
                NEXT FIELD tc_xme00
             WHEN INFIELD(tc_xme02)
#               CALL q_azi(0,0,g_tc_xme.tc_xme02) RETURNING g_tc_xme.tc_xme02
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azi"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO tc_xme02
                NEXT FIELD tc_xme02
             WHEN INFIELD(tc_xme03)
#               CALL q_oah1(0,0,g_tc_xme.tc_xme01) RETURNING g_tc_xme.tc_xme01
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ"
                LET g_qryparam.state = 'c'
                --CALL cl_create_qry() RETURNING g_qryparam.multiret
                --DISPLAY g_qryparam.multiret TO tc_xme03
                CALL cl_create_qry() RETURNING g_tc_xme.tc_xme03
                DISPLAY g_tc_xme.tc_xme03 TO tc_xme03
                CALL  t520_tc_xme03()
                NEXT FIELD tc_xme03
            #str-----add by guanyao160711
             WHEN INFIELD(tc_xme06)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gec"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_tc_xme.tc_xme06
                DISPLAY g_tc_xme.tc_xme06 TO tc_xme06
                NEXT FIELD tc_xme06
            #end-----add by guanyao160711
             OTHERWISE
               EXIT CASE
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF
 

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_xmeuser', 'tc_xmegrup')
   #End:FUN-980030
 
 
   CONSTRUCT g_wc2 ON tc_xmf01,tc_xmf03,tc_xmf04,tc_xmf05,tc_xmf06,tc_xmf07,tc_xmf08,tc_xmf10
           FROM s_tc_xmf[1].tc_xmf01,s_tc_xmf[1].tc_xmf03,
                s_tc_xmf[1].tc_xmf04,s_tc_xmf[1].tc_xmf05,
                s_tc_xmf[1].tc_xmf06,s_tc_xmf[1].tc_xmf07,   #add by guanyao160715
                s_tc_xmf[1].tc_xmf08,s_tc_xmf[1].tc_xmf10 #add by huanglf170405   #add by huanglf170317
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tc_xmf03)
               CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  
               RETURNING  g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_xmf03
               NEXT FIELD tc_xmf03
            WHEN INFIELD(tc_xmf04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe"
               LET g_qryparam.state = 'c'
               LET g_qryparam.default1 = g_tc_xmf[1].tc_xmf04
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_xmf04
               NEXT FIELD tc_xmf04
            OTHERWISE
               EXIT CASE
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      RETURN
   END IF


    IF g_wc2="1=1" THEN                  # 若单身未输入条件
      LET g_sql = "SELECT  tc_xme00 FROM tc_xme_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY tc_xme00"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE tc_xme_file.tc_xme00 ",
                  "  FROM tc_xme_file, tc_xmf_file ",
                  " WHERE tc_xme00 = tc_xmf00",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY tc_xme00"
   END IF
 

   PREPARE t520_prepare FROM g_sql
   IF STATUS THEN
      CALL cl_err('pre',STATUS,1)
   END IF
 
   DECLARE t520_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t520_prepare
  --LET g_sql="SELECT COUNT(*) FROM tc_xme_file WHERE ",g_wc CLIPPED
  --IF  g_wc2="1=1" THEN                  # 取合乎條件筆數
      --LET g_sql="SELECT COUNT(*) FROM tc_xme_file WHERE ",g_wc CLIPPED
   --ELSE
      --LET g_sql="SELECT COUNT(DISTINCT tc_xme001) FROM tc_xme_file,tc_dab_file WHERE ",
                --"tc_xme001=tc_dab001 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   --END IF
 
   IF g_wc2 = " 1=1" THEN
     #LET g_sql="SELECT COUNT(*) FROM tc_xme_file WHERE ",g_wc CLIPPED      #No.TQC-720019
      LET g_sql_tmp="SELECT DISTINCT tc_xme00 FROM tc_xme_file WHERE ",g_wc CLIPPED, 
                    "  INTO TEMP x "  #No.TQC-720019
   ELSE
    # LET g_sql="SELECT DISTINCT tc_xme00",      #No.TQC-720019
      LET g_sql_tmp="SELECT DISTINCT tc_xme00 ",  #No.TQC-720019
                "  FROM tc_xme_file,tc_xmf_file ",
                " WHERE tc_xme00=tc_xmf00 ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                "  INTO TEMP x "
   END IF
   #No.TQC-720019  --Begin
   DROP TABLE x
#  PREPARE t520_precount_x  FROM g_sql      #No.TQC-720019
   PREPARE t520_precount_x  FROM g_sql_tmp  #No.TQC-720019
   EXECUTE t520_precount_x
   LET g_sql="SELECT COUNT(*) FROM x "
   #No.TQC-720019  --End  
 
   PREPARE t520_precount FROM g_sql
   IF STATUS THEN
      CALL cl_err('pre',STATUS,1)
   END IF
 
   DECLARE t520_count CURSOR FOR t520_precount
 
END FUNCTION
 
FUNCTION t520_menu()
   WHILE TRUE
      CALL t520_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t520_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t520_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t520_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t520_u()
            END IF
    #------------------No.FUN-620009 add
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t520_copy()
            END IF
    #------------------No.FUN-620009 end
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t520_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t520_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_xmf),'','')
            END IF
         #No.FUN-6A0020-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_tc_xme.tc_xme00 IS NOT NULL THEN
                LET g_doc.column1 = "tc_xme00"
                LET g_doc.value1 = g_tc_xme.tc_xme00
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0020-------add--------end----
        WHEN "confirm"
           IF cl_chk_act_auth() THEN
             LET g_success = 'Y'
             #darcy:2023/04/04 mod s---
            #  CALL t520_y_chk()
             call t520sub_y_chk(g_tc_xme.tc_xme00)
             if g_success = 'Y' then
               call t520sub_y_upd(g_tc_xme.tc_xme00,false)
             end if
             #darcy:2023/04/04 mod e---
             SELECT * INTO g_tc_xme.* FROM tc_xme_file WHERE tc_xme00 = g_tc_xme.tc_xme00
             CALL t520_show()
           END IF
         #darcy:2023/03/27 add s---
         WHEN "easyflow_approval"
            IF cl_chk_act_auth() THEN
               SELECT * INTO g_tc_xme.* FROM tc_xme_file
                WHERE tc_xme00 = g_tc_xme.tc_xme00
               CALL t520_show()
               CALL t520_b_fill(' 1=1')
               CALL t520_ef()
               CALL t520_show()
            END IF
         #darcy:2023/03/27 add e---
        #str---mark by guanyao160614       
        # WHEN "undo_confirm"
        #   IF cl_chk_act_auth() THEN
        #     LET g_success = 'Y'
        #     CALL t520_z()
        #     SELECT * INTO g_tc_xme.* FROM tc_xme_file WHERE tc_xme00 = g_tc_xme.tc_xme00
        #     CALL t520_show()
        #   END IF
        #str---mark by guanyao160614
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t520_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_tc_xme.* TO NULL              #No.FUN-6A0020  
 
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   DISPLAY '   ' TO FORMONLY.cnt
   CALL g_tc_xmf.clear()
 
   CALL t520_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN t520_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tc_xme.* TO NULL
   ELSE
      OPEN t520_count
      FETCH t520_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t520_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t520_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t520_cs INTO 
                                           g_tc_xme.tc_xme00
      WHEN 'P' FETCH PREVIOUS t520_cs INTO 
                                           g_tc_xme.tc_xme00
      WHEN 'F' FETCH FIRST    t520_cs INTO 
                                           g_tc_xme.tc_xme00
      WHEN 'L' FETCH LAST     t520_cs INTO 
                                           g_tc_xme.tc_xme00
      WHEN '/'
         IF (NOT mi_no_ask) THEN
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
        FETCH ABSOLUTE g_jump t520_cs INTO 
                                           g_tc_xme.tc_xme00
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_xme.tc_xme00,SQLCA.sqlcode,0)
      INITIALIZE g_tc_xme.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_tc_xme.* FROM tc_xme_file WHERE tc_xme00 = g_tc_xme.tc_xme00
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_tc_xme.tc_xme01,SQLCA.sqlcode,0)   #No.FUN-660167
      CALL cl_err3("sel","tc_xme_file",g_tc_xme.tc_xme00,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
      INITIALIZE g_tc_xme.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_tc_xme.tc_xmeuser      #FUN-4C0057 add
   LET g_data_group = g_tc_xme.tc_xmegrup      #FUN-4C0057 add
 
   CALL t520_show()
 
END FUNCTION
 
FUNCTION t520_show()
   DEFINE l_oah02 LIKE oah_file.oah02
   DEFINE l_tc_xme03_desc LIKE occ_file.occ02
 
   LET g_tc_xme_t.* = g_tc_xme.*                      #保存單頭舊值
 
   SELECT oah02 INTO l_oah02 FROM oah_file WHERE oah01 = g_tc_xme.tc_xme01
   SELECT occ02 INTO l_tc_xme03_desc FROM occ_file WHERE occ01 = g_tc_xme.tc_xme03
   DISPLAY l_tc_xme03_desc TO tc_xme03_desc 
   DISPLAY BY NAME g_tc_xme.tc_xme00,g_tc_xme.tc_xme01,g_tc_xme.tc_xme02,g_tc_xme.tc_xme03,g_tc_xme.tc_xme04,g_tc_xme.tc_xmeconf,g_tc_xme.tc_xmeoriu,g_tc_xme.tc_xmeorig,
                   g_tc_xme.tc_xmeuser,g_tc_xme.tc_xmegrup,g_tc_xme.tc_xmemodu,g_tc_xme.tc_xmedate,g_tc_xme.tc_xme06
                   ,g_tc_xme.tc_xme07,g_tc_xme.tc_xmeacti #darcy:2023/04/04 add
   DISPLAY l_oah02 TO FORMONLY.oah02
   CALL  t520_tc_xme06()  #add by guanyao160711
   #str----add by guanyao160715
   LET g_gec07 = ''
   SELECT gec07 INTO g_gec07 FROM gec_file WHERE gec01 = g_tc_xme.tc_xme06
   #end----add by guanyao160715
#TQC-990067 --begin--
 IF cl_null(g_wc2) THEN 
    CALL t520_b_fill("1=1")
 ELSE
#TQC-990067 --end-- 	   
   CALL t520_b_fill(g_wc2)                 #單身
 END IF  #TQC-990067 
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
   CALL t520_pic()
 
END FUNCTION
 
FUNCTION t520_a()
   DEFINE li_result           LIKE type_file.num5
   DEFINE l_y,l_m             LIKE type_file.chr20
   DEFINE l_str,l_tmp         LIKE type_file.chr20
   IF s_shut(0) THEN RETURN END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_tc_xmf.clear()
   INITIALIZE g_tc_xme.* LIKE tc_xme_file.*             #DEFAULT 設定
   LET g_tc_xme00_t = NULL
   #預設值及將數值類變數清成零
   LET g_tc_xme_t.* = g_tc_xme.*
   LET g_tc_xme_o.* = g_tc_xme.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_tc_xme.tc_xmeuser=g_user
      LET g_tc_xme.tc_xmeoriu = g_user #FUN-980030
      LET g_tc_xme.tc_xmeorig = g_grup #FUN-980030
      LET g_tc_xme.tc_xmegrup=g_grup
      LET g_tc_xme.tc_xmedate=g_today
      LET g_tc_xme.tc_xmeconf='N'  #add by guanyao160613

      CALL t520_i("a")                   #輸入單頭
      #str----mark by guanyao160613
       #BEGIN WORK   #No:7829
       # CALL s_auto_assign_no("axm",g_tc_xme.tc_xme00,g_today,"10","tc_xme_file","tc_xme00","","","")  #No.FUN-A40041
       #   RETURNING li_result,g_tc_xme.tc_xme00
      #IF (NOT li_result) THEN
      #     ROLLBACK WORK
      #     CONTINUE WHILE
      #END IF
      #end----mark by guanyao160613
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      #str---add by guanyao160613
      BEGIN WORK   #No:7829

         #darcy:2023/04/04 mark s---
         # LET l_y =YEAR(g_today)
         # LET l_y = l_y USING '&&&&' 
         # LET l_y =l_y[3,4]
         # LET l_m =MONTH(g_today)
         # LET l_m = l_m USING '&&' 
         # LET l_str=l_y clipped,l_m CLIPPED
         # SELECT max(substr(tc_xme00,10,4)) INTO l_tmp FROM tc_xme_file
         # WHERE substr(tc_xme00,6,4)=l_str
         # IF cl_null(l_tmp) THEN 
         #    LET l_tmp = '0001' 
         # ELSE 
         #    LET l_tmp = l_tmp + 1
         #    LET l_tmp = l_tmp USING '&&&&'     
         # END IF 
         # LET g_tc_xme.tc_xme00 = 'SQ01-',l_str clipped,l_tmp
         #darcy:2023/04/04 add s---
         SELECT oayapr INTO g_tc_xme.tc_xme07
           FROM oay_file WHERE oayslip = g_tc_xme.tc_xme00
         if cl_null(g_tc_xme.tc_xme07) then
            let g_tc_xme.tc_xme07 = 'N'
         end if
         let g_tc_xme.tc_xmeacti = '0'
         #darcy:2023/04/04 add e---
         #darcy:2023/03/27 mark e---
         call s_auto_assign_no("axm",g_tc_xme.tc_xme00,g_today,"81","tc_xme_file","tc_xme00","","","")
                  returning li_result,g_tc_xme.tc_xme00
         if (not li_result) then
            rollback work
            continue while
         end if
         #darcy:2023/03/27 add s---



         DISPLAY BY NAME g_tc_xme.tc_xme00
      #str---add by guanyao160613
 
      IF cl_null(g_tc_xme.tc_xme00) THEN    # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      INSERT INTO tc_xme_file VALUES (g_tc_xme.*)
      IF SQLCA.sqlcode THEN                           #置入資料庫不成功
#        CALL cl_err(g_tc_xme.tc_xme01,SQLCA.sqlcode,1)   #No.FUN-660167
         CALL cl_err3("ins","tc_xme_file",g_tc_xme.tc_xme00,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
         CONTINUE WHILE
      END IF
 
      LET g_tc_xme_t.* = g_tc_xme.*
      CALL g_tc_xmf.clear()
      LET g_rec_b=0                   #No.FUN-680064
      CALL t520_b()                   #輸入單身
 
      SELECT tc_xme00 INTO g_tc_xme.tc_xme00 FROM tc_xme_file
       WHERE tc_xme00 = g_tc_xme.tc_xme00
      LET g_tc_xme00_t = g_tc_xme.tc_xme00        #保留舊值
    
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t520_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_oah02         LIKE oah_file.oah02,
          l_n,l_x         LIKE type_file.num5,
          l_cnt           LIKE type_file.num5             #No.FUN-680137 SMALLINT
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   #INPUT BY NAME g_tc_xme.tc_xme00,g_tc_xme.tc_xme01,g_tc_xme.tc_xme02,g_tc_xme.tc_xme03,g_tc_xme.tc_xme04,g_tc_xme.tc_xmeconf,g_tc_xme.tc_xmeoriu,g_tc_xme.tc_xmeorig,#mark by guanyao160613
   #INPUT BY NAME g_tc_xme.tc_xme00,g_tc_xme.tc_xme01,g_tc_xme.tc_xme02,g_tc_xme.tc_xme03,g_tc_xme.tc_xme04,g_tc_xme.tc_xmeoriu,g_tc_xme.tc_xmeorig,  #add by guanyao160613
   INPUT BY NAME g_tc_xme.tc_xme00,g_tc_xme.tc_xme01,g_tc_xme.tc_xme03,g_tc_xme.tc_xme02,g_tc_xme.tc_xme04,g_tc_xme.tc_xme06,g_tc_xme.tc_xmeoriu,g_tc_xme.tc_xmeorig,  #add by guanyao160613 #add tc_xme06 by guanyao160711
                 g_tc_xme.tc_xmeuser,g_tc_xme.tc_xmegrup,g_tc_xme.tc_xmedate
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
         if p_cmd = 'a' then #darcy:2023/04/24 add
            let g_tc_xme.tc_xme00 = 'TE2'
            let g_tc_xme.tc_xme01 = 'KHHJ'
         end if #darcy:2023/04/24 add
         display by name g_tc_xme.tc_xme00,g_tc_xme.tc_xme01
         LET g_before_input_done = FALSE
         CALL t520_set_entry(p_cmd)
         CALL t520_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         next field tc_xme03
    
      AFTER FIELD tc_xme01
         IF NOT cl_null(g_tc_xme.tc_xme01) THEN
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_tc_xme.tc_xme01 != g_tc_xme_t.tc_xme01) THEN
               SELECT oah02 INTO l_oah02 FROM oah_file
                WHERE oah01 = g_tc_xme.tc_xme01
               IF STATUS THEN
                  CALL cl_err3("sel","oah_file",g_tc_xme.tc_xme01,"","mfg4101","","",1)  #No.FUN-660167
                  NEXT FIELD tc_xme01
               END IF
               DISPLAY l_oah02 TO FORMONLY.oah02
            END IF
         END IF
      AFTER FIELD tc_xme02
         IF NOT cl_null(g_tc_xme.tc_xme02) THEN
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_tc_xme.tc_xme02 != g_tc_xme_t.tc_xme02) THEN
               SELECT azi01 FROM azi_file
                WHERE azi01 = g_tc_xme.tc_xme02
                  AND aziacti = 'Y' #MOD-530335
               IF STATUS THEN
#                 CALL cl_err(g_xme.xme02,'mfg3008',0)   #No.FUN-660167
                  CALL cl_err3("sel","azi_file",g_tc_xme.tc_xme02,"","mfg3008","","",1)  #No.FUN-660167
                  NEXT FIELD tc_xme02
               END IF
            END IF
         END IF
      AFTER FIELD tc_xme03
         IF NOT cl_null(g_tc_xme.tc_xme03) THEN
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_tc_xme.tc_xme03 != g_tc_xme_t.tc_xme03) THEN
              LET l_x = 0
              SELECT COUNT(*) INTO l_x FROM occ_file WHERE occ01 = g_tc_xme.tc_xme03
              IF cl_null(l_x) OR l_x = 0 THEN 
                 CALL cl_err(g_tc_xme.tc_xme03,'alm1625',0)
                 NEXT FIELD tc_xme03
              END IF  
             CALL t520_tc_xme03()
             END IF 
         END IF

    #str------add by guanyao160711
      AFTER FIELD tc_xme06
         IF NOT cl_null(g_tc_xme.tc_xme06) THEN 
            LET l_x = 0
            SELECT COUNT(*) INTO l_x FROM gec_file WHERE gec01 = g_tc_xme.tc_xme06 AND gec011 = '2'
            IF cl_null(l_x) OR l_x = 0 THEN 
               CALL cl_err(g_tc_xme.tc_xme06,'axr-089',0)
               NEXT FIELD tc_xme06
            END IF
            #str----add by guanyao160715
            LET g_gec07 = ''
            SELECT gec07 INTO g_gec07 FROM gec_file WHERE gec01 = g_tc_xme.tc_xme06
            #end----add by guanyao160715
         END IF 
     #end------add by guanyao160711
      
      ON ACTION CONTROLP
         CASE
          #WHEN INFIELD(tc_xme00) #查詢單別  hlf add
          #    LET g_oayslip=g_tc_xme.tc_xme00[1,g_doc_len]
          #    CALL q_oay(FALSE,TRUE,g_oayslip,'10','AXM') RETURNING g_oayslip #NO:    #TQC-670008
          #    LET g_tc_xme.tc_xme00= g_oayslip            #No.FUN-550070
          #    DISPLAY BY NAME g_tc_xme.tc_xme00
          #    NEXT FIELD tc_xme00
            WHEN INFIELD(tc_xme01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oah1"
               LET g_qryparam.default1 = g_tc_xme.tc_xme01
               CALL cl_create_qry() RETURNING g_tc_xme.tc_xme01
               DISPLAY BY name g_tc_xme.tc_xme01
               NEXT FIELD tc_xme01
            WHEN INFIELD(tc_xme02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_tc_xme.tc_xme02
               CALL cl_create_qry() RETURNING g_tc_xme.tc_xme02
               DISPLAY BY name g_tc_xme.tc_xme02
               NEXT FIELD tc_xme02
             WHEN INFIELD(tc_xme03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ"
               LET g_qryparam.default1 = g_tc_xme.tc_xme03
               CALL cl_create_qry() RETURNING g_tc_xme.tc_xme03
               DISPLAY BY name g_tc_xme.tc_xme03
               CALL t520_tc_xme03()                               #str—add by huanglf 160711
               NEXT FIELD tc_xme03
        #str-----add by guanyao160711
            WHEN INFIELD(tc_xme06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gec"
               LET g_qryparam.arg1 = '2'
               LET g_qryparam.default1 = g_tc_xme.tc_xme06
               CALL cl_create_qry() RETURNING g_tc_xme.tc_xme06
               DISPLAY BY name g_tc_xme.tc_xme06
               CALL t520_tc_xme06()                             
               NEXT FIELD tc_xme06
        #end-----add by guanyao160711
            #darcy:2023/04/04 add s---
            WHEN INFIELD(tc_xme00) #查詢單据
                 LET g_t1=s_get_doc_no(g_tc_xme.tc_xme00)
                 CALL q_oay(FALSE,FALSE,g_t1,'81','AXM') RETURNING g_t1  #FUN-610055
                 LET g_tc_xme.tc_xme00=g_t1
                 DISPLAY BY NAME g_tc_xme.tc_xme00
                 NEXT FIELD tc_xme00
            #darcy:2023/04/04 add e---
            OTHERWISE
               EXIT CASE
         END CASE
     
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
END FUNCTION
 
FUNCTION t520_u()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_tc_xme.tc_xme00 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   #str----add by guanyao160613
   IF g_tc_xme.tc_xmeconf = 'Y' THEN 
      CALL cl_err('','9022',0)
      RETURN 
   END IF
   #end----add by guanyao160613
   #darcy:2023/04/04 add s---
    # 只有开立中,退回状态可以修改
    select tc_xme07,tc_xmeacti into g_tc_xme.tc_xme07,g_tc_xme.tc_xmeacti from tc_xme_file where tc_xme00 = g_tc_xme.tc_xme00
    if g_tc_xme.tc_xme07='Y' and g_tc_xme.tc_xmeacti !='[0]' and g_tc_xme.tc_xmeacti != 'R'  then          #mod-4a0299
        call cl_err('','mfg3557',0)
        let g_success = 'N'
        return  #darcy:2023/04/24 add
    end if
    #darcy:2023/04/04 add e---
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tc_xme00_t = g_tc_xme.tc_xme00
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t520_cl USING g_tc_xme.tc_xme00
   IF STATUS THEN
      CALL cl_err("OPEN t520_cl:", STATUS, 1)
      CLOSE t520_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t520_cl INTO g_tc_xme.*                  # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_xme.tc_xme00,SQLCA.sqlcode,0)   # 資料被他人LOCK
      CLOSE t520_cl
      RETURN
   END IF
 
   CALL t520_show()
 
   WHILE TRUE
      LET g_tc_xme00_t = g_tc_xme.tc_xme00
      LET g_tc_xme.tc_xmemodu = g_user
      LET g_tc_xme.tc_xmedate = g_today
      CALL t520_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tc_xme.*=g_tc_xme_t.*
         CALL t520_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_tc_xme.tc_xme00 != g_tc_xme00_t THEN
         UPDATE tc_xmf_file SET tc_xmf00 = g_tc_xme.tc_xme00
          WHERE tc_xmf00 = g_tc_xme00_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('upd tc_xmf',SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","tc_xmf_file",g_tc_xme00_t,"",SQLCA.sqlcode,"","upd tc_xmf",1)  #No.FUN-660167
            ROLLBACK WORK
            RETURN
         END IF
 

      END IF
 
      UPDATE tc_xme_file SET tc_xme_file.* = g_tc_xme.*       #更改單頭
       WHERE tc_xme00 = g_tc_xme00_t
     
      IF SQLCA.sqlcode THEN

         CALL cl_err3("upd","tc_xme_file",g_tc_xme00_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE t520_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   END IF
 
END FUNCTION
 
FUNCTION t520_r()
   DEFINE l_chr LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
   DEFINE l_t   LIKE azo_file.azo05         #MOD-D40130 add
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_tc_xme.tc_xme00) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   #darcy:2023/04/04 add s---
    # 只有开立中,退回状态可以修改
    select tc_xmeacti into g_tc_xme.tc_xmeacti from tc_xme_file where tc_xme00 = g_tc_xme.tc_xme00
    if g_tc_xme.tc_xmeacti != '0' and g_tc_xme.tc_xmeacti != 'R'  then          #mod-4a0299
        call cl_err('','mfg3557',0)
        let g_success = 'N'
        return
    end if
    #darcy:2023/04/04 add e---
 
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t520_cl USING g_tc_xme.tc_xme00
   IF STATUS THEN
      CALL cl_err("OPEN t520_cl:", STATUS, 1)
      CLOSE t520_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t520_cl INTO g_tc_xme.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_xme.tc_xme00,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   CALL t520_show()
 
   IF cl_delh(20,16) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "tc_xme00"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_tc_xme.tc_xme00      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      MESSAGE "Delete tc_xme,tc_xmf,xmg!"
 
      DELETE FROM tc_xme_file
       WHERE tc_xme00 = g_tc_xme.tc_xme00
      IF SQLCA.SQLERRD[3] = 0 THEN
#        CALL cl_err('No tc_xme deleted','',0)   #No.FUN-660167
         CALL cl_err3("del","tc_xme_file",g_tc_xme.tc_xme00,"",SQLCA.sqlcode,"","No tc_xme deleted",1)  #No.FUN-660167
         ROLLBACK WORK
         RETURN
      END IF
 
      DELETE FROM tc_xmf_file
       WHERE tc_xmf00 = g_tc_xme.tc_xme00
      IF STATUS THEN
#        CALL cl_err('del tc_xmf',STATUS,0)   #No.FUN-660167
         CALL cl_err3("del","tc_xmf_file",g_tc_xme.tc_xme00,"",STATUS,"","del tc_xmf",1)  #No.FUN-660167
         ROLLBACK WORK
         RETURN
      END IF
#MOD-D40130 add begin------------------------      
      LET g_msg=TIME
      LET l_t = g_tc_xme.tc_xme00 CLIPPED
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) 
                   VALUES (g_prog,g_user,g_today,g_msg,l_t,'delete',g_plant,g_legal)
#MOD-D40130 add end--------------------------  
#FUN-9C0163 MARK START----------------------------------------------------------------
#     DELETE FROM xmg_file
#      WHERE xmg01 = g_tc_xme.tc_xme01
#        AND xmg02 = g_tc_xme.tc_xme02
#     IF STATUS THEN
##       CALL cl_err('del xmg',STATUS,0)   #No.FUN-660167
#        CALL cl_err3("del","xmg_file",g_tc_xme.tc_xme01,g_tc_xme.tc_xme02,STATUS,"","del xmg",1)  #No.FUN-660167
#        ROLLBACK WORK
#        RETURN
#     END IF
#FUN-9C0163 MARK END----------------------------------------------------------------- 
      CLEAR FORM
      CALL g_tc_xmf.clear()
      INITIALIZE g_tc_xme.* TO NULL
 
      DROP TABLE x  #No.TQC-720019
      PREPARE t520_precount_x2 FROM g_sql_tmp  #No.TQC-720019
      EXECUTE t520_precount_x2                 #No.TQC-720019
      OPEN t520_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t520_cs
         CLOSE t520_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH t520_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t520_cs
         CLOSE t520_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
 
      OPEN t520_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t520_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t520_fetch('/')
      END IF
 
      MESSAGE ""
   END IF
 
   CLOSE t520_cl
   COMMIT WORK
 
END FUNCTION

#str—add by huanglf 160711
FUNCTION t520_tc_xme03()
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_tc_xme03_desc    LIKE occ_file.occ02#客户简称

   
   SELECT occ02 INTO l_tc_xme03_desc
   FROM occ_file
   WHERE occ01 = g_tc_xme.tc_xme03
   DISPLAY l_tc_xme03_desc TO tc_xme03_desc 

#str---add by huanglf170317
  SELECT occ42,occ41 INTO g_tc_xme.tc_xme02,g_tc_xme.tc_xme06
  FROM occ_file WHERE occ01 = g_tc_xme.tc_xme03
  DISPLAY BY NAME g_tc_xme.tc_xme02,g_tc_xme.tc_xme06
  CALL t520_tc_xme06()
#str---end by huanglf170317   
END FUNCTION
#str—add by huanglf 160711
#str—add by guanyao 160711
FUNCTION t520_tc_xme06()
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_gec02    LIKE gec_file.gec02#客户简称

   
   SELECT gec02 INTO l_gec02
   FROM gec_file
   WHERE gec01 = g_tc_xme.tc_xme06
   DISPLAY l_gec02 TO gec02 

END FUNCTION
#str—add by guanyao 160711
FUNCTION t520_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680137 SMALLINT
       l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
       l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680137 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680137 VARCHAR(1)
       l_cmd           LIKE type_file.chr1000,             #No.FUN-680137  VARCHAR(60)
       l_flag          LIKE type_file.num5,                #No.FUN-680137 SMALLINT 
       l_i,l_cnt       LIKE type_file.num5,                #No.FUN-680137 SMALLINT
       l_s             LIKE type_file.num5,                #No.FUN-680137 SMALLINT
       l_tc_xmf05         LIKE tc_xmf_file.tc_xmf05,
       l_tc_xmf06         LIKE tc_xmf_file.tc_xmf06,
       l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
       l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
#FUN-9C0163 ADD START--------------------
DEFINE
    l_ima31         LIKE ima_file.ima31,
    t_flag          LIKE type_file.chr1,
    l_fac           LIKE type_file.num20_6,
    l_msg           LIKE type_file.chr1000
#FUN-9C0163 ADD END-----------------------
DEFINE l_x          LIKE type_file.num5   #add by guanyao160614
DEFINE l_gec04      LIKE gec_file.gec04   #add by guanyao160715
define l_occ45      like occ_file.occ45   #darcy:2023/04/06 add
#darcy:2023/04/12 add s---
define l_tc_xme00    like tc_xme_file.tc_xme00
define l_tc_xmf01    like tc_xmf_file.tc_xmf01
#darcy:2023/04/12 add e---
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_tc_xme.tc_xme00 IS NULL  THEN
      RETURN
   END IF
 
   SELECT * INTO g_tc_xme.* FROM tc_xme_file
    WHERE tc_xme00 = g_tc_xme.tc_xme00 
   #CALL t520_gen()
 
 
   CALL cl_opmsg('b')
 
 
   LET g_forupd_sql =
     "SELECT tc_xmf01,tc_xmf03,'','',tc_xmf04,tc_xmf05,tc_xmf06,tc_xmf07,tc_xmf08,tc_xmf10,tc_xmf09,tc_xmf11 ", #add by huanglf170405  #No.MOD-5A0455
     "  FROM tc_xmf_file",
     " WHERE tc_xmf00 = ? ",
     "   AND tc_xmf01 = ? ",
     #"   AND tc_xmf03 = ? ",  #mark by guanyao160614
     #"   AND tc_xmf04 = ? ",  #mark by guanyao160614
     #"   AND tc_xmf05 = ? ",  #mark by guanyao160614
     " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t520_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_tc_xmf WITHOUT DEFAULTS FROM s_tc_xmf.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL cl_set_comp_entry("tc_xmf05",FALSE)
         CALL cl_set_comp_entry("tc_xmf06",FALSE)
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         LET g_success = 'Y'
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_tc_xmf_t.* = g_tc_xmf[l_ac].*  #BACKUP
            LET g_tc_xmf_o.* = g_tc_xmf[l_ac].*  #BACKUP
            BEGIN WORK
 
            OPEN t520_bcl USING g_tc_xme.tc_xme00,g_tc_xmf_t.tc_xmf01
                               #,g_tc_xmf_t.tc_xmf03,g_tc_xmf_t.tc_xmf04,g_tc_xmf_t.tc_xmf05 #mark by guanyao160614
            IF STATUS THEN
               CALL cl_err("OPEN t520_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t520_bcl INTO g_tc_xmf[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_tc_xmf_t.tc_xmf03,SQLCA.sqlcode,1)
                  RETURN
                  LET l_lock_sw = "Y"
               END IF
               CALL t520_tc_xmf03('d')
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         LET g_before_input_done = FALSE
         CALL t520_set_entry_b(p_cmd)
         CALL t520_set_no_entry_b(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_tc_xme.tc_xme00) THEN LET g_tc_xme.tc_xme00=' ' END IF #FUN-790001 add
         INSERT INTO tc_xmf_file (tc_xmf00,tc_xmf01,tc_xmf03,tc_xmf04,tc_xmf05,tc_xmf06,tc_xmf07,tc_xmf08,tc_xmf10,tc_xmf09,tc_xmf11,tc_xmf12) #add by huanglf170405
                        VALUES(g_tc_xme.tc_xme00, g_tc_xmf[l_ac].tc_xmf01,
                               g_tc_xmf[l_ac].tc_xmf03,g_tc_xmf[l_ac].tc_xmf04,
                               g_tc_xmf[l_ac].tc_xmf05,g_tc_xmf[l_ac].tc_xmf06,
                               g_tc_xmf[l_ac].tc_xmf07,g_tc_xmf[l_ac].tc_xmf08,
                               g_tc_xmf[l_ac].tc_xmf10,  
                               g_tc_xmf[l_ac].tc_xmf09,
                               g_tc_xmf[l_ac].tc_xmf11,g_today)  #add by huanglf170405#add by huanglf170317
        
         IF SQLCA.sqlcode THEN

            CALL cl_err3("ins","tc_xmf_file",g_tc_xme.tc_xme00,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
            LET g_success = 'N'
         ELSE
            MESSAGE 'INSERT O.K'
            IF g_success = 'Y' THEN
               COMMIT WORK
            END IF
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
#FUN-9C0163 MARK START-------------------------------
#        INSERT INTO xmg_file(xmg01,xmg02,xmg03,xmg04,xmg05,
#                             xmg06,xmg07)
#                      VALUES(g_tc_xme.tc_xme01,g_tc_xme.tc_xme02,
#                             g_tc_xmf[l_ac].tc_xmf03,g_tc_xmf[l_ac].tc_xmf04,
#                             g_tc_xmf[l_ac].tc_xmf05,0,100)
#        IF SQLCA.sqlcode THEN
##          CALL cl_err('xmg',SQLCA.sqlcode,0)   #No.FUN-660167
#           CALL cl_err3("ins","xmg_file",g_tc_xme.tc_xme01,g_tc_xme.tc_xme02,SQLCA.sqlcode,"","xmg",1)  #No.FUN-660167
#           LET g_success = 'N'
#        END IF
#FUN-9C0163 MARK END------------------------------
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_tc_xmf[l_ac].* TO NULL      #900423
         LET g_tc_xmf_t.* = g_tc_xmf[l_ac].*         #新輸入資料
         LET g_tc_xmf_o.* = g_tc_xmf[l_ac].*         #新輸入資料
         LET g_tc_xmf[l_ac].tc_xmf05 = 0
         LET g_tc_xmf[l_ac].tc_xmf06 = 0  #add by guanyao160715
         LET g_tc_xmf[l_ac].tc_xmf07 = 0  #add by huanglf170317
         LET g_tc_xmf[l_ac].tc_xmf08 = 0  #add by huanglf170317
         LET g_tc_xmf[l_ac].tc_xmf10 = 0  #add by huanglf170320
         LET g_before_input_done = FALSE
         CALL t520_set_entry_b(p_cmd)
         CALL t520_set_no_entry_b(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD tc_xmf01

       BEFORE FIELD tc_xmf01                        #default 序号   依次加一   项次
           IF g_tc_xmf[l_ac].tc_xmf01 IS NULL OR g_tc_xmf[l_ac].tc_xmf01 = 0 THEN
              SELECT max(tc_xmf01)+1 INTO g_tc_xmf[l_ac].tc_xmf01 FROM tc_xmf_file
               #WHERE tc_xmf01 = g_tc_xmf[l_ac].tc_xmf01  #mark by guanyao160613
               WHERE tc_xmf00 =g_tc_xme.tc_xme00          #add by guanyao160613
              IF g_tc_xmf[l_ac].tc_xmf01 IS NULL THEN
                 LET g_tc_xmf[l_ac].tc_xmf01 = 1
              END IF
           END IF
        AFTER FIELD tc_xmf01       #check 序号是否重复
           IF NOT cl_null(g_tc_xmf[l_ac].tc_xmf01) THEN
#MOD-C30161 ----- add ----- begin
              IF g_tc_xmf[l_ac].tc_xmf01 <=0 THEN
                 CALL cl_err('','aec-994',0)
                 LET g_tc_xmf[l_ac].tc_xmf01 = g_tc_xmf_t.tc_xmf01
                 NEXT FIELD tc_xmf01
              END IF
#MOD-C30161 ----- add ----- end
              IF g_tc_xmf[l_ac].tc_xmf01 != g_tc_xmf_t.tc_xmf01 OR g_tc_xmf_t.tc_xmf01 IS NULL THEN
                 SELECT COUNT(*) INTO l_cnt FROM tc_xmf_file
                  WHERE tc_xmf00 = g_tc_xme.tc_xme00
                    AND tc_xmf01 = g_tc_xmf[l_ac].tc_xmf01
                 IF l_cnt > 0 THEN     #l_cnt>0  则有重复
                    CALL cl_err('',-239,0)
                    LET g_tc_xmf[l_ac].tc_xmf01 = g_tc_xmf_t.tc_xmf01
                    NEXT FIELD tc_xmf01
                 END IF
              END IF
           END IF

      #str----add by guanyao160614
      AFTER FIELD tc_xmf03
         IF NOT cl_null(g_tc_xmf[l_ac].tc_xmf03) THEN 
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_tc_xmf_t.tc_xmf03 != g_tc_xmf[l_ac].tc_xmf03) THEN
               SELECT COUNT(*) INTO l_x FROM tc_xmf_file 
                WHERE tc_xmf00 = g_tc_xme.tc_xme00
                  AND tc_xmf03 = g_tc_xme.tc_xme03
               IF l_x > 0 THEN 
                  CALL cl_err('','cxm-007',0)
                  NEXT FIELD tc_xmf03
               END IF 
               #darcy:2023/04/06 add s---
               IF p_cmd = 'a' OR
                  (p_cmd = 'u' AND g_tc_xmf_t.tc_xmf03 != g_tc_xmf[l_ac].tc_xmf03) THEN
                     CALL t520_tc_xmf03('a')
               end if
               #每次修改都重新取价格
               select occ45 into l_occ45 from occ_file where occ01 =''
               CALL cs_fetch_price_new(
                  g_tc_xme.tc_xme03,
                  g_tc_xmf[l_ac].tc_xmf03,
                  "",
                  g_tc_xmf[l_ac].tc_xmf04,
                  g_today,     #FUN-BC0071 
                  '1',
                  g_plant,
                  g_tc_xme.tc_xme02,
                  g_tc_xme.tc_xme01,
                  l_occ45,
                  g_tc_xme.tc_xme00,
                  g_tc_xmf[l_ac].tc_xmf01,
                  1,
                  "",
                  'a',
                  g_tc_xme.tc_xme06)  #MOD-C90105 'a' -> p_cmd #add g_oea.oea21  by guanyao160712
               RETURNING g_tc_xmf[l_ac].tc_xmf11,g_tc_xmf[l_ac].tc_xmf11
               #darcy:2023/04/06 add e---
            END IF 
            #darcy:2023/04/12 add s---
            # 如果有未审核的单据，不允许录入。
            let l_tc_xme00 =''
            let l_tc_xmf01 = ''
            SELECT tc_xme00, tc_xmf01 into l_tc_xme00,l_tc_xmf01
            FROM tc_xme_file, tc_xmf_file
            WHERE tc_xme00 = tc_xmf00
               AND tc_xme01 = g_tc_xme.tc_xme01
               AND tc_xme02 = g_tc_xme.tc_xme02
               AND tc_xme06 = g_tc_xme.tc_xme06
               AND tc_xmf03 = g_tc_xmf[l_ac].tc_xmf03
               AND tc_xmeconf != 'Y'
               and tc_xme00 != g_tc_xme.tc_xme00 #darcy:2023/04/24 add
            if not cl_null(l_tc_xme00||"|"||l_tc_xmf01) then
               call cl_err_msg('错误，请检查！','cxm-038',l_tc_xme00||"|"||l_tc_xmf01,1)
               next field tc_xmf03
            end if
            #darcy:2023/04/12 add e---
         END IF 
      #end----add by guanyao160614

      #darcy:2023/04/12 add s---
      on change tc_xmf03
         # 如果有未审核的单据，不允许录入。
         let l_tc_xme00 =''
         let l_tc_xmf01 = ''
         SELECT tc_xme00, tc_xmf01 into l_tc_xme00,l_tc_xmf01
           FROM tc_xme_file, tc_xmf_file
         WHERE tc_xme00 = tc_xmf00
            AND tc_xme01 = g_tc_xme.tc_xme01
            AND tc_xme02 = g_tc_xme.tc_xme02
            AND tc_xme06 = g_tc_xme.tc_xme06
            AND tc_xmf03 = g_tc_xmf[l_ac].tc_xmf03
            AND tc_xmeconf != 'Y'
            and tc_xme00 != g_tc_xme.tc_xme00
         if not cl_null(l_tc_xme00||"|"||l_tc_xmf01) then
            call cl_err_msg('错误，请检查！','cxm-038',l_tc_xme00||"|"||l_tc_xmf01,1)
            next field tc_xmf03
         end if
      

      #darcy:2023/04/12 add e---
      BEFORE FIELD tc_xmf04
         IF p_cmd = 'a' OR
           (p_cmd = 'u' AND g_tc_xmf_t.tc_xmf03 != g_tc_xmf[l_ac].tc_xmf03) THEN
            CALL t520_tc_xmf03('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_tc_xmf[l_ac].tc_xmf03,g_errno,0)
               LET g_tc_xmf[l_ac].tc_xmf03 = g_tc_xmf_t.tc_xmf03
               NEXT FIELD tc_xmf03
            END IF
         END IF
 
      AFTER FIELD tc_xmf04
         IF NOT cl_null(g_tc_xmf[l_ac].tc_xmf04) THEN
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_tc_xmf_t.tc_xmf04 != g_tc_xmf[l_ac].tc_xmf04) THEN
               CALL t520_tc_xmf04()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tc_xmf[l_ac].tc_xmf04,g_errno,0)
                  LET g_tc_xmf[l_ac].tc_xmf04 = g_tc_xmf_o.tc_xmf04
                  NEXT FIELD tc_xmf04
               #FUN-9C0163 ADD START---------------------
                --ELSE
                   --IF NOT cl_null(g_tc_xmf[l_ac].tc_xmf03) THEN
                      --SELECT ima31 INTO l_ima31 FROM ima_file
                       --WHERE ima01 = g_tc_xmf[l_ac].tc_xmf03
                      --CALL s_umfchk(g_tc_xmf[l_ac].tc_xmf03,g_tc_xmf[l_ac].tc_xmf04
                                    --,l_ima31)
                      --RETURNING t_flag,l_fac
                      --IF t_flag = 1 THEN
                         --LET l_msg = l_ima31 CLIPPED,'->',
                                     --g_tc_xmf[l_ac].tc_xmf04 CLIPPED
                         --CALL cl_err(l_msg CLIPPED,'mfg2719',0)
                         --NEXT FIELD tc_xmf04
                      --END IF
                   --END IF
              #FUN-9C0163 ADD END--------------------------
               END IF
            END IF
         END IF
   

      #str----add by guanyao160719
      BEFORE FIELD tc_xmf05
         LET l_tc_xmf05 = g_tc_xmf[l_ac].tc_xmf05
      #end----add by guanyao160719
      AFTER FIELD tc_xmf05
         IF NOT cl_null(g_tc_xmf[l_ac].tc_xmf05) THEN
            IF g_tc_xmf[l_ac].tc_xmf05 <0 THEN
               CALL cl_err('tc_xmf05','mfg1322',0)
               NEXT FIELD tc_xmf05
            END IF
            IF (p_cmd ='a' AND l_tc_xmf05 <>g_tc_xmf[l_ac].tc_xmf05) OR
               (l_tc_xmf05 <>g_tc_xmf[l_ac].tc_xmf05 AND l_tc_xmf05>0) THEN 
               LET l_gec04 = 0
               SELECT gec04 INTO l_gec04 FROM gec_file WHERE gec01 = g_tc_xme.tc_xme06
               IF l_gec04 = 0 OR cl_null(l_gec04) THEN 
                  LET l_gec04 = 0
               END IF 
               LET g_tc_xmf[l_ac].tc_xmf06 = g_tc_xmf[l_ac].tc_xmf05*(100+l_gec04)/100
            END IF 
         END IF
#str-----add by gunayao160715
     #str----add by guanyao160719
      BEFORE FIELD tc_xmf06
         LET l_tc_xmf06 = g_tc_xmf[l_ac].tc_xmf06
      #end----add by guanyao160719
     AFTER FIELD tc_xmf06
         IF NOT cl_null(g_tc_xmf[l_ac].tc_xmf06) THEN
            IF g_tc_xmf[l_ac].tc_xmf06 <0 THEN
               CALL cl_err('tc_xmf06','mfg1322',0)
               NEXT FIELD tc_xmf06
            END IF
            IF (p_cmd ='a' AND l_tc_xmf06 <>g_tc_xmf[l_ac].tc_xmf06) 
              OR ( l_tc_xmf06 <>g_tc_xmf[l_ac].tc_xmf06 AND l_tc_xmf06>0) THEN
               LET l_gec04 = 0
               SELECT gec04 INTO l_gec04 FROM gec_file WHERE gec01 = g_tc_xme.tc_xme06
               IF l_gec04 = 0 OR cl_null(l_gec04) THEN 
                  LET l_gec04 = 0
               END IF 
               LET g_tc_xmf[l_ac].tc_xmf05 = g_tc_xmf[l_ac].tc_xmf06/((100+l_gec04)/100)  #add by huanglf170317
            END IF 
         END IF
#end-----add by gunayao160715

 #str----add by huanglf170405
    AFTER FIELD tc_xmf07
       IF NOT cl_null(g_tc_xmf[l_ac].tc_xmf07) AND NOT cl_null(g_tc_xmf[l_ac].tc_xmf08)
        AND NOT cl_null(g_tc_xmf[l_ac].tc_xmf10) THEN
            LET g_tc_xmf[l_ac].tc_xmf05 = g_tc_xmf[l_ac].tc_xmf07 + g_tc_xmf[l_ac].tc_xmf08 
                                        + g_tc_xmf[l_ac].tc_xmf10
             LET l_gec04 = 0
             SELECT gec04 INTO l_gec04 FROM gec_file WHERE gec01 = g_tc_xme.tc_xme06
             IF l_gec04 = 0 OR cl_null(l_gec04) THEN 
                  LET l_gec04 = 0
             END IF 
             LET g_tc_xmf[l_ac].tc_xmf06 = g_tc_xmf[l_ac].tc_xmf05*(100+l_gec04)/100                          
       END IF 

    AFTER FIELD tc_xmf08
       IF NOT cl_null(g_tc_xmf[l_ac].tc_xmf07) AND NOT cl_null(g_tc_xmf[l_ac].tc_xmf08)
        AND NOT cl_null(g_tc_xmf[l_ac].tc_xmf10) THEN
            LET g_tc_xmf[l_ac].tc_xmf05 = g_tc_xmf[l_ac].tc_xmf07 + g_tc_xmf[l_ac].tc_xmf08 
                                        + g_tc_xmf[l_ac].tc_xmf10
             LET l_gec04 = 0
             SELECT gec04 INTO l_gec04 FROM gec_file WHERE gec01 = g_tc_xme.tc_xme06
             IF l_gec04 = 0 OR cl_null(l_gec04) THEN 
                  LET l_gec04 = 0
             END IF 
             LET g_tc_xmf[l_ac].tc_xmf06 = g_tc_xmf[l_ac].tc_xmf05*(100+l_gec04)/100                          
       END IF    

     AFTER FIELD tc_xmf10
       IF NOT cl_null(g_tc_xmf[l_ac].tc_xmf07) AND NOT cl_null(g_tc_xmf[l_ac].tc_xmf08)
        AND NOT cl_null(g_tc_xmf[l_ac].tc_xmf10) THEN
            LET g_tc_xmf[l_ac].tc_xmf05 = g_tc_xmf[l_ac].tc_xmf07 + g_tc_xmf[l_ac].tc_xmf08 
                                        + g_tc_xmf[l_ac].tc_xmf10
             LET l_gec04 = 0
             SELECT gec04 INTO l_gec04 FROM gec_file WHERE gec01 = g_tc_xme.tc_xme06
             IF l_gec04 = 0 OR cl_null(l_gec04) THEN 
                  LET l_gec04 = 0
             END IF 
             LET g_tc_xmf[l_ac].tc_xmf06 = g_tc_xmf[l_ac].tc_xmf05*(100+l_gec04)/100                            
       END IF       
 #str----end by huanglf170405
 
      BEFORE DELETE                            #是否取消單身
         IF g_tc_xmf_t.tc_xmf01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM tc_xmf_file                 #刪除單身
             WHERE tc_xmf00 = g_tc_xme.tc_xme00 AND tc_xmf01 = g_tc_xmf[l_ac].tc_xmf01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_tc_xmf_t.tc_xmf03,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","tc_xmf_file",g_tc_xme.tc_xme00,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE
            END IF

            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         IF g_success ='Y' THEN COMMIT WORK END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_tc_xmf[l_ac].* = g_tc_xmf_t.*
            CLOSE t520_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_tc_xmf[l_ac].tc_xmf03,-263,1)
            LET g_tc_xmf[l_ac].* = g_tc_xmf_t.*
         ELSE
            UPDATE tc_xmf_file SET tc_xmf01=g_tc_xmf[l_ac].tc_xmf01,
                                tc_xmf03=g_tc_xmf[l_ac].tc_xmf03,
                                tc_xmf04=g_tc_xmf[l_ac].tc_xmf04,
                                tc_xmf05=g_tc_xmf[l_ac].tc_xmf05,
                                tc_xmf06=g_tc_xmf[l_ac].tc_xmf06,
                                tc_xmf07=g_tc_xmf[l_ac].tc_xmf07,
                                tc_xmf08=g_tc_xmf[l_ac].tc_xmf08,
                                tc_xmf10=g_tc_xmf[l_ac].tc_xmf10, #add by huanglf170405
                                tc_xmf09=g_tc_xmf[l_ac].tc_xmf09
             WHERE tc_xmf00 = g_tc_xme.tc_xme00
               AND tc_xmf01 = g_tc_xmf_t.tc_xmf01
    
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_tc_xmf[l_ac].tc_xmf03,-239,0)   #No.FUN-660167
               CALL cl_err3("upd","tc_xmf_file",g_tc_xme.tc_xme00,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
               LET g_tc_xmf[l_ac].* = g_tc_xmf_t.*
               LET g_success = 'N'
            ELSE
               MESSAGE 'UPDATE O.K'
               IF g_success = 'Y' THEN COMMIT WORK END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_tc_xmf[l_ac].* = g_tc_xmf_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_tc_xmf.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE t520_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE t520_cl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tc_xmf03)

                  CALL q_sel_ima(FALSE, "q_ima","",g_tc_xmf[l_ac].tc_xmf03,"","","","","",'' ) 
                      RETURNING  g_tc_xmf[l_ac].tc_xmf03

                  DISPLAY BY NAME g_tc_xmf[l_ac].tc_xmf03          
            WHEN INFIELD(tc_xmf04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_tc_xmf[l_ac].tc_xmf04
                 CALL cl_create_qry() RETURNING g_tc_xmf[l_ac].tc_xmf04
                 DISPLAY g_tc_xmf[l_ac].tc_xmf04 TO tc_xmf04
                 NEXT FIELD tc_xmf04
            OTHERWISE
                EXIT CASE
         END CASE
 
      #BugNo:6638
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION set_price          #延用定價
         CALL t520_ctry_tc_xmf05()
         NEXT FIELD tc_xmf05
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(tc_xmf03) AND l_ac > 1 THEN
            LET g_tc_xmf[l_ac].* = g_tc_xmf[l_ac-1].*
            NEXT FIELD tc_xmf03
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
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
 
 
   END INPUT
 
   CLOSE t520_bcl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   CALL t520_delHeader()     #CHI-C30002 add
   CALL t520_show()
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t520_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM tc_xme_file WHERE tc_xme01 = g_tc_xme.tc_xme01
                                AND tc_xme02 = g_tc_xme.tc_xme02
                                AND tc_xme00 = g_tc_xme.tc_xme00
         INITIALIZE g_tc_xme.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t520_tc_xmf03(p_cmd)  #料件編號
   DEFINE l_ima02    LIKE ima_file.ima02,
          l_ima021   LIKE ima_file.ima021,
          l_ima31    LIKE ima_file.ima31,
          l_ima33    LIKE ima_file.ima33,
          l_imaacti  LIKE ima_file.imaacti,
          l_cnt      LIKE type_file.num5,   #No.FUN-680137 SMALLINT
          p_cmd      LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE l_gec04       LIKE gec_file.gec04    #add by guanyao160715
 
   LET g_errno = ' '
   SELECT ima02,ima021,imaacti,ima31,ima33  #FUN-560193
     INTO l_ima02,l_ima021,l_imaacti,l_ima31,l_ima33  #FUN-560193
     FROM ima_file
    WHERE ima01 = g_tc_xmf[l_ac].tc_xmf03
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                           LET l_ima02 = NULL
                           LET l_ima021= NULL
        WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'   LET g_errno = '9038'   #No.FUN-690022
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF p_cmd = 'a' THEN
      LET g_tc_xmf[l_ac].tc_xmf04 = l_ima31
      LET l_gec04 = 0
      SELECT gec04 INTO l_gec04 FROM gec_file WHERE gec01 = g_tc_xme.tc_xme06
      IF l_gec04 = 0 OR cl_null(l_gec04) THEN 
         LET l_gec04 = 0
      END IF 
            
      IF g_gec07 = 'Y' THEN 
         LET g_tc_xmf[l_ac].tc_xmf06 = l_ima33
         IF g_tc_xmf[l_ac].tc_xmf06 IS NULL THEN
            LET g_tc_xmf[l_ac].tc_xmf06 = 0
         END IF
         LET g_tc_xmf[l_ac].tc_xmf06 = g_tc_xmf[l_ac].tc_xmf05*(100+l_gec04)/100
      ELSE 
         LET g_tc_xmf[l_ac].tc_xmf05 = l_ima33
         IF g_tc_xmf[l_ac].tc_xmf05 IS NULL THEN
            LET g_tc_xmf[l_ac].tc_xmf05 = 0
         END IF
         LET g_tc_xmf[l_ac].tc_xmf05 = g_tc_xmf[l_ac].tc_xmf06*(100-l_gec04)/100
      END IF 
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_tc_xmf[l_ac].ima02 = l_ima02
      LET g_tc_xmf[l_ac].ima021= l_ima021
   END IF
 
END FUNCTION
 
FUNCTION t520_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
   CONSTRUCT l_wc2 ON tc_xmf01,tc_xmf03,tc_xmf04,tc_xmf05
              FROM s_tc_xmf[1].tc_xmf01,s_tc_xmf[1].tc_xmf03,s_tc_xmf[1].tc_xmf04,s_tc_xmf[1].tc_xmf05
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
   CALL t520_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t520_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
   LET g_sql =
       "SELECT tc_xmf01,tc_xmf03,ima02,ima021,tc_xmf04,tc_xmf05,tc_xmf06,tc_xmf07,tc_xmf08,tc_xmf10,tc_xmf09,tc_xmf11 ", #add by huanglf170405#FUN-560193
       "  FROM tc_xmf_file LEFT OUTER JOIN ima_file ON tc_xmf_file.tc_xmf03=ima_file.ima01",
       " WHERE tc_xmf00 = '",g_tc_xme.tc_xme00,
       "'",
       "   AND ", p_wc2 CLIPPED,                     #單身
       " ORDER BY tc_xmf00"
   PREPARE t520_pb FROM g_sql
   IF STATUS THEN CALL cl_err('per',STATUS,1) RETURN END IF
   DECLARE tc_xmf_curs CURSOR FOR t520_pb
 
   CALL g_tc_xmf.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH tc_xmf_curs INTO g_tc_xmf[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_tc_xmf.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t520_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_xmf TO s_tc_xmf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
    #------------------No.FUN-620009 add
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
    #------------------No.FUN-620009 end
      ON ACTION first
         CALL t520_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t520_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t520_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t520_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t520_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      #darcy:2023/03/28 add s---
      on action easyflow_approval
         let g_action_choice = 'easyflow_approval'
         LET l_ac = 1
         exit display
      #darcy:2023/03/28 add e---
 
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE                 #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 

       ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY 

      #str---mark by guanyao160614   
      #ON ACTION undo_confirm
      #   LET g_action_choice="undo_confirm"
      #   EXIT DISPLAY
      #end---mark by guanyao160614
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t520_gen()     #自動產生單身資料
   DEFINE l_wc          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(300)
   DEFINE l_ima         RECORD LIKE ima_file.*
   DEFINE l_ima01       LIKE ima_file.ima01
   DEFINE l_sql         LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(300)
   #yemy 20130513  --Begin
   DEFINE l_cnt         LIKE type_file.num10
   DEFINE l_sw          LIKE type_file.num10
   DEFINE l_i           LIKE type_file.num10
   #yemy 20130513  --End  
 
   SELECT COUNT(*) INTO l_cnt FROM tc_xmf_file
    WHERE tc_xmf00 = g_tc_xme.tc_xme00
   IF l_cnt > 0 THEN RETURN END IF
 
   LET p_row = 8 LET p_col = 18
   OPEN WINDOW t520_w1 AT p_row,p_col         #顯示畫面
        WITH FORM "axm/42f/axmi5201"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axmi5201")
 
   CONSTRUCT BY NAME l_wc ON ima06,ima01
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
         
 #MOD-990160 --begin--
      ON ACTION controlp
         CASE
           #TQC-D70002--add--str-- 
           WHEN INFIELD(ima06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_imz'
              LET g_qryparam.state = 'c'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima06
              NEXT FIELD ima06
           #TQC-D70002--add--end-- 
           WHEN INFIELD(ima01)
#FUN-AA0059---------mod------------str-----------------             
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima02"
#                LET g_qryparam.state = 'c'
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima02","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

                DISPLAY g_qryparam.multiret TO ima01
                NEXT FIELD ima01              
         END CASE  
#MOD-990160 --end--
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t520_w1
      RETURN
   END IF
 
   LET l_cnt=0
   LET l_sql = "SELECT * FROM ima_file WHERE ",l_wc CLIPPED
 
   PREPARE i5201_prepare FROM l_sql
   IF STATUS THEN
      CALL cl_err('pre',STATUS,1)
      CLOSE WINDOW t520_w1
      RETURN
   END IF
 
   DECLARE i5201_cs CURSOR FOR i5201_prepare

   #yemy 20130513  --Begin
   LET l_sql = "SELECT COUNT(*) FROM ima_file WHERE ",l_wc CLIPPED
   PREPARE i5201_cnt_pre FROM l_sql
   EXECUTE i5201_cnt_pre INTO l_cnt
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN
      CALL cl_progress_bar(l_cnt)
   END IF
   #yemy 20130513  --End  
   LET l_i = 1
   FOREACH i5201_cs INTO l_ima.*

      #yemy 20130513  --Begin
      CALL cl_progressing(" ")
      #yemy 20130513  --End  

      #FUN-AB0025 ------------add start-----------
      IF NOT cl_null(l_ima.ima01 ) THEN
         IF NOT s_chk_item_no(l_ima.ima01,'') THEN
            CONTINUE FOREACH
         END IF
      END IF
      #FUN-AB0025 ------------add end------------
      IF l_ima.ima33 IS NULL THEN LET l_ima.ima33 = 0   END IF
      IF l_ima.ima31 IS NULL THEN LET l_ima.ima31 = " " END IF
      IF cl_null(g_tc_xme.tc_xme01) THEN LET g_tc_xme.tc_xme00= ' ' END IF #FUN-790001 add
      INSERT INTO tc_xmf_file(tc_xmf00,tc_xmf01,tc_xmf03,tc_xmf04,tc_xmf05)
                    VALUES(g_tc_xme.tc_xme00,l_i,l_ima.ima01,l_ima.ima31,l_ima.ima33)
      LET l_i = l_i + 1
      IF STATUS THEN 
#        CALL cl_err('ins tc_xmf',STATUS,0)   #No.FUN-660167
         CALL cl_err3("ins","tc_xmf_file",g_tc_xme.tc_xme00,"",SQLCA.SQLCODE,"","ins tc_xmf",1)  #No.FUN-660167
         EXIT FOREACH 
      END IF
#FUN-9C0163 MARK START--------------------------------------------------------------
#     INSERT INTO xmg_file(xmg01,xmg02,xmg03,xmg04,xmg05,xmg06,xmg07)
#                   VALUES(g_tc_xme.tc_xme01,g_tc_xme.tc_xme02,l_ima.ima01,
#                          l_ima.ima31,g_today,0,100)
#     IF STATUS THEN 
##       CALL cl_err('ins xmg',STATUS,0)  #No.FUN-660167
#        CALL cl_err3("ins","xmg_file",g_tc_xme.tc_xme01,g_tc_xme.tc_xme02,SQLCA.SQLCODE,"","ins xmg",1)  #No.FUN-660167
#        EXIT FOREACH 
#     END IF
#FUN-9C0163 MARK END-------------------------------------------------------------
   END FOREACH
 
   ERROR ""
   CLOSE WINDOW t520_w1
 
   CALL t520_b_fill("1=1")
 
END FUNCTION
 
FUNCTION t520_tc_xmf04()  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti
 
   LET g_errno = " "
 
   SELECT gfeacti INTO l_gfeacti FROM gfe_file
    WHERE gfe01 = g_tc_xmf[l_ac].tc_xmf04
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg3098'
         LET l_gfeacti = NULL
      WHEN l_gfeacti='N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
END FUNCTION
#No.FUN-7C0043--start-- 
FUNCTION t520_out()
 DEFINE l_i             LIKE type_file.num5,         
        l_name          LIKE type_file.chr20,
        l_prog        LIKE zz_file.zz01,
        l_prtway      LIKE type_file.chr1
 DEFINE l_wc           LIKE type_file.chr1000        
 DEFINE l_cmd          LIKE type_file.chr1000              #No.FUN-7C0043                                                                    
   IF cl_null(g_tc_xme.tc_xme00) THEN
      CALL cl_err('','-400',1)  #MOD-640492 0->1
      RETURN
   END IF
   LET l_prog='cxmr008' 

   IF NOT cl_null(l_prog) THEN #BugNo:5548
      LET l_wc='tc_xme00="',g_tc_xme.tc_xme00,'"'
      LET l_cmd = l_prog CLIPPED,
                  " '",g_today CLIPPED,"' ''",
                  " '",g_lang CLIPPED,"' 'N' '",l_prtway,"' '1'",
                  " '",l_wc CLIPPED,"' 'N' 'N' '0' 'N'"
      CALL cl_cmdrun(l_cmd)
   END IF
 
 
END FUNCTION
 

FUNCTION t520_ctry_tc_xmf05()
 DEFINE l_i    LIKE type_file.num10,         #No.FUN-680137  INTEGER
        l_tc_xmf05 LIKE tc_xmf_file.tc_xmf05
 
   LET l_i = l_ac
   LET l_tc_xmf05 = g_tc_xmf[l_ac].tc_xmf05
 
   IF cl_confirm('abx-080') THEN
      WHILE l_i <= g_rec_b  #自本行至最后一行延用其上的值
         UPDATE tc_xmf_file
            SET tc_xmf05 = l_tc_xmf05
          WHERE tc_xmf00 = g_tc_xme.tc_xme00
            AND tc_xmf01 = g_tc_xmf[l_i].tc_xmf01
    
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_tc_xmf[l_i].tc_xmf05,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","tc_xmf_file",g_tc_xme.tc_xme00,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            LET g_success='N'
            EXIT WHILE
         END IF
         LET l_i = l_i + 1
         IF l_i   > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT WHILE
         END IF
      END WHILE
   END IF
 
   CALL t520_show()
 
END FUNCTION
 

FUNCTION t520_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("tc_xme00",TRUE)
       CALL cl_set_comp_entry("tc_xme06",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t520_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
      IF p_cmd = 'u' AND g_chkey = 'N' THEN
         CALL cl_set_comp_entry("tc_xme00",FALSE)
         CALL cl_set_comp_entry("tc_xme06",FALSE)
      END IF
   END IF
   
 
END FUNCTION
 
FUNCTION t520_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("tc_xmf01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t520_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
      IF p_cmd = 'u' THEN
         CALL cl_set_comp_entry("tc_xmf01",FALSE)
      END IF
   END IF
 
END FUNCTION
 
#------------------------No.FUN-620009 add-----------------------------
FUNCTION t520_copy()
DEFINE l_tc_xme00,l_tc_xme00_o  LIKE tc_xme_file.tc_xme00,
       l_tc_xme01,l_tc_xme01_o  LIKE tc_xme_file.tc_xme01,
       l_tc_xme02,l_tc_xme02_o  LIKE tc_xme_file.tc_xme02,
       l_n                  LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       l_oah02              LIKE oah_file.oah02,
       li_result           LIKE type_file.num5
DEFINE l_newno     LIKE tc_xme_file.tc_xme00 
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_tc_xme.tc_xme00 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL t520_set_entry('a')
    LET g_before_input_done = TRUE
 
    DISPLAY ' ' TO tc_xme00
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT l_tc_xme00 FROM tc_xme00 
 
        AFTER FIELD tc_xme00
           IF NOT cl_null(g_tc_xme.tc_xme00) THEN 
              CALL s_check_no("cxm",l_newno,"","10","tc_xme_file","tc_xme00","")
                RETURNING li_result,l_newno
              DISPLAY l_newno to tc_xme00
              IF (NOT li_result) THEN
                  NEXT FIELD tc_xme00
              END IF
           END IF 
        CALL s_auto_assign_no("cxm",l_newno,"","10","tc_xme_file","tc_xme00","","","")
                RETURNING li_result,l_newno

              IF (NOT li_result) THEN
                  NEXT FIELD tc_xme00
              END IF
           
              DISPLAY l_newno to tc_xme00
        
 
       ON ACTION controlp
          CASE
               WHEN INFIELD(tc_xme00) #查詢單別 hlf modify
                   LET g_oayslip=s_get_doc_no(l_newno)
                   CALL q_oay(FALSE,TRUE,g_oayslip,'10','CXM') RETURNING g_oayslip
                   LET l_newno = g_oayslip
                   DISPLAY l_newno TO tc_xme00
                   NEXT FIELD tc_xme00
                WHEN INFIELD(tc_xme01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oah1"
                     LET g_qryparam.default1 = l_tc_xme01
                     CALL cl_create_qry() RETURNING l_tc_xme01
                     DISPLAY BY name l_tc_xme01
                     NEXT FIELD tc_xme01
                WHEN INFIELD(tc_xme02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.default1 = l_tc_xme02
                     CALL cl_create_qry() RETURNING l_tc_xme02
                     DISPLAY BY name l_tc_xme02
                     NEXT FIELD tc_xme02
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
       LET INT_FLAG = 0
       DISPLAY g_tc_xme.tc_xme00 TO tc_xme00 
       RETURN
    END IF
 
    DROP TABLE x
 
    SELECT * FROM tc_xme_file WHERE tc_xme00 = g_tc_xme.tc_xme00
        INTO TEMP x
 
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_tc_xme01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       RETURN
    END IF
 
    UPDATE x SET tc_xme00 = l_tc_xme00,
                 tc_xme01 = l_tc_xme01,
                 tc_xme02 = l_tc_xme02,
                 tc_xme03 = l_tc_xme03,
                 tc_xme04 = l_tc_xme04,
                 tc_xmeuser=g_user,
                 tc_xmemodu=g_user,
                 tc_xmegrup=g_grup,
                 tc_xmedate=g_today 
 
    INSERT INTO tc_xme_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_tc_xme01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("ins","tc_xme_file",l_tc_xme00,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_tc_xme00,') O.K'
 
    DROP TABLE y
 
    SELECT * FROM tc_xmf_file WHERE tc_xmf00 = g_tc_xme.tc_xme00
        INTO TEMP y
 
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_tc_xme01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","tc_xmf_file",g_tc_xme.tc_xme00,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       RETURN
    END IF
 
    UPDATE y SET tc_xmf00 = l_tc_xme00
    IF cl_null(l_tc_xme00) THEN LET l_tc_xme00=' ' END IF   #FUN-790001 add
    INSERT INTO tc_xmf_file SELECT * FROM y
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_tc_xme01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("ins","tc_xmf_file",l_tc_xme00,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_tc_xme00,') O.K'
 
     LET l_tc_xme00_o= g_tc_xme.tc_xme00
     LET g_tc_xme.tc_xme00=l_tc_xme00

 
     SELECT * INTO g_tc_xme.* FROM tc_xme_file WHERE tc_xme00 = g_tc_xme.tc_xme00
                                         
     IF SQLCA.sqlcode THEN
#       CALL cl_err(g_tc_xme.tc_xme01,SQLCA.sqlcode,0)   #No.FUN-660167
        CALL cl_err3("sel","tc_xme_file",g_tc_xme.tc_xme00,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
        INITIALIZE g_tc_xme.* TO NULL
        RETURN
     END IF
     CALL t520_show()
     CALL t520_b_fill("1=1")
     CALL t520_b()
 

END FUNCTION

FUNCTION t520_y_chk()
   DEFINE  l_n LIKE type_file.num5
   DEFINE l_x  LIKE type_file.num5
   DEFINE l_ac LIKE type_file.num5  #add by huanglf170317
   DEFINE l_num LIKE type_file.num5 #add by huanglf170317
   DEFINE l_sql STRING   #add by huanglf170317
   LET g_success = 'Y'
   SELECT * INTO g_tc_xme.* FROM tc_xme_file 
   WHERE tc_xme00=g_tc_xme.tc_xme00  ##


   IF g_tc_xme.tc_xmeconf='Y' THEN
      CALL cl_err('',9023,0)
      LET g_success='N'
      RETURN
   END IF

   IF g_tc_xme.tc_xmeconf='X' THEN
      CALL cl_err('',9024,0)
      LET g_success='N'
      RETURN
   END IF
--
   --IF g_tc_xme.tc_xmeacti='N' THEN
      --CALL cl_err('',9025,0)  ##去引号了
      --LET g_success='N'
      --RETURN
   --END IF
   IF cl_null(g_tc_xme.tc_xme00) THEN
      CALL cl_err('','9033',0)
      LET g_success = 'N'
      RETURN 
   END IF

   IF NOT cl_confirm('aap-017') THEN 
        RETURN 
   END IF
   
   LET g_tc_xme_t.* = g_tc_xme.*
   BEGIN WORK

   OPEN t520_cl USING g_tc_xme.tc_xme00
   IF STATUS THEN
      CALL cl_err("OPEN t520_cl:",STATUS,1)
      CLOSE t520_cl
      RETURN
   END IF

   FETCH t520_cl INTO g_tc_xme.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_xme.tc_xme00,SQLCA.sqlcode,0)
      CLOSE t520_cl
      RETURN 
    END IF
#str----add by guanyao160614
  IF g_success = 'Y' THEN
     CALL t520sub_ins(g_tc_xme.tc_xme00) #darcy:2023/04/04 mod
  END IF 
#end----add by guanyao160614  

  
   UPDATE tc_xme_file SET tc_xmeconf = 'Y',tc_xmemodu = g_user,tc_xmedate=g_today 
             WHERE tc_xme00 = g_tc_xme.tc_xme00

  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
        CALL cl_err3("upd","tc_xme_file",g_tc_xme.tc_xme00,"",SQLCA.sqlcode,"","",0)
        LET g_success = 'N'
  END IF 

  #str----add by huanglf170317
  LET l_sql = " SELECT * FROM tc_xmf_file ",
              " WHERE tc_xmf00 = '",g_tc_xme.tc_xme00,"'" 
  PREPARE t520_pb1 FROM l_sql
  DECLARE t520_bcs1 CURSOR WITH HOLD FOR t520_pb1
  LET l_ac = 1
  FOREACH t520_bcs1 INTO g_tc_xmf[l_ac].*

     --UPDATE xmf_file SET ta_xmf04 = g_tc_xmf[l_ac].tc_xmf07,
                         --ta_xmf05 = g_tc_xmf[l_ac].tc_xmf08
       --WHERE xmf01 = g_tc_xme.tc_xme01 
         --AND xmf02 = g_tc_xme.tc_xme02 
         --AND xmf03 = g_tc_xmf[l_ac].tc_xmf03
         --AND xmf04 = g_tc_xmf[l_ac].tc_xmf04
         --AND xmf05 = g_today
         --AND ta_xmf02 = g_tc_xme.tc_xme06   
         --AND ta_xmf03 = g_tc_xmf[l_ac].tc_xmf06   
     IF cl_null(g_tc_xmf[l_ac].tc_xmf09) THEN
            CONTINUE FOREACH 
     END IF 
     SELECT COUNT(*) INTO l_num FROM tc_ims_file WHERE tc_ims01 = g_tc_xmf[l_ac].tc_xmf03
         IF l_num >0 THEN 
             UPDATE tc_ims_file SET tc_ims02 = g_tc_xmf[l_ac].tc_xmf09 
             WHERE tc_ims01 = g_tc_xmf[l_ac].tc_xmf03 
         ELSE 
            INSERT INTO tc_ims_file (tc_ims01,tc_ims02) 
            VALUES (g_tc_xmf[l_ac].tc_xmf03,g_tc_xmf[l_ac].tc_xmf09)
         END IF
    LET l_ac = l_ac + 1
  END FOREACH 
  #str----end by huanglf170313
  IF g_success = 'N' THEN ROLLBACK WORK END IF 
  IF g_success = 'Y' THEN COMMIT WORK 
  CALL cl_set_act_visible("modify,delete,invalid", FALSE)   #修改、删除、有效/无效都不可做，出现“核”的图片
  END IF
 END FUNCTION

FUNCTION t520_z()   #取消审核

    DEFINE l_qcf22 LIKE qcf_file.qcf22,
            l_ima903 LIKE ima_file.ima903,
            l_tot1   LIKE ima_file.ima271,
            l_tot2   LIKE ima_file.ima271,
            l_n      LIKE type_file.num5
    LET g_success = 'Y'
    SELECT * INTO g_tc_xme.* FROM tc_xme_file
    WHERE tc_xme00 = g_tc_xme.tc_xme00

    IF g_tc_xme.tc_xmeconf = 'N' THEN 
        CALL cl_err('',9023,0)
        LET g_success = 'N'
        RETURN 
    END IF 

    IF g_tc_xme.tc_xmeconf = 'X' THEN 
        CALL cl_err('',9024,0)
        LET g_success = 'N'
    END IF 

    --IF g_tc_xme.tc_xmeacti = 'N' THEN 
        --CALL cl_err('',9025,0)
        --LET g_success = 'N'
    --END IF 

    IF cl_null(g_tc_xme.tc_xme00) THEN 
        CALL cl_err('','9033',0)
        LET g_success = 'N'
        RETURN 
    END IF 

{    IF NOT cl_confirm('aap-017') THEN 
        RETURN
    END IF }
    LET g_tc_xme_t.* = g_tc_xme.*
    BEGIN WORK

    OPEN t520_cl USING g_tc_xme.tc_xme00
    
    IF STATUS THEN 
        CALL cl_err("OPEN t520_cl:",STATUS ,1)
        CLOSE t520_cl
        RETURN 
    END IF 

    FETCH t520_cl INTO g_tc_xme.*
    IF SQLCA.sqlcode THEN 
        CALL cl_err(g_tc_xme.tc_xme00,SQLCA.sqlcode,0)
        CLOSE t520_cl
        RETURN 
    END IF 
   
    UPDATE tc_xme_file SET tc_xmeconf = 'N',tc_xmemodu = user,tc_xmedate = g_today
            WHERE tc_xme00 = g_tc_xme.tc_xme00
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
        CALL cl_err3("upd","tc_xme_file",g_tc_xme.tc_xme00,"",SQLCA.sqlcode,"","",0)##
        LET g_success = 'N'
    END IF 
    IF g_success = 'N' THEN ROLLBACK WORK END IF 
    IF g_success = 'Y' THEN COMMIT WORK 
    CALL cl_set_act_visible("modify,delete,invalid", TRUE)#修改、删除、有效/无效都不可做，出现“核”的图片
    END IF 

END FUNCTION

# FUNCTION t520_ins()
# DEFINE l_xme        RECORD LIKE xme_file.*
# DEFINE l_x,l_i      LIKE type_file.num5
# DEFINE l_sql        STRING 
# DEFINE l_tc_xmf     RECORD LIKE tc_xmf_file.*
# DEFINE l_xmf        RECORD LIKE xmf_file.*

#      SELECT COUNT(*) INTO l_x FROM xme_file WHERE xme01 = g_tc_xme.tc_xme01 AND xme02 = g_tc_xme.tc_xme02 AND xme00='1'  AND ta_xme01 = g_tc_xme.tc_xme06
#      IF l_x >0 THEN 
#         LET l_sql = "SELECT * FROM tc_xmf_file WHERE tc_xmf00 = '",g_tc_xme.tc_xme00,"'"
#         PREPARE t520_tc_xmf_prepare1 FROM l_sql
#         IF STATUS THEN
#            CALL cl_err('pre',STATUS,1)
#            LET g_success = 'N'
#            RETURN
#         END IF
#         DECLARE t520_tc_xmf_cs1 CURSOR FOR t520_tc_xmf_prepare1 
#         LET l_i = 1
#         INITIALIZE l_tc_xmf.* TO NULL
#         INITIALIZE l_xmf.* TO NULL
#         FOREACH t520_tc_xmf_cs1 INTO l_tc_xmf.*
#            SELECT COUNT(*) INTO l_i FROM xmf_file 
#             WHERE xmf01 = g_tc_xme.tc_xme01 
#               AND xmf02 = g_tc_xme.tc_xme02 
#               AND xmf03 = l_tc_xmf.tc_xmf03
#               AND xmf04 = l_tc_xmf.tc_xmf04
#               AND xmf05 = g_today
#               AND ta_xmf02 = g_tc_xme.tc_xme06   #add by guanyao160711
#            IF l_i > 0 THEN 
#               UPDATE xmf_file SET xmf07 = l_tc_xmf.tc_xmf05
#                                WHERE xmf01 = g_tc_xme.tc_xme01 
#                                  AND xmf02 = g_tc_xme.tc_xme02 
#                                  AND xmf03 = l_tc_xmf.tc_xmf03
#                                  AND xmf04 = l_tc_xmf.tc_xmf04
#                                  AND xmf05 = g_today
#                                  AND ta_xmf02 = g_tc_xme.tc_xme06   #add by guanyao160711
#                                  AND ta_xmf03 = l_tc_xmf.tc_xmf06   #add by guanyao160715
#               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
#                  CALL cl_err3("upd","xmf_file",g_tc_xme.tc_xme01,g_tc_xme.tc_xme02,SQLCA.sqlcode,"","",0)
#                  LET g_success = 'N'
#                  EXIT FOREACH 
#               END IF
#            ELSE 
#               LET l_xmf.xmf01 = g_tc_xme.tc_xme01
#               LET l_xmf.xmf02 = g_tc_xme.tc_xme02
#               LET l_xmf.xmf03 = l_tc_xmf.tc_xmf03
#               LET l_xmf.xmf04 = l_tc_xmf.tc_xmf04
#               LET l_xmf.xmf05 = g_today
#               LET l_xmf.xmf07 = l_tc_xmf.tc_xmf05
#               LET l_xmf.xmf08 = 100
#               LET l_xmf.ta_xmf01 = g_tc_xme.tc_xme03    #str—add by huanglf 160707
#               LET l_xmf.ta_xmf02 = g_tc_xme.tc_xme06   #add by guanyao160711
#               LET l_xmf.ta_xmf03 = l_tc_xmf.tc_xmf06   #add by guanyao160715
#               LET l_xmf.ta_xmf04 = l_tc_xmf.tc_xmf07   #add by huanglf170317  
#               LET l_xmf.ta_xmf05 = l_tc_xmf.tc_xmf08   #add by huanglf170317
#               INSERT INTO xmf_file VALUES l_xmf.*
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err3("ins","xmf_file",l_xmf.xmf01,l_xmf.xmf02,SQLCA.sqlcode,"","",1) 
#                  LET g_success = 'N'
#                  EXIT FOREACH 
#               END IF
#            END IF  
#         END FOREACH 
#      ELSE 
#         INITIALIZE l_xme.* TO NULL
#         LET l_xme.xme00 = '1'
#         LET l_xme.xme01 = g_tc_xme.tc_xme01
#         LET l_xme.xme02 = g_tc_xme.tc_xme02
#         LET l_xme.xmeuser=g_user
#         LET l_xme.xmeoriu = g_user #FUN-980030
#         LET l_xme.xmeorig = g_grup #FUN-980030
#         LET l_xme.xmegrup=g_grup
#         LET l_xme.xmedate=g_today  
#         LET l_xme.ta_xme01 = g_tc_xme.tc_xme06  #add by guanyao161711
#         LET l_xmf.ta_xmf03 = l_tc_xmf.tc_xmf06   #add by guanyao160715
#         INSERT INTO xme_file VALUES (l_xme.*)
#         IF SQLCA.sqlcode THEN                         
#            CALL cl_err3("ins","xme_file",g_tc_xme.tc_xme01,g_tc_xme.tc_xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
#            LET g_success = 'N'
#            RETURN 
#         END IF
#         LET l_sql = "SELECT * FROM tc_xmf_file WHERE tc_xmf00 = '",g_tc_xme.tc_xme00,"'"
#         PREPARE t520_tc_xmf_prepare FROM l_sql
#         IF STATUS THEN
#            CALL cl_err('pre',STATUS,1)
#            LET g_success = 'N'
#            RETURN
#         END IF
#         DECLARE t520_tc_xmf_cs CURSOR FOR t520_tc_xmf_prepare 
#         LET l_i = 1
#         INITIALIZE l_tc_xmf.* TO NULL
#         INITIALIZE l_xmf.* TO NULL
#         FOREACH t520_tc_xmf_cs INTO l_tc_xmf.*
#            LET l_xmf.xmf01 = g_tc_xme.tc_xme01
#            LET l_xmf.xmf02 = g_tc_xme.tc_xme02
#            LET l_xmf.xmf03 = l_tc_xmf.tc_xmf03
#            LET l_xmf.xmf04 = l_tc_xmf.tc_xmf04
#            LET l_xmf.xmf05 = g_today
#            LET l_xmf.xmf07 = l_tc_xmf.tc_xmf05
#            LET l_xmf.xmf08 = 100
#            LET l_xmf.ta_xmf01 = g_tc_xme.tc_xme03    #str—add by huanglf 160707
#            LET l_xmf.ta_xmf02 = g_tc_xme.tc_xme06   #add by guanyao160711
#            LET l_xmf.ta_xmf03 = l_tc_xmf.tc_xmf06   #add by guanyao160715
#            INSERT INTO xmf_file VALUES l_xmf.*
#            IF SQLCA.sqlcode THEN
#               CALL cl_err3("ins","xmf_file",l_xmf.xmf01,l_xmf.xmf02,SQLCA.sqlcode,"","",1) 
#               LET g_success = 'N'
#               EXIT FOREACH 
#            END IF 
#         END FOREACH 
#      END IF 
# END FUNCTION 


FUNCTION t520_pic()
    IF g_tc_xme.tc_xmeconf='Y' THEN 
        LET g_chr='Y' 
    ELSE 
        LET g_chr='N' 
    END IF
    LET g_chr2= 'N'
    
    CALL cl_set_field_pic1(g_chr,""  ,""  ,""  ,"","",""    ,g_chr2)
END FUNCTION
#------------------------No.FUN-620009 end-----------------------------

#darcy:2023/03/27 add s---
function t520_ef()
   DEFINE l_tc_xmeacti LIKE tc_xme_file.tc_xmeacti   #MOD-B90091 add

   select tc_xmeacti into l_tc_xmeacti from tc_xme_file where tc_xme00 = g_tc_xme.tc_xme00

   # CALL t520_y_chk() 
   # IF g_success = "N" THEN
   #    RETURN
   # END IF
  
   # UPDATE tc_xme_file SET tc_xmeacti='S' WHERE tc_xme00 = g_tc_xme.tc_xme00 

   CALL aws_condition()                            #判斷送簽資料
   IF g_success = 'N' THEN
      RETURN
   END IF

##########
# CALL aws_efcli()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
      IF aws_efcli2(base.TypeInfo.create(g_tc_xme),base.TypeInfo.create(g_tc_xmf),'','','','')
      THEN
          LET g_success = 'Y'
          LET g_tc_xme.tc_xmeacti = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
          UPDATE tc_xme_file SET tc_xmeacti = g_tc_xme.tc_xmeacti 
           WHERE tc_xme00 = g_tc_xme.tc_xme00  #MOD-B90091 add
          DISPLAY BY NAME g_tc_xme.tc_xmeacti
      ELSE
          LET g_success = 'N'
      END IF
end function
#darcy:2023/03/27 add e---
