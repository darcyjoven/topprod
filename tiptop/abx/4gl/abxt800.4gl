# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abxt800.4gl
# Descriptions...: 保稅系統單據維護
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-550033 05/05/18 By wujie 單據編號加大
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660052 05/06/14 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-6A0046 06/10/19 By jamie 1.FUNCTION t800()_q 一開始應清空g_bxi.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time	 
# Modify.........: No.FUN-6A0007 06/11/02 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6B0033 06/11/10 By hellen 新增單頭折疊功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-840500 08/04/22 By sherry 按修改時會出現amm-107訊息且無法中斷
# Modify.........: No.FUN-840202 08/05/09 By TSD.sar2436 自定欄位功能修改
# Modify.........: No.FUN-980001 09/08/10 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-990217 09/09/24 By mike 会产生回圈   
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30059 10/03/17 by rainy bxy_file 改為 bna_file
# Modify.........: No.FUN-A50102 10/07/27 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A30120 10/08/03 By Pengu 多倉儲出貨時，訂單的勾稽會出錯
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/27 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Mdofiy.........: No:MOD-BB0226 11/11/26 By johung 修改時不應再CALL s_check_no檢查單據編號
# Modify.........: No.FUN-910088 11/12/31 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-C20068 12/02/14 By chenjing 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.MOD-CA0040 12/10/12 By Elise 修正單別不存在，會進入無窮迴圈
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   #FUN-A30059 begin
    #g_bxy   RECORD LIKE bxy_file.*,
    g_bna   RECORD LIKE bna_file.*,
   #FUN-A30059 end
    g_bxi   RECORD LIKE bxi_file.*,
    g_bxr   RECORD LIKE bxr_file.*,
    g_bxi_t RECORD LIKE bxi_file.*,
    g_bxi_o RECORD LIKE bxi_file.*,
    g_yy,g_mm       LIKE type_file.num5,              #                #No.FUN-680062  smallint    
    b_bxj   RECORD LIKE bxj_file.*,
    g_bxj           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                    bxj03     LIKE bxj_file.bxj03,
                    bxj04     LIKE bxj_file.bxj04,
                    ima02     LIKE ima_file.ima02,
                    bxj05     LIKE bxj_file.bxj05,
                    bxj06     LIKE bxj_file.bxj06,
                    bxj20     LIKE bxj_file.bxj20,
                    bxj15     LIKE bxj_file.bxj15,
                    bxj21     LIKE bxj_file.bxj21,
                    bxr02     LIKE bxr_file.bxr02,
                    bxj12     LIKE bxj_file.bxj12,
                    bxj07     LIKE bxj_file.bxj07,
                    bxj18     LIKE bxj_file.bxj18,
                    bxj19     LIKE bxj_file.bxj19,
                    bxj11     LIKE bxj_file.bxj11,
                    bxj17     LIKE bxj_file.bxj17,
                    bxj22     LIKE bxj_file.bxj22,  #FUN-6A0007
                    bxj23     LIKE bxj_file.bxj23,  #FUN-6A0007
                    bxj10     LIKE bxj_file.bxj10,
                   #FUN-840202 --start---
                    bxjud01 LIKE bxj_file.bxjud01,
                    bxjud02 LIKE bxj_file.bxjud02,
                    bxjud03 LIKE bxj_file.bxjud03,
                    bxjud04 LIKE bxj_file.bxjud04,
                    bxjud05 LIKE bxj_file.bxjud05,
                    bxjud06 LIKE bxj_file.bxjud06,
                    bxjud07 LIKE bxj_file.bxjud07,
                    bxjud08 LIKE bxj_file.bxjud08,
                    bxjud09 LIKE bxj_file.bxjud09,
                    bxjud10 LIKE bxj_file.bxjud10,
                    bxjud11 LIKE bxj_file.bxjud11,
                    bxjud12 LIKE bxj_file.bxjud12,
                    bxjud13 LIKE bxj_file.bxjud13,
                    bxjud14 LIKE bxj_file.bxjud14,
                    bxjud15 LIKE bxj_file.bxjud15
                    #FUN-840202 --end--
                    END RECORD,
    g_bxj_t         RECORD
                    bxj03     LIKE bxj_file.bxj03,
                    bxj04     LIKE bxj_file.bxj04,
                    ima02     LIKE ima_file.ima02,
                    bxj05     LIKE bxj_file.bxj05,
                    bxj06     LIKE bxj_file.bxj06,
                    bxj20     LIKE bxj_file.bxj20,
                    bxj15     LIKE bxj_file.bxj15,
                    bxj21     LIKE bxj_file.bxj21,
                    bxr02     LIKE bxr_file.bxr02,
                    bxj12     LIKE bxj_file.bxj12,
                    bxj07     LIKE bxj_file.bxj07,
                    bxj18     LIKE bxj_file.bxj18,
                    bxj19     LIKE bxj_file.bxj19,
                    bxj11     LIKE bxj_file.bxj11,
                    bxj17     LIKE bxj_file.bxj17,
                    bxj22     LIKE bxj_file.bxj22,  #FUN-6A0007
                    bxj23     LIKE bxj_file.bxj23,  #FUN-6A0007
                    bxj10     LIKE bxj_file.bxj10,
                   #FUN-840202 --start---
                    bxjud01 LIKE bxj_file.bxjud01,
                    bxjud02 LIKE bxj_file.bxjud02,
                    bxjud03 LIKE bxj_file.bxjud03,
                    bxjud04 LIKE bxj_file.bxjud04,
                    bxjud05 LIKE bxj_file.bxjud05,
                    bxjud06 LIKE bxj_file.bxjud06,
                    bxjud07 LIKE bxj_file.bxjud07,
                    bxjud08 LIKE bxj_file.bxjud08,
                    bxjud09 LIKE bxj_file.bxjud09,
                    bxjud10 LIKE bxj_file.bxjud10,
                    bxjud11 LIKE bxj_file.bxjud11,
                    bxjud12 LIKE bxj_file.bxjud12,
                    bxjud13 LIKE bxj_file.bxjud13,
                    bxjud14 LIKE bxj_file.bxjud14,
                    bxjud15 LIKE bxj_file.bxjud15
                    #FUN-840202 --end--
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN 
  #FUN-A30059 begin
    #g_t1            LIKE bxy_file.bxy01,         #No.FUN-550033   #No.FUN-680062 VARCHAR(5)
    g_t1            LIKE bna_file.bna01,         
  #FUN-A30059 end
    g_buf           LIKE type_file.chr20,        #No.FUN-680062 VARCHAR(20)
    g_rec_b         LIKE type_file.num5,         #單身筆數              #No.FUN-680062 smallint 
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT   #No.FUN-680062   smallint
DEFINE g_argv1      LIKE type_file.chr1          # 11/12/13             #No.FUN-680062   VARCHAR(2)   
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL     
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680062 integer
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(72)
DEFINE g_before_input_done LIKE type_file.num5     #No.FUN-680062 smallint
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680062 integer
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680062 integer
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680062 integer
DEFINE mi_no_ask      LIKE type_file.num5          #No.FUN-680062 smallint
DEFINE g_bxj05_t      LIKE bxj_file.bxj05          #FUN-910088--add--
DEFINE g_bxj18_t      LIKE bxj_file.bxj18          #FUN-910088--add--
 
MAIN
 
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680062 smallint
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0062
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
 
    LET g_forupd_sql =
         "SELECT * FROM bxi_file WHERE bxi01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t800_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW t301_w AT p_row,p_col WITH FORM "abx/42f/abxt800"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    CALL t800(g_argv1)
    CLOSE WINDOW t301_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
END MAIN
 
FUNCTION t800(p_argv1)
  DEFINE p_argv1   LIKE type_file.chr1        # 11/12/13        #No.FUN-680062   VARCHAR(1)   
 
    LET g_argv1=p_argv1
    CALL t800_menu()
END FUNCTION
 
FUNCTION t800_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_bxj.clear()
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
   INITIALIZE g_bxi.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        bxi01,bxi06,bxi02,bxi11,bxi12,bxi08,bxi13,
        bxi03,bxi04,bxi05,bxi15,bxi09,bxiconf,bxi14, #FUN-6A0007
       #bxi03,bxi04,bxi05,bxi09,bxiconf,bxi14           #FUN-6A0007
       #FUN-840202   ---start---
        bxiud01,bxiud02,bxiud03,bxiud04,bxiud05,
        bxiud06,bxiud07,bxiud08,bxiud09,bxiud10,
        bxiud11,bxiud12,bxiud13,bxiud14,bxiud15
       #FUN-840202    ----end----
 
        ON ACTION CONTROLP
           CASE
            WHEN INFIELD(bxi08)
