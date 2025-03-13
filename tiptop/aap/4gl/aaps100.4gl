# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aaps100.4gl
# Descriptions...: 應付帳款系統參數
# Modify.........: 97/05/07 By Danny 新增結帳日, 關帳日期
# Modify.........: 04/02/23 Kammy Genero aaps101/aaps102/aaps103/aaps104 結合
# Modify.........: MOD-4B0307 04/11/30 By ching update 錯誤修改
# Modify.........: No.FUN-580096 05/08/25 By Carrier aza26='2'時隱藏apz07/apz14
# Modify.........: No.TQC-5B0086 05/11/24 By Smapmin 會計總帳工廠,帳別若上面參數設定'Y',則應必需輸入.
# Modify.........: No.TQC-630135 06/03/16 By Smapmin 將apz23拿掉
# Modify.........: No.TQC-630136 06/03/16 By Smapmin 將apz36,apz37,apz38,apz39拿掉
# Modify.........: No.TQC-630134 06/03/30 By Smapmin 將apz24拿掉
# Modify.........: No.FUN-640012 06/04/07 By kim GP3.0 匯率參數功能改善
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.FUN-660141 06/07/10 By cheunl  帳別權限修改
# Modify.........: No.FUN-680029 06/08/23 By douzh 增加"總帳管理系統使用帳套二"欄位(apz02c)
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-740032 07/04/12 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.TQC-770052 07/07/12 By Rayven 如該留置原因碼為無效，手工錄入仍然能通過
#                                                   結帳日為負數無控管,這樣推算付款日時,付款日總會往后加一個月
#                                                   銀行出帳異動碼缺省值,錄入任何值無管控
# Modify.........: No.FUN-880094 08/08/28 By sherry 預付金額是否與采購單勾稽
# Modify.........: No.FUN-930164 09/04/15 By jamie update apz56、apz57成功時，寫入azo_file
# Modify.........: No.FUN-920210 09/05/04 By Sabrina 新增apz62 預付/暫付不做月底重評價
# Modify.........: No.FUN-980001 09/08/04 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980025 09/09/23 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.FUN-970108 09/08/20 By hongmei add apz63 申報統編
# Modify.........: No.FUN-990031 09/10/23 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No:FUN-990053 09/09/16 By hongmei s_chkban前先检查aza21 = 'Y
# Modify.........: No:MOD-9C0387 09/12/24 By sherry apz58銀行出賬異動碼開窗時應只開出提出類異動碼
# Modify.........: No.TQC-A20062 10/03/02 By lutingting 拿掉參數apz26
# Modify.........: No:TQC-A20064 10/03/01 By Carrier apz06 与 apz05 连动
# Modify.........: No.FUN-A40003 10/04/02 By wujie   add apz64 转销应付单别
# Modify.........: No.FUN-A60024 10/06/09 By wujie   add apz65 转销科目类型编号，apz66 转销帐款类型
# Modify.........: No:TQC-A60123 10/06/29 By xiaofeizhu apz63報錯後回退到字段
# Modify.........: No.FUN-A50102 10/07/26 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A80111 10/08/31 By wujie   add apz67 默认溢退单别
# Modify.........: No.FUN-A90007 10/09/03 By wujie   add apz68 调帐是否走中间过渡科目
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 離開MAIN時沒有 add cl_used(1)和cl_used(2)
# Modify.........: No:TQC-B40067 11/04/11 By yinhy s_chkban前先检查aza21 = 'Y'
# Modify.........: No:MOD-B60117 11/06/15 By lixiang  對溢退單別進行控管
# Modify.........: No.FUN-B50039 11/07/01 By xianghui 增加自定義欄位
# Modify.........: No.TQC-B80136 11/08/23 By wujie    增加apz69
# Modify.........: No.TQC-B90081 11/09/09 By guoch apz69更改时进行初始化
# Modify.........: No.TQC-BC0194 11/12/30 By wujie    在after input时增加apz68对apz64的控管
# Modify.........: No.TQC-C60172 12/06/20 By lujh apz67欄位的after field欄位判斷應稽核開窗q_apy5的管控，應要求apykind=12:雜項發票並且apydmy3=N
# Modify.........: No.TQC-C70157 12/07/24 By lujh 因立賬時現在都按照立賬日期的匯率（經與國萍討論），所以apz69改為no use,無條件隱藏apz69
# Modify.........: No.FUN-C90028 12/09/24 By xuxz 不顯示帳齡分析參數
# Modify.........: No.FUN-C90027 12/09/25 By xuxz add apz70
# Modify.........: No.FUN-CB0056 13/02/21 By minpp 增加apz71,apz72,apz73字段,大陸版時顯示
# Modify.........: No.MOD-D40226 13/04/28 By wujie 对apz70增加同apz64的控管
# Modify.........: No.FUN-DA0051 13/10/15 By yuhuabao 添加'是否允许客户立账'apz74栏位

DATABASE ds

GLOBALS "../../config/top.global"
     DEFINE
        g_apz_t         RECORD LIKE apz_file.*,  # 預留參數檔
        g_apz_o         RECORD LIKE apz_file.*   # 預留參數檔
DEFINE p_row,p_col     LIKE type_file.num5                                                     #No.FUN-690028 SMALLINT
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL
DEFINE  g_cnt           LIKE type_file.num10     #No.FUN-690028 INTEGER
DEFINE  t_dbss          LIKE azp_file.azp03      #No.FUN-740032
DEFINE  g_bookno1       LIKE aza_file.aza81      #No.FUN-740032
DEFINE  g_bookno2       LIKE aza_file.aza82      #No.FUN-740032
DEFINE  g_flag          LIKE type_file.chr1      #No.FUN-740032
DEFINE  g_msg           LIKE type_file.chr1000 #FUN-930164 add
DEFINE  g_flag_56       LIKE type_file.chr1    #FUN-930164 add
DEFINE  g_flag_57       LIKE type_file.chr1    #FUN-930164 add
DEFINE  g_before_input_done LIKE type_file.num5  #No.TQC-A20064

MAIN
   OPTIONS
         INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

    #MOD-4B0307
    LET g_apz.apz00='0'
    INSERT INTO apz_file VALUES(g_apz.*)

   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    #MOD-4B0307
   #LET g_apz.apz00='0'
   #INSERT INTO apz_file VALUES(g_apz.*)
   #--

   #取得有關語言及日期型態的資料
   SELECT * INTO g_aza.* FROM aza_file
    WHERE aza01='0'
   IF SQLCA.sqlcode THEN
#     CALL cl_err('aaps100',9006,3)   #No.FUN-660122
      CALL cl_err3("sel","aza_file","","",9006,"","aaps100",1)  #No.FUN-660122
      EXIT PROGRAM
   END IF
    CALL s100(4,08)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN

FUNCTION s100(p_row,p_col)
    DEFINE
        p_row,p_col LIKE type_file.num5            #No.FUN-690028 SMALLINT
#       l_time        LIKE type_file.chr8          #No.FUN-6A0055

    LET p_row = 4 LET p_col = 8
    OPEN WINDOW s100_w AT p_row,p_col WITH FORM "aap/42f/aaps100"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()

    #No.FUN-580096  --begin
    CALL cl_set_comp_visible("group12",g_aza.aza26 != '2') #FUN-C90028 add
    #大陆版显示
    CALL cl_set_comp_visible("apz71,apz72,apz73,apz74",g_aza.aza26='2')   #FUN-CB0056 #FUN-DA0051 add apz74
    #FUN-C90028--add--str
    IF g_aza.aza26 = '2' THEN
       CALL cl_set_comp_visible('group19',FALSE)
       LET g_apz.apz63 = ''
       CALL cl_set_comp_visible('Group3',TRUE)   #FUN-DA0051
    ELSE
       CALL cl_set_comp_visible('group19',TRUE)
       CALL cl_set_comp_visible('Group3',FALSE)   #FUN-DA0051
    END IF
    #FUN-C90028--add--end
    CALL cl_set_comp_visible("apz69",FALSE)     #TQC-C70157  add
    CALL cl_set_comp_visible("apz07,apz14",g_aza.aza26<>'2')
    CALL cl_set_comp_visible("group05",g_aza.aza26<>'2')
    CALL cl_set_comp_visible("apz02c",g_aza.aza63='Y')             #FUN-680029
    IF cl_null(g_apz.apz07) THEN LET g_apz.apz07='N' END IF
    IF cl_null(g_apz.apz14) THEN LET g_apz.apz14='N' END IF
    #No.FUN-580096  --end

    CALL s100_show()

   WHILE TRUE
      LET g_action_choice=""
      CALL s100_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
   END WHILE

    CLOSE WINDOW s100_w
END FUNCTION

