# Prog. Version..: '5.30.06-13.03.29(00010)'     #
#
# Pattern name...: axms100.4gl
# Descriptions...: 銷售系統參數(一)設定作業連線參數
# Date & Author..: 94/12/12 By Nick
# Modify.........: 04/04/01 Kammy Genero axms010/axms020/axms050/axms060 結合
# Modify.........: 04/12/22 Melody 加入 oaz63的輸入
# Modify.........: No.MOD-570192 05/08/04 By Nicola 加入oza43的輸入
# Modify.........: No.FUN-5C0075 05/12/19 By Tracy 新增欄位oaz23(成品替代否）,oaz42（成品替代方式）
# Modify.........: No.FUN-610020 06/01/10 By Carrier 出貨驗收功能 -- 新增oaz74/oaz75/oaz76/oaz77
# Modify.........: No.FUN-630006 06/03/03 By Nicola 新增欄位oaz19(是否做訂單生產工廠分配)
# Modify.........: No.FUN-640012 06/04/06 By kim GP3.0 匯率參數功能改善
# Modify.........: No.FUN-640025 06/04/08 By Nicola 取消欄位oaz19
# Modify.........: NO.FUN-640252 06/04/23 BY yiting 取消oaz08 
# Modify.........: NO.TQC-640134 06/05/25 BY yiting 增加oaz19
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/11 By bnlent 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time
# Modify.........: NO.FUN-650101 06/12/04 by kim 輸入在途倉時,必須為'非MRP',且需為'成本倉'
# Modify.........: No.CHI-6B0027 07/02/14 By jamie oaz101改為nouse 相關程式移除
# Modify.........: No.FUN-740016 07/04/12 By Nicola 新增欄位oaz78
# Modify.........: NO.CHI-780041 07/08/27 BY yiting add oaz79
# Modify.........: NO.MOD-7A0001 07/10/01 BY claire 儲位NULL時要寫入' '
# Modify.........: No.TQC-7C0091 07/12/08 by zy 訂單缺省容許超交率控管不可小于0
# Modify.........: No.TQC-7C0091 07/12/08 by zy 低價比率控管0至100之間
# Modify.........: NO.TQC-7C0105 07/12/08 by fangyan 修改錯誤提示信息
# Modify.........: No.FUN-820033 08/02/22 By Judy 新增返利參數page
# Modify.........: NO.CHI-840010 08/04/15 by Carol 包裝單在多單位的狀況回寫出貨單='N'
# Modify.........: NO.FUN-850120 08/05/21 by rainy 新增oaz81收貨�出通單是否做批�序號管理
# Modify.........: No.FUN-930164 09/04/15 By jamie update oaz52、oaz70成功時，寫入azo_file
# Modify.........: No.FUN-870100 09/08/04 By Cockroach 零售超市移植
# Modify.........: No.FUN-980010 09/08/21 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10012 10/01/05 By destiny流通零售for業態管控     
# Modify.........: No.FUN-A70130 10/08/12 By huangtao 修改開窗q_oay6 
# Modify.........: No:TQC-960213 10/11/09 By sabrina _u()段中按放棄時並沒有做COMMIT WORK或ROLLBACK WORK導致沒有CLOSE TRANSACTION 
# Modify.........: NO:CHI-AB0032 10/11/30 by Summer 借出客戶倉庫時,控卡為不可用倉
# Modify.........: No:FUN-AC0012 10/12/07 By shiwuying oaz80单据性质更改
# Modify.........: No:MOD-B30292 11/03/12 By Summer 修改axm-666該訊息控卡的地方改為WIP倉 
# Modify.........: No:FUN-B30012 11/03/29 By huangtao 新增字段理由碼oaz88
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B50011 11/05/04 By shiwuying 增加oaz89/oaz90/oaz91
# Modify.........: No:CHI-BB0055 12/02/10 By Vampire 調整AFTER FIELD oaz78的mfg1100的錯誤訊息
# Modify.........: No:FUN-C50025 12/05/14 By yinhy 發出商品管理,增加oaz92/oaz93/oaz94/oaz95
# Modify.........: No:MOD-C50085 12/06/15 By Vampire 增加imd11='N'的條件,只撈出可用倉
# Modify.........: No:FUN-C60033 12/06/26 By minpp 1.oaz92='N'时，发票仓隐藏2.oaz93=Y时，oaz95改为NULL 还有oaz92=N时，oaz93改为N,OAZ95改为null 
# Modify.........: No:FUN-C50136 12/07/06 By chenjing  增加信用管控參數設置
# Modify.........: No:FUN-C60036 12/07/17 By xuxz 發票倉欄位控管不能在jce_file中,添加oaz97,oaz98,oaz100,oaz106
#                                             出貨簽收沒有過單，所以講axms100中oaz94隱藏
# Modify.........: No:FUN-C50097 12/08/02 By SunLM 顯示oaz94
# Modify.........: No:MOD-C80207 12/09/20 By SunLM axms100在途倉，應不能輸入非成本倉
# Modify.........: No:FUN-C80094 12/08/27 By By xuxz 發出商品 
# Modify.........: No:FUN-CA0084 12/10/09 By minpp 将oaz92设置为N时，oaz95栏位应被隐藏
# Modify.........: No:MOD-CB0081 12/11/08 By SunLM 當oza93從Y改為N時，需判斷發票倉內無庫存，否則不允許修改此參數
# Modify.........: No.FUN-CB0052 12/11/15 By xianghui 發票倉庫控管改善
# Modify.........: No:FUN-C30124 13/01/22 By pauline 新增“訂單輸入料號時，新增檢驗資料”oaz108參數
# Modify.........: No.TQC-D20009 12/02/06 By fengrui 修正MOD-CB0081單中的問題
# Modify.........: No.TQC-D20046 13/02/25 By chenjing 修改發票倉有庫存時，發票倉不能修改問題
# Modify.........: No:MOD-D60159 13/06/17 By SunLM 勾選oaz100(審核立即轉應收)，則必須勾選oaz106(審核立即過賬),否則不過賬也是立不了應收
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
# Modify.........: No:TQC-D50127 13/05/30 By lixh1 儲位為空則給空格
# Modify.........: No:TQC-D50126 13/06/06 By lixh1 儲位為空則給空格修正
# Modify.........: No:FUN-D60055 13/06/13 By fengrui oaz92添加控管:如果有收貨單或者銷退單未立賬,不可以由N改為Y
# Modify.........: No.MOD-DB0084 13/11/13 By SunLM 在勾選立賬方式走開票流程時，檢查oga_file是否有未立賬單據時不應當檢查出通單


DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE
        g_oaz_t         RECORD LIKE oaz_file.*,  # 預留參數檔
        g_oaz_o         RECORD LIKE oaz_file.*   # 預留參數檔
DEFINE g_before_input_done   STRING              # No.FUN-5C0075 
DEFINE g_forupd_sql     STRING
DEFINE g_i              SMALLINT   #FUN-820033
DEFINE g_msg               LIKE type_file.chr1000 #FUN-930164 add
DEFINE g_flag_52           LIKE type_file.chr1    #FUN-930164 add
DEFINE g_flag_70           LIKE type_file.chr1    #FUN-930164 add
 
MAIN
#    DEFINE l_time      LIKE type_file.chr8    #No.FUN-680137 VARCHAR(8) #NO.FUN-6A0094
    DEFINE p_row,p_col LIKE type_file.num5    #No.FUN-680137 SMALLINT
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
    LET p_row = 4 LET p_col = 18
 
    OPEN WINDOW s100_w AT p_row,p_col WITH FORM "axm/42f/axms100" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
  #FUN-820033 --start--
   IF g_aza.aza50 != 'Y' THEN
      CALL cl_set_comp_visible("page05",FALSE)
   END IF
  #FUN-820033 --end--
   #No.FUN-870100 --begin--
   IF g_azw.azw04 <> '2' THEN                    
#     CALL cl_set_comp_visible('Page6',FALSE)       #No.FUN-A10012
      CALL cl_set_comp_visible('Page06',FALSE)      #No.FUN-A10012
   ELSE 
      CALL cl_set_comp_visible('Page06',TRUE)      #No.FUN-A10012
   END IF                                          
   #No.FUN-870100 --end--    
    CALL cl_set_comp_visible('oaz89',FALSE) #FUN-B50011
    #No.FUN-C50025  --Begin
    IF g_aza.aza26 <> '2' THEN
    	CALL cl_set_comp_visible("oaz92,oaz93,oaz94,oaz95",FALSE)
        CALL cl_set_comp_visible('Group2,group28',FALSE)                    #FUN-C60033
    END IF 
    #No.FUN-C50025  --End
#wujie 130615 --begin
#   #FUN-C80094  add--str
#   IF g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN
#      CALL cl_set_comp_entry("oaz107",TRUE)
#   ELSE
#      CALL cl_set_comp_entry("oaz107",FALSE)
#   END IF
#   #FUN-C80094 add--end
    IF g_oaz.oaz92 = 'Y' THEN
       CALL cl_set_comp_entry("oaz107",TRUE)
    ELSE
       CALL cl_set_comp_entry("oaz107",FALSE)
    END IF