#               CALL q_bxr(5,4,g_bxi.bxi08) RETURNING g_bxi.bxi08
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_bxr"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO bxi08
                NEXT FIELD bxi08
 
              WHEN INFIELD(bxi01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_bxi01"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO bxi01
                   NEXT FIELD bxi01
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON bxj03,bxj04,bxj05,bxj06,bxj20,bxj15,
                       bxj21,bxj12,bxj07,
                       bxj18,bxj19,bxj11,bxj17,bxj22,bxj23,bxj10,   #FUN-6A0007
                      #bxj18,bxj19,bxj11,bxj17,bxj10   #FUN-6A0007
           #No.FUN-840202 --start--
           bxjud01,bxjud02,bxjud03,bxjud04,bxjud05,
           bxjud06,bxjud07,bxjud08,bxjud09,bxjud10,
           bxjud11,bxjud12,bxjud13,bxjud14,bxjud15
           #No.FUN-840202 ---end---
         FROM s_bxj[1].bxj03, s_bxj[1].bxj04, s_bxj[1].bxj05, s_bxj[1].bxj06,
              s_bxj[1].bxj20,s_bxj[1].bxj15,s_bxj[1].bxj21,  #FUN-6A0007
              s_bxj[1].bxj12, s_bxj[1].bxj07, s_bxj[1].bxj18,
             #FUN-6A0007---------------------------------------------(S)
             #s_bxj[1].bxj19, s_bxj[1].bxj11, s_bxj[1].bxj17, s_bxj[1].bxj10
              s_bxj[1].bxj19, s_bxj[1].bxj11, s_bxj[1].bxj17,
              s_bxj[1].bxj22, s_bxj[1].bxj23, s_bxj[1].bxj10
             #FUN-6A0007---------------------------------------------(E)
           #No.FUN-840202 --start--
           ,s_bxj[1].bxjud01,s_bxj[1].bxjud02,s_bxj[1].bxjud03,s_bxj[1].bxjud04,s_bxj[1].bxjud05
           ,s_bxj[1].bxjud06,s_bxj[1].bxjud07,s_bxj[1].bxjud08,s_bxj[1].bxjud09,s_bxj[1].bxjud10
           ,s_bxj[1].bxjud11,s_bxj[1].bxjud12,s_bxj[1].bxjud13,s_bxj[1].bxjud14,s_bxj[1].bxjud15
           #No.FUN-840202 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
           CASE WHEN INFIELD(bxj04)
#                     CALL q_ima(0,0,g_bxj[1].bxj04) RETURNING g_bxj[1].bxj04
#                     CALL FGL_DIALOG_SETBUFFER( g_bxj[1].bxj04 )
#FUN-AA0059 --Begin--
                  #    CALL cl_init_qry_var()
                  #    LET g_qryparam.form = "q_ima"
                  #    LET g_qryparam.state = 'c'
                  #    LET g_qryparam.default1 = g_bxj[1].bxj04
                  #    CALL cl_create_qry() RETURNING g_qryparam.multiret
                      CALL q_sel_ima( TRUE, "q_ima","",g_bxj[1].bxj04,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                      DISPLAY g_qryparam.multiret TO bxj04
                      NEXT FIELD bxj04
             
               #FUN-6A0007 -->
               WHEN INFIELD(bxj21)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_bxr"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bxj21
                    NEXT FIELD bxj21
               #FUN-6A0007 <--
              #FUN-6A0007--------------------------------------------(S)
               WHEN INFIELD(bxj22)   #訂單單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_oea07"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bxj22
                    NEXT FIELD bxj22
              #FUN-6A0007--------------------------------------------(E)
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
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql = "SELECT bxi01 FROM bxi_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY bxi01"
     ELSE                                       # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE bxi_file.bxi01 ",
                   "  FROM bxi_file, bxj_file",
                   " WHERE bxi01 = bxj01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY bxi01"
    END IF
 
    PREPARE t800_prepare FROM g_sql
    DECLARE t800_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t800_prepare
 
    IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM bxi_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT bxi01) FROM bxi_file,bxj_file WHERE ",
                  "bxj01=bxi01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t800_cntpre FROM g_sql
    DECLARE t800_count CURSOR FOR t800_cntpre
END FUNCTION
 
FUNCTION t800_menu()
 
   WHILE TRUE
      CALL t800_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t800_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t800_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t800_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t800_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t800_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bxj),'','')
            END IF
         #No.FUN-6A0046-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_bxi.bxi01 IS NOT NULL THEN
                 LET g_doc.column1 = "bxi01"
                 LET g_doc.value1 = g_bxi.bxi01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0046-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t800_a()
   DEFINE li_result    LIKE type_file.num5 #FUN-6A0007
 
    MESSAGE ""
    CLEAR FORM
    CALL g_bxj.clear()
    INITIALIZE g_bxi.* TO NULL
    LET g_bxi_o.* = g_bxi.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_bxi.bxi02  =g_today
        LET g_bxi.bxiconf='Y'
 
        LET g_bxi.bxiplant = g_plant  #FUN-980001 add
        LET g_bxi.bxilegal = g_legal  #FUN-980001 add
 
        BEGIN WORK
        CALL t800_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0) ROLLBACK WORK EXIT WHILE
        END IF
 
        #FUN-6A0007 --> 自動編號
       #FUN-A30059 begin
        #CALL s_auto_bxy_no(g_bxi.bxi01,g_bxi.bxi02,"bxi_file","bxi01","")
        #     RETURNING li_result,g_bxi.bxi01
       #FUN-B50026 mod 應可以保存已輸入的流水號
       #LET g_t1 = s_get_doc_no(g_bxi.bxi01)
       #CALL s_auto_assign_no("abx",g_t1,g_bxi.bxi02,"*","","","","","")
       #     RETURNING li_result,g_bxi.bxi01
        CALL s_auto_assign_no("abx",g_bxi.bxi01,g_bxi.bxi02,"*","","","","","")
             RETURNING li_result,g_bxi.bxi01
       #FUN-B50026 mod--end
       #FUN-A30059 end
        IF NOT li_result THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_bxi.bxi01
        #FUN-6A0007 <--
 
        IF g_bxi.bxi01 IS NULL THEN CONTINUE WHILE END IF
        INSERT INTO bxi_file VALUES (g_bxi.*)
        IF STATUS THEN 
#          CALL cl_err(g_bxi.bxi01,STATUS,1) #No.FUN-660052
           CALL cl_err3("ins","bxi_file",g_bxi.bxi01,"",STATUS,"","",1)
           CONTINUE WHILE 
        END IF
        COMMIT WORK
        LET g_bxi_t.* = g_bxi.*
        CALL g_bxj.clear()
        LET g_rec_b = 0
        CALL t800_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t800_u()
    IF g_bxi.bxi01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#   IF g_bxi.bxiconf = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_bxz.bxz09 IS NOT NULL AND g_bxi.bxi02 <= g_bxz.bxz09 THEN
       CALL cl_err('','mfg9999',0) RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bxi_o.* = g_bxi.*
    BEGIN WORK
 
    OPEN t800_cl USING g_bxi.bxi01
    IF STATUS THEN
       CALL cl_err("OPEN t800_cl:", STATUS, 1)
       CLOSE t800_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t800_cl INTO g_bxi.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bxi.bxi01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t800_cl ROLLBACK WORK RETURN
    END IF
    CALL t800_show()
    WHILE TRUE
        CALL t800_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bxi.*=g_bxi_t.*
            CALL t800_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE bxi_file SET * = g_bxi.* WHERE bxi01 = g_bxi_o.bxi01
        IF STATUS THEN  
#          CALL cl_err(g_bxi.bxi01,STATUS,0)  #No.FUN-660052
           CALL cl_err3("upd","bxi_file",g_bxi_o.bxi01,"",STATUS,"","",1)
           CONTINUE WHILE 
        END IF
        IF g_bxi.bxi01 != g_bxi_t.bxi01 THEN CALL t800_chkkey() END IF
        EXIT WHILE
    END WHILE
    CLOSE t800_cl
        COMMIT WORK
END FUNCTION
 
FUNCTION t800_chkkey()
           UPDATE bxj_file SET bxj01=g_bxi.bxi01 WHERE bxj01=g_bxi_t.bxi01
           IF STATUS THEN
#             CALL cl_err('upd bxj01',STATUS,1)   #No.FUN-660052
              CALL cl_err3("upd","bxj_file",g_bxi_t.bxi01,"",STATUS,"","upd bxj01",1)
              LET g_bxi.*=g_bxi_t.* CALL t800_show() ROLLBACK WORK RETURN
           END IF
END FUNCTION
 
FUNCTION t800_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1    #a:輸入 u:更改             #No.FUN-680062 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1    #判斷必要欄位是否有輸入    #No.FUN-680062 VARCHAR(1)
  DEFINE li_result       LIKE type_file.num5    #FUN-6A0007 
  DEFINE l_bna05         LIKE bna_file.bna05    #FUN-B50026 add

    CALL cl_set_head_visible("","YES")            #No.FUN-6B0033                   
 
    INPUT BY NAME
       #FUN-6A0007------------------------------------------------(S)
        g_bxi.bxi01,g_bxi.bxi06,g_bxi.bxi02,g_bxi.bxi11, 
        g_bxi.bxi12,g_bxi.bxi08,g_bxi.bxi13,   #FUN-6A0007
        #g_bxi.bxi03,g_bxi.bxi04,g_bxi.bxi05,g_bxi.bxi09,g_bxi.bxiconf,
        g_bxi.bxi03,g_bxi.bxi04,g_bxi.bxi05,g_bxi.bxi09,g_bxi.bxi15,
        g_bxi.bxiconf,
       #FUN-6A0007------------------------------------------------(E)
        g_bxi.bxi14,                                    #FUN-6A0007
       #FUN-840202     ---start---
        g_bxi.bxiud01,g_bxi.bxiud02,g_bxi.bxiud03,g_bxi.bxiud04,
        g_bxi.bxiud05,g_bxi.bxiud06,g_bxi.bxiud07,g_bxi.bxiud08,
        g_bxi.bxiud09,g_bxi.bxiud10,g_bxi.bxiud11,g_bxi.bxiud12,
        g_bxi.bxiud13,g_bxi.bxiud14,g_bxi.bxiud15 
       #FUN-840202     ----end----
           WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t800_set_entry(p_cmd)
            CALL t800_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-550033--begin
            CALL cl_set_docno_format("bxi01")
#No.FUN-550033--end
 
        AFTER FIELD bxi01
            IF NOT cl_null(g_bxi.bxi01) THEN
#No.FUN-550033--begin
#              LET g_t1=g_bxi.bxi01[1,3]
               LET g_t1=s_get_doc_no(g_bxi.bxi01)