FUNCTION s100_show()
    SELECT * INTO g_apz.*
             FROM apz_file WHERE apz00 = '0'
    IF SQLCA.sqlcode OR g_apz.apz01 IS NULL THEN
        LET g_apz.apz01 = "N"
        LET g_apz.apz02 = "N"
        LET g_apz.apz02p = " "
        LET g_apz.apz02b = " "
        LET g_apz.apz02c = " "                  #FUN-680029
        LET g_apz.apz03 = "N"
        LET g_apz.apz04 = "N"
        LET g_apz.apz04p = " "
        LET g_apz.apz11 = '2'
        LET g_apz.apz42 = "2"
        LET g_apz.apz31 = "N"
        LET g_apz.apz32 = "N"
        LET g_apz.apz33 = "S"    #FUN-640012  N->S
        LET g_apz.apz34 = "N"
        LET g_apz.apz35 = "N"
        #LET g_apz.apz36 = "N"   #TQC-630136
        #LET g_apz.apz37 = "N"   #TQC-630136
        #LET g_apz.apz38 = "N"   #TQC-630136
        #LET g_apz.apz39 = "N"   #TQC-630136
        LET g_apz.apz40 = "N"
        LET g_apz.apz58 = 1
        LET g_apz.apz61 = '2'    #No.FUN-880094
        LET g_apz.apz74 = 'N'    #No.FUN-DA0051
        IF SQLCA.sqlcode THEN
           INSERT INTO apz_file(apz00,apz01,apz02,apz02p,apz03,
                                apz04,apz04p,apz02b,apz02c,apz63,apz64,apz70,apz65,apz66,apz67,apz68,apz74)  #FUN-680029 #FUN-970108 add apz63  #FUN-A40003 add apz64  #No.FUN-A60024 add apz65,apz66  #No.FUN-A80111 add apz67  FUN-A90007 add apz68#No.FUN-C90027 add apz70 #No.FUN-DA0051 add apz74
                  VALUES ('0',g_apz.apz01,g_apz.apz02,g_apz.apz02p,
                          g_apz.apz03,g_apz.apz04,g_apz.apz04p,
                          g_apz.apz02b,g_apz.apz02c,g_apz.apz63,g_apz.apz64,g_apz.apz70,g_apz.apz65,g_apz.apz66,g_apz.apz67,g_apz.apz68,g_apz.apz74)   #FUN-680029 #FUN-970108 add zpa63   #FUN-A40003 add apz64  #No.FUN-A60024 add apz65,apz66  #No.FUN-A80111    FUN-A90007 add apz68#No.FUN-C90027 add apz70 #No.FUN-DA0051 add apz74
        ELSE
           UPDATE apz_file SET apz00 = '0',
                               apz01 = g_apz.apz01,
                               apz02 = g_apz.apz02,
                               apz02p= g_apz.apz02p,
                               apz03 = g_apz.apz03,
                               apz04 = g_apz.apz04,
                               apz04p= g_apz.apz04p,
                               apz05 = g_apz.apz05,
                               apz02b= g_apz.apz02b,
                               apz02c= g_apz.apz02c,  #FUN-680029
                               apz07 = g_apz.apz07,
                               apz53 = g_apz.apz53,
                               apz56 = g_apz.apz56,
                               apz57 = g_apz.apz57,
                                apz42 = g_apz.apz42,  #MOD-4B0307
                               apz31 = g_apz.apz31,
                               apz32 = g_apz.apz32,
                               apz33 = g_apz.apz33,
                               apz34 = g_apz.apz34,
                               apz35 = g_apz.apz35,
                               #apz36 = g_apz.apz36,   #TQC-630136
                               #apz37 = g_apz.apz37,   #TQC-630136
                               #apz38 = g_apz.apz38,   #TQC-630136
                               #apz39 = g_apz.apz39,   #TQC-630136
                               apz40 = g_apz.apz40,
                               apz58 = g_apz.apz58,
                               apz43 = g_apz.apz43,
                               apz44 = g_apz.apz44,
                               apz52 = g_apz.apz52,
                              #apz61 = g_apz.azp61    #FUN-930164 mark #No.FUN-880094
                               apz61 = g_apz.apz61,   #FUN-930164 mod
                               apz63 = g_apz.apz63,    #FUN-970108 add
                               apz64 = g_apz.apz64,    #FUN-A40003 add
                               apz70 = g_apz.apz70,  #No.FUN-C90027 add apz70
                               apz74 = g_apz.apz74,    #No.FUN-DA0051
                               apz65 = g_apz.apz65,    #FUN-A60024 add
                               apz66 = g_apz.apz66,    #FUN-A60024 add
                               apz67 = g_apz.apz67,    #FUN-A80111 add
                               apz68 = g_apz.apz68     #No.FUN-A90007 add
        END IF
        IF SQLCA.sqlcode THEN
           CALL cl_err('',SQLCA.sqlcode,0)
           RETURN
       #FUN-930164---add---str---
        ELSE
           IF g_flag_56='Y' THEN
              LET g_errno = TIME
              LET g_msg = 'old:',g_apz_t.apz56,' new:',g_apz.apz56
              #INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
              INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
                 #VALUES ('aaps100',g_user,g_today,g_errno,'apz56',g_msg) #FUN-980001 mark
                 VALUES ('aaps100',g_user,g_today,g_errno,'apz56',g_msg,g_plant,g_legal) #FUN-980001 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","azo_file","aaps100","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 RETURN
              END IF
           END IF
           IF g_flag_57='Y' THEN
              LET g_errno = TIME
              LET g_msg = 'old:',g_apz_t.apz57,' new:',g_apz.apz57
              #INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
              INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
                 #VALUES ('aaps100',g_user,g_today,g_errno,'apz57',g_msg) #FUN-980001 mark
                 VALUES ('aaps100',g_user,g_today,g_errno,'apz57',g_msg,g_plant,g_legal) #FUN-980001 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","azo_file","aaps100","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 RETURN
              END IF
           END IF
       #FUN-930164---add---end---
        END IF
    END IF
    DISPLAY BY NAME g_apz.apz01,g_apz.apz02,g_apz.apz02p,g_apz.apz02b,g_apz.apz02c,              #FUN-680029
                    g_apz.apz03,g_apz.apz04,g_apz.apz04p,g_apz.apz07,
                    g_apz.apz56,g_apz.apz57,
                    g_apz.apz12,g_apz.apz13,g_apz.apz14,
                    #g_apz.apz15,g_apz.apz16,g_apz.apz23,   #TQC-630135
                    g_apz.apz15,g_apz.apz16,                #TQC-630135
                    g_apz.apz71,g_apz.apz72,g_apz.apz73,    #FUN-CB0056 add--apz71,72,73
                    g_apz.apz74,                            #NO.FUN-DA0051 add
                    #g_apz.apz24,g_apz.apz26,   #TQC-630134
                    #g_apz.apz26,   #TQC-630134   #TAC-A20062
                    g_apz.apz45,g_apz.apz46,g_apz.apz47,
                    g_apz.apz48,g_apz.apz59,g_apz.apz33,  #FUN-640012 add g_apz.apz33
                    g_apz.apz63,g_apz.apz64,g_apz.apz70,g_apz.apz65,g_apz.apz66,g_apz.apz67,g_apz.apz68,g_apz.apz08,              #FUN-970108 add apz63   FUN-A40003 add apz64    #No.FUN-A60024 add apz65,apz66  #No.FUN-A80111 add apz67    FUN-A90007 add apz68#No.FUN-C90027 add apz70
                    g_apz.apz61,    #No.FUN-880094 add
                    g_apz.apz60,g_apz.apz06,g_apz.apz05,
                    g_apz.apz27,g_apz.apz62,g_apz.apz69,g_apz.apz21,g_apz.apz22,  #FUN-920210 add apz62   #No.TQC-B80136 add apz69
                    g_apz.apz42,g_apz.apz31,g_apz.apz32,
                    #g_apz.apz36,g_apz.apz37,   #TQC-630136
                    #g_apz.apz38,g_apz.apz40,g_apz.apz58,   #TQC-630136
                    g_apz.apz40,g_apz.apz58,   #TQC-630136
                    g_apz.apz43,g_apz.apz44,g_apz.apz52,
                    #FUN-B50039-add-str--
                    g_apz.apzud01,g_apz.apzud02,g_apz.apzud03,g_apz.apzud04,g_apz.apzud05,
                    g_apz.apzud06,g_apz.apzud07,g_apz.apzud08,g_apz.apzud09,g_apz.apzud10,
                    g_apz.apzud11,g_apz.apzud12,g_apz.apzud13,g_apz.apzud14,g_apz.apzud15
                    #FUN-B50039-add-end--
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

FUNCTION s100_menu()
 MENU ""
    ON ACTION modify
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN   #更改權限
          CALL s100_u()
       END IF

    ON ACTION reset
       LET g_action_choice="reset"
       IF cl_chk_act_auth() THEN
          CALL s100_y()
       END IF

    ON ACTION help
       CALL cl_show_help()
    ON ACTION locale
       CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#      EXIT MENU
    ON ACTION exit
       LET g_action_choice = "exit"
       EXIT MENU
    ON ACTION CONTROLG
       CALL cl_cmdask()
    ON IDLE g_idle_seconds
       CALL cl_on_idle()

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

       LET g_action_choice = "exit"
       CONTINUE MENU


        -- for Windows close event trapped
    ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145
             LET INT_FLAG=FALSE 		#MOD-570244	mars
       LET g_action_choice = "exit"
       EXIT MENU

    END MENU
END FUNCTION