#wujie 130615 --end   
   # CALL cl_set_comp_visible('group28',FALSE) #FUN-C60036 add by xuxz 出貨簽收沒有過單故將oaz94隱藏 FUN-C50097
    CALL s100_show()
    WHILE TRUE
       LET g_action_choice = ""
       CALL s100_menu()
       IF g_action_choice = "exit" THEN
          EXIT WHILE
       END IF
    END WHILE
    CLOSE WINDOW s100_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION s100_show()
    LET g_oaz_t.* = g_oaz.*
    LET g_oaz_o.* = g_oaz.*
    DISPLAY BY NAME g_oaz.oaz01,g_oaz.oaz02,g_oaz.oaz02p,g_oaz.oaz02b,
                    g_oaz.oaz03,g_oaz.oaz04,g_oaz.oaz05,g_oaz.oaz06,
                    g_oaz.oaz102,g_oaz.oaz103,g_oaz.oaz104,              #CHI-6B0027 mod 
                   #g_oaz.oaz101,g_oaz.oaz102,g_oaz.oaz103,g_oaz.oaz104, #CHI-6B0027 mark
                    g_oaz.oaz09,g_oaz.oaz11,g_oaz.oaz121,g_oaz.oaz122,
                    g_oaz.oaz131,g_oaz.oaz132,g_oaz.oaz141,g_oaz.oaz142,
                    g_oaz.oaz211,g_oaz.oaz212,g_oaz.oaz41,g_oaz.oaz46,
                    #g_oaz.oaz44,g_oaz.oaz43,#g_oaz.oaz19,   #No.MOD-570192  #No.FUN-630006 #No.FUN-640025
                    g_oaz.oaz44,g_oaz.oaz43,g_oaz.oaz19,g_oaz.oaz108,   #No.MOD-570192  #No.FUN-630006 #No.FUN-640025 #NO.TQC-640134  #FUN-C30124 add oaz108
                    g_oaz.oaz681,g_oaz.oaz682, g_oaz.oaz25 ,g_oaz.oaz201,
                    #g_oaz.oaz08 ,g_oaz.oaz184,g_oaz.oaz185,  #NO.FUN-640252
                    g_oaz.oaz184,g_oaz.oaz185,
                    g_oaz.oaz52 ,g_oaz.oaz70,
                    g_oaz.oaz65,g_oaz.oaz66,g_oaz.oaz71,g_oaz.oaz61,
                    #g_oaz.oaz23,g_oaz.oaz42,g_oaz.oaz78,   #No.FUN-740016    #No.FUN-5C0075     
                    g_oaz.oaz23,g_oaz.oaz42,g_oaz.oaz79,g_oaz.oaz78,   #No.FUN-740016    #No.FUN-5C0075      #NO.CHI-780041
                    g_oaz.oaz74,g_oaz.oaz75,g_oaz.oaz76,g_oaz.oaz77, #No.FUN-610020     
                    g_oaz.oaz67,g_oaz.oaz81,g_oaz.oaz22,g_oaz.oaz62,g_oaz.oaz63,g_oaz.oaz64, #MOD-4C0136  #FUN-850120 add oaz81
                    g_oaz.oaz691,g_oaz.oaz692,g_oaz.oaz80  #FUN-820033 add oaz80
                    ,g_oaz.oaz83,g_oaz.oaz84,g_oaz.oaz85,g_oaz.oaz86,g_oaz.oaz87     #FUN-870100
                   #,g_oaz.oaz88                           #FUN-B30012 add #FUN-B50011
                    ,g_oaz.oaz89,g_oaz.oaz88,g_oaz.oaz90,g_oaz.oaz91       #FUN-B50011
                    ,g_oaz.oaz92,g_oaz.oaz93,g_oaz.oaz107,g_oaz.oaz94,g_oaz.oaz95       #FUN-C50025#FUN-C80094 add g_oaz.oaz107
                #   ,g_oaz.oaz96                                           #FUN-C50136
                    ,g_oaz.oaz97,g_oaz.oaz98,g_oaz.oaz100,g_oaz.oaz106 #FUN-C60036 add
    #FUN-CA0084--add--str
     IF g_oaz.oaz92='N' THEN
        CALL cl_set_comp_visible("oaz95",FALSE)
     END IF
    #FUN-CA0084--add--end
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

END FUNCTION
 
FUNCTION s100_menu()
    MENU ""
       ON ACTION modify 
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL s100_u()
           END IF
       ON ACTION reopen 
          LET g_action_choice="reopen"  
          IF cl_chk_act_auth() THEN
             CALL s100_y()
          END IF
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          #EXIT MENU
       ON ACTION help 
          CALL cl_show_help()
       ON ACTION exit
          LET g_action_choice = "exit"
          EXIT MENU
       ON ACTION controlg
          CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
    
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
          LET g_action_choice = "exit"
          EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION s100_u()
 
    IF s_axmshut(0) THEN RETURN END IF
    CALL cl_opmsg('u')
    MESSAGE ""
 
    LET g_forupd_sql = "SELECT * FROM oaz_file WHERE oaz00 = ? ",
                         " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE oaz_curl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
 
    OPEN oaz_curl USING '0'
    IF STATUS THEN
       CALL cl_err('',STATUS,1)
       ROLLBACK WORK         #TQC-960213 add
       RETURN
    END IF
 
    FETCH oaz_curl INTO g_oaz.*
    IF STATUS THEN
       CALL cl_err('',STATUS,1)
       ROLLBACK WORK         #TQC-960213 add
       RETURN
    END IF
 
    WHILE TRUE
        CALL s100_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CALL cl_err('',9001,0)
           LET g_oaz.* = g_oaz_t.* CALL s100_show()
           ROLLBACK WORK         #TQC-960213 add
           EXIT WHILE
        END IF
        IF cl_null(g_oaz.oaz77) THEN LET g_oaz.oaz77=' ' END IF  #MOD-7A0001        
        IF cl_null(g_oaz.oaz75) THEN LET g_oaz.oaz75=' ' END IF  #MOD-7A0001
        UPDATE oaz_file SET * = g_oaz.* WHERE oaz00='0'
        IF STATUS THEN CALL cl_err('',STATUS,0) CONTINUE WHILE
       #FUN-930164---add---str---
        ELSE 
           IF g_flag_52='Y' THEN 
              LET g_errno = TIME
              LET g_msg = 'old:',g_oaz_t.oaz52,' new:',g_oaz.oaz52
              INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980019 add plant & legal 
                 VALUES ('axms100',g_user,g_today,g_errno,'oaz52',g_msg,g_plant,g_legal)
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","azo_file","axms100","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 CONTINUE WHILE
              END IF
           END IF 
           IF g_flag_70='Y' THEN 
              LET g_errno = TIME
              LET g_msg = 'old:',g_oaz_t.oaz70,' new:',g_oaz.oaz70
              INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)   #FUN-980010 add plant & legal
                 VALUES ('axms100',g_user,g_today,g_errno,'oaz70',g_msg,g_plant,g_legal)
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","azo_file","axms100","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 CONTINUE WHILE
              END IF
           END IF 
       #FUN-930164---add---end---
          END IF
        CLOSE oaz_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s100_i()
    DEFINE l_aza LIKE type_file.chr1   #No.FUN-680137 VARCHAR(01)
    DEFINE l_imd RECORD LIKE imd_file.* #FUN-650101
    DEFINE li_result  LIKE type_file.num5   #CHI-780041 
    DEFINE g_t1       LIKE sma_file.sma123  #CHI-780041
    DEFINE l_n        LIKE type_file.num5   #FUN-870100
    DEFINE l_img10    LIKE img_file.img10   #MOD-CB0081 add
    
    IF cl_null(g_oaz.oaz89) THEN LET g_oaz.oaz89 = '1' END IF #FUN-B50011
    #FUN-C60033---ADD---STR
    IF g_oaz.oaz92='Y' AND g_oaz.oaz93='Y' THEN
       CALL cl_set_comp_entry("oaz95",TRUE)
    ELSE
       CALL cl_set_comp_entry("oaz95",FALSE)
    END IF
    #FUN-C60033--ADD--END

    #FUN-C60036--add--str
    IF g_oaz.oaz92='Y' THEN 
       CALL cl_set_comp_entry("oaz97,oaz98,oaz100",TRUE)
       IF g_oaz.oaz93 = 'Y' THEN
          CALL cl_set_comp_entry("oaz106",TRUE)
       ELSE
          CALL cl_set_comp_entry("oaz106",FALSE)
       END IF
    ELSE
       CALL cl_set_comp_entry("oaz97,oaz98,oaz100",FALSE)
    END IF 
    IF cl_null(g_oaz.oaz100) THEN LET g_oaz.oaz100  ='N' END IF
    IF cl_null(g_oaz.oaz106) THEN LET g_oaz.oaz106 = 'N' END IF
    #FUN-C60036--add--end
    LET g_oaz_t.* = g_oaz.*        #FUN-B30012 add
    INPUT BY NAME g_oaz.oaz01,g_oaz.oaz02,g_oaz.oaz02p,g_oaz.oaz02b,
                  g_oaz.oaz03,g_oaz.oaz04,g_oaz.oaz05,g_oaz.oaz06,
                  g_oaz.oaz102,g_oaz.oaz103,g_oaz.oaz104,               #CHI-6B0027 mod
                 #g_oaz.oaz101,g_oaz.oaz102,g_oaz.oaz103,g_oaz.oaz104,  #CHI-6B0027 mark
                  g_oaz.oaz09,g_oaz.oaz11,g_oaz.oaz121,g_oaz.oaz122,
                # g_oaz.oaz131,g_oaz.oaz132,g_oaz.oaz96,g_oaz.oaz141,g_oaz.oaz142,     #FUN-C50136--add
                  g_oaz.oaz131,g_oaz.oaz132,g_oaz.oaz141,g_oaz.oaz142,     #FUN-C50136--add
                  g_oaz.oaz211,g_oaz.oaz212,g_oaz.oaz41,g_oaz.oaz46,
                  #g_oaz.oaz44,g_oaz.oaz43,#g_oaz.oaz19,   #No.MOD-570192  #No.FUN-630006 #No.FUN-640025
                  g_oaz.oaz44,g_oaz.oaz43,g_oaz.oaz19,g_oaz.oaz108,   #No.MOD-570192  #No.FUN-630006 #No.FUN-640025   #NO.TQC-640134  #FUN-C30124 add oaz108
                  g_oaz.oaz681,g_oaz.oaz682, g_oaz.oaz25 ,g_oaz.oaz201,
                  #g_oaz.oaz08 ,g_oaz.oaz184,g_oaz.oaz185,  #NO.FUN-640252
                  g_oaz.oaz184,g_oaz.oaz185,
                  g_oaz.oaz52 ,g_oaz.oaz70,
                  g_oaz.oaz65,g_oaz.oaz66,g_oaz.oaz71,g_oaz.oaz61,
                  #g_oaz.oaz23,g_oaz.oaz78,g_oaz.oaz42,    #No.FUN-5C0075        #No.FUN-740016
                  g_oaz.oaz78,g_oaz.oaz79,g_oaz.oaz23,g_oaz.oaz42,    #No.FUN-5C0075        #No.FUN-740016  #NO.CHI-780041
                  g_oaz.oaz74,g_oaz.oaz75,g_oaz.oaz76,g_oaz.oaz77, #No.FUN-610020     
                  g_oaz.oaz67,g_oaz.oaz81,g_oaz.oaz22,g_oaz.oaz62,g_oaz.oaz63,g_oaz.oaz64, #MOD-4C0136   #FUN-850120 add oaz81
                  g_oaz.oaz691,g_oaz.oaz692,g_oaz.oaz80  #FUN-820033 add oaz80
                 ,g_oaz.oaz83,g_oaz.oaz84,g_oaz.oaz85,g_oaz.oaz86,g_oaz.oaz87     #FUN-870100
                #,g_oaz.oaz88                           #FUN-B30012 add #FUN-B50011
                 ,g_oaz.oaz89,g_oaz.oaz88,g_oaz.oaz90,g_oaz.oaz91       #FUN-B50011
                #,g_oaz.oaz92,g_oaz.oaz93,g_oaz.oaz94,g_oaz.oaz95       #FUN-C50025   #FUN-C60033 mark
                 ,g_oaz.oaz94,g_oaz.oaz92,g_oaz.oaz93,g_oaz.oaz107,g_oaz.oaz95       #FUN-C60033#FUN-C80094 add oaz107
                 ,g_oaz.oaz97,g_oaz.oaz98,g_oaz.oaz100,g_oaz.oaz106     #FUN-C60036
        WITHOUT DEFAULTS
 