#No.FUN-550033--end
               #FUN-B50026 add
                LET l_bna05=''
                SELECT bna05 INTO l_bna05 FROM bna_file,gee_file  #同新增狀態下單別開窗邏輯
                 WHERE bna05=gee02
                   AND gee04='abxi860'
                   AND bna01=g_t1
                IF cl_null(l_bna05) THEN
                   CALL cl_err(g_t1,'abx-087',0)
                   IF p_cmd ='a' THEN   #MOD-CA0040 add
                      NEXT FIELD bxi01
                   ELSE                 #MOD-CA0040 add
                      RETURN            #MOD-CA0040 add
                   END IF               #MOD-CA0040 add
                END IF
               #FUN-B50026 add--end
              #FUN-6A0007 --> 檢查此單別是否為自動編號
               IF p_cmd = 'a' THEN         #MOD-840500  #FUN-B50026 mark MOD-840500修改问题已不存在   #MOD-BB0226 remark
                 #CALL s_chk_bxy_no(g_bxi.bxi01,g_bxi_o.bxi01)                                 #FUN-A30059
                 #CALL s_check_no('ABX',g_bxi.bxi01,g_bxi_o.bxi01,"*","bxi_file","bxi01","")  #FUN-A30059
                  CALL s_check_no('ABX',g_bxi.bxi01,g_bxi_o.bxi01,l_bna05,"bxi_file","bxi01","")  #FUN-A30059  #FUN-B50026 mod
                      #RETURNING li_result,g_t1
                       RETURNING li_result,g_bxi.bxi01  #FUN-B50026 mod
                       DISPLAY BY NAME g_bxi.bxi01  #FUN-B50026 add
                  IF NOT li_result THEN
                     NEXT FIELD bxi01
                  END IF
               END IF                      #MOD-840500  #FUN-B50026 mark   #MOD-BB0226 remark
               CALL t800_set_entry(p_cmd)     #FUN-6A0007
               CALL t800_set_no_entry(p_cmd)  #FUN-6A0007
            END IF
 
           #FUN-6A0007...............mark begin 
           #IF g_bxi.bxi01 != g_bxi_t.bxi01 OR g_bxi_t.bxi01 IS NULL THEN
           #    SELECT count(*) INTO g_cnt FROM bxi_file
           #        WHERE bxi01 = g_bxi.bxi01
           #    IF g_cnt > 0 THEN   #資料重複
           #        CALL cl_err(g_bxi.bxi01,-239,0)
           #        LET g_bxi.bxi01 = g_bxi_t.bxi01
           #        DISPLAY BY NAME g_bxi.bxi01
           #        NEXT FIELD bxi01
           #    END IF
           #END IF
           #END IF
           #FUN-6A0007...............mark end
 
        AFTER FIELD bxi06
            IF NOT cl_null(g_bxi.bxi06) THEN
                IF g_bxi.bxi06 NOT MATCHES "[12]" THEN NEXT FIELD bxi06 END IF
            END IF
        AFTER FIELD bxi02
            IF NOT cl_null(g_bxi.bxi02) THEN
                IF g_bxz.bxz09 IS NOT NULL AND g_bxi.bxi02 <= g_bxz.bxz09 THEN
                    CALL cl_err('','mfg9999',0)
                    NEXT FIELD bxi02
                END IF
            END IF
        AFTER FIELD bxi08
            IF NOT cl_null(g_bxi.bxi08) THEN
               SELECT * INTO g_bxr.* FROM bxr_file WHERE bxr01=g_bxi.bxi08
               IF STATUS THEN 
#                 CALL cl_err('',STATUS,0)   #No.FUN-660052
                  CALL cl_err3("sel","bxr_file",g_bxi.bxi08,"",STATUS,"","",1)
                  NEXT FIELD bxi08 
               END IF
               DISPLAY g_bxr.bxr02 TO bxr02
               IF g_bxi.bxi08 != g_bxi_t.bxi08 OR g_bxi_t.bxi08 IS NULL THEN
               END IF
            END IF
        AFTER FIELD bxi03
            IF NOT cl_null(g_bxi.bxi03) THEN
               CALL t800_show2()
               IF SQLCA.SQLCODE THEN
                  CALL cl_err('',SQLCA.SQLCODE,0) NEXT FIELD bxi03
               END IF
            END IF
 
        #FUN-6A0007 -->
        AFTER FIELD bxi11   ##申報年度
           IF NOT cl_null(g_bxi.bxi11) THEN
              IF g_bxi.bxi11 < 1 THEN
                 NEXT FIELD bxi11
              END IF
           END IF
 
        AFTER FIELD bxi12   ##申報月份
           IF NOT cl_null(g_bxi.bxi12) THEN
              IF g_bxi.bxi12 < 1 OR g_bxi.bxi12 > 12 THEN
                 NEXT FIELD bxi12
              END IF
           END IF
 
        AFTER FIELD bxi13    ##收款廠商
           IF NOT cl_null(g_bxi.bxi13) THEN
              CALL t800_bxi13()
              IF g_errno THEN
                 CALL cl_err(g_bxi.bxi13,g_errno,1)
                 NEXT FIELD bxi13
              END IF
           END IF
        #FUN-6A0007 <--
 
       #FUN-6A0007---------------------------------------------------(S)
        AFTER FIELD bxi15    #異動命令作業別
           CALL t800_bxi15()
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              NEXT FIELD bxi15
           END IF
 
        #FUN-840202     ---start---
        AFTER FIELD bxiud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxiud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxiud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxiud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxiud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxiud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxiud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxiud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxiud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxiud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxiud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxiud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxiud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxiud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxiud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
        AFTER INPUT
           IF INT_FLAG THEN
              RETURN
           END IF
           #IF g_bxy.bxy06='Y' THEN #MOD-990217     #FUN-A30059
           IF g_bna.bna03='Y' THEN                  #FUN-A30059
              CALL t800_bxi15()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD bxi15
              END IF
           END IF  #MOD-990217     
       #FUN-6A0007---------------------------------------------------(E)
 
        ON ACTION CONTROLP
           CASE
            WHEN INFIELD(bxi08)
#               CALL q_bxr(5,4,g_bxi.bxi08) RETURNING g_bxi.bxi08
#               CALL FGL_DIALOG_SETBUFFER( g_bxi.bxi08 )
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_bxr"
                LET g_qryparam.default1 = g_bxi.bxi08
                CALL cl_create_qry() RETURNING g_bxi.bxi08
#                CALL FGL_DIALOG_SETBUFFER( g_bxi.bxi08 )
                DISPLAY BY NAME g_bxi.bxi08
                SELECT bxr02 FROM bxr_file WHERE bxr01=g_bxi.bxi08
                IF NOT STATUS THEN DISPLAY g_bxr.bxr02 TO bxr02 END IF
                NEXT FIELD bxi08
              #FUN-6A0007 -->
              WHEN INFIELD(bxi01)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form  = "q_bxy01"   #FUN-A30059
                 LET g_qryparam.form  = "q_bna02"    #FUN-A30059
                 LET g_qryparam.default1 = g_bxi.bxi01
                 CALL cl_create_qry() RETURNING g_bxi.bxi01
                 DISPLAY BY NAME g_bxi.bxi01
                 NEXT FIELD bxi01
              #FUN-6A0007 <--
           END CASE
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(bxi01) THEN
        #        LET g_bxi.* = g_bxi_t.*
        #        CALL t800_show()
        #        NEXT FIELD bxi01
        #    END IF
        #MOD-650015 --end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
    END INPUT
END FUNCTION
 
FUNCTION t800_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bxi.* TO NULL              #No.FUN-6A0046
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t800_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_bxi.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN t800_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bxi.* TO NULL
    ELSE
        OPEN t800_count
        FETCH t800_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t800_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t800_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680062 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680062 integer
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t800_cs INTO g_bxi.bxi01
        WHEN 'P' FETCH PREVIOUS t800_cs INTO g_bxi.bxi01
        WHEN 'F' FETCH FIRST    t800_cs INTO g_bxi.bxi01
        WHEN 'L' FETCH LAST     t800_cs INTO g_bxi.bxi01
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
            FETCH ABSOLUTE g_jump t800_cs INTO g_bxi.bxi01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bxi.bxi01,SQLCA.sqlcode,0)
        INITIALIZE g_bxi.* TO NULL   #FUN-6A0007
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
    SELECT * INTO g_bxi.* FROM bxi_file WHERE bxi01 = g_bxi.bxi01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_bxi.bxi01,SQLCA.sqlcode,0)  #No.FUN-660052
        CALL cl_err3("sel","bxi_file",g_bxi.bxi01,"",SQLCA.sqlcode,"","",1)
        INITIALIZE g_bxi.* TO NULL
        RETURN
    END IF
 
    CALL t800_show()
END FUNCTION
 
FUNCTION t800_show()
    LET g_bxi_t.* = g_bxi.*                #保存單頭舊值
    DISPLAY BY NAME
        g_bxi.bxi01,g_bxi.bxi06,g_bxi.bxi02,g_bxi.bxi08,
        g_bxi.bxi03,g_bxi.bxi04,g_bxi.bxi05,g_bxi.bxi09,g_bxi.bxiconf,
        g_bxi.bxi15,   #FUN-6A0007
        g_bxi.bxi11,g_bxi.bxi12,g_bxi.bxi13,g_bxi.bxi14, #FUN-6A0007
       #FUN-840202     ---start---
        g_bxi.bxiud01,g_bxi.bxiud02,g_bxi.bxiud03,g_bxi.bxiud04,
        g_bxi.bxiud05,g_bxi.bxiud06,g_bxi.bxiud07,g_bxi.bxiud08,
        g_bxi.bxiud09,g_bxi.bxiud10,g_bxi.bxiud11,g_bxi.bxiud12,
        g_bxi.bxiud13,g_bxi.bxiud14,g_bxi.bxiud15 
       #FUN-840202     ----end----
 
 
#No.FUN-550033--begin
#   LET g_t1 = g_bxi.bxi01[1,3]
    LET g_t1 = s_get_doc_no(g_bxi.bxi01)
#No.FUN-550033--end
  ##FUN-A30059 begin
    #SELECT bxy02 INTO g_buf FROM bxy_file WHERE bxy01=g_t1
    #             DISPLAY g_buf TO bxy02 LET g_buf = NULL
    SELECT bna02 INTO g_buf FROM bna_file WHERE bna01=g_t1
                 DISPLAY g_buf TO bna02 LET g_buf = NULL
  ##FUN-A30059 end
    CALL t800_show2()
    CALL t800_bxi13()     #FUN-6A0007
    CALL t800_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t800_show2()
    SELECT pmc03 INTO g_buf FROM pmc_file WHERE pmc01=g_bxi.bxi03
    DISPLAY g_buf TO name2 LET g_buf = NULL
    IF SQLCA.SQLCODE THEN
       SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_bxi.bxi03
       DISPLAY g_buf TO name2 LET g_buf = NULL
    END IF
    INITIALIZE g_bxr.* TO NULL
    SELECT * INTO g_bxr.* FROM bxr_file WHERE bxr01=g_bxi.bxi08
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      DISPLAY g_bxr.bxr02 TO bxr02
END FUNCTION
 
FUNCTION t800_r()
    DEFINE l_chr,l_sure   LIKE type_file.chr1        #No.FUN-680062   VARCHAR(1)   
 
    IF g_bxi.bxi01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#   IF g_bxi.bxiconf = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_bxz.bxz09 IS NOT NULL AND g_bxi.bxi02 <= g_bxz.bxz09 THEN
       CALL cl_err('','mfg9999',0) RETURN
    END IF
    BEGIN WORK
 
    OPEN t800_cl USING g_bxi.bxi01
    IF STATUS THEN
       CALL cl_err("OPEN t800_cl:", STATUS, 1)
       CLOSE t800_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t800_cl INTO g_bxi.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bxi.bxi01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
    END IF
    CALL t800_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bxi01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bxi.bxi01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete bxi,bxj!"
        DELETE FROM bxi_file WHERE bxi01 = g_bxi.bxi01
        IF SQLCA.SQLERRD[3]=0 OR STATUS
