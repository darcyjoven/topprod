# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asft801.4gl
# Descriptions...: 工單單頭變更作業
# Date & Author..: 03/03/13 By Carol
# Modify.........: No:7686 03/08/07 Carol sfb98應該參考gem_file部門資料
#                                         (與 axc 一致) 將smh_file -> gem_file
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530131 05/03/17 By Carrier 書寫錯誤更正
# Modify.........: No.MOD-530156 05/03/31 By Carol 變更生產套數不可為0
# Modify.........: No.MOD-530887 05/04/01 By ching fix count sfp,sfq err
# Modify.........: No.FUN-550067 05/05/31 By Trisy 單據編號加大
# Modify.........: No.FUN-570041 05/07/06 By pengu 工單單頭變更，單身也會隨著變更，但是變更完數量不會考慮小數點取位
# Modify.........: No.MOD-5B0271 05/12/07 By Pengu 只輸入"工單單號",直接按確定,系統會詢問是否刪除,
                               #                   若選'否',會造成INSERT成功,但無變更序號
# Modify.........: No.TQC-630013 06/03/03 By Claire 串報表傳參數
# Modify.........: NO.MOD-640359 06/04/10 By YITING 工單無任何變更資料也可以發出
# Modify.........: No.MOD-640301 06/04/11 By pengu 1.工單未確認也可做工單變更,建議若輸入未確認的工單應有拒訊息
                            #                       2.製造部門/廠商的欄位可按ctrl+p 但畫面無出現放大鏡的按鈕.
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-690022 06/09/20 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0164 06/11/22 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-710164 07/03/06 By pengu  heck sfq_file存在的訊息asf-050,改成asf-069
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740003 07/04/09 By pengu 在UPDATE 應發量時應判斷ima64及ima641算出合理的量
# Modify.........: No.MOD-740021 07/04/10 By pengu 程式段中沒有任何地方塞值給g_sfb05
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-810084 08/01/29 By lumxa  不能排除掉已經作廢的發/退料單，應根據sfpconf <>’X’來判斷
# Modify.........: No.FUN-870051 08/07/18 By sherry 增加被替代料(sfa27)為Key值
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-940175 09/05/11 By mike 程序中用到sfbact = 'Y'，應改為sfbacti = 'Y' 
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20037 10/03/16 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No.MOD-A80225 10/08/27 by sabrina AFTER FIELD snb08a直接抓sfa065與snb08a比較時未考慮QPA
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-910088 11/12/09 By chenjing 增加數量欄位小數取位 
# Modify.........: No:FUN-BB0083 11/12/12 By xujing 增加數量欄位小數取位
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: NO.TQC-C50088 12/05/10 By fengrui 依工作行事歷預計開工日和預計完工日,修改日期控管
# Modify.........: NO.TQC-C50151 12/05/17 By fengrui 添加變量l_sfb24清空
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No.TQC-C80127 12/08/22 By chenjing 修改更改后預計開工日預計完工日控管
# Modify.........: No.TQC-C80137 12/08/22 By chenjing 修改asf-055控管以及ctrl+g呼叫command run 程序
# Modify.........: No.MOD-CC0161 12/12/26 By Elise 工單已結案不可變更
# Modify.........: No.MOD-D10253 13/01/30 By bart 新增與變更發出後應update snb99, 否則asft803可查得到此張變更單維未發出變更狀態
# Modify.........: No:CHI-D20010 13/02/21 By yangtt 將作廢功能分成作廢與取消作廢2個action

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_snb   RECORD LIKE snb_file.*,
    g_snb_t RECORD LIKE snb_file.*,
    g_sfb   RECORD LIKE sfb_file.*,
    g_snb01_t LIKE snb_file.snb01,
    g_snb02_t LIKE snb_file.snb02,
    g_snb08a_t     LIKE snb_file.snb08a,              #TQC-C50088 add
    g_snb13a_t     LIKE snb_file.snb13a,              #TQC-C50088 add
    g_snb15a_t     LIKE snb_file.snb15a,              #TQC-C50088 add
    g_sfb02        LIKE sfb_file.sfb02,
    g_sfb081       LIKE sfb_file.sfb081,
    g_sfb09        LIKE sfb_file.sfb09,
    g_argv1        LIKE snb_file.snb01,
    g_yy,g_mm		LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    g_wc,g_sql          string,  #No.FUN-580092 HCN
    l_cmd               LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(300)
    #MOD-530131  --begin
    #MOD-530131  --end
 
DEFINE l_sfbqty              LIKE sfb_file.sfb08   #No.FUN-570041
DEFINE g_gfe03               LIKE gfe_file.gfe03   #No.FUN-570041
DEFINE g_sfb05               LIKE sfb_file.sfb05   #No.FUN-570041
DEFINE g_ima55               LIKE ima_file.ima55   #No.FUN-570041
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_chr                 LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE g_msg                LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(120)#TQC-630013
DEFINE g_row_count          LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_curs_index         LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_jump               LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_no_ask             LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE g_confirm             LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_approve             LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_post                LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_close               LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_void                LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_valid               LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
MAIN
    OPTIONS
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
 
    INITIALIZE g_snb.* TO NULL
    INITIALIZE g_snb_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM snb_file WHERE snb01 = ? AND snb02 = ? AND snb04 = '1' FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t801_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    DECLARE t801_g0_cl CURSOR WITH HOLD FOR
        SELECT * FROM sfa_file
        WHERE sfa01 = g_snb.snb01
 
    DECLARE t801_g1_cl CURSOR WITH HOLD FOR
        SELECT UNIQUE sfa27,SUM(sfa05),SUM(sfa06),SUM(sfa062),SUM(sfa07)
          FROM sfa_file
         WHERE sfa01 = g_snb.snb01
          GROUP BY sfa27
 
   #組合出 SQL 指令
    LET g_sql='SELECT sna_file.*,sfa_file.* FROM sna_file,sfa_file ',
              ' WHERE sna01 = ? ',
                ' AND sna02 =  ? ',
                ' AND sna01 = sfa01 ',
                ' AND sna27b= ? ',
                ' AND sna03b= sfa03 ',
                ' AND sna08b= sfa08 ',
                ' AND sna12b= sfa12 ',
              ' ORDER BY sfa03,sfa26 ' CLIPPED
    PREPARE t801_g2_p1 FROM g_sql
    DECLARE t801_g2_cl CURSOR FOR t801_g2_p1
 
 
    OPEN WINDOW t801_w WITH FORM "asf/42f/asft801"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    LET g_snb.snb04 = '1'
    DISPLAY BY NAME g_snb.snb04
 
    IF NOT cl_null(g_argv1) THEN  CALL t801_q() END IF
 
    LET g_action_choice=""
    CALL t801_menu()
 
    CLOSE WINDOW t801_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
END MAIN
 
FUNCTION t801_cs()
    CLEAR FORM
    DISPLAY BY NAME g_snb.snb04
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = "snb01 = '",g_argv1 CLIPPED,"' "
    ELSE
   INITIALIZE g_snb.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
#          snb01,snb022,snb02,sfb05,snbconf,snb08b,snb08a,
           snb01,snb022,snb02,snbconf,snb08b,snb08a,
           snb13b,snb13a,snb15b,snb15a,snb82b,snb82a,snb98b,snb98a,
           snbuser,snbgrup,snbmodu,snbdate
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON ACTION controlp
            CASE
               WHEN INFIELD(snb01)
                 #CALL q_sfb(0,0,g_snb.snb01,'234567') RETURNING g_snb.snb01
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form     = "q_sfb"
                  LET g_qryparam.default1 = g_snb.snb01
                  LET g_qryparam.arg1     = "234567"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO snb01
                  NEXT FIELD snb01
               WHEN INFIELD(snb82a)
                  IF g_sfb02=7 THEN
                    #CALL q_pmc(0,0,g_snb.snb82a) RETURNING g_snb.snb82a
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form     = "q_pmc"
                     LET g_qryparam.default1 = g_snb.snb82a
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                  ELSE
                    #CALL q_gem(10,2,g_snb.snb82a) RETURNING g_snb.snb82a
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form     = "q_gem"
                     LET g_qryparam.default1 = g_snb.snb82a
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                  END IF
                  DISPLAY g_qryparam.multiret TO snb82a
                  NEXT FIELD snb82a
             #-----------------No.MOD-640301 add
               WHEN INFIELD(snb82b)
                  IF g_sfb02=7 THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form     = "q_pmc"
                     LET g_qryparam.default1 = g_snb.snb82b
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                  ELSE
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form     = "q_gem"
                     LET g_qryparam.default1 = g_snb.snb82b
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                  END IF
                  DISPLAY g_qryparam.multiret TO snb82b
                  NEXT FIELD snb82b
             #-----------------No.MOD-640301 end
               WHEN INFIELD(snb98a)   #No:7686
                 #CALL q_gem(10,2,g_snb.snb98a) RETURNING g_snb.snb98a
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form     = "q_gem"
                  LET g_qryparam.default1 = g_snb.snb98a
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO snb98a
                  NEXT FIELD snb98a
               OTHERWISE EXIT CASE
            END CASE
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
           #TQC-C80137--add--
            ON ACTION controlg
               CALL cl_cmdask()
           #TQC-C80137--add--    
         END CONSTRUCT
    END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND snbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND snbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND snbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('snbuser', 'snbgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT snb01,snb02 FROM snb_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED," AND snb04 = '1'  ORDER BY snb01"
    PREPARE t801_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t801_cs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t801_prepare
    LET g_sql="SELECT COUNT(*) FROM snb_file WHERE ",
               g_wc CLIPPED," AND snb04 = '1'"
    PREPARE t801_precount FROM g_sql
    DECLARE t801_count CURSOR FOR t801_precount
END FUNCTION
 
FUNCTION t801_menu()
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
               IF NOT cl_null(g_argv1) THEN
                  HIDE OPTION  "insert"
                  HIDE OPTION  "modify"
                  HIDE OPTION  "change_release"
                  HIDE OPTION  "delete"
                  HIDE OPTION  "void"
               END IF
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t801_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t801_q()
            END IF
        ON ACTION next
            CALL t801_fetch('N')
        ON ACTION previous
            CALL t801_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t801_u()
            END IF
        ON ACTION detail_query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_snb.snb01) AND g_snb.snbconf = 'Y' THEN
                  LET g_msg="asft802 '",g_snb.snb01,"' '",g_snb.snb02,"' "
                  #CALL cl_cmdrun(g_msg)     #FUN-660216 remark
                  CALL cl_cmdrun_wait(g_msg) #FUN-660216 add
               END IF
            END IF