#No.FUN-5C0075  --start--   
    BEFORE INPUT                                                                                                                    
        LET g_before_input_done = FALSE                                                                                             
        CALL s100_set_entry()                                                                                                       
        CALL s100_set_no_entry()                                                                                                    
        LET g_before_input_done = TRUE                                                                                              
        LET g_flag_52='N'     #FUN-930164 add
        LET g_flag_70='N'     #FUN-930164 add
#No.FUN-5C0075  --end--   
                                                                
    AFTER FIELD oaz01
       IF g_oaz.oaz01 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz01) THEN
          LET g_oaz.oaz01=g_oaz_o.oaz01
          DISPLAY BY NAME g_oaz.oaz01
          NEXT FIELD oaz01
       END IF
       LET g_oaz_o.oaz01=g_oaz.oaz01
 
    AFTER FIELD oaz02
       IF g_oaz.oaz02 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz02) THEN
          LET g_oaz.oaz02=g_oaz_o.oaz02
          DISPLAY BY NAME g_oaz.oaz02
          NEXT FIELD oaz02
       END IF
       LET g_oaz_o.oaz02=g_oaz.oaz02
 
    AFTER FIELD oaz02p
       IF cl_null(g_oaz.oaz02p) THEN
          LET g_oaz.oaz02p=g_oaz_o.oaz02p
          DISPLAY BY NAME g_oaz.oaz02p
          NEXT FIELD oaz02p
       END IF
       LET g_oaz_o.oaz02p=g_oaz.oaz02p
 
    AFTER FIELD oaz02b
       IF cl_null(g_oaz.oaz02b) THEN
          LET g_oaz.oaz02b=g_oaz_o.oaz02b
          DISPLAY BY NAME g_oaz.oaz02b
          NEXT FIELD oaz02b
       END IF
       LET g_oaz_o.oaz02b=g_oaz.oaz02b
 
    AFTER FIELD oaz03
       IF g_oaz.oaz03 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz03) THEN
          LET g_oaz.oaz03=g_oaz_o.oaz03
          DISPLAY BY NAME g_oaz.oaz03
          NEXT FIELD oaz03
       END IF
       LET g_oaz_o.oaz03=g_oaz.oaz03
 
    AFTER FIELD oaz04
       IF g_oaz.oaz04 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz04) THEN
          LET g_oaz.oaz04=g_oaz_o.oaz04
          DISPLAY BY NAME g_oaz.oaz04
          NEXT FIELD oaz04
       END IF
       LET g_oaz_o.oaz04=g_oaz.oaz04
 
    AFTER FIELD oaz05
       IF g_oaz.oaz05 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz05) THEN
          LET g_oaz.oaz05=g_oaz_o.oaz05
          DISPLAY BY NAME g_oaz.oaz05
          NEXT FIELD oaz05
       END IF
       LET g_oaz_o.oaz05=g_oaz.oaz05
 
    AFTER FIELD oaz06
       IF g_oaz.oaz06 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz06) THEN
          LET g_oaz.oaz06=g_oaz_o.oaz06
          DISPLAY BY NAME g_oaz.oaz06
          NEXT FIELD oaz06
       END IF
       LET g_oaz_o.oaz06=g_oaz.oaz06
 
    AFTER FIELD oaz09
       IF cl_null(g_oaz.oaz09) THEN
          LET g_oaz.oaz09=g_today
          DISPLAY BY NAME g_oaz.oaz09
          NEXT FIELD oaz09
       END IF
       LET g_oaz_o.oaz09=g_oaz.oaz09
 
   #CHI-6B0027---mark---str---
   #AFTER FIELD oaz101
   #   IF g_oaz.oaz101 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz101) THEN
   #      LET g_oaz.oaz101=g_oaz_o.oaz101
   #      DISPLAY BY NAME g_oaz.oaz101
   #      NEXT FIELD oaz101
   #   END IF
   #   LET g_oaz_o.oaz101=g_oaz.oaz101
   #CHI-6B0027---mark---end---
 
    AFTER FIELD oaz102
       IF g_oaz.oaz102 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz102) THEN
          LET g_oaz.oaz102=g_oaz_o.oaz102
          DISPLAY BY NAME g_oaz.oaz102
          NEXT FIELD oaz102
       END IF
       LET g_oaz_o.oaz102=g_oaz.oaz102
 
    AFTER FIELD oaz103
       IF g_oaz.oaz103 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz103) THEN
          LET g_oaz.oaz103=g_oaz_o.oaz103
          DISPLAY BY NAME g_oaz.oaz103
          NEXT FIELD oaz103
       END IF
       LET g_oaz_o.oaz103=g_oaz.oaz103
 
    AFTER FIELD oaz104
       IF g_oaz.oaz104 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz104) THEN
          LET g_oaz.oaz104=g_oaz_o.oaz104
          DISPLAY BY NAME g_oaz.oaz104
          NEXT FIELD oaz104
       END IF
       LET g_oaz_o.oaz104=g_oaz.oaz104
 
    AFTER FIELD oaz11
       IF cl_null(g_oaz.oaz11) THEN
          LET g_oaz.oaz11=g_oaz_o.oaz11
          DISPLAY BY NAME g_oaz.oaz11
          NEXT FIELD oaz11
       ELSE
          SELECT oak02 FROM oak_file WHERE oak01=g_oaz.oaz11 AND oak03='1'
          IF STATUS THEN
#              CALL cl_err(g_oaz.oaz11,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("sel","oak_file",g_oaz.oaz11,"",SQLCA.sqlcode,"","",0)   #No.FUN-660167
               LET g_oaz.oaz11=g_oaz_o.oaz11
               DISPLAY BY NAME g_oaz.oaz11
               NEXT FIELD oaz11
          END IF
       END IF
       LET g_oaz_o.oaz11=g_oaz.oaz11
 
    AFTER FIELD oaz121
       IF g_oaz.oaz121 NOT MATCHES '[0-1]' OR cl_null(g_oaz.oaz121) THEN
          LET g_oaz.oaz121=g_oaz_o.oaz121
          DISPLAY BY NAME g_oaz.oaz121
          NEXT FIELD oaz121
       END IF
       LET g_oaz_o.oaz121=g_oaz.oaz121
 
    AFTER FIELD oaz122
       IF g_oaz.oaz122 NOT MATCHES '[0-2]' OR cl_null(g_oaz.oaz122) THEN
          LET g_oaz.oaz122=g_oaz_o.oaz122
          DISPLAY BY NAME g_oaz.oaz122
          NEXT FIELD oaz122
       END IF
       LET g_oaz_o.oaz122=g_oaz.oaz122
 
    AFTER FIELD oaz131
       IF g_oaz.oaz131 NOT MATCHES '[0-1]' OR cl_null(g_oaz.oaz131) THEN
          LET g_oaz.oaz131=g_oaz_o.oaz131
          DISPLAY BY NAME g_oaz.oaz131
          NEXT FIELD oaz131
       END IF
       LET g_oaz_o.oaz131=g_oaz.oaz131
 
    AFTER FIELD oaz132
       IF g_oaz.oaz132 NOT MATCHES '[012]' OR cl_null(g_oaz.oaz132) THEN
          LET g_oaz.oaz132=g_oaz_o.oaz132
          DISPLAY BY NAME g_oaz.oaz132
          NEXT FIELD oaz132
       END IF
       LET g_oaz_o.oaz132=g_oaz.oaz132
 
    AFTER FIELD oaz141
       IF g_oaz.oaz141 NOT MATCHES '[0-1]' OR cl_null(g_oaz.oaz141) THEN
          LET g_oaz.oaz141=g_oaz_o.oaz141
          DISPLAY BY NAME g_oaz.oaz141
          NEXT FIELD oaz141
       END IF
       LET g_oaz_o.oaz141=g_oaz.oaz141
 
    AFTER FIELD oaz142
       IF g_oaz.oaz142 NOT MATCHES '[012]' OR cl_null(g_oaz.oaz142) THEN
          LET g_oaz.oaz142=g_oaz_o.oaz142
          DISPLAY BY NAME g_oaz.oaz142
          NEXT FIELD oaz142
       END IF
       LET g_oaz_o.oaz142=g_oaz.oaz142
 
    AFTER FIELD oaz211
       IF g_oaz.oaz211 NOT MATCHES '[12]' OR cl_null(g_oaz.oaz211) THEN
          LET g_oaz.oaz211=g_oaz_o.oaz211
          DISPLAY BY NAME g_oaz.oaz211
          NEXT FIELD oaz211
       END IF
       LET g_oaz_o.oaz211=g_oaz.oaz211
 
    AFTER FIELD oaz212
       IF g_oaz.oaz212 NOT MATCHES '[BSMCD]' OR cl_null(g_oaz.oaz212) THEN #FUN-640012 del 'P'
          LET g_oaz.oaz212=g_oaz_o.oaz212
          DISPLAY BY NAME g_oaz.oaz212
          NEXT FIELD oaz212
       END IF
       LET g_oaz_o.oaz212=g_oaz.oaz212
 
#No.FUN-5C0075  --start-- 
    AFTER FIELD oaz23
       IF g_oaz.oaz23 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz23) THEN
          LET g_oaz.oaz23=g_oaz_o.oaz23
          DISPLAY BY NAME g_oaz.oaz23
          NEXT FIELD oaz23
       END IF
       LET g_oaz_o.oaz23=g_oaz.oaz23
 
    ON CHANGE oaz23
       CALL s100_set_entry()                                                                                                        
       CALL s100_set_no_entry()             
 
    AFTER FIELD oaz42
       IF g_oaz.oaz42 NOT MATCHES '[12]' OR cl_null(g_oaz.oaz42) THEN
          LET g_oaz.oaz42=g_oaz_o.oaz42
          DISPLAY BY NAME g_oaz.oaz42
          NEXT FIELD oaz42
       END IF
       LET g_oaz_o.oaz42=g_oaz.oaz42