#          THEN CALL cl_err('del bxi error:',STATUS,0)    #No.FUN-660052
           THEN CALL cl_err3("del","bxi_file",g_bxi.bxi01,"",STATUS,"","del bxi error",1)
                ROLLBACK WORK RETURN
        END IF
        DELETE FROM bxj_file WHERE bxj01 = g_bxi.bxi01
        IF STATUS
#          THEN CALL cl_err('del bxj error',STATUS,1)     #No.FUN-660052
           THEN CALL cl_err3("del","bxj_file",g_bxi.bxi01,"",STATUS,"","del bxj error",1)
                ROLLBACK WORK RETURN
        END IF
        MESSAGE "update tlf909 ..."
        IF g_bxi.bxi06 = '1'
           #THEN LET g_sql="UPDATE ",g_bxi.bxi09,"tlf_file",
           THEN LET g_sql="UPDATE ",cl_get_target_table(g_bxi.bxi09,'tlf_file'), #FUN-A50102
                          " SET tlf909=NULL WHERE tlf036=?"
           #ELSE LET g_sql="UPDATE ",g_bxi.bxi09,"tlf_file",
           ELSE LET g_sql="UPDATE ",cl_get_target_table(g_bxi.bxi09,'tlf_file'), #FUN-A50102
                          " SET tlf909=NULL WHERE tlf026=?"
        END IF
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102									
	    CALL cl_parse_qry_sql(g_sql,g_bxi.bxi09) RETURNING g_sql  #FUN-A50102
        PREPARE upd_tlf909 FROM g_sql
        EXECUTE upd_tlf909 USING g_bxi.bxi01
        IF SQLCA.SQLCODE
#          THEN CALL cl_err('upd tlf909 error',SQLCA.SQLCODE,1)  #No.FUN-660052
           THEN CALL cl_err3("upd","tlf_file","","",SQLCA.SQLCODE,"","upd tlf909 error",1)
                ROLLBACK WORK RETURN
        END IF
#       LET g_msg=TIME
#       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06)
#          VALUES ('abxt800',g_user,g_today,g_msg,g_bxi.bxi01,'delete')
        CLEAR FORM
        CALL g_bxj.clear()
        INITIALIZE g_bxi.* TO NULL
        MESSAGE ""
        OPEN t800_count
        #FUN-B50062-add-start--
        IF STATUS THEN
           CLOSE t800_cs
           CLOSE t800_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        FETCH t800_count INTO g_row_count
        #FUN-B50062-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t800_cs
           CLOSE t800_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t800_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t800_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t800_fetch('/')
        END IF
 
    END IF
    CLOSE t800_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t800_d()
    DEFINE l_wc   LIKE type_file.chr1000   #No.FUN-680062 VARCHAR(300)
    DEFINE l_bxi RECORD LIKE bxi_file.*
 
    OPEN WINDOW t800_w2 AT 8,27 WITH FORM "abx/42f/abxt8002"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abxt8002")
 
 
    CONSTRUCT BY NAME l_wc ON bxi01,bxi02
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
    CLOSE WINDOW t800_w2
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    LET g_sql="SELECT * FROM bxi_file WHERE ",l_wc CLIPPED
    PREPARE t800_p2 FROM g_sql
    DECLARE t800_c2 CURSOR FOR t800_p2
    LET g_cnt=0
    FOREACH t800_c2 INTO l_bxi.*
       IF STATUS THEN EXIT FOREACH END IF
       IF l_bxi.bxi02 <= g_bxz.bxz09 THEN CONTINUE FOREACH END IF
       MESSAGE 'del:',l_bxi.bxi01,' ',l_bxi.bxi01
       DELETE FROM bxi_file WHERE bxi01 = l_bxi.bxi01
       IF STATUS THEN 
#         CALL cl_err('del bxi:',STATUS,1)    #No.FUN-660052
          CALL cl_err3("del","bxi_file",l_bxi.bxi01,"",STATUS,"","del bxi:",1)
       END IF
       DELETE FROM bxj_file WHERE bxj01 = l_bxi.bxi01
       IF STATUS THEN 
#         CALL cl_err('del bxj:',STATUS,1)    #No.FUN-660052
          CALL cl_err3("del","bxj_file",l_bxi.bxi01,"",STATUS,"","del bxj:",1)
       END IF
        IF l_bxi.bxi06 = '1'
           #THEN LET g_sql="UPDATE ",l_bxi.bxi09,"tlf_file",
           THEN LET g_sql="UPDATE ",cl_get_target_table(l_bxi.bxi09,'tlf_file'), #FUN-A50102
                          " SET tlf909=NULL WHERE tlf036=?"
           #ELSE LET g_sql="UPDATE ",l_bxi.bxi09,"tlf_file",
           ELSE LET g_sql="UPDATE ",cl_get_target_table(l_bxi.bxi09,'tlf_file'), #FUN-A50102
                          " SET tlf909=NULL WHERE tlf026=?"
        END IF
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102									
	    CALL cl_parse_qry_sql(g_sql,l_bxi.bxi09) RETURNING g_sql  #FUN-A50102
        PREPARE upd_tlf909_2 FROM g_sql
        EXECUTE upd_tlf909_2 USING l_bxi.bxi01
        IF STATUS THEN 
#          CALL cl_err('upd tlf909:',STATUS,1)    #No.FUN-660052
           CALL cl_err3("upd","tlf_file","","",STATUS,"","upd tlf909:",1)
        END IF
        LET g_cnt=g_cnt+1
    END FOREACH
    MESSAGE g_cnt,' rows deleted!'
END FUNCTION
 
FUNCTION t800_b()
DEFINE
    l_ac_t          LIKE type_file.num5,               #未取消的ARRAY CNT #No.FUN-680062 smallint
    l_row,l_col     LIKE type_file.num5,                                  #No.FUN-680062 smallint     
    l_n,l_cnt       LIKE type_file.num5,               #檢查重複用        #No.FUN-680062 smallint
    l_lock_sw       LIKE type_file.chr1,               #單身鎖住否        #No.FUN-680062 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,               #處理狀態          #No.FUN-680062 VARCHAR(1)
    l_b2            LIKE bxj_file.bxj05,                                  #No.FUN-680062 VARCHAR(30)     
    l_ima35         LIKE ima_file.ima35,                #No.FUN-680062  VARCHAR(10)    
    l_ima36         LIKE ima_file.ima36,                #No.FUN-680062  VARCHAR(10)    
    l_qty           LIKE type_file.num20_6,             #No.FUN-680062   DECIMAL(15,3)     
    l_flag          LIKE type_file.num10,               #No.FUN-680062   integer   
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680062 smallint
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680062 smallint
 
    LET g_action_choice = ""
    IF g_bxi.bxi01 IS NULL THEN RETURN END IF