FUNCTION s100_u()
    IF s_aapshut(0) THEN RETURN END IF
    CALL cl_opmsg('u')
    #檢查是否有更改的權限
    MESSAGE ""

    LET g_forupd_sql = "SELECT * FROM apz_file WHERE apz00 = '0' FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE apz_curl CURSOR FROM g_forupd_sql

    BEGIN WORK
    OPEN apz_curl
    IF STATUS  THEN CALL cl_err('OPEN apz_curl',STATUS,1) RETURN END IF
    FETCH apz_curl INTO g_apz.*
    IF STATUS  THEN CALL cl_err('',STATUS,0) RETURN END IF
    LET g_apz_t.* = g_apz.*
    LET g_apz_o.* = g_apz.*
    DISPLAY BY NAME g_apz.apz01,g_apz.apz02,g_apz.apz02p,g_apz.apz02b,g_apz.apz02c,    #FUN-680029
                    g_apz.apz03,g_apz.apz04,g_apz.apz04p,g_apz.apz07,
                    g_apz.apz56,g_apz.apz57,
                    g_apz.apz12,g_apz.apz13,g_apz.apz14,
                    #g_apz.apz15,g_apz.apz16,g_apz.apz23,   #TQC-630135
                    g_apz.apz15,g_apz.apz16,   #TQC-630135
                    g_apz.apz71,g_apz.apz72,g_apz.apz73,  #FUN-CB0056 add--apz71,72,73
                    g_apz.apz74,                          #FUN-DA0051
                    #g_apz.apz24,g_apz.apz26,   #TQC-630134
                    #g_apz.apz26,   #TQC-630134    #TQC-A20062
                    g_apz.apz45,g_apz.apz46,g_apz.apz47,
                    g_apz.apz48,g_apz.apz59,g_apz.apz33,  #FUN-640012 add g_apz.apz33
                    g_apz.apz63,g_apz.apz64,g_apz.apz70,g_apz.apz65,g_apz.apz66,g_apz.apz67,g_apz.apz68,g_apz.apz08,              #FUN-970108 add apz63   FUN-A40003 add apz64    #No.FUN-A60024 add apz65,apz66 #No.FUN-A80111 add apz67    FUN-A90007 add apz68#No.FUN-C90027 add apz70
                    g_apz.apz61,    #No.FUN-880094 add
                    g_apz.apz60,g_apz.apz06,g_apz.apz05,
                    g_apz.apz27,g_apz.apz62,g_apz.apz69,g_apz.apz21,g_apz.apz22,   #FUN-920210 add apz62   #No.TQC-B80136 add apz69
                    g_apz.apz42,g_apz.apz31,g_apz.apz32,
                    #g_apz.apz36,g_apz.apz37,   #TQC-630136
                    #g_apz.apz38,g_apz.apz40,g_apz.apz58,   #TQC-630136
                    g_apz.apz40,g_apz.apz58,   #TQC-630136
                    g_apz.apz43,g_apz.apz44,g_apz.apz52,
                    #FUN-B50039-add-str--
                    g_apz.apzud01,g_apz.apzud02,g_apz.apzud03,g_apz.apzud04,g_apz.apzud05,
                    g_apz.apzud06,g_apz.apzud07,g_apz.apzud08,g_apz.apzud09,g_apz.apzud10,
                    g_apz.apzud11,g_apz.apzud12,g_apz.apzud13,g_apz.apzud14,g_apz.apzud15
                    #FUN-B50039-add-end--

    WHILE TRUE
        CALL s100_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           LET g_apz.* = g_apz_t.*
           CALL s100_show()
           EXIT WHILE
        END IF
        UPDATE apz_file SET
                apz01=g_apz.apz01,
                apz02=g_apz.apz02,
                apz02p=g_apz.apz02p,
                apz03=g_apz.apz03,
                apz04=g_apz.apz04,
                apz04p=g_apz.apz04p,
                apz07=g_apz.apz07,
                apz56=g_apz.apz56,
                apz57=g_apz.apz57,
                apz02b=g_apz.apz02b,
                apz02c=g_apz.apz02c,  #FUN-680029
                apz11='2',
                apz12=g_apz.apz12,
                apz13=g_apz.apz13,
                apz14=g_apz.apz14,
                apz15=g_apz.apz15,
                apz16=g_apz.apz16,
                apz71=g_apz.apz71,    #FUN-CB0056
                apz72=g_apz.apz72,    #FUN-CB0056
                apz73=g_apz.apz73,    #FUN-CB0056
                apz74=g_apz.apz74,    #FUN-DA0051
                #apz23=g_apz.apz23,   #TQC-630135
                #apz24=g_apz.apz24,   #TQC-630134
                #apz26=g_apz.apz26,   #TQC-A20062
                apz45=g_apz.apz45,
                apz46=g_apz.apz46,
                apz47=g_apz.apz47,
                apz48=g_apz.apz48,
                apz59=g_apz.apz59,
                apz08=g_apz.apz08,
                apz61=g_apz.apz61,    #No.FUN-880094 add
                apz60=g_apz.apz60,
                apz06=g_apz.apz06,
                apz05=g_apz.apz05,
                apz27=g_apz.apz27,
                apz62=g_apz.apz62,   #FUN-920210 add 
                apz69=g_apz.apz69,   #No.TQC-B80136 add apz69  
                apz21=g_apz.apz21,
                apz22=g_apz.apz22,
                apz42=g_apz.apz42,
                apz31=g_apz.apz31,
                apz32=g_apz.apz32,
                apz33=g_apz.apz33,
                apz34=g_apz.apz34,
                apz35=g_apz.apz35,
                #apz36=g_apz.apz36,   #TQC-630136
                #apz37=g_apz.apz37,   #TQC-630136
                #apz38=g_apz.apz38,   #TQC-630136
                #apz39=g_apz.apz39,   #TQC-630136
                apz40=g_apz.apz40,
                apz58=g_apz.apz58,
                apz43=g_apz.apz43,
                apz44=g_apz.apz44,
                apz52=g_apz.apz52,
                apz63=g_apz.apz63,    #FUN-970108 add
                apz64=g_apz.apz64,    #FUN-A40003 add
                apz70=g_apz.apz70,  #No.FUN-C90027 add apz70
                apz65=g_apz.apz65,    #FUN-A60024 add
                apz66=g_apz.apz66,    #FUN-A60024 add
                apz67=g_apz.apz67,    #FUN-A80111 add
                apz68=g_apz.apz68,    #FUN-A90007 add
                #FUN-B50039-add-str--
                apzud01=g_apz.apzud01,
                apzud02=g_apz.apzud02,
                apzud03=g_apz.apzud03,
                apzud04=g_apz.apzud04,
                apzud05=g_apz.apzud05,
                apzud06=g_apz.apzud06,
                apzud07=g_apz.apzud07,
                apzud08=g_apz.apzud08,
                apzud09=g_apz.apzud09,
                apzud10=g_apz.apzud10,
                apzud11=g_apz.apzud11,
                apzud12=g_apz.apzud12,
                apzud13=g_apz.apzud13,
                apzud14=g_apz.apzud14,
                apzud15=g_apz.apzud15
                #FUN-B50039-add-str--
                
            WHERE apz00='0'
        IF SQLCA.sqlcode THEN