#No.FUN-5C0075  --end--
 
    #-----No.FUN-740016-----
    AFTER FIELD oaz78                                                       
       IF g_oaz.oaz78 !=' ' AND g_oaz.oaz78 IS NOT NULL THEN
          SELECT * INTO l_imd.* FROM imd_file
           WHERE imd01=g_oaz.oaz78 AND imdacti='Y'
             AND imd11='N' #CHI-AB0032 add
          IF SQLCA.SQLCODE THEN                                            
             #CALL cl_err3("sel","imd_file",g_oaz.oaz78,"",'mfg1100',"","",0) #CHI-BB0055 mark
             CALL cl_err3("sel","imd_file",g_oaz.oaz78,"",'mfg1114',"","",0)  #CHI-BB0055 add
             NEXT FIELD oaz78
          END IF                                                           
          #FUN-CB0052--add--str--
          IF l_imd.imd10 MATCHES '[Ii]' THEN 
             CALL cl_err(l_imd.imd10,'axm-693',0)
             NEXT FIELD oaz78
          END IF
          #FUN-CB0052--add--end--
       END IF                                                              
    #-----No.FUN-740016-----
                                                                            
    #-----No.CHI-780041-----
    AFTER FIELD oaz79                                                       
       IF g_oaz.oaz79 !=' ' AND g_oaz.oaz79 IS NOT NULL THEN
           CALL s_check_no("aim",g_oaz.oaz79,g_oaz_t.oaz79,"4","oaz_file","oaz79","")
               RETURNING li_result,g_oaz.oaz79
           IF (NOT li_result) THEN
              NEXT FIELD oaz79
           END IF
           CALL s_get_doc_no(g_oaz.oaz79) RETURNING g_oaz.oaz79
       END IF                                                              
    #-----No.CHI-780041-----
 
    #No.FUN-610020  --Begin
    AFTER FIELD oaz74                                                       
        IF g_oaz.oaz74 !=' ' AND g_oaz.oaz74 IS NOT NULL THEN               
          #SELECT * FROM imd_file WHERE imd01=g_oaz.oaz74 AND imdacti='Y'   #FUN-650101
           SELECT * INTO l_imd.* FROM imd_file WHERE imd01=g_oaz.oaz74 AND imdacti='Y'   #FUN-650101
           IF SQLCA.SQLCODE THEN                                            
#             CALL cl_err(g_oaz.oaz74,'mfg1100',0)                             #No.FUN-660167
              CALL cl_err3("sel","imd_file",g_oaz.oaz74,"",'mfg1100',"","",0)   #No.FUN-660167
              NEXT FIELD oaz74                                              
           END IF                                                           
           #FUN-650101...............begin
           IF NOT (l_imd.imd11 MATCHES '[Yy]') THEN
              CALL cl_err(g_oaz.oaz74,'axm-993',0)
              NEXT FIELD oaz74                                              
           END IF 
          #IF NOT (l_imd.imd10 MATCHES '[Ss]') THEN  #MOD-B30292 mark
           IF NOT (l_imd.imd10 MATCHES '[Ww]') THEN  #MOD-B30292
             # CALL cl_err(g_oaz.oaz74,'axm-065',0)   #mak-by fangyan TQC-7C0105
              CALL cl_err(g_oaz.oaz74,'axm-666',0)     #add-by fangyan TQC-7C0105
              NEXT FIELD oaz74                                              
           END IF 
           IF NOT (l_imd.imd12 MATCHES '[Nn]') THEN
              CALL cl_err(g_oaz.oaz74,'axm-067',0)
              NEXT FIELD oaz74                                              
           END IF 
           #FUN-650101...............end
           #MOD-C80207 ---add--str
           IF NOT cl_null(g_oaz.oaz74) THEN 
              LET l_n = 0 
              SELECT count(*) INTO l_n  FROM jce_file WHERE jce02 = g_oaz.oaz74
              IF l_n > 0 THEN 
                 LET g_oaz.oaz74 = ''
                 DISPLAY g_oaz.oaz74 TO oaz74
                 CALL cl_err('','axm-065',0)
                 NEXT FIELD oaz74
              END IF
           END IF 
           #MOD-C80207---add--end           
           #FUN-CB0052--add--str--
           IF l_imd.imd10 MATCHES '[Ii]' THEN
              CALL cl_err(l_imd.imd10,'axm-693',0)
              NEXT FIELD oaz74
           END IF
           #FUN-CB0052--add--end--
        END IF                                                              
                                                                            
        #FUN-D40103 -------Begin-------
        IF NOT s_imechk(g_oaz.oaz74,g_oaz.oaz75) THEN
           NEXT FIELD oaz75
        END IF
        #FUN-D40103 -------End---------

    AFTER FIELD oaz75    
      #FUN-D40103 ------Begin-------                                                   
        #IF g_oaz.oaz75 !=' ' AND g_oaz.oaz75 IS NOT NULL THEN               
       #   SELECT * FROM ime_file WHERE ime01=g_oaz.oaz74                   
       #      AND ime02=g_oaz.oaz75                                         
       #   IF SQLCA.SQLCODE THEN                                            
#      #      CALL cl_err(g_oaz.oaz75,'mfg1101',0)                             #No.FUN-660167
       #      CALL cl_err3("sel","ime_file",g_oaz.oaz74,"",'mfg1101',"","",0)   #No.FUN-660167
       #      NEXT FIELD oaz75                                              
       #   END IF                                                           
       #END IF 
      #FUN-D40103 ------End----------
     # IF cl_null(g_oaz.oaz75) THEN LET g_oaz.oaz75 = 0 END IF   #TQC-D50127
        IF cl_null(g_oaz.oaz75) THEN LET g_oaz.oaz75 = ' ' END IF #TQC-D50126  
        #FUN-D40103 -------Begin-------
        IF NOT s_imechk(g_oaz.oaz74,g_oaz.oaz75) THEN
           NEXT FIELD oaz75
        END IF
    #FUN-D40103 -------End--------- 
    AFTER FIELD oaz76                                                       
        IF g_oaz.oaz76 !=' ' AND g_oaz.oaz76 IS NOT NULL THEN               
          #SELECT * FROM imd_file WHERE imd01=g_oaz.oaz76 AND imdacti='Y'   #FUN-CB0052 mark
           SELECT * INTO l_imd.* FROM imd_file WHERE imd01=g_oaz.oaz76 AND imdacti='Y'   #FUN-CB0052  
           IF SQLCA.SQLCODE THEN                                            
#             CALL cl_err(g_oaz.oaz76,'mfg1100',0)                             #No.FUN-660167
              CALL cl_err3("sel","imd_file",g_oaz.oaz76,"",'mfg1100',"","",0)   #No.FUN-660167
              NEXT FIELD oaz76                                              
           END IF  
           #MOD-C80207 ---add--str
           IF NOT cl_null(g_oaz.oaz76) THEN 
              LET l_n = 0 
              SELECT count(*) INTO l_n  FROM jce_file WHERE jce02 = g_oaz.oaz76
              IF l_n > 0 THEN 
                 LET g_oaz.oaz76 = ''
                 DISPLAY g_oaz.oaz76 TO oaz76
                 CALL cl_err('','axm-065',0)
                 NEXT FIELD oaz76
              END IF
           END IF 
           #MOD-C80207---add--end                                                                    
           #FUN-CB0052--add--str--
           IF l_imd.imd10 MATCHES '[Ii]' THEN
              CALL cl_err(l_imd.imd10,'axm-693',0)
              NEXT FIELD oaz76
           END IF
           #FUN-CB0052--add--end--
        END IF                                                              
          #FUN-D40103 -------Begin-------
        IF NOT s_imechk(g_oaz.oaz76,g_oaz.oaz77) THEN
           NEXT FIELD oaz77
        END IF
          #FUN-D40103 -------End---------
                                                                            
    AFTER FIELD oaz77                                                       
   #FUN-D40103 -----Begin------
       #IF g_oaz.oaz77 !=' ' AND g_oaz.oaz77 IS NOT NULL THEN               
       #   SELECT * FROM ime_file WHERE ime01=g_oaz.oaz76                   
       #      AND ime02=g_oaz.oaz77                                         
       #   IF SQLCA.SQLCODE THEN                                            
#      #      CALL cl_err(g_oaz.oaz77,'mfg1101',0)                             #No.FUN-660167
       #      CALL cl_err3("sel","ime_file",g_oaz.oaz76,"",'mfg1101',"","",0)   #No.FUN-660167
       #      NEXT FIELD oaz77                                              
       #   END IF                                                           
       #END IF 
    #FUN-D40103 -----End-------- 
    IF cl_null(g_oaz.oaz77) THEN LET g_oaz.oaz77 = ' ' END IF   #TQC-D50127
    #FUN-D40103 -------Begin-------
        IF NOT s_imechk(g_oaz.oaz76,g_oaz.oaz77) THEN
           NEXT FIELD oaz77
        END IF
    #FUN-D40103 -------End---------
    #No.FUN-610020  --End   
    #FUN-820033 --start--
    AFTER FIELD oaz80
         IF NOT cl_null(g_oaz.oaz80) THEN
           #FUN-AC0012 Begin---
           #SELECT COUNT(*) INTO g_i FROM oay_file
           # WHERE oaytype = '04' AND oayacti = 'Y' AND oayslip = g_oaz.oaz80
           #IF g_i = 0 THEN
           #   CALL cl_err3("sel","oay_file",g_oaz.oaz80,"",'100',"","",0)
           #   NEXT FIELD oaz80
           #END IF
            CALL s_check_no("atm",g_oaz.oaz80,"","U5","tqw_file","tqw01","") RETURNING li_result,g_oaz.oaz80
            IF (NOT li_result) THEN
                NEXT FIELD oaz80
            END IF
           #FUN-AC0012 End-----
         END IF
     #FUN-820033 --end--
 
    AFTER FIELD oaz41
       IF cl_null(g_oaz.oaz41) THEN
          LET g_oaz.oaz41=g_oaz_o.oaz41
          DISPLAY BY NAME g_oaz.oaz41
          NEXT FIELD oaz41
       END IF
       LET g_oaz_o.oaz41=g_oaz.oaz41
 
    AFTER FIELD oaz44
       IF g_oaz.oaz44 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz44) THEN
          LET g_oaz.oaz44=g_oaz_o.oaz44
          DISPLAY BY NAME g_oaz.oaz44
          NEXT FIELD oaz44
       END IF
       LET g_oaz_o.oaz44=g_oaz.oaz44
 
     #-----No.MOD-570192-----
    AFTER FIELD oaz43
       IF g_oaz.oaz43 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz43) THEN
          LET g_oaz.oaz43=g_oaz_o.oaz43
          DISPLAY BY NAME g_oaz.oaz43
          NEXT FIELD oaz43
       END IF
       LET g_oaz_o.oaz43=g_oaz.oaz43
     #-----No.MOD-570192 END-----
 
