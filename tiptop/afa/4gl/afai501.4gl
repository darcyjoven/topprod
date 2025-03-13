# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afai501
# Descriptions...: 每月攤提保費分錄底稿維護作業(FA) 
# Date & Author..: 99/05/31 By Kammy
# Modify.........: No.MOD-470515 04/07/27 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0019 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0008 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.MOD-4C0029 04/12/07 By Nicola cl_doc參數傳遞錯誤
# Modify.........: NO.FUN-550034 05/05/17 By jackie 單據編號加大
# Modify.........: NO.FUN-570129 05/08/05 BY yiting 單身只有行序時只能放棄才能離
# Modify.........: No.MOD-5C0103 05/12/16 By Smapmin 分錄底稿格式修改
# Modify.........: No.FUN-620022 06/03/09 By Sarah 移除單身,改成單檔形式,add act"分錄底稿"CALL s_fsgl.4gl維護
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-660165 06/08/15 By Sarah 改變畫面顯示方式,直接CALL分錄底稿s_fsgl的畫面跟4gl來維護程式
# Modify.........: No.FUN-680028 06/08/22 By day 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION i501_q() 一開始應清空g_npp.*值
# Modify.........: No.FUN-6A0069 06/11/06 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-780068 07/11/15 By Sarah 當不使用多帳別功能時，隱藏npptype
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-8C0050 08/04/27 By ve007 將s_fsgl的_bp函數移入程序內部
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
# Modify.........: No.MOD-B80142 11/08/16 By Polly 修正g_argv3，再刪除時會出現錯誤訊息
# Modify.........: No:FUN-BA0112 11/11/07 By Sakura 財簽二5.25與5.1程式比對不一致修改 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_fsgl.global"      #No.FUN-8C0050
 
DEFINE
    g_argv1         LIKE npp_file.nppsys,  #系統別         #No.FUN-680070 VARCHAR(02)
    g_argv2         LIKE npp_file.npp00,   #類別           #No.FUN-680070 SMALLINT
    g_argv3         LIKE npp_file.npp01,   #單號           #No.FUN-680070 VARCHAR(20)
    g_argv4         LIKE npq_file.npq07,   #本幣金額
    g_argv5         LIKE aaa_file.aaa01,   #帳別
    g_argv6         LIKE npp_file.npp011,  #異動序號       #No.FUN-680070 SMALLINT
    g_argv7         LIKE type_file.chr1,   #確認碼         #No.FUN-680070 VARCHAR(01)
    g_argv8         LIKE npp_file.npptype, #No.FUN-680028
    g_argv9         LIKE azp_file.azp01    #No.FUN-680028
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                         # Supress DEL key function
 
    LET g_argv1 = ARG_VAL(1)    # FA
    LET g_argv2 = ARG_VAL(2)    # 類別
    LET g_argv3 = ARG_VAL(3)    # 單號
    LET g_argv4 = ARG_VAL(4)    # 本幣金額
    LET g_argv6 = ARG_VAL(6)    # 異動序號
    LET g_argv7 = ARG_VAL(7)    # 確認碼
    LET g_argv8 = ARG_VAL(8)    #No.FUN-680028 
    LET g_argv9 = ARG_VAL(9)    #No.FUN-680028

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AFA")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #NO.FUN-6A0069 
 
    LET g_argv5 = g_faa.faa02b  # 帳別   #MOD-5C0103
 
    OPEN WINDOW s_fsgl_w WITH FORM "sub/42f/s_fsgl"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()

    #No.FUN-680028--begin
 #  IF g_aza.aza63 != 'Y' THEN  
 #  IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088 #No:FUN-BA0112 mark
    IF g_faa.faa31 != 'Y' THEN  #No:FUN-BA0112 add   
       CALL cl_set_comp_visible("npptype",FALSE)  
    END IF
    #No.FUN-680028--end  
    CALL s_fsgl_show_filed()  #FUN-5C0015 051216 BY GILL
   #str FUN-780068 add
   #當不使用多帳別功能時，隱藏npptype
 #  IF g_aza.aza63 = 'N' THEN
 #  IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088 #No:FUN-BA0112 mark
    IF g_faa.faa31 = 'N' THEN   #No:FUN-BA0112 add
       CALL cl_set_comp_visible("npptype",FALSE)
    END IF
   #end FUN-780068 add
 
    CALL i501_menu()
 
    CLOSE WINDOW s_fsgl_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出時間)  #NO.FUN-6A0069 
END MAIN
 
FUNCTION i501_menu()
 
   WHILE TRUE
     # CALL s_fsgl_bp2("G")
      CALL i501_bp("G")     #No.FUN-8C0050
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL s_fsgl_q('FA')    #FUN-980003  修改s_fsgl 程式
            END IF
         #No.FUN-6A0001-----str----刪除
        #----------No.MOD-B80142-----------------start remark
         WHEN "delete"                              
            IF cl_chk_act_auth() THEN               
               CALL s_fsgl_r()                      
            END IF                                  
        #WHEN "delete"
        #   IF cl_chk_act_auth() THEN
        #      IF   g_argv3 IS NULL THEN
        #           CALL cl_err('',-400,0)
        #      ELSE
        #           CALL s_fsgl_r()
        #      END IF
        #   END IF
        #-----------No.MOD-B80142-----------------end
         #No.FUN-6A0001-----end----
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL s_fsgl_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL s_fsgl_out('afai501')
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL s_fsgl_exporttoexcel()
            END IF
      END CASE
   END WHILE
 
END FUNCTION
#end FUN-660165 add
 