#          CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660122
           CALL cl_err3("upd","apz_file","","",SQLCA.sqlcode,"","",0)  #No.FUN-660122
           CONTINUE WHILE
       #FUN-930164---add---str---
        ELSE
           IF g_flag_56='Y' THEN
              LET g_errno = TIME
              LET g_msg = 'old:',g_apz_t.apz56,' new:',g_apz.apz56
              #INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
              INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
                 #VALUES ('aaps100',g_user,g_today,g_errno,'apz56',g_msg) #FUN-980001 mark
                 VALUES ('aaps100',g_user,g_today,g_errno,'apz56',g_msg,g_plant,g_legal) #FUN-980001 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","azo_file","aaps100","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 CONTINUE WHILE
              END IF
           END IF
           IF g_flag_57='Y' THEN
              LET g_errno = TIME
              LET g_msg = 'old:',g_apz_t.apz57,' new:',g_apz.apz57
              #INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
              INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
                 #VALUES ('aaps100',g_user,g_today,g_errno,'apz57',g_msg) #FUN-980001 mark
                 VALUES ('aaps100',g_user,g_today,g_errno,'apz57',g_msg,g_plant,g_legal) #FUN-980001 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","azo_file","aaps100","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 CONTINUE WHILE
              END IF
           END IF
       #FUN-930164---add---end---
        END IF
        CLOSE apz_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION s100_i()
   DEFINE   l_dbs        LIKE type_file.chr21        #No.FUN-740032
   DEFINE   l_aza        LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
            # Prog. Version..: '5.30.06-13.03.12(01)                    #FUN-660117 remark
            l_apoacti    LIKE apo_file.apoacti,      #FUN-660117
            l_nmcacti    LIKE nmc_file.nmcacti,      #No.TQC-770052
            li_chk_bookno LIKE type_file.num5,       # No.FUN-690028 SMALLINT,   #No.FUN-660141
            l_sql        STRING         #No.FUN-660141
   DEFINE   l_plant      LIKE type_file.chr10        #No.FUN-980020
   DEFINE   l_nmc03     LIKE nmc_file.nmc03           #MOD-9C0387
   DEFINE li_result   LIKE type_file.num5            #No.FUN-A40003
   DEFINE   l_n          LIKE type_file.num5         #No.FUN-A60024
   DEFINE   l_pma11      LIKE pma_file.pma11         #FUN-CB0056
   
   INPUT BY NAME g_apz.apz01,g_apz.apz02,g_apz.apz02p,g_apz.apz02b,g_apz.apz02c,          #FUN-680029
                 g_apz.apz03,g_apz.apz04,g_apz.apz04p,g_apz.apz07,
                 g_apz.apz56,g_apz.apz57,
                 g_apz.apz12,g_apz.apz13,g_apz.apz14,
                 #g_apz.apz15,g_apz.apz16,g_apz.apz23,   #TQC-630135
                 g_apz.apz15,g_apz.apz16,    #TQC-630135
                 g_apz.apz71,g_apz.apz72,g_apz.apz73,  #FUN-CB0056 add--apz71,72,73
                 #g_apz.apz24,g_apz.apz26,   #TQC-630134
                 #g_apz.apz26,   #TQC-630134 #TQC-A20062
                 g_apz.apz45,g_apz.apz46,g_apz.apz47,
                 g_apz.apz48,g_apz.apz59,g_apz.apz33,  #FUN-640012 add g_apz.apz33
                 g_apz.apz63,g_apz.apz68,g_apz.apz64,g_apz.apz70,g_apz.apz65,g_apz.apz66,g_apz.apz67,g_apz.apz08,              #FUN-970108 add apz63 FUN-A40003 add apz64   #No.FUN-A60024 add apz65,apz66  #No.FUN-A80111 add apz67    FUN-A90007 add apz68 #No.FUN-C90027 add apz70
                 g_apz.apz61,    #No.FUN-880094 add
                 g_apz.apz60,g_apz.apz06,g_apz.apz05,
                 g_apz.apz27,g_apz.apz62,g_apz.apz74,g_apz.apz69,g_apz.apz21,g_apz.apz22,  #FUN-920210 add apz62  #No.TQC-B80136 add apz69 #FUN-DA0051 add apz74
                 g_apz.apz31,g_apz.apz32,
                 #g_apz.apz36,g_apz.apz37,   #TQC-630136
                 #g_apz.apz38,g_apz.apz40,g_apz.apz58,g_apz.apz42,   #TQC-630136
                 g_apz.apz40,g_apz.apz58,g_apz.apz42,   #TQC-630136
                 g_apz.apz43,g_apz.apz44,g_apz.apz52,
                 #FUN-B50039-add-str--
                 g_apz.apzud01,g_apz.apzud02,g_apz.apzud03,g_apz.apzud04,g_apz.apzud05,
                 g_apz.apzud06,g_apz.apzud07,g_apz.apzud08,g_apz.apzud09,g_apz.apzud10,
                 g_apz.apzud11,g_apz.apzud12,g_apz.apzud13,g_apz.apzud14,g_apz.apzud15
                 #FUN-B50039-add-end--
                 WITHOUT DEFAULTS


      BEFORE INPUT               #FUN-930164 add
         LET g_flag_56 = 'N'     #FUN-930164 add
         LET g_flag_57 = 'N'     #FUN-930164 add
         #No.TQC-A20064  --Begin
         LET g_before_input_done = FALSE
         CALL s100_set_entry()
         CALL s100_set_no_entry()
         LET g_before_input_done = TRUE
         #No.TQC-A20064  --End
         #--FUN-970108 start--
         CALL s100_set_no_required()
         CALL s100_set_required()
         #--FUN-970108 end---
         #TQC-B90081  --begin
         IF cl_null(g_apz.apz69) THEN
            LET g_apz.apz69 = 'N'
            DISPLAY BY NAME g_apz.apz69
         END IF
         #TQC-B90081  --end

      AFTER FIELD apz01
         IF NOT cl_null(g_apz.apz01) THEN
            IF g_apz.apz01 NOT MATCHES '[YN]' THEN
               LET g_apz.apz01=g_apz_o.apz01
               DISPLAY BY NAME g_apz.apz01
               NEXT FIELD apz01
            END IF
         END IF
         LET g_apz_o.apz01=g_apz.apz01

      AFTER FIELD apz02
         IF NOT cl_null(g_apz.apz02) THEN
            IF g_apz.apz02 NOT MATCHES "[YN]" THEN
               LET g_apz.apz02=g_apz_o.apz02
               DISPLAY BY NAME g_apz.apz02
               NEXT FIELD apz02
            END IF
         END IF
         LET g_apz_o.apz02=g_apz.apz02
#TQC-5B0086
        CALL cl_set_comp_entry("apz02p,apz02b,apz02c",TRUE)                     #FUN-680029
        IF g_apz.apz02 = 'N' THEN
           CALL cl_set_comp_entry("apz02p,apz02b,apz02c",FALSE)                 #FUN-680029
           LET g_apz.apz02p=''
           LET g_apz.apz02b=''
           LET g_apz.apz02c=''                                                  #FUN-680029
           DISPLAY BY NAME g_apz.apz02p,g_apz.apz02b,g_apz.apz02c               #FUN-680029
        END IF
#END TQC-5B0086

      AFTER FIELD apz02p
         IF NOT cl_null(g_apz.apz02p) THEN
            #FUN-990031--add--str--營運中心要控制在同一法人下
            #SELECT count(*) INTO g_cnt FROM azp_file WHERE azp01 = g_apz.apz02p
            SELECT count(*) INTO g_cnt FROM azw_file WHERE azw01 = g_apz.apz02p
               AND azw02 = g_legal
            #FUN-990031--end
            IF g_cnt = 0 THEN
               CALL cl_err('sel_azw','agl-171',0)   #FUN-990031
               #CALL cl_err('',100,0)    #FUN-990031
               LET g_apz.apz02p=g_apz_o.apz02p
               DISPLAY BY NAME g_apz.apz02p
               NEXT FIELD apz02p
            END IF
#TQC-5B0086
        ELSE
           IF g_apz.apz02 = 'Y' THEN
              CALL cl_err('','aap-099',0)
              NEXT FIELD apz02p
           END IF
#END TQC-5B0086
         END IF
         #No.FUN-740032  --Begin
         LET l_dbs = NULL
         LET l_plant = g_apz.apz02p                    #FUN-980020
         SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=g_apz.apz02p
         LET t_dbss = l_dbs
         LET l_dbs = s_dbstring(l_dbs CLIPPED) #FUN-9B0106

         CALL s_get_bookno1(NULL,l_plant)              #FUN-980020
#        CALL s_get_bookno1(NULL,l_dbs)                #FUN-980020 mark
              RETURNING g_flag,g_bookno1,g_bookno2
         IF g_flag =  '1' THEN  #抓不到帳別
            CALL cl_err(l_dbs,'aoo-081',1)
            NEXT FIELD apz02p
         END IF
         #No.FUN-740032  --End
         LET g_apz_o.apz02p=g_apz.apz02p

      AFTER FIELD apz02b
         IF NOT cl_null(g_apz.apz02b) THEN
             #No.FUN-660141--begin
           CALL s_check_bookno(g_apz.apz02b,g_user,g_apz.apz02p)
                RETURNING li_chk_bookno
           IF (NOT li_chk_bookno) THEN
              NEXT FIELD apz02b
           END IF
           LET g_plant_new=  g_apz.apz02p   # 工廠編號
           CALL s_getdbs()
           LET l_sql = "SELECT count(*) ",
                  #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                   "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                   " WHERE aaa01 = '",g_apz.apz02b,"' ",
                   "   AND aaaacti = 'Y' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
           PREPARE p100_pre2 FROM l_sql
           DECLARE p100_cur2 CURSOR FOR p100_pre2
           OPEN p100_cur2
           FETCH p100_cur2 INTO g_cnt
#            SELECT count(*) INTO g_cnt FROM aaa_file WHERE aaa01 = g_apz.apz02b
           #No.FUN-660141--end
           IF g_cnt = 0 THEN
               CALL cl_err(g_apz.apz02b,'agl-043',0)
               LET g_apz.apz02b=NULL
               DISPLAY BY NAME g_apz.apz02b
               NEXT FIELD apz02b
           END IF
#FUN-680029--begin
           IF NOT cl_null(g_apz.apz02c) THEN
               IF g_apz.apz02b = g_apz.apz02c THEN
                  CALL cl_err(g_apz.apz02b,'afa-888',0)
                  NEXT FIELD apz02b
               END IF
           END IF
           #No.FUN-740032  --Begin
           IF g_apz.apz02b <> g_bookno1 THEN
              CALL cl_err(g_apz.apz02b,"axc-531",1)
           END IF
           #No.FUN-740032  --End
#FUN-680029--end
#TQC-5B0086
         ELSE
           IF g_apz.apz02 = 'Y' THEN
              CALL cl_err('','aap-099',0)
              NEXT FIELD apz02b
           END IF
#END TQC-5B0086
         END IF
         LET g_apz_o.apz02b=g_apz.apz02b

#FUN-680029--begin
      AFTER FIELD apz02c
         IF NOT cl_null(g_apz.apz02c) THEN
           CALL s_check_bookno(g_apz.apz02c,g_user,g_apz.apz02p)
                RETURNING li_chk_bookno
           IF (NOT li_chk_bookno) THEN
              NEXT FIELD apz02c
           END IF
           LET g_plant_new=  g_apz.apz02p   # 工廠編號
           CALL s_getdbs()
           LET l_sql = "SELECT count(*) ",
                   #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                   "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                   " WHERE aaa01 = '",g_apz.apz02c,"' ",
                   "   AND aaaacti = 'Y' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
           PREPARE p100_pre3 FROM l_sql
           DECLARE p100_cur3 CURSOR FOR p100_pre3
           OPEN p100_cur3
           FETCH p100_cur3 INTO g_cnt
           IF g_cnt = 0 THEN
               CALL cl_err(g_apz.apz02c,'agl-043',0)
               LET g_apz.apz02c=NULL
               DISPLAY BY NAME g_apz.apz02c
               NEXT FIELD apz02c
            END IF