#NO.TQC-640134 取消MARK  
   #-----#No.FUN-640025 MARK-----
   #-----No.FUN-630006-----
   AFTER FIELD oaz19
      IF g_oaz.oaz19 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz19) THEN
         LET g_oaz.oaz19=g_oaz_o.oaz19
         DISPLAY BY NAME g_oaz.oaz19
         NEXT FIELD oaz19
      END IF
      LET g_oaz_o.oaz19=g_oaz.oaz19
   #-----No.MOD-630006 END-----
   #-----#No.FUN-640025 MARK END-----
#NO.TQC-640134 取消MARK

   #FUN-C30124 add START
    AFTER FIELD oaz108
       IF g_oaz.oaz108 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz108) THEN
          LET g_oaz.oaz108 = g_oaz_o.oaz108
          #TQC-D20009--modify--end--
          #DISPLAY g_oaz.oaz108
          #NEXT FIELD g_oaz.oaz108      
          DISPLAY BY NAME g_oaz.oaz108
          NEXT FIELD oaz108          
          #TQC-D20009--modify--end--
       END IF
       LET g_oaz_o.oaz108 = g_oaz.oaz108
   #FUN-C30124 add END
 
    AFTER FIELD oaz46
       IF g_oaz.oaz46 NOT MATCHES "[YN]" OR cl_null(g_oaz.oaz46) THEN
          LET g_oaz.oaz46=g_oaz_o.oaz46
          DISPLAY BY NAME g_oaz.oaz46
          NEXT FIELD oaz46
       END IF
       LET g_oaz_o.oaz46=g_oaz.oaz46
 
    AFTER FIELD oaz681
       IF cl_null(g_oaz.oaz681) THEN
          LET g_oaz.oaz681=g_oaz_o.oaz681
          DISPLAY BY NAME g_oaz.oaz681
          NEXT FIELD oaz681
       END IF
       LET g_oaz_o.oaz681=g_oaz.oaz681
 
    AFTER FIELD oaz682
       IF cl_null(g_oaz.oaz682) THEN
          LET g_oaz.oaz682=g_oaz_o.oaz682
          DISPLAY BY NAME g_oaz.oaz682
          NEXT FIELD oaz682
       END IF
       LET g_oaz_o.oaz682=g_oaz.oaz682
 
    AFTER FIELD oaz52
       IF g_oaz.oaz52 NOT MATCHES "[BMSCD]" OR cl_null(g_oaz.oaz52) THEN #FUN-640012 add 'M'
          LET g_oaz.oaz52=g_oaz_o.oaz52
          DISPLAY BY NAME g_oaz.oaz52
          NEXT FIELD oaz52
       END IF
       LET g_oaz_o.oaz52=g_oaz.oaz52
      #FUN-930164---add---str---
        IF g_oaz.oaz52 <> g_oaz_t.oaz52 THEN 
           LET g_flag_52='Y'
        END IF
      #FUN-930164---add---end---
 
    AFTER FIELD oaz70
       IF g_oaz.oaz70 NOT MATCHES "[BMSCD]" OR cl_null(g_oaz.oaz70) THEN #FUN-640012 add 'M'
          LET g_oaz.oaz70=g_oaz_o.oaz70
          DISPLAY BY NAME g_oaz.oaz70
          NEXT FIELD oaz70
       END IF
       LET g_oaz_o.oaz70=g_oaz.oaz70
      #FUN-930164---add---str---
        IF g_oaz.oaz70 <> g_oaz_t.oaz70 THEN 
           LET g_flag_70='Y'
        END IF
      #FUN-930164---add---end---
 
    #no.7150
    AFTER FIELD oaz184
       IF g_oaz.oaz184 NOT MATCHES '[RWN]' OR cl_null(g_oaz.oaz184) THEN
          LET g_oaz.oaz184=g_oaz_o.oaz184
          DISPLAY BY NAME g_oaz.oaz184
          NEXT FIELD oaz184
       END IF
       LET g_oaz_o.oaz184=g_oaz.oaz184
 
    AFTER FIELD oaz185
       IF cl_null(g_oaz.oaz185) THEN LET g_oaz.oaz185 = 0 END IF
 
      #No.TQC-7C0091 07/12/08 by zy begin modify 低價比率控管0至100之間
 
      #IF g_oaz.oaz185 < 0 OR cl_null(g_oaz.oaz185) THEN #mark by zy 07/12/08
       IF g_oaz.oaz185>100 OR g_oaz.oaz185 < 0 OR cl_null(g_oaz.oaz185) THEN
 
      #No.TQC-7C0091 07/12/08 by zy end modify
 
          LET g_oaz.oaz185=g_oaz_o.oaz185
          DISPLAY BY NAME g_oaz.oaz185
          NEXT FIELD oaz185
       END IF
       LET g_oaz_o.oaz185=g_oaz.oaz185
 
    #no.7150(end)
 
    AFTER FIELD oaz25
       IF g_oaz.oaz25>99 OR g_oaz.oaz25<1 THEN NEXT FIELD oaz25 END IF
 
    #No.TQC-7C0091 07/12/08 by zy begin add  訂單缺省容許超交率控管不可小于0
 
    AFTER FIELD oaz201
       IF g_oaz.oaz201<0 THEN NEXT FIELD oaz201 END IF
 
    #No.TQC-7C0091 07/12/08 by zy end add 
 
  #FUN-850120 add begin
    AFTER FIELD oaz81
       IF g_oaz.oaz81 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz81) THEN
          LET g_oaz.oaz81=g_oaz_o.oaz81
          DISPLAY BY NAME g_oaz.oaz81
          NEXT FIELD oaz81
       END IF
       LET g_oaz_o.oaz81=g_oaz.oaz81
  #FUN-850120 aee end
 
    AFTER FIELD oaz22
       IF g_oaz.oaz22 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz22) THEN
          LET g_oaz.oaz22=g_oaz_o.oaz22
          DISPLAY BY NAME g_oaz.oaz22
          NEXT FIELD oaz22
       END IF
       LET g_oaz_o.oaz22=g_oaz.oaz22
 
    AFTER FIELD oaz61
       IF g_oaz.oaz61 NOT MATCHES '[1-3]' OR cl_null(g_oaz.oaz61) THEN
          LET g_oaz.oaz61=g_oaz_o.oaz61
          DISPLAY BY NAME g_oaz.oaz61
          NEXT FIELD oaz61
       END IF
       LET g_oaz_o.oaz61=g_oaz.oaz61
 
    AFTER FIELD oaz62
       IF g_oaz.oaz62 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz62) THEN
          LET g_oaz.oaz62=g_oaz_o.oaz62
          DISPLAY BY NAME g_oaz.oaz62
          NEXT FIELD oaz62
       END IF
       LET g_oaz_o.oaz62=g_oaz.oaz62
 
     #MOD-4C0136
    AFTER FIELD oaz63
       IF g_oaz.oaz63 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz63) THEN
          LET g_oaz.oaz63=g_oaz_o.oaz63
          DISPLAY BY NAME g_oaz.oaz63
          NEXT FIELD oaz63
       END IF
       LET g_oaz_o.oaz63=g_oaz.oaz63
     #MOD-4C0136
 
    AFTER FIELD oaz64
       IF g_oaz.oaz64 NOT MATCHES '[YNO]' OR cl_null(g_oaz.oaz64) THEN
          LET g_oaz.oaz64=g_oaz_o.oaz64
          DISPLAY BY NAME g_oaz.oaz64
          NEXT FIELD oaz64
       END IF
       LET g_oaz_o.oaz64=g_oaz.oaz64
 
    AFTER FIELD oaz65
       IF g_oaz.oaz65 NOT MATCHES '[0-1]' OR cl_null(g_oaz.oaz65) THEN
          LET g_oaz.oaz65=g_oaz_o.oaz65
          DISPLAY BY NAME g_oaz.oaz65
          NEXT FIELD oaz65
       END IF
       LET g_oaz_o.oaz65=g_oaz.oaz65
 
    AFTER FIELD oaz66
       IF g_oaz.oaz66 NOT MATCHES '[0-1]' OR cl_null(g_oaz.oaz66) THEN
          LET g_oaz.oaz66=g_oaz_o.oaz66
          DISPLAY BY NAME g_oaz.oaz66
          NEXT FIELD oaz66
       END IF
       LET g_oaz_o.oaz66=g_oaz.oaz66
 
    AFTER FIELD oaz67
       IF g_oaz.oaz67 NOT MATCHES '[1-2]' OR cl_null(g_oaz.oaz67) THEN
          LET g_oaz.oaz67=g_oaz_o.oaz67
          DISPLAY BY NAME g_oaz.oaz67
          NEXT FIELD oaz67
       END IF
       LET g_oaz_o.oaz67=g_oaz.oaz67
 
    AFTER FIELD oaz691
       IF cl_null(g_oaz.oaz691) THEN
          LET g_oaz.oaz691=g_oaz_o.oaz691
          DISPLAY BY NAME g_oaz.oaz691
          NEXT FIELD oaz691
       END IF
       LET g_oaz_o.oaz691=g_oaz.oaz691
 
    AFTER FIELD oaz692
       IF cl_null(g_oaz.oaz692) THEN
          LET g_oaz.oaz692=g_oaz_o.oaz692
          DISPLAY BY NAME g_oaz.oaz692
          NEXT FIELD oaz692
       END IF
       LET g_oaz_o.oaz692=g_oaz.oaz692
 
    AFTER FIELD oaz71
       IF g_oaz.oaz71 NOT MATCHES '[1-2]' OR cl_null(g_oaz.oaz71) THEN
          LET g_oaz.oaz71=g_oaz_o.oaz71
          DISPLAY BY NAME g_oaz.oaz71
          NEXT FIELD oaz71
       END IF
       LET g_oaz_o.oaz71=g_oaz.oaz71