##start FUN-660165 mark
#{
#DEFINE 
#    g_npp     	RECORD LIKE npp_file.*,
#    g_sql           string,   #No.FUN-580092 HCN
#    g_wc            string,   #No.FUN-580092 HCN
#   #g_wc2           string,   #No.FUN-580092 HCN   #FUN-620022 mark
#   #g_rec_b         LIKE type_file.num5,     #FUN-620022 mark       #No.FUN-680070 SMALLINT
#   #l_ac            LIKE type_file.num5,     #FUN-620022 mark       #No.FUN-680070 SMALLINT
#    g_buf           LIKE type_file.chr20,    #No.FUN-680070 VARCHAR(20)
#    g_argv1         LIKE npp_file.nppsys,    #系統別          #No.FUN-680070 VARCHAR(02)
#    g_argv2         LIKE npp_file.npp01,     #類別            #No.FUN-680070 SMALLINT
#    g_argv3         LIKE npp_file.npp01,     #單號            #No.FUN-680070 VARCHAR(10)
#    g_argv4         LIKE nmd_file.nmd04,     #票面金額        #No.FUN-4C0008
#    g_argv5         LIKE aaa_file.aaa01,     #帳別            #No.FUN-670039   
#    g_azn02         LIKE azn_file.azn02,
#    g_azn04         LIKE azn_file.azn04 
# 
#DEFINE g_forupd_sql STRING                          #SELECT ... FOR UPDATE SQL
#DEFINE g_before_input_done   LIKE type_file.num5    #No.FUN-680070 SMALLINT
#DEFINE   g_cnt          LIKE type_file.num10        #No.FUN-680070 INTEGER
#DEFINE   g_msg          LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
#DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
#DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
#DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
#DEFINE   g_no_ask      LIKE type_file.num5         #No.FUN-680070 SMALLINT
#
#
#MAIN
#   OPTIONS
#       INPUT NO WRAP
#   DEFER INTERRUPT			   # Supress DEL key function
# 
#    IF (NOT cl_user()) THEN
#       EXIT PROGRAM
#    END IF
# 
#    WHENEVER ERROR CALL cl_err_msg_log
# 
#    IF (NOT cl_setup("AFA")) THEN
#       EXIT PROGRAM
#    END IF
# 
#    CALL cl_used(g_prog,g_time,1) RETURNING g_time               #NO.FUN-6A0069 
# 
#    #假設...
#    LET g_argv1 = 'FA'   
#    LET g_argv2 = 1    
#    LET g_argv5 = g_faa.faa02b    #MOD-5C0103
# 
#    OPEN WINDOW afai501 WITH FORM "afa/42f/afai501" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#    CALL cl_ui_init()
# 
#    LET g_forupd_sql = " SELECT * FROM npp_file WHERE npp01 =? AND npp011=? AND nppsys=? AND npp00=? FOR UPDATE "
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE i501_cl CURSOR FROM g_forupd_sql
# 
#    CALL i501_menu()
#    CLOSE WINDOW afai501  
#
#    CALL cl_used(g_prog,g_time,2) RETURNING g_time              #NO.FUN-6A0069
#END MAIN
# 
#FUNCTION i501_cs()
#DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
# 
#       CLEAR FORM                             #清除畫面
#      #CALL g_npq.clear()   #FUN-620022 mark
#       CONSTRUCT BY NAME g_wc  ON             # 螢幕上取單頭條件
#         npp01, npp03, nppglno
#          #No.FUN-580031 --start--     HCN
#          BEFORE CONSTRUCT
#             CALL cl_qbe_init()
#          #No.FUN-580031 --end--       HCN
#          ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE CONSTRUCT
# 
#          ON ACTION about         #MOD-4C0121
#             CALL cl_about()      #MOD-4C0121
# 
#          ON ACTION help          #MOD-4C0121
#             CALL cl_show_help()  #MOD-4C0121
# 
#          ON ACTION controlg      #MOD-4C0121
#             CALL cl_cmdask()     #MOD-4C0121
# 
#	  #No.FUN-580031 --start--     HCN
#          ON ACTION qbe_select
#	     CALL cl_qbe_list() RETURNING lc_qbe_sn
#	     CALL cl_qbe_display_condition(lc_qbe_sn)
#	  #No.FUN-580031 --end--       HCN
#       END CONSTRUCT
#       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
# 
#       IF INT_FLAG THEN RETURN END IF
###start FUN-620022 mark
###  #MOD-5C0103
###  #  CONSTRUCT g_wc2 ON npq02,npq03,npq05,npq04,npq06,npq07
###  #            FROM     s_npq[1].npq02,s_npq[1].npq03,
###  #                     s_npq[1].npq05,s_npq[1].npq04,
###  #                     s_npq[1].npq06,s_npq[1].npq07
###     CONSTRUCT g_wc2 ON npq02,npq03,npq05,npq06,npq07,npq04,npq15,npq08
###               FROM     s_npq[1].npq02,s_npq[1].npq03,
###                        s_npq[1].npq05,s_npq[1].npq06,s_npq[1].npq07,
###                        s_npq[1].npq04,s_npq[1].npq15,s_npq[1].npq08
###  #END MOD-5C0103
###
###        #No.FUN-580031 --start--     HCN
###        BEFORE CONSTRUCT
###           CALL cl_qbe_display_condition(lc_qbe_sn)
###        #No.FUN-580031 --end--       HCN
###
###        ON ACTION controlp
###           CASE
###              WHEN INFIELD(npq03)    #會計科目 
###                  CALL cl_init_qry_var()
###                  LET g_qryparam.form = "q_aag"
###                  LET g_qryparam.state = "c"
###                  IF NOT cl_null(g_npq[1].npq03) THEN
###                     LET g_qryparam.where =
###                     "aag01 MATCHES '",g_npq[1].npq03 CLIPPED,"'"
###                  END IF
###                  CALL cl_create_qry() RETURNING g_qryparam.multiret
###                  DISPLAY g_qryparam.multiret TO npq03
###                  NEXT FIELD npq03
###               WHEN INFIELD(npq05) #部門編號
###                  CALL cl_init_qry_var()
###                  LET g_qryparam.form = "q_gem"
###                  LET g_qryparam.state = "c"
###                  CALL cl_create_qry() RETURNING g_qryparam.multiret
###                  DISPLAY g_qryparam.multiret TO npq05
###                  NEXT FIELD npq05
###            #MOD-5C0103
###               WHEN INFIELD(npq08)    #查詢專案編號
###                  CALL cl_init_qry_var()
###                  LET g_qryparam.form = "q_gja"
###                  LET g_qryparam.state = "c"
###                  CALL cl_create_qry() RETURNING g_qryparam.multiret
###                  DISPLAY g_qryparam.multiret TO npq08
###                  NEXT FIELD npq08
###
###               WHEN INFIELD(npq15)    #查詢預算編號
###                  CALL cl_init_qry_var()
###                  LET g_qryparam.form = "q_afa"
###                  LET g_qryparam.state = "c"
###                  CALL cl_create_qry() RETURNING g_qryparam.multiret
###                  DISPLAY g_qryparam.multiret TO npq15
###                  NEXT FIELD npq15
###            #END MOD-5C0103
###           END CASE
###
###        ON IDLE g_idle_seconds
###           CALL cl_on_idle()
###           CONTINUE CONSTRUCT
###
###        ON ACTION about         #MOD-4C0121
###           CALL cl_about()      #MOD-4C0121
###
###        ON ACTION help          #MOD-4C0121
###           CALL cl_show_help()  #MOD-4C0121
###
###        ON ACTION controlg      #MOD-4C0121
###           CALL cl_cmdask()     #MOD-4C0121
###     
###        #No.FUN-580031 --start--     HCN
###            ON ACTION qbe_save
###               CALL cl_qbe_save()
###        #No.FUN-580031 --end--       HCN
###     END CONSTRUCT
###     IF INT_FLAG THEN RETURN END IF
###     IF g_wc2 = " 1=1" THEN 
###end FUN-620022 mark
#          LET g_sql = "SELECT npp01,npp011,nppsys,npp00 FROM npp_file",
#                      " WHERE nppsys = 'FA' ",
#                      "   AND npp00=12 ",   
#                      "   AND ", g_wc CLIPPED," ORDER BY 2 "
#     ##start FUN-620022 mark
#     ##ELSE 
#     ##   LET g_sql = "SELECT UNIQUE npp_file.rowid,npp01        ",
#     ##               "  FROM npp_file, npq_file ",
#     ##               " WHERE nppsys = npqsys ",
#     ##               "   AND npp00  = npq00  ",
#     ##               "   AND npp01  = npq01  ",
#     ##               "   AND npp011 = npq011 ",
#     ##               "   AND nppsys = 'FA'   ",
#     ##               "   AND npp00  = 12   ",
#     ##               "   AND ", g_wc CLIPPED,
#     ##               "   AND ", g_wc2 CLIPPED,
#     ##               " ORDER BY 2 "
#     ##END IF
#     ##end FUN-620022 mark
#    PREPARE i501_prepare FROM g_sql
#    IF STATUS THEN CALL cl_err('i501_pre',STATUS,1) EXIT PROGRAM END IF
#    DECLARE i501_cs                         #SCROLL CURSOR
#        SCROLL CURSOR WITH HOLD FOR i501_prepare
# 
#   #IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數   #FUN-620022 mark
#       LET g_sql="SELECT COUNT(*) FROM npp_file",
#                 " WHERE nppsys = 'FA'",
#                 "   AND npp00=12",
#                 "   AND ",g_wc CLIPPED
#  ##start FUN-620022 mark
#  ##ELSE
#  ##   LET g_sql="SELECT COUNT(DISTINCT npp01) FROM npp_file,npq_file ",
#  ##             " WHERE nppsys = npqsys ",
#  ##             "   AND npp00  = npq00  ",
#  ##             "   AND npp01  = npq01  ",
#  ##             "   AND npp011 = npq011 ",
#  ##             "   AND nppsys = 'FA'   ",
#  ##             "   AND npp00  = 12   ",
#  ##            "    AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
#  ##END IF
#  ##end FUN-620022 mark
#    PREPARE i501_precount FROM g_sql
#    DECLARE i501_count CURSOR FOR i501_precount
# 
#END FUNCTION
# 
#FUNCTION i501_menu()
# 
#  ##start FUN-620022 mark
#  ##WHILE TRUE
#  ##   CALL i501_bp("G")
#  ##   CASE g_action_choice
#  ##      WHEN "query" 
#  ##         CALL i501_q()
#  ##      WHEN "delete" 
#  ##         IF cl_chk_act_auth() THEN
#  ##            CALL i501_r()
#  ##         END IF
#  ##      WHEN "detail"  
#  ##         IF cl_chk_act_auth() THEN
#  ##            CALL i501_b() 
#  ##         ELSE
#  ##            LET g_action_choice = NULL
#  ##         END IF
#  ##       WHEN "related_document"  #No.MOD-470515
#  ##         IF cl_chk_act_auth() THEN
#  ##            IF g_npp.npp01 IS NOT NULL THEN
#  ##               LET g_doc.column1 = "npp01"
#  ##               LET g_doc.value1 = g_npp.npp01
#  ##                #-----No.MOD-4C0029-----
#  ##               LET g_doc.column2 = "npp011"
#  ##               LET g_doc.value2 = g_npp.npp011
#  ##               LET g_doc.column3 = "nppsys"
#  ##               LET g_doc.value3 = g_npp.nppsys
#  ##               LET g_doc.column4 = "npp00"
#  ##               LET g_doc.value4 = g_npp.npp00
#  ##                #-----No.MOD-4C0029 END-----
#  ##               CALL cl_doc()
#  ##            END IF
#  ##         END IF
#  ##
#  ##      WHEN "help" 
#  ##         CALL cl_show_help()
#  ##      WHEN "exit"
#  ##         EXIT WHILE
#  ##      WHEN "controlg"
#  ##         CALL cl_cmdask()
#  ##      WHEN "carry_voucher" 
#  ##         CALL i501_trans() 
#  ##      WHEN "undo_carry"
#  ##         CALL i501_untrans() 
#  ##      WHEN "exporttoexcel"   #No.FUN-4B0019
#  ##         IF cl_chk_act_auth() THEN
#  ##           CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_npq),'','')
#  ##         END IF
#  ##   END CASE
#  ##END WHILE
#    MENU ""
#       BEFORE MENU
#          CALL cl_navigator_setting(g_curs_index, g_row_count)
#       ON ACTION query
#          LET g_action_choice="query"
#          IF cl_chk_act_auth() THEN
#             CALL i501_q()
#          END IF
#       ON ACTION delete
#          LET g_action_choice="delete"
#          IF cl_chk_act_auth() THEN
#             CALL i501_r()
#          END IF
#       ON ACTION help
#           CALL cl_show_help()
#       ON ACTION exit
#           LET g_action_choice = "exit"
#           EXIT MENU
#       ON ACTION jump
#           CALL i501_fetch('/')
#       ON ACTION first
#           CALL i501_fetch('F')
#       ON ACTION next
#           CALL i501_fetch('N')
#       ON ACTION previous
#           CALL i501_fetch('P')
#       ON ACTION last
#           CALL i501_fetch('L')
#       ON ACTION controlg
#           CALL cl_cmdask()
#       ON ACTION locale
#           CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE MENU
#       ON ACTION about         #MOD-4C0121
#          CALL cl_about()      #MOD-4C0121
#       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
#          LET INT_FLAG=FALSE                 #MOD-570244     mars
#          LET g_action_choice = "exit"
#          EXIT MENU
#       ON ACTION related_document
#          LET g_action_choice="related_document"
#          IF cl_chk_act_auth() THEN
#             IF g_npp.npp01 IS NOT NULL THEN
#                LET g_doc.column1 = "npp01"
#                LET g_doc.value1 = g_npp.npp01
#                CALL cl_doc()
#             END IF
#          END IF
#       ON ACTION entry_sheet   #分錄底稿
#          LET g_action_choice="entry_sheet"
#          IF cl_chk_act_auth() THEN
#             CALL i501_npq()
#          END IF
#       ON ACTION carry_voucher 
#          LET g_action_choice="carry_voucher"
#          IF cl_chk_act_auth() THEN
#             CALL i501_trans() 
#          END IF
#       ON ACTION undo_carry
#          LET g_action_choice="undo_carry"
#          IF cl_chk_act_auth() THEN
#             CALL i501_untrans() 
#          END IF
#      #FUN-810046
#      &include "qry_string.4gl"
#    END MENU
#    CLOSE i501_cs
#  ##end FUN-620022 mark
# 
#END FUNCTION
# 
##Query 查詢
#FUNCTION i501_q()
# 
#    LET g_row_count = 0
#    LET g_curs_index = 0
#    CALL cl_navigator_setting( g_curs_index, g_row_count )
#    INITIALIZE g_npp.* TO NULL        #No.FUN-6A0001 
#    CALL cl_opmsg('q')
#    MESSAGE ""
#    CALL i501_cs()                    #取得查詢條件
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
#    OPEN i501_cs                            # 從DB產生合乎條件TEMP(0-30秒)
#    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_npp.npp01,SQLCA.sqlcode,1)
#        INITIALIZE g_npp.* TO NULL
#    ELSE
#         OPEN i501_count
#         FETCH i501_count INTO g_row_count
#         DISPLAY g_row_count TO FORMONLY.cnt
# 
#         CALL i501_fetch('F')                # 讀出TEMP第一筆並顯示
#    END IF
#END FUNCTION
# 
##處理資料的讀取
#FUNCTION i501_fetch(p_flag)
#DEFINE
#    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
#    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
# 
#    CASE p_flag
#      WHEN 'N' FETCH NEXT  i501_cs INTO g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npp00
#      WHEN 'P' FETCH PREVIOUS i501_cs INTO g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npp00
#      WHEN 'F' FETCH FIRST i501_cs INTO g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npp00
#      WHEN 'L' FETCH LAST  i501_cs INTO g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npp00
#      WHEN '/'
#         #CKP3
#         IF (NOT g_no_ask) THEN
#        CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
#            LET INT_FLAG = 0  ######add for prompt bug
#        PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
#           ON IDLE g_idle_seconds
#              CALL cl_on_idle()
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
#        
#        END PROMPT
#        IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
#         #CKP3
#         END IF
#        FETCH ABSOLUTE g_jump i501_cs INTO g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npp00
#         LET g_no_ask = FALSE
#    END CASE
#    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_npp.npp01,SQLCA.sqlcode,0)
#        INITIALIZE g_npp.* TO NULL  #TQC-6B0105
#        RETURN
#    ELSE
#       CASE p_flag
#          WHEN 'F' LET g_curs_index = 1
#          WHEN 'P' LET g_curs_index = g_curs_index - 1
#          WHEN 'N' LET g_curs_index = g_curs_index + 1
#          WHEN 'L' LET g_curs_index = g_row_count
#          WHEN '/' LET g_curs_index = g_jump #CKP3
#       END CASE
#    
#       CALL cl_navigator_setting( g_curs_index, g_row_count )
#    END IF
#    SELECT * INTO g_npp.* FROM npp_file WHERE npp01=g_npp.npp01 AND npp011=g_npp.npp011 AND nppsys=g_npp.nppsys AND npp00=g_npp.npp00
#    IF SQLCA.sqlcode THEN
##       CALL cl_err(g_npp.npp01,SQLCA.sqlcode,1)   #No.FUN-660136
#        CALL cl_err3("sel","npp_file",g_npp.npp01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
#           INITIALIZE g_npp.* TO NULL
#        RETURN
#    ELSE
#        CALL i501_show()
#    END IF
#END FUNCTION 
# 
#FUNCTION i501_show()
#  DEFINE l_sysdes   LIKE type_file.chr8         #No.FUN-680070 VARCHAR(8)
#  DEFINE l_np0des   LIKE type_file.chr6             #No.FUN-680070 VARCHAR(6)
# 
#   #將資料顯示在畫面上
#   DISPLAY BY NAME g_npp.npp01, g_npp.npp03 ,g_npp.nppglno
# 
#  #CALL i501_b_fill()   #FUN-620022 mark
#  #CALL i501_chk()      #FUN-620022 mark
#   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#END FUNCTION
# 
##start FUN-620022 mark
###FUNCTION i501_b_fill()
###
###  # LET g_sql= " SELECT npq02,npq03,npq05,aag02,npq04,npq06,npq07 ",  #MOD-5C0103
###   LET g_sql= " SELECT npq02,npq03,aag02,npq05,npq06,npq07,npq04,npq15, ",   #MOD-5C0103
###              " npq08,npq11,npq12,npq13,npq14 ",   #MOD-5C0103
###              " FROM npq_file,OUTER aag_file ",
###              " WHERE npqsys = '",g_npp.nppsys,"'  ",
###              " AND npq00 = ",g_npp.npp00," ",
###              " AND npq01 = '",g_npp.npp01,"' ",
###              " AND npq011 = ",g_npp.npp011," ",
###              " AND npq03 = aag_file.aag01 ",
###              " ORDER BY npq02 "
###   PREPARE i105_pb FROM g_sql
###   DECLARE npq_curs CURSOR FOR i105_pb        #SCROLL CURSOR
###
###   CALL g_npq.clear()
###   LET g_rec_b = 0 
###   LET g_cnt = 1
###   LET g_npq07_t1 = 0   
###   LET g_npq07_t2 = 0
###   FOREACH npq_curs INTO g_npq[g_cnt].*              #單身 ARRAY 填充
###      LET g_cnt = g_cnt + 1
###     # genero shell add g_max_rec check START
###     IF g_cnt > g_max_rec THEN
###        CALL cl_err( '', 9035, 0 )
###        EXIT FOREACH
###     END IF
###     # genero shell add g_max_rec check END
###   END FOREACH
###   CALL g_npq.deleteElement(g_cnt)
###   LET g_rec_b= g_cnt-1
###   DISPLAY g_rec_b TO FORMONLY.cn2
###END FUNCTION 
###
###FUNCTION i501_bp(p_ud)
###   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
###   
###   IF p_ud <> "G" OR g_action_choice = "detail" THEN
###      RETURN
###   END IF
###   
###   LET g_action_choice = " "
###   
###   CALL cl_set_act_visible("accept,cancel", FALSE)
###   DISPLAY ARRAY g_npq TO s_npq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
###   
###      BEFORE DISPLAY
###         CALL cl_navigator_setting( g_curs_index, g_row_count )
###   
###      BEFORE ROW
###         LET l_ac = ARR_CURR()
###         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
###   
###      ##########################################################################
###      # Standard 4ad ACTION
###      ##########################################################################
###      ON ACTION query
###         LET g_action_choice="query"
###         EXIT DISPLAY
###      ON ACTION delete
###         LET g_action_choice="delete"
###         EXIT DISPLAY
###      ON ACTION first 
###         CALL i501_fetch('F')
###         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
###         IF g_rec_b != 0 THEN
###            CALL fgl_set_arr_curr(1)  ######add in 040505
###         END IF
###         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
###                              
###      ON ACTION previous
###         CALL i501_fetch('P') 
###         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
###         IF g_rec_b != 0 THEN
###            CALL fgl_set_arr_curr(1)  ######add in 040505
###         END IF
###         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
###   
###      ON ACTION jump 
###         CALL i501_fetch('/')
###         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
###         IF g_rec_b != 0 THEN
###            CALL fgl_set_arr_curr(1)  ######add in 040505
###         END IF
###         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
###                              
###      ON ACTION next
###         CALL i501_fetch('N')
###         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
###         IF g_rec_b != 0 THEN
###            CALL fgl_set_arr_curr(1)  ######add in 040505
###         END IF
###         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
###                              
###      ON ACTION last 
###         CALL i501_fetch('L')
###         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
###         IF g_rec_b != 0 THEN
###            CALL fgl_set_arr_curr(1)  ######add in 040505
###         END IF
###         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
###   
###      ON ACTION detail
###         LET g_action_choice="detail"
###         LET l_ac = 1
###         EXIT DISPLAY
###
###    #@ON ACTION 相關文件  
###      ON ACTION related_document  #No.MOD-470515
###         LET g_action_choice="related_document"
###         EXIT DISPLAY
###   
###      ON ACTION help
###         LET g_action_choice="help"
###         EXIT DISPLAY
###   
###      ON ACTION locale
###         CALL cl_dynamic_locale()
###          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
###   
###      ON ACTION exit
###         LET g_action_choice="exit"
###         EXIT DISPLAY
###   
###      ##########################################################################
###      # Special 4ad ACTION
###      ##########################################################################
###      ON ACTION controlg 
###         LET g_action_choice="controlg"
###         EXIT DISPLAY
###    #@ON ACTION 傳票拋轉
###      ON ACTION carry_voucher
###         LET g_action_choice="carry_voucher"
###         EXIT DISPLAY
###    #@ON ACTION 傳票拋轉還原
###      ON ACTION undo_carry
###         LET g_action_choice="undo_carry"
###         EXIT DISPLAY
###   
###      ON ACTION accept
###         LET g_action_choice="detail"
###         LET l_ac = ARR_CURR()
###         EXIT DISPLAY
###      
###      ON ACTION cancel
###         LET INT_FLAG=FALSE 		#MOD-570244	mars
###         LET g_action_choice="exit"
###         EXIT DISPLAY
###   
###      ON IDLE g_idle_seconds
###         CALL cl_on_idle()
###         CONTINUE DISPLAY
###   
###      ON ACTION about         #MOD-4C0121
###         CALL cl_about()      #MOD-4C0121
###   
###      ON ACTION exporttoexcel   #No.FUN-4B0019
###         LET g_action_choice = 'exporttoexcel'
###         EXIT DISPLAY
###   
###      # No.FUN-530067 --start--
###      AFTER DISPLAY
###         CONTINUE DISPLAY
###      # No.FUN-530067 ---end---
###   
###   END DISPLAY
###   CALL cl_set_act_visible("accept,cancel", TRUE)
###END FUNCTION
###
###FUNCTION i501_chk()
###   LET g_npq07_t1 = 0 LET g_npq07_t2 = 0
###   # 借方合計
###   SELECT SUM(npq07) INTO g_npq07_t1 FROM npq_file 
###    WHERE npqsys = g_npp.nppsys AND npq00=g_npp.npp00 
###      AND npq01=g_npp.npp01 AND npq011=g_npp.npp011 AND npq06='1'
###
###   # 貸方合計
###   SELECT SUM(npq07) INTO g_npq07_t2 FROM npq_file 
###    WHERE npqsys = g_npp.nppsys AND npq00=g_npp.npp00 
###      AND npq01=g_npp.npp01 AND npq011=g_npp.npp011 AND npq06='2'
###
###   DISPLAY g_npq07_t1,g_npq07_t2 TO npq07_t1,npq07_t2 
###END FUNCTION
###
###FUNCTION i501_b()
###DEFINE
###   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
###   l_row,l_col     LIKE type_file.num5,  		   #分段輸入之行,列數       #No.FUN-680070 SMALLINT
###   l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
###   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
###   p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
###   l_b2      	    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
###   l_str           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(80)
###   l_buf           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
###   l_buf1          LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
###   l_cmd           LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(20)
###   l_rowid         LIKE type_file.chr18,        #No.FUN-680070 INT # saki 20070821 rowid chr18 -> num10 
###   l_flag          LIKE type_file.num10,        #No.FUN-680070 INTEGER
###   l_afb07         LIKE afb_file.afb07,
###   l_amt           LIKE npq_file.npq07,
###   l_tol           LIKE npq_file.npq07,
###   l_tol1          LIKE npq_file.npq07,
###   total_t         LIKE npq_file.npq07,
###   l_aag05         LIKE aag_file.aag05,
###   l_aag06         LIKE aag_file.aag06,  #借餘或貸餘
###   l_aag15         LIKE aag_file.aag15,
###   l_aag16         LIKE aag_file.aag16,
###   l_aag17         LIKE aag_file.aag17,
###   l_aag18         LIKE aag_file.aag18,
###   l_aag151        LIKE aag_file.aag151,
###   l_aag161        LIKE aag_file.aag161,
###   l_aag171        LIKE aag_file.aag171,
###   l_aag181        LIKE aag_file.aag181,
###   l_aag21         LIKE aag_file.aag21,
###   l_aag23         LIKE aag_file.aag23, 
###   l_nmg20         LIKE nmg_file.nmg20, 
###   l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
###   l_allow_delete  LIKE type_file.num5,                #可刪除否       #No.FUN-680070 SMALLINT
###   l_afb04         LIKE afb_file.afb04,   #MOD-5C0103
###   l_afb15         LIKE afb_file.afb15,   #MOD-5C0103
###   l_dept          LIKE gem_file.gem01    #MOD-5C0103
###
###   LET g_action_choice = ""
###   IF g_npp.npp01 IS NULL THEN RETURN END IF
###   CALL cl_opmsg('b')
###
###  # LET g_forupd_sql = " SELECT npq02,npq03,npq05,'',npq04,npq06,npq07 ",   #MOD-5C0103
###   LET g_forupd_sql = " SELECT npq02,npq03,'',npq05,npq06,npq07,npq04, ",   #MOD-5C0103
###                      " npq15,npq08,npq11,npq12,npq13,npq14 ",   #MOD-5C0103
###                      "  FROM npq_file ",
###                      " WHERE npqsys = ? ",
###                      "   AND npq00  = ? ",
###                      "   AND npq01  = ? ",
###                      "   AND npq011 = ? ",
###                      "   AND npq02  = ? ",
###                      "   FOR UPDATE "
###   DECLARE i501_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
###
###   LET l_ac_t = 0
###   LET l_allow_insert = cl_detail_input_auth("insert")
###   LET l_allow_delete = cl_detail_input_auth("delete")
###
###   #CKP2
###   IF g_rec_b=0 THEN CALL g_npq.clear() END IF
###
###   INPUT ARRAY g_npq WITHOUT DEFAULTS FROM s_npq.* 
###         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
###                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
###
###      BEFORE INPUT
###         IF g_rec_b != 0 THEN
###           CALL fgl_set_arr_curr(l_ac)
###         END IF
###
###      BEFORE ROW
###         LET p_cmd=''
###         LET l_ac = ARR_CURR() 
###        #LET g_npq_t.* = g_npq[l_ac].*  #BACKUP
###         LET l_lock_sw = 'N'                   #DEFAULT
###         LET l_n  = ARR_COUNT()
###         LET g_success='Y'
###         BEGIN WORK
###
###         OPEN i501_cl USING g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npp00
###         IF STATUS THEN
###            CALL cl_err("OPEN i501_cl:", STATUS, 1)
###            CLOSE i501_cl
###            ROLLBACK WORK
###            RETURN
###         END IF
###         FETCH i501_cl INTO g_npp.*
###         IF SQLCA.sqlcode THEN
###            CALL cl_err(g_npp.npp01,SQLCA.sqlcode,0)
###            CLOSE i501_cl ROLLBACK WORK RETURN
###         END IF
###         IF g_rec_b>=l_ac THEN
###         #IF g_npq[l_ac].npq02 IS NOT NULL THEN
###            LET p_cmd='u'
###            LET g_npq_t.* = g_npq[l_ac].*  #BACKUP
###
###            OPEN i501_bcl USING g_npp.nppsys,g_npp.npp00,g_npp.npp01,g_npp.npp011,g_npq_t.npq02
###            IF STATUS THEN
###               CALL cl_err("OPEN i501_bcl:", STATUS, 1)
###               CLOSE i501_bcl
###               ROLLBACK WORK
###               RETURN
###            ELSE
###               FETCH i501_bcl INTO g_npq[l_ac].*
###               IF SQLCA.sqlcode THEN
###                  CALL cl_err('lock npq',SQLCA.sqlcode,1)
###                  LET l_lock_sw = "Y"
###               END IF
###               SELECT aag02 INTO g_npq[l_ac].aag02 FROM aag_file
###               WHERE aag01=g_npq[l_ac].npq03
###            END IF
###            CALL cl_show_fld_cont()     #FUN-550037(smin)
###         END IF
###         CALL i501_set_entry_b()     #MOD-5C0103
###         CALL i501_set_no_entry_b()  #MOD-5C0103
###       # LET g_npq_t.* = g_npq[l_ac].*  #BACKUP
###       # NEXT FIELD npq02
###
###      AFTER INSERT
###         IF INT_FLAG THEN
###            CALL cl_err('',9001,0)
###            LET INT_FLAG = 0
###            #CKP2
###            INITIALIZE g_npq[l_ac].* TO NULL  #重要欄位空白,無效
###            DISPLAY g_npq[l_ac].* TO s_npq.*
###            CALL g_npq.deleteElement(l_ac)
###            ROLLBACK WORK
###            EXIT INPUT
###           #CANCEL INSERT
###         END IF
###         IF cl_null(g_npq[l_ac].npq07) THEN LET g_npq[l_ac].npq07=0 END IF 
###       #MOD-5C0103
###       #  INSERT INTO npq_file(npqsys,npq00,npq01,npq011,npq02,npq03,
###       #       	        npq04,npq05,npq06,npq07f,npq07,npq24,
###       #                       npq25)
###       #                VALUES(g_npp.nppsys,g_npp.npp00,g_npp.npp01,
###       #                      g_npp.npp011,g_npq[l_ac].npq02,
###       #       		g_npq[l_ac].npq03,g_npq[l_ac].npq04,
###       #       		g_npq[l_ac].npq05,g_npq[l_ac].npq06,
###       #                      g_npq[l_ac].npq07 ,g_npq[l_ac].npq07,
###       #                      g_aza.aza17,1)
###         INSERT INTO npq_file(npqsys,npq00,npq01,npq011,npq02,npq03,
###                             npq04,npq05,npq06,npq07f,npq07,npq08,
###                             npq11,npq12,npq13,npq14,npq15,npq24,npq25)
###                       VALUES(g_npp.nppsys,g_npp.npp00,g_npp.npp01,
###                              g_npp.npp011,g_npq[l_ac].npq02,
###                             g_npq[l_ac].npq03,g_npq[l_ac].npq04,
###                             g_npq[l_ac].npq05,g_npq[l_ac].npq06,
###                             g_npq[l_ac].npq07,g_npq[l_ac].npq07,
###                             g_npq[l_ac].npq08,g_npq[l_ac].npq11,
###                             g_npq[l_ac].npq12,g_npq[l_ac].npq13,
###                             g_npq[l_ac].npq14,g_npq[l_ac].npq15,
###                             g_aza.aza17,1)
###       #END MOD-5C0103
###         IF SQLCA.sqlcode THEN
###           #CALL cl_err('ins npq',SQLCA.sqlcode,1)   #No.FUN-660136
###            CALL cl_err3("ins","npq_file",g_npp.npp01,g_npq[l_ac].npq02,SQLCA.sqlcode,"","ins npq",1)  #No.FUN-660136
###            LET g_success = 'N'
###            CANCEL INSERT
###         END IF
###         IF g_success='Y' 
###            THEN COMMIT WORK 
###                 LET g_rec_b=g_rec_b+1 
###                 MESSAGE 'Insert Ok!'
###            ELSE ROLLBACK WORK
###         END IF
###         DISPLAY g_rec_b TO FORMONLY.cn2
###         CALL i501_chk()
###
###      BEFORE INSERT
###         LET l_n = ARR_COUNT()
###         LET p_cmd='a'
###         INITIALIZE g_npq[l_ac].* TO NULL      #900423
###         LET g_npq_t.* = g_npq[l_ac].*  #BACKUP
###         CALL cl_show_fld_cont()     #FUN-550037(smin)
###         NEXT FIELD npq02
###
###      BEFORE FIELD npq02                       #default 行序
###         IF cl_null(g_npq[l_ac].npq02) OR g_npq[l_ac].npq02=0 THEN
###            SELECT max(npq02)+1 INTO g_npq[l_ac].npq02 FROM npq_file
###             WHERE npqsys = g_npp.nppsys AND npq00 = g_npp.npp00 
###                     AND npq01 = g_npp.npp01 AND npq011=g_npp.npp011
###            IF g_npq[l_ac].npq02 IS NULL THEN 
###               LET g_npq[l_ac].npq02=1
###            END IF
###             #NO.MOD-570129 MARK
###            #DISPLAY g_npq[l_ac].npq02 TO npq02
###         END IF
###
###      AFTER FIELD npq02                         #check是否重複
###         IF NOT cl_null(g_npq[l_ac].npq02) THEN 
###            IF g_npq[l_ac].npq02 != g_npq_t.npq02 OR 
###               g_npq_t.npq02 IS NULL THEN
###               SELECT COUNT(*) INTO g_cnt FROM npq_file
###               WHERE npqsys = g_npp.nppsys AND npq00=g_npp.npp00 
###                      AND npq01=g_npp.npp01 AND npq011=g_npp.npp011 
###                      AND npq02=g_npq[l_ac].npq02
###               IF g_cnt > 0 THEN 
###                  CALL cl_err('',-239,0) NEXT FIELD npq02       
###               END IF
###            END IF
###         END IF
###
###      AFTER FIELD npq03     #會計科目
###         IF NOT cl_null(g_npq[l_ac].npq03) THEN
###         #MOD-5C0103
###            LET g_npq[l_ac].aag02=''
###            LET l_aag05='' LET l_aag15='' LET l_aag16=''
###            LET l_aag17='' LET l_aag18='' LET l_aag151=''
###            LET l_aag161='' LET l_aag171='' LET l_aag181=''
###            LET l_aag06='' LET l_aag21='' LET l_aag23=''
###            SELECT aag02,aag05,aag15,aag16,aag17,aag18,aag151,
###                     aag161,aag171,aag181,aag06,aag21,aag23
###              INTO g_npq[l_ac].aag02,l_aag05,l_aag15,l_aag16,
###                   l_aag17,l_aag18,l_aag151,l_aag161,l_aag171,
###                   l_aag181,l_aag06,l_aag21,l_aag23
###              FROM aag_file
###             WHERE aag01=g_npq[l_ac].npq03
###            #SELECT aag02,aag05 INTO g_npq[l_ac].aag02,l_aag05
###            #  FROM aag_file
###            # WHERE aag01=g_npq[l_ac].npq03
###         #END MOD-5C0103
###            IF STATUS THEN
###              #CALL cl_err('sel aag',STATUS,0)    #No.FUN-660136
###               CALL cl_err3("sel","aag_file",g_npq[l_ac].npq03,"",STATUS,"","sel aag",1)  #No.FUN-660136
###               LET g_npq[l_ac].npq03 = g_npq_t.npq03
###               DISPLAY g_npq[l_ac].npq03 TO npq03 
###               NEXT FIELD npq03
###            END IF
###            DISPLAY g_npq[l_ac].aag02 TO aag02
###            CALL i501_aag(g_npq[l_ac].npq03)
###            IF NOT cl_null(g_errno) THEN
###               CALL cl_err(g_npq[l_ac].npq03,g_errno,0) NEXT FIELD npq03
###            END IF
###         END IF
###         CALL i501_set_entry_b()     #MOD-5C0103
###         CALL i501_set_no_entry_b()  #MOD-5C0103
###
###    #MOD-5C0103
###      BEFORE FIELD npq05   #部門
###         LET l_aag05=''
###         SELECT aag05 INTO l_aag05 FROM aag_file
###            WHERE aag01=g_npq[l_ac].npq03
###         IF l_aag05 = 'N' OR cl_null(l_aag05) THEN
###            LET g_npq[l_ac].npq05=''
###            DISPLAY BY NAME g_npq[l_ac].npq05
###         END IF
###    #END MOD-5C0103
###
###      AFTER FIELD npq05     #部門
###         IF l_aag05 MATCHES '[yY]' AND cl_null(g_npq[l_ac].npq05) THEN 
###            NEXT FIELD npq05
###         END IF
###         IF NOT cl_null(g_npq[l_ac].npq05) THEN
###            SELECT gem01 FROM gem_file WHERE gem01=g_npq[l_ac].npq05
###               AND gemacti='Y'   #NO:6950
###            IF STATUS THEN
###              #CALL cl_err('select gem',STATUS,1)    #No.FUN-660136
###               CALL cl_err3("sel","gem_file",g_npq[l_ac].npq05,"",STATUS,"","select gem",1)  #No.FUN-660136
###               NEXT FIELD npq05
###            END IF
###         END IF
###
###      AFTER FIELD npq06   #借/貸 1/2
###         IF NOT cl_null(g_npq[l_ac].npq06) THEN
###            IF g_npq[l_ac].npq06 NOT MATCHES '[12]' THEN 
###               NEXT FIELD npq06 
###            END IF
###         END IF
###
###      AFTER FIELD npq07    #本幣金額
###         IF NOT cl_null(g_npq[l_ac].npq07) THEN
###            IF g_npq[l_ac].npq07=0 THEN
###               NEXT FIELD npq07
###            END IF
###         END IF
###
###    #MOD-5C0103
###      BEFORE FIELD npq15  #預算編號
###         LET l_aag06 = '' LET l_aag21=''
###         SELECT aag06,aag21 INTO l_aag06,l_aag21 FROM aag_file
###            WHERE aag01=g_npq[l_ac].npq03
###         IF l_aag21 = 'N' OR cl_null(l_aag21) THEN
###            LET g_npq[l_ac].npq15=' '
###            DISPLAY BY NAME g_npq[l_ac].npq15
###         END IF
###
###      AFTER FIELD npq15  #預算編號
###         IF cl_null(g_npq[l_ac].npq15) AND l_aag21 = 'Y' THEN
###            NEXT FIELD npq15
###         END IF
###         IF g_npq[l_ac].npq15 IS NOT NULL AND g_npq[l_ac].npq15 !=' ' THEN
###            SELECT azn02,azn04 INTO g_azn02,g_azn04  FROM azn_file
###              WHERE azn01 = g_npp.npp02
###            IF g_npq[l_ac].npq05 IS NULL OR g_npq[l_ac].npq05=' ' THEN
###               LET l_dept='@'
###            ELSE
###               LET l_dept = g_npq[l_ac].npq05
###            END IF
###            SELECT afb04,afb15 INTO l_afb04,l_afb15
###              FROM afb_file WHERE afb00 = g_argv5 AND
###                                  afb01 = g_npq[l_ac].npq15 AND
###                                  afb02 = g_npq[l_ac].npq03 AND
###                                  afb03 = g_azn02 AND afb04 = l_dept
###            IF SQLCA.sqlcode THEN
###              #CALL cl_err(g_npq[l_ac].npq15,'agl-139',0)   #No.FUN-660136
###               CALL cl_err3("sel","afb_file",g_argv5,g_npq[l_ac].npq15,"agl-139","","",1)  #No.FUN-660136
###               LET g_npq[l_ac].npq15 = g_npq_t.npq15
###               NEXT FIELD npq15
###            END IF
###            CALL s_getbug(g_argv5,g_npq[l_ac].npq15,g_npq[l_ac].npq03,
###                          g_azn02,g_azn04,l_afb04,l_afb15)
###                 RETURNING l_flag,l_afb07,l_amt
###            IF l_flag THEN CALL cl_err('','agl-139',0) END IF #若不成功#
###            IF l_afb07  = '1' THEN #不做超限控制
###               NEXT FIELD npq08
###            ELSE
###            #----------????????????????年度,期別-----------
###                SELECT SUM(npq07) INTO l_tol FROM npq_file,npp_file
###                       WHERE npq01 = npp01
###                         AND npq03 = g_npq[l_ac].npq03
###                         AND npq15 = g_npq[l_ac].npq15 AND npq06 = '1' #借方
###                       #no.6353
###                         AND YEAR(npp02) = g_azn02
###                         AND MONTH(npp02) = g_azn04
###                         AND ( npq01 != g_npp.npp01 OR
###                              (npq01  = g_npp.npp01 AND
###                               npq02 != g_npq[l_ac].npq02))
###                       #no.6353(end)
###                IF SQLCA.sqlcode OR l_tol IS NULL THEN
###                   LET l_tol = 0
###                END IF
###               SELECT SUM(npq07) INTO l_tol1 FROM npq_file,npp_file
###                      WHERE npq01 = npp01
###                        AND npq03 = g_npq[l_ac].npq03
###                        AND npq15 = g_npq[l_ac].npq15 AND npq06 = '2' #貸方
###                       #no.6353
###                         AND YEAR(npp02) = g_azn02
###                         AND MONTH(npp02) = g_azn04
###                         AND ( npq01 != g_npp.npp01 OR
###                              (npq01  = g_npp.npp01 AND
###                               npq02 != g_npq[l_ac].npq02))
###                       #no.6353(end)
###               IF SQLCA.sqlcode OR l_tol1 IS NULL THEN
###                  LET l_tol1 = 0
###               END IF
###                IF l_aag06 = '1' THEN #借餘
###                      LET total_t = l_tol - l_tol1   #借減貸
###                ELSE #貸餘
###                      LET total_t = l_tol1 - l_tol   #貸減借
###                END IF
###
###               #IF p_cmd = 'a' THEN #若本筆資料為新增則加上本次輸入的值
###                LET total_t = total_t + g_npq[l_ac].npq07  #no.6353
###               #ELSE #若為更改則減掉舊值再加上新值
###               #   LET total_t = total_t - g_npq_t.npq07 +
###               #                 g_npq[l_ac].npq07
###               #END IF
###                IF total_t > l_amt THEN #借餘大於預算金額
###                   CASE l_afb07
###                        WHEN '2'
###                                CALL cl_getmsg('agl-140',0) RETURNING l_buf
###                                CALL cl_getmsg('agl-141',0) RETURNING l_buf1
###                                ERROR l_buf CLIPPED,' ',total_t,
###                                      l_buf1 CLIPPED,' ',l_amt
###                                 NEXT FIELD npq08
###                        WHEN '3'
###                                CALL cl_getmsg('agl-142',0) RETURNING l_buf
###                                CALL cl_getmsg('agl-143',0) RETURNING l_buf
###                                ERROR l_buf CLIPPED,' ',total_t,
###                                      l_buf1 CLIPPED,' ',l_amt
###                                 NEXT FIELD npq15
###                   END CASE
###                END IF
###            END IF
###         END IF
###
###      BEFORE FIELD npq08  #專案編號
###         LET l_aag23=''
###         SELECT aag23 INTO l_aag23 FROM aag_file
###            WHERE aag01=g_npq[l_ac].npq03
###         IF l_aag23 = 'N' OR cl_null(l_aag23) THEN
###            LET g_npq[l_ac].npq08=''
###            DISPLAY BY NAME g_npq[l_ac].npq08
###         END IF
###
###      AFTER FIELD npq08   #專案編號
###         IF g_npq[l_ac].npq08 IS NOT NULL AND g_npq[l_ac].npq08 != ' ' THEN
###            SELECT * FROM gja_file WHERE gja01 = g_npq[l_ac].npq08
###            IF SQLCA.sqlcode THEN
###              #CALL cl_err(g_npq[l_ac].npq08,'agl-007',0)   #No.FUN-660136
###               CALL cl_err3("sel","gja_file",g_npq[l_ac].npq08,"","agl-007","","",1)  #No.FUN-660136
###               LET g_npq[l_ac].npq08 = g_npq_t.npq08
###               NEXT FIELD npq08
###            END IF
###         END IF
###
###      BEFORE FIELD npq11  #  npq03-npq11-npq12
###         LET l_aag15='' LET l_aag151=''
###         SELECT aag15,aag151 INTO l_aag15,l_aag151 FROM aag_file
###            WHERE aag01=g_npq[l_ac].npq03
###         IF l_aag15 IS NOT NULL AND l_aag15 != ' ' THEN
###              CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
###              LET l_str = l_str CLIPPED,l_aag15,'!'
###              ERROR l_str
###         END IF
###         IF cl_null(l_aag151) THEN
###            LET g_npq[l_ac].npq11=''
###            DISPLAY BY NAME g_npq[l_ac].npq11
###         END IF
###
###      AFTER FIELD npq11
###         CALL i104_npq11(l_aag151,'1',g_npq[l_ac].npq11)
###         IF NOT cl_null(g_errno) THEN
###            CALL cl_err('sel aee:',g_errno,1)
###            NEXT FIELD npq11
###         END IF
###
###      BEFORE FIELD npq12  #  npq11-npq12-npq13
###         LET l_aag16='' LET l_aag161=''
###         SELECT aag16,aag161 INTO l_aag16,l_aag161 FROM aag_file
###            WHERE aag01=g_npq[l_ac].npq03
###         IF l_aag16 IS NOT NULL AND l_aag16 != ' ' THEN
###              CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
###              LET l_str = l_str CLIPPED,l_aag16,'!'
###              ERROR l_str
###         END IF
###         IF cl_null(l_aag161) THEN
###            LET g_npq[l_ac].npq12=''
###            DISPLAY BY NAME g_npq[l_ac].npq12
###         END IF
###      
###      AFTER FIELD npq12
###         CALL i104_npq11(l_aag161,'2',g_npq[l_ac].npq12)
###         IF NOT cl_null(g_errno) THEN
###            CALL cl_err('sel aee:',g_errno,1)
###            NEXT FIELD npq12
###         END IF
###
###      BEFORE FIELD npq13  #  npq12-npq13-npq14
###         LET l_aag17='' LET l_aag171=''
###
###         SELECT aag17,aag171 INTO l_aag17,l_aag171 FROM aag_file
###            WHERE aag01=g_npq[l_ac].npq03
###         IF l_aag17 IS NOT NULL AND l_aag17 != ' ' THEN
###            CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
###            LET l_str = l_str CLIPPED,l_aag17,'!'
###            ERROR l_str
###         END IF
###         IF cl_null(l_aag171) THEN
###            LET g_npq[l_ac].npq13=''
###            DISPLAY BY NAME g_npq[l_ac].npq13
###         END IF
###
###      AFTER FIELD npq13
###         CALL i104_npq11(l_aag171,'3',g_npq[l_ac].npq13)
###         IF NOT cl_null(g_errno) THEN
###            CALL cl_err('sel aee:',g_errno,1) NEXT FIELD npq13
###         END IF
###
###      BEFORE FIELD npq14
###         LET l_aag18='' LET l_aag181=''
###         SELECT aag18,aag181 INTO l_aag18,l_aag181 FROM aag_file
###            WHERE aag01=g_npq[l_ac].npq03
###         IF l_aag18 IS NOT NULL AND l_aag18 != ' ' THEN
###              CALL cl_getmsg('agl-098',g_lang) RETURNING l_str
###              LET l_str = l_str CLIPPED,l_aag18,'!'
###              ERROR l_str
###         END IF
###         IF cl_null(l_aag181) THEN
###            LET g_npq[l_ac].npq14=''
###            DISPLAY BY NAME g_npq[l_ac].npq14
###         END IF
###
###      AFTER FIELD npq14
###         CALL i104_npq11(l_aag181,'4',g_npq[l_ac].npq14)
###         IF NOT cl_null(g_errno) THEN
###            CALL cl_err('sel aee:',g_errno,1)
###            NEXT FIELD npq14
###         END IF
###
###      AFTER FIELD npq04
###         LET g_msg = g_npq[l_ac].npq04
###         IF g_msg[1,1] = '.' THEN
###            LET g_msg = g_msg[2,10]
###            SELECT aad02 INTO g_npq[l_ac].npq04 FROM aad_file
###             WHERE aad01 = g_msg AND aadacti = 'Y'
###            NEXT FIELD npq04
###         END IF
###    #END MOD-5C0103
###
###      BEFORE DELETE                            #是否取消單身
###         IF g_npq_t.npq02 > 0 AND g_npq_t.npq02 IS NOT NULL THEN
###            IF NOT cl_delb(0,0) THEN
###                 CANCEL DELETE
###            END IF
###            # genero shell add start
###            IF l_lock_sw = "Y" THEN 
###               CALL cl_err("", -263, 1) 
###               CANCEL DELETE 
###            END IF 
###            # genero shell add end
###            DELETE FROM npq_file WHERE npqsys=g_npp.nppsys 
###               AND npq00= g_npp.npp00 AND npq01 =g_npp.npp01 
###               AND npq011 =g_npp.npp011 AND npq02= g_npq_t.npq02
###            IF SQLCA.sqlcode THEN
###               LET g_success = 'N'
###              #CALL cl_err(g_npq_t.npq02,SQLCA.sqlcode,1)   #No.FUN-660136
###               CALL cl_err3("del","npq_file",g_npp.npp01 ,g_npq_t.npq02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
###               ROLLBACK WORK
###               CANCEL DELETE
###            END IF
###            IF g_success='Y'   
###            THEN COMMIT WORK
###                 LET g_rec_b=g_rec_b-1
###                 MESSAGE 'Delete Ok!'
###            ELSE ROLLBACK WORK
###            END IF
###            DISPLAY g_rec_b TO FORMONLY.cn2
###         END IF
###
###      ON ROW CHANGE
###         IF INT_FLAG THEN
###            CALL cl_err('',9001,0)
###            LET INT_FLAG = 0
###            LET g_npq[l_ac].* = g_npq_t.*
###            CLOSE i501_bcl
###            ROLLBACK WORK
###            EXIT INPUT
###         END IF
###         IF l_lock_sw = 'Y' THEN
###            CALL cl_err(g_npq[l_ac].npq02,-263,1)
###            LET g_npq[l_ac].* = g_npq_t.*
###         ELSE
###            IF cl_null(g_npq[l_ac].npq07) THEN LET g_npq[l_ac].npq07=0 END IF
###          #MOD-5C0103
###          # UPDATE npq_file SET
###          #        npqsys=g_npp.nppsys,    npq00=g_npp.npp00,
###          #        npq01=g_npp.npp01,      npq011=g_npp.npp011,
###          #        npq02=g_npq[l_ac].npq02,npq03=g_npq[l_ac].npq03,
###          #        npq04=g_npq[l_ac].npq04,npq05=g_npq[l_ac].npq05,
###          #        npq06=g_npq[l_ac].npq06,npq07f=g_npq[l_ac].npq07,
###          #        npq07=g_npq[l_ac].npq07
###          #  WHERE npqsys = g_npp.nppsys AND npq00=g_npp.npp00 
###          #    AND npq01=g_npp.npp01 AND npq011=g_npp.npp011 
###          #    AND npq02=g_npq_t.npq02
###            UPDATE npq_file SET
###                   npqsys=g_npp.nppsys,
###                   npq00=g_npp.npp00,
###                   npq01=g_npp.npp01,
###                   npq011=g_npp.npp011,
###                   npq02=g_npq[l_ac].npq02,
###                   npq03=g_npq[l_ac].npq03,
###                   npq04=g_npq[l_ac].npq04,
###                   npq05=g_npq[l_ac].npq05,
###                   npq06=g_npq[l_ac].npq06,
###                   npq07=g_npq[l_ac].npq07,
###                   npq08=g_npq[l_ac].npq08,
###                   npq11=g_npq[l_ac].npq11,
###                   npq12=g_npq[l_ac].npq12,
###                   npq13=g_npq[l_ac].npq13,
###                   npq14=g_npq[l_ac].npq14,
###                   npq15=g_npq[l_ac].npq15
###             WHERE npqsys = g_npp.nppsys
###               AND npq00  = g_npp.npp00
###               AND npq01  = g_npp.npp01
###               AND npq011 = g_npp.npp011
###               AND npq02  = g_npq_t.npq02
###          #END MOD-5C0103
###            IF SQLCA.sqlcode THEN
###              #CALL cl_err('upd npq',SQLCA.sqlcode,1)   #No.FUN-660136
###               CALL cl_err3("upd","npq_file",g_npp.npp01,g_npq_t.npq02,SQLCA.sqlcode,"","upd npq",1)  #No.FUN-660136
###               LET g_success = 'N'
###            END IF
###            IF g_success='Y' THEN
###               COMMIT WORK
###               MESSAGE 'UPDATE O.K'
###            ELSE
###               ROLLBACK WORK
###            END IF
###            CALL i501_chk()
###         END IF
###
###      AFTER ROW
###         LET l_ac = ARR_CURR()
###         LET l_ac_t = l_ac
###         IF INT_FLAG THEN
###            CALL cl_err('',9001,0)
###            LET INT_FLAG = 0
###            IF p_cmd='u' THEN
###               LET g_npq[l_ac].* = g_npq_t.*
###            END IF
###            CLOSE i501_bcl
###            ROLLBACK WORK
###         #MOD-5C0103
###            CALL i501_chk()
###            IF cl_null(g_npq07_t1) THEN LET g_npq07_t1=0 END IF
###            IF cl_null(g_npq07_t2) THEN LET g_npq07_t2=0 END IF
###            IF g_npq07_t1 != g_npq07_t2
###               THEN    #本幣金額借貸相等否
###               CALL cl_err('','axr-058',1)
###               NEXT FIELD npq07
###            END IF
###         #END MOD-5C0103
###            EXIT INPUT
###         END IF
###        #LET g_npq_t.* = g_npq[l_ac].*
###         CLOSE i501_bcl
###         COMMIT WORK
###         #CKP2
###         CALL g_npq.deleteElement(g_rec_b+1)
###
###      AFTER INPUT
###         CALL i501_chk()
###         IF cl_null(g_npq07_t1) THEN LET g_npq07_t1=0 END IF   #MOD-5C0103
###         IF cl_null(g_npq07_t2) THEN LET g_npq07_t2=0 END IF   #MOD-5C0103
###         IF g_npq07_t1 != g_npq07_t2 
###         THEN    #本幣金額借貸相等否
###            CALL cl_err('','axr-058',1)
###            NEXT FIELD npq07   #MOD-5C0103
###         END IF
###         EXIT INPUT
###
###      ON ACTION CONTROLO                        #沿用所有欄位
###         IF INFIELD(npq02) AND l_ac > 1 THEN
###            LET g_npq[l_ac].* = g_npq[l_ac-1].*
###            LET g_npq[l_ac].npq02 = NULL
###            NEXT FIELD npq02
###         END IF
###
###      ON ACTION controlp
###         CASE
###            WHEN INFIELD(npq03)    #會計科目
###                 CALL cl_init_qry_var()
###                 LET g_qryparam.form = "q_aag"
###                 IF NOT cl_null(g_npq[l_ac].npq03) THEN
###                     LET g_qryparam.where =
###                     "aag01 IN '",g_npq[l_ac].npq03 CLIPPED,"'"
###                 END IF
###                 LET g_qryparam.default1 = g_npq[l_ac].npq03
###                 CALL cl_create_qry() RETURNING g_npq[l_ac].npq03
###                 #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq03 )
###                 DISPLAY g_npq[l_ac].npq03 TO npq03
###                 NEXT FIELD npq03
###            WHEN INFIELD(npq05) #部門編號
###                 CALL cl_init_qry_var()
###                 LET g_qryparam.form = "q_gem"
###                 LET g_qryparam.default1 = g_npq[l_ac].npq05
###                 CALL cl_create_qry() RETURNING g_npq[l_ac].npq05
###                 #CALL FGL_DIALOG_SETBUFFER( g_npq[l_ac].npq05 )
###                 DISPLAY g_npq[l_ac].npq05 TO npq05
###                 NEXT FIELD npq05
###         #MOD-5C0103
###            WHEN INFIELD(npq04) #常用摘要
###                 LET g_qryparam.form = 'q_aad2'
###                 LET g_qryparam.default1 = g_npq[l_ac].npq04
###                 LET g_qryparam.state = "i"
###                 CALL cl_create_qry() RETURNING g_npq[l_ac].npq04
###                 DISPLAY g_npq[l_ac].npq04 TO npq04
###                 NEXT FIELD npq04
###
###            WHEN INFIELD(npq08)    #查詢專案編號
###                 LET g_qryparam.form = 'q_gja'
###                 LET g_qryparam.default1 = g_npq[l_ac].npq08
###                 LET g_qryparam.state = "i"
###                 CALL cl_create_qry() RETURNING g_npq[l_ac].npq08
###                 DISPLAY g_npq[l_ac].npq08 TO npq08
###                 NEXT FIELD npq08
###
###            WHEN INFIELD(npq15)    #查詢預算編號
###                 LET g_qryparam.form = 'q_afa'
###                 LET g_qryparam.default1 = g_npq[l_ac].npq15
###                 LET g_qryparam.state = "i"
###                 CALL cl_create_qry() RETURNING g_npq[l_ac].npq15
###                 DISPLAY g_npq[l_ac].npq15 TO npq15
###                 NEXT FIELD npq15
###
###            WHEN INFIELD(npq11)    #查詢異動碼-1
###                 LET g_qryparam.form = 'q_aee'
###                 LET g_qryparam.default1 = g_npq[l_ac].npq11
###                 LET g_qryparam.state = "i"
###                 LET g_qryparam.arg1 = g_npq[l_ac].npq03
###                 LET g_qryparam.arg2 = 1
###                 CALL cl_create_qry() RETURNING g_npq[l_ac].npq11
###                 DISPLAY g_npq[l_ac].npq11 TO npq11
###                 NEXT FIELD npq11
###
###            WHEN INFIELD(npq12)    #查詢異動碼-2
###                 LET g_qryparam.form = 'q_aee'
###                 LET g_qryparam.default1 = g_npq[l_ac].npq12
###                 LET g_qryparam.state = "i"
###                 LET g_qryparam.arg1 = g_npq[l_ac].npq03
###                 LET g_qryparam.arg2 = 2
###                 CALL cl_create_qry() RETURNING g_npq[l_ac].npq12
###                 DISPLAY g_npq[l_ac].npq12 TO npq12
###                 NEXT FIELD npq12
###
###            WHEN INFIELD(npq13)    #查詢異動碼-3
###                 LET g_qryparam.form = 'q_aee'
###                 LET g_qryparam.default1 = g_npq[l_ac].npq13
###                 LET g_qryparam.state = "i"
###                 LET g_qryparam.arg1 = g_npq[l_ac].npq03
###                 LET g_qryparam.arg2 = 3
###                 CALL cl_create_qry() RETURNING g_npq[l_ac].npq13
###                 DISPLAY g_npq[l_ac].npq13 TO npq13
###                 NEXT FIELD npq13
###
###            WHEN INFIELD(npq14)    #查詢異動碼-4
###                 LET g_qryparam.form = 'q_aee'
###                 LET g_qryparam.default1 = g_npq[l_ac].npq14
###                 LET g_qryparam.state = "i"
###                 LET g_qryparam.arg1 = g_npq[l_ac].npq03
###                 LET g_qryparam.arg2 = 4
###                 CALL cl_create_qry() RETURNING g_npq[l_ac].npq14
###                 DISPLAY g_npq[l_ac].npq14 TO npq14
###                 NEXT FIELD npq14
###         #END MOD-5C0103
###
###         END CASE
###
###      ON ACTION CONTROLR
###         CALL cl_show_req_fields()
###
###      ON ACTION CONTROLG 
###         CALL cl_cmdask()
###
###      ON ACTION CONTROLF
###         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
###         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
###        
###      ON IDLE g_idle_seconds
###         CALL cl_on_idle()
###         CONTINUE INPUT
###
###      ON ACTION about         #MOD-4C0121
###         CALL cl_about()      #MOD-4C0121
###
###      ON ACTION help          #MOD-4C0121
###         CALL cl_show_help()  #MOD-4C0121
###      
###    END INPUT
###    IF g_success='Y' 
###       THEN COMMIT WORK
###       ELSE ROLLBACK WORK
###    END IF
###    CLOSE i501_bcl
###END FUNCTION
###end FUN-620022 mark
# 
#FUNCTION i501_trans()
#   DEFINE l_cmd		    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(400)
#          l_first_flag      LIKE type_file.chr1,         # 1:初次拋轉 2:重新拋轉    #No.FUN-680070 VARCHAR(1)
#          l_wc              LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
#          l_no_sep          LIKE type_file.chr3,         # 傳票單號區分選擇         #No.FUN-680070 VARCHAR(3)
#          l_tran            LIKE type_file.chr1,         # 是否列印摘要             #No.FUN-680070 VARCHAR(1)
#          l_apz02b          LIKE aaa_file.aaa01,         # 總帳帳別                 #No.FUN-670039
##          l_gl_no           LIKE type_file.chr3,        # 傳票單別                 #No.FUN-680070 VARCHAR(3)
#          l_gl_no           LIKE type_file.chr5,         # No.FUN-550034            #No.FUN-680070 VARCHAR(5)
#          l_gl_date         LIKE type_file.dat,          # 傳票日期                 #No.FUN-680070 DATE
#          l_existno         LIKE type_file.chr20,        # 已存在傳票單號           #No.FUN-680070 VARCHAR(12)
#          l_npq26           LIKE npq_file.npq26          # 帳款編號                 #No.FUN-680070 VARCHAR(10)
# 
#   IF NOT cl_null(g_npp.nppglno) THEN 
#      CALL cl_err(g_npp.nppglno,'aap-122',0) 
#      RETURN 
#   END IF
#   LET l_first_flag ='1'
#   LET l_wc         = 'npq01="',g_npp.npp01,'"'    # 單號
#   LET l_no_sep     = ' '
#   LET l_tran       = 'Y'
#   LET l_apz02b     = '00'
#   LET l_gl_no      = 'TRV'
#   LET l_gl_date    = g_npp.npp03
#   LET l_existno    = g_npp.nppglno
#   LET l_cmd = "afap302 ", 
#               " '",l_first_flag CLIPPED,"'",
#               " '",l_wc CLIPPED,"'",
#               " '",l_no_sep CLIPPED,"'",
#               " '",l_apz02b CLIPPED,"'",
#               " '",l_gl_no CLIPPED,"'",
#               " '",l_gl_date CLIPPED,"'",
#               " '",l_tran CLIPPED,"'",
#               " '",l_existno CLIPPED,"'" 
#   #CALL cl_cmdrun(l_cmd)      #FUN-660216 remark
#   CALL cl_cmdrun_wait(l_cmd)  #FUN-660216 add
#   SELECT nppglno,npp03 INTO g_npp.nppglno,g_npp.npp03
#     FROM npp_file WHERE npp01=g_npp.npp01 AND npp00=12
#                     AND nppsys='FA'
#   DISPLAY BY NAME g_npp.npp03, g_npp.nppglno    #Ann 091997
#   ERROR ' '
#END FUNCTION
# 
#FUNCTION i501_untrans()
#   DEFINE l_cmd		    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(400)
#          l_abapost         LIKE type_file.chr1,                 # 是否已過帳       #No.FUN-680070 VARCHAR(1)
#          l_existno         LIKE type_file.chr20,               # 已存在傳票單號          #No.FUN-680070 VARCHAR(12)
#          l_npq26           LIKE type_file.chr20                # 帳款編號          #No.FUN-680070 VARCHAR(10)
# 
#   IF g_npp.nppglno IS NULL THEN 
#      CALL cl_err('','anm-621',0) 
#      RETURN 
#   END IF
# 
#   SELECT abapost INTO l_abapost FROM aba_file
#    WHERE aba01=g_npp.nppglno
#      AND aba00=g_npp.npp07     #no.7277
#   IF  l_abapost = 'Y' THEN
#       CALL cl_err(l_existno,'aap-742',0)
#       RETURN
#   END IF
#   LET l_existno  = g_npp.nppglno
#   LET l_cmd = "afap303 ", 
#               " '",l_existno CLIPPED,"'" 
#   #CALL cl_cmdrun(l_cmd)      #FUN-660216 remark
#   CALL cl_cmdrun_wait(l_cmd)  #FUN-660216 add
#   SELECT nppglno,npp03 INTO g_npp.nppglno,g_npp.npp03
#     FROM npp_file WHERE npp01=g_npp.npp01 AND npp00=12
#                     AND nppsys='FA'
#   DISPLAY BY NAME g_npp.npp03, g_npp.nppglno     #Ann 091997
#   ERROR ' '
#END FUNCTION
# 
#FUNCTION i501_r()
#   DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
# 
#   IF s_shut(0) THEN RETURN END IF
#   IF g_npp.npp01 IS NULL THEN 
#      CALL cl_err('',-400,0) RETURN
#   END IF
#   BEGIN WORK
# 
#   OPEN i501_cl USING g_npp.npp01,g_npp.npp011,g_npp.nppsys,g_npp.npp00
#   IF STATUS THEN
#      CALL cl_err("OPEN i501_cl:", STATUS, 1)
#      CLOSE i501_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   FETCH i501_cl INTO g_npp.*
#   IF SQLCA.sqlcode THEN 
#      CALL cl_err(g_npp.npp01,SQLCA.sqlcode,0) 
#      CLOSE i501_cl ROLLBACK WORK RETURN 
#   END IF
#   CALL i501_show()
#   IF cl_delh(20,16) THEN
#      MESSAGE "Delete npp,npq!"
#      DELETE FROM npp_file WHERE nppsys = g_npp.nppsys
#                             AND npp00 = g_npp.npp00
#                             AND npp01 = g_npp.npp01
#                             AND npp011= g_npp.npp011
#      IF SQLCA.SQLERRD[3]=0 THEN
#        #CALL cl_err('No npp deleted',SQLCA.SQLCODE,0)   #No.FUN-660136
#         CALL cl_err3("del","npp_file",g_npp.nppsys,g_npp.npp01,SQLCA.sqlcode,"","No npp deleted",1)  #No.FUN-660136
#         ROLLBACK WORK
#         RETURN
#      ELSE
#         CLEAR FORM
#         #CALL g_npq.clear()   #FUN-620022 mark
#         #CKP3
#         OPEN i501_count
#         FETCH i501_count INTO g_row_count
#         DISPLAY g_row_count TO FORMONLY.cnt
#         OPEN i501_cs
#         IF g_curs_index = g_row_count + 1 THEN
#            LET g_jump = g_row_count
#            CALL i501_fetch('L')
#         ELSE
#            LET g_jump = g_curs_index
#            LET g_no_ask = TRUE
#            CALL i501_fetch('/')
#         END IF
#      END IF  
#      DELETE FROM npq_file WHERE npqsys = g_npp.nppsys
#                             AND npq00 = g_npp.npp00
#                             AND npq01 = g_npp.npp01
#                             AND npq011= g_npp.npp011
#      INITIALIZE g_npp.* TO NULL
#      MESSAGE ""
#   END IF
#   CLOSE i501_cl
#   COMMIT WORK
#END FUNCTION
# 
###start FUN-620022 mark
###FUNCTION i501_aag(p_key)
###  DEFINE  
###     l_aagacti  LIKE aag_file.aagacti,
###     l_aag02    LIKE aag_file.aag02,
###     l_aag07    LIKE aag_file.aag07,
###     l_aag03    LIKE aag_file.aag03,
###     l_aag09    LIKE aag_file.aag09,
###     p_key      LIKE fcx_file.fcx09,
###     p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
###
###   LET g_errno = " "
###   SELECT aag02,aagacti,aag07,aag03,aag09 
###     INTO l_aag02,l_aagacti,l_aag07,l_aag03,l_aag09
###     FROM aag_file
###    WHERE aag01=p_key
###   CASE
###        WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
###                                 LET l_aag02 = NULL
###                                 LET l_aagacti = NULL
###        WHEN l_aagacti='N'       LET g_errno = '9028'
###        WHEN l_aag07  ='1'       LET g_errno = 'agl-131'
###        WHEN l_aag03  ='4'       LET g_errno = 'agl-912'
###        WHEN l_aag09  ='N'       LET g_errno = 'agl-913'
###        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
###   END CASE
###END FUNCTION
###
####MOD-5C0103
###FUNCTION i104_npq11(p_cmd,p_seq,p_key)
###   DEFINE p_cmd    LIKE aag_file.aag151,           # 檢查否
###          p_seq      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
###          p_key      LIKE type_file.chr20,                        # 異動碼       #No.FUN-680070 VARCHAR(20)
###          l_aeeacti  LIKE aee_file.aeeacti,
###          l_aee04    LIKE aee_file.aee04
###   LET g_errno = ' '
###   IF p_cmd IS NULL OR p_cmd NOT MATCHES "[123]" THEN RETURN END IF
###   SELECT aee04,aeeacti INTO l_aee04,l_aeeacti FROM aee_file
###           WHERE aee01 = g_npq[l_ac].npq03
###             AND aee02 = p_seq     AND aee03 = p_key
###   CASE p_cmd
###           WHEN '2' IF p_key IS NULL OR p_key = ' ' THEN
###                               LET g_errno = 'agl-154'
###                            END IF
###           WHEN '3' CASE
###                WHEN p_key IS NULL OR p_key = ' ' LET g_errno = 'agl-154'
###                WHEN l_aeeacti = 'N' LET g_errno = '9027'
###                WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-153'
###                    OTHERWISE  LET g_errno = SQLCA.sqlcode USING'-------'
###                    END CASE
###           OTHERWISE EXIT CASE
###   END CASE
###END FUNCTION
###
###FUNCTION i501_set_entry_b()
### CALL cl_set_comp_entry("npq05,npq15,npq08,npq11,npq12,npq13,npq14",TRUE)
###END FUNCTION
###
###FUNCTION i501_set_no_entry_b()
###   DEFINE l_aag151        LIKE aag_file.aag151,
###          l_aag161        LIKE aag_file.aag161,
###          l_aag171        LIKE aag_file.aag171,
###          l_aag181        LIKE aag_file.aag181,
###          l_aag05         LIKE aag_file.aag05,
###          l_aag21         LIKE aag_file.aag21,
###          l_aag23         LIKE aag_file.aag23
###
###   SELECT aag151,aag161,aag171,aag181,aag05,aag21,aag23
###      INTO l_aag151,l_aag161,l_aag171,l_aag181,l_aag05,l_aag21,l_aag23
###      FROM aag_file WHERE aag01 = g_npq[l_ac].npq03
###  
###   IF cl_null(l_aag151) THEN
###      LET g_npq[l_ac].npq11 = ''
###      DISPLAY BY NAME g_npq[l_ac].npq11
###      CALL cl_set_comp_entry("npq11",FALSE)
###   END IF
###   IF cl_null(l_aag161) THEN
###      LET g_npq[l_ac].npq12 = ''
###      DISPLAY BY NAME g_npq[l_ac].npq12
###      CALL cl_set_comp_entry("npq12",FALSE)
###   END IF
###   IF cl_null(l_aag171) THEN
###      LET g_npq[l_ac].npq13 = ''
###      DISPLAY BY NAME g_npq[l_ac].npq13
###      CALL cl_set_comp_entry("npq13",FALSE)
###   END IF
###   IF cl_null(l_aag181) THEN
###      LET g_npq[l_ac].npq14 = ''
###      DISPLAY BY NAME g_npq[l_ac].npq14
###      CALL cl_set_comp_entry("npq14",FALSE)
###   END IF
###   IF l_aag05='N' OR cl_null(l_aag05) THEN
###      LET g_npq[l_ac].npq05 = ''
###      DISPLAY BY NAME g_npq[l_ac].npq05
###      CALL cl_set_comp_entry("npq05",FALSE)
###   END IF
###   IF l_aag21='N' OR cl_null(l_aag21) THEN
###      LET g_npq[l_ac].npq15 = ''
###      DISPLAY BY NAME g_npq[l_ac].npq15
###      CALL cl_set_comp_entry("npq15",FALSE)
###   END IF
###   IF l_aag23='N' OR cl_null(l_aag23) THEN
###      LET g_npq[l_ac].npq08 = ''
###      DISPLAY BY NAME g_npq[l_ac].npq08
###      CALL cl_set_comp_entry("npq08",FALSE)
###   END IF
###END FUNCTION
####END MOD-5C0103
##end FUN-620022 mark
# 
##start FUN-620022
#FUNCTION i501_npq()
# 
#  IF NOT cl_null(g_npp.npp01) THEN
#     CALL s_fsgl('FA',12,g_npp.npp01,0,1,1,'N')
#  END IF
# 
#END FUNCTION
##end FUN-620022
#}
#NO.FUN-8C0050--begin--
FUNCTION i501_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
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
         CALL cl_show_fld_cont()                   
 
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
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION first
         CALL s_fsgl_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                  
 
      ON ACTION previous
         CALL s_fsgl_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION jump
         CALL s_fsgl_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                  
 
      ON ACTION next
         CALL s_fsgl_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY                  
 
      ON ACTION last
         CALL s_fsgl_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION exporttoexcel
         LET g_action_choice = "exporttoexcel"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                
 
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
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controls
         LET g_action_choice="controls"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-8C0050 --end--
#end FUN-660165 mark