#FUN-680029--begin
            IF NOT cl_null(g_apz.apz02b) THEN
               IF g_apz.apz02c  = g_apz.apz02b   THEN
                  CALL cl_err(g_apz.apz02c ,'afa-888',0)
                  NEXT FIELD apz02c
               END IF
            END IF
            #No.FUN-740032  --Begin
            IF g_apz.apz02c <> g_bookno2 THEN
               CALL cl_err(g_apz.apz02c,"axc-531",1)
            END IF
            #No.FUN-740032  --End
#FUN-680029--end
         ELSE
           IF g_apz.apz02 = 'Y' THEN
              CALL cl_err('','aap-099',0)
              NEXT FIELD apz02c
           END IF
         END IF
         LET g_apz_o.apz02c=g_apz.apz02c
#FUN-680029--end

      AFTER FIELD apz03
         IF NOT cl_null(g_apz.apz01) THEN
            IF g_apz.apz03 NOT MATCHES "[YN]" THEN
               LET g_apz.apz03=g_apz_o.apz03
               DISPLAY BY NAME g_apz.apz03
               NEXT FIELD apz03
            END IF
         END IF
         LET g_apz_o.apz03=g_apz.apz03

      AFTER FIELD apz04
         IF NOT cl_null(g_apz.apz01) THEN
            IF g_apz.apz04 NOT MATCHES "[YN]" THEN
               LET g_apz.apz04=g_apz_o.apz04
               DISPLAY BY NAME g_apz.apz04
               NEXT FIELD apz04
            END IF
         END IF
         LET g_apz_o.apz04=g_apz.apz04

      AFTER FIELD apz04p
         IF NOT cl_null(g_apz.apz01) THEN
            #FUN-990031--add--str--營運中心要控制在同一法人下
            #SELECT count(*) INTO g_cnt FROM azp_file WHERE azp01 = g_apz.apz04p
            SELECT count(*) INTO g_cnt FROM azw_file WHERE azw01 = g_apz.apz04p
               AND azw02 = g_legal
            #FUN-990031--end
            IF g_cnt = 0 THEN
               CALL cl_err('sel_azw','agl-171',0)   #FUN-990031
               #CALL cl_err('',100,0)   #FUN-990031
               LET g_apz.apz04p=g_apz_o.apz04p
               DISPLAY BY NAME g_apz.apz04p
               NEXT FIELD apz04p
            END IF
         END IF
         LET g_apz_o.apz04p=g_apz.apz04p

      #No.TQC-770052 --start--
      AFTER FIELD apz56
         IF NOT cl_null(g_apz.apz56) THEN
            IF g_apz.apz56 < 0 THEN
               CALL cl_err('','mfg4012',0)
               NEXT FIELD apz56
            END IF
           #FUN-930164---add---str---
            IF g_apz.apz56 <> g_apz_t.apz56 THEN
               LET g_flag_56='Y'
            END IF
           #FUN-930164---add---end---
         END IF
      #No.TQC-770052 --end--

     #FUN-930164---add---str---
      AFTER FIELD apz57
         IF g_apz.apz57 <> g_apz_t.apz57 THEN
            LET g_flag_57='Y'
         END IF
     #FUN-930164---add---end---

      AFTER FIELD apz07
         IF NOT cl_null(g_apz.apz01) THEN
            IF g_apz.apz07 NOT MATCHES "[YN]" THEN
               LET g_apz.apz07=g_apz_o.apz07
               DISPLAY BY NAME g_apz.apz07
               NEXT FIELD apz07
            END IF
         END IF
         LET g_apz_o.apz07=g_apz.apz07

      AFTER FIELD apz12
         IF NOT cl_null(g_apz.apz12) THEN
            LET l_apoacti = NULL     #No.TQC-770052
            SELECT apoacti INTO l_apoacti FROM apo_file WHERE apo01 = g_apz.apz12
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_apz.apz12,'aap-003',0)   #No.FUN-660122
               CALL cl_err3("sel","apo_file",g_apz.apz12,"","aap-003","","",0)  #No.FUN-660122
               LET g_apz.apz12=g_apz_o.apz12
               DISPLAY BY NAME g_apz.apz12
               NEXT FIELD apz12
            END IF
            #No.TQC-770052 --start--
            IF l_apoacti = 'N' THEN
               CALL cl_err('','mfg0301',0)
               NEXT FIELD apz12
            END IF
            #No.TQC-770052 --end--
         END IF
         LET g_apz_o.apz12=g_apz.apz12

      AFTER FIELD apz13
         IF NOT cl_null(g_apz.apz13) THEN
            IF g_apz.apz13 NOT MATCHES "[YN]" THEN
               LET g_apz.apz13=g_apz_o.apz13
               DISPLAY BY NAME g_apz.apz13
               NEXT FIELD apz13
            END IF
         END IF
         LET g_apz_o.apz13=g_apz.apz13

      AFTER FIELD apz14
         IF NOT cl_null(g_apz.apz14) THEN
            IF g_apz.apz14 NOT MATCHES "[YN]" THEN
               LET g_apz.apz14=g_apz_o.apz14
               DISPLAY BY NAME g_apz.apz14
               NEXT FIELD apz14
            END IF
         END IF
         LET g_apz_o.apz14=g_apz.apz14

      AFTER FIELD apz15
         IF NOT cl_null(g_apz.apz15) THEN
            IF g_apz.apz15 NOT MATCHES "[YN]" THEN
               LET g_apz.apz15=g_apz_o.apz15
               DISPLAY BY NAME g_apz.apz15
               NEXT FIELD apz15
            END IF
         END IF
         LET g_apz_o.apz15=g_apz.apz15

      AFTER FIELD apz16
         IF NOT cl_null(g_apz.apz16) THEN
            IF g_apz.apz16 NOT MATCHES "[YN]" THEN
               LET g_apz.apz16=g_apz_o.apz16
               DISPLAY BY NAME g_apz.apz16
               NEXT FIELD apz16
            END IF
         END IF
         LET g_apz_o.apz16=g_apz.apz16

       #FUN-CB0056---add---str
      AFTER FIELD apz71    #零用金默认付款条件
         IF NOT cl_null(g_apz.apz71) THEN
            SELECT pma11 INTO l_pma11 FROM pma_file
             WHERE pma01 = g_apz.apz71
            IF STATUS THEN
               CALL cl_err3("sel","pma_file",g_apz.apz71,"",STATUS,"","sel pma:",0)
               NEXT FIELD apz71
            END IF
         END IF
         LET g_apz_o.apz71=g_apz.apz71

       AFTER FIELD apz72     #零用金默认還款銀行
          IF NOT cl_null(g_apz.apz72) THEN
             CALL s100_apz72()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_apz.apz72,g_errno,0)
                NEXT FIELD apz72
             END IF
         END IF
         LET g_apz_o.apz72=g_apz.apz72

      AFTER FIELD apz73       #零用金默认還款異動碼
         IF NOT cl_null(g_apz.apz73) THEN
            CALL s100_apz73()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_apz.apz73,g_errno,0)
               NEXT FIELD apz73
            END IF
         END IF
         LET g_apz_o.apz73=g_apz.apz73
      #FUN-CB0056---add--end
      #-----TQC-630135---------
      #AFTER FIELD apz23
      #   IF NOT cl_null(g_apz.apz23) THEN
      #      IF g_apz.apz23 NOT MATCHES "[YN]" THEN
      #         LET g_apz.apz23=g_apz_o.apz23
      #         DISPLAY BY NAME g_apz.apz23
      #         NEXT FIELD apz23
      #      END IF
      #   END IF
      #   LET g_apz_o.apz23=g_apz.apz23
      #-----END TQC-630135-----

      #-----TQC-630134---------
      #AFTER FIELD apz24
      #   IF NOT cl_null(g_apz.apz24) THEN
      #      IF g_apz.apz24 NOT MATCHES "[YN]" THEN
      #         LET g_apz.apz24=g_apz_o.apz24
      #         DISPLAY BY NAME g_apz.apz24
      #         NEXT FIELD apz24
      #      END IF
      #   END IF
      #   LET g_apz_o.apz24=g_apz.apz24
      #-----END TQC-630134-----

     #TQC-A20062--mark--str--
     #AFTER FIELD apz26
     #   IF NOT cl_null(g_apz.apz26) THEN
     #      IF g_apz.apz26 NOT MATCHES "[YN]" THEN
     #         LET g_apz.apz26=g_apz_o.apz26
     #         DISPLAY BY NAME g_apz.apz26
     #         NEXT FIELD apz26
     #      END IF
     #   END IF
     #   LET g_apz_o.apz26=g_apz.apz26
     #TQC-A20062

      AFTER FIELD apz59
         IF NOT cl_null(g_apz.apz59) THEN
            IF g_apz.apz59 NOT MATCHES "[YN]" THEN
               LET g_apz.apz59=g_apz_o.apz59
               DISPLAY BY NAME g_apz.apz59
               NEXT FIELD apz59
            END IF
         END IF
         LET g_apz_o.apz59=g_apz.apz59

      #FUN-970108---Begin
      AFTER FIELD apz63
         IF NOT cl_null(g_apz.apz63) THEN
            SELECT COUNT(*) INTO g_cnt FROM ama_file
             WHERE ama02 = g_apz.apz63
              IF g_cnt = 0 THEN
                 CALL cl_err("","mfg9329",1) 
                 NEXT FIELD apz63                     #TQC-A60123 Add
              END IF
              #IF g_aza.aza21 = 'Y' OR NOT s_chkban(g_apz.apz63) THEN #FUN-990053 mod #TQC-B40067
              IF g_aza.aza21 = 'Y' AND  NOT s_chkban(g_apz.apz63) THEN #TQC-B40067
                 NEXT FIELD apz63
              END IF
         ELSE
         	    IF g_aza.aza94 = 'Y' THEN
           	     CALL cl_err('apz63 is null: ','aap-099',0)
           	     NEXT FIELD apz63
           	  END IF
         END IF
      #FUN-970108---End
