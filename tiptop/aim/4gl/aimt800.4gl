# Prog. Version..: '5.30.06-13.04.11(00010)'     #
#
# Pattern name...: aimt800.4gl
# Descriptions...: 盤點標簽重新計算作業
# Date & Author..: 93/05/24 By Apple
# Modify.........: 97/07/24 By Melody 1.新增開窗挑選產生條件範圍
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-480110 04/08/11 By Nicola Message下加入CALL ui.Interface.refresh()
# Modify.........: No.MOD-4C0176 04/12/30 By Melody 1.OUTER 替換錯誤(oracle) 2. l_sql 加上 img10>0的判斷有誤
# Modify.........: No.FUN-570082 05/07/18 By Carrier 多單位內容修改
# Modify.........: No.MOD-560202 05/07/15 By kim INSERT INTO pid_file(&pie_file)有漏
# Modify.........: No.MOD-570320 05/07/26 By kim 排序資料依狀況設定 not null required,拿掉per檔所設的;"生成空白標簽別"不 set null;欄位控管
# Modify.........: No.MOD-570399 05/08/01 By kim 修改"QBE條件的開窗時機"&加入err msg提示
# Modify.........: No.MOD-580005 05/08/23 By Claire 應盤量應計入替代料已發料量
# Modify.........: No.MOD-580322 05/08/30 By wujie  中文資訊修改進 ze_file
# Modify.........: No.FUN-590035 05/09/08 By Nicola 空白標籤，起始號碼可輸可不輸
# Modify.........: No.FUN-5A0199 06/01/05 By Sarah 單號放大至10碼
# Modify.........: NO.MOD-610107 06/01/25 By PENGU 1.FOREACH t800_cs_pia 這個cursor的sql語法是有問題的
#                                                    照成它會把不同倉儲批但料號相同的imgg_file全撈出來
#                                                  2.pia01是由907行的LET g_pia.pia01=tm.tag1,'-',g_estk所產生
#                                                    產生完應再讓l_pia01 = g_pia.pia01
# Modify.........: NO.MOD-610095 06/01/25 By PENGU 1.重算時若原本已存在pia_file只是重新計算庫存量但因該不用累加盤點標籤
#                                                    導致update回標籤別最大號碼時,多了一些空的
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIKE 
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3
# Modify.........: No.FUN-680006 06/08/04 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.CHI-690006 06/12/12 By rainy 1.已產生的標籤號要能重新產生
#                                                  2.如有已過帳的要全部rollback
# Modify.........: No.FUN-760040 07/06/13 By kim MSV環境必須移除ROWID,t800_cexit cursor 需select 出pie07 後續 EXECUTE t800_uppie 需用到pie07
# Modify.........: No.MOD-7C0014 07/12/05 By Pengu CHI-690006修正的BEGIN WORK,沒有加上COMMIT WORK
# Modify.........: No.MOD-7C0193 07/12/25 By Pengu 調整盤點單流水號調整為10碼
# Modify.........: No.TQC-7C0165 07/12/26 By rainy 將begin work移至上層,否則 t800_2()會沒包到
# Modify.........: No.MOD-810134 08/01/17 By Smapmin 不insert 'STK' 以及 'WIP',不default 'STK' 以及 'WIP'
# Modify.........: No.MOD-810010 08/03/05 By Pengu 調整t800_s_piaa的SQL
# Modify.........: No.FUN-870051 08/07/26 By sherry 增加被替代料為Key值
# Modify.........: No.MOD-890059 08/09/04 By claire 記錄程式離開時間
# Modify.........: No.FUN-8A0147 08/11/13 By douzh 新增將庫存資料產生批序號資料
# Modify.........: No.MOD-8C0247 09/01/05 By chenl 增加篩選條件。
# Modify.........: No.MOD-910031 09/01/06 By chenyu 盤點替代料時有處理方式有問題
# Modify.........: No.FUN-980004 09/08/25 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0028 09/11/04 By wujie 5.2SQL转标准语法
# Modify.........: No.CHI-960065 09/11/10 By jan 盤點資料生成時編碼方式采用自動編碼
# Modify.........: No:MOD-A10019 10/01/13 By Pengu 修正MOD-8C0247的調整
# Modify.........: No:MOD-A10008 10/01/13 By Pengu 產生盤點標籤時應排除無效料
# Modify.........: No.FUN-9C0072 10/01/15 By vealxu 精簡程式碼
# Modify.........: No.FUN-A20037 10/03/11 By lilingyu 替代碼sfa26加上"8,Z"的條件
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                   成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/07/02 By vealxu 製造功能優化-平行製程
# Modify.........: No:MOD-A60191 10/07/01 By Sarah 若盤點單號選擇5碼時,要寫入pic06/pic15/pic26/pic36時只取前5碼寫入
# Modify.........: No.FUN-A60095 10/07/19 By kim GP5.25 平行工藝
# Modify.........: No:TQC-A90082 10/09/20 By Carrier 拿掉结束后的PROMPT内容
# Modify.........: No:TQC-AB0036 10/11/09 By suncx sybase第一階段測試BUG修改
# Modify.........: No:TQC-AC0391 10/12/29 By zhangll aimi800->asmi300
# Modify.........: No:MOD-B10045 11/01/06 By sabrina 修改SQL語法
# Modify.........: No.FUN-B30211 11/04/01By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2)
# Modify.........: No:MOD-B50256 11/06/10 By sabrina 修改MOD-A10019的SQL語法
# Modify.........: No:CHI-B10015 11/06/10 By sabrina 在製工單若料號為取替代料，則要抓原先料號的QPA值而不是抓取替代料的QPA 
# Modify.........: No:MOD-B70012 11/07/04 By zhangll g_pia.pia01->l_pia01
# Modify.........: No.CHI-B90001 11/11/01 By jason ICD刻號/BIN-盤點新增piad_file檔
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No:MOD-B70286 11/11/22 By Vampire CONTINUE FOREACH前需先將l_pia01清空以免有舊值殘留的問題
# Modify.........: No:FUN-910088 11/12/13 By chenjing 增加數量欄位小數取位
# Modify.........: No:FUN-BB0086 11/12/13 By tanxc 增加數量欄位小數取位 
# Modify.........: No:MOD-C60004 12/06/01 By ck2yuan 料若已經產生標籤且未過帳,則不再產生標籤
# Modify.........: No:MOD-B60230 12/06/15 By Elise 當勾選無庫存時不重產生，但還是會產生
# Modify.........: No:TQC-C80015 12/08/02 By fengrui 增加QBE欄位開窗
# Modify.........: No:MOD-C90008 12/09/20 By Elise l_sql定義修正為STRING
# Modify.........: No:MOD-CB0258 12/12/26 By Elise 在製盤點工單狀態<4或>7的部分JOIN pid_file改為INNER JOIN
# Modify.........: No:MOD-CC0243 13/01/11 By Elise 修正庫存重計若有舊的盤點單過帳時,無法重計
# Modify.........: No:CHI-B60100 13/01/21 By Alberti 盤點標籤只更新pia08,若有批序號管理時,也應更新pias09
# Modify.........: No:CHI-B70010 13/01/21 By Alberti 產生在製盤點標籤時，排除"消耗性料件"(sfa11<>'E')
# Modify.........: No:MOD-D20013 13/02/18 By bart 空白標籤單別不同，導致不會重計
# Modify.........: No:MOD-CA0139 13/02/26 By bart 排除已過帳
# Modify.........: No:CHI-B20003 13/03/12 By Alberti 在aimt800加上一"截止日期"欄位，在重計庫存數量時須考慮該日期
# Modify.........: No:MOD-D40070 13/04/11 By bart 修改若有走製造批號時,重計時不會新增新的製造批號資料

DATABASE ds
 
GLOBALS "../../config/top.global"
 

    DEFINE tm        RECORD			      # Print condition RECORD
                     stk      LIKE pic_file.pic05,    #stock tag (Y/N)  #No.FUN-690026 VARCHAR(1)
                     tag1     LIKE pia_file.pia01,    #CHI-960065
                     noinv1   LIKE pic_file.pic08,    #No.FUN-690026 VARCHAR(1)
                     spcg1    LIKE pic_file.pic14,    #No.FUN-690026 VARCHAR(1)
                     spc1     LIKE pia_file.pia01,    #CHI-960065
                     qty1     LIKE pic_file.pic17,    #No.FUN-690026 INTEGER
                     edate    LIKE type_file.dat,     #No:CHI-B20003 add
                     order1   LIKE pic_file.pic21,    #No.FUN-690026 VARCHAR(10)
                     class1   LIKE pic_file.pic22,    #No.FUN-690026 VARCHAR(1)
                     wip      LIKE pic_file.pic25,    #wo tab (Y/N)  #No.FUN-690026 VARCHAR(1)
                     tag2     LIKE pid_file.pid01,    #CHI-960065
                     spcg2    LIKE pic_file.pic14,    #No.FUN-690026 VARCHAR(1)
                     spc2     LIKE pid_file.pid01,    #CHI-960065 
                     qty2     LIKE pic_file.pic37,    #No.FUN-690026 INTEGER
                     order2   LIKE pic_file.pic41,    #No.FUN-690026 VARCHAR(10)
                     exedate  LIKE type_file.dat      #No.FUN-690026 DATE
                     END RECORD,
        tm3          RECORD    #for UI
                     o1,o2,o3,o4,o5,o6   LIKE type_file.chr20,  #No.FUN-690026 VARCHAR(20)
                     k1,k2,k3,k4,k5,k6   LIKE type_file.chr20   #No.FUN-690026 VARCHAR(20)
                     END RECORD,
        tm_tag1_o    LIKE pia_file.pia01,   #CHI-960065
        tm_spc1_o    LIKE pia_file.pia01,   #CHI-960065
        tm_tag2_o    LIKE pid_file.pid01,   #CHI-960065
        tm_spc2_o    LIKE pid_file.pid01,   #CHI-960065
        g_bstk          LIKE pic_file.pic11,  #FUN-660078
        g_estk          LIKE pic_file.pic12,  #FUN-660078
        g_bwip          LIKE pic_file.pic31,  #FUN-660078
        g_ewip          LIKE pic_file.pic32,  #FUN-660078
        g_bspcstk,g_espcstk LIKE pic_file.pic18,
        g_bspcwip,g_espcwip LIKE pic_file.pic38,
        g_spcstk,g_spcwip   LIKE pic_file.pic20,
        g_bstk1             LIKE pic_file.pic11,  #CHI-960065
        g_bwip1             LIKE pic_file.pic12,  #CHI-960065
        g_bspcstk1          LIKE pic_file.pic18,  #CHI-960065
        g_bspcwip1          LIKE pic_file.pic38,  #CHI-960065
        g_paper1,g_paper2   LIKE pic_file.pic13,
        g_date              LIKE type_file.dat,    #No.FUN-690026 DATE
        g_zero,l_n          LIKE type_file.num5,   #No.FUN-690026 SMALLINT
        g_begin,g_end       LIKE pia_file.pia01,   #No.B118 010326 add
        g_begin2,g_end2     LIKE pia_file.pia01,   #No.B118 010326 add
        g_program           LIKE zz_file.zz01,     #No.FUN-690026 VARCHAR(10)
        g_wc1,g_wc2         string,                #No.FUN-580092 HCN
        l_pia19             LIKE pia_file.pia19
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_pia930        LIKE pia_file.pia930   #FUN-680006
DEFINE g_t1            LIKE oay_file.oayslip  #CHI-960065
DEFINE g_last_yy       LIKE type_file.num5    #No:CHI-B20003 add #記錄抓imk_file年度
DEFINE g_last_mm       LIKE type_file.num5    #No:CHI-B20003 add #記錄抓imk_file.期別
DEFINE g_bdate         LIKE tlf_file.tlf06    #No:CHI-B20003 add #記錄抓tlf_file起始時間

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
   IF s_shut(0) THEN EXIT PROGRAM END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   LET g_date  = g_today
   LET g_program = 'aimt800'
   LET g_success = 'Y'
   LET p_row = 2 LET p_col = 2
 
   OPEN WINDOW t800_w AT p_row,p_col
        WITH FORM "aim/42f/aimt800"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
     CALL t800_tm()		        # Input print condition
     #TQC-AB0036 mark-start-----此部份邏輯搬至t800_tm()函數中
     #IF cl_sure(21,20) THEN
     #   CALL cl_wait()
     #  LET g_success = 'Y'         #No.MOD-7C0014 add
     #  BEGIN WORK                  #TQC-7C0165 add
     #  #是否為多倉管理
     #  IF g_sma.sma12 MATCHES '[yY]' THEN
     #     CALL t800_cur()
     #     CALL t800_wocur()
     #     CALL t800_1()
     #  ELSE
     #     CALL t800_cur2()
     #     CALL t800_wocur()
     #     CALL t800_2()
     #  END IF
 
     #  IF g_success = 'Y' THEN    #TQC-7C0165 add g_success = 'Y'才進入
     #    CALL t800_udpic()
     #  END IF
     #  IF g_success = 'Y' THEN 
     #     COMMIT WORK
     #  ELSE
     #     ROLLBACK WORK
     #  END IF
     #  ERROR ""
     #  CALL cl_end(19,20)
     #END IF
     #TQC-AB0036 mark-end-----此部份邏輯搬至t800_tm()函數中
     CLOSE WINDOW t800_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #MOD-890059 add
END MAIN
 