#        ON ACTION 變更發出
         ON ACTION change_release #BUG041109
            LET g_action_choice="change_release"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_snb.snb01) THEN
                  CALL t801_g()
               END IF
            END IF
            CASE g_snb.snbconf
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
         ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t801_r()
            END IF
#        ON ACTION 作廢
         ON ACTION void
            LET g_action_choice="void"
            IF cl_chk_act_auth() THEN
                #CALL t801_x()   #CHI-D2001
                 CALL t801_x(1)  #CHI-D2001
            END IF
            CASE g_snb.snbconf
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,"")

        #CHI-D20010---begin
         ON ACTION undo_void
            LET g_action_choice="undo_void"
            IF cl_chk_act_auth() THEN
                 CALL t801_x(2)
            END IF
            CASE g_snb.snbconf
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
        #CHI-D20010---end
 
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
              #TQC-630013-begin
               LET g_wc=' snb01= "',g_snb.snb01,'" AND snb02=',g_snb.snb02,' '  
              #LET g_msg="asfr801 '",g_snb.snb01,"' '",g_snb.snb02,"' "
               #LET g_msg="asfr801 ",  #FUN-C30085 mark
              LET g_msg="asfg801 ",  #FUN-C30085 add
                         "'",g_today,"'",
                         " '",g_user,"'",
                         " '",g_lang,"'",
                         " 'Y' ",
                         " ' ' ",
                         " '1'",
                         " '",g_wc,"'",
                         " 'N' ",
                         " '3'"
              #TQC-630013-end
               CALL cl_cmdrun(g_msg)
            END IF
#        ON ACTION 備註
         ON ACTION memo
            LET g_action_choice="memo"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_snb.snb01) THEN  CALL t801_memo() END IF
            END IF
#        ON ACTION 工單查詢
         ON ACTION query_w_o
            LET g_action_choice="query_w_o"
            IF cl_chk_act_auth() AND NOT cl_null(g_snb.snb01) THEN
               LET g_msg="asfq301 '",g_snb.snb01,"' "
               CALL cl_cmdrun(g_msg)
            END IF
        ON ACTION help
            CALL cl_show_help()
       #TQC-C80137--add--
        ON ACTION controlg
           CALL cl_cmdask()
       #TQC-C80137--add--
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           #EXIT MENU
           CASE g_snb.snbconf
                WHEN 'Y'   LET g_confirm = 'Y'
                           LET g_void = ''
                WHEN 'N'   LET g_confirm = 'N'
                           LET g_void = ''
                WHEN 'X'   LET g_confirm = ''
                           LET g_void = 'Y'
             OTHERWISE     LET g_confirm = ''
                           LET g_void = ''
           END CASE
           #圖形顯示
           CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
         ON ACTION jump
            CALL t801_fetch('/')
         ON ACTION first
             CALL t801_fetch('F')
         ON ACTION last
             CALL t801_fetch('L')
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        #No.FUN-6A0164-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_snb.snb01 IS NOT NULL THEN
                  LET g_doc.column1 = "snb01"
                  LET g_doc.column2 = "snb02"
                  LET g_doc.value1 = g_snb.snb01
                  LET g_doc.value2 = g_snb.snb02
              CALL cl_doc()                            
               END IF                                        
            END IF                                           
         #No.FUN-6A0164-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE t801_cs