#No.FUN-A40003 --begin
     AFTER FIELD apz64 
         IF NOT cl_null(g_apz.apz64) THEN 
            IF g_apz.apz64 != g_apz_t.apz64 OR g_apz_t.apz64 IS NULL THEN
               CALL s_check_no("aap",g_apz.apz64,g_apz_t.apz64,"12","apa_file","apa01","")
               RETURNING li_result,g_apz.apz64
               DISPLAY BY NAME g_apz.apz64
               IF (NOT li_result) THEN
                  LET g_apz.apz64=g_apz_o.apz64
                  NEXT FIELD apz64
               END IF
            END IF
            IF g_apz.apz68 ='Y' THEN 
               SELECT COUNT(*) INTO l_n FROM apy_file WHERE apyacti = 'Y' AND apyslip = g_apz.apz64 AND apydmy3 ='Y'
               IF l_n =0 THEN 
                  CALL cl_err(g_apz.apz64,'aap-940',1)
                  LET g_apz.apz64=g_apz_o.apz64
                  NEXT FIELD apz68
               END IF 
            ELSE 
               SELECT COUNT(*) INTO l_n FROM apy_file WHERE apyacti = 'Y' AND apyslip = g_apz.apz64 AND apydmy3 ='N'
               IF l_n =0 THEN 
                  CALL cl_err(g_apz.apz64,'aap-941',1)
                  LET g_apz.apz64=g_apz_o.apz64
                  NEXT FIELD apz68
               END IF 
          	END IF 
         END IF  
#No.FUN-A40003 --end
#No.FUN-C90027--BEGIN
      AFTER FIELD apz70
         IF NOT cl_null(g_apz.apz70) THEN
            IF g_apz.apz70 != g_apz_t.apz70 OR g_apz_t.apz70 IS NULL THEN
               CALL s_check_no("aap",g_apz.apz70,g_apz_t.apz70,"22","apa_file","apa01","")
               RETURNING li_result,g_apz.apz70
               DISPLAY BY NAME g_apz.apz70
               IF (NOT li_result) THEN
                  LET g_apz.apz70=g_apz_o.apz70
                  NEXT FIELD apz70
               END IF
            END IF
#No.MOD-D40226 --begin
            IF g_apz.apz68 ='Y' THEN 
               SELECT COUNT(*) INTO l_n FROM apy_file WHERE apyacti = 'Y' AND apyslip = g_apz.apz70 AND apydmy3 ='Y'
               IF l_n =0 THEN 
                  CALL cl_err(g_apz.apz70,'aap-940',1)
                  LET g_apz.apz70=g_apz_o.apz70
                  NEXT FIELD apz68
               END IF 
            ELSE 
               SELECT COUNT(*) INTO l_n FROM apy_file WHERE apyacti = 'Y' AND apyslip = g_apz.apz70 AND apydmy3 ='N'
               IF l_n =0 THEN 
                  CALL cl_err(g_apz.apz70,'aap-941',1)
                  LET g_apz.apz70=g_apz_o.apz70
                  NEXT FIELD apz68
               END IF 
          	END IF 
#No.MOD-D40226 --end
         END IF

#No.FUN-C90027--END
#No.FUN-A60024 --begin
      AFTER FIELD apz65 
         IF NOT cl_null(g_apz.apz65) THEN 
            IF g_apz.apz65 != g_apz_t.apz65 OR g_apz_t.apz65 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM apw_file WHERE apw01 = g_apz.apz65
               IF l_n =0 THEN
                  CALL cl_err(g_apz.apz65,"aap-974",1)
                  LET g_apz.apz65 = g_apz_o.apz65
                  NEXT FIELD apz65 
               END IF 
            END IF
         END IF 

      AFTER FIELD apz66 
         IF NOT cl_null(g_apz.apz66) THEN 
            IF g_apz.apz66 != g_apz_t.apz66 OR g_apz_t.apz66 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM apt_file WHERE apt01 = g_apz.apz66
               IF l_n =0 THEN
                  CALL cl_err(g_apz.apz66,"aap-668",1)
                  LET g_apz.apz66 = g_apz_o.apz66
                  NEXT FIELD apz66 
               END IF 
            END IF
         END IF 
#No.FUN-A60024 --end
#No.FUN-A80111 --begin
      AFTER FIELD apz67 
         IF NOT cl_null(g_apz.apz67) THEN 
            #No.MOD-B60117--add--
            IF g_apz.apz67 != g_apz_t.apz67 OR g_apz_t.apz67 IS NULL THEN
               CALL s_check_no("aap",g_apz.apz67,g_apz_t.apz67,"12","apa_file","apa01","")
               RETURNING li_result,g_apz.apz67
               DISPLAY BY NAME g_apz.apz67
               IF (NOT li_result) THEN
                  LET g_apz.apz67=g_apz_o.apz67
                  NEXT FIELD apz67
               END IF
            END IF
            #No.MOD-B60117--end--
            IF g_apz.apz67 != g_apz_t.apz67 OR g_apz_t.apz67 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM apy_file WHERE apyslip = g_apz.apz67
                                                        AND apykind='12' and apydmy3='N'    #TQC-C60172  add  
               IF l_n =0 THEN
                  CALL cl_err(g_apz.apz67,"aap-668",1)
                  LET g_apz.apz67 = g_apz_o.apz67
                  NEXT FIELD apz67 
               END IF 
            END IF
         END IF 
#No.FUN-A80111 --end
#No.FUN-A90007 --begin
       AFTER FIELD apz68
         IF NOT cl_null(g_apz.apz68) THEN 
            IF g_apz.apz68 NOT MATCHES '[YyNn]' THEN
               NEXT FIELD apz68
            END IF
         ELSE 
         	  NEXT FIELD apz68
         END IF         
#No.FUN-A90007 --end
      AFTER FIELD apz08
         IF NOT cl_null(g_apz.apz08) THEN
            IF g_apz.apz08 NOT MATCHES "[123]" THEN
               LET g_apz.apz08=g_apz_o.apz08
               DISPLAY BY NAME g_apz.apz08
               NEXT FIELD apz08
            END IF
         END IF
         LET g_apz_o.apz08=g_apz.apz08

      #No.FUN-880094---Begin
      AFTER FIELD apz61
         IF NOT cl_null(g_apz.apz61) THEN
            IF g_apz.apz61 NOT MATCHES "[123]" THEN
               LET g_apz.apz61=g_apz_o.apz61
               DISPLAY BY NAME g_apz.apz61
               NEXT FIELD apz61
            END IF
         END IF
         LET g_apz_o.apz61=g_apz.apz61
      #No.FUN-880094---End

      AFTER FIELD apz60
         IF NOT cl_null(g_apz.apz60) THEN
            IF g_apz.apz60 NOT MATCHES "[YN]" THEN
               LET g_apz.apz60=g_apz_o.apz60
               DISPLAY BY NAME g_apz.apz60
               NEXT FIELD apz60
            END IF
         END IF
         LET g_apz_o.apz60=g_apz.apz60

      AFTER FIELD apz06
         IF NOT cl_null(g_apz.apz06) THEN
            IF g_apz.apz06 NOT MATCHES "[YN]" THEN
               LET g_apz.apz06=g_apz_o.apz06
               DISPLAY BY NAME g_apz.apz06
               NEXT FIELD apz06
            END IF
         END IF
         LET g_apz_o.apz06=g_apz.apz06

      #No.TQC-A20064  --Begin
      BEFORE FIELD apz05
         CALL s100_set_entry()
      #No.TQC-A20064  --End

      AFTER FIELD apz05
         IF NOT cl_null(g_apz.apz05) THEN
            IF g_apz.apz05 NOT MATCHES "[YN]" THEN
               LET g_apz.apz05=g_apz_o.apz05
               DISPLAY BY NAME g_apz.apz05
               NEXT FIELD apz05
            END IF
         END IF
         #No.TQC-A20064  --Begin
         CALL s100_set_no_entry()
         #No.TQC-A20064  --End
         LET g_apz_o.apz05=g_apz.apz05

      AFTER FIELD apz27
         IF NOT cl_null(g_apz.apz27) THEN
            IF g_apz.apz27 NOT MATCHES "[YN]" THEN
               LET g_apz.apz27=g_apz_o.apz27
               DISPLAY BY NAME g_apz.apz27
               NEXT FIELD apz27
            END IF
         END IF
         LET g_apz_o.apz27=g_apz.apz27

  #FUN-920210---add---start---
      AFTER FIELD apz62
         IF NOT cl_null(g_apz.apz62) THEN
            IF g_apz.apz62 NOT MATCHES "[YN]" THEN
               LET g_apz.apz62=g_apz_o.apz62
               DISPLAY BY NAME g_apz.apz62
               NEXT FIELD apz62
            END IF
         END IF
         LET g_apz_o.apz62=g_apz.apz62