#   IF g_bxi.bxiconf = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_bxz.bxz09 IS NOT NULL AND g_bxi.bxi02 <= g_bxz.bxz09 THEN
       CALL cl_err('','mfg9999',0) RETURN
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT * FROM bxj_file ",
                       "  WHERE bxj01= ? ",
                       "   AND bxj03= ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t800_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_bxj WITHOUT DEFAULTS FROM s_bxj.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
        BEFORE INPUT
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t800_cl USING g_bxi.bxi01
            IF STATUS THEN
               CALL cl_err("OPEN t800_cl:", STATUS, 1)
               CLOSE t800_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t800_cl INTO g_bxi.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_bxi.bxi01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t800_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_bxj_t.* = g_bxj[l_ac].*  #BACKUP
                LET g_bxj05_t = g_bxj[l_ac].bxj05     #FUN-910088--add--
                LET g_bxj18_t = g_bxj[l_ac].bxj18     #FUN-910088--add--
                OPEN t800_bcl USING g_bxi.bxi01,g_bxj_t.bxj03
                IF STATUS THEN
                    CALL cl_err("OPEN t800_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t800_bcl INTO b_bxj.*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err('lock bxj',SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        CALL t800_b_move_to()
                        #FUN-6A0007 -->
                        SELECT bxr02 INTO g_bxj[l_ac].bxr02 FROM bxr_file
                         WHERE bxr01 = g_bxj[l_ac].bxj21
                        #FUN-6A0007 <--
                        #FUN-6A0007 (S)--------------------
                         IF g_bxi.bxi05 = 'axmt620' THEN
                            CALL cl_set_comp_required("bxj22,bxj23",TRUE)
                         ELSE
                            CALL cl_set_comp_required("bxj22,bxj23",FALSE)
                         END IF
                        #FUN-6A0007 (E)--------------------
                    END IF
                    CALL t800_set_entry_b(p_cmd)     #FUN-6A0007
                    CALL t800_set_no_entry_b(p_cmd)  #FUN-6A0007
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
           #FUN-6A0007--------------------------------------------(S)
            CALL t800_chk_oea()
            IF NOT cl_null(g_errno) THEN
               LET g_msg = g_bxj[l_ac].bxj22,' - ',
                           g_bxj[l_ac].bxj23 USING '<<<<<'
               CALL cl_err(g_msg,g_errno,1)
               CALL g_bxj.deleteElement(l_ac)
               CANCEL INSERT
            END IF
           #FUN-6A0007--------------------------------------------(E)
            CALL t800_b_move_back()
            INSERT INTO bxj_file VALUES(b_bxj.*)
            IF SQLCA.sqlcode THEN
#               CALL cl_err('ins bxj',SQLCA.sqlcode,0)   #No.FUN-660052
                CALL cl_err3("ins","bxj_file",b_bxj.bxj01,b_bxj.bxj03,SQLCA.sqlcode,"","ins bxj",1)
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                CALL t800_bu()
                COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_bxj[l_ac].* TO NULL      #900423
                INITIALIZE g_bxj_t.*     TO NULL      #900423
                LET g_bxj05_t = NULL                  #FUN-910088--add--
                LET g_bxj18_t = NULL                  #FUN-910088--add--
                LET b_bxj.bxj01=g_bxi.bxi01
 
                LET b_bxj.bxjplant = g_plant  #FUN-980001 add
                LET b_bxj.bxjlegal = g_legal  #FUN-980001 add
 
                LET g_bxj[l_ac].bxj06=0
                #FUN-6A0007 -->
                LET g_bxj[l_ac].bxj20 = 0
                LET g_bxj[l_ac].bxj15 = 0
                #FUN-6A0007 <--
                IF l_ac > 1 THEN
                   LET g_bxj[l_ac].bxj04=g_bxj[l_ac-1].bxj04
                   LET g_bxj[l_ac].bxj05=g_bxj[l_ac-1].bxj05
                   LET g_bxj[l_ac].bxj10=g_bxj[l_ac-1].bxj10
                   LET g_bxj[l_ac].bxj11=g_bxj[l_ac-1].bxj11
                   LET g_bxj[l_ac].bxj12=g_bxj[l_ac-1].bxj12
                   LET g_bxj[l_ac].bxj07=g_bxj[l_ac-1].bxj07
                   LET g_bxj[l_ac].bxj17=g_bxj[l_ac-1].bxj17
                   LET g_bxj[l_ac].bxj18=g_bxj[l_ac-1].bxj18
                   #FUN-6A0007 -->
                   LET g_bxj[l_ac].bxj21 = g_bxj[l_ac-1].bxj21
                   LET g_bxj[l_ac].bxr02     = g_bxj[l_ac-1].bxr02
                   #FUN-6A0007 <--
                END IF
            #FUN-6A0007 (S)--------------------
             IF g_bxi.bxi05 = 'axmt620' THEN
                CALL cl_set_comp_required("bxj22,bxj23",TRUE)
             ELSE
                CALL cl_set_comp_required("bxj22,bxj23",FALSE)
             END IF
            #FUN-6A0007 (E)--------------------
            CALL t800_set_entry_b(p_cmd)     #FUN-6A0007
            CALL t800_set_no_entry_b(p_cmd)  #FUN-6A0007
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bxj03
 
        BEFORE FIELD bxj03                            #default 序號
            IF g_bxj[l_ac].bxj03 IS NULL OR g_bxj[l_ac].bxj03 = 0 THEN
                SELECT max(bxj03)+1 INTO g_bxj[l_ac].bxj03
                   FROM bxj_file WHERE bxj01 = g_bxi.bxi01
                IF g_bxj[l_ac].bxj03 IS NULL THEN
                    LET g_bxj[l_ac].bxj03 = 1
                END IF
            END IF
        AFTER FIELD bxj03                        #check 序號是否重複
            IF NOT cl_null(g_bxj[l_ac].bxj03) THEN
                IF g_bxj[l_ac].bxj03 != g_bxj_t.bxj03 OR
                   g_bxj_t.bxj03 IS NULL THEN
                    SELECT count(*) INTO l_n FROM bxj_file
                        WHERE bxj01 = g_bxi.bxi01 AND bxj03 = g_bxj[l_ac].bxj03
                    IF l_n > 0 THEN
                        LET g_bxj[l_ac].bxj03 = g_bxj_t.bxj03
                        CALL cl_err('',-239,0) NEXT FIELD bxj03
                    END IF
                END IF
            END IF
        AFTER FIELD bxj04
           IF NOT cl_null(g_bxj[l_ac].bxj04) THEN
              #FUN-AA0059 ---------------------------------add start----------------
               IF NOT s_chk_item_no(g_bxj[l_ac].bxj04,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD bxj04
               END IF 
              #FUN-AA0059 ---------------------------------add end----------------    
               SELECT ima02,ima25 INTO g_bxj[l_ac].ima02,l_b2
                 FROM ima_file WHERE ima01=g_bxj[l_ac].bxj04 AND imaacti='Y'
               IF STATUS THEN
#                 CALL cl_err('sel ima',STATUS,0)   #No.FUN-660052
                  CALL cl_err3("sel","ima_file",g_bxj[l_ac].bxj04,"",STATUS,"","sel ima",1)
                  NEXT FIELD bxj04   
               END IF
               IF cl_null(g_bxj[l_ac].bxj05) THEN
                  LET g_bxj[l_ac].bxj05=l_b2
              #FUN-910088--add--start--
                  IF NOT cl_null(g_bxj[l_ac].bxj06) AND g_bxj[l_ac].bxj06 <> 0 THEN    #FUN-C20068--add--
                     CALL t800_bxj06_check() 
                  END IF                                                               #FUN-C20068--add--
                  LET g_bxj05_t = g_bxj[l_ac].bxj05
              #FUN-910088--add--end--
               END IF
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_bxj[l_ac].ima02
               DISPLAY BY NAME g_bxj[l_ac].bxj05
               #------MOD-5A0095 END------------
              #FUN-6A0007--------------------------------------------(S)
               CALL t800_chk_oea()
               IF NOT cl_null(g_errno) THEN
                  LET g_msg = g_bxj[l_ac].bxj22,' - ',
                              g_bxj[l_ac].bxj23 USING '<<<<<'
                  CALL cl_err(g_msg,g_errno,0)
               END IF
              #FUN-6A0007--------------------------------------------(E)
           END IF
 
        AFTER FIELD bxj11
            IF g_bxr.bxr91='Y' AND g_bxj[l_ac].bxj11 IS NULL THEN
                CALL cl_err('','aap-099',0)
                NEXT FIELD bxj11
            END IF
           IF NOT cl_null(g_bxj[l_ac].bxj11) THEN
              IF cl_null(g_bxj[l_ac].bxj12) THEN
                 SELECT MAX(bxj12) INTO g_bxj[l_ac].bxj12 FROM bxj_file
                      WHERE bxj11 = g_bxj[l_ac].bxj11
              END IF
              IF cl_null(g_bxj[l_ac].bxj17) THEN
                 SELECT MAX(bxj17) INTO g_bxj[l_ac].bxj17 FROM bxj_file
                      WHERE bxj11 = g_bxj[l_ac].bxj11
              END IF
              #------MOD-5A0095 START----------
              DISPLAY BY NAME g_bxj[l_ac].bxj12
              DISPLAY BY NAME g_bxj[l_ac].bxj17
              #------MOD-5A0095 END------------
           END IF
        AFTER FIELD bxj12
            IF g_bxr.bxr92='Y' AND g_bxj[l_ac].bxj12 IS NULL THEN
                CALL cl_err('','aap-099',0)
                NEXT FIELD bxj12
            END IF
        AFTER FIELD bxj17
            IF g_bxr.bxr94='Y' AND g_bxj[l_ac].bxj17 IS NULL THEN
                CALL cl_err('','aap-099',0)
                NEXT FIELD bxj17
            END IF
 
        #FUN-6A0007 -->
        AFTER FIELD bxj20   ##單價
           IF g_bxj[l_ac].bxj20 > 0 AND g_bxj[l_ac].bxj06 > 0 THEN
              LET g_bxj[l_ac].bxj15 = g_bxj[l_ac].bxj20 * g_bxj[l_ac].bxj06
           END IF 
 
        AFTER FIELD bxj06       ##數量
           CALL t800_bxj06_check()    #FUN-910088--add--
         #FUN-910088--mark--start--
         # IF g_bxj[l_ac].bxj20 > 0 AND g_bxj[l_ac].bxj06 > 0 THEN
         #    LET g_bxj[l_ac].bxj15 = g_bxj[l_ac].bxj20 * g_bxj[l_ac].bxj06
         # END IF 
         #FUN-910088--mark--end--
      #FUN-910088--add--start--
        AFTER FIELD bxj05
           IF NOT cl_null(g_bxj[l_ac].bxj06) AND g_bxj[l_ac].bxj06 <> 0 THEN      #FUN-C20068
              CALL t800_bxj06_check()  
           END IF                                                                 #FUN-C20068
           LET g_bxj05_t = g_bxj[l_ac].bxj05

        AFTER FIELD bxj19
           CALL t800_bxj19_check() 
                                                
        AFTER FIELD bxj18
           IF NOT cl_null(g_bxj[l_ac].bxj19) AND g_bxj[l_ac].bxj19 <> 0 THEN      #FUN-C20068
              CALL t800_bxj19_check() 
           END IF                                                                 #FUN-C20068
           LET g_bxj18_t = g_bxj[l_ac].bxj18
      #FUN-910088--add--end--
 
        AFTER FIELD bxj21
           IF NOT cl_null(g_bxj[l_ac].bxj21) THEN 
              IF (g_bxj[l_ac].bxj21 != g_bxj_t.bxj21) OR
                 cl_null(g_bxj_t.bxj21) THEN
                 SELECT bxr02 INTO g_bxj[l_ac].bxr02 FROM bxr_file
                  WHERE bxr01 = g_bxj[l_ac].bxj21
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_bxj[l_ac].bxj21,SQLCA.sqlcode,1)
                    NEXT FIELD bxj21
                 END IF
              END IF
           ELSE
              LET g_bxj[l_ac].bxr02 = NULL
           END IF
           DISPLAY BY NAME g_bxj[l_ac].bxr02
        #FUN-6A0007 <--
 
       #FUN-6A0007---------------------------------------------------(S)
        AFTER FIELD bxj22      #訂單單號
           CALL t800_chk_oea()
           IF NOT cl_null(g_errno) THEN
              LET g_msg = g_bxj[l_ac].bxj22,' - ',
                          g_bxj[l_ac].bxj23 USING '<<<<<'
              CALL cl_err(g_msg,g_errno,0)
           END IF
 
        AFTER FIELD bxj23      #訂單項次
           CALL t800_chk_oea()
           IF NOT cl_null(g_errno) THEN
              LET g_msg = g_bxj[l_ac].bxj22,' - ',
                          g_bxj[l_ac].bxj23 USING '<<<<<'
              CALL cl_err(g_msg,g_errno,0)
           END IF
 
       #FUN-6A0007---------------------------------------------------(E)
        #No.FUN-840202 --start--
        AFTER FIELD bxjud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxjud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxjud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxjud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxjud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxjud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxjud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxjud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxjud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxjud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxjud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxjud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxjud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxjud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxjud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_bxj_t.bxj03 > 0 AND g_bxj_t.bxj03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM bxj_file
                    WHERE bxj01 = g_bxi.bxi01
                      AND bxj03 = g_bxj_t.bxj03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bxj_t.bxj03,SQLCA.sqlcode,0)   #No.FUN-660052
                    CALL cl_err3("del","bxj_file",g_bxi.bxi01,g_bxj_t.bxj03,SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                CALL t800_bu()
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bxj[l_ac].* = g_bxj_t.*
               CLOSE t800_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           #FUN-6A0007--------------------------------------------(S)
            CALL t800_chk_oea()
            IF NOT cl_null(g_errno) THEN
               LET g_msg = g_bxj[l_ac].bxj22,' - ',
                           g_bxj[l_ac].bxj23 USING '<<<<<'
               CALL cl_err(g_msg,g_errno,0)
               NEXT FIELD bxj22
            END IF
           #FUN-6A0007--------------------------------------------(E)
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bxj[l_ac].bxj03,-263,1)
                LET g_bxj[l_ac].* = g_bxj_t.*
            ELSE
                CALL t800_b_move_back()
                UPDATE bxj_file SET * = b_bxj.*
                   WHERE bxj01=g_bxi.bxi01
                     AND bxj03=g_bxj_t.bxj03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err('upd bxj',SQLCA.sqlcode,0)   #No.FUN-660052
                    CALL cl_err3("upd","bxj_file",g_bxi.bxi01,g_bxj_t.bxj03,SQLCA.sqlcode,"","upd bxj",1)
                    LET g_bxj[l_ac].* = g_bxj_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    CALL t800_bu()
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                   LET g_bxj[l_ac].* = g_bxj_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_bxj.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE t800_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE t800_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL t800_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bxj03) AND l_ac > 1 THEN
                LET g_bxj[l_ac].* = g_bxj[l_ac-1].*
                LET g_bxj[l_ac].bxj03 = NULL
                NEXT FIELD bxj03
            END IF
        ON ACTION CONTROLP
           CASE WHEN INFIELD(bxj04)