#FUN-870100---start---
    AFTER FIELD oaz83
       IF NOT cl_null(g_oaz.oaz83) THEN
          SELECT COUNT(*) INTO l_n FROM oaj_file WHERE oaj01 = g_oaz.oaz83 AND oajacti = 'Y'
          IF l_n = 0 THEN
             CALL cl_err('','art-078',0)
             LET g_oaz.oaz83 = g_oaz_t.oaz83
             DISPLAY BY NAME g_oaz.oaz83
             NEXT FIELD oaz83
          END IF
       END IF
 
    AFTER FIELD oaz84
       IF NOT cl_null(g_oaz.oaz84) THEN
          SELECT COUNT(*) INTO l_n FROM oaj_file WHERE oaj01 = g_oaz.oaz84 AND oajacti = 'Y'
          IF l_n = 0 THEN
             CALL cl_err('','art-078',0)
             LET g_oaz.oaz84 = g_oaz_t.oaz84
             DISPLAY BY NAME g_oaz.oaz84
             NEXT FIELD oaz84
          END IF
       END IF
 
    AFTER FIELD oaz85
       IF NOT cl_null(g_oaz.oaz85) THEN
          SELECT COUNT(*) INTO l_n FROM oaj_file WHERE oaj01 = g_oaz.oaz85 AND oajacti = 'Y'
          IF l_n = 0 THEN
             CALL cl_err('','art-078',0)
             LET g_oaz.oaz85 = g_oaz_t.oaz85
             DISPLAY BY NAME g_oaz.oaz85
             NEXT FIELD oaz85
          END IF
       END IF
 
    AFTER FIELD oaz86
       IF NOT cl_null(g_oaz.oaz86) THEN
          SELECT COUNT(*) INTO l_n FROM oaj_file WHERE oaj01 = g_oaz.oaz86 AND oajacti = 'Y'
          IF l_n = 0 THEN
             CALL cl_err('','art-078',0)
             LET g_oaz.oaz86 = g_oaz_t.oaz86
             DISPLAY BY NAME g_oaz.oaz86
             NEXT FIELD oaz86
          END IF
       END IF
#FUN-870100---end---
 
   #FUN-B50011 Begin---
    AFTER FIELD oaz88
       IF NOT cl_null(g_oaz.oaz88) THEN
          CALL s100_oaz91(g_oaz.oaz89,g_oaz.oaz88)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_oaz.oaz88,g_errno,0)
             LET g_oaz.oaz88 = g_oaz_t.oaz88
             DISPLAY BY NAME g_oaz.oaz88
             NEXT FIELD oaz88
          END IF
       END IF

    AFTER FIELD oaz91
       IF NOT cl_null(g_oaz.oaz91) THEN
          CALL s100_oaz91(g_oaz.oaz90,g_oaz.oaz91)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_oaz.oaz91,g_errno,0)
             LET g_oaz.oaz91 = g_oaz_t.oaz91
             DISPLAY BY NAME g_oaz.oaz91
             NEXT FIELD oaz91
          END IF
       END IF

    ON CHANGE oaz90
       LET g_oaz.oaz91=''
       DISPLAY BY NAME g_oaz.oaz91

    ON CHANGE oaz89
       LET g_oaz.oaz88=''
       DISPLAY BY NAME g_oaz.oaz88

   #FUN-B50011 End-----
    
    #No.FUN-C50025  --Beign
    ON CHANGE oaz92
     #FUN-C60033--MARK--STR 
     # IF g_oaz.oaz92 = 'Y' THEN
     # 	  CALL cl_set_comp_entry("oaz93",TRUE)
     # ELSE
     # 	  LET g_oaz.oaz93 = 'N'
     # 	  CALL cl_set_comp_entry("oaz93",FALSE)
     # END IF
     #FUN-C60033--MARK--END
     # #FUN-C60033---ADD---str

 #FUN-D60055--add--str--
       IF g_oaz_t.oaz92 = 'N' AND g_oaz.oaz92 = 'Y' THEN
          SELECT COUNT(*) INTO l_n FROM oga_file 
           #WHERE oga09 <> '9' AND ogaconf <> 'X' AND oga55 <> '9'#MOD-DB0084
           WHERE oga09 NOT IN ('9','1','5') AND ogaconf <> 'X' AND oga55 <> '9'  #MOD-DB0084           
             AND trim(oga10) IS NULL
          IF l_n > 0 THEN 
             CALL cl_err('','axm1059',1)
             LET g_oaz.oaz92=g_oaz_o.oaz92
             DISPLAY BY NAME g_oaz.oaz92
             NEXT FIELD oaz92
          END IF 
          SELECT COUNT(*) INTO l_n FROM oha_file
           WHERE ohaconf <> 'X' AND oha55 <> '9'
             AND trim(oha10) IS NULL 
          IF l_n > 0 THEN
             CALL cl_err('','axm1059',1)
             LET g_oaz.oaz92=g_oaz_o.oaz92
             DISPLAY BY NAME g_oaz.oaz92
             NEXT FIELD oaz92
          END IF
       END IF 
 #FUN-D60055--add--end--
       #FUN-C80094 xuxz 20120827 add --str
#wujie 130615 --begin
#      IF g_oaz.oaz93 = 'Y' AND g_oaz.oaz92 = 'Y' THEN
#         CALL cl_set_comp_entry("oaz107",TRUE)
#      ELSE
#         CALL cl_set_comp_entry("oaz107",FALSE)
#         LET g_oaz.oaz107 = 'N'
#         DISPLAY g_oaz.oaz107 TO oaz107
#      END IF
#wujie 130615 --end  
       #FUN-C80094 xuxz 20120827 add --end
       IF g_oaz.oaz92 = 'Y' THEN
          CALL cl_set_comp_entry("oaz93",TRUE)
          CALL cl_set_comp_visible('oaz95',TRUE)
          CALL cl_set_comp_visible('oaz107',TRUE)    #wujie 130615
          CALL cl_set_comp_entry('oaz97,oaz98,oaz100',TRUE) #FUN-C60036 add
          IF g_oaz.oaz93 = 'Y' THEN
             CALL cl_set_comp_entry("oaz95",TRUE)
             CALL cl_set_comp_required("oaz95",TRUE)
             CALL cl_set_comp_entry("oaz106",TRUE)#FUN-C60036 add             
          ELSE
             #MOD-CB0081 add begin------
             IF g_oaz_t.oaz93 = 'Y' AND g_oaz.oaz93 = 'N' THEN  
                CALL s100_chkimg10() RETURNING l_img10 
                IF l_img10 <> 0 THEN 
                    LET g_oaz.* = g_oaz_t.*
                    DISPLAY BY NAME g_oaz.oaz92                  
                    CALL cl_err('','axm-716',1)
                    NEXT FIELD oaz92
                END IF     
             #ELSE  #MOD-CB0081 add end #TQC-D20009 mark
             END IF #TQC-D20009 add
             CALL cl_set_comp_entry("oaz95",FALSE)
             LET g_oaz.oaz95=''
             DISPLAY BY NAME g_oaz.oaz95
             #FUN-C60036 --add--str
             CALL cl_set_comp_entry("oaz106",FALSE)
             LET g_oaz.oaz106 = 'N'
             DISPLAY BY NAME g_oaz.oaz106   
             #FUN-C60036--add--end
             #END IF #MOD-CB0081 add    #TQC-D20009 mark

#################
             CALL cl_set_comp_entry("oaz107",FALSE)
             LET g_oaz.oaz107='Y'
             DISPLAY BY NAME g_oaz.oaz107

################

          END IF
        ELSE
           #MOD-CB0081 add begin------
           IF g_oaz_t.oaz92 = 'Y' AND g_oaz.oaz92 = 'N' AND g_oaz_t.oaz93 = 'Y' THEN 
              CALL s100_chkimg10() RETURNING l_img10 
              IF l_img10 <> 0 THEN 
                  LET g_oaz.* = g_oaz_t.*
                  DISPLAY BY NAME g_oaz.oaz92                
                  CALL cl_err('','axm-716',1)                  
                  NEXT FIELD oaz92
              END IF     
           #ELSE  #MOD-CB0081 add end #TQC-D20009 mark
           END IF #TQC-D20009 mark
           LET g_oaz.oaz93='N'
           LET g_oaz.oaz95=''
           LET g_oaz.oaz106 = 'N'#FUN-C60036 add 
           LET g_oaz.oaz107 = 'N'#wujie 130615   
           DISPLAY BY NAME g_oaz.oaz93,g_oaz.oaz95,g_oaz.oaz106,g_oaz.oaz07   #FUN-C60036 add oaz106   wujie 130615 add oaz107
           CALL cl_set_comp_entry("oaz93",FALSE)
           CALL cl_set_comp_visible('oaz95',FALSE)
           CALL cl_set_comp_visible('oaz107',FALSE)   #wujie 130615
           CALL cl_set_comp_entry('oaz97,oaz98,oaz100,oaz106',FALSE) #FUN-C60036 add
           #FUN-C60036--add--str
           LET g_oaz.oaz97 = ''
           LET g_oaz.oaz98 = ''
           LET g_oaz.oaz100 = 'N'
           DISPLAY BY NAME g_oaz.oaz97,g_oaz.oaz98,g_oaz.oaz100,g_oaz.oaz93   #wujie add oaz93
           #END IF #MOD-CB0081 add    #TQC-D20009 mark 
        END IF

       ON CHANGE oaz93
          IF g_oaz.oaz93 = 'Y' THEN
             CALL cl_set_comp_entry("oaz95",TRUE)
             CALL cl_set_comp_required("oaz95",TRUE)
             CALL cl_set_comp_entry("oaz106",TRUE)#FUN-C60036 add
             CALL cl_set_comp_entry("oaz107",TRUE)#FUN-C60036 add
          ELSE
             #MOD-CB0081 add begin------
             IF g_oaz_t.oaz93 = 'Y' AND g_oaz.oaz93 = 'N' THEN 
                CALL s100_chkimg10() RETURNING l_img10 
                IF l_img10 <> 0 THEN 
                    LET g_oaz.* = g_oaz_t.*
                    DISPLAY BY NAME g_oaz.oaz93                  
                    CALL cl_err('','axm-716',1)
                    NEXT FIELD oaz93
                END IF     
             ELSE  #MOD-CB0081 add end -------
                CALL cl_set_comp_entry("oaz95",FALSE)
                LET g_oaz.oaz95=''
                DISPLAY BY NAME g_oaz.oaz95
                 #FUN-C60036 --add--str
                CALL cl_set_comp_entry("oaz106",FALSE)
                LET g_oaz.oaz106 = 'N'
                DISPLAY BY NAME g_oaz.oaz106
                #FUN-C60036--add--end
