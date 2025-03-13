# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli014 (FUN-770086 copy from agli142)
# Descriptions...: 合併報表長期投資認列分錄維護作業
# Date & Author..: 07/07/27 By kim
# Modify.........: No.FUN-780068 07/11/15 By Sarah 當不使用多帳別功能時，隱藏npptype
# Modify.........: No.FUN-910001 09/01/02 By Sarah 改CALL i014_bp4()
# Modify.........: NO.FUN-920150 09/02/20 by Yiting 把原本在i014.4gl的程式段拉回
#                  1.agli014單頭新開npp07顯示營運中心 DISPLAY ONLY(QBE/INPUT 時要有開窗及AFTER FIELD檢查的功能，依azp_file)
#                  2.整支程式中只要有SELECT的部份，都要加上跨資料庫的處理
#                  3.寫入npq_file時，本幣/原幣金額需依azi04做小數位數取位 ，CALL cl_digcut
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/07/26 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現(已取消跨庫修改）
# Modify.........: No:TQC-AA0138 10/10/28 By Yinhy 查詢時，按TAB鍵進入營運中心編號npp06欄位，此時點“退出"程序可能down出
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No:FUN-AC0063 11/02/09 By Summer 有輸入異動碼5-8的欄位後要檢核
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No:FUN-B50105 11/05/23 By zhangweib aaz88範圍修改為0~4 添加azz125 營運部門資訊揭露使用異動碼數(5-8)
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No.TQC-BA0065 11/11/01 by Dido 切換資料庫前需先關閉資料庫 
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti
# Modify.........: No:FUN-D40105 13/06/27 By yangtt INSERT INTO npq_file增加npqlegal

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-BA0012
#FUN-BA0006 
DEFINE g_npp                 RECORD LIKE npp_file.*,
       g_npq                 DYNAMIC ARRAY of RECORD    #程式變數(Program Variables)
                    npq02     LIKE npq_file.npq02,
                    npq03     LIKE npq_file.npq03,
                    aag02     LIKE aag_file.aag02,
                    npq05     LIKE npq_file.npq05,
                    npq05_d   LIKE gem_file.gem02,   #FUN-920112 
                    npq06     LIKE npq_file.npq06,
                    npq24     LIKE npq_file.npq24,
                    npq25     LIKE npq_file.npq25,
                    npq07f    LIKE npq_file.npq07f,
                    npq07     LIKE npq_file.npq07,
                    npq21     LIKE npq_file.npq21,
                    npq22     LIKE npq_file.npq22,
                    npq23     LIKE npq_file.npq23,
                    npq15     LIKE npq_file.npq15,
                    npq08     LIKE npq_file.npq08,
                    npq11     LIKE npq_file.npq11,
                    npq12     LIKE npq_file.npq12,
                    npq13     LIKE npq_file.npq13,
                    npq14     LIKE npq_file.npq14,
                    npq31     LIKE npq_file.npq31,  #異動碼5
                    npq32     LIKE npq_file.npq32,  #異動碼6
                    npq33     LIKE npq_file.npq33,  #異動碼7
                    npq34     LIKE npq_file.npq34,  #異動碼8
                    npq35     LIKE npq_file.npq35,  #異動碼9
                    npq36     LIKE npq_file.npq36,  #異動碼10
                    npq37     LIKE npq_file.npq37,  #關係人異動碼
                    npq04     LIKE npq_file.npq04
                             END RECORD,
       g_npq_t               RECORD                 #程式變數(Program Variables)
                    npq02     LIKE npq_file.npq02,
                    npq03     LIKE npq_file.npq03,
                    aag02     LIKE aag_file.aag02,
                    npq05     LIKE npq_file.npq05,
                    npq05_d   LIKE gem_file.gem02,   #FUN-920112 
                    npq06     LIKE npq_file.npq06,
                    npq24     LIKE npq_file.npq24,
                    npq25     LIKE npq_file.npq25,
                    npq07f    LIKE npq_file.npq07f,
                    npq07     LIKE npq_file.npq07,
                    npq21     LIKE npq_file.npq21,
                    npq22     LIKE npq_file.npq22,
                    npq23     LIKE npq_file.npq23,
                    npq15     LIKE npq_file.npq15,
                    npq08     LIKE npq_file.npq08,
                    npq11     LIKE npq_file.npq11,
                    npq12     LIKE npq_file.npq12,
                    npq13     LIKE npq_file.npq13,
                    npq14     LIKE npq_file.npq14,
                    npq31     LIKE npq_file.npq31,  #異動碼5
                    npq32     LIKE npq_file.npq32,  #異動碼6
                    npq33     LIKE npq_file.npq33,  #異動碼7
                    npq34     LIKE npq_file.npq34,  #異動碼8
                    npq35     LIKE npq_file.npq35,  #異動碼9
                    npq36     LIKE npq_file.npq36,  #異動碼10
                    npq37     LIKE npq_file.npq37,  #關係人異動碼
                    npq04     LIKE npq_file.npq04
                             END RECORD,
       g_buf                 LIKE type_file.chr20,         #No.FUN-680098 VARCHAR(20) 
       g_argv1               LIKE type_file.chr2,   #系統別#No.FUN-680098 VARCHAR(2)
       g_argv2               LIKE type_file.num5,   #類別  #No.FUN-680098 SMALLINT
       g_argv3               LIKE type_file.chr20,  #單號  #No.FUN-680098 VARCHAR(20)
       g_argv4               LIKE npq_file.npq07,   #本幣金額
       g_argv5               LIKE aaa_file.aaa01,   #帳別
       g_argv6               LIKE type_file.num5,   #異動序號 #No.FUN-680098  SMALLINT
       g_argv7               LIKE type_file.chr1,   #確認碼   #No.FUN-680098  VARCHAR(1)
       g_argv8               LIKE npp_file.npptype    
#--FUN-920112  start--
DEFINE   g_curs_index    LIKE type_file.num10        
DEFINE   g_row_count     LIKE type_file.num10        
DEFINE   g_chr           LIKE type_file.chr1         
DEFINE   g_cnt           LIKE type_file.num10        
DEFINE   g_msg           LIKE type_file.chr1000      
DEFINE   mi_no_ask       LIKE type_file.num5        
DEFINE   g_jump          LIKE type_file.num10      
DEFINE   g_before_input_done LIKE type_file.num5     
DEFINE   g_dbs_gl        LIKE type_file.chr21     
DEFINE   g_azn02         LIKE azn_file.azn02
DEFINE   g_azn04         LIKE azn_file.azn04,
         g_aaz72         LIKE aaz_file.aaz72,
         g_apz02p        LIKE apz_file.apz02p,
         g_nmz02p        LIKE nmz_file.nmz02p
DEFINE   g_bookno11    LIKE aza_file.aza81   
DEFINE   g_bookno22    LIKE aza_file.aza82   
DEFINE   g_bookno33    LIKE aza_file.aza82   
DEFINE   g_flag        LIKE type_file.chr1   
DEFINE   g_forupd_sql STRING, 
         g_sql           STRING,  
         g_sql1          STRING, 
         g_wc            STRING,
         g_rec_b         LIKE type_file.num5,    
         l_ac            LIKE type_file.num5
DEFINE   l_aag05         LIKE aag_file.aag05,
         l_aag06         LIKE aag_file.aag06,  #借餘或貸餘
         l_aag15         LIKE aag_file.aag15,
         l_aag16         LIKE aag_file.aag16,
         l_aag17         LIKE aag_file.aag17,
         l_aag18         LIKE aag_file.aag18,
         l_aag151        LIKE aag_file.aag151,
         l_aag161        LIKE aag_file.aag161,
         l_aag171        LIKE aag_file.aag171,
         l_aag181        LIKE aag_file.aag181,
         l_aag21         LIKE aag_file.aag21,
         l_aag23         LIKE aag_file.aag23
DEFINE   l_aag31         LIKE aag_file.aag31,
         l_aag32         LIKE aag_file.aag32,
         l_aag33         LIKE aag_file.aag33,
         l_aag34         LIKE aag_file.aag34,
         l_aag35         LIKE aag_file.aag35,
         l_aag36         LIKE aag_file.aag36,
         l_aag37         LIKE aag_file.aag37,
         l_aag311        LIKE aag_file.aag311,
         l_aag321        LIKE aag_file.aag321,
         l_aag331        LIKE aag_file.aag331,
         l_aag341        LIKE aag_file.aag341,
         l_aag351        LIKE aag_file.aag351,
         l_aag361        LIKE aag_file.aag361,
         l_aag371        LIKE aag_file.aag371,
         g_ahe02         LIKE ahe_file.ahe02
DEFINE   g_npq07f_t1,g_npq07_t1     LIKE npq_file.npq07
DEFINE   g_npq07f_t2,g_npq07_t2     LIKE npq_file.npq07
DEFINE   g_azp03         LIKE azp_file.azp03
#--FUN-920112  end--
DEFINE g_npq3          RECORD LIKE npq_file.* #FUN-AC0063 add

MAIN
#     DEFINE   l_time LIKE type_file.chr8           #No.FUN-6A0073
   DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680098 SMALLINT
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                         # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_argv1 = 'CD'
   LET g_argv2 = '1'    #類別
   LET g_argv3 = ARG_VAL(3)    #單號
   LET g_argv4 = ARG_VAL(4)    #本幣金額
   LET g_argv5 = ARG_VAL(5)    #帳別
   LET g_argv6 = ARG_VAL(6)    #異動序號
   LET g_argv7 = ARG_VAL(7)    #確認碼
 
   LET p_row = 3 LET p_col = 10
 
   #OPEN WINDOW i014_w AT p_row,p_col WITH FORM "sub/42f/i014"
   OPEN WINDOW i014_w AT p_row,p_col WITH FORM "agl/42f/agli014"  #FUN-920150
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
  #str FUN-780068 add
  #當不使用多帳別功能時，隱藏npptype
   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("npptype",FALSE)
   END IF
  #end FUN-780068 add
   CALL i014_show_filed()
 
   CALL i014_menu()
 
   CLOSE WINDOW i014_w                               #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i014_menu()
 
   WHILE TRUE
      CALL i014_bp("G") 
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i014_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i014_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i014_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#         WHEN "exporttoexcel"
#            IF cl_chk_act_auth() THEN
#               CALL i014_exporttoexcel()
#            END IF
      END CASE
   END WHILE
END FUNCTION
#FUN-770086
 
#--FUN-920150 start--
FUNCTION i014_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680147 VARCHAR(01)
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npq TO s_npq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION first
         CALL i014_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i014_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i014_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i014_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i014_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
#      ON ACTION exporttoexcel
#         LET g_action_choice = "exporttoexcel"
#         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION help
         LET g_action_choice="help"
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
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
     #ON IDLE 5
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0033 --START
      ON ACTION controls
         LET g_action_choice="controls"
         EXIT DISPLAY
#No.FUN-6B0033 --END
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i014_cs()
DEFINE l_cnt LIKE type_file.num5
 
   LET g_npp.nppsys = g_argv1
   LET g_npp.npp00 = g_argv2
 
   CONSTRUCT BY NAME g_wc ON npptype,npp00,npp01,npp011,npp02,nppglno,npp03 #FUN-670047
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--HCN
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
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(npp06)  
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azp" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO npp06
               NEXT FIELD npp06
         END CASE 
 
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
   LET g_npp.npp06 = ''
   INPUT BY NAME g_npp.npp06 WITHOUT DEFAULTS
 
      AFTER FIELD npp06
         IF cl_null(g_npp.npp06) THEN
             NEXT FIELD npp06
         ELSE
             SELECT COUNT(*) INTO l_cnt 
               FROM azp_file
              WHERE azp01 = g_npp.npp06
             IF l_cnt = 0 THEN
                 CALL cl_err('','aap-025',0)
                 NEXT FIELD npp06
             END IF            
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(npp06)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp" 
               CALL cl_create_qry() RETURNING g_npp.npp06
               DISPLAY BY NAME g_npp.npp06
               NEXT FIELD npp06
         END CASE 
   END INPUT
  
   IF cl_null(g_npp.npp06) THEN RETURN END IF  #No.TQC-AA0138 add 
   #--先依營運中心抓取資料庫--
   SELECT azp03 INTO g_azp03   
     FROM azp_file 
    WHERE azp01= g_npp.npp06

  #-TQC-BA0065-add-
   CALL cl_ins_del_sid(2,'')
   CLOSE DATABASE
   DATABASE g_azp03  
   CALL cl_ins_del_sid(1,g_npp.npp06) 
  #-TQC-BA0065-end-
 
   LET g_forupd_sql = " SELECT * FROM npp_file ",
                      "  WHERE npp01 = ?",
                      "    AND npp011 = ?",
                      "    AND nppsys = ?",
                      "    AND npp00 = ?",
                      "    AND npptype = ?",
                      " FOR UPDATE " 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i014_cl CURSOR FROM g_forupd_sql                                
 
   LET g_sql = " SELECT npp01,npp011,nppsys,npp00,npptype FROM npp_file ",
               "  WHERE nppsys='",g_npp.nppsys,"'",
               "    AND npp00 ='",g_npp.npp00,"'",
               "    AND npp06 ='",g_npp.npp06,"'",
               "    AND ", g_wc CLIPPED
   #當只使用一套帳時,查詢資料只要查出主帳別的資料
    IF g_aza.aza63 = 'N' THEN
       LET g_sql = g_sql,"    AND npptype='0'"
    END IF
    LET g_sql = g_sql,"  ORDER BY 1,2"
 
    LET g_sql1= "SELECT COUNT(*) FROM npp_file",
                " WHERE nppsys='",g_npp.nppsys,"'",
                "   AND npp00 ='",g_npp.npp00,"'",
               "    AND npp06 ='",g_npp.npp06,"'",
                "   AND ", g_wc CLIPPED
 
   #當只使用一套帳時,查詢資料只要查出主帳別的資料
    IF g_aza.aza63 = 'N' THEN
       LET g_sql1= g_sql1,"    AND npptype='0'"
    END IF
    PREPARE i014_prepare FROM g_sql
    DECLARE i014_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i014_prepare
    PREPARE i014_co FROM g_sql1
    DECLARE i014_count CURSOR FOR i014_co
END FUNCTION
 
FUNCTION i014_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_npq.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i014_cs()                    #取得查詢條件
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_npp.* TO NULL
      RETURN
   END IF
 
   OPEN i014_cs                      #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      IF g_bgerr THEN
         CALL s_errmsg('','','',SQLCA.sqlcode,0)  
      ELSE
         CALL cl_err('',SQLCA.sqlcode,0)
      END IF
      INITIALIZE g_npp.* TO NULL
   ELSE
      OPEN i014_count
      FETCH i014_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i014_fetch('F')           #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i014_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1   
 
    CASE p_flag
      WHEN 'N' FETCH NEXT     i014_cs INTO g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npp00,g_npp.npptype
      WHEN 'P' FETCH PREVIOUS i014_cs INTO g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npp00,g_npp.npptype
      WHEN 'F' FETCH FIRST    i014_cs INTO g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npp00,g_npp.npptype
      WHEN 'L' FETCH LAST     i014_cs INTO g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npp00,g_npp.npptype
      WHEN '/'
           IF (NOT mi_no_ask) THEN       #No.FUN-6A0079
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
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
              IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
           END IF
           FETCH ABSOLUTE g_jump i014_cs INTO g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npp00,g_npp.npptype
           LET mi_no_ask = FALSE         #No.FUN-6A0079
    END CASE
    IF SQLCA.sqlcode THEN
       IF g_bgerr THEN
          CALl s_errmsg('','',g_npp.npp01,SQLCA.sqlcode,0)
       ELSE
          CALL cl_err(g_npp.npp01,SQLCA.sqlcode,0)
       END IF
        RETURN
    END IF
#--FUN-920150 start----
    #SELECT * INTO g_npp.* FROM npp_file WHERE rowid = g_npp_rowid
    SELECT * INTO g_npp.* FROM npp_file WHERE npp01 = g_npp.npp01
      AND npp011 = '1'
      AND nppsys = 'CD'
      AND npp00  = '1'
      AND npptype = '0'
#--FUN-920150 end---
 
    IF SQLCA.sqlcode THEN
       IF g_bgerr THEN
          CALL s_errmsg('','',g_npp.npp01,SQLCA.sqlcode,1)
       ELSE
          CALL cl_err(g_npp.npp01,SQLCA.sqlcode,1)
       END IF
       INITIALIZE g_npp.* TO NULL
       RETURN
    ELSE
       CALL i014_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    END IF
END FUNCTION
 
FUNCTION i014_show()
  DEFINE l_sysdes   LIKE ze_file.ze03     
  DEFINE l_np0des   LIKE ze_file.ze03,
         l_sql      STRING  
 
   #將資料顯示在畫面上
   DISPLAY BY NAME g_npp.npptype,g_npp.nppsys,g_npp.npp00,g_npp.npp01, #FUN-670047 新增g_npp.npptype
                   g_npp.npp011,g_npp.nppglno,g_npp.npp03
   DISPLAY BY NAME g_npp.npp02,g_npp.npp06
 
   CASE g_argv1       #系統別
       WHEN 'CD'   #合併報表
           CALL cl_getmsg('agl-953',g_lang) RETURNING l_sysdes
           LET g_argv2 = g_npp.npp00
           CASE g_argv2
              WHEN  1   #長期投資認列
                 CALL cl_getmsg('agl-954',g_lang) RETURNING l_np0des
              OTHERWISE EXIT CASE
           END CASE
       OTHERWISE EXIT CASE
   END CASE
 
#-->取總帳系統參數
   #LET l_sql = "SELECT aaz72  FROM CLIPPED ",
   LET l_sql = "SELECT aaz72  FROM ",   #FUN-920150 mod
               "aaz_file WHERE aaz00 = '0' "
   PREPARE chk_pregl FROM l_sql
   DECLARE chk_curgl CURSOR FOR chk_pregl
   OPEN chk_curgl
   FETCH chk_curgl INTO g_aaz72
   IF SQLCA.sqlcode THEN LET g_aaz72 = '1' END IF
 
   IF g_aza.aza63 = 'Y' THEN
      IF NOT cl_null(g_argv5) THEN
         SELECT aznn02,aznn04 FROM aznn_file
          WHERE aznn01 =g_npp.npp03
                    AND aznn00 = g_argv5
      ELSE
         SELECT aznn02,aznn04 FROM  aznn_file 
          WHERE aznn01 = g_npp.npp03
            AND aznn00 = g_npp.npp07
      END IF
   ELSE
      SELECT azn02,azn04 INTO g_azn02,g_azn04  FROM azn_file
       WHERE azn01 = g_npp.npp03     #(傳票日)
   END IF  
   IF SQLCA.sqlcode THEN LET g_azn02 = NULL LET g_azn04 = NULL END IF
   DISPLAY l_sysdes,l_np0des,g_azn02,g_azn04 TO sysdes,np0des,azn02,azn04
 
   LET g_bookno33 = g_npp.npp07  #帳別
   CALL i014_b_fill()
   CALL i014_chk()
END FUNCTION
 
FUNCTION i014_b_fill()
    LET g_sql = " SELECT npq02,npq03,aag02,npq05,'',npq06,npq24,npq25,npq07f,npq07, ",
                "   npq21,npq22,npq23,npq15,npq08,npq11,npq12,npq13,npq14,",
                "   npq31,npq32,npq33,npq34,npq35,npq36,npq37,", 
                "   npq04",
                "   FROM npq_file LEFT OUTER JOIN aag_file ON npq03  = aag01 AND aag00 = '",g_bookno33,"'",
                "  WHERE npqsys ='",g_npp.nppsys,"'",
                "    AND npq00 = '",g_npp.npp00,"'", 
                "    AND npq01 = '",g_npp.npp01,"'",
                "    AND npq011= '",g_npp.npp011,"'",
                "    AND npqtype = '",g_npp.npptype,"'",
                "  ORDER BY npq02 "
    PREPARE i014_npq_pre FROM g_sql
    DECLARE i014_npq_curs CURSOR FOR i014_npq_pre
    CALL g_npq.clear()
    LET g_cnt = 1
    FOREACH i014_npq_curs INTO g_npq[g_cnt].*              #單身 ARRAY 填充
        IF STATUS THEN 
           IF g_bgerr THEN 
              CALL s_errmsg('','','foreach:',STATUS,1)
           ELSE
              CALL cl_err('foreach:',STATUS,1)
           END IF
        EXIT FOREACH END IF
        SELECT gem02 INTO g_npq[g_cnt].npq05_d FROM gem_file
          WHERE gem01 = g_npq[g_cnt].npq05
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           IF g_bgerr THEN
              CALL s_errmsg('','','', 9035, 0 )
           ELSE
              CALL cl_err( '', 9035, 0 )
           END IF
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_npq.deleteElement(g_cnt)
    LET g_rec_b= g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION i014_r()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_npp.npp00 IS NULL  OR g_npp.npp01 IS NULL OR 
       g_npp.npp011 IS NULL OR g_npp.nppsys IS NULL THEN 
       IF g_bgerr THEN
          CALL s_errmsg('','','',-400,0)
       ELSE
          CALL cl_err('',-400,0) 
       END IF
      RETURN 
    END IF
    #-->已產生傳票不可修改
    IF NOT cl_null(g_npp.nppglno) THEN
       IF g_bgerr THEN
          CALL s_errmsg('','',g_npp.npp01,'aap-145',0)
       ELSE
          CALL cl_err(g_npp.npp01,'aap-145',0) 
       END IF
     RETURN
    END IF
 
    BEGIN WORK
 
    OPEN i014_cl USING g_npp.npp01,g_npp.npp011,g_npp.nppsys,
                       g_npp.npp00,g_npp.npptype
    IF STATUS THEN
       IF g_bgerr THEN
          CALL s_errmsg('','',"OPEN i014_cl:",STATUS, 1)
       ELSE 
          CALL cl_err("OPEN i014_cl:", STATUS, 1)
       END IF
       CLOSE i014_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i014_cl INTO g_npp.*
    IF SQLCA.sqlcode THEN
       IF g_bgerr THEN
          CALL s_errmsg('','',g_npp.npp01,SQLCA.sqlcode,0) 
       ELSE
          CALL cl_err(g_npp.npp01,SQLCA.sqlcode,0)
       END IF
       CLOSE i014_cl
       ROLLBACK WORK 
       RETURN
    END IF
 
    IF NOT cl_delh(20,16) THEN RETURN END IF
    DELETE FROM npp_file WHERE npp00  =g_npp.npp00
                           AND npp01  =g_npp.npp01
                           AND npp011 =g_npp.npp011
                           AND nppsys =g_npp.nppsys
                           AND npptype=g_npp.npptype     #No.FUN-670047
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
       IF g_bgerr THEN
          LET g_showmsg=g_npp.npp00,"/",g_npp.npp01,"/",g_npp.npp011,"/",g_npp.nppsys,"/",g_npp.npptype
          CALL s_errmsg('npp0,npp01,npp011,nppsys,npptype',g_showmsg,"del npp",SQLCA.sqlcode,1) 
       ELSE
          CALL cl_err3("del","npp_file",g_npp.npp00,g_npp.npp01,SQLCA.sqlcode,"","del npp",1)
       END IF
       LET g_success = 'N'
    END IF   
 
    DELETE FROM npq_file WHERE npq00  =g_npp.npp00
                           AND npq01  =g_npp.npp01
                           AND npq011 =g_npp.npp011
                           AND npqsys =g_npp.nppsys
                           AND npqtype=g_npp.npptype     #No.FUN-670047
    IF SQLCA.sqlcode THEN
       IF g_bgerr THEN                                                                                                              
          LET g_showmsg=g_npp.npp00,"/",g_npp.npp01,"/",g_npp.npp011,"/",g_npp.nppsys,"/",g_npp.npptype
          CALL s_errmsg('npp0,npp01,npp011,nppsys,npptype',g_showmsg,"del npp",SQLCA.sqlcode,1)                                     
       ELSE
          CALL cl_err3("del","npq_file",g_npp.npp00,g_npp.npp01,SQLCA.sqlcode,"","del npq",1)
       END IF
       LET g_success = 'N'
    END IF   
 
    CLEAR FORM
    CALL g_npq.clear()
 
    MESSAGE ""
    OPEN i014_count
    #FUN-B50062-add-start--
    IF STATUS THEN
       CLOSE i014_cs
       CLOSE i014_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50062-add-end-- 
    FETCH i014_count INTO g_row_count
    #FUN-B50062-add-start--
    IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
       CLOSE i014_cs
       CLOSE i014_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50062-add-end-- 
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i014_cs
    IF g_curs_index = g_row_count + 1 THEN
       LET g_jump = g_row_count
       CALL i014_fetch('L')
    ELSE
       LET g_jump = g_curs_index
       LET mi_no_ask = TRUE             #No.FUN-6A0079
       CALL i014_fetch('/')
    END IF
 
    IF g_success = 'N' THEN
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF
 
    CLOSE i014_cl
END FUNCTION
 
FUNCTION i014_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #No.FUN-680147 SMALLINT     #未取消的ARRAY CNT
    l_row,l_col     LIKE type_file.num5,         #No.FUN-680147 SMALLINT   #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,         #No.FUN-680147 SMALLINT   #檢查重複用
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否
    p_cmd           LIKE type_file.chr1,         #處理狀態
    l_b2     	    LIKE npp_file.npp01,         #No.FUN-680147 VARCHAR(30)
    l_str           LIKE type_file.chr1000,      #No.FUN-680147 VARCHAR(80)
    l_buf           LIKE type_file.chr1000,      #No.FUN-680147 VARCHAR(40)
    l_buf1          LIKE type_file.chr1000,      #No.FUN-680147 VARCHAR(40)
    l_cmd           LIKE npp_file.npp01,         #No.FUN-680147 VARCHAR(20)
    l_flag          LIKE type_file.num10,        #No.FUN-680147 INTEGER
    l_flag2         LIKE type_file.num10,        #TQC-7B0006用來判斷是否為AP-13/17類帳款
    l_t1            LIKE apy_file.apyslip,       #TQC-7B0006
    l_afb04         LIKE afb_file.afb04,
    l_afb07         LIKE afb_file.afb07,
    l_afb15         LIKE afb_file.afb15,
    l_amt           LIKE npq_file.npq07,
    l_afb041        LIKE afb_file.afb041,        #No.FUN-910001
    l_afb042        LIKE afb_file.afb042,        #No.FUN-910001
    l_tol           LIKE npq_file.npq07,
    l_tol1          LIKE npq_file.npq07,
    total_t         LIKE npq_file.npq07,
    #t_azi04         LIKE azi_file.azi04,          #No.CHI-6A0004   #MOD-770076
    l_dept          LIKE gem_file.gem01,
    l_nmg20         LIKE nmg_file.nmg20,
    l_allow_insert  LIKE type_file.num5,         #No.FUN-680147 SMALLINT
    l_allow_delete  LIKE type_file.num5,         #No.FUN-680147 SMALLINT   #可刪除否
    l_oob04         LIKE oob_file.oob04   #No.MOD-530748
DEFINE l_fld_name   LIKE type_file.chr10  #FUN-AC0063 add
 
    LET g_action_choice = ""
    IF g_npp.npp01 IS NULL THEN RETURN END IF
    #-->已產生傳票不可修改
    IF NOT cl_null(g_npp.nppglno) THEN
          CALL cl_err(g_npp.npp01,'aap-145',0)
       RETURN
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT npq02,npq03,'',npq05,'',npq06,npq24,npq25, ",   #FUN-810082
                       " npq07f,npq07,npq21,npq22,npq23,npq15,npq08, ",
                       " npq11,npq12,npq13,npq14, ",
                       " npq31,npq32,npq33,npq34,npq35,npq36,npq37 ",
                       ",npq04 ",
                       " FROM npq_file ",
                       " WHERE npqsys = ? AND npq00 = ? AND npq01 = ? ",
                       " AND npq011 = ? AND npq02 = ? AND npqtype = ? FOR UPDATE "  #No.FUN-670047 增加npqtype
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i014_bcl CURSOR  FROM g_forupd_sql      # LOCK CURSOR
 
      LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_npq.clear() END IF
 
      INPUT ARRAY g_npq WITHOUT DEFAULTS FROM s_npq.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            LET g_success='Y'
            BEGIN WORK
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_npq_t.* = g_npq[l_ac].*  #BACKUP
                OPEN i014_bcl USING g_npp.nppsys, g_npp.npp00,
                                      g_npp.npp01 , g_npp.npp011,
                                      g_npq_t.npq02,g_npp.npptype  #No.FUN-670047 增加g_npp.npptype
                IF STATUS THEN
                      CALL cl_err("OPEN i014_bcl:", STATUS, 1)
                   CLOSE i014_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i014_bcl INTO g_npq[l_ac].*
                   IF SQLCA.sqlcode THEN
                          CALL cl_err('lock npq',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                   SELECT aag02 INTO g_npq[l_ac].aag02 FROM aag_file
                      WHERE aag01=g_npq[l_ac].npq03
                        AND aag00 = g_bookno33  #No.FUN-730020
                   SELECT gem02 INTO g_npq[l_ac].npq05_d FROM gem_file
                      WHERE gem01 = g_npq[l_ac].npq05
                END IF
                LET g_before_input_done = FALSE
                CALL i014_set_entry_b(p_cmd)
                CALL i014_set_no_entry_b(p_cmd)
                CALL i014_set_no_required()   
                CALL i014_set_required()   
                LET g_before_input_done = TRUE
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              INITIALIZE g_npq[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_npq[l_ac].* TO s_npq.*
              CALL g_npq.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
            END IF
            INSERT INTO npq_file(npqsys,npq00,npq01,npq011,npq02,npq03,
	         	         npq04,npq05,npq06,npq07f,npq07,npq08,
	         	         npq11,npq12,npq13,npq14,
                                 npq31,npq32,npq33,npq34,npq35,npq36,npq37,
                                 npq15,npq21,
	         	         npq22,npq23,npq24,npq25,npqtype,npqlegal) #No.FUN-670047 增加npqtype   #FUN-D40104 add npqlegal
                          VALUES(g_npp.nppsys,g_npp.npp00,g_npp.npp01,
                                 g_npp.npp011,g_npq[l_ac].npq02,
	          		 g_npq[l_ac].npq03,g_npq[l_ac].npq04,
	          		 g_npq[l_ac].npq05,g_npq[l_ac].npq06,
                                 g_npq[l_ac].npq07f,g_npq[l_ac].npq07,
                                 g_npq[l_ac].npq08,g_npq[l_ac].npq11,
                                 g_npq[l_ac].npq12,g_npq[l_ac].npq13,
                                 g_npq[l_ac].npq14,
                                 g_npq[l_ac].npq31,g_npq[l_ac].npq32,
                                 g_npq[l_ac].npq33,g_npq[l_ac].npq34,
                                 g_npq[l_ac].npq35,g_npq[l_ac].npq36,
                                 g_npq[l_ac].npq37,
                                 g_npq[l_ac].npq15,
                                 g_npq[l_ac].npq21,g_npq[l_ac].npq22,
                                 g_npq[l_ac].npq23,g_npq[l_ac].npq24,
                                 g_npq[l_ac].npq25,g_npp.npptype,g_legal) #No.FUN-670047 增加g_npp.npptype  #FUN-D40105 add g_legal
            IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","npq_file",g_npp.npp01,"",STATUS,"","",1) #FUN-670091
               LET g_success = 'N'
               ROLLBACK WORK
               CANCEL INSERT
            END IF
            IF g_success='Y' THEN
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              MESSAGE 'Insert Ok'
            ELSE
              ROLLBACK WORK
              CANCEL INSERT
            END IF
            CALL i014_chk()
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET g_before_input_done = FALSE
            CALL i014_set_entry_b(p_cmd)
            CALL i014_set_no_entry_b(p_cmd)
            CALL i014_set_no_required()   #MOD-680003
            CALL i014_set_required()   #MOD-680003
            LET g_before_input_done = TRUE
            LET l_n = ARR_COUNT()
            INITIALIZE g_npq[l_ac].* TO NULL      #900423
            LET g_npq_t.* = g_npq[l_ac].*  #BACKUP
            IF l_ac > 1 THEN
               LET g_npq[l_ac].npq21 = g_npq[l_ac-1].npq21  #廠商編號
               LET g_npq[l_ac].npq22 = g_npq[l_ac-1].npq22  #廠商簡稱
               LET g_npq[l_ac].npq23 = g_npq[l_ac-1].npq23  #參考單號
               LET g_npq[l_ac].npq24 = g_npq[l_ac-1].npq24  #幣別
               LET g_npq[l_ac].npq25 = g_npq[l_ac-1].npq25  #匯率
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD npq02
 
        BEFORE FIELD npq02                       #default 行序
            IF cl_null(g_npq[l_ac].npq02) OR g_npq[l_ac].npq02=0 THEN
               SELECT max(npq02)+1 INTO g_npq[l_ac].npq02 FROM npq_file
                WHERE npqsys = g_npp.nppsys AND npq00 = g_npp.npp00
                  AND npq01  = g_npp.npp01  AND npq011= g_npp.npp011
                  AND npqtype = g_npp.npptype  #FUN-670047
               IF g_npq[l_ac].npq02 IS NULL THEN
                  LET g_npq[l_ac].npq02=1
               END IF
            END IF
 
        AFTER FIELD npq02                         #check是否重複
            IF NOT cl_null(g_npq[l_ac].npq02) THEN
               IF g_npq[l_ac].npq02 != g_npq_t.npq02 OR
                  g_npq_t.npq02 IS NULL THEN
                  SELECT COUNT(*) INTO g_cnt FROM npq_file
                  WHERE npqsys = g_npp.nppsys AND npq00 = g_npp.npp00
                    AND npq01  = g_npp.npp01  AND npq011= g_npp.npp011
                    AND npq02  = g_npq[l_ac].npq02
                    AND npqtype= g_npp.npptype  #FUN-670047
                  IF g_cnt > 0 THEN
                        CALL cl_err('',-239,0) 
                     NEXT FIELD npq02
                  END IF
               END IF
            END IF
 
        AFTER FIELD npq03     #會計科目
            IF NOT cl_null(g_npq[l_ac].npq03) THEN
               SELECT aag02,aag05,aag15,aag16,aag17,aag18,aag151,
                        aag161,aag171,aag181,aag06,aag21,aag23,
                        aag31,aag32,aag33,aag34,aag35,aag36,aag37,
                        aag311,aag321,aag331,aag341,aag351,aag361,aag371
                   INTO g_npq[l_ac].aag02,l_aag05,l_aag15,l_aag16,
                        l_aag17,l_aag18,l_aag151,l_aag161,l_aag171,
                        l_aag181,l_aag06,l_aag21,l_aag23,
                        l_aag31,l_aag32,l_aag33,l_aag34,l_aag35,l_aag36,
                        l_aag37,l_aag311,l_aag321,l_aag331,l_aag341,l_aag351,
                        l_aag361,l_aag371
                   FROM aag_file
                WHERE aag01=g_npq[l_ac].npq03
                  AND aag07 !='1'      #不可為統制帳戶 NO:4756
                  AND aag00 = g_bookno33  #No.FUN-730020
               IF STATUS THEN
                  CALL cl_err3("sel","aag_file",g_npq[l_ac].npq03,"",STATUS,"","",0)  #FUN-670091  #Mod No.FUN-B10048
                 #Mod No.FUN-B10048
                 #LET g_npq[l_ac].npq03 = g_npq_t.npq03
                  LET g_qryparam.form = 'q_aag'
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = g_npq[l_ac].npq03
                  LET g_qryparam.arg1 = g_bookno33  #No.FUN-730020
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag01 LIKE '",g_npq[l_ac].npq03 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq03
                  DISPLAY g_npq[l_ac].npq03 TO npq03
                 #End Mod No.FUN-B10048
                  NEXT FIELD npq03
               END IF
               IF l_aag05 MATCHES '[Nn]' THEN
                   LET g_npq[l_ac].npq05=NULL   #MOD-680003
                   DISPLAY BY NAME g_npq[l_ac].npq05           #No.MOD-510119
               END IF
 
               IF l_aag05='Y' AND NOT cl_null(g_npq[l_ac].npq05) THEN 
                  CALL s_chkdept(g_aaz.aaz72,g_npq[l_ac].npq03,g_npq[l_ac].npq05,g_bookno33) RETURNING g_errno  
               END IF 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD npq03
               END IF
 
               IF l_aag21 MATCHES '[Nn]' THEN
                   LET g_npq[l_ac].npq15=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq15
               END IF
               IF l_aag23 MATCHES '[Nn]' THEN
                   LET g_npq[l_ac].npq08=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq08
               END IF
               IF cl_null(l_aag151) THEN
                  LET g_npq[l_ac].npq11=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq11           #No.MOD-510119
               END IF
               IF cl_null(l_aag161) THEN
                  LET g_npq[l_ac].npq12=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq12           #No.MOD-510119
               END IF
               IF cl_null(l_aag171)  THEN
                  LET g_npq[l_ac].npq13=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq13           #No.MOD-510119
               END IF
               IF cl_null(l_aag181) THEN
                  LET g_npq[l_ac].npq14=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq14           #No.MOD-510119
               END IF
 
               IF cl_null(l_aag311) THEN
                  LET g_npq[l_ac].npq31=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq31
               END IF
               IF cl_null(l_aag321) THEN
                  LET g_npq[l_ac].npq32=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq32
               END IF
               IF cl_null(l_aag331) THEN
                  LET g_npq[l_ac].npq33=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq33
               END IF
               IF cl_null(l_aag341) THEN
                  LET g_npq[l_ac].npq34=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq34
               END IF
               IF cl_null(l_aag351) THEN
                  LET g_npq[l_ac].npq35=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq35
               END IF
               IF cl_null(l_aag361) THEN
                  LET g_npq[l_ac].npq36=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq36
               END IF
               IF cl_null(l_aag371) THEN
                  LET g_npq[l_ac].npq37=NULL
                   DISPLAY BY NAME g_npq[l_ac].npq37
               END IF
            ELSE    #MOD-5B0205
               NEXT FIELD npq03   #MOD-5B0205
            END IF
            LET g_before_input_done = FALSE
            CALL i014_set_entry_b(p_cmd)
            CALL i014_set_no_entry_b(p_cmd)
            CALL i014_set_no_required()
            CALL i014_set_required()
            LET g_before_input_done = TRUE
 
        AFTER FIELD npq05     #部門
            IF NOT cl_null(g_npq[l_ac].npq05) THEN
               SELECT gem01 FROM gem_file WHERE gem01=g_npq[l_ac].npq05
                                            AND gemacti='Y'  #NO:4897
               IF STATUS THEN
                     CALL cl_err3("sel","gem_file",g_npq[l_ac].npq05,"",STATUS,"","",1)  #FUN-670091
                    NEXT FIELD npq05
               END IF
 
               IF l_aag05='Y' AND NOT cl_null(g_npq[l_ac].npq03) THEN 
                  CALL s_chkdept(g_aaz.aaz72,g_npq[l_ac].npq03,g_npq[l_ac].npq05,g_bookno33) RETURNING g_errno  
               END IF 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD npq05
               END IF
               SELECT gem02 INTO g_npq[l_ac].npq05_d FROM gem_file
                 WHERE gem01 = g_npq[l_ac].npq05
               IF g_aaz72 = '2' THEN
                    SELECT COUNT(*) INTO g_cnt FROM aab_file
                     WHERE aab01 = g_npq[l_ac].npq03
                       AND aab02 = g_npq[l_ac].npq05
                       AND aab00 = g_bookno33  #No.FUN-730020
                    IF g_cnt = 0 THEN
                          CALL cl_err(g_npq[l_ac].npq05,'agl-209',0)
                       NEXT FIELD npq05
                    END IF
               ELSE SELECT COUNT(*) INTO g_cnt FROM aab_file
                     WHERE aab01 = g_npq[l_ac].npq03
                       AND aab02 = g_npq[l_ac].npq05
                       AND aab00 = g_bookno33  #No.FUN-730020
                    IF g_cnt > 0 THEN
                          CALL cl_err(g_npq[l_ac].npq05,'agl-207',0)
                       NEXT FIELD npq05
                    END IF
               END IF
            END IF
 
            
        AFTER FIELD npq06   #借/貸
            IF g_npq[l_ac].npq06 NOT MATCHES '[12]' THEN
               NEXT FIELD npq06
            END IF
 
        AFTER FIELD npq07f
            IF NOT cl_null(g_npq[l_ac].npq07f) THEN
               SELECT azi04 INTO t_azi04 FROM azi_file
                WHERE azi01=g_npq[l_ac].npq24 AND aziacti = 'Y'
               IF STATUS THEN
                  LET t_azi04 = 0 
               END IF    
               LET g_npq[l_ac].npq07f=cl_digcut(g_npq[l_ac].npq07f,t_azi04)    #No.CHI-6A0004
               IF g_npq[l_ac].npq07f <> g_npq_t.npq07f OR g_npq_t.npq07f IS NULL THEN   #MOD-750137
                  LET g_npq[l_ac].npq07 = g_npq[l_ac].npq07f * g_npq[l_ac].npq25
                  LET g_npq[l_ac].npq07 = cl_digcut(g_npq[l_ac].npq07,g_azi04)   #MOD-770076
                  DISPLAY BY NAME g_npq[l_ac].npq07
               END IF   #MOD-750137
            END IF
 
        AFTER FIELD npq07    #本幣金額
            IF g_npq[l_ac].npq07=0 THEN
               NEXT FIELD npq07
            END IF
            IF NOT cl_null(g_npq[l_ac].npq07) THEN
               LET g_npq[l_ac].npq07=cl_digcut(g_npq[l_ac].npq07,g_azi04)   #No.CHI-6A0004   #MOD-770076
               DISPLAY BY NAME g_npq[l_ac].npq07
            END IF
 
        AFTER FIELD npq24    #幣別
            IF NOT cl_null(g_npq[l_ac].npq24) THEN
               SELECT azi02 INTO g_buf FROM azi_file
                WHERE azi01=g_npq[l_ac].npq24 AND aziacti = 'Y'
               IF STATUS THEN
                      CALL cl_err3("sel","gem_file",g_npq[l_ac].npq05,"",STATUS,"","",1)  #FUN-670091
                   NEXT FIELD npq24
               END IF
               SELECT azi04 INTO t_azi04 FROM azi_file
                WHERE azi01=g_npq[l_ac].npq24 AND aziacti = 'Y'
               IF STATUS THEN
                  LET t_azi04 = 0 
               END IF    
               IF g_npq[l_ac].npq24 != g_npq_t.npq24 OR g_npq_t.npq24 IS NULL THEN
                  CALL i014_npq24()
               END IF
            END IF
 
        AFTER FIELD npq25    #匯率
            IF g_npq[l_ac].npq25=0 THEN
               NEXT FIELD npq25
            END IF
            IF g_npq[l_ac].npq25 <> g_npq_t.npq25 OR g_npq_t.npq25 IS NULL THEN    #MOD-750137
               LET g_npq[l_ac].npq07=g_npq[l_ac].npq07f*g_npq[l_ac].npq25   #MOD-750137 取消mark
            END IF   #MOD-750137
 
        AFTER FIELD npq21     #廠商編號
            IF NOT cl_null(g_npq[l_ac].npq21) THEN
                IF g_npq[l_ac].npq21 IS NULL THEN
                   LET g_npq[l_ac].npq21 = ' '
                   DISPLAY g_npq[l_ac].npq21 TO npq21
                   LET g_npq[l_ac].npq21 = NULL
                   DISPLAY g_npq[l_ac].npq21 TO npq21
                END IF
                IF g_npq[l_ac].npq21 = ' ' THEN
                   LET g_npq[l_ac].npq21 = NULL
                   DISPLAY g_npq[l_ac].npq21 TO npq21
                END IF
            END IF
 
        AFTER FIELD npq15  #預算編號
            IF g_npq[l_ac].npq15 IS NOT NULL AND g_npq[l_ac].npq15 !=' ' THEN
                LET g_argv5 = g_npp.npp07
                IF g_aza.aza63 = 'N' THEN  
                   SELECT azn02,azn04 INTO g_azn02,g_azn04  FROM azn_file
                     WHERE azn01 = g_npp.npp02
                ELSE
                   #LET g_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl CLIPPED,"aznn_file",
                   #LET g_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(g_plant_new,'aznn_file'), #FUN-A50102
                   LET g_sql = " SELECT aznn02,aznn04 FROM  aznn_file ",#FUN-A50102
                               "  WHERE aznn01 = '",g_npp.npp02,"'" ,
                               "    AND aznn00 = '",g_argv5,"'"
                   #CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
                   #CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102 
                   PREPARE aznn_pre FROM g_sql
                   DECLARE aznn_cs CURSOR FOR aznn_pre
                   OPEN aznn_cs
                   FETCH aznn_cs INTO g_azn02,g_azn04
               END IF
               IF g_npq[l_ac].npq05 IS NULL OR g_npq[l_ac].npq05=' ' THEN
                  LET l_dept='@'
               ELSE
                  LET l_dept = g_npq[l_ac].npq05
               END IF
               SELECT afb04,afb15,afb041,afb042 INTO l_afb04,l_afb15,l_afb041,l_afb042
                 FROM afb_file WHERE afb00 = g_argv5 AND
                                     afb01 = g_npq[l_ac].npq15 AND
                                     afb02 = g_npq[l_ac].npq03 AND
                                     afb03 = g_azn02 AND afb04 = l_dept
                                     AND afbacti = 'Y'                         #FUN-D70090 add
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_npq[l_ac].npq15,'agl-139',0)
                  LET g_npq[l_ac].npq15 = g_npq_t.npq15
                  NEXT FIELD npq15
               END IF
               CALL s_getbug(g_argv5,g_npq[l_ac].npq15,g_npq[l_ac].npq03,
                             g_azn02,g_azn04,l_afb04,l_afb15,l_afb041,l_afb042)
                    RETURNING l_flag,l_afb07,l_amt
               IF l_flag THEN
                     CALL cl_err('','agl-139',0) 
               END IF #若不成功#
               IF l_afb07  = '1' THEN #不做超限控制
                  NEXT FIELD npq08
               ELSE
               SELECT aag05 INTO l_aag05 FROM aag_file
                  WHERE aag01 = g_npq[l_ac].npq03
                    AND aag00 = g_bookno33  #No.FUN-730020
               IF l_aag05 = 'Y' THEN 
                   SELECT SUM(npq07) INTO l_tol FROM npq_file,npp_file
                    WHERE npq01 = npp01
                      AND npq03 = g_npq[l_ac].npq03
                      AND npq15 = g_npq[l_ac].npq15 AND npq06 = '1' #借方
                      AND npq05 = g_npq[l_ac].npq05
                      AND YEAR(npp02) = g_azn02
                      AND MONTH(npp02) = g_azn04
                      AND ( npq01 != g_npp.npp01 OR
                           (npq01  = g_npp.npp01 AND
                            npq02 != g_npq[l_ac].npq02))
                   IF SQLCA.sqlcode OR l_tol IS NULL THEN
                      LET l_tol = 0
                   END IF
                   SELECT SUM(npq07) INTO l_tol1 FROM npq_file,npp_file
                    WHERE npq01 = npp01
                      AND npq03 = g_npq[l_ac].npq03
                      AND npq15 = g_npq[l_ac].npq15 AND npq06 = '2' #貸方
                      AND npq05 = g_npq[l_ac].npq05
                      AND YEAR(npp02) = g_azn02
                      AND MONTH(npp02) = g_azn04
                      AND ( npq01 != g_npp.npp01 OR
                           (npq01  = g_npp.npp01 AND
                            npq02 != g_npq[l_ac].npq02))
                   IF SQLCA.sqlcode OR l_tol1 IS NULL THEN
                      LET l_tol1 = 0
                   END IF
               ELSE
                   SELECT SUM(npq07) INTO l_tol FROM npq_file,npp_file
                    WHERE npq01 = npp01
                      AND npq03 = g_npq[l_ac].npq03
                      AND npq15 = g_npq[l_ac].npq15 AND npq06 = '1' #借方
                      AND YEAR(npp02) = g_azn02
                      AND MONTH(npp02) = g_azn04
                      AND ( npq01 != g_npp.npp01 OR
                           (npq01  = g_npp.npp01 AND
                            npq02 != g_npq[l_ac].npq02))
                   IF SQLCA.sqlcode OR l_tol IS NULL THEN
                      LET l_tol = 0
                   END IF
                  SELECT SUM(npq07) INTO l_tol1 FROM npq_file,npp_file
                         WHERE npq01 = npp01
                           AND npq03 = g_npq[l_ac].npq03
                           AND npq15 = g_npq[l_ac].npq15 AND npq06 = '2' #貸方
                            AND YEAR(npp02) = g_azn02
                            AND MONTH(npp02) = g_azn04
                            AND ( npq01 != g_npp.npp01 OR
                                 (npq01  = g_npp.npp01 AND
                                  npq02 != g_npq[l_ac].npq02))
                  IF SQLCA.sqlcode OR l_tol1 IS NULL THEN
                     LET l_tol1 = 0
                  END IF
               END IF   #MOD-620020
                   IF l_aag06 = '1' THEN #借餘
                         LET total_t = l_tol - l_tol1   #借減貸
                   ELSE #貸餘
                         LET total_t = l_tol1 - l_tol   #貸減借
                   END IF
 
                  #IF p_cmd = 'a' THEN #若本筆資料為新增則加上本次輸入的值
                   LET total_t = total_t + g_npq[l_ac].npq07  #no.6353
                   IF total_t > l_amt THEN #借餘大於預算金額
                      CASE l_afb07
                           WHEN '2'
                                   CALL cl_getmsg('agl-140',0) RETURNING l_buf
                                   CALL cl_getmsg('agl-141',0) RETURNING l_buf1
                                   ERROR l_buf CLIPPED,' ',total_t,
                                         l_buf1 CLIPPED,' ',l_amt
                                    NEXT FIELD npq08
                           WHEN '3'
                                   CALL cl_getmsg('agl-142',0) RETURNING l_buf
                                   CALL cl_getmsg('agl-143',0) RETURNING l_buf
                                   ERROR l_buf CLIPPED,' ',total_t,
                                         l_buf1 CLIPPED,' ',l_amt
                                    NEXT FIELD npq15
                      END CASE
                   END IF
               END IF
            END IF
 
        AFTER FIELD npq08
            IF g_npq[l_ac].npq08 IS NOT NULL AND g_npq[l_ac].npq08 != ' ' THEN
               SELECT * FROM gja_file WHERE gja01 = g_npq[l_ac].npq08
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_npq[l_ac].npq08,'agl-007',0)
                  LET g_npq[l_ac].npq08 = g_npq_t.npq08
                  NEXT FIELD npq08
               END IF
            END IF
 
        BEFORE FIELD npq11  #  npq03-npq11-npq12
           IF l_aag15 IS NOT NULL AND l_aag15 != ' ' THEN
                CALL i014_get_ahe02('1')  #FUN-5C0015
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
                LET l_str = l_str CLIPPED,g_ahe02,'!'  #FUN-5C0015
                ERROR l_str
           END IF
 
        AFTER FIELD npq11
         SELECT aag151 INTO l_aag151 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
            CALL s_chk_aee(g_npq[l_ac].npq03,'1',g_npq[l_ac].npq11,g_bookno33)  #No.FUN-730020
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('sel aee:',g_errno,1)
               NEXT FIELD npq11
            END IF
 
        BEFORE FIELD npq12  #  npq11-npq12-npq13
           IF l_aag16 IS NOT NULL AND l_aag16 != ' ' THEN
                CALL i014_get_ahe02('2')  #FUN-5C0015
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
               #LET l_str = l_str CLIPPED,l_aag16,'!'
                LET l_str = l_str CLIPPED,g_ahe02,'!'   #FUN-5C0015
                ERROR l_str
           END IF
 
        AFTER FIELD npq12
         SELECT aag161 INTO l_aag161 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
               CALL s_chk_aee(g_npq[l_ac].npq03,'2',g_npq[l_ac].npq12,g_bookno33)  #No.FUN-730020
               IF NOT cl_null(g_errno) THEN
                     CALL cl_err('sel aee:',g_errno,1)
                  NEXT FIELD npq12
               END IF
 
        BEFORE FIELD npq13  #  npq12-npq13-npq14
           IF l_aag17 IS NOT NULL AND l_aag17 != ' ' THEN
              CALL i014_get_ahe02('3')  #FUN-5C0015
              CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
              LET l_str = l_str CLIPPED,g_ahe02,'!'  #FUN-5C0015
              ERROR l_str
           END IF
 
        AFTER FIELD npq13
         SELECT aag171 INTO l_aag171 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
               CALL s_chk_aee(g_npq[l_ac].npq03,'3',g_npq[l_ac].npq13,g_bookno33)  #No.FUN-730020
               IF NOT cl_null(g_errno) THEN
                     CALL cl_err('sel aee:',g_errno,1) 
                 NEXT FIELD npq13
               END IF
 
        BEFORE FIELD npq14
           IF l_aag18 IS NOT NULL AND l_aag18 != ' ' THEN
                CALL i014_get_ahe02('4')  #FUN-5C0015
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
                LET l_str = l_str CLIPPED,g_ahe02,'!'   #FUN-5C0015
                ERROR l_str
           END IF
 
        AFTER FIELD npq14
         SELECT aag181 INTO l_aag181 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
               CALL s_chk_aee(g_npq[l_ac].npq03,'4',g_npq[l_ac].npq14,g_bookno33)  #No.FUN-730020
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('sel aee:',g_errno,1)
                  NEXT FIELD npq14
               END IF
 
        BEFORE FIELD npq31
           IF l_aag31 IS NOT NULL AND l_aag31 != ' ' THEN
                CALL i014_get_ahe02('5')
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
                LET l_str = l_str CLIPPED,g_ahe02,'!'
                ERROR l_str
           END IF
 
        AFTER FIELD npq31
         SELECT aag311 INTO l_aag311 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
               CALL s_chk_aee(g_npq[l_ac].npq03,'5',g_npq[l_ac].npq31,g_bookno33)  #No.FUN-730020
               IF NOT cl_null(g_errno) THEN
                     CALL cl_err('sel aee:',g_errno,1)
                  NEXT FIELD npq31
               END IF
 
        BEFORE FIELD npq32
           IF l_aag32 IS NOT NULL AND l_aag32 != ' ' THEN
                CALL i014_get_ahe02('6')
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
                LET l_str = l_str CLIPPED,g_ahe02,'!'
                ERROR l_str
           END IF
        AFTER FIELD npq32
         SELECT aag321 INTO l_aag321 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
               CALL s_chk_aee(g_npq[l_ac].npq03,'6',g_npq[l_ac].npq32,g_bookno33)  #No.FUN-730020
               IF NOT cl_null(g_errno) THEN
                     CALL cl_err('sel aee:',g_errno,1)
                  NEXT FIELD npq32
               END IF
 
        BEFORE FIELD npq33
           IF l_aag33 IS NOT NULL AND l_aag33 != ' ' THEN
                CALL i014_get_ahe02('7')
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
                LET l_str = l_str CLIPPED,g_ahe02,'!'
                ERROR l_str
           END IF
        AFTER FIELD npq33
         SELECT aag331 INTO l_aag331 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
               CALL s_chk_aee(g_npq[l_ac].npq03,'7',g_npq[l_ac].npq33,g_bookno33)  #No.FUN-730020
               IF NOT cl_null(g_errno) THEN
                     CALL cl_err('sel aee:',g_errno,1)
                  NEXT FIELD npq33
               END IF
 
        BEFORE FIELD npq34
           IF l_aag34 IS NOT NULL AND l_aag34 != ' ' THEN
                CALL i014_get_ahe02('8')
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
                LET l_str = l_str CLIPPED,g_ahe02,'!'
                ERROR l_str
           END IF
        AFTER FIELD npq34
         SELECT aag341 INTO l_aag341 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
               CALL s_chk_aee(g_npq[l_ac].npq03,'8',g_npq[l_ac].npq34,g_bookno33)  #No.FUN-730020
               IF NOT cl_null(g_errno) THEN
                     CALL cl_err('sel aee:',g_errno,1)
                  NEXT FIELD npq34
               END IF
 
        BEFORE FIELD npq35
           IF l_aag35 IS NOT NULL AND l_aag35 != ' ' THEN
                CALL i014_get_ahe02('9')
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
                LET l_str = l_str CLIPPED,g_ahe02,'!'
                ERROR l_str
           END IF
 
        AFTER FIELD npq35
         SELECT aag351 INTO l_aag351 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
               CALL s_chk_aee(g_npq[l_ac].npq03,'9',g_npq[l_ac].npq35,g_bookno33)  #No.FUN-730020
               IF NOT cl_null(g_errno) THEN
                     CALL cl_err('sel aee:',g_errno,1)
                  NEXT FIELD npq35
               END IF
 
        BEFORE FIELD npq36
           IF l_aag36 IS NOT NULL AND l_aag36 != ' ' THEN
                CALL i014_get_ahe02('10')
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
                LET l_str = l_str CLIPPED,g_ahe02,'!'
                ERROR l_str
           END IF
 
        AFTER FIELD npq36
         SELECT aag361 INTO l_aag361 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
               CALL s_chk_aee(g_npq[l_ac].npq03,'10',g_npq[l_ac].npq36,g_bookno33)  #No.FUN-730020
               IF NOT cl_null(g_errno) THEN
                     CALL cl_err('sel aee:',g_errno,1)
                  NEXT FIELD npq36
               END IF
 
        BEFORE FIELD npq37
           IF l_aag37 IS NOT NULL AND l_aag37 != ' ' THEN
                CALL i014_get_ahe02('99')
                CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
                LET l_str = l_str CLIPPED,g_ahe02,'!'
                ERROR l_str
           END IF
        AFTER FIELD npq37
         SELECT aag371 INTO l_aag371 FROM aag_file
          WHERE aag01=g_npq[l_ac].npq03
            AND aag00 = g_bookno33  #No.FUN-730020
               CALL s_chk_aee(g_npq[l_ac].npq03,'99',g_npq[l_ac].npq37,g_bookno33)  #No.FUN-730020
               IF NOT cl_null(g_errno) THEN
                     CALL cl_err('sel aee:',g_errno,1)
                  NEXT FIELD npq37
               END IF
 
        AFTER FIELD npq04
            LET g_msg = g_npq[l_ac].npq04
            IF g_msg[1,1] = '.' THEN
               LET g_msg = g_msg[2,10]
               SELECT aad02 INTO g_npq[l_ac].npq04 FROM aad_file
                WHERE aad01 = g_msg AND aadacti = 'Y'
                DISPLAY BY NAME g_npq[l_ac].npq04
               NEXT FIELD npq04
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_npq_t.npq02 > 0 AND g_npq_t.npq02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                      CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
{ckp#1}         DELETE FROM npq_file WHERE npqsys=g_npp.nppsys
                   AND npq00= g_npp.npp00 AND npq01 =g_npp.npp01
                   AND npq011 =g_npp.npp011 AND npq02= g_npq_t.npq02
                   AND npqtype=g_npp.npptype  #No.FUN-670047
                IF SQLCA.sqlcode THEN
                    LET g_success = 'N'
                       CALL cl_err(g_npq_t.npq02,SQLCA.sqlcode,1)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                IF g_success='Y'   THEN
                   COMMIT WORK
                   LET g_rec_b=g_rec_b-1
                   DISPLAY g_rec_b TO FORMONLY.cn2
                   MESSAGE 'Delete Ok'
                ELSE
                   ROLLBACK WORK
                END IF
                CALL i014_chk()   #No.MOD-4A0347
                IF cl_null(g_npq07_t1) THEN LET g_npq07_t1 = 0 END IF
                IF cl_null(g_npq07_t2) THEN LET g_npq07_t2 = 0 END IF
                IF g_npq07_t1 != g_npq07_t2 THEN  #(僅判斷本幣即可)
                      CALL cl_err('','axr-058',1)   #原幣金額,本幣金額借貸相等否
                   CONTINUE INPUT
                END IF
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_npq[l_ac].* = g_npq_t.*
               CLOSE i014_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_npq[l_ac].npq02,-263,1)
               LET g_npq[l_ac].* = g_npq_t.*
            ELSE
               #FUN-AC0063 add --start--
               CALL g_npq_to_g_npq3()
               CALL s_chk_dimension(g_npq3.*,g_npq[l_ac].npq03,g_npq[l_ac].npq11,g_bookno33) RETURNING l_fld_name 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  CASE l_fld_name
                     WHEN 'npq31'
                        NEXT FIELD npq31
                     WHEN 'npq32'
                        NEXT FIELD npq32
                     WHEN 'npq33'
                        NEXT FIELD npq33
                     WHEN 'npq34'
                        NEXT FIELD npq34
                  END CASE        
               END IF
               #FUN-AC0063 add --end--
                UPDATE npq_file
                   SET npq02=g_npq[l_ac].npq02,npq03=g_npq[l_ac].npq03,
                       npq04=g_npq[l_ac].npq04,npq05=g_npq[l_ac].npq05,
                       npq06=g_npq[l_ac].npq06,npq07f=g_npq[l_ac].npq07f,
                       npq07=g_npq[l_ac].npq07,npq08=g_npq[l_ac].npq08,
                       npq11=g_npq[l_ac].npq11,npq12=g_npq[l_ac].npq12,
                       npq13=g_npq[l_ac].npq13,npq14=g_npq[l_ac].npq14,
                       npq31=g_npq[l_ac].npq31,npq32=g_npq[l_ac].npq32,
                       npq33=g_npq[l_ac].npq33,npq34=g_npq[l_ac].npq34,
                       npq35=g_npq[l_ac].npq35,npq36=g_npq[l_ac].npq36,
                       npq37=g_npq[l_ac].npq37,
                       npq15=g_npq[l_ac].npq15,npq21=g_npq[l_ac].npq21,
                       npq22=g_npq[l_ac].npq22,npq23=g_npq[l_ac].npq23,
                       npq24=g_npq[l_ac].npq24,npq25=g_npq[l_ac].npq25
                WHERE npqsys = g_npp.nppsys AND npq00=g_npp.npp00
	        	AND npq01=g_npp.npp01 AND npq011=g_npp.npp011
	         	AND npq02=g_npq_t.npq02
                        AND npqtype=g_npp.npptype  #No.FUN-670047
                IF SQLCA.sqlcode THEN
                   CALL cl_err('upd npq',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                END IF
                IF g_success='Y' THEN
                   COMMIT WORK
                   MESSAGE 'UPDATE O.K'
                ELSE
                   ROLLBACK WORK
                END IF
                CALL i014_chk()
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D30032
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_npq[l_ac].* = g_npq_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_npq.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF
               IF g_npq07_t1 != g_npq07_t2 THEN 
                  IF (g_npp.nppsys = 'AP' AND g_npp.npp00 = '1') OR 
                     (g_npp.nppsys = 'AR' AND g_npp.npp00 = '2') THEN 
                     CALL cl_err('','axr-058','1')
                     NEXT FIELD npq07
                  END IF
               END IF
               CLOSE i014_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032
            CLOSE i014_bcl
            COMMIT WORK
            CALL g_npq.deleteElement(g_rec_b+1)
 
       AFTER INPUT
          IF g_npq07_t1 != g_npq07_t2   #(僅判斷本幣即可)
          THEN    #原幣金額,本幣金額借貸相等否
             IF (g_npp.nppsys = 'AP' AND g_npp.npp00 = '1') OR 
                (g_npp.nppsys = 'AR' AND g_npp.npp00 = '2') THEN 
                CALL cl_err('','axr-058','1')
                NEXT FIELD npq07
             ELSE
                CALL cl_err('','axr-058',1)
                EXIT INPUT
             END IF   #MOD-7B0147
          END IF
 
        ON ACTION controlo
            IF INFIELD(npq02) AND l_ac > 1 THEN
                LET g_npq[l_ac].* = g_npq[l_ac-1].*
                LET g_npq[l_ac].npq02 = NULL
                NEXT FIELD npq02
            END IF
 
        ON ACTION CONTROLP
            CALL cl_init_qry_var()
            CASE
               WHEN INFIELD(npq03) #會計科目
                  LET g_qryparam.form = 'q_aag'
                  LET g_qryparam.default1 = g_npq[l_ac].npq03
                  LET g_qryparam.arg1 = g_bookno33  #No.FUN-730020
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq03
                  DISPLAY g_npq[l_ac].npq03 TO npq03
                  NEXT FIELD npq03
 
               WHEN INFIELD(npq04) #常用摘要
                  LET g_qryparam.form = 'q_aad2'
                  LET g_qryparam.default1 = g_npq[l_ac].npq04
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq04
                  DISPLAY g_npq[l_ac].npq04 TO npq04
                  NEXT FIELD npq04
 
               WHEN INFIELD(npq05) #部門編號
                   LET g_qryparam.form = 'q_gem1'      #No.MOD-440244
                  LET g_qryparam.default1 = g_npq[l_ac].npq05
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq05
                  DISPLAY g_npq[l_ac].npq05 TO npq05
                  NEXT FIELD npq05
 
               WHEN INFIELD(npq24)   #幣別
                  LET g_qryparam.form = 'q_azi'
                  LET g_qryparam.default1 = g_npq[l_ac].npq24
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq24
                  DISPLAY g_npq[l_ac].npq24 TO npq24
                  NEXT FIELD npq24
 
               WHEN INFIELD(npq25)
                  CALL s_rate(g_npq[l_ac].npq24,g_npq[l_ac].npq25) RETURNING g_npq[l_ac].npq25
                  DISPLAY g_npq[l_ac].npq25 TO npq25
                  NEXT FIELD npq25
 
               WHEN INFIELD(npq08)    #查詢專案編號
                  LET g_qryparam.form = 'q_gja'
                  LET g_qryparam.default1 = g_npq[l_ac].npq08
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq08
                  DISPLAY g_npq[l_ac].npq08 TO npq08
                  NEXT FIELD npq08
 
               WHEN INFIELD(npq15)    #查詢預算編號
                  LET g_qryparam.form = 'q_afa'
                  LET g_qryparam.default1 = g_npq[l_ac].npq15
                  LET g_qryparam.arg1 = g_bookno33  #No.FUN-730070
                  CALL cl_create_qry() RETURNING g_npq[l_ac].npq15
                  DISPLAY g_npq[l_ac].npq15 TO npq15
                  NEXT FIELD npq15
              
               WHEN INFIELD(npq11)    #查詢異動碼-1
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'1','i',g_npq[l_ac].npq11,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq11
                    DISPLAY g_npq[l_ac].npq11 TO npq11
                    NEXT FIELD npq11
               
               WHEN INFIELD(npq12)    #查詢異動碼-2
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'2','i',g_npq[l_ac].npq12,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq12
                    DISPLAY g_npq[l_ac].npq12 TO npq12
                    NEXT FIELD npq12
               
               WHEN INFIELD(npq13)    #查詢異動碼-3
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'3','i',g_npq[l_ac].npq13,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq13
                    DISPLAY g_npq[l_ac].npq13 TO npq13
                    NEXT FIELD npq13
               
               WHEN INFIELD(npq14)    #查詢異動碼-4
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'4','i',g_npq[l_ac].npq14,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq14
                    DISPLAY g_npq[l_ac].npq14 TO npq14
                    NEXT FIELD npq14
               
               WHEN INFIELD(npq31)    #查詢異動碼-5
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'5','i',g_npq[l_ac].npq31,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq31
                    DISPLAY g_npq[l_ac].npq31 TO npq31
                    NEXT FIELD npq31
               
               WHEN INFIELD(npq32)    #查詢異動碼-6
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'6','i',g_npq[l_ac].npq32,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq32
                    DISPLAY g_npq[l_ac].npq32 TO npq32
                    NEXT FIELD npq32
               
               WHEN INFIELD(npq33)    #查詢異動碼-7
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'7','i',g_npq[l_ac].npq33,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq33
                    DISPLAY g_npq[l_ac].npq33 TO npq33
                    NEXT FIELD npq33
               
               WHEN INFIELD(npq34)    #查詢異動碼-8
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'8','i',g_npq[l_ac].npq34,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq34
                    DISPLAY g_npq[l_ac].npq34 TO npq34
                    NEXT FIELD npq34
               
               WHEN INFIELD(npq35)    #查詢異動碼-9
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'9','i',g_npq[l_ac].npq35,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq35
                    DISPLAY g_npq[l_ac].npq35 TO npq35
                    NEXT FIELD npq35
               
               WHEN INFIELD(npq36)    #查詢異動碼-10
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'10','i',g_npq[l_ac].npq36,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq36
                    DISPLAY g_npq[l_ac].npq36 TO npq36
                    NEXT FIELD npq36
               
               WHEN INFIELD(npq37)    #關係人
                    CALL s_ahe_qry(g_npq[l_ac].npq03,'99','i',g_npq[l_ac].npq37,g_bookno33)  #No.FUN-730020
                      RETURNING g_npq[l_ac].npq37
                    DISPLAY g_npq[l_ac].npq37 TO npq37
                    NEXT FIELD npq37
 
            END CASE
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION controls                       #No.FUN-6B0033
            CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033            
 
      END INPUT
      IF g_success='Y'
         THEN COMMIT WORK
         ELSE ROLLBACK WORK
      END IF
      CLOSE i014_bcl
END FUNCTION

#FUN-AC0063 add --start--
FUNCTION g_npq_to_g_npq3() 
 
   SELECT * INTO g_npq3.* FROM npq_file
    WHERE npq00  =g_npp.npp00
      AND npq01  =g_npp.npp01
      AND npq02  =g_npq_t.npq02
      AND npq011 =g_npp.npp011
      AND npqsys =g_npp.nppsys
      AND npqtype=g_npp.npptype

   LET g_npq3.npq02 = g_npq[l_ac].npq02
   LET g_npq3.npq03 = g_npq[l_ac].npq03
   LET g_npq3.npq04 = g_npq[l_ac].npq04
   LET g_npq3.npq05 = g_npq[l_ac].npq05
   LET g_npq3.npq06 = g_npq[l_ac].npq06
   LET g_npq3.npq07 = g_npq[l_ac].npq07
   LET g_npq3.npq07f = g_npq[l_ac].npq07f
   LET g_npq3.npq08 = g_npq[l_ac].npq08
   LET g_npq3.npq11 = g_npq[l_ac].npq11
   LET g_npq3.npq12 = g_npq[l_ac].npq12
   LET g_npq3.npq13 = g_npq[l_ac].npq13
   LET g_npq3.npq14 = g_npq[l_ac].npq14
   LET g_npq3.npq21 = g_npq[l_ac].npq21
   LET g_npq3.npq22 = g_npq[l_ac].npq22
   LET g_npq3.npq23 = g_npq[l_ac].npq23
   LET g_npq3.npq24 = g_npq[l_ac].npq24
   LET g_npq3.npq25 = g_npq[l_ac].npq25
   LET g_npq3.npq31 = g_npq[l_ac].npq31
   LET g_npq3.npq32 = g_npq[l_ac].npq32
   LET g_npq3.npq33 = g_npq[l_ac].npq33
   LET g_npq3.npq34 = g_npq[l_ac].npq34
   LET g_npq3.npq35 = g_npq[l_ac].npq35
   LET g_npq3.npq36 = g_npq[l_ac].npq36
   LET g_npq3.npq37 = g_npq[l_ac].npq37

END FUNCTION
#FUN-AC0063 add --end--
 
FUNCTION i014_set_entry_b(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680147 VARCHAR(01)
   DEFINE   l_nmg20 LIKE nmg_file.nmg20  #MOD-550100
 
   IF (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("npq21,npq22,npq23,npq24,npq25",TRUE)
   END IF
 
   IF INFIELD(npq03) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("npq05",TRUE)
      CALL cl_set_comp_entry("npq15",TRUE)   #MOD-570379   #MOD-680003 remark
      CALL cl_set_comp_entry("npq08",TRUE)
      CALL cl_set_comp_entry("npq11",TRUE)
      CALL cl_set_comp_entry("npq12",TRUE)
      CALL cl_set_comp_entry("npq13",TRUE)
      CALL cl_set_comp_entry("npq14",TRUE)
 
      #FUN-5C0015 051216 BY GILL --START
      CALL cl_set_comp_entry("npq31",TRUE)
      CALL cl_set_comp_entry("npq32",TRUE)
      CALL cl_set_comp_entry("npq33",TRUE)
      CALL cl_set_comp_entry("npq34",TRUE)
      CALL cl_set_comp_entry("npq35",TRUE)
      CALL cl_set_comp_entry("npq36",TRUE)
      CALL cl_set_comp_entry("npq37",TRUE)
      #FUN-5C0015 051216 BY GILL --END
   END IF
END FUNCTION
 
FUNCTION i014_set_no_entry_b(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1   #No.FUN-680147 VARCHAR(01)
   DEFINE l_nmg20  LIKE nmg_file.nmg20   #MOD-550100
 
   IF INFIELD(npq03) OR (NOT g_before_input_done) THEN
     SELECT aag151,aag161,aag171,aag181,aag05,aag21,aag23,
            aag311,aag321,aag331,aag341,aag351,aag361,aag371 #FUN-5C0015 BY GILL
        INTO l_aag151,l_aag161,l_aag171,l_aag181,l_aag05,l_aag21,l_aag23,
             l_aag311,l_aag321,l_aag331,l_aag341,l_aag351,l_aag361,l_aag371 #FUN-5C0015 BY GILL
       FROM aag_file WHERE aag01 = g_npq[l_ac].npq03 AND aag07 != '1'
                       AND aag00 = g_bookno33  #No.FUN-730020
      IF l_aag05 = 'N' THEN
         CALL cl_set_comp_entry("npq05",FALSE)
      END IF
      IF l_aag21 = 'N' OR cl_null(l_aag21) THEN
          CALL cl_set_comp_entry("npq15",FALSE)   #MOD-570379 #MOD-680003 remark
      END IF
      IF l_aag23 = 'N' OR cl_null(l_aag23) THEN
         CALL cl_set_comp_entry("npq08",FALSE)
      END IF
      IF cl_null(l_aag151) THEN
         CALL cl_set_comp_entry("npq11",FALSE)
      END IF
      IF cl_null(l_aag161) THEN
         CALL cl_set_comp_entry("npq12",FALSE)
      END IF
      IF cl_null(l_aag171) THEN
         CALL cl_set_comp_entry("npq13",FALSE)
      END IF
      IF cl_null(l_aag181) THEN
         CALL cl_set_comp_entry("npq14",FALSE)
      END IF
 
      IF cl_null(l_aag311) THEN
         CALL cl_set_comp_entry("npq31",FALSE)
      END IF
      IF cl_null(l_aag321) THEN
         CALL cl_set_comp_entry("npq32",FALSE)
      END IF
      IF cl_null(l_aag331) THEN
         CALL cl_set_comp_entry("npq33",FALSE)
      END IF
      IF cl_null(l_aag341) THEN
         CALL cl_set_comp_entry("npq34",FALSE)
      END IF
      IF cl_null(l_aag351) THEN
         CALL cl_set_comp_entry("npq35",FALSE)
      END IF
      IF cl_null(l_aag361) THEN
         CALL cl_set_comp_entry("npq36",FALSE)
      END IF
      IF cl_null(l_aag371) THEN
         CALL cl_set_comp_entry("npq37",FALSE)
      END IF
      #FUN-5C0015 051216 BY GILL --END
 
    END IF
END FUNCTION
 
FUNCTION i014_chk()
    SELECT SUM(npq07f),SUM(npq07) INTO g_npq07f_t1,g_npq07_t1 FROM npq_file
     WHERE npqsys =g_npp.nppsys AND npq00 =g_npp.npp00
       AND npq01  =g_npp.npp01  AND npq011=g_npp.npp011 AND npq06='1'
       AND npqtype = g_npp.npptype  #No.FUN-670047
    SELECT SUM(npq07f),SUM(npq07) INTO g_npq07f_t2,g_npq07_t2 FROM npq_file
     WHERE npqsys =g_npp.nppsys AND npq00 =g_npp.npp00
       AND npq01  =g_npp.npp01  AND npq011=g_npp.npp011 AND npq06='2'
       AND npqtype = g_npp.npptype  #No.FUN-670047
    DISPLAY g_npq07f_t1,g_npq07_t1,g_npq07f_t2,g_npq07_t2
         TO npq07f_t1,npq07_t1,npq07f_t2,npq07_t2
END FUNCTION
 
FUNCTION i014_get_ahe02(p_no)
  DEFINE p_no LIKE aaz_file.aaz88
   LET g_ahe02 = ''
   CASE p_no
      WHEN "1" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag15
      WHEN "2" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag16
      WHEN "3" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag17
      WHEN "4" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag18
      WHEN "5" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag31
      WHEN "6" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag32
      WHEN "7" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag33
      WHEN "8" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag34
      WHEN "9" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag35
      WHEN "10" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag36
      WHEN "99" SELECT ahe02 INTO g_ahe02 FROM ahe_file WHERE ahe01=l_aag37
   END CASE
END FUNCTION
 
FUNCTION i014_set_no_required()
#   CALL cl_set_comp_required("npq11,npq12,npq13,npq14,npq31,npq32,npq33,npq34,npq35,
#                              npq36,npq37,npq05,npq15,npq08",FALSE)
END FUNCTION
 
FUNCTION i014_set_required()
    #本科目是否作部門明細管理 (Y/N)
    IF l_aag05='Y' THEN
       CALL cl_set_comp_required("npq05",TRUE)
    END IF
 
    #是否作線上預算控制(Y/N)
    IF l_aag21 = 'Y' THEN
       CALL cl_set_comp_required("npq15",TRUE)
    END IF
 
    #是否作專案管理(Y/N)
    IF l_aag23 = 'Y' THEN
       CALL cl_set_comp_required("npq08",TRUE)
    END IF
    #-----END MOD-680003-----
 
   IF l_aag151 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq11",TRUE)
   END IF
   IF l_aag161 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq12",TRUE)
   END IF
   IF l_aag171 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq13",TRUE)
   END IF
   IF l_aag181 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq14",TRUE)
   END IF
   IF l_aag311 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq31",TRUE)
   END IF
   IF l_aag321 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq32",TRUE)
   END IF
   IF l_aag331 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq33",TRUE)
   END IF
   IF l_aag341 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq34",TRUE)
   END IF
   IF l_aag351 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq35",TRUE)
   END IF
   IF l_aag361 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq36",TRUE)
   END IF
   IF l_aag371 MATCHES '[23]' THEN
      CALL cl_set_comp_required("npq37",TRUE)
   END IF
END FUNCTION
 
FUNCTION i014_npq24()
DEFINE l_oma08    LIKE oma_file.oma08
DEFINE l_date     LIKE apa_file.apa02
DEFINE l_rate     LIKE type_file.chr1
 
   LET l_date =null
   LET l_rate =null
         LET l_date =g_today
         LET l_rate ='M'
   IF cl_null(l_date) THEN
      LET l_date =g_today
   END IF
   IF cl_null(l_rate) THEN
      LET l_rate ='M'
   END IF  
 
   CALL s_curr3(g_npq[l_ac].npq24,l_date,l_rate) RETURNING g_npq[l_ac].npq25
   IF cl_null(g_npq[l_ac].npq25) THEN LET g_npq[l_ac].npq25 =1 END IF
   IF g_npq[l_ac].npq24 =g_aza.aza17 THEN
      LET g_npq[l_ac].npq25 = 1
   END IF
END FUNCTION
 
FUNCTION  i014_show_filed()
#依參數決定異動碼的多寡
 
  DEFINE l_field     STRING

#FUN-B50105   ---start   Mark 
# IF g_aaz.aaz88 = 10 THEN
#    RETURN
# END IF
#
# IF g_aaz.aaz88 = 0 THEN
#    LET l_field  = "npq11,npq12,npq13,npq14,npq31,npq32,npq33,npq34,",
#                   "npq35,npq36"
# END IF
#
# IF g_aaz.aaz88 = 1 THEN
#    LET l_field  = "npq12,npq13,npq14,npq31,npq32,npq33,npq34,",
#                   "npq35,npq36"
# END IF
#
# IF g_aaz.aaz88 = 2 THEN
#    LET l_field  = "npq13,npq14,npq31,npq32,npq33,npq34,",
#                   "npq35,npq36"
# END IF
#
# IF g_aaz.aaz88 = 3 THEN
#    LET l_field  = "npq14,npq31,npq32,npq33,npq34,",
#                   "npq35,npq36"
# END IF
#
# IF g_aaz.aaz88 = 4 THEN
#    LET l_field  = "npq31,npq32,npq33,npq34,",
#                   "npq35,npq36"
# END IF
#
# IF g_aaz.aaz88 = 5 THEN
#    LET l_field  = "npq32,npq33,npq34,",
#                   "npq35,npq36"
# END IF
#
# IF g_aaz.aaz88 = 6 THEN
#    LET l_field  = "npq33,npq34,npq35,npq36"
# END IF
#
# IF g_aaz.aaz88 = 7 THEN
#    LET l_field  = "npq34,npq35,npq36"
# END IF
#
# IF g_aaz.aaz88 = 8 THEN
#    LET l_field  = "npq35,npq36"
# END IF
#
# IF g_aaz.aaz88 = 9 THEN
#    LET l_field  = "npq36"
# END IF
#FUN-B50105   ---start   Mark
 
#FUN-B50105   ---start   Add
   IF g_aaz.aaz88 = 0 THEN
      LET l_field = "npq11,npq12,npq13,npq14"
   END IF
   IF g_aaz.aaz88 = 1 THEN
      LET l_field = "npq12,npq13,npq14"
   END IF
   IF g_aaz.aaz88 = 2 THEN
      LET l_field = "npq13,npq14"
   END IF
   IF g_aaz.aaz88 = 3 THEN
      LET l_field = "npq14"
   END IF
   IF g_aaz.aaz88 = 4 THEN
      LET l_field = ""
   END IF
   IF NOT cl_null(l_field) THEN lET l_field = l_field,"," END IF
   IF g_aaz.aaz125 = 5 THEN
      LET l_field = l_field,"npq32,npq33,npq34,npq35,npq36"
   END IF
   IF g_aaz.aaz125 = 6 THEN
      LET l_field = l_field,"npq33,npq34,npq35,npq36"
   END IF
   IF g_aaz.aaz125 = 7 THEN
      LET l_field = l_field,"npq34,npq35,npq36"
   END IF
   IF g_aaz.aaz125 = 8 THEN
      LET l_field = l_field,"npq35,npq36"
   END IF
#FUN-B50105   ---end     Add
 
  CALL cl_set_comp_visible(l_field,FALSE)
END FUNCTION
#--FUN-920150 end----
 