END FUNCTION
 
 
FUNCTION t801_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清除螢幕內容
    INITIALIZE g_snb.* LIKE snb_file.*
    LET g_snb01_t = NULL
    #TQC-C50088--add--str--
    LET g_snb08a_t = NULL 
    LET g_snb13a_t = NULL 
    LET g_snb15a_t = NULL 
    #TQC-C50088--add--end--
    LET g_snb_t.* = g_snb.*
    LET g_snb.snb04 = '1'
    DISPLAY BY NAME g_snb.snb04
    LET g_snb.snbconf = 'N'
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_snb.snbconf ='N'
        LET g_snb.snbuser = g_user
        LET g_snb.snboriu = g_user #FUN-980030
        LET g_snb.snborig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_snb.snbgrup = g_grup               #使用者所屬群
        LET g_snb.snbdate = g_today
        LET g_snb.snbplant = g_plant #FUN-980008 add
        LET g_snb.snblegal = g_legal #FUN-980008 add
        LET g_snb.snb99 ='0'  #MOD-D10253
 
        CALL t801_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            LET g_snb.snb01 = NULL   #MOD-660086 add
            LET g_snb.snb02 = NULL   #MOD-660086 add
            CALL cl_err('',9001,0)
            CLEAR FORM
            DISPLAY BY NAME g_snb.snb04
            EXIT WHILE
        END IF
        IF cl_null(g_snb.snb01) THEN             # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF cl_null(g_snb.snb08a) AND cl_null(g_snb.snb13a) AND
           cl_null(g_snb.snb15a) AND cl_null(g_snb.snb82a) AND
           cl_null(g_snb.snb98a) THEN
           #沒有輸入變更資料，是否存此筆資料？
           IF cl_confirm('asf-059') THEN
              CLEAR FORM
              DISPLAY BY NAME g_snb.snb04
              EXIT WHILE
           END IF
        END IF
        LET g_snb.snb04 = '1'
        LET g_snb.snbconf = 'N'
 
        INSERT INTO snb_file VALUES(g_snb.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("ins","snb_file",g_snb.snb01,g_snb.snb02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
            CONTINUE WHILE
        ELSE
            LET g_snb_t.* = g_snb.*                # 保存上筆資料
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t801_i(p_cmd)
    DEFINE
        l_imd10         LIKE  imd_file.imd10,   #倉庫類別
        l_imd11         LIKE  imd_file.imd11,   #可用否
        l_ime04         LIKE  ime_file.ime04,   #倉庫類別
        l_ime05         LIKE  ime_file.ime05,   #可用否
        l_n1,l_n2       LIKE type_file.num5,    #是否須將數值欄位清為0        #No.FUN-680121 SMALLINT
        l_dir1          LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#Direction Flag
        p_cmd           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
	l_sw            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1) 
        l_sfb24         LIKE sfb_file.sfb24,
        l_cnt           LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        l_n             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        li_result       LIKE type_file.num5           #No.TQC-C50088 SMALLINT
    DEFINE l_sfb81      LIKE sfb_file.sfb81           #No.TQC-C80127
 
    DISPLAY BY NAME g_snb.snbuser, g_snb.snbgrup, g_snb.snbmodu,
                    g_snb.snbdate, g_snb.snbconf
    INPUT BY NAME g_snb.snboriu,g_snb.snborig,
        g_snb.snb01,g_snb.snb022,g_snb.snb08a,
        g_snb.snb13a,g_snb.snb15a,g_snb.snb82a,g_snb.snb98a
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t801_set_entry(p_cmd)
            CALL t801_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
      
         #No.FUN-550067 --start--
         CALL cl_set_docno_format("snb01")
         #No.FUN-550067 ---end---
 
        AFTER FIELD snb01
            IF NOT cl_null(g_snb.snb01) THEN
          #---------No.MOD-640301 add
          #未確認的工單不可做工單變更
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM sfb_file
                WHERE sfb01 = g_snb.snb01
                  AND sfb87 != 'Y'
               IF l_cnt > 0 THEN
                  CALL cl_err('','asf-019',1)
                  NEXT FIELD snb01
               END IF
          #---------No.MOD-640301 end
               IF g_snb.snb01 != g_snb01_t OR cl_null(g_snb01_t) THEN
             #---------No.MOD-5B0271 add
                #若為新增時自動帶出變更序號
                IF p_cmd = 'a' THEN
                   SELECT sfb101 INTO g_snb.snb02 FROM sfb_file
                   WHERE sfb01 = g_snb.snb01
                   IF cl_null(g_snb.snb02) THEN
                      LET g_snb.snb02 = 1
                   ELSE
                      LET g_snb.snb02 = g_snb.snb02 + 1
                   END IF
                   DISPLAY BY NAME g_snb.snb02
                END IF
            #----------No.MOD-5B0271 end
 
#檢查輸入之工單若有尚未做發出確認的工單變更單資料
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM snb_file
                   WHERE snb01 = g_snb.snb01
                     AND snbconf = 'N'
                  IF l_cnt > 0 THEN
                     CALL cl_err('','asf-050',0)
                     NEXT FIELD snb01
                  END IF
#檢查輸入之工單若為其他工單之母工單或此工單之下還有相關的子工單
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM sfb_file
                   WHERE sfb86 = g_snb.snb01
                     AND sfbacti = 'Y'
 
#開窗詢問『此工單為母子工單，是否確定執行(Y/N)？』
                  IF l_cnt > 0 THEN
                     IF NOT cl_confirm('asf-051') THEN
                        NEXT FIELD snb01
                     END IF
                  END IF
 
#檢查輸入之工單是否已產生[工單製程檔](ecm_file)資料或 sfb24='Y'
                  LET l_cnt = 0
                  LET l_sfb24 = NULL   #TQC-C50151 add
                  SELECT sfb24,COUNT(*) INTO l_sfb24,l_cnt FROM sfb_file,ecm_file
                   WHERE sfb01 = g_snb.snb01
                     AND sfbacti = 'Y'
                     AND ecm01 = sfb01
                     AND ecm03_par = sfb05
                     AND ecmacti = 'Y'
                   GROUP BY sfb24
                  IF l_cnt > 0 OR l_sfb24 = 'Y' THEN
                     CALL cl_err('','asf-052',0)
                     NEXT FIELD snb01
                  END IF
 
#檢查輸入之工單若為委外工單/重工委外工單(sfb02='7' OR '8')
#且已有收貨紀錄(rvaconf != 'X')
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM sfb_file,rva_file,rvb_file
                   WHERE sfb01 = g_snb.snb01
                     AND sfbacti = 'Y'
                     AND ( sfb02 = '7' OR sfb02 = '8' )
                     AND rvb34 = sfb01
                     AND rvb01 = rva01
                     AND rvaconf !='X'
                  IF l_cnt > 0 THEN
                     CALL cl_err('','asf-053',0)
                     NEXT FIELD snb01
                  END IF
 
#有未確認的發料單,退料單(過濾作廢的發退料單),顯示訊息,不可新增工單變更單
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM sfp_file,sfq_file
                    WHERE sfq02 = g_snb.snb01   #MOD-530887
                     AND sfq01 = sfp01
                      AND sfp04 = 'N'           #MOD-530887
                      AND sfpconf <>'X'         #TQC-810084
                  IF l_cnt > 0 THEN
                     CALL cl_err('','asf-069',0)    #No.MOD-710164 modify
                     NEXT FIELD snb01
                  END IF
#MOD-CC0161---add---S
#已結案工單不可變更  
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM sfb_file
                   WHERE sfb01 = g_snb.snb01
                     AND sfb04 = '8'
                  IF l_cnt > 0 THEN
                     CALL cl_err('','asf-070',0)
                     NEXT FIELD snb01
                  END IF
#MOD-CC0161---add---E  
 
                #自動帶出工單資訊
                  CALL t801_snb01(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD snb01
                  END IF
               END IF
            END IF
 
        BEFORE FIELD snb022
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND (( g_snb.snb01 != g_snb01_t)
               OR (g_snb.snb01 != g_snb01_t))) THEN
                SELECT COUNT(*) INTO l_n FROM snb_file
                 WHERE snb01 = g_snb.snb01
                   AND snb02 = g_snb.snb02
                IF l_n > 0 THEN
                   CALL cl_err(g_snb.snb01,'mfg4000',0)
                   LET g_snb.snb01 = g_snb01_t
                   LET g_snb.snb02 = g_snb02_t
                   DISPLAY BY NAME g_snb.snb01
                   DISPLAY BY NAME g_snb.snb02
                   NEXT FIELD snb01
                END IF
#工單第一次變更時， default 1 ，之後工單每變更一次序號加 1
                IF p_cmd = 'a' THEN
                #---------No.MOD-5B0271 mark
#                  SELECT sfb101 INTO g_snb.snb02 FROM sfb_file
#                  WHERE sfb01 = g_snb.snb01
#                  IF cl_null(g_snb.snb02) THEN
#                     LET g_snb.snb02 = 1
#                  ELSE
#                     LET g_snb.snb02 = g_snb.snb02 + 1
#                  END IF
#                  DISPLAY BY NAME g_snb.snb02
                #----------No.MOD-5B0271 end
                   #本欄位預設值為系統日期
                   IF cl_null(g_snb.snb022) THEN
                      LET g_snb.snb022 = g_today
                   END IF
                END IF
            END IF
 
        AFTER FIELD snb022
           IF NOT cl_null(g_snb.snb022) THEN
 
             #日期不可大於單據輸入會計年度/期別
              CALL s_yp(g_snb.snb022) RETURNING g_yy,g_mm
              IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                 CALL cl_err(g_yy,'mfg6090',0) NEXT FIELD snb022
              END IF
 
             #日期不可小於成本關帳日期sma53
              IF NOT cl_null(g_sma.sma53) AND g_snb.snb022<g_sma.sma53
              THEN
                 CALL cl_err('','mfg9999',0) NEXT FIELD snb022
              END IF
           END IF
 
        AFTER FIELD snb08a
           IF NOT cl_null(g_snb.snb08a) THEN
 #MOD-530156
              #變更後的資料不可為0
               IF g_snb.snb08a = 0 THEN
                  CALL cl_err('','asf-049',0)
                  NEXT FIELD snb08a
               END IF
##
 
              #變更後的資料與變更前資料相同不須輸入
               IF g_snb.snb08b = g_snb.snb08a THEN
                  CALL cl_err('','asf-054',0)
                  NEXT FIELD snb08a
               END IF
            #TQC-C80137--mark--
            # #變更的生產套數不可大於工單生產套數
            #  IF g_snb.snb08b < g_snb.snb08a THEN
            #     CALL cl_err('','asf-055',0)
            #     NEXT FIELD snb08a
            #  END IF
            #TQC-C80137--mark--
 
              #變更的生產套數不可小於工單已發套數 !
               IF g_sfb081 > g_snb.snb08a THEN
                  CALL cl_err('','asf-056',0)
                  NEXT FIELD snb08a
               END IF
 
              #變更的生產套數不可小於工單完工入庫套數
               IF g_sfb09 > g_snb.snb08a THEN
                  CALL cl_err('','asf-057',0)
                  NEXT FIELD snb08a
               END IF
 
              #工單若為委外工單/重工委外工單(sfb02='7' OR sfb02='8')
              #變更的生產套數不可小於備料最大的-委外代買量(sfa065)
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM sfa_file,sfb_file
                 WHERE sfb01 = g_snb.snb01
                   AND ( sfb02 = '7' OR sfb02 = '8' )
                   AND sfb01 = sfa01
                  #AND ( sfa065 IS NOT NULL AND sfa065 < g_snb.snb08a )          #MOD-A80225 mark
                   AND ( sfa065 IS NOT NULL AND sfa065 < g_snb.snb08a*sfa161)    #MOD-A80225 add
                  #AND sfbact = 'Y' #TQC-940175   
                   AND sfbacti = 'Y' #TQC-940175  
               IF l_cnt > 0 THEN
                   CALL cl_err('','asf-058',0)
                   NEXT FIELD snb08a
               END IF
            #--No.FUN-570041 add
               SELECT ima55 INTO g_ima55 FROM ima_file where ima01=g_sfb05
               SELECT gfe03 INTO g_gfe03 FROM gfe_file WHERE gfe01=g_ima55
               IF cl_null(g_gfe03) THEN LET g_gfe03=0 END IF
               CALL cl_digcut(g_snb.snb08a,g_gfe03) RETURNING l_sfbqty
               LET g_snb.snb08a = l_sfbqty
               DISPLAY BY NAME g_snb.snb08a
             #--end

               #TQC-C50088--add--str--
               IF (g_snb08a_t IS NULL OR g_snb08a_t<>g_snb.snb08a) THEN
                  IF cl_confirm("asf-981") THEN
                     LET g_snb.snb15a=t801_time('1')                                                  
                     LET g_snb15a_t = g_snb.snb15a 
                     DISPLAY BY NAME g_snb.snb15a
                  END IF
               END IF 
               #TQC-C50088--add--end--
           END IF
           LET g_snb08a_t = g_snb.snb08a  #TQC-C50088 add

        AFTER FIELD snb13a
           IF NOT cl_null(g_snb.snb13a) THEN
              #變更後的資料與變更前資料相同不須輸入
               IF g_snb.snb13b = g_snb.snb13a THEN
                  CALL cl_err('','asf-054',0)
                  NEXT FIELD snb13a
               END IF
             #TQC-C80127--add--str--
               SELECT sfb81 INTO l_sfb81 FROM sfb_file WHERE sfb01 = g_snb.snb01
               IF g_snb.snb13a < l_sfb81 THEN 
                  CALL cl_err('','asf-867',1)
                  NEXT FIELD snb13a
               END IF
             #TQC-C80127 --add--end--

              #TQC-C50088--add--str--
              IF g_snb13a_t IS NULL OR g_snb13a_t<>g_snb.snb13a THEN
                 LET li_result = 0
                 CALL s_daywk(g_snb.snb13a) RETURNING li_result
                 IF li_result = 0 THEN      #0:非工作日
                    CALL cl_err(g_snb.snb13a,'mfg3152',1)
                 END IF
                 IF li_result = 2 THEN      #2:未設定
                    CALL cl_err(g_snb.snb13a,'mfg3153',1)
                 END IF
                 IF cl_confirm("asf-983") THEN
                    LET g_snb.snb15a=t801_time('1')     
                 #TQC-C80127--add--
                    IF g_snb.snb15a < l_sfb81 THEN
                       CALL cl_err('','asf-868',1)
                       NEXT FIELD snb13a
                    ELSE
                       LET g_snb15a_t = g_snb.snb15a
                    END IF
                #TQC-C80127--add--         
                #   LET g_snb15a_t = g_snb.snb15a    #TQC-C80127--
                    DISPLAY BY NAME g_snb.snb15a
                 END IF
              END IF
              #TQC-C50088--add--end--
               IF NOT cl_null(g_snb.snb15a) THEN
                  IF g_snb.snb15a < g_snb.snb13a THEN
                     CALL cl_err('','asf-310',0)
                     NEXT FIELD snb13a
                  END IF
               #TQC-C50088--mark--str--
               #ELSE
               #   IF g_snb.snb15b < g_snb.snb13a THEN
               #      CALL cl_err('','asf-310',0)
               #      NEXT FIELD snb13a
               #   END IF
               #TQC-C50088--mark--end--
               END IF
           #TQC-C50088--mark--str--
           #ELSE
           #    IF NOT cl_null(g_snb.snb15a) THEN
           #       IF g_snb.snb15a < g_snb.snb13b THEN
           #          CALL cl_err('','asf-310',0)
           #          NEXT FIELD snb13a
           #       END IF
           #    END IF
           #TQC-C50088--mark--end--
           END IF 
           LET g_snb13a_t = g_snb.snb13a  #TQC-C50088 add

        AFTER FIELD snb15a
           IF NOT cl_null(g_snb.snb15a) THEN
              #變更後的資料與變更前資料相同不須輸入
               IF g_snb.snb15b = g_snb.snb15a THEN
                  CALL cl_err('','asf-054',0)
                  NEXT FIELD snb15a
               END IF
            #TQC-C80127--add--str--
               SELECT sfb81 INTO l_sfb81 FROM sfb_file WHERE sfb01 = g_snb.snb01
               IF g_snb.snb15a < l_sfb81 THEN
                  CALL cl_err('','asf-868',1)
                  NEXT FIELD snb15a
               END IF
             #TQC-C80127 --add--end--
              #TQC-C50088--add--str--
              IF g_snb15a_t IS NULL OR g_snb15a_t<>g_snb.snb15a THEN
                 LET li_result = 0
                 CALL s_daywk(g_snb.snb15a) RETURNING li_result
                 IF li_result = 0 THEN      #0:非工作日 
                    CALL cl_err(g_snb.snb15a,'mfg3152',1)
                 END IF
                 IF li_result = 2 THEN      #2:未設定 
                    CALL cl_err(g_snb.snb15a,'mfg3153',1)
                 END IF
                 IF cl_confirm("asf-379") THEN
                    LET g_snb.snb13a=t801_time('2')     
                #TQC-C80127--add--str--
                    IF g_snb.snb13a < l_sfb81 THEN
                       CALL cl_err('','asf-867',1)
                       NEXT FIELD snb15a
                    ELSE
                       LET g_snb13a_t = g_snb.snb13a
                    END IF
                #TQC-C80127 --add--end--
                 #  LET g_snb13a_t = g_snb.snb13a    #TQC-C80127
                    DISPLAY BY NAME g_snb.snb13a
                 END IF
              END IF
              #TQC-C50088--add--end--
               IF NOT cl_null(g_snb.snb13a) THEN
                  IF g_snb.snb13a > g_snb.snb15a THEN
                     CALL cl_err('','asf-310',0)
                     NEXT FIELD snb15a
                  END IF
               #TQC-C50088--mark--str--
               #ELSE
               #   IF g_snb.snb13b > g_snb.snb15a THEN
               #      CALL cl_err('','asf-310',0)
               #      NEXT FIELD snb15a
               #   END IF
               #TQC-C50088--mark--end--
               END IF
           #TQC-C50088--mark--str--
           #ELSE
           #    IF NOT cl_null(g_snb.snb13a) THEN
           #       IF g_snb.snb13a > g_snb.snb15b THEN
           #          CALL cl_err('','asf-310',0)
           #          NEXT FIELD snb15a
           #       END IF
           #    END IF
           #TQC-C50088--mark--end--  
           END IF
           LET g_snb15a_t = g_snb.snb15a  #TQC-C50088 add
 
        AFTER FIELD snb82a
           IF NOT cl_null(g_snb.snb82a) THEN
              #變更後的資料與變更前資料相同不須輸入
               IF g_snb.snb82b = g_snb.snb82a THEN
                  CALL cl_err('','asf-054',0)
                  NEXT FIELD snb82a
               END IF
               IF g_sfb02=7 THEN
                  SELECT * FROM pmc_file WHERE pmc01=g_snb.snb82a
                  IF STATUS THEN
#                    CALL cl_err('sel pmc',STATUS,0) #No.FUN-660128
                     CALL cl_err3("sel","pmc_file",g_snb.snb82a,"",STATUS,"","sel pmc",1)  #No.FUN-660128
                     NEXT FIELD snb82a   
                  END IF
               ELSE
                  SELECT * FROM gem_file WHERE gem01=g_snb.snb82a
                  IF STATUS THEN
#                    CALL cl_err('sel gem',STATUS,0) #No.FUN-660128
                     CALL cl_err3("sel","gem_file",g_snb.snb82a,"",STATUS,"","sel gem",1)  #No.FUN-660128
                     NEXT FIELD snb82a   
                  END IF
               END IF
           END IF
 
        AFTER FIELD snb98a
            IF NOT cl_null(g_snb.snb98a) THEN
              #變更後的資料與變更前資料相同不須輸入
               IF g_snb.snb98b = g_snb.snb98a THEN
                  CALL cl_err('','asf-054',0)
                  NEXT FIELD snb98a
               END IF
               CALL t801_snb98a('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD snb98a
               END IF
            END IF
 
	AFTER INPUT
	   LET g_snb.snbuser = s_get_data_owner("snb_file") #FUN-C10039
	   LET g_snb.snbgrup = s_get_data_group("snb_file") #FUN-C10039
	    IF INT_FLAG THEN  EXIT INPUT END IF
           #TQC-C50088--add--str--
           IF NOT cl_null(g_snb.snb13a) THEN
              IF NOT cl_null(g_snb.snb15a) THEN     
                 IF g_snb.snb13a>g_snb.snb15a THEN
                    CALL cl_err('','asf-378',1)
                    NEXT FIELD snb13a
                 END IF
              ELSE                                
                 IF g_snb.snb13a>g_snb.snb15b THEN
                    CALL cl_err('','asf-378',1)
                    NEXT FIELD snb13a
                 END IF
              END IF
           ELSE                            
              IF NOT cl_null(g_snb.snb15a) THEN
                 IF g_snb.snb13b>g_snb.snb15a THEN
                    CALL cl_err('','asf-378',1)
                    NEXT FIELD snb15a
                 END IF
              END IF
           END IF
           #TQC-C50088--add--end--
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(snb01)
                 #CALL q_sfb(0,0,g_snb.snb01,'234567') RETURNING g_snb.snb01
                 #CALL FGL_DIALOG_SETBUFFER( g_snb.snb01 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_sfb"
                  LET g_qryparam.default1 = g_snb.snb01
                  LET g_qryparam.arg1     = "234567"
                  CALL cl_create_qry() RETURNING g_snb.snb01
#                  CALL FGL_DIALOG_SETBUFFER( g_snb.snb01 )
                  DISPLAY BY NAME g_snb.snb01
                  NEXT FIELD snb01
               WHEN INFIELD(snb82a)
                  IF g_sfb02=7 THEN
                    #CALL q_pmc(0,0,g_snb.snb82a) RETURNING g_snb.snb82a
                    #CALL FGL_DIALOG_SETBUFFER( g_snb.snb82a )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_pmc"
                     LET g_qryparam.default1 = g_snb.snb82a
                     CALL cl_create_qry() RETURNING g_snb.snb82a
#                     CALL FGL_DIALOG_SETBUFFER( g_snb.snb82a )
                  ELSE
                    #CALL q_gem(10,2,g_snb.snb82a) RETURNING g_snb.snb82a
                    #CALL FGL_DIALOG_SETBUFFER( g_snb.snb82a )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_gem"
                     LET g_qryparam.default1 = g_snb.snb82a
                     CALL cl_create_qry() RETURNING g_snb.snb82a
#                     CALL FGL_DIALOG_SETBUFFER( g_snb.snb82a )
                   END IF
                   DISPLAY BY NAME g_snb.snb82a
                   NEXT FIELD snb82a
               WHEN INFIELD(snb98a)   #No:7686
                 #CALL q_gem(10,2,g_snb.snb98a) RETURNING g_snb.snb98a
                 #CALL FGL_DIALOG_SETBUFFER( g_snb.snb98a )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gem"
                  LET g_qryparam.default1 = g_snb.snb98a
                  CALL cl_create_qry() RETURNING g_snb.snb98a
#                  CALL FGL_DIALOG_SETBUFFER( g_snb.snb98a )
                   DISPLAY BY NAME g_snb.snb98a        #No.MOD-490371
                  NEXT FIELD snb98a
               OTHERWISE EXIT CASE
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
 
    END INPUT
END FUNCTION
 
FUNCTION t801_snb01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_imaacti       LIKE ima_file.imaacti,
    l_sfb    RECORD LIKE sfb_file.*
 
    LET g_errno = ''
    SELECT *  INTO l_sfb.* FROM sfb_file
     WHERE sfb01 = g_snb.snb01
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-312'
                                   LET l_sfb.sfb05 = NULL
                                   LET l_sfb.sfbacti = NULL
         WHEN l_sfb.sfbacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) AND NOT cl_null(l_sfb.sfb05) THEN
       SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti FROM ima_file
        WHERE ima01 = l_sfb.sfb05
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                      LET l_ima02 = NULL
                                      LET l_ima021 = NULL
                                      LET l_imaacti = NULL
            WHEN l_imaacti='N' LET g_errno = '9028'
            WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  #No.FUN-690022 add
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
    END IF
 
       LET g_sfb02  = l_sfb.sfb02
       LET g_sfb081 = l_sfb.sfb081
       LET g_sfb09  = l_sfb.sfb09
       LET g_sfb05  = l_sfb.sfb05        #No.MOD-740021 add
 
    IF p_cmd !='d' THEN
       LET g_snb.snb08b = l_sfb.sfb08
       LET g_snb.snb13b = l_sfb.sfb13
       LET g_snb.snb15b = l_sfb.sfb15
       LET g_snb.snb34b = l_sfb.sfb34
       LET g_snb.snb40b = l_sfb.sfb40
       LET g_snb.snb82b = l_sfb.sfb82
       LET g_snb.snb98b = l_sfb.sfb98
    END IF
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
        DISPLAY l_sfb.sfb05  TO FORMONLY.sfb05
        DISPLAY l_ima02      TO FORMONLY.ima02
        DISPLAY l_ima021     TO FORMONLY.ima021
        DISPLAY l_sfb.sfb02  TO FORMONLY.sfb02
        DISPLAY l_sfb.sfb04  TO FORMONLY.sfb04
        DISPLAY BY NAME g_snb.snb08b
        DISPLAY BY NAME g_snb.snb13b
        DISPLAY BY NAME g_snb.snb15b
        DISPLAY BY NAME g_snb.snb82b
        DISPLAY BY NAME g_snb.snb98b
    END IF
END FUNCTION
 
FUNCTION t801_snb98a(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_gemacti       LIKE gem_file.gemacti,    #No:7686
    l_sfb    RECORD LIKE sfb_file.*
 
    LET g_errno = ''
#NO:7686
    SELECT gemacti  INTO l_gemacti FROM gem_file
     WHERE gem01 = g_snb.snb98a
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1318'
                                   LET l_gemacti = NULL
         WHEN l_gemacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
##
 
END FUNCTION
 
 
FUNCTION t801_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_snb.* TO NULL              #No.FUN-6A0164
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '' TO FORMONLY.cnt
    CALL t801_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_snb.snb01 = NULL   #MOD-660086 add
       LET g_snb.snb02 = NULL   #MOD-660086 add
       CLEAR FORM
       RETURN
    END IF
    OPEN t801_count
    FETCH t801_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t801_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)
       INITIALIZE g_snb.* TO NULL
    ELSE
       CALL t801_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t801_fetch(p_flsnb)
    DEFINE
        p_flsnb         LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680121 INTEGER
 
    CASE p_flsnb
        WHEN 'N' FETCH NEXT     t801_cs INTO  g_snb.snb01,g_snb.snb02
        WHEN 'P' FETCH PREVIOUS t801_cs INTO  g_snb.snb01,g_snb.snb02
        WHEN 'F' FETCH FIRST    t801_cs INTO  g_snb.snb01,g_snb.snb02
        WHEN 'L' FETCH LAST     t801_cs INTO  g_snb.snb01,g_snb.snb02
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t801_cs INTO  g_snb.snb01,g_snb.snb02
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)
        INITIALIZE g_snb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flsnb
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_snb.* FROM snb_file  # 重讀DB,因TEMP有不被更新特性
       WHERE snb01 = g_snb.snb01
         AND snb02 = g_snb.snb02
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)   #No.FUN-660128
       CALL cl_err3("sel","snb_file",g_snb.snb01,g_snb.snb02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_snb.* TO NULL            #FUN-4C0035
    ELSE
       LET g_data_owner = g_snb.snbuser      #FUN-4C0035
       LET g_data_group = g_snb.snbgrup      #FUN-4C0035
       LET g_data_plant = g_snb.snbplant #FUN-980030
       CALL t801_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t801_show()
 
    LET g_snb_t.* = g_snb.*
    #TQC-C50088--add--str--
    LET g_snb08a_t = g_snb.snb08a 
    LET g_snb13a_t = g_snb.snb13a 
    LET g_snb15a_t = g_snb.snb15a 
    #TQC-C50088--add--end--
    DISPLAY BY NAME g_snb.snboriu,g_snb.snborig,
        g_snb.snb01,g_snb.snb02,g_snb.snb022,g_snb.snb08a,
        g_snb.snb13a,g_snb.snb15a,g_snb.snb82a,g_snb.snb98a,g_snb.snbconf,
        g_snb.snbuser,g_snb.snbgrup,g_snb.snbmodu,g_snb.snbdate
    CALL t801_snb01('d')
 
    CASE g_snb.snbconf
         WHEN 'Y'   LET g_confirm = 'Y'
                    LET g_void = ''
         WHEN 'N'   LET g_confirm = 'N'
                    LET g_void = ''
         WHEN 'X'   LET g_confirm = ''
                    LET g_void = 'Y'
      OTHERWISE     LET g_confirm = ''
                    LET g_void = ''
    END CASE
    #圖形顯示
    CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t801_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_snb.snb01) THEN
        CALL cl_err(g_snb.snb01,-400,0)
        RETURN
    END IF
    IF g_snb.snbconf ="X" OR g_snb.snbconf="Y" THEN    #檢查資料是否為無效
        CALL cl_err(g_snb.snb01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_snb01_t = g_snb.snb01
    BEGIN WORK
 
    OPEN t801_cl USING g_snb.snb01,g_snb.snb02
 
    IF STATUS THEN
       CALL cl_err("OPEN t801_cl:", STATUS, 1)
       CLOSE t801_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t801_cl INTO g_snb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_snb.snbmodu = g_user               #修改者
    LET g_snb.snbdate = g_today              #修改日期
    CALL t801_show()                         # 顯示最新資料
    WHILE TRUE
        CALL t801_i("u")                     # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_snb.* = g_snb_t.*
            CALL t801_show()
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            EXIT WHILE
        END IF
        IF cl_null(g_snb.snb08a) AND cl_null(g_snb.snb13a) AND
           cl_null(g_snb.snb15a) AND cl_null(g_snb.snb82a) AND
           cl_null(g_snb.snb98a) THEN
           #沒有輸入變更資料，是否存此筆資料？
           IF cl_confirm('asf-059') THEN
    #          DELETE FROM snb_fiel
              DELETE FROM snb_file    #No.FUN-660128
               WHERE snb01 = g_snb.snb01
                 AND snb02 = g_snb.snb02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)   #No.FUN-660128
                 CALL cl_err3("del","snb_file",g_snb.snb01,g_snb.snb02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                 ROLLBACK WORK
                 EXIT WHILE
              ELSE
                 DELETE FROM snc_file
                  WHERE snc01 = g_snc.snc01
                    AND snc02 = g_snc.snc02
              END IF
           END IF
        END IF
        UPDATE snb_file SET snb_file.* = g_snb.*    # 更新DB
            WHERE snb01 = g_snb.snb01
              AND snb02 = g_snb.snb02
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("upd","snb_file",g_snb01_t,g_snb02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660128
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t801_cl
    COMMIT WORK
END FUNCTION
 
#FUNCTION t801_x()  #CHI-D2001
FUNCTION t801_x(p_type) #CHI-D2001
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
    DEFINE l_flag  LIKE type_file.chr1  #CHI-D20010
    DEFINE p_type  LIKE type_file.chr1  #CHI-D2001
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_snb.snb01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_snb.snbconf = 'Y' THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    #CHI-D20010---begin
    IF p_type = 1 THEN
       IF g_snb.snbconf ='X' THEN RETURN END IF
    ELSE
       IF g_snb.snbconf <>'X' THEN RETURN END IF
    END IF
    #CHI-D20010---end

    BEGIN WORK
 
    OPEN t801_cl USING g_snb.snb01,g_snb.snb02
 
    IF STATUS THEN
       CALL cl_err("OPEN t801_cl:", STATUS, 1)
       CLOSE t801_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t801_cl INTO g_snb.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    IF g_snb.snbconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
    CALL t801_show()
   # Prog. Version..: '5.30.06-13.03.12(0,0,g_snb.snbconf) THEN   #CHI-D20010
    IF cl_void(0,0,l_flag) THEN          #CHI-D20010
        LET g_chr=g_snb.snbconf
       #IF g_snb.snbconf='X' THEN  #CHI-D20010
        IF p_type=2 THEN           #CHI-D20010
            LET g_snb.snbconf='N'
        ELSE
            LET g_snb.snbconf='X'
        END IF
        UPDATE snb_file SET snbconf=g_snb.snbconf,
                            snbmodu=g_user,
                            snbdate=g_today
            WHERE snb01 = g_snb.snb01
              AND snb02 = g_snb.snb02
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("upd","snb_file",g_snb01_t,g_snb02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660128
            LET g_snb.snbconf=g_chr
            ROLLBACK WORK
            RETURN
        END IF
        DISPLAY BY NAME g_snb.snbconf
    END IF
    COMMIT WORK
    CLOSE t801_cl
END FUNCTION
 
FUNCTION t801_r()
    DEFINE  l_azo05     LIKE azo_file.azo05        #No.FUN-680121 VARCHAR(18)
    DEFINE  l_azo06     LIKE azo_file.azo06        #No.FUN-680121 VARCHAR(72)
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_snb.snb01) THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    BEGIN WORK
 
    OPEN t801_cl USING g_snb.snb01,g_snb.snb02
 
    IF STATUS THEN
       CALL cl_err("OPEN t801_cl:", STATUS, 1)
       CLOSE t801_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t801_cl INTO g_snb.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL t801_show()
    IF g_snb.snbconf = 'Y' THEN CALL cl_err('','asf-060',0) RETURN END IF
    IF g_snb.snbconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "snb01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "snb02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_snb.snb01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_snb.snb02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM snb_file
        WHERE snb01 = g_snb.snb01
          AND snb02 = g_snb.snb02
       IF SQLCA.sqlcode THEN
#         CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660128
          CALL cl_err3("del","snb_file",g_snb.snb01,g_snb.snb02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
          ROLLBACK WORK
       ELSE
          DELETE FROM sna_file
           WHERE sna01 = g_snb.snb01
             AND sna02 = g_snb.snb02
          DELETE FROM snc_file
           WHERE snc01 = g_snb.snb01
             AND snc02 = g_snb.snb02
       END IF
       LET g_msg=TIME
       LET l_azo05='asft801','-',g_snb.snb02 USING '&&&'
       LET l_azo06=g_snb.snb01,'-',g_snb.snb02,'   ','delete' CLIPPED
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)       #FUN-980008 add
              VALUES ('asft801',g_user,g_today,g_msg,l_azo05,l_azo06,g_plant,g_legal)    #FUN-980008 add
       CLEAR FORM
       DISPLAY BY NAME g_snb.snb04
       OPEN t801_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t801_cs
          CLOSE t801_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t801_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t801_cs
          CLOSE t801_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t801_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t801_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL t801_fetch('/')
       END IF
    END IF
    CLOSE t801_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t801_memo()
   DEFINE p1		LIKE snb_file.snb01
   DEFINE p2		LIKE snb_file.snb02
   DEFINE i,j,n         LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE l_rec_b       LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE l_snc         DYNAMIC ARRAY OF RECORD
                        snc05        LIKE snc_file.snc05,
                        snc06        LIKE snc_file.snc06
                        END RECORD
   IF cl_null(g_snb.snb01) THEN RETURN END IF
 
   OPEN WINDOW asf_w_m AT 05,02 WITH FORM "asf/42f/asft801m"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("asft801m")
 
   DECLARE asf_memo CURSOR FOR
           SELECT snc05,snc06 FROM snc_file
            WHERE snc01 = g_snb.snb01
              AND snc02 = g_snb.snb02
            ORDER BY snc05
 
   FOR i = 1 TO l_snc.getLength() INITIALIZE l_snc[i].* TO NULL END FOR
   LET i = 1
   FOREACH asf_memo INTO l_snc[i].snc05,l_snc[i].snc06
      IF STATUS THEN CALL cl_err('foreach snc',STATUS,0) EXIT FOREACH END IF
      LET i = i + 1
      IF i > 30 THEN EXIT FOREACH END IF
   END FOREACH
   LET l_rec_b=i-1
   INPUT ARRAY l_snc WITHOUT DEFAULTS FROM s_snc.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
 
     BEFORE ROW
        LET i=ARR_CURR()
        LET j=SCR_LINE()
        DISPLAY l_snc[i].snc05 TO s_snc[j].snc05
        DISPLAY l_snc[i].snc06 TO s_snc[j].snc06
 
        IF cl_null(l_snc[i].snc05) THEN
           IF i > 1 THEN
              LET l_snc[i].snc05=l_snc[i-1].snc05+1
           ELSE
              LET l_snc[i].snc05=1
           END IF
        END IF
        DISPLAY l_snc[i].snc05 TO s_snc[j].snc05
 
     AFTER DELETE
        LET n=ARR_CURR()
        INITIALIZE l_snc[n].* TO NULL
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
   CLOSE WINDOW asf_w_m
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   DELETE FROM snc_file
    WHERE snc01 = g_snb.snb01
      AND snc02 = g_snb.snb02
   FOR i = 1 TO l_snc.getLength()
       IF cl_null(l_snc[i].snc06) THEN CONTINUE FOR END IF
       INSERT INTO snc_file (snc01,snc02,snc03,snc08,snc12,snc05,snc06,
                             sncplant,snclegal) #FUN-980008 add
                      VALUES(g_snb.snb01,g_snb.snb02,'','','',
                             l_snc[i].snc05,l_snc[i].snc06,
                             g_plant,g_legal)   #FUN-980008 add
       IF STATUS THEN
    #   CALL cl_err('ins snc',STATUS,1)  #No.FUN-660128
        CALL cl_err3("ins","snc_file",g_snb.snb01,g_snb.snb02,STATUS,"","ins snc",1)   #No.FUN-660128
       END IF
   END FOR
END FUNCTION
 
FUNCTION t801_g()
 DEFINE  l_azo05     LIKE azo_file.azo05        #No.FUN-680121 VARCHAR(18)
 DEFINE  l_azo06     LIKE azo_file.azo06        #No.FUN-680121 VARCHAR(72)
 DEFINE  l_sfb   RECORD LIKE sfb_file.*,
         b_sfb   RECORD LIKE sfb_file.*
 
    IF s_shut(0) THEN RETURN END IF
 
    IF cl_null(g_snb.snb01) THEN
       CALL cl_err('',-400,0) RETURN
    END IF
 
#NO.MOD-640359 start--
    IF cl_null(g_snb.snb08a) AND cl_null(g_snb.snb13a) AND
       cl_null(g_snb.snb15a) AND cl_null(g_snb.snb82a) AND
       cl_null(g_snb.snb98a) THEN
       CALL cl_err('','asf-969',0)
       RETURN
    END IF
#NO.MOD-640359 start--
 
    LET g_success = 'Y'
    BEGIN WORK
 
    OPEN t801_cl USING g_snb.snb01,g_snb.snb02
 
    IF STATUS THEN
       CALL cl_err("OPEN t801_cl:", STATUS, 1)
       CLOSE t801_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t801_cl INTO g_snb.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)
        CLOSE t801_cl
        ROLLBACK WORK
        RETURN
    END IF
    CALL t801_show()
    IF g_snb.snbconf = 'Y' THEN
       CALL cl_err('','asf-061',0)
       CLOSE t801_cl
       ROLLBACK WORK
       RETURN
    END IF
 
   #發出否snbconf='N'，才可執行
    IF g_snb.snbconf = 'X' THEN
       CALL cl_err('','9024',0)
       CLOSE t801_cl
       ROLLBACK WORK
       RETURN
    END IF
 
   #需檢查變更日期不可大於會計年度/期別，和小於系統關帳日期
    IF NOT cl_null(g_sma.sma53) AND g_snb.snb022 <= g_sma.sma53 THEN
       CALL cl_err('','mfg9999',0)
       CLOSE t801_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL s_yp(g_snb.snb022) RETURNING g_yy,g_mm
    IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
       CALL cl_err(g_yy,'mfg6090',0)
       CLOSE t801_cl
       ROLLBACK WORK
       RETURN
    END IF
    IF NOT cl_sure(15,22) THEN
       CLOSE t801_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01 = g_snb.snb01
    IF SQLCA.sqlcode THEN
#      CALL cl_err('g_sel_sfb',SQLCA.sqlcode,0)   #No.FUN-660128
       CALL cl_err3("sel","sfb_file",g_snb.snb01,"",SQLCA.sqlcode,"","g_sel_sfb",1)  #No.FUN-660128
       ROLLBACK WORK
       RETURN
    END IF
 
   #若變更生產套數需 INSERT 工單變更單身檔 [sna_file]
    IF g_snb.snb08a > 0 THEN
       CALL t801_g1()     #變動單頭生產數量 -->add單身變更資料
    END IF
    IF g_success = 'Y' THEN
       LET g_sfb.sfb101 = g_snb.snb02
       IF NOT cl_null(g_snb.snb08a) THEN LET g_sfb.sfb08 = g_snb.snb08a END IF
       IF NOT cl_null(g_snb.snb13a) THEN LET g_sfb.sfb13 = g_snb.snb13a END IF
       IF NOT cl_null(g_snb.snb15a) THEN LET g_sfb.sfb15 = g_snb.snb15a END IF
       IF NOT cl_null(g_snb.snb82a) THEN LET g_sfb.sfb82 = g_snb.snb82a END IF
       IF NOT cl_null(g_snb.snb98a) THEN LET g_sfb.sfb98 = g_snb.snb98a END IF
       UPDATE sfb_file SET * = g_sfb.* WHERE sfb01 = g_snb.snb01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL cl_err('upd_sfb',SQLCA.sqlcode,0)   #No.FUN-660128
          CALL cl_err3("upd","sfb_file","","",SQLCA.sqlcode,"","upd_sfb",1)  #No.FUN-660128
          LET g_success = 'N'
       END IF
     END IF
     IF g_success = 'Y' THEN
        LET g_snb.snbconf = 'Y'
        LET g_snb.snb99 = '2'  #MOD-D10253
        UPDATE snb_file SET snbconf = g_snb.snbconf,
                            snb99 = g_snb.snb99  #MOD-D10253
         WHERE snb01 = g_snb.snb01
           AND snb02 = g_snb.snb02
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL cl_err('g_upd snb_file',SQLCA.sqlcode,0)   #No.FUN-660128
          CALL cl_err3("upd","snb_file",g_snb01_t,g_snb02_t,SQLCA.sqlcode,"","g_upd snb_file",1)  #No.FUN-660128
          LET g_success = 'N'
       ELSE
          DISPLAY BY NAME g_snb.snbconf
       END IF
     END IF
 
     LET g_msg=TIME
     LET l_azo05='asft801','-',g_snb.snb02 USING '&&&'
     LET l_azo06=g_snb.snb01,'-',g_snb.snb02 USING '&&&','   ','t801_g' CLIPPED
     INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)     #FUN-980008 add
            VALUES ('asft801',g_user,g_today,g_msg,l_azo05,l_azo06,g_plant,g_legal)  #FUN-980008 add
     IF g_success = 'Y' THEN
        COMMIT WORK
        CALL cl_cmmsg(2)
     ELSE
        ROLLBACK WORK
        CALL cl_rbmsg(2)
     END IF
     CLOSE t801_cl
 