##################
                CALL cl_set_comp_entry("oaz107",FALSE)
                LET g_oaz.oaz107='Y'
                DISPLAY BY NAME g_oaz.oaz107
##################
             END IF #MOD-CB0081 add   
          END IF
#wujie 130615 --begin
#         #FUN-C80094xuxz 20120827 add --str
#         IF g_oaz.oaz93 = 'Y' AND g_oaz.oaz92 = 'Y' THEN
#            CALL cl_set_comp_entry("oaz107",TRUE)
#         ELSE
#            CALL cl_set_comp_entry("oaz107",FALSE)
#            LET g_oaz.oaz107 = 'N'
#            DISPLAY g_oaz.oaz107 TO oaz107
#         END IF
#         #FUN-C80094 xuxz 20120827 add --end
#wujie 130615 --end   

       AFTER FIELD oaz95
          IF g_oaz.oaz92 = 'Y' THEN
             IF g_oaz.oaz93 = 'Y' THEN
                CALL cl_set_comp_entry("oaz95",TRUE)
                IF cl_null(g_oaz.oaz95) THEN
                   CALL cl_err('','apm1073',0)
                END IF
             END IF
          END IF
          IF g_oaz.oaz95 !=' ' AND g_oaz.oaz95 IS NOT NULL THEN
            #SELECT * FROM imd_file WHERE imd01=g_oaz.oaz95 AND imdacti='Y'                #FUN-CA0084
             SELECT * INTO l_imd.* FROM imd_file WHERE imd01=g_oaz.oaz95 AND imdacti='Y'   #FUN-CA0084
             IF SQLCA.SQLCODE THEN
                CALL cl_err3("sel","imd_file",g_oaz.oaz95,"",'mfg1100',"","",0)  
                NEXT FIELD oaz95
             END IF
             IF NOT (l_imd.imd11 MATCHES '[Nn]') THEN  #FUN-CB0052 Yy->Nn
               #CALL cl_err(g_oaz.oaz95,'axm-993',0)   #FUN-CB0052 mark
                CALL cl_err(g_oaz.oaz95,'axm-694',0)   #FUN-CB0052
                NEXT FIELD oaz95
             END IF
            #IF NOT (l_imd.imd10 MATCHES '[Ww]') THEN    #FUN-CB0052 mark
             IF NOT (l_imd.imd10 MATCHES '[Ii]') THEN    #FUN-CB0052
               #CALL cl_err(g_oaz.oaz95,'axm-666',0)     #FUN-CB0052 mark
                CALL cl_err(g_oaz.oaz95,'axm-692',0)     #FUN-CB0052
                NEXT FIELD oaz95
             END IF
             IF NOT (l_imd.imd12 MATCHES '[Nn]') THEN
                CALL cl_err(g_oaz.oaz95,'axm-067',0)
                NEXT FIELD oaz95
             END IF
          END IF
      #FUN-C60033---ADD---END
         #FUN-C60036 ---add--str
         IF NOT cl_null(g_oaz.oaz95) THEN 
            LET l_n = 0 
            SELECT count(*) INTO l_n  FROM jce_file WHERE jce02 = g_oaz.oaz95
            IF l_n > 0 THEN 
               LET g_oaz.oaz95 = ''
               DISPLAY g_oaz.oaz95 TO oaz95
               CALL cl_err('','axr-388',0)
               NEXT FIELD oaz95
            END IF
         END IF 
         #FUN-C60036---add--end
     #TQC-D20046--cj--add--
         IF NOT cl_null(g_oaz_t.oaz95) AND cl_null(g_oaz.oaz95) OR g_oaz_t.oaz95 <> g_oaz.oaz95 THEN
            CALL s100_chkimg10() RETURNING l_img10
            IF l_img10 <> 0 THEN
               LET g_oaz.* = g_oaz_t.*
               DISPLAY BY NAME g_oaz.oaz95
               CALL cl_err('','axm-716',1)
               NEXT FIELD oaz95
            END IF
         END IF
     #TQC-D20046--cj--end--
    #FUN-C60036 --add--str
    AFTER FIELD oaz97
       IF NOT cl_null(g_oaz.oaz97) THEN
          CALL s100_ooy_chk(g_oaz.oaz97)
          IF cl_null(g_errno)THEN
             DISPLAY g_oaz.oaz97 TO oaz97
          ELSE
             CALL cl_err('',g_errno,0)
             LET g_oaz.oaz97 = ''
             DISPLAY g_oaz.oaz97 TO oaz97
             NEXT FIELD oaz97
          END IF
       END IF 
    AFTER FIELD oaz98
       IF NOT cl_null(g_oaz.oaz98) THEN 
          CALL s_check_no('axr',g_oaz.oaz98,g_oaz_t.oaz98,'12','','','')
              RETURNING li_result,g_oaz.oaz98
          DISPLAY BY NAME g_oaz.oaz98
          IF (NOT li_result) THEN
             NEXT FIELD oaz98
          END IF 
       END IF 
    #FUN-C60036---add--end
 
    AFTER FIELD oaz92
       IF g_oaz.oaz92 NOT MATCHES '[YN]' OR cl_null(g_oaz.oaz92) THEN
          LET g_oaz.oaz92=g_oaz_o.oaz92
          DISPLAY BY NAME g_oaz.oaz92
          NEXT FIELD oaz92
       END IF
       LET g_oaz_o.oaz92=g_oaz.oaz92
    #No.FUN-C50025  --End
    #MOD-D60159 add beg------------------
    AFTER FIELD oaz100
       IF g_oaz.oaz100 = 'Y' THEN 
          LET  g_oaz.oaz106 = 'Y'
       END IF    
    AFTER FIELD oaz106
       IF g_oaz.oaz100 = 'Y' THEN 
          IF g_oaz.oaz106 = 'N' THEN 
             CALL cl_err('','axm-775',1) 
             LET g_oaz.oaz106 = 'Y'
          END IF     
       END IF
    ON CHANGE oaz100
       IF g_oaz.oaz100 = 'Y' THEN 
          LET  g_oaz.oaz106 = 'Y'
       END IF
       DISPLAY BY NAME g_oaz.oaz106,g_oaz.oaz100
    ON CHANGE oaz106
       IF g_oaz.oaz100 = 'Y' THEN 
          IF g_oaz.oaz106 = 'N' THEN 
             CALL cl_err('','axm-775',1) 
             LET g_oaz.oaz106 = 'Y'
          END IF     
       END IF
       DISPLAY BY NAME g_oaz.oaz106,g_oaz.oaz100              
    #MOD-D60159 add end------------------   
   #FUN-C50136--add--
   # IF g_aza.aza26 = '2' THEN
   #    LET g_oaz.oaz96 = 'Y'
   # ELSE
   #    LET g_oaz.oaz96 = 'N'
   # END IF
   # DISPLAY BY NAME g_oaz.oaz96
   #FUN-C50136--add--
    ON ACTION CONTROLP
       CASE
            WHEN INFIELD(oaz11)                       #No:7909
#                CALL q_oak1(10,3,g_oaz.oaz11,'1') RETURNING g_oaz.oaz11 
#                CALL FGL_DIALOG_SETBUFFER( g_oaz.oaz11 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_oak1'
                 LET g_qryparam.default1 = g_oaz.oaz11
                 LET g_qryparam.arg1 ='1'
                 CALL cl_create_qry() RETURNING g_oaz.oaz11