#                     CALL q_ima(0,0,g_bxj[l_ac].bxj04) RETURNING g_bxj[l_ac].bxj04
#                     CALL FGL_DIALOG_SETBUFFER( g_bxj[l_ac].bxj04 )
#FUN-AA0059 --Begin--
                  #    CALL cl_init_qry_var()
                  #    LET g_qryparam.form = "q_ima"
                  #    LET g_qryparam.default1 = g_bxj[l_ac].bxj04
                  #    CALL cl_create_qry() RETURNING g_bxj[l_ac].bxj04
                       CALL q_sel_ima(FALSE, "q_ima", "", g_bxj[l_ac].bxj04, "", "", "", "" ,"",'' )  RETURNING g_bxj[l_ac].bxj04
#FUN-AA0059 --End--
#                      CALL FGL_DIALOG_SETBUFFER( g_bxj[l_ac].bxj04 )
                       DISPLAY BY NAME g_bxj[l_ac].bxj04          #No.MOD-490371
                      NEXT FIELD bxj04
               WHEN INFIELD(bxj21)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_bxr"
                    LET g_qryparam.default1 = g_bxj[l_ac].bxj21
                    CALL cl_create_qry() RETURNING g_bxj[l_ac].bxj21
                    DISPLAY BY NAME g_bxj[l_ac].bxj21 
                    NEXT FIELD bxj21
              #FUN-6A0007--------------------------------------------(S)
               WHEN INFIELD(bxj22)   #訂單單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_oea07"
                    LET g_qryparam.default1 = g_bxj[l_ac].bxj22
                    CALL cl_create_qry() RETURNING g_bxj[l_ac].bxj22,
                                                   g_bxj[l_ac].bxj23
                    DISPLAY BY NAME g_bxj[l_ac].bxj22,g_bxj[l_ac].bxj23
                    NEXT FIELD bxj22
              #FUN-6A0007--------------------------------------------(E)
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
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
    
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
      END INPUT
      SELECT COUNT(*) INTO g_cnt FROM bxj_file WHERE bxj01=g_bxi.bxi01
    CLOSE t800_bcl
        COMMIT WORK
     CALL t800_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t800_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM bxi_file WHERE bxi01 = g_bxi.bxi01
         INITIALIZE g_bxi.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t800_b_move_to()
   LET g_bxj[l_ac].bxj03 = b_bxj.bxj03
   LET g_bxj[l_ac].bxj04 = b_bxj.bxj04
   LET g_bxj[l_ac].bxj05 = b_bxj.bxj05
   LET g_bxj[l_ac].bxj06 = b_bxj.bxj06
   LET g_bxj[l_ac].bxj07 = b_bxj.bxj07
   LET g_bxj[l_ac].bxj10 = b_bxj.bxj10
   LET g_bxj[l_ac].bxj11 = b_bxj.bxj11
   LET g_bxj[l_ac].bxj12 = b_bxj.bxj12
   LET g_bxj[l_ac].bxj17 = b_bxj.bxj17
   LET g_bxj[l_ac].bxj18 = b_bxj.bxj18
   LET g_bxj[l_ac].bxj19 = b_bxj.bxj19
   #FUN-6A0007 -->
   LET g_bxj[l_ac].bxj20 = b_bxj.bxj20
   LET g_bxj[l_ac].bxj21 = b_bxj.bxj21
   LET g_bxj[l_ac].bxj15 = b_bxj.bxj15
   #FUN-6A0007 <--
   LET g_bxj[l_ac].bxj22 = b_bxj.bxj22  #FUN-6A0007
   LET g_bxj[l_ac].bxj23 = b_bxj.bxj23  #FUN-6A0007
   #NO.FUN-840202 --start--
   LET g_bxj[l_ac].bxjud01 = b_bxj.bxjud01
   LET g_bxj[l_ac].bxjud02 = b_bxj.bxjud02
   LET g_bxj[l_ac].bxjud03 = b_bxj.bxjud03
   LET g_bxj[l_ac].bxjud04 = b_bxj.bxjud04
   LET g_bxj[l_ac].bxjud05 = b_bxj.bxjud05
   LET g_bxj[l_ac].bxjud06 = b_bxj.bxjud06
   LET g_bxj[l_ac].bxjud07 = b_bxj.bxjud07
   LET g_bxj[l_ac].bxjud08 = b_bxj.bxjud08
   LET g_bxj[l_ac].bxjud09 = b_bxj.bxjud09
   LET g_bxj[l_ac].bxjud10 = b_bxj.bxjud10
   LET g_bxj[l_ac].bxjud11 = b_bxj.bxjud11
   LET g_bxj[l_ac].bxjud12 = b_bxj.bxjud12
   LET g_bxj[l_ac].bxjud13 = b_bxj.bxjud13
   LET g_bxj[l_ac].bxjud14 = b_bxj.bxjud14
   LET g_bxj[l_ac].bxjud15 = b_bxj.bxjud15
   #NO.FUN-840202 --end--
END FUNCTION
FUNCTION t800_b_move_back()
   LET b_bxj.bxj03 = g_bxj[l_ac].bxj03
   LET b_bxj.bxj04 = g_bxj[l_ac].bxj04
   LET b_bxj.bxj05 = g_bxj[l_ac].bxj05
   LET b_bxj.bxj06 = g_bxj[l_ac].bxj06
   LET b_bxj.bxj07 = g_bxj[l_ac].bxj07
   LET b_bxj.bxj10 = g_bxj[l_ac].bxj10
   LET b_bxj.bxj11 = g_bxj[l_ac].bxj11
   LET b_bxj.bxj12 = g_bxj[l_ac].bxj12
   LET b_bxj.bxj17 = g_bxj[l_ac].bxj17
   LET b_bxj.bxj18 = g_bxj[l_ac].bxj18
   LET b_bxj.bxj19 = g_bxj[l_ac].bxj19
   #FUN-6A0007 -->
   LET b_bxj.bxj20 = g_bxj[l_ac].bxj20
   LET b_bxj.bxj21 = g_bxj[l_ac].bxj21
   LET b_bxj.bxj15 = g_bxj[l_ac].bxj15
   #FUN-6A0007 <--
   LET b_bxj.bxj22 = g_bxj[l_ac].bxj22  #FUN-6A0007
   LET b_bxj.bxj23 = g_bxj[l_ac].bxj23  #FUN-6A0007
   #No.FUN-840202 --start--
   LET b_bxj.bxjud01 = g_bxj[l_ac].bxjud01
   LET b_bxj.bxjud02 = g_bxj[l_ac].bxjud02
   LET b_bxj.bxjud03 = g_bxj[l_ac].bxjud03
   LET b_bxj.bxjud04 = g_bxj[l_ac].bxjud04
   LET b_bxj.bxjud05 = g_bxj[l_ac].bxjud05
   LET b_bxj.bxjud06 = g_bxj[l_ac].bxjud06
   LET b_bxj.bxjud07 = g_bxj[l_ac].bxjud07
   LET b_bxj.bxjud08 = g_bxj[l_ac].bxjud08
   LET b_bxj.bxjud09 = g_bxj[l_ac].bxjud09
   LET b_bxj.bxjud10 = g_bxj[l_ac].bxjud10
   LET b_bxj.bxjud11 = g_bxj[l_ac].bxjud11
   LET b_bxj.bxjud12 = g_bxj[l_ac].bxjud12
   LET b_bxj.bxjud13 = g_bxj[l_ac].bxjud13
   LET b_bxj.bxjud14 = g_bxj[l_ac].bxjud14
   LET b_bxj.bxjud15 = g_bxj[l_ac].bxjud15
   #NO.FUN-840202 --end--
END FUNCTION
 
FUNCTION t800_b_else()
#  IF g_bxj[l_ac].bxj15 IS NULL THEN LET g_bxj[l_ac].bxj15 =0 END IF
#  IF g_bxj[l_ac].bxj16 IS NULL THEN LET g_bxj[l_ac].bxj16 =0 END IF
END FUNCTION
 
FUNCTION t800_bu()
END FUNCTION
 