END FUNCTION
 
FUNCTION t801_g1()
 DEFINE p_sfb02   LIKE sfb_file.sfb02,
        l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        l_sum_sna05a  LIKE sna_file.sna05a,
        l_sna05a      LIKE sna_file.sna05a,
        s_sfa     RECORD
          sfa27   LIKE sfa_file.sfa27,
          sfa05   LIKE sfa_file.sfa05,
          sfa06   LIKE sfa_file.sfa06,
          sfa062  LIKE sfa_file.sfa062,
          sfa07   LIKE sfa_file.sfa07
                  END RECORD,
        l_sfa     RECORD LIKE sfa_file.*,
        l_sna     RECORD LIKE sna_file.*
 
#read sfa_file --> insert into sna_file --> 舊值寫入
    LET l_cnt = 1
    FOREACH t801_g0_cl INTO l_sfa.*
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      INITIALIZE l_sna.* TO NULL
      LET l_sna.sna01  = g_snb.snb01
      LET l_sna.sna02  = g_snb.snb02
      LET l_sna.sna022 = g_snb.snb022
      LET l_sna.sna04  = l_cnt
     #若變更生產套數需 INSERT 工單變更單身檔 [sna_file]
     #單身變異別 sna10 = '4' 單頭變更,影響單身變更
      LET l_sna.sna10  = '4'
      LET l_sna.sna03b = l_sfa.sfa03
 
      LET l_sna.sna05b = l_sfa.sfa05
      LET l_sna.sna06b = l_sfa.sfa06
      LET l_sna.sna062b= l_sfa.sfa062
      LET l_sna.sna065b= l_sfa.sfa065
      LET l_sna.sna07b = l_sfa.sfa07
      LET l_sna.sna08b = l_sfa.sfa08
      LET l_sna.sna100b= l_sfa.sfa100
      LET l_sna.sna11b = l_sfa.sfa11
      LET l_sna.sna12b = l_sfa.sfa12
      LET l_sna.sna13b = l_sfa.sfa13
      LET l_sna.sna161b= l_sfa.sfa161
      LET l_sna.sna26b = l_sfa.sfa26
      LET l_sna.sna27b = l_sfa.sfa27
      LET l_sna.sna28b = l_sfa.sfa28
      LET l_sna.sna30b = l_sfa.sfa30
 
      LET l_sna.snaplant = g_plant #FUN-980008 add
      LET l_sna.snalegal = g_legal #FUN-980008 add
 
 #--No.FUN-570041 add
      SELECT ima55 INTO g_ima55 FROM ima_file where ima01=l_sna.sna03b
      SELECT gfe03 INTO g_gfe03 FROM gfe_file WHERE gfe01=g_ima55
      IF cl_null(g_gfe03) THEN LET g_gfe03=0 END IF
      CALL cl_digcut(l_sna.sna05b,g_gfe03) RETURNING l_sfbqty
      LET l_sna.sna05b = l_sfbqty
   #--end
 
     #變更前替代碼='6'者,不需做任何處理(6.主料,已做SET替代)
     #(因其應發,已發,欠料,超領,QPA皆為0)
      IF l_sfa.sfa26 = '6' THEN
         LET l_sna.sna05a = l_sna.sna05b
         LET l_sna.sna06a = l_sna.sna06b
         LET l_sna.sna062a = l_sna.sna062b
         LET l_sna.sna065a = l_sna.sna065b
         LET l_sna.sna07a = l_sna.sna07b
      END IF
 
      #一般備料數量變更
      IF l_sfa.sfa26 MATCHES '[0125T7]' THEN        #FUN-A20037 add '7'
         LET l_sna.sna05a = g_snb.snb08a * l_sna.sna161b
         LET l_sna.sna05a = s_digqty(l_sna.sna05a,l_sna.sna12b)    #FUN-910088--add--
         IF cl_null(l_sna.sna05a) THEN LET l_sna.sna05a=0 END IF
         LET l_sna.sna05a = t801_sna05a(l_sna.sna03b,l_sna.sna05a,l_sna.sna12b)  #No.MOD-740003 add
         LET l_sna.sna05a = s_digqty(l_sna.sna05a,l_sna.sna12b)    #FUN-910088--add--
 
        #變更後應發(sna05a) < 變更前已發數量(sfb06)
         IF l_sna.sna05a < l_sfa.sfa06 THEN
            LET l_sna.sna06a = l_sna.sna05a
            LET l_sna.sna062a= l_sna.sna062b + l_sna.sna06b - l_sna.sna05a
            LET l_sna.sna07a = 0
         ELSE
            LET l_sna.sna06a = l_sna.sna06b
           #變更後欠料(sna07a)  = [單頭已發套數(sfb081a)*QPA(sna161b)]-
           #                       變更後已發數量(sna06a)
            LET l_sna.sna07a = g_sfb.sfb081 * l_sna.sna161b - l_sna.sna06a
            LET l_sna.sna07a = s_digqty(l_sna.sna07a,l_sna.sna12b)    #FUN-910088--add--
            LET l_sna.sna062a= 0
         END IF
      END IF
 
      #取替代料數量變更
      IF l_sfa.sfa26 MATCHES '[34US8Z]' THEN       #FUN-A20037 add '8,Z'
         IF l_sfa.sfa26 MATCHES '[348]' THEN       #FUN-A20037 add '8'
            LET l_sna.sna28a = 1
         ELSE
           #計算取替代比率
            SELECT bmd07 INTO l_sna.sna28a FROM bmd_file
              WHERE bmd01 = l_sfa.sfa03
                AND bmd04 = l_sfa.sfa27
                AND (bmd08=l_sfa.sfa29 OR bmd08='ALL')
                AND bmdacti = 'Y'                                           #CHI-910021
         END IF
         IF cl_null(l_sna.sna28a) THEN
            LET l_sna.sna28a = 1
         END IF
        #重計取替代料的新應發量(sna05a)
        #新應發量 = 比率 * 變更前的應發數量(sna05a)
         LET l_sna.sna05a = ( g_snb.snb08a / g_sfb.sfb08 ) * l_sna.sna05b
         LET l_sna.sna05a = s_digqty(l_sna.sna05a,l_sna.sna12b)    #FUN-910088--add--
 
        #重計取替代料的新已發數量(sna06a)，新超領量(sna062a)
        #IF 原已發量 > 新應發量 THEN
        #   新已發量 = 新應發量
        #   新超領量 = 原已發量-新應發量
        #ELSE
        #   新已發量 = 原已發量
        #   新超領量 = 0
        #END IF
 
         IF l_sna.sna05a < l_sfa.sfa06 THEN
            LET l_sna.sna06a = l_sna.sna05a
            LET l_sna.sna062a= l_sna.sna06b - l_sna.sna05a
         ELSE
            LET l_sna.sna06a = l_sna.sna06b
            LET l_sna.sna062a= 0
         END IF
      ELSE
         LET l_sna.sna28a = 1
      END IF
      INSERT INTO sna_file VALUES(l_sna.*)
      IF SQLCA.sqlcode THEN