#No.TQC-B80136 --begin 
     AFTER FIELD apz69  
         IF NOT cl_null(g_apz.apz69) THEN
            IF g_apz.apz69 NOT MATCHES "[YN]" THEN
               LET g_apz.apz69=g_apz_o.apz69
               DISPLAY BY NAME g_apz.apz69
               NEXT FIELD apz69
            END IF
         END IF
         LET g_apz_o.apz69=g_apz.apz69
#No.TQC-B80136 --end

  #FUN-920210---add---end---

  #   AFTER FIELD apz21
  #      IF cl_null(g_apz.apz21) THEN
  #         LET g_apz.apz21=g_apz_o.apz21
  #         DISPLAY BY NAME g_apz.apz21
  #         NEXT FIELD apz21
  #      END IF
  #      LET g_apz_o.apz21=g_apz.apz21

      AFTER FIELD apz22
         IF NOT cl_null(g_apz.apz22) THEN
            IF g_apz.apz22 < 1 OR g_apz.apz22 > 13 THEN
               LET g_apz.apz22=g_apz_o.apz22
               DISPLAY BY NAME g_apz.apz22
               NEXT FIELD apz22
            END IF
         END IF
         LET g_apz_o.apz22=g_apz.apz22

      AFTER FIELD apz31
         IF NOT cl_null(g_apz.apz31) THEN
            IF g_apz.apz31 NOT MATCHES '[YN]' THEN
               LET g_apz.apz31=g_apz_o.apz31
               DISPLAY BY NAME g_apz.apz31
               NEXT FIELD apz31
            END IF
         END IF
         LET g_apz_o.apz31=g_apz.apz31

      AFTER FIELD apz32
         IF NOT cl_null(g_apz.apz32) THEN
            IF g_apz.apz32 NOT MATCHES "[YN]" THEN
               LET g_apz.apz32=g_apz_o.apz32
               DISPLAY BY NAME g_apz.apz32
               NEXT FIELD apz32
            END IF
         END IF
         LET g_apz_o.apz32=g_apz.apz32

      #-----TQC-630136---------
      #AFTER FIELD apz36
      #   IF NOT cl_null(g_apz.apz36) THEN
      #      IF g_apz.apz36 NOT MATCHES "[YN]" THEN
      #         LET g_apz.apz36=g_apz_o.apz36
      #         DISPLAY BY NAME g_apz.apz36
      #         NEXT FIELD apz36
      #      END IF
      #   END IF
      #   LET g_apz_o.apz36=g_apz.apz36
      #
      #AFTER FIELD apz37
      #   IF NOT cl_null(g_apz.apz37) THEN
      #      IF g_apz.apz37 NOT MATCHES "[YN]" THEN
      #         LET g_apz.apz37=g_apz_o.apz37
      #         DISPLAY BY NAME g_apz.apz37
      #         NEXT FIELD apz37
      #      END IF
      #   END IF
      #   LET g_apz_o.apz37=g_apz.apz37
      #
      #AFTER FIELD apz38
      #   IF NOT cl_null(g_apz.apz38) THEN
      #      IF g_apz.apz38 NOT MATCHES "[YN]" THEN
      #         LET g_apz.apz38=g_apz_o.apz38
      #         DISPLAY BY NAME g_apz.apz38
      #         NEXT FIELD apz38
      #      END IF
      #   END IF
      #   LET g_apz_o.apz38=g_apz.apz38
      #-----END TQC-630136-----

      AFTER FIELD apz40
         IF NOT cl_null(g_apz.apz40) THEN
            IF g_apz.apz40 NOT MATCHES "[YN]" THEN
               LET g_apz.apz40=g_apz_o.apz40
               DISPLAY BY NAME g_apz.apz40
               NEXT FIELD apz40
            END IF
         END IF
         LET g_apz_o.apz40=g_apz.apz40

      #No.TQC-770052 --start--
      AFTER FIELD apz58
         IF NOT cl_null(g_apz.apz58) THEN
            LET l_nmcacti = NULL
            SELECT nmcacti INTO l_nmcacti FROM nmc_file WHERE nmc01 = g_apz.apz58
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","nmc_file",g_apz.apz58,"","anm-024","","",0)
               LET g_apz.apz58=g_apz_o.apz58
               DISPLAY BY NAME g_apz.apz58
               NEXT FIELD apz58
            END IF
            IF l_nmcacti = 'N' THEN
               CALL cl_err('','mfg0301',0)
               NEXT FIELD apz58
            END IF
            #MOD-9C0387---Begin
            SELECT nmc03 INTO l_nmc03 FROM nmc_file
             WHERE nmc01 = g_apz.apz58
            IF l_nmc03 <> '2' THEN
               CALL cl_err(g_apz.apz58,'anm-019',0)
               NEXT FIELD apz58
            END IF
            #MOD-9C0387---End
         END IF
         LET g_apz_o.apz58=g_apz.apz58
      #No.TQC-770052 --end--

      #add 030317 NO.A048
      AFTER FIELD apz42
         IF NOT cl_null(g_apz.apz42) THEN
            IF g_apz.apz42 NOT MATCHES "[123]" THEN
               LET g_apz.apz42=g_apz_o.apz42
               DISPLAY BY NAME g_apz.apz42
               NEXT FIELD apz42
            END IF
         END IF
         LET g_apz_o.apz42=g_apz.apz42

      AFTER FIELD apz43
         IF NOT cl_null(g_apz.apz43) THEN
            IF g_apz.apz43 NOT MATCHES '[012]' THEN
               LET g_apz.apz43=g_apz_o.apz43
               DISPLAY BY NAME g_apz.apz43
               NEXT FIELD apz43
            END IF
         END IF
         LET g_apz_o.apz43=g_apz.apz43

      AFTER FIELD apz44
         IF NOT cl_null(g_apz.apz44) THEN
            IF g_apz.apz44 NOT MATCHES '[012]' THEN
               LET g_apz.apz44=g_apz_o.apz44
               DISPLAY BY NAME g_apz.apz44
               NEXT FIELD apz44
            END IF
         END IF
         LET g_apz_o.apz44=g_apz.apz44

      AFTER FIELD apz52
         IF NOT cl_null(g_apz.apz52) THEN
            IF g_apz.apz52 NOT MATCHES '[12]' THEN
               LET g_apz.apz52=g_apz_o.apz52
               DISPLAY BY NAME g_apz.apz52
               NEXT FIELD apz52
            END IF
         END IF
         LET g_apz_o.apz52=g_apz.apz52
#FUN-B50039-add-str--
      AFTER FIELD apzud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD apzud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD apzud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD apzud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD apzud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD apzud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD apzud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD apzud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD apzud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD apzud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD apzud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD apzud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD apzud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD apzud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD apzud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
#FUN-B50039-add-end--

#TQC-5B0086
     AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT  END IF
        IF g_apz.apz02 = 'Y' THEN
           IF cl_null(g_apz.apz02p) THEN
              CALL cl_err('','aap-099',0)
              NEXT FIELD apz02p
           END IF
           IF cl_null(g_apz.apz02b) THEN
              CALL cl_err('','aap-099',0)
              NEXT FIELD apz02b
           END IF
        END IF
#END TQC-5B0086
#No.TQC-BC0194 --begin
        IF NOT cl_null(g_apz.apz64) THEN 
           IF g_apz.apz68 ='Y' THEN 
              SELECT COUNT(*) INTO l_n FROM apy_file WHERE apyacti = 'Y' AND apyslip = g_apz.apz64 AND apydmy3 ='Y'
              IF l_n =0 THEN 
                 CALL cl_err(g_apz.apz64,'aap-940',1)
                 LET g_apz.apz64=g_apz_o.apz64
                 NEXT FIELD apz68
              END IF 
           ELSE 
              SELECT COUNT(*) INTO l_n FROM apy_file WHERE apyacti = 'Y' AND apyslip = g_apz.apz64 AND apydmy3 ='N'
              IF l_n =0 THEN 
                 CALL cl_err(g_apz.apz64,'aap-941',1)
                 LET g_apz.apz64=g_apz_o.apz64
                 NEXT FIELD apz68
              END IF 
         	END IF 
        END IF
#No.TQC-BC0194 --end
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913


      ON ACTION controlp
         CASE
            WHEN INFIELD(apz02p) #查詢工廠資料檔
               CALL cl_init_qry_var()
               #FUN-990031--add--str--
               #LET g_qryparam.form = "q_azp"
               LET g_qryparam.form = "q_azw"
               LET g_qryparam.where = "azw02 = '",g_legal,"' "
               #FUN-990031--add--end
               LET g_qryparam.default1 = g_apz.apz02p
               CALL cl_create_qry() RETURNING g_apz.apz02p