FUNCTION t800_tm()
   DEFINE l_pib03,l_pib03_2 LIKE pib_file.pib03,
          l_temp            LIKE pib_file.pib02,   #MOD-560202
          l_cmd	    	    LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(400)
   DEFINE li_result    LIKE type_file.num5    #CHI-960065
   DEFINE l_smydesc    LIKE smy_file.smydesc  #CHI-960065
   DEFINE l_edate      LIKE tlf_file.tlf06    #No:CHI-B20003 add
   DEFINE l_correct    LIKE type_file.chr1    #No:CHI-B20003 add
 
 WHILE TRUE
   INITIALIZE tm.* TO NULL			# Default condition
   INITIALIZE tm3.* TO NULL			# Default condition
   LET tm.stk = 'N'
   LET tm.wip = 'N'
   LET tm.noinv1 = 'N'
   LET tm.spcg1 = 'N'
   LET tm.spcg2 = 'N'
   LET tm3.o1 = 1
   LET tm3.o2 = 2
   LET tm3.o3 = 3
   LET tm3.o4 = 4
   LET tm3.o5 = 5
   LET tm3.o6 = 6
   LET tm3.k1 = 1
   LET tm3.k2 = 2
   LET tm3.k3 = 3
   LET tm3.k4 = 4
   LET tm3.k5 = 5
   LET tm3.k6 = 6
   LET tm.edate = g_today       #No:CHI-B20003 add
   LET tm.exedate = g_today
    CALL t800_control() #MOD-570320
    CALL t800_control() #MOD-570320
   DISPLAY BY NAME tm.exedate
 
   INPUT BY NAME tm.stk,tm.tag1,tm.noinv1,tm.spcg1,
                 tm.spc1,tm.qty1,tm.edate,                         #No:CHI-B20003 add edate                  
                 tm3.o1,tm3.o2,tm3.o3,tm3.o4,tm3.o5,tm3.o6,
                 tm.class1,
                 tm.wip,tm.tag2,tm.spcg2,
                 tm.spc2,tm.qty2,
                 tm3.k1,tm3.k2,tm3.k3,tm3.k4,tm3.k5,tm3.k6
                WITHOUT DEFAULTS
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
      ON ACTION exit
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
 
      ON CHANGE stk
          CALL t800_control() #MOD-570320
         IF tm.stk matches'[Nn]' THEN
              LET tm.noinv1 = 'N'
              LET tm.spcg1 = 'N'
              LET tm.tag1   = ' '
              LET tm.spc1   = ' '
              LET tm.qty1   = ' '
              LET tm.class1 = ' '
 
              LET tm.order1= ' '
               CALL t800_control() #MOD-570320
              DISPLAY BY NAME tm.tag1,tm.noinv1,tm.spcg1,   #CHI-960065
                              tm.spc1,tm.qty1,tm.class1     #CHI-960065
         ELSE
              IF tm.noinv1 IS NULL OR tm.noinv1 = ' ' THEN
                 LET tm.noinv1 = 'Y'
              END IF
              IF tm.spcg1 IS NULL OR tm.spcg1 = ' ' THEN
                 LET tm.spcg1  = 'N'
              END IF
              IF tm.order1 IS NULL OR tm.order1 = ' ' THEN
                 LET tm.order1 = '123456'
              END IF
              IF tm.class1 IS NULL OR tm.order1 = ' ' THEN
                 LET tm.class1 = '0'
              END IF
               CALL t800_control() #MOD-570320
              DISPLAY BY NAME tm.tag1,tm.noinv1,tm.spcg1,
                              tm.class1
         END IF
 
      AFTER FIELD tag1
         IF NOT cl_null(tm.tag1) THEN
            CALL s_check_no("aim",tm.tag1,tm_tag1_o,"5","pia_file","pia01","")
            RETURNING li_result,tm.tag1
            DISPLAY BY NAME tm.tag1
            IF (NOT li_result) THEN 
                 NEXT FIELD tag1
            END IF
            LET l_smydesc = s_get_doc_no(tm.tag1)
            SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip = l_smydesc
            DISPLAY l_smydesc TO smydesc1 LET l_smydesc = NULL
         END IF
         LET tm_tag1_o = tm.tag1
 
 
      ON CHANGE spcg1
         CALL t800_control()
 
      AFTER FIELD spcg1
         IF tm.spcg1 MATCHES'[Yy]'
            AND (tm.spc1 IS NULL OR tm.spc1 = ' ')
         THEN LET tm.spc1 = tm.tag1
              DISPLAY BY NAME tm.spc1
         END IF
         IF tm.spcg1 MATCHES '[Nn]' THEN
            IF not cl_null(tm.spc1) THEN
               LET tm.spc1 = ' '
               DISPLAY BY NAME tm.spc1
            END IF
            IF not cl_null(tm.qty1) THEN
               LET tm.qty1 = ' '
               DISPLAY BY NAME tm.qty1
            END IF
         END IF
 
      AFTER FIELD spc1
         IF NOT cl_null(tm.spc1) THEN
            CALL s_check_no("aim",tm.spc1,tm_spc1_o,"5","pia_file","pia01","")
            RETURNING li_result,tm.spc1
            DISPLAY BY NAME tm.spc1
            IF (NOT li_result) THEN
                 NEXT FIELD spc1
              END IF
            LET l_smydesc = s_get_doc_no(tm.spc1)
            SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip = l_smydesc
            DISPLAY l_smydesc TO smydesc2 LET l_smydesc = NULL
         END IF
         LET tm_spc1_o = tm.spc1
 
 
      AFTER FIELD qty1
         IF tm.qty1 <=0 THEN
             CALL cl_err('','aim-813',0) #MOD-570399
            NEXT FIELD qty1
         END IF
 
 
       ON CHANGE wip #MOD-570320
          CALL t800_control() #MOD-570320
         IF tm.wip matches'[Nn]' THEN
              LET tm.spcg2 = 'N'
              LET tm.tag2   = ' '
              LET tm.spc2   = ' '
              LET tm.qty2   = ' '
 
              LET tm.order2= ' '
 
               CALL t800_control() #MOD-570320
              DISPLAY BY NAME tm.tag2,tm.spcg2,  #CHI-960065
                              tm.spc2,tm.qty2    #CHI-960065
         ELSE
              IF tm.spcg2 IS NULL OR tm.spcg2 = ' ' THEN
                 LET tm.spcg2  = 'N'
              END IF
              IF tm.order2 IS NULL OR tm.order2 = ' ' THEN
                 LET tm.order2 = '123456'
              END IF
               CALL t800_control() #MOD-570320
              DISPLAY BY NAME tm.tag2,tm.spcg2
         END IF
 
      AFTER FIELD tag2
         IF NOT cl_null(tm.tag2) THEN
            CALL s_check_no("aim",tm.tag2,tm_tag2_o,"I","pid_file","pid01","")
            RETURNING li_result,tm.tag2
            DISPLAY BY NAME tm.tag2
            IF (NOT li_result) THEN
                NEXT FIELD tag2
            END IF
            LET l_smydesc = s_get_doc_no(tm.tag2)
            SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip = l_smydesc
            DISPLAY l_smydesc TO smydesc3 LET l_smydesc = NULL
         END IF
         LET tm_tag2_o = tm.tag2
 
 
      ON CHANGE spcg2
         CALL t800_control()
 
      AFTER FIELD spcg2
         IF tm.spcg2 MATCHES'[Yy]' AND
            (tm.spc2 IS NULL OR tm.spc2 = ' ') THEN
              LET tm.spc2 = tm.tag2
              DISPLAY BY NAME tm.spc2
         END IF
         IF tm.spcg2 matches'[Nn]' THEN
            IF not cl_null(tm.spc2) THEN
               LET tm.spc2 = ' '
               DISPLAY BY NAME tm.spc2
            END IF
            IF not cl_null(tm.qty2) THEN
               LET tm.qty2 = ' '
               DISPLAY BY NAME tm.qty2
            END IF
         END IF
 
      AFTER FIELD spc2
         IF NOT cl_null(tm.spc2) THEN
            CALL s_check_no("aim",tm.spc2,tm_spc2_o,"I","pid_file","pid01","")
            RETURNING li_result,tm.spc2
            DISPLAY BY NAME tm.spc2
            IF (NOT li_result) THEN
                 NEXT FIELD spc2
              END IF
            LET l_smydesc = s_get_doc_no(tm.spc2)
            SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip = l_smydesc
            DISPLAY l_smydesc TO smydesc4 LET l_smydesc = NULL
         END IF
         LET tm_spc2_o = tm.spc2
 
 
      AFTER FIELD qty2
         IF tm.qty2 <=0 THEN
             CALL cl_err('','aim-813',0) #MOD-570399
            NEXT FIELD qty2
         END IF
 
      AFTER INPUT
         LET tm.order1 = tm3.o1[1,1],tm3.o2[1,1],tm3.o3[1,1],
                         tm3.o4[1,1],tm3.o5[1,1],tm3.o6[1,1]
         LET tm.order2 = tm3.k1[1,1],tm3.k2[1,1],tm3.k3[1,1],
                         tm3.k4[1,1],tm3.k5[1,1],tm3.k6[1,1]
 
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      ON ACTION stk_qbe
         IF tm.stk = 'Y' THEN
             CALL t800_stk()
         END IF
      ON ACTION wip_qbe
         IF tm.wip = 'Y' THEN
             CALL t800_wip()
         END IF
 
      ON ACTION CONTROLP
            CASE
               WHEN INFIELD(tag1)
                  LET g_t1 = s_get_doc_no(tm.tag1)
                  CALL q_smy( FALSE,TRUE,g_t1,'AIM','5') RETURNING g_t1
                  LET tm.tag1=g_t1
                  DISPLAY BY NAME tm.tag1
                  NEXT FIELD tag1
               WHEN INFIELD(spc1)
                  LET g_t1 = s_get_doc_no(tm.spc1)
                  CALL q_smy( FALSE,TRUE,g_t1,'AIM','5') RETURNING g_t1
                  LET tm.spc1=g_t1
                  DISPLAY BY NAME tm.spc1
                  NEXT FIELD spc1 
               WHEN INFIELD(tag2)
                  LET g_t1 = s_get_doc_no(tm.tag2)
                  CALL q_smy( FALSE,TRUE,g_t1,'AIM','I') RETURNING g_t1
                  LET tm.tag2=g_t1
                  DISPLAY BY NAME tm.tag2
                  NEXT FIELD tag2
               WHEN INFIELD(spc2)
                  LET g_t1 = s_get_doc_no(tm.spc2)
                  CALL q_smy( FALSE,TRUE,g_t1,'AIM','I') RETURNING g_t1
                  LET tm.spc2=g_t1
                  DISPLAY BY NAME tm.spc2
                  NEXT FIELD spc2
               OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION mntn_tag
        #CALL cl_cmdrun('aimi800' )
         CALL cl_cmdrun('asmi300' )  #Mod No:TQC-AC0391
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()	# Command execution
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
   IF tm.stk MATCHES'[Nn]' AND tm.wip MATCHES'[Nn]' THEN
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t800_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF

  #---------------No:CHI-B20003 add
   LET g_last_yy = YEAR(tm.edate)
   LET g_last_mm = MONTH(tm.edate)
   CALL s_azm(g_last_yy,g_last_mm) RETURNING l_correct, g_bdate, l_edate #得出起始日與截止日
   IF g_last_mm = 1 THEN
      LET g_last_yy = g_last_yy - 1
      LET g_last_mm = 12
   ELSE
      LET g_last_mm = g_last_mm - 1
   END IF
  #---------------No:CHI-B20003 end
 
   #EXIT WHILE    #TQC-AB0036 mark
   #TQC-AB0046 add by suncx -start--------此部份為原來MAIN函數中的邏輯
    IF cl_sure(21,20) THEN
        CALL cl_wait()
       LET g_success = 'Y'         #No.MOD-7C0014 add
       BEGIN WORK                  #TQC-7C0165 add
       #是否為多倉管理
       IF g_sma.sma12 MATCHES '[yY]' THEN
          CALL t800_cur()
          CALL t800_wocur()
          CALL t800_1()
       ELSE
          CALL t800_cur2()
          CALL t800_wocur()
          CALL t800_2()
       END IF

       IF g_success = 'Y' THEN    #TQC-7C0165 add g_success = 'Y'才進入
         CALL t800_udpic()
       END IF
       IF g_success = 'Y' THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       ERROR ""
       CALL cl_end(19,20)
    END IF
    #TQC-AB0036 add by suncx -end--------
 END WHILE
 
END FUNCTION
 