#        CALL cl_err('g0_ins_sna',SQLCA.sqlcode,1)   #No.FUN-660128
         CALL cl_err3("ins","sna_file",l_sna.sna01,l_sna.sna02,SQLCA.sqlcode,"","g0_ins_sna",1)  #No.FUN-660128
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
    END FOREACH
    CLOSE t801_g0_cl
 
    FOREACH t801_g1_cl INTO s_sfa.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('t801_g1_cl',SQLCA.sqlcode,0)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      LET l_sum_sna05a = 0
      FOREACH t801_g2_cl USING g_snb.snb01,g_snb.snb02,s_sfa.sfa27
         INTO l_sna.*,l_sfa.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('t801_g2_cl',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH
        END IF
        IF l_sfa.sfa26 MATCHES '[34US8Z]' THEN   #FUN-A20037 add '8,Z'
          #計算變更後應發數量...............................................
           LET l_sna.sna05a = l_sna.sna05b * ( g_snb.snb08a / g_sfb.sfb08 )
           LET l_sna.sna05a = s_digqty(l_sna.sna05a,l_sna.sna12b)    #FUN-910088--add--
          #計算變更後已發/超領...............................................
          #變更後應發數量  > 已發數量
           IF l_sna.sna05a > l_sna.sna06b THEN
              LET l_sna.sna06a = l_sna.sna06b
           ELSE
              LET l_sna.sna06a = l_sna.sna05a
              LET l_sna.sna062a = l_sna.sna062b +
                                  (l_sna.sna06b - l_sna.sna05a)
           END IF
          #計算變更後欠料數量................................................
          #依原生產已發套數(sfb081)變更後之應發數量(l_sna05a)
           LET l_sna05a = g_sfb.sfb081 * ( l_sfa.sfa05 / s_sfa.sfa05 )*l_sna.sna161b
           LET l_sna05a = s_digqty(l_sna05a,l_sna.sna12b)        #FUN-910088--add--
          #變更後已發數量不足 --> 產生欠料
           IF l_sna05a > l_sna.sna06a THEN
             #new欠料量=變更後之應發量(l_sna05a) - 變更後之已發數量
              LET l_sna.sna07a = l_sna05a - l_sna.sna06a
           ELSE
              LET l_sna.sna07a = 0
           END IF
          #...................................................................
           UPDATE sna_file SET * = l_sna.*
            WHERE sna01 = l_sna.sna01
              AND sna02 = l_sna.sna02
              AND sna04 = l_sna.sna04
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#             CALL cl_err('g2_upd_sna',SQLCA.sqlcode,1)   #No.FUN-660128
              CALL cl_err3("upd","sna_file",l_sna.sna01,l_sna.sna02,SQLCA.sqlcode,"","g2_upd_sna",1)  #No.FUN-660128
              LET g_success = 'N'
           END IF
        END IF
        IF g_success = 'Y' THEN
           IF cl_null(l_sna.sna05a)  THEN LET l_sna.sna05a  = 0 END IF
           IF cl_null(l_sna.sna06a)  THEN LET l_sna.sna06a  = 0 END IF
           IF cl_null(l_sna.sna062a) THEN LET l_sna.sna062a = 0 END IF
           IF cl_null(l_sna.sna065a) THEN LET l_sna.sna065a = 0 END IF
           IF cl_null(l_sna.sna07a)  THEN LET l_sna.sna07a  = 0 END IF
           IF cl_null(l_sna.sna28a)  THEN LET l_sna.sna28a  = 1 END IF
           LET l_sfa.sfa05 = l_sna.sna05a
           LET l_sfa.sfa05 = s_digqty(l_sfa.sfa05,l_sfa.sfa12) #FUN-BB0083 add
           LET l_sfa.sfa06 = l_sna.sna06a
           LET l_sfa.sfa06 = s_digqty(l_sfa.sfa06,l_sfa.sfa12) #FUN-BB0083 add
           LET l_sfa.sfa062= l_sna.sna062a
           LET l_sfa.sfa062= s_digqty(l_sfa.sfa062,l_sfa.sfa12) #FUN-BB0083 add
           LET l_sfa.sfa065= l_sna.sna065a
           LET l_sfa.sfa07 = l_sna.sna07a
           LET l_sfa.sfa07 = s_digqty(l_sfa.sfa07,l_sfa.sfa12) #FUN-BB0083 add
           LET l_sfa.sfa28 = l_sna.sna28b
        error 'update-sfa',l_sfa.sfa03,' ',l_sfa.sfa05 USING '&&&',' ',
           l_sfa.sfa06 USING '&&&',' ',l_sfa.sfa062 USING '&&&',' ',
           l_sfa.sfa07 USING '&&&'
           UPDATE sfa_file SET * = l_sfa.*
            WHERE sfa01 = l_sfa.sfa01
              AND sfa03 = l_sfa.sfa03
              AND sfa08 = l_sfa.sfa08
              AND sfa12 = l_sfa.sfa12
              AND sfa27 = l_sfa.sfa27      #No.FUN-870051
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#             CALL cl_err('g1_upd_sfa',SQLCA.sqlcode,1)   #No.FUN-660128
              CALL cl_err3("upd","sfa_file",l_sfa.sfa01,l_sfa.sfa03,SQLCA.sqlcode,"","g1_upd_sfa",1)  #No.FUN-660128
              LET g_success = 'N'
           END IF
        END IF
      END FOREACH
    END FOREACH
 
END FUNCTION
 
FUNCTION t801_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("snb01",TRUE)
   END IF
END FUNCTION
 
FUNCTION t801_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("snb01",FALSE)
   END IF
END FUNCTION
 
#------------------No.MOD-740003 add
FUNCTION t801_sna05a(p_sfa03,p_sfa05,p_sfa12)
   DEFINE l_ima64       LIKE ima_file.ima64,
          l_ima641      LIKE ima_file.ima641,
          l_double      LIKE type_file.num5, 
          l_gfe03       LIKE gfe_file.gfe03,
          p_sfa03       LIKE sfa_file.sfa03,
          p_sfa05       LIKE sfa_file.sfa05,
          p_sfa12       LIKE sfa_file.sfa12
 
   LET g_errno = ' '
   SELECT ima64,ima641 INTO l_ima64,l_ima641 FROM ima_file
    WHERE ima01=p_sfa03
   IF STATUS THEN LET l_ima64 = 0 LET l_ima641 = 0 END IF
   #check最少發料數量
   IF l_ima641 <>  0 AND p_sfa05 < l_ima641 THEN
      LET p_sfa05=l_ima641
   END IF
   IF l_ima64!=0 THEN
       LET l_double=(p_sfa05/l_ima64)+ 0.999999
       LET p_sfa05=l_double*l_ima64
   END IF
   #-->考慮單位小數取位
   SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = p_sfa12
   IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
   CALL cl_digcut(p_sfa05,l_gfe03) RETURNING p_sfa05
   RETURN p_sfa05
END FUNCTION
#------------------No.MOD-740003 end

#TQC-C50088--add--str--
FUNCTION t801_time(p_cmd)

DEFINE p_cmd      LIKE type_file.chr1  #'1'代表推算預計完工日
                                       #'2'代表推算預計開工日
DEFINE l_ima59    LIKE ima_file.ima59
DEFINE l_ima60    LIKE ima_file.ima60
DEFINE l_ima601   LIKE ima_file.ima601
DEFINE l_ima61    LIKE ima_file.ima61
DEFINE l_time     LIKE sfb_file.sfb13
DEFINE l_sfb15     LIKE sfb_file.sfb15
DEFINE li_result  LIKE type_file.num5
DEFINE l_day      LIKE type_file.num5
DEFINE l_ima56    LIKE ima_file.ima56


   SELECT ima59,ima60,ima601,ima61,ima56 INTO l_ima59,l_ima60,l_ima601,l_ima61,l_ima56
      FROM ima_file WHERE ima01=g_sfb05

   IF p_cmd = '1' THEN
      IF NOT cl_null(g_snb.snb13a) THEN
         LET l_time = g_snb.snb13a     #sfb13
      ELSE
         LET l_time = g_snb.snb13b     #sfb13
      END IF
       LET l_day = (l_ima59+l_ima60/l_ima601*g_snb.snb08a+l_ima61)
      WHILE TRUE
         LET li_result = 0
         CALL s_daywk(l_time) RETURNING li_result
         CASE
           WHEN li_result = 0  #0:非工作日
             LET l_time = l_time + 1
             CONTINUE WHILE
           WHEN li_result = 1  #1:工作日
             EXIT WHILE
           WHEN li_result = 2  #2:無設定
             CALL cl_err(l_time,'mfg3153',0)
             EXIT WHILE
           OTHERWISE EXIT WHILE
         END CASE
      END WHILE
      LET l_sfb15 = l_time
      CALL s_aday(l_sfb15,1,l_day) RETURNING l_sfb15
      #變更後的資料與變更前資料相同則清空
      IF g_snb.snb15b = l_sfb15 THEN
         CALL cl_err('','asf-423',0)
         LET l_sfb15 = NULL
      END IF
      RETURN l_sfb15
   ELSE
      IF NOT cl_null(g_snb.snb15a) THEN
         LET l_time = g_snb.snb15a   #sfb15
      ELSE
         LET l_time = g_snb.snb15b   #sfb15
      END IF
      #LET l_day = (l_ima59+l_ima60/l_ima601*g_sfb.sfb08+l_ima61)
      LET l_day = (l_ima59+l_ima60/l_ima601*g_snb.snb08b+l_ima61)

      WHILE TRUE
         LET li_result = 0
         CALL s_daywk(l_time) RETURNING li_result
         CASE
           WHEN li_result = 0  #0:非工作日
             LET l_time = l_time + 1
             CONTINUE WHILE
           WHEN li_result = 1  #1:工作日
             EXIT WHILE 
           WHEN li_result = 2  #2:無設定
             CALL cl_err(l_time,'mfg3153',0)
             EXIT WHILE
           OTHERWISE EXIT WHILE
         END CASE 
      END WHILE
      LET l_sfb15 = l_time
      CALL s_aday(l_sfb15,-1,l_day) RETURNING l_sfb15
      #變更後的資料與變更前資料相同則清空
      IF g_snb.snb13b = l_sfb15 THEN
         CALL cl_err('','asf-423',0)
         LET l_sfb15 = NULL
      END IF
      RETURN l_sfb15
   END IF 
      
END FUNCTION

#TQC-C50088--add--end--

#Patch....NO.TQC-610037 <001> #