FUNCTION t800_b_askkey()
DEFINE l_wc2     LIKE type_file.chr1000#No.FUN-680062 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON bxj03,bxj04,bxj05,bxj06,bxj20,
                       bxj015,bxj21,bxj18,bxj19
                      ,bxj22,bxj23      #FUN-6A0007
            FROM s_bxj[1].bxj03, s_bxj[1].bxj04,s_bxj[1].bxj05,s_bxj[1].bxj06,
                 s_bxj[1].bxj20,s_bxj[1].bxj015,s_bxj[1].bxj21,  #FUN-6A0007
                 s_bxj[1].bxj18, s_bxj[1].bxj19	 
                ,s_bxj[1].bxj22,s_bxj[1].bxj23  #FUN-6A0007
 
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
    CALL t800_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t800_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2   LIKE type_file.chr1000    #No.FUN-680062 VARCHAR(200)
 
    LET g_sql =
        "SELECT bxj03,bxj04,ima02,bxj05,bxj06, ",
        "       bxj20,bxj15,bxj21,'',  ",  #FUN-6A0007
       #FUN-6A0007---------------------------------------------------(S)
       #"       bxj12,bxj07,bxj18,bxj19,bxj11,bxj17,bxj10 ",
        "       bxj12,bxj07,bxj18,bxj19,bxj11,bxj17,bxj22,bxj23,bxj10, ",
       #FUN-6A0007---------------------------------------------------(E)
        #No.FUN-840202 --start--
        "       bxjud01,bxjud02,bxjud03,bxjud04,bxjud05,",
        "       bxjud06,bxjud07,bxjud08,bxjud09,bxjud10,",
        "       bxjud11,bxjud12,bxjud13,bxjud14,bxjud15", 
        #No.FUN-840202 ---end---
        " FROM bxj_file, OUTER ima_file ",
        " WHERE bxj01 ='",g_bxi.bxi01,"'",  #單頭
        "   AND bxj_file.bxj04 = ima_file.ima01 AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t800_pb FROM g_sql
    DECLARE bxj_curs CURSOR FOR t800_pb
 
    CALL g_bxj.clear()
    LET g_cnt = 1
    FOREACH bxj_curs INTO g_bxj[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
        #FUN-6A0007 -->
        SELECT bxr02 INTO g_bxj[g_cnt].bxr02 FROM bxr_file
         WHERE bxr01 = g_bxj[g_cnt].bxj21
        #FUN-6A0007 <--
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bxj.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t800_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680062 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bxj TO s_bxj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t800_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t800_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t800_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t800_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t800_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6A0046  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                        #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")    #No.FUN-6B0033
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t800_bp2(j,i)
   DEFINE j,i       LIKE type_file.num5          #No.FUN-680062 smallint
   DISPLAY g_bxj[j].* TO s_bxj[i].*
   IF g_bxj[j].bxj03 IS NULL THEN RETURN END IF
   IF g_bxr.bxr91='Y' AND g_bxj[j].bxj11 IS NULL THEN
      DISPLAY g_bxj[j].bxj11 TO s_bxj[i].bxj11
   END IF
   IF g_bxr.bxr92='Y' AND g_bxj[j].bxj12 IS NULL THEN
      DISPLAY g_bxj[j].bxj12 TO s_bxj[i].bxj12
   END IF
END FUNCTION
 
FUNCTION t800_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680062  VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
      #CALL cl_set_comp_entry("bxi01",TRUE)            #FUN-6A0007
       CALL cl_set_comp_entry("bxi01,bxi15",TRUE)  #FUN-6A0007
   END IF
 
END FUNCTION
 
FUNCTION t800_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680062 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("bxi01",FALSE)
       END IF
   END IF
 
  #FUN-6A0007--------------------------------(S)
   IF NOT cl_null(g_bxi.bxi01) THEN
      #CALL t800_get_bxy()   #FUN-A30059
      CALL t800_get_bna()    #FUN-A30059
      #不為自動編號的單別，則不允許修改異動命令別
      #IF g_bxy.bxy06 != 'Y' THEN     #FUN-A30059
      IF g_bna.bna03 != 'Y' THEN      #FUN-A30059 
         CALL cl_set_comp_entry("bxi15",FALSE)
      END IF
   END IF
  #FUN-6A0007--------------------------------(E)
 
END FUNCTION
#Patch....NO.MOD-5A0095 <001,002> #
 
#FUN-6A0007 -->
FUNCTION t800_bxi13()
   DEFINE l_cnt    LIKE type_file.num5 #FUN-6A0007
   DEFINE l_pmc    RECORD LIKE pmc_file.*
   DEFINE l_occ    RECORD LIKE occ_file.*
 
   LET g_errno = NULL
   ##檢查
   SELECT * INTO l_pmc.* FROM pmc_file WHERE pmc01 = g_bxi.bxi13
   IF SQLCA.SQLCODE THEN
   ELSE
      IF l_pmc.pmcacti = 'Y' THEN
         DISPLAY l_pmc.pmc03 TO FORMONLY.name1
         RETURN
      END IF
   END IF
 
   ##在pmc_file沒資料 或無效時，撈occ_file
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01 = g_bxi.bxi13
   IF SQLCA.sqlcode THEN
      LET g_errno = SQLCA.sqlcode
      DISPLAY '' TO FORMONLY.name1
   ELSE
      IF l_occ.occacti = 'Y' THEN
         DISPLAY l_occ.occ02 TO FORMONLY.name1
      ELSE
         LET g_errno = 'abx-066'
         DISPLAY '' TO FORMONLY.name1
      END IF
   END IF
END FUNCTION
#FUN-6A0007 <--
 
#FUN-6A0007----------------------------------------------------------(S)
#取得保稅單別資料
#FUN-A30059 begin
#FUNCTION t800_get_bxy()
#   DEFINE l_str   LIKE type_file.chr5
# 
#   CALL s_get_doc_no(g_bxi.bxi01) RETURNING l_str
#   SELECT * INTO g_bxy.* FROM bxy_file
#    WHERE bxy01 = l_str
#END FUNCTION
FUNCTION t800_get_bna()
 
   DEFINE l_str   LIKE type_file.chr5
 
   CALL s_get_doc_no(g_bxi.bxi01) RETURNING l_str
   SELECT * INTO g_bna.* FROM bna_file
    WHERE bna01 = l_str
END FUNCTION
#FUN-A30059 end
 
FUNCTION t800_set_entry_b(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
   CALL cl_set_comp_entry("bxj22,bxj23",TRUE)
 
END FUNCTION
 
FUNCTION t800_set_no_entry_b(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
   IF cl_null(g_bxi.bxi05) OR (
      g_bxi.bxi05 != 'axmt620' AND g_bxi.bxi05 != 'aomt800' AND
      g_bxi.bxi05 != 'aimt301' AND g_bxi.bxi05 != 'aimt311' AND
      g_bxi.bxi05 != 'aimt302' AND g_bxi.bxi05 != 'aimt312' AND
      g_bxi.bxi05 != 'aimt303' AND g_bxi.bxi05 != 'aimt313' AND
      g_bxi.bxi05 != 'asfi511' AND g_bxi.bxi05 != 'asfi512' AND
      g_bxi.bxi05 != 'asfi513' AND g_bxi.bxi05 != 'asfi514' AND
      g_bxi.bxi05 != 'asfi526' AND g_bxi.bxi05 != 'asfi527' AND
      g_bxi.bxi05 != 'asfi528' AND g_bxi.bxi05 != 'asfi529') THEN
      CALL cl_set_comp_entry("bxj22,bxj23",FALSE)
   END IF
 
END FUNCTION
 
#訂單單號+項次依不同異動命令來做判斷
FUNCTION t800_chk_oea()
   DEFINE l_cnt      LIKE type_file.num5, #FUN-6A0007
          l_chr      LIKE type_file.chr2, #FUN-6A0007
          l_ohb33    LIKE ohb_file.ohb33,
          l_ohb34    LIKE ohb_file.ohb34
   
   LET g_errno = ''
   LET l_chr = ''
   CASE 
      #出貨
      WHEN g_bxi.bxi05 = 'axmt620'
           IF cl_null(g_bxj[l_ac].bxj22) THEN
              #訂單單號不可空白，請輸入!
              LET g_errno = 'abx-067'
              RETURN
           END IF
           IF g_bxj[l_ac].bxj23 IS NULL THEN
              #訂單項次不可空白，請輸入!
              LET g_errno = 'abx-068'
              RETURN
           END IF
           IF cl_null(g_errno) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM ogb_file
               WHERE ogb01 = g_bxi.bxi01
                #AND ogb03 = g_bxj[l_ac].bxj03   #No:MOD-A30120 mark
                 AND ogb31 = g_bxj[l_ac].bxj22
                 AND ogb32 = g_bxj[l_ac].bxj23
              IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
              IF l_cnt = 0 THEN
                 #此「訂單單號+項次」，不存在於此出貨單中，請確認!!
                 LET g_errno = 'abx-069'
                 RETURN
              END IF
           END IF
      #銷退
      WHEN g_bxi.bxi05 = 'aomt800'
           LET l_ohb33 = NULL
           LET l_ohb34 = NULL
           SELECT ohb33,ohb34 INTO l_ohb33,l_ohb34
             FROM ohb_file
            WHERE ohb01 = g_bxi.bxi01
              AND ohb03 = g_bxj[l_ac].bxj03
           IF SQLCA.SQLCODE THEN
              LET g_errno = SQLCA.SQLCODE
              RETURN
           ELSE
              IF cl_null(l_ohb33) AND l_ohb34 IS NULL THEN
                 IF NOT cl_null(g_bxj[l_ac].bxj22) THEN
                    #此「訂單單號+項次」，不存在於此銷退單中 或是 該銷退單的訂單單號+項次皆為null，請確認!!
                    LET g_errno = 'abx-070'
                    RETURN
                 END IF
                 IF g_bxj[l_ac].bxj23 IS NOT NULL THEN
                    #此「訂單單號+項次」，不存在於此銷退單中 或是 該銷退單的訂單單號+項次皆為null，請確認!!
                    LET g_errno = 'abx-070'
                    RETURN
                 END IF
              ELSE
                 IF cl_null(g_bxj[l_ac].bxj22) THEN
                    #訂單單號不可空白，請輸入!
                    LET g_errno = 'abx-067'
                    RETURN
                 END IF
                 IF g_bxj[l_ac].bxj23 IS NULL THEN
                    #訂單項次不可空白，請輸入!
                    LET g_errno = 'abx-068'
                    RETURN
                 END IF
                 IF g_bxj[l_ac].bxj22 != l_ohb33 THEN
                    #此「訂單單號+項次」，不存在於此銷退單中 或是 該銷退單的訂單單號+項次皆為null，請確認!!
                    LET g_errno = 'abx-070'
                    RETURN
                 END IF
                 IF g_bxj[l_ac].bxj23 != l_ohb34 THEN
                    #此「訂單單號+項次」，不存在於此銷退單中 或是 該銷退單的訂單單號+項次皆為null，請確認!!
                    LET g_errno = 'abx-070'
                    RETURN
                 END IF
              END IF
           END IF
      #雜收,雜發,報廢
      WHEN g_bxi.bxi05 = 'aimt301' OR g_bxi.bxi05 = 'aimt311' OR
           g_bxi.bxi05 = 'aimt302' OR g_bxi.bxi05 = 'aimt312' OR
           g_bxi.bxi05 = 'aimt303' OR g_bxi.bxi05 = 'aimt313'
           IF cl_null(g_bxj[l_ac].bxj22) AND 
              g_bxj[l_ac].bxj23 IS NULL THEN
              RETURN
           END IF
           IF NOT cl_null(g_bxj[l_ac].bxj22) AND 
              g_bxj[l_ac].bxj23 IS NOT NULL THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM oea_file,oeb_file
               WHERE oea01 = oeb01 
                 AND oea01 = g_bxj[l_ac].bxj22
                 AND oeb03 = g_bxj[l_ac].bxj23
                 AND oeaconf = 'Y'
              IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
              IF l_cnt = 0 THEN
                 #此「訂單單號+項次」,不存在訂單檔或是無單身資料，或是該訂單尚未確認，請確認!!
                 LET g_errno = 'abx-053'
                 RETURN
              END IF
              CALL t800_chk_oeb04(g_bxj[l_ac].bxj22,g_bxj[l_ac].bxj23)
              CALL t800_chk_inb04(g_bxj[l_ac].bxj22,g_bxj[l_ac].bxj23,g_bxj[l_ac].bxj04)
           ELSE
              IF g_bxj[l_ac].bxj23 IS NULL THEN
                 #訂單項次不可空白，請輸入!
                 LET g_errno = 'abx-068'
                 RETURN
              END IF
              IF cl_null(g_bxj[l_ac].bxj22) THEN
                 #訂單單號不可空白，請輸入!
                 LET g_errno = 'abx-067'
                 RETURN
              END IF
           END IF
      #工單發退料
      WHEN g_bxi.bxi05 = 'asfi511' OR g_bxi.bxi05 = 'asfi512' OR
           g_bxi.bxi05 = 'asfi513' OR g_bxi.bxi05 = 'asfi514' OR
           g_bxi.bxi05 = 'asfi526' OR g_bxi.bxi05 = 'asfi527' OR
           g_bxi.bxi05 = 'asfi528' OR g_bxi.bxi05 = 'asfi529'
           IF cl_null(g_bxj[l_ac].bxj22) AND 
              g_bxj[l_ac].bxj23 IS NULL THEN
              RETURN
           END IF
           IF NOT cl_null(g_bxj[l_ac].bxj22) AND 
              g_bxj[l_ac].bxj23 IS NOT NULL THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM oea_file,oeb_file
               WHERE oea01 = oeb01 
                 AND oea01 = g_bxj[l_ac].bxj22
                 AND oeb03 = g_bxj[l_ac].bxj23
                 AND oeaconf = 'Y'
              IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
              IF l_cnt = 0 THEN
                 #此「訂單單號+項次」,不存在訂單檔或是無單身資料，或是該訂單尚未確認，請確認!!
                 LET g_errno = 'abx-053'
                 RETURN
              END IF
              CALL t800_chk_oeb04(g_bxj[l_ac].bxj22,g_bxj[l_ac].bxj23)
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt
                FROM sfs_file,sfb_file
               WHERE sfs01 = g_bxi.bxi01
                 AND sfs02 = g_bxj[l_ac].bxj03
                 AND sfb22 = g_bxj[l_ac].bxj22
                 AND sfb221 = g_bxj[l_ac].bxj23
                 AND sfs03 = sfb01
              IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
              IF l_cnt = 0 THEN
                 LET g_msg = g_bxj[l_ac].bxj22,' - ',
                             g_bxj[l_ac].bxj23 USING '<<<<<'
                 #此「訂單單號+項次」，不存在於此工單中，請確認!!
                 CALL cl_err(g_msg,'abx-071',1)
              END IF
           ELSE
              IF g_bxj[l_ac].bxj23 IS NULL THEN
                 #訂單項次不可空白，請輸入!
                 LET g_errno = 'abx-068'
                 RETURN
              END IF
              IF cl_null(g_bxj[l_ac].bxj22) THEN
                 #訂單單號不可空白，請輸入!
                 LET g_errno = 'abx-067'
                 RETURN
              END IF
           END IF
   END CASE
END FUNCTION
 
#判斷單號項次所購入之料件有無架BOM資料
FUNCTION t800_chk_oeb04(p_oea01,p_oeb03)
   DEFINE p_oea01 LIKE oea_file.oea01,
          p_oeb03 LIKE oeb_file.oeb03
   DEFINE l_cnt   LIKE type_file.num5 #FUN-6A0007
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM oea_file,oeb_file,bma_file,bmb_file
    WHERE oea01 = oeb01 AND oeb04 = bma01 AND oeaconf = 'Y'
      AND bma01 = bmb01 AND bma06 = bmb29 AND bmaacti = 'Y'
      AND (bmb04 IS NULL OR bmb04 <= g_bxi.bxi02)
      AND (bmb05 IS NULL OR bmb05 > g_bxi.bxi02)
      AND oea01 = p_oea01
      AND oeb03 = p_oeb03
   IF l_cnt = 0 THEN
      LET g_msg = p_oea01,' - ',p_oeb03 USING '<<<<<'
      CALL cl_err(g_msg,'abx-054',1)
   END IF
END FUNCTION
 
#判斷單號項次 inb04是否是單號所建bom元件，若沒有，show msg
FUNCTION t800_chk_inb04(p_oea01,p_oeb03,p_bmb03)
   DEFINE p_oea01 LIKE oea_file.oea01,
          p_oeb03 LIKE oeb_file.oeb03,
          p_bmb03 LIKE bmb_File.bmb03
   DEFINE l_cnt LIKE type_file.num5, #FUN-6A0007
          l_oeb04 LIKE oeb_file.oeb04
 
   SELECT oeb04 INTO l_oeb04 FROM oea_file,oeb_file
    WHERE oea01 = oeb01 AND oeaconf = 'Y'
      AND oea01 = p_oea01
      AND oeb03 = p_oeb03
 
   IF NOT t800_bom(l_oeb04,p_bmb03) THEN
      CALL cl_err(p_bmb03,'abx-055',1)
   END IF
END FUNCTION
 
#展bom找元件
FUNCTION t800_bom(p_bma01,p_bmb03)
    DEFINE p_bma01 LIKE bma_file.bma01,
           p_bmb03 LIKE bmb_file.bmb03,
           l_bmb03 LIKE bmb_file.bmb03,
           l_cnt   LIKE type_file.num5, #FUN-6A0007
           l_i     LIKE type_file.num5, #FUN-6A0007
           l_rec   LIKE type_file.num5, #FUN-6A0007
           l_bmb   DYNAMIC ARRAY OF RECORD
              bmb03 LIKE bmb_file.bmb03
                   END RECORD
 
   LET l_cnt = 0
   DECLARE t800_bom_cs CURSOR WITH HOLD FOR
      SELECT bmb03 FROM bma_file,bmb_file
       WHERE bma01 = bmb01 AND bma06 = bmb29 AND bmaacti = 'Y'
         AND (bmb04 IS NULL OR bmb04 <= g_bxi.bxi02)
         AND (bmb05 IS NULL OR bmb05 > g_bxi.bxi02)
         AND bma01 = p_bma01
 
   OPEN t800_bom_cs
   LET l_i = 1
   FOREACH t800_bom_cs INTO l_bmb[l_i].*
       LET l_i = l_i + 1
   END FOREACH
   LET l_rec = l_i - 1
 
   FOR l_i = 1 TO l_rec
     IF l_bmb[l_i].bmb03 = p_bmb03 THEN
        LET l_cnt = 1
        RETURN l_cnt
     END IF
     IF t800_bom(l_bmb[l_i].bmb03,p_bmb03) THEN RETURN 1 END IF
   END FOR
 
   RETURN l_cnt
END FUNCTION
 
FUNCTION t800_bxi15()
   LET g_errno = ''
   IF cl_null(g_bxi.bxi15) THEN
      LET g_errno = 'abx-072'
      RETURN
   ELSE
      IF g_bxi.bxi15 NOT MATCHES '[123456789AB]' THEN
         LET g_errno = 'abx-072'
         RETURN
      END IF
      #異動別為「入庫」時，只可輸入正確值[1567AB]!
      IF g_bxi.bxi06 = '1' AND 
         g_bxi.bxi15 NOT MATCHES '[1567AB]' THEN
         LET g_errno = 'abx-073'
         RETURN
      END IF
      #異動別為「出庫」時，只可輸入正確值[23489B]!
      IF g_bxi.bxi06 = '2' AND 
         g_bxi.bxi15 NOT MATCHES '[23489B]' THEN
         LET g_errno = 'abx-074'
         RETURN
      END IF
   END IF
END FUNCTION
#FUN-6A0007----------------------------------------------------------(E)

#FUN-910088--add--start--
FUNCTION t800_bxj06_check()
   IF NOT cl_null(g_bxj[l_ac].bxj06) AND NOT cl_null(g_bxj[l_ac].bxj05) THEN
      IF cl_null(g_bxj05_t) OR cl_null(g_bxj_t.bxj06) OR g_bxj05_t != g_bxj[l_ac].bxj05 OR g_bxj_t.bxj06 != g_bxj[l_ac].bxj06 THEN
         LET g_bxj[l_ac].bxj06 = s_digqty(g_bxj[l_ac].bxj06,g_bxj[l_ac].bxj05)
         DISPLAY BY NAME g_bxj[l_ac].bxj06
      END IF
   END IF
   IF g_bxj[l_ac].bxj20 > 0 AND g_bxj[l_ac].bxj06 > 0 THEN
      LET g_bxj[l_ac].bxj15 = g_bxj[l_ac].bxj20 * g_bxj[l_ac].bxj06
   END IF
END FUNCTION 

FUNCTION t800_bxj19_check()
   IF NOT cl_null(g_bxj[l_ac].bxj19) AND NOT cl_null(g_bxj[l_ac].bxj18) THEN
      IF cl_null(g_bxj18_t) OR cl_null(g_bxj_t.bxj19) OR g_bxj18_t != g_bxj[l_ac].bxj18 OR g_bxj_t.bxj19 != g_bxj[l_ac].bxj19 THEN
         LET g_bxj[l_ac].bxj19 = s_digqty(g_bxj[l_ac].bxj19,g_bxj[l_ac].bxj18)
         DISPLAY BY NAME g_bxj[l_ac].bxj19
      END IF
   END IF
END FUNCTION
#FUN-910088--add--end--