FUNCTION t800_cur()
 DEFINE l_cmd  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(600)
 
   LET l_cmd = " INSERT INTO pia_file (pia01,pia02,pia03,pia04,pia05,pia06,",
                                     " pia07,pia08,pia09,pia10,",
                                     " pia11,pia12,pia13,pia14,",
                                     " pia15,pia16,pia19,pia930,piaplant,pialegal)", #FUN-680006 #FUN-980004 add piaplant,pialegal
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,? )" #FUN-680006 #FUN-980004 add ?,?  
   PREPARE t800_pia FROM l_cmd
   DECLARE t800_cpia CURSOR WITH HOLD FOR t800_pia
 
   OPEN t800_cpia
 
   LET l_cmd = " INSERT INTO piaa_file (piaa00,piaa01,piaa02,piaa03,piaa04,",
                                      " piaa05,piaa06,piaa07,piaa08,piaa09,",
                                      " piaa10,piaa11,piaa12,piaa13,piaa14,",
                                      " piaa15,piaa16,piaa19,piaa930,piaaplant,piaalegal)", #FUN-680006 #FUN-980004 add piaaplant,piaalegal
              " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)" #FUN-680006 #FUN-980004 add ?,?
   PREPARE t800_piaa FROM l_cmd
   DECLARE t800_cpiaa CURSOR WITH HOLD FOR t800_piaa
   OPEN t800_cpiaa
 
   LET l_cmd = "SELECT imgg_file.*,piaa01,piaa19",
               "  FROM imgg_file LEFT OUTER JOIN piaa_file ON imgg01=piaa_file.piaa02 AND imgg02=piaa_file.piaa03 AND imgg03=piaa_file.piaa04 AND imgg04 =piaa_file.piaa05 AND imgg09=piaa_file.piaa09 AND piaa01=?,ima_file",    #MOD-B10045 add piaa_file.
               " WHERE imgg01=ima01  AND ",
               "       imgg01=?      AND ",  #NO.MOD-610107 add , #No.MOD-810010 add AND
               "       imgg02=?      AND ",  #NO.MOD-610107 add
               "       imgg03=?      AND ",  #NO.MOD-610107 add
               "       imgg04=?          "   #NO.MOD-610107 add
 
   PREPARE t800_s_piaa FROM l_cmd
   IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare s_piaa:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
   END IF
   DECLARE t800_cs_piaa CURSOR WITH HOLD FOR t800_s_piaa


     #-------------No:CHI-B20003 add
   LET l_cmd = "SELECT imgs_file.*,pias_file.* ",
               "  FROM imgs_file LEFT OUTER JOIN pias_file ON imgs01=pias_file.pias02 AND imgs02=pias_file.pias03 ", 
               "   AND imgs03=pias_file.pias04 AND imgs04 = pias_file.pias05 AND imgs05 = pias_file.pias06 ",
               "   AND imgs06 = pias_file.pias07 AND pias01 = ?,ima_file",    
               " WHERE imgs01=ima01  AND ",
               "       imgs01=?      AND ",  
               "       imgs02=?      AND ",  
               "       imgs03=?      AND ",  
               "       imgs04=?          "   
 
   PREPARE t800_s_pias1 FROM l_cmd
   IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare s_pias1:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
   END IF
   DECLARE t800_cs_pias1 CURSOR WITH HOLD FOR t800_s_pias1

   LET l_cmd = " SELECT tlf_file.* FROM tlf_file ",
               "   WHERE tlf01 = ?  AND tlf902 = ? ",
               "     AND tlf903 = ? AND tlf904 = ? ",    
               "     AND tlf06 >='",g_bdate,"'",
               "     AND tlf06 <='",tm.edate,"'",
               "     AND ( tlf907 <> 0 ) ",
               "     ORDER BY tlf06,tlf08 "

   PREPARE t800_ptlf FROM l_cmd
   DECLARE t800_ctlf CURSOR WITH HOLD FOR t800_ptlf

   LET l_cmd = " SELECT tlff_file.* FROM tlff_file ",
               "       WHERE tlff01 = ? ",
               "         AND tlff902 = ? ",
               "         AND tlff903 = ? ",
               "         AND tlff904 = ? ",
               "         AND tlff11 = ? ",
               "         AND tlff06 >='",g_bdate,"'",
               "         AND tlff06 <='",tm.edate,"'",
               "         AND tlff907 <> 0 ",
               "         ORDER BY tlff06,tlff08 "

   PREPARE t800_ptlff FROM l_cmd
   DECLARE t800_ctlff CURSOR WITH HOLD FOR t800_ptlff

   LET l_cmd = " SELECT tlfs_file.* FROM tlfs_file ",
               "        WHERE tlfs01 = ? ",
               "          AND tlfs02 = ? ",
               "          AND tlfs03 = ? ",
               "          AND tlfs04 = ? ",
               "          AND tlfs05 = ? ",
               "          AND tlfs06 = ? ",
               "          AND tlfs111 >='",g_bdate,"'",
               "          AND tlfs111 <='",tm.edate,"'",
               "          AND tlfs09 <> 0 ",
               "        ORDER BY tlfs111  "   

   PREPARE t800_ptlfs FROM l_cmd
   DECLARE t800_ctlfs CURSOR WITH HOLD FOR t800_ptlfs
  #-------------No:CHI-B20003 end
  
   #CHI-B90001 --START--
   IF s_industry('icd') THEN
      LET l_cmd = "SELECT idc_file.*,piad_file.* ",
                  "  FROM idc_file LEFT OUTER JOIN piad_file ON idc01=piad_file.piad02 AND idc02=piad_file.piad03 ", 
                  "   AND idc03=piad_file.piad04 AND idc04 = piad_file.piad05 AND idc05 = piad_file.piad06 ",
                  "   AND idc06 = piad_file.piad07 AND piad01 = ?,ima_file",    
                  " WHERE idc01=ima01  AND ",
                  "       idc01=?      AND ",  
                  "       idc02=?      AND ",  
                  "       idc03=?      AND ",  
                  "       idc04=?          "      
      PREPARE t800_s_piad FROM l_cmd
      IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare s_piad:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time
          EXIT PROGRAM
      END IF
      DECLARE t800_cs_piad CURSOR WITH HOLD FOR t800_s_piad
 
      LET l_cmd = " INSERT INTO piad_file ( ",
                  " piad01,piad02,piad03,piad04,piad05,",
                  " piad06,piad07,piad08,piad09,piad10,",
                  " piad11,piad12,piad13,piad19,",
                  " piadplant,piadlegal) ", 
                  " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
      PREPARE t800_piad FROM l_cmd
      DECLARE t800_cpiad CURSOR WITH HOLD FOR t800_piad
      OPEN t800_cpiad   
      IF SQLCA.sqlcode THEN
          CALL cl_err('DECLARE t800_cpiad:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          RETURN
      END IF                 
   END IF
   #CHI-B90001 --END-- 
 
   LET l_cmd = " INSERT INTO pias_file ( ",
               " pias01,pias02,pias03,pias04,pias05,",
               " pias06,pias07,pias08,pias09,pias10,",
               " pias11,pias12,pias13,pias19,piasplant,piaslegal", #FUN-980004 add  piasplant,piaslegal
               " )",
               " VALUES( ",
               "   ?, ?, ?, ?, ?, ",
               "   ?, ?, ?, ?, ?, ",
               "   ?, ?, ?, ?  ,?,?   ", #FUN-980004 add  ?,?
               "   )" 
   PREPARE t800_pias FROM l_cmd
   DECLARE t800_cpias CURSOR WITH HOLD FOR t800_pias
   OPEN t800_cpias   #No.FUN-8A0147
   IF SQLCA.sqlcode THEN
       CALL cl_err('DECLARE t800_cpias:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
   END IF
   LET l_cmd = " SELECT * FROM imgs_file ",
               "  WHERE imgs01=?",
               "    AND imgs02=?",
               "    AND imgs03=?",
               "    AND imgs04=?"
   PREPARE t800_imgs FROM l_cmd
   DECLARE t800_cimgs CURSOR FOR t800_imgs
   IF SQLCA.sqlcode THEN
       CALL cl_err('DECLARE t800_cimgs:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
   END IF
 
END FUNCTION
 
FUNCTION t800_cur2()
 DEFINE l_cmd  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(600)
 
   LET l_cmd = " INSERT INTO pia_file (pia01,pia02,pia08,pia09,pia10,",
                                     " pia11,pia12,pia13,pia14,pia15,",
                                     " pia16,pia19,pia930,piaplant,pialegal)", #FUN-680006 #FUN-980004 add piaplant,pialegal
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)" #FUN-680006 #FUN-980004 add  ?,?
   PREPARE t800_pia2 FROM l_cmd
   DECLARE t800_cpia2 CURSOR WITH HOLD FOR t800_pia2
 
   OPEN t800_cpia2
END FUNCTION
 
FUNCTION t800_wocur()
 DEFINE l_cmd  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(600)
 
   #--->更新在製工單盤點單頭檔(相關數量)
   LET l_cmd = " UPDATE pia_file SET pia08 = ? WHERE pia01 = ? ",
               " "
   PREPARE t800_uppia FROM l_cmd

   #CHI-B60100 --- modify --- start ---
   LET l_cmd = " UPDATE pias_file  SET pias09 = ? ",
               "  WHERE pias01 = ? AND pias02 = ? ",
               "    AND pias03 = ? AND pias04 = ? ",
               "    AND pias05 = ? AND pias06 = ? ",
               "    AND pias07 = ?                "
   PREPARE t800_uppias FROM l_cmd
   #CHI-B60100 --- modify ---  end  ---
 
   #--->更新多單位盤點單頭檔(相關數量)
   LET l_cmd = " UPDATE piaa_file SET piaa08 = ? WHERE piaa01 = ? AND piaa09 = ? ",
               " "
   PREPARE t800_uppiaa FROM l_cmd

   #----------------No:CHI-B20003 add
   LET l_cmd = " UPDATE pias_file SET pias09 = ? WHERE pias01 = ? AND pias06 = ? AND pias07 =? ",
               " "
   PREPARE t800_uppias1 FROM l_cmd
  #----------------No:CHI-B20003 end

   #CHI-B90001 --START--
   IF s_industry('icd') THEN
      LET l_cmd = " UPDATE piad_file SET piad09 = ? WHERE piad01 = ? AND piad06 = ? AND piad07 =? "                 
      PREPARE t800_uppiad FROM l_cmd
   END IF    
   #CHI-B90001 --END--
 
   #--->更新在製工單盤點單頭檔(相關數量)
   LET l_cmd = " UPDATE pid_file SET pid13 = ?, ",     #完工入庫量
                               "     pid14 = ?, ",     #再加工量
                               "     pid15 = ?, ",     #F Q C 量
                               "     pid17 = ?  WHERE pid01 = ?",     #報廢量
               " "
   PREPARE t800_uppid FROM l_cmd
 
   #--->更新在製工單盤點單身檔(相關數量)
   LET l_cmd = " UPDATE pie_file SET pie11 = ?, ",      #應發數量
                               "     pie12 = ?, ",      #已發數量
                               "     pie13 = ?, ",      #超領數量
                               "     pie14 = ?, ",      #QPA
                               "     pie15 = ?, ",      #報廢數量
                               "    pie151 = ?, ",      #代買數量
                               "    pie153 = ?  WHERE pie01 = ? AND pie07 = ?",      #應盤數量
               " "
   PREPARE t800_uppie FROM l_cmd
 
   #-->在製工單下階料已存在則更新(pie_file)
   LET l_cmd = " SELECT sfa05,sfa06,sfa062,sfa161,sfa063,sfa065,",
               " pie07 ", #FUN-760040
               " FROM sfa_file,pie_file ",
               " WHERE pie01 = ? ",       #標籤號碼
               "   AND sfa01 = ? ",       #工單
               "   AND sfa03 = ?",        #下階料號  #MOD-580005
               "   AND sfa08 = ?",        #作業序號  #MOD-580005
               "   AND sfa12 = ?",        #發料單位  #MOD-580005
               "   AND sfa012 = ?",       #FUN-A60027 
               "   AND sfa013 = ?",       #FUN-A60027    
               "   AND sfa03 = pie02",    #下階料號
               "   AND sfa08 = pie03",    #作業序號
               "   AND sfa12 = pie04",    #發料單位
               "   AND sfa012 = pie012 AND sfa013 = pie013", #FUN-A60027
               "   AND sfa11 <> 'E' "     #消耗性料件 #CHI-B70010 add
   PREPARE t800_pexit FROM l_cmd
   DECLARE t800_cexit CURSOR WITH HOLD FOR t800_pexit
 
   #-->產生在製工單盤點單頭檔(pid_file)
   LET l_cmd = " INSERT INTO pid_file(pid01,pid02,pid03,pid04,pid05,",
                                    " pid06,pid07,pid08,pid09,",
                                    " pid10,pid11,pid12,pid13,",
                                    " pid14,pid15,pid17,pid18,",
                                    " pid021,pid022,pid023,pidplant,pidlegal,pid012)", #MOD-560202 #FUN-980004 add pidplant,pidlegal
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,? ,?)" #MOD-560202加三個? #FUN-980004 add ?,?  #FUN-A60095
   PREPARE t800_pid FROM l_cmd
   DECLARE t800_cpid CURSOR WITH HOLD FOR t800_pid
 
   LET l_cmd = "INSERT INTO pie_file(pie01,pie02,pie03,",
                                   " pie04,pie05,pie06,pie07,",
                                   " pie11,pie12,pie13,pie14,",
                                   " pie15,pie151,pie152,pie153,pie16,",
                                   " pieplant,pielegal,pie012,pie013,pie900)", #FUN-980004 add pieplant,pielegal   #FUN-A60027 add pie012,pie013  #FUN-A60095
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,? ,? ) " #FUN-980004 add ?,?   #FUN-A60027 add 2 ?  #FUN-A60095
   PREPARE t800_pie FROM l_cmd
   DECLARE t800_cpie CURSOR WITH HOLD FOR t800_pie
 
   #--->針對空白標籤用
   LET l_cmd = " INSERT INTO pie_file(pie01,pie06,pie07,pie08,pie09,",
                                    " pie12,pieplant,pielegal,pie012,pie013)", #FUN-980004 add pieplant,pielegal #FUN-A60095
               " VALUES(?, ?, ?, ?, ?, ?, ?,? ,?,?)" #FUN-980004 add ?,?  #FUN-A60095
   PREPARE t800_pie2 FROM l_cmd
   DECLARE t800_cpie2 CURSOR WITH HOLD FOR t800_pie2 #BugNo:6206
 
   OPEN t800_cpid
   OPEN t800_cpie
   OPEN t800_cpie2
END FUNCTION
 
 
#多倉時的處理
FUNCTION t800_1()
   DEFINE l_name	LIKE type_file.chr20, 	# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
         #l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1600)  #MOD-C90008 mark
          l_sql         STRING,                 #MOD-C90008
          l_za05	LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          l_wc          LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
          l_cmd         LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(600)
          l_pias        RECORD LIKE pias_file.*,#No:CHI-B20003  add
          g_pia         RECORD
                        pia01  LIKE pia_file.pia01,    #標籤編號
                        pia02  LIKE pia_file.pia02,    #料件編號
                        pia03  LIKE pia_file.pia03,    #倉庫別
                        pia04  LIKE pia_file.pia04,    #存放位置
                        pia05  LIKE pia_file.pia05,    #批號
                        pia06  LIKE pia_file.pia06,    #庫存等級
                        pia07  LIKE pia_file.pia07,    #倉儲會計科目
                        pia08  LIKE pia_file.pia08,    #現有庫存
                        pia09  LIKE pia_file.pia09,    #庫存單位
                        pia10  LIKE pia_file.pia10,    #庫存/料件單位轉換率
                        ima06  LIKE ima_file.ima06,    #分群碼
                        ima09  LIKE ima_file.ima09,    #其它分群碼(1)
                        ima10  LIKE ima_file.ima10,    #其它分群碼(2)
                        ima11  LIKE ima_file.ima11,    #其它分群碼(3)
                        ima12  LIKE ima_file.ima12,    #其它分群碼(4)
                        ima23  LIKE ima_file.ima23     #倉管員
                        END RECORD,
          l_stat        LIKE type_file.num5,      #1.過帳  2.有盤點資料  3.新增  #No.FUN-690026 SMALLINT
          l_ima906      LIKE ima_file.ima906,
          l_imgg        RECORD LIKE imgg_file.*,
          l_piaa01      LIKE pia_file.pia01,
          l_piaa19      LIKE pia_file.pia19,
          l_imgs        RECORD LIKE imgs_file.*,#No.FUN-8A0147
          l_ima918      LIKE ima_file.ima918,   #No.FUN-8A0147
          l_ima921      LIKE ima_file.ima921,   #No.FUN-8A0147
          l_pia01       LIKE pia_file.pia01,
          l_pid01       LIKE pid_file.pid01,
          l_msg         LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
          l_item        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
	  l_sw          LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