#                 CALL FGL_DIALOG_SETBUFFER( g_oaz.oaz11 )
                 DISPLAY BY NAME g_oaz.oaz11 
                 NEXT FIELD oaz11 
               #-----No.FUN-740016-----
               WHEN INFIELD(oaz78)
                  CALL cl_init_qry_var()                                        
                  #LET g_qryparam.form    = "q_imd"   #MOD-C50085 mark 
                  LET g_qryparam.form     = "q_imd04" #MOD-C50085 add 
                  LET g_qryparam.default1 = g_oaz.oaz78                         
                  LET g_qryparam.arg1     = 'SW'
                  CALL cl_create_qry() RETURNING g_oaz.oaz78                    
                  DISPLAY BY NAME g_oaz.oaz78                                   
                  NEXT FIELD oaz78 
               #-----No.FUN-740016 END-----
               #no.CHI-780041 START--------
               WHEN INFIELD(oaz79)
                  LET  g_t1=s_get_doc_no(g_oaz.oaz79)
                  CALL q_smy(FALSE,FALSE,g_t1,'AIM','4') RETURNING g_t1 
                  LET  g_oaz.oaz79 = g_t1
                  DISPLAY BY NAME g_oaz.oaz79
                  NEXT FIELD oaz79
               #-----No.CHI-780041 END-----
               #No.FUN-610020  --Begin
               WHEN INFIELD(oaz74)                                              
                  CALL cl_init_qry_var()                                        
                  LET g_qryparam.form     = "q_imd"                             
                  LET g_qryparam.default1 = g_oaz.oaz74                         
                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213  
                  CALL cl_create_qry() RETURNING g_oaz.oaz74                    
                  DISPLAY BY NAME g_oaz.oaz74                                   
                  NEXT FIELD oaz74                                              
               WHEN INFIELD(oaz75)                                              
                  CALL cl_init_qry_var()                                        
                  LET g_qryparam.form     = "q_ime"                             
                  LET g_qryparam.default1 = g_oaz.oaz75                         
                  LET g_qryparam.arg1     = g_oaz.oaz74 
                  LET g_qryparam.arg2     = 'SW'       
                  CALL cl_create_qry() RETURNING g_oaz.oaz75                    
                  DISPLAY BY NAME g_oaz.oaz75                                   
                  NEXT FIELD oaz75 
               WHEN INFIELD(oaz76)                                              
                  CALL cl_init_qry_var()                                        
                  LET g_qryparam.form     = "q_imd"                             
                  LET g_qryparam.default1 = g_oaz.oaz76                         
                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213  
                  CALL cl_create_qry() RETURNING g_oaz.oaz76                    
                  DISPLAY BY NAME g_oaz.oaz76                                   
                  NEXT FIELD oaz76                                              
               #FUN-820033 --start--
               WHEN INFIELD(oaz80)                                              
                  CALL cl_init_qry_var()                                        
                  LET g_qryparam.form     = "q_oay6"
                  LET g_qryparam.default1 = g_oaz.oaz80
                 #FUN-AC0012 Begin---
                 #LET g_qryparam.arg1 = '04'
                 #LET g_qryparam.arg2 = 'axm'       #FUN-A70130
                  LET g_qryparam.arg1 = 'U5' 
                  LET g_qryparam.arg2 = 'atm'
                 #FUN-AC0012 End-----
                  CALL cl_create_qry() RETURNING g_oaz.oaz80                    
                  DISPLAY BY NAME g_oaz.oaz80                                   
                  NEXT FIELD oaz80 
                #FUN-820033 --end--
               WHEN INFIELD(oaz77)                                              
                  CALL cl_init_qry_var()                                        
                  LET g_qryparam.form     = "q_ime"                             
                  LET g_qryparam.default1 = g_oaz.oaz77                         
                  LET g_qryparam.arg1     = g_oaz.oaz76 
                  LET g_qryparam.arg2     = 'SW'       
                  CALL cl_create_qry() RETURNING g_oaz.oaz77                    
                  DISPLAY BY NAME g_oaz.oaz77                                   
                  NEXT FIELD oaz77 
               #No.FUN-610020  --End  
               #FUN-870100---start---
               WHEN INFIELD(oaz83)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oaj"
                  CALL cl_create_qry() RETURNING g_oaz.oaz83
                  DISPLAY BY NAME g_oaz.oaz83
                  NEXT FIELD oaz83
               WHEN INFIELD(oaz84)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oaj"
                  CALL cl_create_qry() RETURNING g_oaz.oaz84
                  DISPLAY BY NAME g_oaz.oaz84
                  NEXT FIELD oaz84
               WHEN INFIELD(oaz85)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oaj"
                  CALL cl_create_qry() RETURNING g_oaz.oaz85
                  DISPLAY BY NAME g_oaz.oaz85
                  NEXT FIELD oaz85
               WHEN INFIELD(oaz86)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oaj"
                  CALL cl_create_qry() RETURNING g_oaz.oaz86
                  DISPLAY BY NAME g_oaz.oaz86
                  NEXT FIELD oaz86
               #FUN-870100---end---
               #FUN-B30012 ------------STA
                WHEN INFIELD(oaz88)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azf03"
                  LET g_qryparam.default1 = g_oaz.oaz88
                  LET g_qryparam.arg1 = '2'    
                 #FUN-B50011 Begin---
                 #LET g_qryparam.arg2 = '1'    
                  IF g_oaz.oaz89='2' THEN
                     LET g_qryparam.arg2 = '4'
                  ELSE
                     LET g_qryparam.arg2 = '1'
                  END IF
                 #FUN-B50011 End-----
                  CALL cl_create_qry() RETURNING g_oaz.oaz88
                  DISPLAY BY NAME g_oaz.oaz88
                  NEXT FIELD oaz88
               #FUN-B30012 ------------END
               #FUN-B50011 Begin---
                WHEN INFIELD(oaz91)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azf03"
                  LET g_qryparam.default1 = g_oaz.oaz91
                  LET g_qryparam.arg1 = '2'
                  IF cl_null(g_oaz.oaz90) THEN NEXT FIELD oaz90 END IF
                  IF g_oaz.oaz90='1' THEN
                     LET g_qryparam.arg2 = '1'
                  ELSE
                     LET g_qryparam.arg2 = '4'
                  END IF
                  CALL cl_create_qry() RETURNING g_oaz.oaz91
                  DISPLAY BY NAME g_oaz.oaz91
                  NEXT FIELD oaz91
               #FUN-B50011 End-----
               #No.FUN-C50025  --Begin
               WHEN INFIELD(oaz95)                                              
                  CALL cl_init_qry_var()                                        
                # LET g_qryparam.form     = "q_imd"   #FUN-CB0052 mark                           
                  LET g_qryparam.form     = "q_imdd"   #FUN-CB0052                          
                  LET g_qryparam.default1 = g_oaz.oaz95                        
                # LET g_qryparam.arg1     = 'SW'      #FUN-CB0052 mark
                # LET g_qryparam.where = " imdacti = 'Y' AND imd11 = 'Y' AND imd10 = 'W' AND imd12 = 'N' AND imd01 NOT IN (SELECT jce02 FROM jce_file) "#FUN-CA0084 xuxz add 20121031   #FUN-CB0052 mark
                  CALL cl_create_qry() RETURNING g_oaz.oaz95                 
                  DISPLAY BY NAME g_oaz.oaz95                                   
                  NEXT FIELD oaz95 
               #No.FUN-C50025  --End 
               #FUN-C60036--add--str
               WHEN INFIELD(oaz97)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_oay3"
                  LET g_qryparam.default1 = g_oaz.oaz95
                  LET g_qryparam.arg1     = '70'
                  LET g_qryparam.arg2     = 'axm'
                  CALL cl_create_qry() RETURNING g_oaz.oaz97
                  DISPLAY BY NAME g_oaz.oaz97
                  NEXT FIELD oaz97
               WHEN INFIELD(oaz98)
                  CALL q_ooy(FALSE,FALSE,g_oaz.oaz98,'12','AXR') 
                     RETURNING g_oaz.oaz98
                  DISPLAY BY NAME g_oaz.oaz98
                  NEXT FIELD oaz98
               #FUN-C60036--add--end
            END CASE
 
    ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
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

#FUN-B50011 Begin---
FUNCTION s100_oaz91(p_oaz90,p_oaz91)
 DEFINE p_oaz90      LIKE oaz_file.oaz90
 DEFINE p_oaz91      LIKE oaz_file.oaz91
 DEFINE l_azf09      LIKE azf_file.azf09
 DEFINE l_azfacti    LIKE azf_file.azfacti

   LET g_errno = ''

   IF cl_null(p_oaz90) THEN LET g_errno='axm-378' END IF
   IF p_oaz90 = '2' THEN LET p_oaz90 = '4' END IF
   SELECT azf09,azfacti INTO l_azf09,l_azfacti
     FROM azf_file
    WHERE azf01=p_oaz91
      AND azf02='2'
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='aic-040'
        WHEN l_azfacti='N'     LET g_errno='9028'
        WHEN l_azf09<>p_oaz90  LET g_errno='axm-379'
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
#FUN-B50011 End-----
 
#--->NO:3044
FUNCTION s100_y()
 DEFINE   l_oaz01 LIKE type_file.chr1   #No.FUN-680137 VARCHAR(01)
     SELECT oaz01 INTO l_oaz01 FROM oaz_file WHERE oaz00='0'
     IF l_oaz01 = 'Y' THEN RETURN END IF
     UPDATE oaz_file SET oaz01='Y' WHERE oaz00='0'
     IF STATUS THEN 
        LET g_oaz.oaz01='N'
#       CALL cl_err('upd oaz01:',STATUS,0)   #No.FUN-660167
        CALL cl_err3("upd","oaz_file","","",STATUS,"","upd oaz01",0)   #No.FUN-660167
     ELSE
        LET g_oaz.oaz01='Y'
     END IF
     DISPLAY BY NAME g_oaz.oaz01 
END FUNCTION
 
#No.FUN-5C0075  --start--   
FUNCTION s100_set_entry()                                                                                                           
                                                                                                                                    
   IF g_oaz.oaz23 ='Y' THEN                                                                                                        
      CALL cl_set_comp_entry("oaz42",TRUE)                                                                                         
   END IF                                                     
   #No.FUN-C50025  --Begin
   IF g_oaz.oaz92 = 'Y' THEN
      CALL cl_set_comp_entry("oaz93",TRUE) 
   END IF
   #No.FUN-C50025  --Begin
END FUNCTION
#No.FUN-5C0075  --end--   
 
#No.FUN-5C0075  --start--   
FUNCTION s100_set_no_entry()                                                                                                           
                                                                                                                                    
   IF g_oaz.oaz23 ='N' THEN                                                                                                        
      CALL cl_set_comp_entry("oaz42",FALSE)                                                                                         
   END IF                                                     
 
#CHI-840010-add
   IF g_sma.sma115 ='Y' THEN                                                                                                        
      LET g_oaz.oaz22 = 'N'
      DISPLAY BY NAME g_oaz.oaz22
      CALL cl_set_comp_entry("oaz22",FALSE)                                                                                         
   END IF                                                     
#CHI-840010-add-end
 
   #No.FUN-C50025  --Begin
   IF g_oaz.oaz92 = 'N' THEN
      LET g_oaz.oaz93 = 'N'
      DISPLAY BY NAME g_oaz.oaz93
      CALL cl_set_comp_entry("oaz93",FALSE)  
   END IF
   #No.FUN-C50025  --Begin
END FUNCTION
#No.FUN-5C0075  --end--   
#FUN-C60036--add--str
FUNCTION s100_ooy_chk(p_oaz97)
   DEFINE p_oaz97 LIKE oaz_file.oaz97
   DEFINE l_oaysys LIKE oay_file.oaysys,
          l_oaytype LIKE oay_file.oaytype,
          l_oayacti LIKe oay_file.oayacti
   LET g_errno = ''
   SELECT oaysys,oaytype,oayacti INTO l_oaysys,l_oaytype,l_oayacti
     FROM oay_file
    WHERE oayslip = p_oaz97
   CASE
      WHEN SQLCA.sqlcode=100
         LET g_errno='aap-010'
      WHEN l_oayacti='N'
         LET g_errno='agl-530'
      WHEN l_oaytype <> '70'
         LET g_errno='aap-009'
      WHEN l_oaysys <> 'axm'
         LET g_errno = 'asm-700'
      OTHERWISE
         LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
END FUNCTION
#FUN-C60036--add--end

#MOD-CB0081 add begin-------
FUNCTION s100_chkimg10()

DEFINE l_img10   LIKE img_file.img10  

    SELECT SUM(img10) INTO l_img10 FROM img_file WHERE img02 = g_oaz_t.oaz95  #g_oaz.oaz95-->g_oaz_t.oaz95 cj
    IF cl_null(l_img10) THEN 
       LET l_img10 = 0 
    END IF
    RETURN l_img10
END FUNCTION 
#MOD-CB0081 add end-------