#               CALL FGL_DIALOG_SETBUFFER( g_apz.apz02p )
               DISPLAY BY NAME g_apz.apz02p
               NEXT FIELD apz02p
            WHEN INFIELD(apz02b) #查詢帳別檔
               CALL cl_init_qry_var()
               #No.FUN-740032  --Begin
#              LET g_qryparam.form = "q_aaa"
               LET g_qryparam.form = "q_m_aaa"
               LET g_qryparam.default1 = g_apz.apz02b
#              LET g_qryparam.arg1 = t_dbss          #No.FUN-980025 mark
               LET g_qryparam.plant = g_apz.apz02p   #No.FUN-980025 add
               #No.FUN-740032  --End
               CALL cl_create_qry() RETURNING g_apz.apz02b
#               CALL FGL_DIALOG_SETBUFFER( g_apz.apz02b )
               DISPLAY BY NAME g_apz.apz02b
               NEXT FIELD apz02b
#FUN-680029--begin
            WHEN INFIELD(apz02c) #查詢帳別檔
               CALL cl_init_qry_var()
               #No.FUN-740032  --Begin
#              LET g_qryparam.form = "q_aaa"
               LET g_qryparam.form = "q_m_aaa"
               LET g_qryparam.default1 = g_apz.apz02c
#              LET g_qryparam.arg1 = t_dbss          #No.FUN-980025 mark
               LET g_qryparam.plant = g_apz.apz02p   #No.FUN-980025 add
               #No.FUN-740032  --End
               CALL cl_create_qry() RETURNING g_apz.apz02c
               DISPLAY BY NAME g_apz.apz02c
               NEXT FIELD apz02c
#FUN-680029--end
            WHEN INFIELD(apz04p) #查詢工廠資料檔
               CALL cl_init_qry_var()
               #FUN-990031--add--str--
               #LET g_qryparam.form = "q_azp"
               LET g_qryparam.form = "q_azw"
               LET g_qryparam.where = "azw02 = '",g_legal,"' "
               #FUN-990031--add--end
               LET g_qryparam.default1 = g_apz.apz04p
               CALL cl_create_qry() RETURNING g_apz.apz04p
#               CALL FGL_DIALOG_SETBUFFER( g_apz.apz04p )
               DISPLAY BY NAME g_apz.apz04p
               NEXT FIELD apz04p
            WHEN INFIELD(apz12) #HOLD CODE
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_apo"
               LET g_qryparam.default1 = g_apz.apz12
               CALL cl_create_qry() RETURNING g_apz.apz12
#               CALL FGL_DIALOG_SETBUFFER( g_apz.apz12 )
               DISPLAY BY NAME g_apz.apz12
            #FUN-970108---Begin
            WHEN INFIELD(apz63)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ama02"
               LET g_qryparam.default1 = g_apz.apz63
               CALL cl_create_qry() RETURNING g_apz.apz63
               DISPLAY BY NAME g_apz.apz63
               NEXT FIELD apz63
            #FUN-970108---End
#No.FUN-A40003 --begin
            WHEN INFIELD(apz64)
               CALL q_apy(FALSE,FALSE,g_apz.apz64,'12','AAP') RETURNING g_apz.apz64    #No.FUN-A90007 add 'aapt335'
               DISPLAY BY NAME g_apz.apz64
               NEXT FIELD apz64
#No.FUN-A40003 --end
#No.FUN-A60024 --begin
            WHEN INFIELD(apz65)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_apw"
               LET g_qryparam.arg1 = g_bookno1   
               LET g_qryparam.default1 = g_apz.apz65
               CALL cl_create_qry() RETURNING g_apz.apz65
               NEXT FIELD apz65
            WHEN INFIELD(apz66)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_apt01"
               LET g_qryparam.default1 = g_apz.apz66
               CALL cl_create_qry() RETURNING g_apz.apz66
               NEXT FIELD apz66
#No.FUN-A60024 --end
#No.FUN-C90027 --begin
            WHEN INFIELD(apz70)
               CALL q_apy(FALSE,FALSE,g_apz.apz70,'22','AAP') RETURNING g_apz.apz70    
               DISPLAY BY NAME g_apz.apz70
               NEXT FIELD apz70
#FUN-C90027--end
#No.FUN-A80111 --begin
            WHEN INFIELD(apz67)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_apy5"
               LET g_qryparam.default1 = g_apz.apz67
               CALL cl_create_qry() RETURNING g_apz.apz67
               NEXT FIELD apz67
#No.FUN-A80111 --end
            WHEN INFIELD(apz58) #HOLD CODE
               CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_nmc"  #MOD-9C0387
               LET g_qryparam.form = "q_nmc1"  #MOD-9C0387
               LET g_qryparam.default1 = g_apz.apz58
               CALL cl_create_qry() RETURNING g_apz.apz58
#               CALL FGL_DIALOG_SETBUFFER(g_apz.apz58)
               DISPLAY BY NAME g_apz.apz58
            #FUN-CB0056---add---str
             WHEN INFIELD(apz71) #零用金默认付款条件
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pma"
               LET g_qryparam.default1 = g_apz.apz71
               CALL cl_create_qry() RETURNING g_apz.apz71
               DISPLAY BY NAME g_apz.apz71
             WHEN INFIELD(apz72)   #還款銀行
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_nma"
               IF g_aza.aza26!='2' THEN
                  LET g_qryparam.where ="nma28 !=1 and nma37 !=0 "
               ELSE
                  LET g_qryparam.where ="nma37 !=0 "
               END IF
               LET g_qryparam.default1 = g_apz.apz72
               CALL cl_create_qry() RETURNING g_apz.apz72
               DISPLAY BY NAME g_apz.apz72
            WHEN INFIELD(apz73)   #還款異動碼
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_nmc"
               LET g_qryparam.where =" nmc03='1'"
               LET g_qryparam.default1 = g_apz.apz73
               CALL cl_create_qry() RETURNING g_apz.apz73
               DISPLAY BY NAME g_apz.apz73
             #FUN-CB0056---add--end 
            OTHERWISE EXIT CASE
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

FUNCTION s100_y()
 # Prog. Version..: '5.30.06-13.03.12(01)            #FUN-660117 remark
 DEFINE   l_apz01 LIKE apz_file.apz01  #FUN-660117
     SELECT apz01 INTO l_apz01 FROM apz_file WHERE apz00='0'
     IF l_apz01 = 'Y' THEN RETURN END IF
     UPDATE apz_file SET apz01='Y' WHERE apz00='0'
     IF STATUS THEN
        LET g_apz.apz01='N'
#       CALL cl_err('upd apz01:',STATUS,0)   #No.FUN-660122
        CALL cl_err3("upd","apz_file","","",STATUS,"","upd apz01:",0)  #No.FUN-660122
     ELSE
        LET g_apz.apz01='Y'
     END IF
     DISPLAY BY NAME g_apz.apz01
END FUNCTION

#--FUN-970108 start-----
FUNCTION s100_set_no_required()

  CALL cl_set_comp_required("apz63",FALSE)

END FUNCTION
FUNCTION s100_set_required()

   IF g_aza.aza94 = 'Y' THEN
      CALL cl_set_comp_required("apz63",TRUE)
   END IF
END FUNCTION
#--FUN-970108 end----------------

#No.TQC-A20064  --Begin
FUNCTION s100_set_entry()

   IF INFIELD(apz05) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("apz06",TRUE)
   END IF

END FUNCTION

FUNCTION s100_set_no_entry()

   IF INFIELD(apz05) OR (NOT g_before_input_done) THEN
      IF g_apz.apz05 = "N" THEN
         LET g_apz.apz06 = 'N'
         DISPLAY BY NAME g_apz.apz06
         CALL cl_set_comp_entry("apz06",FALSE)
      END IF
   END IF
END FUNCTION
#No.TQC-A20064  --End

#FUN-CB0056---add----str
#零用金默认还款银行
FUNCTION s100_apz72()
   DEFINE l_nma28   LIKE nma_file.nma28
   DEFINE l_nma37   LIKE nma_file.nma37
   DEFINE l_nmaacti LIKE nma_file.nmaacti

   LET g_errno = ' '
   SELECT nma28,nma37,nmaacti INTO l_nma28,l_nma37,l_nmaacti
     FROM nma_file
    WHERE nma01 = g_apz.apz72

   CASE WHEN SQLCA.SQLCODE = 100     LET g_errno = 'aap-007'
        WHEN l_nmaacti = 'N'         LET g_errno = 'anm-017'
        WHEN l_nma28 ='1' OR l_nma37  ='0'
           IF g_aza.aza26!='2' THEN
              LET g_errno = 'aap-601'
           ELSE
              IF l_nma37  ='0' THEN
                 LET g_errno = 'aap-601'
              END IF
           END IF
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE

END FUNCTION

#零用金默认还款异动码
FUNCTION s100_apz73()
   DEFINE l_nmc03   LIKE nmc_file.nmc03
   DEFINE l_nmcacti LIKE nmc_file.nmcacti

   LET g_errno = ' '
   SELECT nmc03,nmcacti INTO l_nmc03,l_nmcacti
     FROM nmc_file
    WHERE nmc01 = g_apz.apz73

   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-024'
        WHEN l_nmc03 = '2'       LET g_errno = 'anm-019'
        WHEN l_nmcacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
END FUNCTION
#FUN-CB0056---add----end