DEFINE    li_result     LIKE type_file.num5     #CHI-960065
DEFINE l_imgs05       LIKE imgs_file.imgs05  #CHI-B60100 add 
DEFINE l_imgs06       LIKE imgs_file.imgs06  #CHI-B60100 add 
DEFINE l_imgs08       LIKE imgs_file.imgs08  #CHI-B60100 add 
DEFINE l_tag1         STRING                 #CHI-960065
DEFINE l_tag2         STRING                 #CHI-960065
DEFINE l_spc1         STRING                 #CHI-960065
DEFINE l_spc2         STRING                 #CHI-960065
DEFINE l_n3           LIKE type_file.num5    #CGI-960065
#DEFINE l_imaicd08     LIKE imaicd_file.imaicd08 #FUN-B70032 #FUN-BA0051 mark
DEFINE l_idc          RECORD LIKE idc_file.*    #CHI-B90001
DEFINE l_piad         RECORD LIKE piad_file.*   #CHI-B90001
DEFINE l_img10        LIKE img_file.img10       #MOD-CC0243 add 
DEFINE l_pia19b       LIKE pia_file.pia19       #MOD-CC0243 add
 
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
     LET g_begin=''
     LET g_end=''
     LET g_begin2=''
     LET g_end2=''
  #---->產生現有庫存標籤產生
  IF tm.stk = 'Y' THEN
      LET l_sql = "SELECT '',img01,img02,img03,img04, img19,img26,",
                  " img10,img09,img21,",
                  " ima06,ima09,ima10,ima11,ima12,ima23,",
                  " pia01,pia19",
                 #MOD-B50256---modify---start---
                  " FROM img_file LEFT OUTER JOIN pia_file ON",
                  "       (pia_file.pia01 LIKE '",tm.spc1 CLIPPED,"%' AND pia_file.pia16 = 'Y' OR ",  #MOD-D20013
                  "       pia_file.pia01 LIKE '",tm.tag1 CLIPPED,"%') AND ", #No.MOD-8C0247
                  "       pia_file.pia19 <> 'Y' AND ",  #MOD-CA0139
                  "       img01=pia_file.pia02 AND ",          #MOD-B10045 add pia_file. 
                  "       img02=pia_file.pia03 AND ",          #MOD-B10045 add pia_file.  
                  "       img03=pia_file.pia04 AND ",          #MOD-B10045 add pia_file.    
                  "       img04=pia_file.pia05,",              #MOD-B10045 add pia_file.    
                  "      ima_file",
                  "  WHERE img01=ima01  AND imaacti <> 'N' "    #No:MOD-A10008 modify
                 #" FROM img_file, ima_file, pia_file ", 
                 #"  WHERE img01=ima01  AND imaacti <> 'N' ",
                 #"    AND pia_file.pia01(+) LIKE '",tm.tag1 CLIPPED,"%' ",
                 #"   AND img01=pia_file.pia02(+) ",        
                 #"   AND img02=pia_file.pia03(+) ",        
                 #"   AND img03=pia_file.pia04(+) ",        
                 #"   AND img04=pia_file.pia05(+) "     
                 #MOD-B50256---modify---end---
     IF NOT cl_null(g_wc1) THEN
        LET l_sql = l_sql CLIPPED," AND ",g_wc1 CLIPPED
     END IF
     IF tm.noinv1 = 'N' THEN
          #LET l_sql = l_sql clipped," AND img10 > 0 "   #No:CHI-B20003 mark
        LET l_sql = l_sql CLIPPED,
                    " UNION ",
                    "SELECT '',img01,img02,img03,img04, img19,img26,",
                    " img10,img09,img21,",
                    " ima06,ima09,ima10,ima11,ima12,ima23,",
                    " pia01,pia19",
                  #====MOD-B60230==modify==# 
                  ##MOD-B50256---modify---start---
                  # " FROM img_file LEFT OUTER JOIN pia_file ON",
                  # "       pia_file.pia01 LIKE '",tm.tag1 CLIPPED,"%' AND ",     #MOD-B10045 add pia_file. 
                  # "       img01=pia_file.pia02 AND ",    #MOD-B10045 add pia_file.      
                  # "       img02=pia_file.pia03 AND ",    #MOD-B10045 add pia_file.     
                  # "       img03=pia_file.pia04 AND ",    #MOD-B10045 add pia_file.   
                  # "       img04=pia_file.pia05,",        #MOD-B10045 add pia_file.  
                  # "      ima_file",
                  # "  WHERE img01=ima01  AND imaacti <> 'N' "    #No:MOD-A10008 modify
                  ##" FROM img_file,ima_file, pia_file ",  
                  ##" WHERE img01=ima01     ",
                  ##"   AND imaacti <> 'N' ",    
                  ##"   AND pia_file.pia01(+) LIKE '",tm.tag1 CLIPPED,"%' ", 
                  ##"   AND img01=pia_file.pia02(+) ",         
                  ##"   AND img02=pia_file.pia03(+) ",          
                  ##"   AND img03=pia_file.pia04(+) ",           
                  ##"   AND img04=pia_file.pia05(+) "                
                  ##MOD-B50256---modify---end---
                    " FROM img_file,ima_file, pia_file ",
                    " WHERE img01=ima01     ",
                    "   AND imaacti <> 'N' ",
                    "   AND pia01 LIKE '",tm.tag1 CLIPPED,"%' ",
                    "   AND pia19 <> 'Y' ",  #MOD-CA0139
                    "   AND img01=pia02 ",
                    "   AND img02=pia03 ",
                    "   AND img03=pia04 ",
                    "   AND img04=pia05 "
                  #====MOD-B60230==modify==# 
        IF NOT cl_null(g_wc1) THEN
           LET l_sql=l_sql CLIPPED," AND ",g_wc1 CLIPPED
        END IF
     END IF
     LET l_sw='N'
     FOR g_i = 1 TO 6       #資料產生順序
        CASE tm.order1[g_i,g_i]
	 	   WHEN '1' IF l_sw='N' THEN
                         LET l_wc=' ORDER BY 16' LET l_sw='Y'   #No.+345
                    ELSE LET l_wc=l_wc CLIPPED,' ,16'           #No.+345
                    END IF
           WHEN '2' IF l_sw='N' THEN
                         LET l_wc=' ORDER BY 3' LET l_sw='Y'   #No.+345
                    ELSE LET l_wc=l_wc CLIPPED,' ,3 '   #No.+345
                    END IF
           WHEN '3' IF l_sw='N' THEN
                     LET l_wc=' ORDER BY 4 ' LET l_sw='Y'   #No.+345
                    ELSE LET l_wc=l_wc CLIPPED,' ,4 '    #No.+345
                    END IF
           WHEN '4' IF l_sw='N' THEN
                        LET l_wc=' ORDER BY 5 ' LET l_sw='Y'   #No.+345
                    ELSE LET l_wc=l_wc CLIPPED,' , 5'    #No.+345
                    END IF
           WHEN '5' IF l_sw='N' THEN
	 	                 LET l_wc=' ORDER BY 2' LET l_sw='Y'   #No.+345
                    ELSE LET l_wc=l_wc CLIPPED,' ,2 '    #No.+345
                    END IF
           WHEN '6'
	        IF l_sw='N' THEN  LET l_sw='Y'
		      CASE tm.class1
			   WHEN '0' LET l_wc=' ORDER BY 11 '
			   WHEN '1' LET l_wc=' ORDER BY 12 '
			   WHEN '2' LET l_wc=' ORDER BY 13 '
			   WHEN '3' LET l_wc=' ORDER BY 14 '
			   WHEN '4' LET l_wc=' ORDER BY 15 '
			OTHERWISE EXIT CASE
                    END CASE
                 ELSE
		    CASE tm.class1
			 WHEN '0' LET l_wc=l_wc CLIPPED,' ,11'
			 WHEN '1' LET l_wc=l_wc CLIPPED,' ,12'
			 WHEN '2' LET l_wc=l_wc CLIPPED,' ,13'
			 WHEN '3' LET l_wc=l_wc CLIPPED,' ,14'
			 WHEN '4' LET l_wc=l_wc CLIPPED,' ,15'
			OTHERWISE EXIT CASE
                    END CASE
                 END IF
           OTHERWISE LET l_wc = l_wc  CLIPPED
        END CASE
     END FOR
     LET l_sql =l_sql CLIPPED,l_wc CLIPPED
     PREPARE t800_prepare12 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM END IF
     DECLARE t800_cs12 CURSOR WITH HOLD FOR t800_prepare12
 
     #---->現有庫存起始流水號
     LET g_paper1 = 0
     FOREACH t800_cs12 INTO g_pia.*,l_pia01,l_pia19
         IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
 
         IF l_pia19 = 'Y' THEN  #已過帳要全部rollback並跳出FOREACH
           #CALL cl_err('','aim-128',1)  #MOD-CC0243 mark
           #LET g_success = 'N'          #MOD-CC0243 mark  
           #RETURN                       #MOD-CC0243 mark
           #MOD-CC0243---add---S
            LET l_img10=0
            SELECT COUNT(img10) INTO l_img10 FROM img_file
             WHERE img01=g_pia.pia02 AND img02=g_pia.pia03
               AND img03=g_pia.pia04 AND img04=g_pia.pia05

            SELECT COUNT(pia19) INTO l_pia19b FROM pia_file
             WHERE pia02=g_pia.pia02 AND pia03=g_pia.pia03
               AND pia04=g_pia.pia04 AND pia05=g_pia.pia05
               AND pia19='N'

            IF l_img10>0 AND l_pia19b>0 THEN
               CONTINUE FOREACH
            END IF
           #MOD-CC0243---add---E
         END IF
 
         LET l_stat=3
        #IF l_pia19='Y' THEN LET l_stat=1 END IF   #MOD-CC0243 mark
        CALL t800_com_pia08(g_pia.*) RETURNING g_pia.pia08   #No:CHI-B20003 add
         #--->如存在則更新現有庫存量
         IF l_pia01 IS NOT NULL AND l_pia01 !=' ' AND l_stat<>1 THEN
            message l_pia01
             CALL ui.Interface.refresh()   #No.MOD-480110
           #EXECUTE t800_uppia USING g_pia.pia08,g_pia.pia01
            EXECUTE t800_uppia USING g_pia.pia08,l_pia01  #MOD-B70012 mod
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err(g_pia.pia01,'mfg0157',0)
                 LET g_success = 'N'
                 RETURN
            END IF
            LET l_stat=2
         END IF
        #MOD-C60004 str add-----
         SELECT COUNT(*) INTO l_n FROM pia_file
            WHERE pia02=g_pia.pia02 AND pia03=g_pia.pia03
              AND pia04=g_pia.pia04 AND pia05=g_pia.pia05 AND pia19='N'
         IF l_n>0 THEN  
         #MOD-D40070---begin
            LET l_sql = " SELECT COUNT(*) FROM pia_file ",
                        "  WHERE pia02=? AND pia03=? ",
                        "    AND pia04=? AND pia05=? AND pia19='N' ",
                        "    AND pia01 LIKE '",tm.tag1 CLIPPED,"%' "
            PREPARE t800_pia_p1 FROM l_sql   
            EXECUTE t800_pia_p1 USING g_pia.pia02,g_pia.pia03,g_pia.pia04,g_pia.pia05 INTO l_n            
            IF l_n=0 THEN
         #MOD-D40070---end
               CONTINUE FOREACH  
            END IF          
         ELSE  #MOD-D40070
        #MOD-C60004 end add----- 
            #MOD-B70286 --- modify --- start ---
            #IF g_pia.pia02 IS NULL THEN CONTINUE FOREACH END IF
            IF g_pia.pia02 IS NULL THEN
               LET l_pia01 = ''
               CONTINUE FOREACH
            END IF
            IF l_stat=3 THEN
               #MOD-B70286 --- modify --- start ---
               IF tm.noinv1 = 'N' AND g_pia.pia08 = 0 THEN
                  LET l_pia01 = ''
                  CONTINUE FOREACH
               END IF
               #MOD-B70286 --- modify ---  end  ---
               LET g_paper1 = g_paper1 + 1
               CALL s_auto_assign_no("aim",tm.tag1,tm.exedate,"5","pia_file","pia01","","","")
               RETURNING li_result,g_pia.pia01
               IF (NOT li_result) THEN
                   LET g_success = 'N'
                   EXIT FOREACH
               END IF
               IF g_paper1 = 1 THEN
                  LET g_bstk = g_pia.pia01
                  LET l_tag1 = tm.tag1
                  IF l_tag1.getlength() > 6 THEN 
                     LET tm.tag1 =  s_get_doc_no(tm.tag1)
                  END IF
               END IF
               LET l_pia01=g_pia.pia01  #No.MOD-610107 add
               IF g_pia.pia04 IS NULL THEN LET g_pia.pia04 = ' ' END IF
               IF g_pia.pia05 IS NULL THEN LET g_pia.pia05 = ' ' END IF
               message g_pia.pia01
               CALL ui.Interface.refresh()   #No.MOD-480110
               LET g_pia930=t800_set_pia930(g_pia.pia02) #FUN-680006
               PUT t800_cpia  FROM g_pia.pia01,g_pia.pia02,g_pia.pia03,
                                   g_pia.pia04,g_pia.pia05,g_pia.pia06,
                                   g_pia.pia07,g_pia.pia08,g_pia.pia09,
                                   g_pia.pia10,
                                   g_user,g_today,'','',g_zero,'N','N',g_pia930,g_plant,g_legal #FUN-680006 #FUN-980004 add  g_plant,g_legal
               IF SQLCA.sqlcode THEN
                    CALL cl_err('ckp#1',SQLCA.sqlcode,1)
                    LET g_success = 'N'
                    RETURN
               END IF
               IF cl_null(g_begin) THEN LET g_begin=g_pia.pia01 END IF
               LET g_end = g_pia.pia01
            END IF
         END IF  #MOD-D40070
         IF g_sma.sma115 ='Y' THEN
            SELECT ima906 INTO l_ima906 FROM ima_file
             WHERE ima01=g_pia.pia02
            IF l_ima906 MATCHES '[23]' THEN
               FOREACH t800_cs_piaa USING l_pia01,g_pia.pia02,g_pia.pia03,  #NO.MOD-610107 add
                                          g_pia.pia04,g_pia.pia05           #NO.MOD-610107 add
                                     INTO l_imgg.*,l_piaa01,
                                          l_piaa19
                  IF SQLCA.sqlcode != 0 THEN
                     CALL cl_err('foreach cs_piaa:',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                     RETURN
                  END IF
                  IF l_piaa19='Y' THEN CONTINUE FOREACH END IF
                  IF l_piaa01 IS NOT NULL AND l_piaa01 !=' ' THEN
                      CALL ui.Interface.refresh()   #No.MOD-480110
                      CALL t800_com_piaa08(l_imgg.*) RETURNING l_imgg.imgg10   #No:CHI-B20003 add
                     EXECUTE t800_uppiaa USING l_imgg.imgg10,l_piaa01,l_imgg.imgg09
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                          CALL cl_err(l_piaa01,'mfg0157',0)
                          LET g_success = 'N'
                          RETURN
                     END IF
                     CONTINUE FOREACH
                  END IF
                  IF l_imgg.imgg02 IS NULL THEN CONTINUE FOREACH END IF
                  IF tm.noinv1 = 'N' THEN
                     IF l_imgg.imgg10 = 0 THEN
                        CONTINUE FOREACH
                     END IF
                  END IF
                  LET g_paper1 = g_paper1 + 1
                   CALL ui.Interface.refresh()   #No.MOD-480110
                  LET g_pia930=t800_set_pia930(g_pia.pia02) #FUN-680006
		  LET l_imgg.imgg10 = s_digqty(l_imgg.imgg10,l_imgg.imgg09)   #No.FUN-BB0086
                  PUT t800_cpiaa  FROM l_imgg.imgg00,l_pia01,     g_pia.pia02,
                                       g_pia.pia03,  g_pia.pia04, g_pia.pia05,
                                       g_pia.pia06,  g_pia.pia07, l_imgg.imgg10,
                                       l_imgg.imgg09,l_imgg.imgg21,g_user,g_today,
                                       '','',g_zero,'N','N',g_pia930,g_plant,g_legal #FUN-680006 #FUN-980004 add g_plant,g_legal
                  IF SQLCA.sqlcode THEN
                       CALL cl_err('ckp#1.1',SQLCA.sqlcode,1)
                       LET g_success = 'N'
                       RETURN
                  END IF
               END FOREACH
            END IF
         END IF
 
        #庫存資料(imgs_file)寫入各料件的pias_file中
        LET l_ima918=''
        LET l_ima921=''
        SELECT ima918,ima921 INTO l_ima918,l_ima921 FROM ima_file
         WHERE ima01=g_pia.pia02
        IF l_ima918='Y' OR l_ima921='Y' THEN
          #------------------No:CHI-B20003  modify
          #    FOREACH t800_cimgs USING g_pia.pia02,g_pia.pia03,
          #                             g_pia.pia04,g_pia.pia05 
          #       INTO l_imgs.*
               FOREACH t800_cs_pias1 USING l_pia01,g_pia.pia02,g_pia.pia03,
                                       g_pia.pia04,g_pia.pia05 
                 INTO l_imgs.*,l_pias.*
          #------------------No:CHI-B20003  end
                  IF SQLCA.sqlcode != 0 THEN
                     CALL s_errmsg('','','foreach imgs:',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
                  IF l_pias.pias19='Y' THEN CONTINUE FOREACH END IF    #No:CHI-B20003  add
                  IF l_imgs.imgs05 IS NULL THEN LET l_imgs.imgs05=' ' END IF
                  IF l_imgs.imgs06 IS NULL THEN LET l_imgs.imgs06=' ' END IF
                 #------------------No:CHI-B20003 mark
                 #SELECT COUNT(*) INTO l_n FROM pias_file
                 # WHERE pias02=l_imgs.imgs01 AND pias03=l_imgs.imgs02
                 #   AND pias04=l_imgs.imgs03 AND pias05=l_imgs.imgs04
                 #   AND pias06=l_imgs.imgs05 
                 #   AND pias07=l_imgs.imgs06 
                 #   AND pias19='N'
                 #IF l_n>0 THEN
                 #   CONTINUE FOREACH
                 #END IF
                 #------------------No:CHI-B20003 end
                  IF tm.noinv1 = 'N' THEN
                     IF l_imgs.imgs08 = 0 THEN
                        LET l_pia01 = ''             #MOD-B70286 add
                        CONTINUE FOREACH
                     END IF
                  END IF
                  CALL t800_com_pias09(l_imgs.*) RETURNING l_imgs.imgs08   #No:CHI-B20003

                 #------------------No:CHI-B20003 add
                 IF NOT cl_null(l_pias.pias01) THEN 
                     EXECUTE t800_uppias1 USING l_imgs.imgs08,l_pias.pias01,l_pias.pias06,l_pias.pias07
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                          CALL cl_err(l_pias.pias01,'mfg0157',0)
                          LET g_success = 'N'
                          RETURN
                     END IF
                     CONTINUE FOREACH
                  END IF
                 #------------------No:CHI-B20003 end
                  IF g_pia.pia01 IS NULL THEN LET g_pia.pia01=l_pia01 END IF            #No.FUN-8A0147 add 08/12/25
                  CALL ui.Interface.refresh()
                  PUT t800_cpias  FROM 
                     g_pia.pia01, 
                     g_pia.pia02,g_pia.pia03, g_pia.pia04, g_pia.pia05,
                     l_imgs.imgs05,l_imgs.imgs06,'',
                     l_imgs.imgs08,l_imgs.imgs07,g_user,g_today,'','N',g_plant,g_legal #FUN-980004 add  g_plant,g_legal
                  IF SQLCA.sqlcode THEN
                       CALL s_errmsg('','','ckp#1.1-ins pias_file',SQLCA.sqlcode,1)
                       LET g_success = 'N'
                       EXIT FOREACH
                  END IF
              END FOREACH
               #CHI-B60100 --- modify --- start ---
              IF cl_null(g_pia.pia01) THEN LET g_pia.pia01 = l_pia01 END IF  #MOD-D40070
              LET l_sql = " SELECT imgs05,imgs06,imgs08 FROM pia_file,imgs_file ",
                          "  WHERE pia02 = imgs01 AND pia03 = imgs02 ",
                          "    AND pia04 = imgs03 AND pia05 = imgs04 ",
                          "    AND pia02 = ? AND pia03 = ? ",
                          "    AND pia04 = ? AND pia05 = ? "
              PREPARE t800_s_pias FROM l_sql
              DECLARE t800_cs_pias CURSOR WITH HOLD FOR t800_s_pias
              FOREACH t800_cs_pias USING g_pia.pia02,g_pia.pia03,g_pia.pia04,g_pia.pia05
                                    INTO l_imgs05,l_imgs06,l_imgs08
                 EXECUTE t800_uppias USING l_imgs08,g_pia.pia01,g_pia.pia02,g_pia.pia03,
                                           g_pia.pia04,g_pia.pia05,l_imgs05,l_imgs06
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL s_errmsg('','','foreach t800_uppias:',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                     RETURN
                 END IF
                 CONTINUE FOREACH
              END FOREACH
              #CHI-B60100 --- modify ---  end  ---
        END IF

        #CHI-B90001 --START--        
        IF s_industry('icd') THEN           
           #FUN-BA0051 --START mark--
           #LET l_imaicd08=''           
           #SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
           # WHERE imaicd00 = g_pia.pia02
           #IF l_imaicd08 = 'Y' THEN   #走刻號/BIN管理
           #FUN-BA0051 --END mark--
           IF s_icdbin(g_pia.pia02) THEN   #FUN-BA0051
              FOREACH t800_cs_piad USING l_pia01,g_pia.pia02,g_pia.pia03,g_pia.pia04,g_pia.pia05
               INTO l_idc.*,l_piad.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL s_errmsg('','','foreach piad:',SQLCA.sqlcode,1)
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
                 
                 IF l_piad.piad19='Y' THEN CONTINUE FOREACH END IF   #已過帳
                 IF l_idc.idc05 IS NULL THEN LET l_idc.idc05=' ' END IF
                 IF l_idc.idc06 IS NULL THEN LET l_idc.idc06=' ' END IF                 
                 #包含已無庫存量資料
                 IF tm.noinv1 = 'N' THEN
                    IF l_idc.idc08 = 0 THEN
                       CONTINUE FOREACH
                    END IF
                 END IF
                 #標籤已存在,更新庫存量
                 IF NOT cl_null(l_piad.piad01) THEN 
                    EXECUTE t800_uppiad USING l_idc.idc08,l_piad.piad01,l_piad.piad06,l_piad.piad07
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                         CALL cl_err(l_piad.piad01,'mfg0157',0)
                         LET g_success = 'N'
                         RETURN
                    END IF
                    CONTINUE FOREACH
                 END IF
                 #標籤不存在,新增標籤
                 IF g_pia.pia01 IS NULL THEN LET g_pia.pia01=l_pia01 END IF
                  CALL ui.Interface.refresh()
                  PUT t800_cpiad  FROM 
                     g_pia.pia01, 
                     g_pia.pia02,g_pia.pia03, g_pia.pia04, g_pia.pia05,
                     l_idc.idc05,l_idc.idc06,'',
                     l_idc.idc08,l_idc.idc07,g_user,g_today,'','N',g_plant,g_legal
                  IF SQLCA.sqlcode THEN
                       CALL s_errmsg('','','ckp#1.1-ins piad_file',SQLCA.sqlcode,1)
                       LET g_success = 'N'
                       EXIT FOREACH
                  END IF                 
              END FOREACH 
           END IF            
        END IF    
        #CHI-B90001 --END--        
 
     END FOREACH
 
     LET g_bstk1 = g_end  #CHI-960065
  END IF
 
  IF tm.wip='Y' THEN
     CALL t800_wogen()
  END IF
  #---->現有庫存空白標籤產生
  IF tm.spcg1 = 'Y' THEN
     LET g_spcstk = 0
     LET g_pia930=s_costcenter(g_grup) #FUN-680006
     LET l_n3 = 0 
     LET l_spc1 = tm.spc1
     IF l_spc1.getlength() > 6 THEN
        SELECT COUNT(*) INTO l_n3 FROM pia_file
         WHERE pia01 = tm.spc1
        IF l_n3 > 0 THEN 
           LET tm.spc1=s_get_doc_no(tm.spc1)
        END IF
     END IF
     FOR g_cnt=1 TO tm.qty1
        CALL s_auto_assign_no("aim",tm.spc1,tm.exedate,"5","pia_file","pia01","","","")
        RETURNING li_result,g_pia.pia01
        IF (NOT li_result) THEN
            LET g_success = 'N'
            EXIT FOR
        END IF
        IF g_spcstk = 0 THEN
           LET g_bspcstk = g_pia.pia01
           LET l_spc1 = tm.spc1
           IF l_spc1.getlength() > 6 THEN
              LET tm.spc1 =  s_get_doc_no(tm.spc1)
           END IF
         END IF
        message g_pia.pia01
        PUT t800_cpia  FROM g_pia.pia01,'','', '','','','','','',
                            '',g_user,g_today,'','',g_zero,'Y','N',g_pia930,g_plant,g_legal #FUN-680006 #FUN-980004 add  g_plant,g_legal
        IF SQLCA.sqlcode THEN
           CALL cl_err('ckp#6',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
        END IF
       LET g_spcstk = g_spcstk + 1   #CHI-960065
     END FOR
     LET g_bspcstk1 = g_pia.pia01      #CHI-960065
  END IF
 
  #產生在製工單空白標籤
  IF tm.spcg2 = 'Y' THEN
    LET g_spcwip  = 0
     LET l_n3 = 0
     LET l_spc2 = tm.spc2 
     IF l_spc2.getlength() > 6 THEN
        SELECT COUNT(*) INTO l_n3 FROM pid_file 
         WHERE pid01 = tm.spc2
        IF l_n3 > 0 THEN
           LET tm.spc2=s_get_doc_no(tm.spc2)
        END IF
     END IF
   	FOR g_cnt=1 TO tm.qty2
       CALL s_auto_assign_no("aim",tm.spc2,tm.exedate,"I","pid_file","pid01","","","")
       RETURNING li_result,l_pid01
       IF (NOT li_result) THEN
           LET g_success = 'N'
           EXIT FOR
       END IF
       IF g_spcwip = 0 THEN
          LET g_bspcwip = l_pid01  #記錄開始單號
          LET l_spc2 = tm.spc2
          IF l_spc2.getlength() > 6 THEN 
             LET tm.spc2 =  s_get_doc_no(tm.spc2)
          END IF
       END IF
       message l_pid01
       PUT t800_cpie2  FROM l_pid01,'Y','N',g_user,g_today,g_zero,g_plant,g_legal,' ','0'  #FUN-980004 add g_plant,g_legal   #FUN-A60095
       IF SQLCA.sqlcode THEN
          CALL cl_err('ckp#8',SQLCA.sqlcode,0)
          LET g_success = 'N'
          RETURN
       END IF
       LET g_spcwip = g_spcwip + 1   #CHI-960065
    END FOR
    LET g_bspcwip1 = l_pid01   #CHI-960065
 
  END IF
  CLOSE t800_cpia
  CLOSE t800_cpiaa   #No.FUN-570082
  CLOSE t800_cpias   #No.FUN-8A0147
  IF s_industry('icd') THEN CLOSE t800_cpiad END IF #CHI-B90001
  CLOSE t800_cpid
  CLOSE t800_cpie
  CLOSE t800_cpie2
  LET l_msg= "INV New No:",g_begin,"-",g_end," WIP New No:",g_begin2,"-",g_end2
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       MESSAGE l_msg
   ELSE
       DISPLAY l_msg AT 2,1
   END IF
            LET INT_FLAG = 0  ######add for prompt bug
#No.TQC-A90082  --Begin
# PROMPT '作業結束,請按任何鍵離開..!' FOR g_chr
#    ON IDLE g_idle_seconds
#       CALL cl_on_idle()
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#
# END PROMPT
#No.TQC-A90082  --End  
END FUNCTION

#------------------------------------No:CHI-B20003 add ------------------------------------------------
FUNCTION t800_com_pia08(p_pia)
   DEFINE l_bal         LIKE tlf_file.tlf10
   DEFINE l_imk09       LIKE imk_file.imk09
   DEFINE l_tlf10       LIKE tlf_file.tlf10
   DEFINE  xx           RECORD LIKE tlf_file.*
   DEFINE p_pia         RECORD
                        pia01  LIKE pia_file.pia01,    #標籤編號
                        pia02  LIKE pia_file.pia02,    #料件編號
                        pia03  LIKE pia_file.pia03,    #倉庫別
                        pia04  LIKE pia_file.pia04,    #存放位置
                        pia05  LIKE pia_file.pia05,    #批號
                        pia06  LIKE pia_file.pia06,    #庫存等級
                        pia07  LIKE pia_file.pia07,    #倉儲會計科目
                        pia08  LIKE pia_file.pia08,    #現有庫存
                        pia09  LIKE pia_file.pia09,    #庫存單位
                        pia10  LIKE pia_file.pia10,    #庫存/料件單位轉換率
                        ima06  LIKE ima_file.ima06,    #分群碼
                        ima09  LIKE ima_file.ima09,    #其它分群碼(1)
                        ima10  LIKE ima_file.ima10,    #其它分群碼(2)
                        ima11  LIKE ima_file.ima11,    #其它分群碼(3)
                        ima12  LIKE ima_file.ima12,    #其它分群碼(4)
                        ima23  LIKE ima_file.ima23     #倉管員
                        END RECORD

    
    LET l_imk09 = 0 
    SELECT imk09 INTO l_imk09 FROM imk_file WHERE imk01 = p_pia.pia02
           AND imk02 = p_pia.pia03 AND imk03 = p_pia.pia04
           AND imk04 = p_pia.pia05 AND imk05 = g_last_yy 
           AND imk06 = g_last_mm
    IF cl_null(l_imk09) THEN LET l_imk09 = 0 END IF
    LET l_bal = l_imk09

    FOREACH t800_ctlf USING p_pia.pia02,p_pia.pia03,p_pia.pia04,p_pia.pia05 INTO xx.*
       IF STATUS THEN
          CALL cl_err('t800_ctlf',STATUS,0)
          LET g_success = 'N'
          RETURN 0
       END IF
       IF xx.tlf10 IS NULL THEN LET xx.tlf10=0 END IF
       IF xx.tlf12 IS NULL OR xx.tlf12=0 THEN LET xx.tlf12=1 END IF
       IF xx.tlf031=p_pia.pia03 AND xx.tlf032=p_pia.pia04 AND xx.tlf033=p_pia.pia05 AND xx.tlf13 != 'apmt1071' THEN
          LET xx.tlf10  = xx.tlf10 *  1
       ELSE  
          LET xx.tlf10  = xx.tlf10 * -1
       END IF
       LET l_tlf10 =  xx.tlf10*xx.tlf12
       LET l_bal = l_bal + l_tlf10
    END FOREACH
    RETURN l_bal

END FUNCTION

FUNCTION t800_com_piaa08(p_imgg)
   DEFINE l_bal         LIKE tlff_file.tlff10
   DEFINE l_imkk09      LIKE imkk_file.imkk09
   DEFINE l_tlff10      LIKE tlff_file.tlff10
   DEFINE  xx           RECORD LIKE tlff_file.*
   DEFINE  p_imgg       RECORD LIKE imgg_file.*
    
    LET l_imkk09 = 0 
    SELECT imkk09 INTO l_imkk09 FROM imkk_file WHERE imkk01 = p_imgg.imgg01
           AND imkk02 = p_imgg.imgg02 AND imkk03 = p_imgg.imgg03
           AND imkk04 = p_imgg.imgg04 AND imkk10 = p_imgg.imgg09
           AND imkk05 = g_last_yy AND imkk06 = g_last_mm
          
    IF cl_null(l_imkk09) THEN LET l_imkk09 = 0 END IF
    LET l_bal = l_imkk09

    FOREACH t800_ctlff USING p_imgg.imgg01,p_imgg.imgg02,p_imgg.imgg03,p_imgg.imgg04,p_imgg.imgg09 INTO xx.*
       IF STATUS THEN
          CALL cl_err('t800_ctlff',STATUS,0)
          LET g_success = 'N'
          RETURN 0
       END IF
       IF xx.tlff10 IS NULL THEN LET xx.tlff10=0 END IF
       IF xx.tlff031=p_imgg.imgg02 AND xx.tlff032=p_imgg.imgg03 AND xx.tlff033=p_imgg.imgg04 AND xx.tlff13 != 'apmt1071' THEN
          LET xx.tlff10  = xx.tlff10 *  1
       ELSE  
          LET xx.tlff10  = xx.tlff10 * -1
       END IF
       LET l_tlff10 =  xx.tlff10
       LET l_bal = l_bal + l_tlff10
    END FOREACH
    RETURN l_bal

END FUNCTION

FUNCTION t800_com_pias09(p_imgs)
   DEFINE l_bal         LIKE tlfs_file.tlfs13
   DEFINE l_imks09      LIKE imks_file.imks09
   DEFINE l_tlfs13      LIKE tlfs_file.tlfs13
   DEFINE  xx           RECORD LIKE tlfs_file.*
   DEFINE  p_imgs       RECORD LIKE imgs_file.*
    
    LET l_imks09 = 0 
    SELECT imks09 INTO l_imks09 FROM imks_file WHERE imks01 = p_imgs.imgs01
           AND imks02 = p_imgs.imgs02 AND imks03 = p_imgs.imgs03
           AND imks04 = p_imgs.imgs04 AND imks10 = p_imgs.imgs05
           AND imks11 = p_imgs.imgs06 AND imks12 = p_imgs.imgs11
           AND imks05 = g_last_yy AND imks06 = g_last_mm
          
    IF cl_null(l_imks09) THEN LET l_imks09 = 0 END IF
    LET l_bal = l_imks09

    FOREACH t800_ctlfs USING p_imgs.imgs01,p_imgs.imgs02,p_imgs.imgs03,p_imgs.imgs04,
                             p_imgs.imgs05,p_imgs.imgs06 INTO xx.*
       IF STATUS THEN
          CALL cl_err('t800_ctlfs',STATUS,0)
          LET g_success = 'N'
          RETURN 0
       END IF
       IF xx.tlfs13 IS NULL THEN LET xx.tlfs13=0 END IF
       LET l_tlfs13 =  xx.tlfs13*xx.tlfs09
       LET l_bal = l_bal + l_tlfs13
    END FOREACH
    RETURN l_bal

END FUNCTION
#------------------------------------No:CHI-B20003 end ------------------------------------------------ 
FUNCTION t800_udpic()
   DEFINE l_time  LIKE type_file.chr8
   DEFINE l_pic06 LIKE pic_file.pic06      #MOD-A60191 add
   DEFINE l_pic15 LIKE pic_file.pic15      #MOD-A60191 add
   DEFINE l_pic26 LIKE pic_file.pic26      #MOD-A60191 add
   DEFINE l_pic35 LIKE pic_file.pic35      #MOD-A60191 add

   LET l_time = TIME
   LET l_pic06=tm.tag1[1,5]   #MOD-A60191 add
   LET l_pic15=tm.spc1[1,5]   #MOD-A60191 add
   LET l_pic26=tm.tag2[1,5]   #MOD-A60191 add
   LET l_pic35=tm.spc2[1,5]   #MOD-A60191 add
   INSERT INTO pic_file (pic01,pic02,pic03,pic04,pic05,pic06,pic07,  #No.MOD-470041
                        pic08,pic09,pic10,pic11,pic12,pic13,pic14,
                        pic15,pic16,pic17,pic18,pic19,pic20,pic21,
                        pic22,pic23,pic24,pic25,pic26,pic27,pic28,
                        pic29,pic30,pic31,pic32,pic33,pic34,pic35,
                        pic36,pic37,pic38,pic39,pic40,pic41,pic42,pic43)
   VALUES(g_date,l_time,g_program,g_user,tm.stk,l_pic06,'',    #CHI-960065  #MOD-A60191 mod tm.tag1->l_pic06`
          tm.noinv1,' ',' ',g_bstk,g_bstk1,g_paper1,tm.spcg1,l_pic15, #CHI-960065 estk-->bstk1  #MOD-A60191 tm.spc1->l_pic15
          '',tm.qty1,g_bspcstk,g_bspcstk1,g_spcstk,tm.order1,  #CHI-960065
          tm.class1,' ',' ',tm.wip,l_pic26,'',' ',' ',' ',     #CHI-960065 tm.seno2-->''  #MOD-A60191 tm.tag2->l_pic26
          g_bwip,g_bwip1,g_paper2,tm.spcg2,l_pic35,'',tm.qty2,      #CHI-960065  #MOD-A60191 tm.spc2->l_pic35
          g_bspcwip,g_bspcwip1,g_spcwip,tm.order2,' ',' ')   #CHI-960065
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pic_file",g_date,"",SQLCA.sqlcode,"","insert",1)   #NO.FUN-640266 #No.FUN-660156
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
END FUNCTION
 
#---->單倉處理
FUNCTION t800_2()
   DEFINE l_name	LIKE type_file.chr20, 	# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
         #l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT  #No.FUN-690026 VARCHAR(600) ##MOD-C90008 mark
          l_sql         STRING,                 #MOD-C90008
          l_za05	LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
	  l_wc          LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
          g_pia         RECORD
                        pia01  LIKE pia_file.pia01,    #標籤編號
                        pia02  LIKE pia_file.pia02,    #料件編號
                        pia08  LIKE pia_file.pia08,    #庫存數量
                        pia09  LIKE pia_file.pia09,    #庫存單位
                        ima06  LIKE ima_file.ima06,    #分群碼
                        ima09  LIKE ima_file.ima09,    #其它分群碼(1)
                        ima10  LIKE ima_file.ima10,    #其它分群碼(2)
                        ima11  LIKE ima_file.ima11,    #其它分群碼(3)
                        ima12  LIKE ima_file.ima12,    #其它分群碼(4)
                        ima23  LIKE ima_file.ima23     #倉管員
                        END RECORD,
          l_pia01       LIKE pia_file.pia01,
          l_pia02       LIKE pia_file.pia02,           #NO.FUN-A20044
          l_pia19       LIKE pia_file.pia19,           #No.B113 010328 by plum
          l_sfb01       LIKE sfb_file.sfb01,
          l_sfb01_old   LIKE sfb_file.sfb01,
          l_sfb02       LIKE sfb_file.sfb02,
          l_sfb04       LIKE sfb_file.sfb04,
          l_sfb05       LIKE sfb_file.sfb05,
          l_sfb15       LIKE sfb_file.sfb15,
          l_sfb82       LIKE sfb_file.sfb82,
          l_sfa03       LIKE sfa_file.sfa03,
          l_sfa08       LIKE sfa_file.sfa08,
          l_sfa11       LIKE sfa_file.sfa11,
          l_sfa12       LIKE sfa_file.sfa12,
          l_work        LIKE ecm_file.ecm06,
          l_pid01       LIKE pid_file.pid01,
          l_item        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
	  l_sw          LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
DEFINE    li_result     LIKE type_file.num5     #CHI-960065
DEFINE l_tag1         STRING                 #CHI-960065
DEFINE l_tag2         STRING                 #CHI-960065
DEFINE l_spc1         STRING                 #CHI-960065
DEFINE l_spc2         STRING                 #CHI-960065
DEFINE l_n3           LIKE type_file.num5    #CGI-960065
DEFINE l_n1           LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
DEFINE l_n2           LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
  #---->產生再有庫存狀況
  IF tm.stk = 'Y' THEN
     LET l_sql = "SELECT ' ',ima01,ima25,",
                  " ima06,ima09,ima10,ima11,ima12,ima23,",
                  " pia01,pia19 ",     #No.B113 010328 by plum
                  " FROM ima_file LEFT OUTER JOIN pia_file ON pia_file.pia02 = ima01",     #MOD-B10045 add pia_file.
                  " WHERE ima08 NOT IN ('C','D','A') "
 
     IF tm.noinv1 = 'N' THEN
#       LET l_sql = l_sql clipped ," AND ima262 > 0 "  #NO.FUN-A20044
        LET l_sql = l_sql clipped                      #NO.FUN-A20044
     END IF
 
     LET l_sw='N'
     FOR g_i = 1 TO 6       #資料產生順序
        CASE tm.order1[g_i,g_i]
	 	   WHEN '1' IF l_sw='N' THEN
                         LET l_wc=' ORDER BY ima23' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,ima23'
                    END IF
           WHEN '5' IF l_sw='N' THEN
	 	         LET l_wc=' ORDER BY ima01' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,ima01'
                    END IF
           WHEN '6'
	             IF l_sw='N' THEN  LET l_sw='Y'
					CASE tm.class1
					  WHEN '0' LET l_wc=' ORDER BY ima06 '
					  WHEN '1' LET l_wc=' ORDER BY ima09 '
					  WHEN '2' LET l_wc=' ORDER BY ima10 '
			    	  WHEN '3' LET l_wc=' ORDER BY ima11 '
					  WHEN '4' LET l_wc=' ORDER BY ima12 '
					  OTHERWISE EXIT CASE
                    END CASE
                 ELSE
					CASE tm.class1
			    	  WHEN '0' LET l_wc=l_wc CLIPPED,' ,ima06'
					  WHEN '1' LET l_wc=l_wc CLIPPED,' ,ima09'
					  WHEN '2' LET l_wc=l_wc CLIPPED,' ,ima10'
					  WHEN '3' LET l_wc=l_wc CLIPPED,' ,ima11'
					  WHEN '4' LET l_wc=l_wc CLIPPED,' ,ima12'
					  OTHERWISE EXIT CASE
                    END CASE
                 END IF
           OTHERWISE LET l_wc = l_wc  CLIPPED
        END CASE
     END FOR
     LET l_sql =l_sql CLIPPED,l_wc CLIPPED
 
     PREPARE t800_prepare21 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM END IF
     DECLARE t800_cs21 CURSOR WITH HOLD FOR t800_prepare21
 
     #現有庫存起始流水號
     LET g_paper1 = 0
     FOREACH t800_cs21 INTO g_pia.*,l_pia01,l_pia19
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          RETURN
       END IF
  ##NO.FUN-A20044   --begin
       SELECT pia02 INTO l_pia02 FROM pia_file 
        WHERE pia01 = l_pia01
                       
       CALL s_getstock(l_pia02,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
       IF tm.noinv1 = 'N' THEN 
         IF l_n3 < = 0 THEN 
           CONTINUE FOREACH 
         END IF 
       END IF 
  ##NO.FUN-A20044   --end
      #No.B113 010328 by plum 新增,若已過帳不處理
       IF l_pia19='Y' THEN CONTINUE FOREACH END IF
 
       IF l_pia01 IS NOT NULL AND l_pia01 !=' '
      #THEN EXECUTE t800_uppia USING g_pia.pia08,g_pia.pia01
       THEN EXECUTE t800_uppia USING g_pia.pia08,l_pia01  #MOD-B70012 mod
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0
            THEN CALL cl_err(g_pia.pia01,'mfg0157',0)
                 LET g_success = 'N'
                 RETURN
            END IF
            CONTINUE FOREACH
       END IF
       IF g_pia.pia02 IS NULL THEN CONTINUE FOREACH END IF
       LET g_paper1 = g_paper1 + 1
       CALL s_auto_assign_no("aim",tm.tag1,tm.exedate,"5","pia_file","pia01","","","")
       RETURNING li_result,g_pia.pia01
       IF (NOT li_result) THEN
           LET g_success = 'N'
           EXIT FOREACH
       END IF
       IF g_paper1 = 1 THEN
          LET g_bstk = g_pia.pia01   #記錄起始單號
          LET l_tag1 = tm.tag1
          IF l_tag1.getlength() > 6 THEN
             LET tm.tag1 =  s_get_doc_no(tm.tag1)
          END IF
       END IF
       message g_pia.pia01
        CALL ui.Interface.refresh()   #No.MOD-480110
       PUT t800_cpia2 FROM g_pia.pia01,g_pia.pia02,g_pia.pia08,
                           g_pia.pia09,'1',g_user,g_today,
                           ' ',' ',g_zero,'N','N',g_plant,g_legal #FUN-980004 add g_plant,g_legal
       IF SQLCA.sqlcode THEN
            CALL cl_err(g_pia.pia01,SQLCA.sqlcode,0)
            LET g_success = 'N'
            RETURN
       END IF
     END FOREACH
     LET g_bstk1 = g_pia.pia01  #CHI-960065
 
  END IF
 
  #---->在製工單標籤產生
  IF tm.wip ='Y' THEN
     CALL t800_wogen()
  END IF
 
  #---->現有庫存空白標籤產生
  IF tm.spcg1 = 'Y' THEN
     LET g_spcstk = 0
     LET l_n3 = 0 
     LET l_spc1 = tm.spc1 
     IF l_spc1.getlength() > 6 THEN 
        SELECT COUNT(*) INTO l_n3 FROM pia_file
         WHERE pia01 = tm.spc1 
        IF l_n3 > 0 THEN
           LET tm.spc1=s_get_doc_no(tm.spc1)
        END IF
     END IF
     FOR g_cnt=1 TO tm.qty1
        CALL s_auto_assign_no("aim",tm.spc1,tm.exedate,"5","pia_file","pia01","","","")
        RETURNING li_result,g_pia.pia01
        IF (NOT li_result) THEN
            LET g_success = 'N'
            EXIT FOR
        END IF
        IF g_spcstk = 0 THEN
           LET g_bspcstk = g_pia.pia01
           LET l_spc1 = tm.spc1                                                                                                    
           IF l_spc1.getlength() > 6 THEN                                                                                          
              LET tm.spc1 =  s_get_doc_no(tm.spc1)                                                                                 
           END IF
        END IF
        message g_pia.pia01
        PUT t800_cpia2  FROM g_pia.pia01,'','','',
                            '',g_user,g_today,'','',g_zero,'Y','N',g_plant,g_legal  #FUN-980004 add  g_plant,g_legal
        IF SQLCA.sqlcode THEN
           CALL cl_err('ckp#6',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
        END IF
        LET g_spcstk = g_spcstk + 1   #CHI-960065
     END FOR
     LET g_bspcstk1 = g_pia.pia01     #CHI-960065
  END IF
 
  #---->在製工單空白標籤列印
  IF tm.spcg2 = 'Y' THEN
 
    LET g_spcwip  = 0
     LET l_n3 = 0
     LET l_spc2 = tm.spc2 
     IF l_spc2.getlength() > 6 THEN
        SELECT COUNT(*) INTO l_n3 FROM pid_file
         WHERE pid01 = tm.spc2
        IF l_n3 > 0 THEN
           LET tm.spc2=s_get_doc_no(tm.spc2)
        END IF
     END IF
   	FOR g_cnt=1 TO tm.qty2
       CALL s_auto_assign_no("aim",tm.spc2,tm.exedate,"I","pid_file","pid01","","","")
       RETURNING li_result,l_pid01
       IF (NOT li_result) THEN
           LET g_success = 'N'
           EXIT FOR
       END IF
       IF g_spcwip = 0 THEN
          LET g_bspcwip = l_pid01
          LET l_spc2 = tm.spc2 
          IF l_spc2.getlength() > 6 THEN
             LET tm.spc2 =  s_get_doc_no(tm.spc2) 
          END IF
       END IF
       message l_pid01
       PUT t800_cpie2  FROM l_pid01,'Y','N',g_user,g_today,g_zero,g_plant,g_legal,' ','0' #FUN-980004 add g_plant,g_legal #FUN-A60095
       IF SQLCA.sqlcode THEN
          CALL cl_err('ckp#8',SQLCA.sqlcode,0)
          LET g_success = 'N'
          RETURN
       END IF
       LET g_spcwip = g_spcwip + 1    #CHI-960065

    END FOR
    LET g_bspcwip1 = l_pid01  #CHI-960065

  END IF
 
  CLOSE t800_cpia2
  CLOSE t800_cpid
  CLOSE t800_cpie
  CLOSE t800_cpie2
END FUNCTION
 
FUNCTION t800_wogen()
 DEFINE   l_sfb01       LIKE sfb_file.sfb01,
          l_sfb01_old   LIKE sfb_file.sfb01,
          l_sfb02       LIKE sfb_file.sfb02,
          l_sfb04       LIKE sfb_file.sfb04,
          l_sfb05       LIKE sfb_file.sfb05,
          l_sfb06       LIKE sfb_file.sfb06,
          l_sfb071      LIKE sfb_file.sfb071,
          l_sfb08       LIKE sfb_file.sfb08,
          l_sfb09       LIKE sfb_file.sfb09,
          l_sfb10       LIKE sfb_file.sfb10,
          l_sfb11       LIKE sfb_file.sfb11,
          l_sfb12       LIKE sfb_file.sfb12,
          l_sfb15       LIKE sfb_file.sfb15,
          l_sfb82       LIKE sfb_file.sfb82,
          l_sfa03       LIKE sfa_file.sfa03,
          l_sfa05       LIKE sfa_file.sfa05,
          l_sfa06       LIKE sfa_file.sfa06,
          l_sfa062      LIKE sfa_file.sfa062,
          l_sfa063      LIKE sfa_file.sfa063,
          l_sfa065      LIKE sfa_file.sfa065,
          l_sfa13       LIKE sfa_file.sfa13,
          l_sfa161      LIKE sfa_file.sfa161,
          l_sfa08       LIKE sfa_file.sfa08,
          l_sfa11       LIKE sfa_file.sfa11,
          l_sfa12       LIKE sfa_file.sfa12,
          l_sfa012      LIKE sfa_file.sfa012,
          l_sfa013      LIKE sfa_file.sfa013,  
          l_pid01       LIKE pid_file.pid01,
          l_pid01_2     LIKE pid_file.pid01,
          l_ima55       LIKE ima_file.ima55,
          l_work        LIKE ecm_file.ecm06,
          l_actuse      LIKE pie_file.pie153,
          l_uninv       LIKE pie_file.pie153,
          l_actuse_e    LIKE pie_file.pie153,
          l_uninv_e     LIKE pie_file.pie153,
          l_sfa27       LIKE sfa_file.sfa27,    #MOD-580005 應發bom料號
          l_sfa27_2     LIKE sfa_file.sfa27,    #MOD-580005
          l_sfa26       LIKE sfa_file.sfa26,    #MOD-580005 發料料號
          l_sfa05_e     LIKE sfa_file.sfa05,    #應發數量
          l_sfa06_e     LIKE sfa_file.sfa06,    #已發數量
          l_sfa062_e    LIKE sfa_file.sfa062,   #超領數量
          l_sfa161_e    LIKE sfa_file.sfa161,   #QPA
          l_sfa063_e    LIKE sfa_file.sfa063,   #報廢數量
          l_sfa065_e    LIKE sfa_file.sfa065,   #代買數量
          l_ecb03       LIKE ecb_file.ecb03,    #MOD-560202
          l_uninv_e_2   LIKE type_file.num10,   #MOD-580005  #No.FUN-690026 INTEGER
          l_sql         STRING, #No.FUN-690026 VARCHAR(600)  #FUN-A60095
          l_wc          LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(400)
          l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_item        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_pie07       LIKE pie_file.pie07     #FUN-760040
   DEFINE l_sfa28       LIKE sfa_file.sfa28     #No.MOD-910031 add
   DEFINE li_result     LIKE type_file.num5     #CHI-960065
   DEFINE l_tag2        STRING                  #CHI-960065
   DEFINE l_n3          LIKE type_file.num5     #CHI-960065  
 
  #---->在製工單盤點資料產生作業
    #MOD-B50256---modify---start---
     LET l_sql = "SELECT sfb01, sfb02, sfb04, sfb05, sfb06, ",
                 "       sfb071,sfb08, sfb09, sfb10, sfb11,",
                 "       sfb12, sfb15, sfb82,",
                 "       sfa03, sfa05, sfa06, sfa062,sfa063,",
                 "       sfa065,sfa13, sfa161, sfa08, sfa11,",
                 "       sfa12, sfa26, sfa27 , sfa012, sfa013, pid01, ima55", #MOD-580005  #FUN-A60027 add sfa012,sfa013
                 " FROM sfb_file, ", #FUN-A60095
                 "      sfa_file ",
                 "   LEFT OUTER JOIN ima_file ON ima_file.ima01 = sfa03 ",    #MOD-B10045 add ima_file.
                 "   LEFT OUTER JOIN pid_file ON pid_file.pid02 = sfa01 AND pid_file.pid021=sfa013 AND pid_file.pid012=sfa012 AND pid_file.pid022=sfa08", #FUN-A60095     #MOD-B10045 add pid_file.
                 " WHERE sfb01 = sfa01 ",
                 "   AND sfb04 BETWEEN 4 AND 7 ",
                 "   AND sfa05 > 0 AND sfb87!='X' ",
    #LET l_sql = "SELECT sfb01, sfb02, sfb04, sfb05, sfb06, ",
    #            "       sfb071,sfb08, sfb09, sfb10, sfb11,",
    #            "       sfb12, sfb15, sfb82,",
    #            "       sfa03, sfa05, sfa06, sfa062,sfa063,",
    #            "       sfa065,sfa13, sfa161, sfa08, sfa11,",
    #            "       sfa12, sfa26, sfa27 ,pid01, ima55", 
    #            " FROM sfb_file,sfa_file,pid_file ",
    #            "      ,ima_file ",
    #            " WHERE sfb01 = sfa01 ",
    #            "   AND sfb01 = pid_file.pid02(+) ",
    #            "   AND sfa03 = ima_file.ima01(+) ",
    #            "   AND sfb04 BETWEEN 4 AND 7 ",
    #            "   AND sfa05 > 0 AND sfb87!='X' ",
                 "   AND sfa11 !='E' ",                                     #CHI-B70010 add
                 "UNION ",
                 "SELECT sfb01, sfb02, sfb04, sfb05, sfb06, ",
                 "       sfb071,sfb08, sfb09, sfb10, sfb11,",
                 "       sfb12, sfb15, sfb82,",
                 "       sfa03, sfa05, sfa06, sfa062,sfa063,",
                 "       sfa065,sfa13, sfa161, sfa08, sfa11,",
                 "       sfa12, sfa26, sfa27 , sfa012, sfa013, pid01, ima55", 
               # " FROM sfb_file,sfa_file,pid_file ",
               # "      ,ima_file ",
                 " FROM sfb_file, ", 
                 "      pid_file, ",  #MOD-CB0258 add
                 "      sfa_file  ",
                 "   LEFT OUTER JOIN ima_file ON ima_file.ima01 = sfa03 ",    
               # "   LEFT OUTER JOIN pid_file ON pid_file.pid02 = sfa01 AND pid_file.pid021=sfa013 AND pid_file.pid012=sfa012 AND pid_file.pid022=sfa08",  #MOD-CB0258 mark 
                 " WHERE sfb01 = sfa01 ",
               # "   AND sfa03 = ima_file.ima01(+) ",
               # "   AND sfb01 = pid_file.pid02(+) ",
                 "   AND (sfb04 < 4 OR sfb04 > 7) ",
                 "   AND sfa05 > 0 AND sfb87!='X' ",  #MOD-CB0258 add ,
                 "   AND sfa11 !='E' ",                                     #CHI-B70010 add
                 "   AND pid02 = sfa01 ",             #MOD-CB0258 add
                 "   AND pid021= sfa013 ",            #MOD-CB0258 add
                 "   AND pid012= sfa012 ",            #MOD-CB0258 add
                 "   AND pid022= sfa08 "              #MOD-CB0258 add
    #MOD-B50256---modify---end--
     IF NOT cl_null(g_wc2) THEN
        LET l_sql=l_sql CLIPPED," AND ",g_wc2 CLIPPED
     END IF
     LET l_sw='N'
     FOR g_i = 1 TO 6       #資料產生順序
        CASE tm.order2[g_i,g_i]
	 	   WHEN '1' IF l_sw='N' THEN
                         LET l_wc=' ORDER BY sfb05' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,sfb05'
                    END IF
           WHEN '2' IF l_sw='N' THEN
                         LET l_wc=' ORDER BY sfb15' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,sfb15'
                    END IF
           WHEN '3' IF l_sw='N' THEN
                     LET l_wc=' ORDER BY sfb04' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,sfb04'
                    END IF
           WHEN '4' IF l_sw='N' THEN
                        LET l_wc=' ORDER BY sfb02' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,sfb02'
                    END IF
           WHEN '5' IF l_sw='N' THEN
	 	                 LET l_wc=' ORDER BY sfb01' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,sfb01'
                    END IF
           WHEN '6' IF l_sw='N' THEN
	 	                 LET l_wc=' ORDER BY sfb82' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,sfb82'
                    END IF
           OTHERWISE LET l_wc = l_wc  CLIPPED
        END CASE
     END FOR
     IF cl_null(l_wc) THEN
         LET l_wc = l_wc clipped," ORDER BY sfa03"
     ELSE
         LET l_wc = l_wc clipped,",sfa03"
     END IF
     LET l_sql =l_sql CLIPPED,l_wc CLIPPED
     PREPARE t800_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM END IF
     DECLARE t800_cs1 CURSOR WITH HOLD FOR t800_prepare1
 
     LET g_paper2 = 0
     LET l_sfb01_old ='!@$$%^&*()'
     LET l_item = 0
     LET l_n3 = 0 
     LET l_tag2 = tm.tag2
     IF l_tag2.getlength() > 6 THEN
        SELECT COUNT(*) INTO l_n3 FROM pid_file 
         WHERE pid01 = tm.tag2
        IF l_n3 > 0 THEN
           LET tm.tag2 = s_get_doc_no(tm.tag2)
        END IF
     END IF
     FOREACH t800_cs1 INTO l_sfb01, l_sfb02, l_sfb04,
                           l_sfb05, l_sfb06, l_sfb071,
                           l_sfb08, l_sfb09, l_sfb10, l_sfb11,
                           l_sfb12, l_sfb15, l_sfb82,
                           l_sfa03, l_sfa05, l_sfa06, l_sfa062,
                           l_sfa063,l_sfa065,l_sfa13, l_sfa161, l_sfa08,
                           l_sfa11, l_sfa12, l_sfa26, l_sfa27, l_sfa012,l_sfa013,     #MOD-580005  #FUN-A60027
                           l_pid01_2,l_ima55
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          RETURN
       END IF
       SELECT COUNT(*) INTO l_n FROM pie_file
          WHERE pie01=l_pid01_2 AND pie16='Y'
       IF l_n>0 THEN CONTINUE FOREACH END IF
       #--->此張工單已產生過(將數量重新更正一次)
       IF l_pid01_2 IS NOT NULL AND l_pid01_2 != ' ' THEN
            message l_pid01_2
             CALL ui.Interface.refresh()   #No.MOD-480110
            #-->更新盤點標籤單頭檔
         #FUN-910088--add--start--
            LET l_sfb09 = s_digqty(l_sfb09,l_ima55)
            LET l_sfb10 = s_digqty(l_sfb10,l_ima55)
            LET l_sfb11 = s_digqty(l_sfb11,l_ima55)
            LET l_sfb12 = s_digqty(l_sfb12,l_ima55)
         #FUN-910088--add--end--
            EXECUTE t800_uppid USING l_sfb09,     #完工入庫量
                                     l_sfb10,     #再加工量
                                     l_sfb11,     #F Q C 量
                                     l_sfb12,     #報廢量
                                     l_pid01_2
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err(l_pid01_2,'mfg0171',0)
               LET g_success = 'N'
               RETURN
               CALL cl_err(l_sfb01,'aim1002','0')
                CALL ui.Interface.refresh()   #No.MOD-480110
               SLEEP 1
               LET g_success = 'N'
               RETURN
            END IF
            #-->更新在製工單盤點單身檔(pie_file)
            FOREACH t800_cexit
            USING l_pid01_2,l_sfb01,l_sfa03,l_sfa08,l_sfa12,l_sfa012,l_sfa013    #FUN-A60027 add sfa012,sfa013
                               INTO l_sfa05_e,      #應發數量
                                    l_sfa06_e,      #已發數量
                                    l_sfa062_e,     #超領數量
                                    l_sfa161_e,      #QPA
                                    l_sfa063_e,     #報廢數量
                                    l_sfa065_e,     #代買數量
                                    l_pie07         #產生項次  #FUN-760040
            IF SQLCA.sqlcode THEN 
               LET g_success = 'N'
               RETURN
            END IF
            IF l_sfa05_e IS NULL OR l_sfa05_e = ' '
            THEN LET l_sfa05_e = 0
            END IF
            IF l_sfa06_e IS NULL OR l_sfa06_e = ' '
            THEN LET l_sfa06_e = 0
            END IF
            IF l_sfa062_e IS NULL OR l_sfa062_e = ' '
            THEN LET l_sfa062_e = 0
            END IF
            IF l_sfa161_e IS NULL OR l_sfa161_e = ' '
            THEN LET l_sfa161_e = 0
            END IF
            IF l_sfa063_e IS NULL OR l_sfa063_e = ' '
            THEN LET l_sfa063_e = 0
            END IF
            IF l_sfa065_e IS NULL OR l_sfa065_e = ' '
            THEN LET l_sfa065_e = 0
            END IF
 
          # IF l_sfa26 MATCHES '[SU]' THEN      #FUN-A20037
            IF l_sfa26 MATCHES '[SUZ]' THEN     #FUN-A20037
               SELECT sfa28 INTO l_sfa28 FROM sfa_file
                  WHERE sfa01 = l_sfb01
                    AND sfa03 = l_sfa03
                    AND sfa08 = l_sfa08
                    AND sfa12 = l_sfa12               #FUN-A60027
                    AND sfa012 = l_sfa012             #FUN-A60027 
                    AND sfa013 = l_sfa013             #FUN-A60027
              #CHI-B10015---add---start---
               SELECT sfa161 INTO l_sfa161_e FROM sfa_file
                WHERE sfa01 = l_sfb01
                  AND sfa03 = l_sfa27
                  AND sfa27 = l_sfa27
               IF cl_null(l_sfa161_e) THEN LET l_sfa161_e = 0 END IF
              #CHI-B10015---add---end---
               IF STATUS THEN LET l_sfa28 = 1 END IF
               LET l_sfa161_e = l_sfa161_e * l_sfa28 
               LET l_sfa28 = 1  
            END IF
 
              #--->計算未入庫數量
              #    實際已用量=((完工入庫量 + 報廢數量) * qpa ) + 下階報廢
              #    應盤數量  = 已發數量 + 超領數量 - 實際已用量
              LET l_actuse_e = ((l_sfb09 + l_sfb12) * l_sfa161_e) + l_sfa063_e
              LET l_uninv_e = (l_sfa06_e + l_sfa062_e) - l_actuse_e
             IF l_uninv_e < 0 THEN LET l_uninv_e = 0 END IF  #No.MOD-910031 add
              #-->更新盤點標籤單身檔
            #FUN-910088--add--start--
              LET l_sfa05_e = s_digqty(l_sfa05_e,l_sfa12)
              LET l_sfa06_e = s_digqty(l_sfa06_e,l_sfa12)
              LET l_sfa062_e = s_digqty(l_sfa062_e,l_sfa12)
              LET l_sfa063_e = s_digqty(l_sfa063_e,l_sfa12)
              LET l_sfa065_e = s_digqty(l_sfa065_e,l_sfa12)
              LET l_uninv_e = s_digqty(l_uninv_e,l_sfa12)    
            #FUN-910088--add--end--
              EXECUTE t800_uppie USING l_sfa05_e,      #應發數量
                                       l_sfa06_e,      #已發數量
                                       l_sfa062_e,     #超領數量
                                       l_sfa161_e,      #QPA
                                       l_sfa063_e,     #報廢數量
                                       l_sfa065_e,     #代買數量
                                       l_uninv_e,      #應盤數量
                                       l_pid01_2,l_pie07
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0
                 THEN CALL cl_err(l_pid01_2,'mfg0172',0)
                      LET g_success='N'
                      RETURN
                 END IF
            END FOREACH
          CONTINUE FOREACH
       END IF
       #---->是否使用製程(#ASM 54)
       IF g_sma.sma54 = 'Y' THEN
          #---->工單生產製程追蹤設定(#ASM 26)
          IF g_sma.sma26 = '1' THEN
             LET l_work = ' ' #FUN-A60095
             SELECT ecb08 INTO l_work
                          FROM ecb_file
                         WHERE ecb01 = l_sfb05
                           AND ecb02 = l_sfb06
                           AND ecb02 = l_sfa08
                           AND (ecb04 IS NULL OR ecb04 <= l_sfb071)
                           AND (ecb05 IS NULL OR ecb05 >  l_sfb071)
                           AND ecbacti='Y'
          ELSE
             LET l_work = ' ' #FUN-A60095
             SELECT ecm06 INTO l_work
                          FROM ecm_file WHERE ecm01 = l_sfb01
                                         #AND ecm03 = l_sfa08      #FUN-A60076 mark
                                          AND ecm012 = l_sfa012    #FUN-A60027
                                         #AND ecm013 = l_sfa013    #FUN-A60027  #FUN-A60076 mark
                                          AND ecm03 = l_sfa013     #FUN-A60076 
          END IF
       END IF
       IF l_sfb01 != l_sfb01_old THEN
          CALL s_auto_assign_no("aim",tm.tag2,tm.exedate,"I","pid_file","pid01","","","")
             RETURNING li_result,l_pid01
             IF (NOT li_result) THEN
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             IF g_paper2 = 0 THEN
                LET g_bwip = l_pid01
                LET l_tag2 = tm.tag2
                IF l_tag2.getlength() > 6 THEN
                   LET tm.tag2 =  s_get_doc_no(tm.tag2)
                END IF
             END IF 
          #產生[在製工單]盤點標籤檔
          message l_pid01
           CALL ui.Interface.refresh()   #No.MOD-480110
         #FUN-A60095 mark (S)
         #SELECT ecb03 INTO l_ecb03 FROM ecb_file
         #   WHERE ecb01=l_sfb05 AND ecb02=l_sfb06
         #IF SQLCA.sqlcode THEN
         #   LET l_ecb03=NULL
         #END IF
         #FUN-A60095 mark (E)
         #FUN-910088--add--start--
          LET l_sfb09 = s_digqty(l_sfb09,l_ima55)
          LET l_sfb10 = s_digqty(l_sfb10,l_ima55)
          LET l_sfb11 = s_digqty(l_sfb11,l_ima55) 
          LET l_sfb12 = s_digqty(l_sfb12,l_ima55)
         #FUN-910088--add--end--
          PUT t800_cpid  FROM l_pid01,l_sfb01,l_sfb05,l_sfb08,l_ima55,
                              'N','N',g_user,g_today,'','',g_zero,
                              l_sfb09,l_sfb10,l_sfb11,l_sfb12,
                              l_sfb82,
                              #l_ecb03,   #FUN-A60095
                               l_sfa013,  #FUN-A60095
                               l_sfa08,l_sfb82,g_plant,g_legal, #MOD-560202 #FUN-980004 add g_plant,g_legal
                               l_sfa012   #FUN-A60095
          IF SQLCA.sqlcode THEN
             CALL cl_err('ckp#3',SQLCA.sqlcode,1)
             LET g_success = 'N'
             RETURN
          END IF
           IF cl_null(g_begin2) THEN LET g_begin2=l_pid01 END IF
           LET g_end2 = l_pid01
          LET g_paper2 = g_paper2 + 1
          LET l_item = 0
       END IF
       LET l_item = l_item + 1
       #--->計算未入庫數量
       #    實際已用量=((完工入庫量 + 報廢數量) * qpa ) + 下階報廢
       #    應盤數量  = 已發數量 + 超領數量 - 實際已用量
        LET l_actuse = ((l_sfb09 + l_sfb12) * l_sfa161) + l_sfa063
        LET l_uninv = (l_sfa06 + l_sfa062) - l_actuse
       #---->產生盤點標籤明細[在製工單](下階用料)資料檔
        IF l_uninv < 0 THEN LET l_uninv = 0 END IF   #No.MOD-910031 add
       #FUN-910088--add--start--
        LET l_sfa05 = s_digqty(l_sfa05,l_sfa12)
        LET l_sfa06 = s_digqty(l_sfa06,l_sfa12)
        LET l_sfa062 = s_digqty(l_sfa062,l_sfa12)
        LET l_sfa063 = s_digqty(l_sfa063,l_sfa12)
        LET l_sfa065 = s_digqty(l_sfa065,l_sfa12)
        LET l_uninv = s_digqty(l_uninv,l_sfa12)
       #FUN-910088--add--end--
        PUT t800_cpie  FROM l_pid01,l_sfa03,l_sfa08,
                            l_sfa12,l_work,l_sfa11,l_item,
                            l_sfa05,l_sfa06,l_sfa062,l_sfa161,
                            l_sfa063,l_sfa065,l_sfa13,l_uninv,'N',g_plant,g_legal,  #FUN-980004 add g_plant,g_legal
                            l_sfa012,l_sfa013,l_sfa27   #FUN-A60027 add sfa012,sfa013  #FUN-A60095
        IF SQLCA.sqlcode THEN
           CALL cl_err('ckp#4',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN     #No.MOD-7C0014 add
        END IF
        LET l_sfb01_old = l_sfb01
 
     END FOREACH
 
     LET g_bwip1 = l_pid01   #CHI-960065記錄截止單號
 
END FUNCTION
 
FUNCTION t800_stk()
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW t800_wstk AT p_row,p_col
         WITH FORM "aim/42f/aimt8001"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimt8001")
 
    CONSTRUCT BY NAME g_wc1 ON ima23,img02,img03,img04,img01,ima06
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
                 
       #TQC-C80015--add--str--
       ON ACTION controlp
          CASE    
             WHEN INFIELD(img01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO img01
                  NEXT FIELD img01
             WHEN INFIELD(img02)      #倉庫別
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_imd"
                  LET g_qryparam.arg1 = 'SW'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO img02
                  NEXT FIELD img02
             WHEN INFIELD(img03)      #儲位
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.arg2 = 'SW'
                  LET g_qryparam.form = "q_ime"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO img03
                  NEXT FIELD img03    
             WHEN INFIELD(img04)      #批號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_img"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO img04
                  NEXT FIELD img04
             WHEN INFIELD(ima06) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_imz"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima06
                  NEXT FIELD ima06
             WHEN INFIELD(ima23)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima23
                  NEXT FIELD ima23
             OTHERWISE EXIT CASE
          END CASE
       #TQC-C80015--add--end--

       ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()   #FUN-550037(smin)
 
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
LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
    IF INT_FLAG THEN
       LET INT_FLAG=0
    END IF
    CLOSE WINDOW t800_wstk
END FUNCTION
 
FUNCTION t800_wip()
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW t800_wwip AT p_row,p_col
         WITH FORM "aim/42f/aimt8002"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimt8002")
 
    CONSTRUCT BY NAME g_wc2 ON sfa01,sfb82
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

       #TQC-C80015--add--str--
       ON ACTION controlp
          CASE
             WHEN INFIELD(sfa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_sfa10"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfa01
                  NEXT FIELD sfa01
             WHEN INFIELD(sfb82)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_sfb82"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb82
                  NEXT FIELD sfb82
             OTHERWISE EXIT CASE
          END CASE
       #TQC-C80015--add--end--

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
       LET INT_FLAG=0
    END IF
    CLOSE WINDOW t800_wwip
END FUNCTION
 
FUNCTION t800_control()
  IF tm.stk='Y' THEN
      CALL cl_set_comp_entry("tag1,noinv1,spcg1,              #CHI-960065 拿掉seno1  
                              o1,o2,o3,o4,o5,o6,class1,spc1",TRUE)  #MOD-D20013 spc1
      CALL cl_set_comp_required("tag1,noinv1,spcg1,           #CHI-960065 拿掉seno1
                              o1,o2,o3,o4,o5,o6,class1",TRUE)
  ELSE
      LET tm.noinv1='N'
      LET tm.spcg1='N'
      LET tm.tag1=''
      CALL cl_set_comp_entry("tag1,noinv1,spcg1,               #CHI-960065 拿掉seno1
                              o1,o2,o3,o4,o5,o6,class1,spc1",FALSE)  #MOD-D20013 spc1
      CALL cl_set_comp_required("tag1,noinv1,spcg1,            #CHI-960065 拿掉seno1
                              o1,o2,o3,o4,o5,o6,class1",FALSE)
       DISPLAY BY NAME tm.noinv1,tm.spcg1,tm.tag1              #CHI-960065 拿掉seno1
  END IF
 
  IF tm.spcg1='Y' THEN
      #CALL cl_set_comp_entry("spc1,qty1",TRUE)  #CHI-960065 拿掉spno1
      CALL cl_set_comp_entry("qty1",TRUE)  #MOD-D20013
      CALL cl_set_comp_required("spc1,qty1",TRUE)   #No.FUN-590035
  ELSE
      #CALL cl_set_comp_entry("spc1,qty1",FALSE)     #CHI-960065 拿掉spno1 #MOD-D20013
      CALL cl_set_comp_entry("qty1",FALSE)  #MOD-D20013
      CALL cl_set_comp_required("spc1,qty1",FALSE)  #CHI-960065 拿掉spno1
      LET tm.spc1=''
      LET tm.qty1=''
      DISPLAY BY NAME tm.spc1,tm.qty1               #CHI-960065 拿掉spno1
  END IF
  IF tm.wip='Y' THEN
      CALL cl_set_comp_entry("tag2,spcg2,              #CHI-960065 拿掉seno2
                              k1,k2,k3,k4,k5,k6,spc2",TRUE)  #MOD-D20013 spc2
      CALL cl_set_comp_required("tag2,spcg2,           #CHI-960065 拿掉seno2
                              k1,k2,k3,k4,k5,k6",TRUE)
  ELSE
      LET tm.spcg2='N'
      LET tm.tag2=''
      CALL cl_set_comp_entry("tag2,spcg2,              #CHI-960065 拿掉seno2
                              k1,k2,k3,k4,k5,k6,spc2",FALSE)  #MOD-D20013 spc2
      CALL cl_set_comp_required("tag2,spcg2,           #CHI-960065 拿掉seno2
                              k1,k2,k3,k4,k5,k6",FALSE)
      DISPLAY BY NAME tm.spcg2,tm.tag2                 #CHI-960065 拿掉seno2
  END IF
 
  IF tm.spcg2='Y' THEN
      #CALL cl_set_comp_entry("spc2,qty2",TRUE)        #CHI-960065 拿掉spno2  #MOD-D20013
      CALL cl_set_comp_entry("qty2",TRUE)  #MOD-D20013
      CALL cl_set_comp_required("spc2,qty2",TRUE)   #No.FUN-590035
  ELSE
      LET tm.spc2=''
      LET tm.qty2=''
      #CALL cl_set_comp_entry("spc2,qty2",FALSE)    #CHI-960065 拿掉spno2  #MOD-D20013
      CALL cl_set_comp_entry("qty2",FALSE)  #MOD-D20013
      CALL cl_set_comp_required("spc2,qty2",FALSE) #CHI-960065 拿掉spno2
      DISPLAY BY NAME tm.spc2,tm.qty2              #CHI-960065 拿掉spno2
  END IF
END FUNCTION
 
FUNCTION t800_set_pia930(p_pia02)
DEFINE p_pia02 LIKE pia_file.pia02
DEFINE l_ima23 LIKE ima_file.ima23
DEFINE l_gen03 LIKE gen_file.gen03
  SELECT gen03 INTO l_gen03 FROM gen_file,ima_file
                           WHERE ima01=p_pia02
                             AND gen01=ima23
  RETURN s_costcenter(l_gen03)
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
    
