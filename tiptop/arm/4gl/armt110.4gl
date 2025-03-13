# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: armt110.4gl
# Descriptions...: RMA單維護作業
# Date & Author..: 98/03/11 By  Wu
# Modify.........: 98/03/21 By plum
# Modify.........: No.MOD-490371 04/09/22 By Kitty Controlp 未加display
# Modify.........: No.MOD-490407 04/09/23 By Wiky 覆出日期<預計到貨日要show出警告
# Modify.........: No.MOD-4A0197 04/10/13 By Mandy 無法使用列印功能
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0058 04/11/24 By Mandy 匯率加開窗功能
# Modify.........: No.FUN-4C0055 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0085 04/12/16 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-550064 05/05/28 By Trisy 單據編號加大
# Modify.........: NO.FUN-570265 05/08/19 By Yiting 應在armt110 勾稽 armi100 的客訴單
# Modify.........: No.MOD-5B0133 05/11/23 By Rosayu RMA單號加開窗查詢
# Modify.........: No.MOD-5B0189 05/11/23 By Rosayu 變更客戶資料不能修改
# Modify.........: No.TQC-610087 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-640267 06/04/11 By kim RMA單據登錄日期應不可小於RMA登記日期
# Modify.........: No.MOD-640452 06/04/18 By Sarah 當已做過點收確認,不可做取消確認
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-650046 06/05/15 By sam_lin 修改處理狀況說明顯示方式COMBOBOX
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0018 06/10/05 By jamie 1.FUNCTION t110()_q 一開始應清空g_rma.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0085 06/10/26 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-790027 07/09/17 By Pengu 若l_rmb14=null時應default為0
# Modify.........: No.MOD-7A0186 07/10/30 By ciare 確認時,若幣別(rma16)匯率(rma17)是空白不可確認
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-840068 08/04/23 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-950060 09/05/08 By Smapmin 預設覆出日期
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-930007 09/09/07 By chenmoyan 給交運方式加開窗
# Modify.........: No.TQC-9C0202 10/01/04 By lilingyu 由客訴單自動產生單身資料的sql寫錯
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-BB0084 11/12/31 By lixh1 增加數量欄位小數取位
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30085 12/06/29 By lixiang 串CR報表改串GR報表
# Modify.........: No.CHI-C80041 12/12/20 By bart 排除作廢
# Modify.........: No:FUN-D40030 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_rma           RECORD LIKE rma_file.*,       #RMA單號  (單頭)
    g_rma_t         RECORD LIKE rma_file.*,       #RMA單號  (舊值)
    g_rma_o         RECORD LIKE rma_file.*,       #RMA單號  (舊值)
    g_rma01_t       LIKE rma_file.rma01,   #簽核等級 (舊值)
#   g_t1            VARCHAR(03),
    g_t1            LIKE oay_file.oayslip,              #No.FUN-550064  #No.FUN-690010 VARCHAR(05)
#   g_sheet         VARCHAR(3),               #單別    (沿用)
    g_sheet         LIKE oay_file.oayslip,  #No.FUN-690010 VARCHAR(05),              #No.FUN-550064
    g_cmd           LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(100)
   #g_ydate         DATE,                  #單據日期(沿用)
    g_rmb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    rmb02     LIKE rmb_file.rmb02,   #項次
                    rmb03     LIKE rmb_file.rmb03,   #料件編號
                    rmb05     LIKE rmb_file.rmb05,   #品名
                    rmb06     LIKE rmb_file.rmb06,   #規格
                    rmb04     LIKE rmb_file.rmb04,   #單位
                    rmb11     LIKE rmb_file.rmb11,   #INVO數量
                    rmb12     LIKE rmb_file.rmb12,   #實收數量
                    rmb13     LIKE rmb_file.rmb13,   #單價
                    rmb14     LIKE rmb_file.rmb14,   #金額
                    rmb15     LIKE rmb_file.rmb15,   #P/NO
                    rmb16     LIKE rmb_file.rmb16,   #C/NO
                    rmb17     LIKE rmb_file.rmb17,   #ORG/INVO#
                    #FUN-840068 --start---
                    rmbud01   LIKE rmb_file.rmbud01,
                    rmbud02   LIKE rmb_file.rmbud02,
                    rmbud03   LIKE rmb_file.rmbud03,
                    rmbud04   LIKE rmb_file.rmbud04,
                    rmbud05   LIKE rmb_file.rmbud05,
                    rmbud06   LIKE rmb_file.rmbud06,
                    rmbud07   LIKE rmb_file.rmbud07,
                    rmbud08   LIKE rmb_file.rmbud08,
                    rmbud09   LIKE rmb_file.rmbud09,
                    rmbud10   LIKE rmb_file.rmbud10,
                    rmbud11   LIKE rmb_file.rmbud11,
                    rmbud12   LIKE rmb_file.rmbud12,
                    rmbud13   LIKE rmb_file.rmbud13,
                    rmbud14   LIKE rmb_file.rmbud14,
                    rmbud15   LIKE rmb_file.rmbud15
                    #FUN-840068 --end--
                    END RECORD,
    g_rmb_t         RECORD                 #程式變數 (舊值)
                    rmb02     LIKE rmb_file.rmb02,   #項次
                    rmb03     LIKE rmb_file.rmb03,   #料件編號
                    rmb05     LIKE rmb_file.rmb05,   #品名
                    rmb06     LIKE rmb_file.rmb06,   #規格
                    rmb04     LIKE rmb_file.rmb04,   #單位
                    rmb11     LIKE rmb_file.rmb11,   #INVO數量
                    rmb12     LIKE rmb_file.rmb12,   #實收數量
                    rmb13     LIKE rmb_file.rmb13,   #單價
                    rmb14     LIKE rmb_file.rmb14,   #金額
                    rmb15     LIKE rmb_file.rmb15,   #P/NO
                    rmb16     LIKE rmb_file.rmb16,   #C/NO
                    rmb17     LIKE rmb_file.rmb17,   #ORG/INVO#
                    #FUN-840068 --start---
                    rmbud01   LIKE rmb_file.rmbud01,
                    rmbud02   LIKE rmb_file.rmbud02,
                    rmbud03   LIKE rmb_file.rmbud03,
                    rmbud04   LIKE rmb_file.rmbud04,
                    rmbud05   LIKE rmb_file.rmbud05,
                    rmbud06   LIKE rmb_file.rmbud06,
                    rmbud07   LIKE rmb_file.rmbud07,
                    rmbud08   LIKE rmb_file.rmbud08,
                    rmbud09   LIKE rmb_file.rmbud09,
                    rmbud10   LIKE rmb_file.rmbud10,
                    rmbud11   LIKE rmb_file.rmbud11,
                    rmbud12   LIKE rmb_file.rmbud12,
                    rmbud13   LIKE rmb_file.rmbud13,
                    rmbud14   LIKE rmb_file.rmbud14,
                    rmbud15   LIKE rmb_file.rmbud15
                    #FUN-840068 --end--
                    END RECORD,
    g_rmb_o         RECORD                 #程式變數 (舊值)
                    rmb02     LIKE rmb_file.rmb02,   #項次
                    rmb03     LIKE rmb_file.rmb03,   #料件編號
                    rmb05     LIKE rmb_file.rmb05,   #品名
                    rmb06     LIKE rmb_file.rmb06,   #規格
                    rmb04     LIKE rmb_file.rmb04,   #單位
                    rmb11     LIKE rmb_file.rmb11,   #INVO數量
                    rmb12     LIKE rmb_file.rmb12,   #實收數量
                    rmb13     LIKE rmb_file.rmb13,   #單價
                    rmb14     LIKE rmb_file.rmb14,   #金額
                    rmb15     LIKE rmb_file.rmb15,   #P/NO
                    rmb16     LIKE rmb_file.rmb16,   #C/NO
                    rmb17     LIKE rmb_file.rmb17,   #ORG/INVO#
                    #FUN-840068 --start---
                    rmbud01   LIKE rmb_file.rmbud01,
                    rmbud02   LIKE rmb_file.rmbud02,
                    rmbud03   LIKE rmb_file.rmbud03,
                    rmbud04   LIKE rmb_file.rmbud04,
                    rmbud05   LIKE rmb_file.rmbud05,
                    rmbud06   LIKE rmb_file.rmbud06,
                    rmbud07   LIKE rmb_file.rmbud07,
                    rmbud08   LIKE rmb_file.rmbud08,
                    rmbud09   LIKE rmb_file.rmbud09,
                    rmbud10   LIKE rmb_file.rmbud10,
                    rmbud11   LIKE rmb_file.rmbud11,
                    rmbud12   LIKE rmb_file.rmbud12,
                    rmbud13   LIKE rmb_file.rmbud13,
                    rmbud14   LIKE rmb_file.rmbud14,
                    rmbud15   LIKE rmb_file.rmbud15
                    #FUN-840068 --end--
                    END RECORD,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_za05          LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
    g_rma22         LIKE rma_file.rma22
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_argv1     LIKE rma_file.rma01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0085
    p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
 
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
    LET p_row = 2 LET p_col = 6
    OPEN WINDOW t110_w AT p_row,p_col      #顯示畫面
         WITH FORM "arm/42f/armt110"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t110_q()
            END IF
         OTHERWISE        
            CALL t110_q() 
      END CASE
   END IF
   #--
 
    CALL t110_menu()
    CLOSE WINDOW t110_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION t110_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                                      #清除畫面
    CALL g_rmb.clear()
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_rma.* TO NULL    #No.FUN-750051
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" rma01='",g_argv1,"'"       #FUN-7C0050
      LET g_wc2=" 1=1"                      #FUN-7C0050
   ELSE
 
      CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        rma01,rma03,rma02,rma07,rma06,rma12,rma13,rma14,rma16,rma17,rma10,rma11,rma18,
        rma09,rma19,rmaconf,rmarecv,
        rmauser,rmagrup,rmamodu,rmadate,  #rmaacti
        #FUN-840068   ---start---
        rmaud01,rmaud02,rmaud03,rmaud04,rmaud05,
        rmaud06,rmaud07,rmaud08,rmaud09,rmaud10,
        rmaud11,rmaud12,rmaud13,rmaud14,rmaud15
        #FUN-840068    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
          CASE
               #MOD-5B0133 add
               WHEN INFIELD(rma01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rma4"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rma01
               #MOD-5B0133 end
 
               WHEN INFIELD(rma03)
#                CALL q_occ(0,0,g_rma.rma03) RETURNING g_rma.rma03
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rma03
#No.FUN-930007 --Begin
               WHEN INFIELD(rma11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ged"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rma11
                 NEXT FIELD rma11
#No.FUN-930007 --End
               WHEN INFIELD(rma13)
#                CALL q_gen(0,0,g_rma.rma13) RETURNING g_rma.rma13
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rma13
 
               WHEN INFIELD(rma14)
#                CALL q_gem(0,0,g_rma.rma14) RETURNING g_rma.rma14
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_rma.rma14
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rma14
 
               WHEN INFIELD(rma16)
#                CALL q_azi(5,10,g_rma.rma16) RETURNING g_rma.rma16
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_rma.rma16
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rma16
                 NEXT FIELD rma16
 
             OTHERWISE EXIT CASE
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
      IF INT_FLAG THEN RETURN END IF
 
   CONSTRUCT g_wc2 ON rmb02,rmb03,rmb05,rmb06,rmb04,rmb11,rmb12,rmb13,rmb14,
                      rmb15,rmb16,rmb17
                      #No.FUN-840068 --start--
                      ,rmbud01,rmbud02,rmbud03,rmbud04,rmbud05
                      ,rmbud06,rmbud07,rmbud08,rmbud09,rmbud10
                      ,rmbud11,rmbud12,rmbud13,rmbud14,rmbud15
                      #No.FUN-840068 ---end---
                      FROM s_rmb[1].rmb02,s_rmb[1].rmb03,s_rmb[1].rmb05,
                           s_rmb[1].rmb06,s_rmb[1].rmb04,s_rmb[1].rmb11,
                           s_rmb[1].rmb12,s_rmb[1].rmb13,s_rmb[1].rmb14,
                           s_rmb[1].rmb15,s_rmb[1].rmb16,s_rmb[1].rmb17
           #No.FUN-840068 --start--
           ,s_rmb[1].rmbud01,s_rmb[1].rmbud02,s_rmb[1].rmbud03
           ,s_rmb[1].rmbud04,s_rmb[1].rmbud05,s_rmb[1].rmbud06
           ,s_rmb[1].rmbud07,s_rmb[1].rmbud08,s_rmb[1].rmbud09
           ,s_rmb[1].rmbud10,s_rmb[1].rmbud11,s_rmb[1].rmbud12
           ,s_rmb[1].rmbud13,s_rmb[1].rmbud14,s_rmb[1].rmbud15
           #No.FUN-840068 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rmb03) #料件編號
#                   CALL q_ima(10,3,g_rmb[1].rmb03) RETURNING g_rmb[1].rmb03
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#                    LET g_qryparam.state = 'c'
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY g_qryparam.multiret TO rmb03
                    NEXT FIELD rmb03
 
               WHEN INFIELD(rmb04) #料件的單位
#                   CALL q_gfe(0,0,g_rmb[1].rmb04) RETURNING g_rmb[1].rmb04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rmb04
                    NEXT FIELD rmb04
               OTHERWISE EXIT CASE
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
 
    IF INT_FLAG THEN RETURN END IF
  END IF  #FUN-7C0050
 
  #資料權限的檢查
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                             #只能使用自己的資料
  #     LET g_wc = g_wc clipped," AND rmauser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                             #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND rmagrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc = g_wc clipped," AND rmagrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmauser', 'rmagrup')
  #End:FUN-980030
 
    IF g_wc2 = " 1=1" THEN                        #若單身未輸入條件
       LET g_sql = "SELECT rma01 FROM rma_file,oay_file ",
                   " WHERE ", g_wc CLIPPED,
#                  " AND rma01[1,3]=oayslip",
                   " AND rma01 like ltrim(rtrim(oayslip)) || '-%'",      #No.FUN-550064
                   " AND oaytype='70' ",
                   " ORDER BY rma01"
     ELSE                                         #若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  rma01 ",
                   "  FROM rma_file, rmb_file,oay_file ",
                   " WHERE rma01 = rmb01",
#                  " AND rma01[1,3]=oayslip ",
                   " AND rma01 like ltrim(rtrim(oayslip)) || '-%'",      #No.FUN-550064
                   " AND oaytype='70'",
#                  " AND rmb01[1,3]=oayslip ",
                   " AND rmb01 like trim(oayslip)||'-%'",      #No.FUN-550064
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY rma01"
    END IF
 
    PREPARE t110_prepare FROM g_sql
    DECLARE t110_cs                               #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t110_prepare
 
 
    LET g_forupd_sql =
        "SELECT * FROM rma_file WHERE rma01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t110_cl CURSOR FROM g_forupd_sql
 
    IF g_wc2 = " 1=1" THEN                        #取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM rma_file,oay_file WHERE ",
                   g_wc CLIPPED,
                   " AND oaytype='70'",
#                  " AND rma01[1,3]=oayslip "
                   " AND rma01 like ltrim(rtrim(oayslip)) || '-%'"      #No.FUN-550064
    ELSE
        LET g_sql="SELECT COUNT(*) FROM rma_file,rmb_file,oay_file WHERE ",
                  "rmb01=rma01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   " AND oaytype='70'",
#                  " AND rma01[1,3]=oayslip "
                   " AND rma01 like ltrim(rtrim(oayslip)) || '-%'"    #No.FUN-550064
    END IF
    PREPARE t110_precount FROM g_sql
    DECLARE t110_count CURSOR FOR t110_precount
END FUNCTION
 
FUNCTION t110_menu()
DEFINE    l_wc      LIKE type_file.chr1000  #No.TQC-610087 add  #No.FUN-690010 VARCHAR(200)
 
   WHILE TRUE
      CALL t110_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t110_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t110_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               #NO.FUN-570265
               SELECT rma22 INTO g_rma22
                 FROM rma_file
                WHERE rma01 = g_rma.rma01
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt
                 FROM rmb_file
                WHERE rmb01 = g_rma.rma01
               IF NOT cl_null(g_rma22) AND g_cnt = 0 THEN   #客訴單不為空白時
                  IF cl_confirm('arm-528') THEN
                      CALL t110_g_b()
                  END IF
               END IF
               CALL t110_b()
               #--END
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
            #---------------No.TQC-610087 modify--------------
              #LET g_cmd = 'armr181 "',g_rma.rma01,'"'
              ##LET g_cmd = "armr181 '",g_rma.rma01,"'"
              ##LET g_cmd = 'armr181 "',g_wc clipped,'"'
               LET l_wc = "rma01='",g_rma.rma01 CLIPPED,"'"
              #LET g_cmd = "armr181 '",g_today,"' '",g_user,"' '",g_lang,"' ",  #FUN-C30085 mark
               LET g_cmd = "armg181 '",g_today,"' '",g_user,"' '",g_lang,"' ",  #FUN-C30085 add
                           " 'Y' ' ' '1' ",'\" ',l_wc CLIPPED,' \" '
            #---------------No.TQC-610087 end------------------
               CALL cl_cmdrun(g_cmd CLIPPED)
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "確認"
         WHEN "confirm"
            CALL t110_y()
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            CALL t110_z()
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rmb),'','')
            END IF
         #No.FUN-6A0018-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_rma.rma01 IS NOT NULL THEN
                 LET g_doc.column1 = "rma01"
                 LET g_doc.value1 = g_rma.rma01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0018-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION t110_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rma.* TO NULL             #No.FUN-6A0018
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_rmb.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t110_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rma.* TO NULL
        RETURN
    END IF
    OPEN t110_cs                               #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rma.* TO NULL
    ELSE
        OPEN t110_count
        FETCH t110_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t110_fetch('F')                   #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t110_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                    #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                    #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t110_cs INTO g_rma.rma01
        WHEN 'P' FETCH PREVIOUS t110_cs INTO g_rma.rma01
        WHEN 'F' FETCH FIRST    t110_cs INTO g_rma.rma01
        WHEN 'L' FETCH LAST     t110_cs INTO g_rma.rma01
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
            FETCH ABSOLUTE g_jump t110_cs INTO g_rma.rma01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)
        INITIALIZE g_rma.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_rma.* FROM rma_file WHERE rma01 = g_rma.rma01
    IF SQLCA.sqlcode THEN
  #      CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0) #FUN-660111
        CALL cl_err3("sel","rma_file",g_rma.rma01,"",SQLCA.sqlcode,"","",1) #FUN-660111
        INITIALIZE g_rma.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_rma.rmauser #FUN-4C0055
        LET g_data_group = g_rma.rmagrup #FUN-4C0055
        LET g_data_plant = g_rma.rmaplant #FUN-980030
    END IF
 
    CALL t110_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t110_show()
  DEFINE l_occ02 LIKE occ_file.occ02
  DEFINE l_gem02 LIKE gem_file.gem02
  DEFINE l_gen02 LIKE gen_file.gen02
  DEFINE l_ged02 LIKE ged_file.ged02       #No.FUN-930007
 
    LET g_rma_t.* = g_rma.*                #保存單頭舊值
    LET g_rma_o.* = g_rma.*                #保存單頭舊值
    DISPLAY BY NAME
 
 
        g_rma.rma01,g_rma.rma02,g_rma.rma07,g_rma.rma06,g_rma.rma12,
        g_rma.rma16,g_rma.rma17,g_rma.rma10,g_rma.rma19,
        g_rma.rma11,g_rma.rma18,
        g_rma.rma03,g_rma.rma13,g_rma.rma14,g_rma.rma09,
        g_rma.rma16,g_rma.rma17,g_rma.rma19,g_rma.rmaconf,g_rma.rmarecv,
        g_rma.rmauser,g_rma.rmagrup,g_rma.rmamodu,g_rma.rmadate,
        #FUN-840068     ---start---
        g_rma.rmaud01,g_rma.rmaud02,g_rma.rmaud03,g_rma.rmaud04,
        g_rma.rmaud05,g_rma.rmaud06,g_rma.rmaud07,g_rma.rmaud08,
        g_rma.rmaud09,g_rma.rmaud10,g_rma.rmaud11,g_rma.rmaud12,
        g_rma.rmaud13,g_rma.rmaud14,g_rma.rmaud15 
        #FUN-840068     ----end----
 
    #CKP
    CALL cl_set_field_pic(g_rma.rmaconf,"","","","","")
    SELECT  occ02 INTO l_occ02   FROM occ_file WHERE   occ01=g_rma.rma03
    DISPLAY l_occ02 TO FORMONLY.occ02
    SELECT  gen02 INTO l_gen02   FROM gen_file WHERE   gen01=g_rma.rma13
    DISPLAY l_gen02 TO FORMONLY.gen02
    SELECT  gem02 INTO l_gem02   FROM gem_file WHERE   gem01=g_rma.rma14
    DISPLAY l_gem02 TO FORMONLY.gem02
#No.FUN-930007 --Begin
    SELECT  ged02 INTO l_ged02   FROM ged_file WHERE   ged01=g_rma.rma11
    DISPLAY l_ged02 TO FORMONLY.ged02
#No.FUN-930007 --End
#   CALL t110_rma09()          #NO.TQC-650046
 
#   CALL t110_rma03('d')       #顯示參考值
    CALL t110_b_fill(g_wc2)    #單身填充
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t110_u()
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rma.* FROM rma_file WHERE rma01 = g_rma.rma01
    IF g_rma.rma01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF  #No.FUN-6A0018 #MOD-7A0186
   #IF g_rma01_t IS NULL THEN CALL cl_err('','-400',0) RETURN END IF     #No.FUN-6A0018  #MOD-7A0186
    IF g_rma.rmavoid = 'N' THEN CALL cl_err('',9024,0) RETURN END IF
    IF g_rma.rmaconf = 'Y' THEN CALL cl_err('',9003,0) RETURN END IF
    IF g_rma.rma09 = '6' THEN CALL cl_err('','arm-018',0) RETURN END IF
    IF g_rma.rma02 IS NULL THEN LET g_rma.rma02=g_today END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_rma_t.* = g_rma.*
    LET g_rma_o.* = g_rma.*
    BEGIN WORK
 
    OPEN t110_cl USING g_rma.rma01
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_rma.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t110_cl ROLLBACK WORK RETURN
    END IF
    CALL t110_show()
    WHILE TRUE
        LET g_rma01_t = g_rma.rma01
        LET g_rma_t.* = g_rma.*
        LET g_rma.rmamodu=g_user
        LET g_rma.rmadate=g_today
       #LET g_rma.rma07=g_today
        CALL t110_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_rma.*=g_rma_t.*
            CALL t110_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF  g_rma.rma07 IS NULL OR g_rma.rma07 = ' '   OR
            g_rma.rma16 IS NULL OR g_rma.rma16 = ' '   OR
            g_rma.rma17 IS NULL OR g_rma.rma17 = ' '   OR
            g_rma.rma13 IS NULL OR g_rma.rma13 = ' '   OR
            g_rma.rma14 IS NULL OR g_rma.rma14 = ' '   THEN
           #LET g_rma.*=g_rma_t.*
           #CALL t110_show()
            DISPLAY BY NAME g_rma.rma07
            DISPLAY BY NAME g_rma.rma16
            DISPLAY BY NAME g_rma.rma17
            DISPLAY BY NAME g_rma.rma13
            DISPLAY BY NAME g_rma.rma14
            CALL cl_err('',9033,1)
            CONTINUE WHILE
        END IF
       {IF  g_rma.rma09 MATCHES '[1-3]' AND
            ( g_rma.rma12 IS NULL OR g_rma.rma12 = ' ' ) THEN
            DISPLAY BY NAME g_rma.rma09
            CALL cl_err('',9033,1)
            CONTINUE WHILE
        END IF }
        UPDATE rma_file SET rma_file.* = g_rma.* WHERE rma01 = g_rma.rma01
        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
  #          CALL cl_err(g_rma.rma01,STATUS,0) # FUN-660111
            CALL cl_err3("upd","rma_file",g_rma_t.rma01,"",SQLCA.sqlcode,"","",1) #FUN-660111
            CONTINUE WHILE
        END IF
        IF g_rma.rma01 != g_rma_t.rma01 THEN     #KEY值被更改
            LET g_rma.*=g_rma_t.*
            CALL t110_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
           #CALL t110_chkkey()
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t110_cl
    COMMIT WORK
 
    #CKP
    CALL cl_set_field_pic(g_rma.rmaconf,"","","","","")
 
END FUNCTION
 
{FUNCTION t110_chkkey()
           UPDATE rmb_file SET rmb01=g_rma.rma01 WHERE rmb01=g_rma_t.rma01
           IF STATUS THEN
              CALL cl_err('upd rmb01',STATUS,1)
              LET g_rma.*=g_rma_t.* CALL t110_show() ROLLBACK WORK RETURN
           END IF
END FUNCTION}
 
FUNCTION t110_i(p_cmd)
  DEFINE li_result   LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
  DEFINE p_cmd            LIKE type_file.chr1                  #a:輸入 u:更改  #No.FUN-690010 VARCHAR(1)
  DEFINE l_flag           LIKE type_file.chr1                 #判斷必要欄位是否有輸入  #No.FUN-690010 VARCHAR(1)
  DEFINE l_n1             LIKE type_file.num5    #No.FUN-690010 SMALLINT
  DEFINE l_oga01     LIKE oga_file.oga01
  DEFINE l_oga24     LIKE oga_file.oga24
  DEFINE l_oga23     LIKE oga_file.oga23
  DEFINE l_n              LIKE type_file.num5    #No.FUN-690010 SMALLINT
  DEFINE l_gen02     LIKE gen_file.gen02
  DEFINE l_gem02     LIKE gem_file.gem02
  DEFINE l_oga_desc  LIKE oga_file.oga24
  DEFINE l_azi01     LIKE azi_file.azi01,
         l_aza17     LIKE aza_file.aza17,
         l_occ02     LIKE occ_file.occ02,
         l_aza19     LIKE aza_file.aza19,
         l_azk01     LIKE azk_file.azk01,
         l_azk02     LIKE azk_file.azk02,
         l_azk04     LIKE azk_file.azk04,
         l_azj01     LIKE azj_file.azj01,
         l_azj03     LIKE azj_file.azj03
  DEFINE l_ged02     LIKE ged_file.ged02           #No.FUN-930007
 
    DISPLAY BY NAME
        g_rma.rmaconf,g_rma.rmarecv,g_rma.rmauser,g_rma.rmagrup,
        g_rma.rmamodu,g_rma.rmadate,g_rma.rma07
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME
        g_rma.rma01,g_rma.rma03,g_rma.rma02,g_rma.rma07,g_rma.rma06,g_rma.rma12,
        g_rma.rma13,g_rma.rma14,g_rma.rma16,
        g_rma.rma17,g_rma.rma10,g_rma.rma11,
        g_rma.rma18,g_rma.rma09,g_rma.rma19,
        #FUN-840068     ---start---
        g_rma.rmaud01,g_rma.rmaud02,g_rma.rmaud03,g_rma.rmaud04,
        g_rma.rmaud05,g_rma.rmaud06,g_rma.rmaud07,g_rma.rmaud08,
        g_rma.rmaud09,g_rma.rmaud10,g_rma.rmaud11,g_rma.rmaud12,
        g_rma.rmaud13,g_rma.rmaud14,g_rma.rmaud15 
        #FUN-840068     ----end----
            WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t110_set_entry(p_cmd)
            CALL t110_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         #No.FUN-550064 --start--
         CALL cl_set_docno_format("rma10")
         #No.FUN-550064 ---end---
 
      { AFTER FIELD rma01
           IF cl_null(g_rma.rma01) THEN NEXT FIELD rma01 END IF
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_rma.rma01 != g_rma01_t) THEN
               SELECT count(*) INTO l_n FROM rma_file
                    WHERE rma01 = g_rma.rma01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_rma.rma01,-239,0)
                    LET g_rma.rma01 = g_rma01_t
                    DISPLAY BY NAME g_rma.rma01
                    NEXT FIELD rma01
                END IF
           END IF   }
 
        BEFORE FIELD rma07
           IF cl_null(g_rma.rma07) THEN
              LET g_rma.rma07=g_today
              DISPLAY BY NAME g_rma.rma07
           END IF
 
        AFTER FIELD rma07
           IF cl_null(g_rma.rma07) THEN
              LET g_rma.rma07=g_today
              DISPLAY BY NAME g_rma.rma07
           ELSE
              #MOD-640267...............begin
              IF g_rma.rma02>g_rma.rma07 THEN
                 CALL cl_err('','arm-043',1)
                 NEXT FIELD rma02
              END IF
              #MOD-640267...............end
           END IF
           LET g_rma_o.rma07 = g_rma.rma07
 
        AFTER FIELD rma03
          IF NOT cl_null(g_rma.rma03) THEN
              IF g_rma.rma03 != g_rma_o.rma03 OR g_rma.rma03 IS NULL THEN
                  SELECT occ02 INTO l_occ02 FROM occ_file
                        WHERE occ01=g_rma.rma03 AND occacti='Y'
                  IF SQLCA.sqlcode THEN
  #                   CALL cl_err(g_rma.rma03,SQLCA.sqlcode,0) #FUN-660111
                     CALL cl_err3("sel","occ_file",g_rma.rma03,"",SQLCA.sqlcode,"","",1) #FUN-660111
                     LET g_rma.rma03 = g_rma_t.rma03
                     DISPLAY BY NAME g_rma.rma03
                     DISPLAY ' ' TO FOMRONLY.occ02
                     NEXT FIELD rma03
                  END IF
                  DISPLAY l_occ02 TO FORMONLY.occ02
              END IF
          END IF
          LET g_rma_o.rma03 = g_rma.rma03
 
          #-----MOD-950060---------
          AFTER FIELD rma06
             IF cl_null(g_rma.rma12) THEN  
                LET g_rma.rma12=g_rma.rma06+g_rmz.rmz20
                IF NOT cl_null(g_rma.rma12) THEN
                    CALL s_wkday(g_rma.rma12)  RETURNING l_flag,g_rma.rma12
                END IF
             END IF
          #-----END MOD-950060----- 
 
           #No.MOD-490407
#No.FUN-930007 --Begin
          AFTER FIELD rma11
            IF NOT cl_null(g_rma.rma11) THEN
               LET l_ged02=''
               SELECT ged02 INTO l_ged02 FROM ged_file
                WHERE ged01 = g_rma.rma11
               IF SQLCA.sqlcode=100 THEN
                  LET l_ged02 = ''
                  CALL cl_err(g_rma.rma11,'axm-309',0)
                  NEXT FIELD rma11
               END IF
               DISPLAY l_ged02 TO FORMONLY.ged02
            END IF
#No.FUN-930007 --End
          AFTER FIELD rma12
            IF NOT cl_null(g_rma.rma12) AND NOT cl_null(g_rma.rma06) THEN
               IF g_rma.rma12 < g_rma.rma06 THEN
                  CALL cl_err('','arm-527',1)
               END IF
            END IF
           #No.MOD-490407(end)
 
        AFTER FIELD rma13
            IF NOT cl_null(g_rma.rma13) THEN
                IF g_rma.rma13 != g_rma_o.rma13 THEN
                   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rma.rma13
                   IF SQLCA.sqlcode THEN
#                      CALL cl_err(g_rma.rma13,SQLCA.sqlcode,0) # FUN-660111
                      CALL cl_err3("sel","gen_file",g_rma.rma13,"",SQLCA.sqlcode,"","",1) #FUN-660111
                      LET g_rma.rma13 = g_rma_t.rma13
                      DISPLAY BY NAME g_rma.rma13
                      DISPLAY ' ' TO FOMRONLY.gen02
                      NEXT FIELD rma13
                   END IF
                   DISPLAY l_gen02 TO FORMONLY.gen02
                END IF
           END IF
           LET g_rma_o.rma13 = g_rma.rma13
 
       AFTER FIELD rma14
         IF NOT cl_null(g_rma.rma14) THEN
             IF g_rma.rma14 != g_rma_o.rma14 THEN
               SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_rma.rma14
                  AND gemacti='Y'   #NO:6950
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_rma.rma14,SQLCA.sqlcode,0) # FUN-660111
                  CALL cl_err3("sel","gem_file",g_rma.rma14,"",SQLCA.sqlcode,"","",1) #FUN-660111
                  LET g_rma.rma14 = g_rma_t.rma14
                  DISPLAY BY NAME g_rma.rma14
                  DISPLAY ' ' TO FOMRONLY.gem02
                  NEXT FIELD rma14
               END IF
               DISPLAY l_gem02 TO FORMONLY.gem02
             END IF
         END IF
         LET g_rma_o.rma14 = g_rma.rma14
 
         AFTER FIELD rma09
         #IF g_rma.rma09 != g_rma_o.rma09 or g_rma_o.rma09 is null THEN
         #  CALL t110_rma09()    #NO.TQC-650046
         #END IF
          LET g_rma_o.rma09 = g_rma.rma09
 
     BEFORE FIELD rma16
          CALL t110_set_entry(p_cmd)
 
     AFTER FIELD rma16
          IF NOT cl_null(g_rma.rma16) THEN
              SELECT azi01 INTO l_azi01 FROM azi_file WHERE azi01=g_rma.rma16
              IF STATUS THEN
#                 CALL cl_err('select azi',STATUS,0) # FUN-660111 
              CALL cl_err3("sel","azi_file",g_rma.rma16,"",STATUS,"","select azi",1) #FUN-660111
              NEXT FIELD rma16
              END IF
              IF g_rma.rma17=0 OR cl_null(g_rma.rma17) THEN
                 CALL s_curr3(g_rma.rma16,g_rma.rma02,g_rmz.rmz15) RETURNING g_rma.rma17
                 DISPLAY BY NAME g_rma.rma17
              END IF
           END IF
           DISPLAY BY NAME g_rma.rma16
           LET g_rma_o.rma16 = g_rma.rma16
           CALL t110_set_no_entry(p_cmd)
 
 
     BEFORE FIELD rma17
          IF g_rma.rma16 = g_aza.aza17 THEN
             LET g_rma.rma17='1'
             LET g_rma_o.rma17 = g_rma.rma17
             DISPLAY BY NAME g_rma.rma17
          END IF
          LET g_rma_o.rma17 = g_rma.rma17
          DISPLAY BY NAME g_rma.rma17
 
     AFTER FIELD rma17
 
        #FUN-4C0083
        IF g_rma.rma17 IS NOT NULL THEN
           IF g_rma.rma16=g_aza.aza17 THEN
              LET g_rma.rma17 =1
              DISPLAY BY NAME g_rma.rma17
           END IF
        END IF
        #--END
 
          LET g_rma_o.rma17 = g_rma.rma17
 
     #FUN-840068     ---start---
     AFTER FIELD rmaud01
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud02
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud03
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud04
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud05
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud06
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud07
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud08
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud09
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud10
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud11
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud12
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud13
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud14
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     AFTER FIELD rmaud15
        IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
     #FUN-840068     ----end----
 
        ON ACTION CONTROLP
          CASE
             {WHEN INFIELD(rma01)    #查詢單別
#                CALL q_oay(0,0,g_rma.rma01,'',g_sys) RETURNING g_rma.rma01
                 #CALL q_oay(FALSE,FALSE,g_rma.rma01,'',g_sys) RETURNING g_rma.rma01  #TQC-670008
                 CALL q_oay(FALSE,FALSE,g_rma.rma01,'','ARM') RETURNING g_rma.rma01   #TQC-670008
#                 CALL FGL_DIALOG_SETBUFFER( g_rma.rma01 )
                 DISPLAY BY NAME g_rma.rma01
                 NEXT FIELD rma01 }
 
               WHEN INFIELD(rma03)
#                CALL q_occ(0,0,g_rma.rma03) RETURNING g_rma.rma03
#                CALL FGL_DIALOG_SETBUFFER( g_rma.rma03 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.default1 = g_rma.rma03
                 CALL cl_create_qry() RETURNING g_rma.rma03
#                 CALL FGL_DIALOG_SETBUFFER( g_rma.rma03 )
                 DISPLAY BY NAME g_rma.rma03
#No.FUN-930007 --Begin
               WHEN INFIELD(rma11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ged"
                 LET g_qryparam.default1 = g_rma.rma11
                 CALL cl_create_qry() RETURNING g_rma.rma11
                 DISPLAY BY NAME g_rma.rma11
                 NEXT FIELD rma11
#No.FUN-930007 --End
               WHEN INFIELD(rma13)
#                CALL q_gen(0,0,g_rma.rma13) RETURNING g_rma.rma13
#                CALL FGL_DIALOG_SETBUFFER( g_rma.rma13 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_rma.rma13
                 CALL cl_create_qry() RETURNING g_rma.rma13
#                 CALL FGL_DIALOG_SETBUFFER( g_rma.rma13 )
                 DISPLAY BY NAME g_rma.rma13
 
               WHEN INFIELD(rma14)
#                CALL q_gem(0,0,g_rma.rma14) RETURNING g_rma.rma14
#                CALL FGL_DIALOG_SETBUFFER( g_rma.rma14 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_rma.rma14
                 CALL cl_create_qry() RETURNING g_rma.rma14
#                 CALL FGL_DIALOG_SETBUFFER( g_rma.rma14 )
                 DISPLAY BY NAME g_rma.rma14
               { BugNo:6485
               WHEN INFIELD(rma15)
#                CALL q_oga(05,11,g_rma.rma15) RETURNING g_rma.rma15
#                CALL FGL_DIALOG_SETBUFFER( g_rma.rma15 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oga"
                 LET g_qryparam.default1 = g_rma.rma15
                 CALL cl_create_qry() RETURNING g_rma.rma15
#                 CALL FGL_DIALOG_SETBUFFER( g_rma.rma15 )
                 DISPLAY BY NAME g_rma.rma15
                 NEXT FIELD rma15
               }
 
               WHEN INFIELD(rma16)
#                CALL q_azi(5,10,g_rma.rma16) RETURNING g_rma.rma16
#                CALL FGL_DIALOG_SETBUFFER( g_rma.rma16 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_rma.rma16
                 CALL cl_create_qry() RETURNING g_rma.rma16
#                 CALL FGL_DIALOG_SETBUFFER( g_rma.rma16 )
                 DISPLAY BY NAME g_rma.rma16
                 NEXT FIELD rma16
                #FUN-4B0058
                WHEN INFIELD(rma17)
                   CALL s_rate(g_rma.rma16,g_rma.rma17) RETURNING g_rma.rma17
                   DISPLAY BY NAME g_rma.rma17
                   NEXT FIELD rma17
                #FUN-4B0058(end)
 
             OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       #MOD-650015 --start 
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(rma01) THEN
       #         LET g_rma.* = g_rma_t.*
       #         CALL t110_show()
       #         NEXT FIELD rma01
       #     END IF
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
 
#NO.FUN-570265
FUNCTION t110_g_b()
DEFINE g_n      LIKE type_file.num5    #No.FUN-690010 smallint
DEFINE l_ohc08  LIKE ohc_file.ohc08,
       l_ohc081 LIKE ohc_file.ohc081,
       l_ohc17  LIKE ohc_file.ohc17,
       l_ohc18  LIKE ohc_file.ohc18,
       l_rmb14  LIKE rmb_file.rmb14,
       l_ima021 LIKE ima_file.ima021,
       l_ohc04  LIKE ohc_file.ohc04,
       l_ohc041 LIKE ohc_file.ohc041,
       l_ogb05  LIKE ogb_file.ogb05
 
       LET g_sql =" SELECT ohc04,ohc041,ohc08,ohc081,ohc17,ohc18,ima021 ",
                 #"   FROM ohc_file,rma_file LEFT JOIN ima_file ON ohc08 = ima_file.ima01",  #TQC-9C0202
                  "   FROM rma_file,ohc_file LEFT JOIN ima_file ON ohc08 = ima01",  #TQC-9C0202
                  "  WHERE rma01 = '",g_rma.rma01,"'",
                  "    AND ohc01 = '",g_rma22,"'",
                  "    AND ohcconf='Y'"
 
    PREPARE t110_ohc_p FROM g_sql
    IF SQLCA.SQLCODE != 0 THEN
       CALL cl_err('pre1:',SQLCA.sqlcode,0)
       LET g_success="N"
       RETURN
    END IF
    DECLARE ohc_curs                       #SCROLL CURSOR
        CURSOR FOR t110_ohc_p
    LET g_cnt = 1
    LET g_rec_b = 0
    LET l_ohc08 = NULL
    LET l_ohc081 = NULL
    LET l_ohc17 = NULL
    LET l_ohc18 = NULL
    LET l_ima021 = NULL
 
    FOREACH ohc_curs INTO l_ohc04,l_ohc041,l_ohc08,
                          l_ohc081,l_ohc17,l_ohc18,l_ima021
        IF STATUS THEN
            CALL cl_err('foreach: rmb_file',STATUS,1)
            EXIT FOREACH
        END IF
    LET l_rmb14 = 0         #No.MOD-790027 add
    IF cl_null(l_ohc18) THEN LET l_ohc18 = 0 END IF
    IF cl_null(l_ohc17) THEN LET l_ohc17 = 0 END IF
    IF (l_ohc18 > 0 and l_ohc17 > 0) THEN
        LET l_rmb14 = l_ohc18 * l_ohc17
    END IF
    #--找出原出貨單的單位
    SELECT ogb05 INTO l_ogb05
      FROM ogb_file
     WHERE ogb01 = l_ohc04
       AND ogb03 = l_ohc041
    LET l_ohc18 = s_digqty(l_ohc18,l_ogb05)   #FUN-BB0084 
                        #項次/料號/品名/單位/規格/單價/登記數量/金額)
    INSERT INTO rmb_file(rmb01,rmb02,rmb03,rmb04,rmb05,rmb06,rmb11,rmb111,
                         rmb12,rmb121,rmb13,rmb14,
                         rmbplant,rmblegal)  #FUN-980007
           VALUES (g_rma.rma01,g_cnt,l_ohc08,l_ogb05,l_ohc081,l_ima021,l_ohc18,
                   0,0,0,l_ohc17,l_rmb14,
                   g_plant,g_legal)          #FUN-980007
           IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
 #             CALL cl_err('ins rmb',STATUS,1) # FUN-660111
              CALL cl_err3("ins","rmb_file",g_rma.rma01,g_cnt,STATUS,"","ins rmb",1) #FUN-660111
              ROLLBACK WORK
              LET g_success="N"
              EXIT FOREACH
           END IF
           LET g_rec_b = g_rec_b + 1
           LET g_cnt = g_cnt + 1
    END FOREACH
    IF g_rec_b =0 THEN
       CALL cl_err('body: ','aap-129',0)
       LET g_success="N"
       ROLLBACK WORK
       RETURN
    ELSE
       IF g_success="N" THEN
          ROLLBACK WORK
          RETURN
       ELSE
          COMMIT WORK
       END IF
    END IF
    CALL t110_b_fill(" 1=1")
END FUNCTION
#---end
 
FUNCTION t110_b()                          #單身
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
    l_ima01         LIKE ima_file.ima01,   #料件編號
    l_ima25         LIKE ima_file.ima25,   #料件編號: 單位
    l_gfe01         LIKE gfe_file.gfe01,   #料件編號: 單位
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690010 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rma.* FROM rma_file WHERE rma01=g_rma.rma01
    IF g_rma.rma01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
    IF g_rma.rmavoid ='N'  THEN    #檢查資料是否為無效
        CALL cl_err(g_rma.rma01,'mfg1000',0)  RETURN
    END IF
    IF g_rma.rmaconf = 'Y' THEN CALL cl_err('',9003,0) RETURN END IF
    IF g_rma.rma09 = '6'   THEN CALL cl_err('','arm-018',0) RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
       "SELECT rmb02,rmb03,rmb05,rmb06,rmb04,rmb11,rmb12,rmb13,rmb14,",
       "       rmb15,rmb16,rmb17,",
       #No.FUN-840068 --start--
       "       rmbud01,rmbud02,rmbud03,rmbud04,rmbud05,",
       "       rmbud06,rmbud07,rmbud08,rmbud09,rmbud10,",
       "       rmbud11,rmbud12,rmbud13,rmbud14,rmbud15 ", 
       #No.FUN-840068 ---end---
       "  FROM rmb_file",
       "   WHERE rmb01= ? ",
       "   AND rmb02= ? ",
       "FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_rmb
              WITHOUT DEFAULTS
              FROM s_rmb.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t110_cl USING g_rma.rma01
            IF STATUS THEN
               CALL cl_err("OPEN t110_cl:", STATUS, 1)
               CLOSE t110_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t110_cl INTO g_rma.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE t110_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_rmb_t.* = g_rmb[l_ac].*  #BACKUP
               LET g_rmb_o.* = g_rmb[l_ac].*  #BACKUP
 
                OPEN t110_bcl USING g_rma.rma01,g_rmb_t.rmb02
                IF STATUS THEN
                    CALL cl_err("OPEN t110_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t110_bcl INTO g_rmb[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rmb_t.rmb02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #NEXT FIELD rmb02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO rmb_file(rmb01,rmb02,rmb03,rmb05,
                                 rmb06,rmb04,rmb11,rmb12,rmb13,
                                 rmb14,rmb15,rmb16,rmb17,
                                 rmb111,rmb121,
                                 #FUN-840068 --start--
                                 rmbud01,rmbud02,rmbud03,
                                 rmbud04,rmbud05,rmbud06,
                                 rmbud07,rmbud08,rmbud09,
                                 rmbud10,rmbud11,rmbud12,
                                 rmbud13,rmbud14,rmbud15,
                                 rmbplant,rmblegal) #FUN-980007
                                 #FUN-840068 --end--
            VALUES(g_rma.rma01,g_rmb[l_ac].rmb02,g_rmb[l_ac].rmb03,
                   g_rmb[l_ac].rmb05,g_rmb[l_ac].rmb06,
                   g_rmb[l_ac].rmb04,g_rmb[l_ac].rmb11,
                   g_rmb[l_ac].rmb12,g_rmb[l_ac].rmb13,
                   g_rmb[l_ac].rmb14,g_rmb[l_ac].rmb15,
                   g_rmb[l_ac].rmb16,g_rmb[l_ac].rmb17,0,0,
                   #FUN-840068 --start--
                   g_rmb[l_ac].rmbud01,g_rmb[l_ac].rmbud02,
                   g_rmb[l_ac].rmbud03,g_rmb[l_ac].rmbud04,
                   g_rmb[l_ac].rmbud05,g_rmb[l_ac].rmbud06,
                   g_rmb[l_ac].rmbud07,g_rmb[l_ac].rmbud08,
                   g_rmb[l_ac].rmbud09,g_rmb[l_ac].rmbud10,
                   g_rmb[l_ac].rmbud11,g_rmb[l_ac].rmbud12,
                   g_rmb[l_ac].rmbud13,g_rmb[l_ac].rmbud14,
                   g_rmb[l_ac].rmbud15,
                   g_plant,g_legal)                  #FUN-980007
                   #FUN-840068 --end--
            IF SQLCA.sqlcode THEN
 #               CALL cl_err(g_rmb[l_ac].rmb02,SQLCA.sqlcode,0) # FUN-660111 
                CALL cl_err3("ins","rmb_file",g_rma.rma01,g_rmb[l_ac].rmb02,SQLCA.sqlcode,"","",1) #FUN-660111
               #CKP
                ROLLBACK WORK
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
                INITIALIZE g_rmb[l_ac].* TO NULL      #900423
                LET g_rmb[l_ac].rmb11 =  0            #Body default
                LET g_rmb[l_ac].rmb12 =  0            #Body default
                LET g_rmb[l_ac].rmb13 =  0            #Body default
                LET g_rmb[l_ac].rmb14 =  0            #Body default
            LET g_rmb_t.* = g_rmb[l_ac].*         #新輸入資料
            LET g_rmb_o.* = g_rmb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD rmb02
 
        BEFORE FIELD rmb02                        #default 序號
            IF g_rmb[l_ac].rmb02 IS NULL OR
               g_rmb[l_ac].rmb02 = 0 THEN
                SELECT max(rmb02)+1 INTO g_rmb[l_ac].rmb02
                       FROM rmb_file WHERE rmb01 = g_rma.rma01
                IF g_rmb[l_ac].rmb02 IS NULL THEN
                    LET g_rmb[l_ac].rmb02 = 1
                END IF
           END IF
           IF p_cmd="u" THEN
           IF g_rmb[l_ac].rmb11 =0  THEN
              CALL cl_err('',9060,0)
           ELSE
              IF g_rmb[l_ac].rmb12 =0  THEN
                 CALL cl_err('',9060,0)
              ELSE
                 IF g_rmb[l_ac].rmb11 <> g_rmb[l_ac].rmb12 THEN
                    CALL cl_err('',9060,0)
                 ELSE
                    MESSAGE ""
                 END IF
              END IF
           END IF
          END IF
 
        AFTER FIELD rmb02                        #check 序號是否重複
            IF g_rmb[l_ac].rmb02 IS NULL THEN
                LET g_rmb[l_ac].rmb02 = g_rmb_t.rmb02
            END IF
            IF NOT cl_null(g_rmb[l_ac].rmb02) THEN
                IF g_rmb[l_ac].rmb02 != g_rmb_t.rmb02 OR
                   g_rmb_t.rmb02 IS NULL THEN
                    SELECT count(*)
                        INTO l_n
                        FROM rmb_file
                        WHERE rmb01 = g_rma.rma01 AND
                              rmb02 = g_rmb[l_ac].rmb02
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,1)
                        LET g_rmb[l_ac].rmb02 = g_rmb_t.rmb02
                        NEXT FIELD rmb02
                    END IF
                END IF
           END IF
           IF p_cmd="u" AND g_rmb[l_ac].rmb03 IS NOT NULL  THEN
           IF g_rmb[l_ac].rmb11 =0  THEN
           ELSE
              IF g_rmb[l_ac].rmb12 =0  THEN
              ELSE
                 IF g_rmb[l_ac].rmb11 <> g_rmb[l_ac].rmb12 THEN
                 ELSE
                    MESSAGE ""
                 END IF
              END IF
           END IF
         END IF
 
 
        AFTER FIELD rmb03                  #料件編號
            IF NOT cl_null(g_rmb[l_ac].rmb03) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_rmb[l_ac].rmb03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_rmb[l_ac].rmb03= g_rmb_t.rmb03
                  NEXT FIELD rmb03
               END IF
#FUN-AA0059 ---------------------end-------------------------------
                IF g_rmb_t.rmb03 IS NULL OR
                 (g_rmb[l_ac].rmb03 != g_rmb_t.rmb03 ) THEN
                  CALL t110_chk_rmb03()   #檢查此料號是否重覆(同一單號中)
                  IF NOT cl_null(g_errno) THEN
                     LET g_rmb[l_ac].rmb03 = g_rmb_t.rmb03
                     NEXT FIELD rmb03 END IF
                  CALL t110_rmb03('a')    #抓料件主檔的資料
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_rmb[l_ac].rmb03,g_errno,0)
                     LET g_rmb[l_ac].rmb03 = g_rmb_t.rmb03
                     LET g_rmb[l_ac].rmb05 = g_rmb_t.rmb05
                     LET g_rmb[l_ac].rmb06 = g_rmb_t.rmb06
                     #------MOD-5A0095 START----------
                     DISPLAY BY NAME g_rmb[l_ac].rmb03
                     DISPLAY BY NAME g_rmb[l_ac].rmb05
                     DISPLAY BY NAME g_rmb[l_ac].rmb06
                     #------MOD-5A0095 END------------
                     NEXT FIELD rmb03
                  END IF
                END IF
            END IF
 
        AFTER FIELD rmb04                  #料件單位
            IF g_rmb[l_ac].rmb04 IS NULL OR g_rmb[l_ac].rmb04 = ' ' THEN
               CALL t110_rmb03(p_cmd)
            END IF
            IF NOT cl_null(g_rmb[l_ac].rmb04) THEN
                SELECT gfe01 INTO l_gfe01 FROM gfe_file  #須存在單位主檔
                WHERE  gfe01=g_rmb[l_ac].rmb04
                IF SQLCA.sqlcode THEN
  #                 CALL cl_err('無此單位!',9024,0) # FUN-660111 
                   CALL cl_err3("sel","gfe_file",g_rmb[l_ac].rmb04,"",9024,"","無此單位",1) #FUN-660111                
                   NEXT FIELD rmb04
                END IF
            END IF
       #FUN-BB0084 -------------Begin-----------------
            IF NOT t110_rmb11_chk(p_cmd) THEN
               LET g_rmb_o.rmb04 = g_rmb[l_ac].rmb04
               NEXT FIELD rmb11
            END IF  
            LET g_rmb_o.rmb04 = g_rmb[l_ac].rmb04
       #FUN-BB0084 -------------End------------------- 
 
       AFTER FIELD rmb11
#FUN-BB0084 -----------------Begin----------------
            IF NOT t110_rmb11_chk(p_cmd) THEN
               NEXT FIELD rmb11
            END IF
#FUN-BB0084 -----------------End------------------
#FUN-BB0084 -----------------Begin----------------
#           IF NOT cl_null(g_rmb[l_ac].rmb11) THEN
#               IF g_rmb[l_ac].rmb11 <0 THEN
#                   NEXT FIELD rmb11
#               END IF
#               LET g_rmb[l_ac].rmb14 = g_rmb[l_ac].rmb11*g_rmb[l_ac].rmb13
#               DISPLAY g_rmb[l_ac].rmb14 TO rmb14
#               IF p_cmd="u" AND g_rmb[l_ac].rmb04 IS NOT NULL THEN
#                   IF g_rmb[l_ac].rmb11 <> g_rmb[l_ac].rmb12 THEN
#                           CALL cl_err('',9060,0)
#                   ELSE
#                      IF g_rmb[l_ac].rmb11=0  THEN
#                           CALL cl_err('',9060,0)
#                      ELSE
#                         MESSAGE ""
#                      END IF
#                   END IF
#               END IF
#           END IF
#FUN-BB0084 -----------------End-----------------
 
       AFTER FIELD rmb13
            IF NOT cl_null(g_rmb[l_ac].rmb13) THEN
                IF g_rmb[l_ac].rmb13 <0 THEN
                    LET g_rmb[l_ac].rmb13 = g_rmb_t.rmb13
                    NEXT FIELD rmb13
                END IF
                LET g_rmb[l_ac].rmb14 = g_rmb[l_ac].rmb11*g_rmb[l_ac].rmb13
                DISPLAY g_rmb[l_ac].rmb14 TO rmb14
            END IF
 
       AFTER FIELD rmb14
            IF NOT cl_null(g_rmb[l_ac].rmb14) THEN
                IF g_rmb[l_ac].rmb14 < 0 THEN
                   LET g_rmb[l_ac].rmb14 = g_rmb_t.rmb14
                   DISPLAY g_rmb[l_ac].rmb14 TO rmb14
                END IF
            END IF
 
       #No.FUN-840068 --start--
       AFTER FIELD rmbud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmbud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmbud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmbud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmbud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmbud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmbud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmbud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmbud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmbud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmbud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmbud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmbud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmbud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmbud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       #No.FUN-840068 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_rmb_t.rmb02 > 0 AND
               g_rmb_t.rmb02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM rmb_file
                    WHERE rmb01 = g_rma.rma01 AND
                          rmb02 = g_rmb_t.rmb02
                IF SQLCA.sqlcode THEN
  #                  CALL cl_err(g_rmb_t.rmb02,SQLCA.sqlcode,0)   # FUN-660111 
                    CALL cl_err3("del","rmb_file",g_rma.rma01,g_rmb_t.rmb02,SQLCA.sqlcode,"","",1) #FUN-660111
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rmb[l_ac].* = g_rmb_t.*
               CLOSE t110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_rmb[l_ac].rmb02,-263,1)
                LET g_rmb[l_ac].* = g_rmb_t.*
            ELSE
                UPDATE rmb_file SET
                       rmb02=g_rmb[l_ac].rmb02,
                       rmb03=g_rmb[l_ac].rmb03,
                       rmb06=g_rmb[l_ac].rmb06,
                       rmb05=g_rmb[l_ac].rmb05,
                       rmb04=g_rmb[l_ac].rmb04,
                       rmb11=g_rmb[l_ac].rmb11,
                       rmb12=g_rmb[l_ac].rmb12,
                       rmb13=g_rmb[l_ac].rmb13,
                       rmb14=g_rmb[l_ac].rmb14,
                       rmb15=g_rmb[l_ac].rmb15,
                       rmb16=g_rmb[l_ac].rmb16,
                       rmb17=g_rmb[l_ac].rmb17,
                       #FUN-840068 --start--
                       rmbud01 = g_rmb[l_ac].rmbud01,
                       rmbud02 = g_rmb[l_ac].rmbud02,
                       rmbud03 = g_rmb[l_ac].rmbud03,
                       rmbud04 = g_rmb[l_ac].rmbud04,
                       rmbud05 = g_rmb[l_ac].rmbud05,
                       rmbud06 = g_rmb[l_ac].rmbud06,
                       rmbud07 = g_rmb[l_ac].rmbud07,
                       rmbud08 = g_rmb[l_ac].rmbud08,
                       rmbud09 = g_rmb[l_ac].rmbud09,
                       rmbud10 = g_rmb[l_ac].rmbud10,
                       rmbud11 = g_rmb[l_ac].rmbud11,
                       rmbud12 = g_rmb[l_ac].rmbud12,
                       rmbud13 = g_rmb[l_ac].rmbud13,
                       rmbud14 = g_rmb[l_ac].rmbud14,
                       rmbud15 = g_rmb[l_ac].rmbud15
                       #FUN-840068 --end-- 
                 WHERE rmb01=g_rma.rma01 AND
                       rmb02=g_rmb_t.rmb02
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
  #                  CALL cl_err(g_rmb[l_ac].rmb02,SQLCA.sqlcode,0)   # FUN-660111 
                    CALL cl_err3("upd","rmb_file",g_rma.rma01,g_rmb_t.rmb02,SQLCA.sqlcode,"","",1) #FUN-660111
                    LET g_rmb[l_ac].* = g_rmb_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac    #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_rmb[l_ac].* = g_rmb_t.*
            #FUN-D40030--add--str--
               ELSE
                  CALL g_rmb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D40030--add--end--
               END IF
               CLOSE t110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac    #FUN-D40030 add
           #CKP
           #LET g_rmb_t.* = g_rmb[l_ac].*          # 900423
            CLOSE t110_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL t110_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(rmb02) AND l_ac > 1 THEN
                LET g_rmb[l_ac].* = g_rmb[l_ac-1].*
                LET g_rmb[l_ac].rmb02 = NULL
                NEXT FIELD rmb02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rmb03) #料件編號
#                   CALL q_ima(10,3,g_rmb[l_ac].rmb03) RETURNING g_rmb[l_ac].rmb03
#                   CALL FGL_DIALOG_SETBUFFER( g_rmb[l_ac].rmb03 )
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#                    LET g_qryparam.default1 = g_rmb[l_ac].rmb03
#                    CALL cl_create_qry() RETURNING g_rmb[l_ac].rmb03
                     CALL q_sel_ima(FALSE, "q_ima","",g_rmb[l_ac].rmb03,"","","","","",'' ) 
                       RETURNING g_rmb[l_ac].rmb03

#FUN-AA0059---------mod------------end-----------------
                    CALL FGL_DIALOG_SETBUFFER( g_rmb[l_ac].rmb03 )
                     DISPLAY BY NAME g_rmb[l_ac].rmb03          #No.MOD-490371
                    CALL  t110_rmb03('a')
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_rmb[l_ac].rmb03 = g_rmb_t.rmb03
                    END IF
                    NEXT FIELD rmb03
 
               WHEN INFIELD(rmb04) #料件的單位
#                 CALL q_gfe(0,0,g_rmb[l_ac].rmb04) RETURNING g_rmb[l_ac].rmb04
#                 CALL FGL_DIALOG_SETBUFFER( g_rmb[l_ac].rmb04 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_rmb[l_ac].rmb04
                  CALL cl_create_qry() RETURNING g_rmb[l_ac].rmb04
#                  CALL FGL_DIALOG_SETBUFFER( g_rmb[l_ac].rmb04 )
                     DISPLAY BY NAME g_rmb[l_ac].rmb04          #No.MOD-490371
                  NEXT FIELD rmb04
               OTHERWISE EXIT CASE
            END CASE
 
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END    
 
        END INPUT
 
 
    CLOSE t110_bcl
    COMMIT WORK
   #CALL t110_delall()
END FUNCTION
 
{FUNCTION t110_delall()
    SELECT COUNT(*) INTO g_cnt FROM rmb_file
        WHERE rmb01 = g_rma.rma01
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM rma_file WHERE rma01 = g_rma.rma01
    END IF
END FUNCTION  }
 
#NO: TQC-650046
#FUNCTION t110_rma09()  #處理方式
#    DEFINE l_rma09    VARCHAR(21)
#
#     LET l_rma09 = '                     '
#     CASE
#         WHEN g_rma.rma09='1'
#              LET l_rma09=g_x[11]
#         WHEN g_rma.rma09='2'
#              LET l_rma09=g_x[12]
#         WHEN g_rma.rma09='3'
#              LET l_rma09=g_x[13]
#         WHEN g_rma.rma09='4'
#             LET l_rma09 =g_x[14]
#         WHEN g_rma.rma09='5'
#             LET l_rma09 =g_x[15]
#         WHEN g_rma.rma09='6'
#             LET l_rma09 =g_x[16]
#       OTHERWISE EXIT CASE
#     END CASE
#     DISPLAY l_rma09 TO FORMONLY.rma09_desc
#END FUNCTION
 
FUNCTION t110_chk_rmb03()  #chk rmb01+料件編號: 不允許重覆
    DEFINE l_n             LIKE type_file.num5                #檢查重複用  #No.FUN-690010 SMALLINT
 
    LET g_errno = ' '
    SELECT COUNT(*) INTO l_n FROM rmb_file WHERE rmb01=g_rma.rma01
                                    AND rmb03=g_rmb[l_ac].rmb03
    IF l_n >= 1 THEN LET g_errno ='arm-022'
       CALL cl_err('','arm-022',0)
    END IF
 
END FUNCTION
 
#FUN-BB0084 ---------------Begin---------------
FUNCTION t110_rmb11_chk(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1
   IF NOT cl_null(g_rmb[l_ac].rmb11) THEN
       IF g_rmb[l_ac].rmb11 <0 THEN
          RETURN FALSE 
       END IF
       IF NOT cl_null(g_rmb[l_ac].rmb04) THEN
          IF cl_null(g_rmb_o.rmb04) OR cl_null(g_rmb_t.rmb11) OR
             g_rmb_o.rmb04 ! = g_rmb[l_ac].rmb04 OR 
             g_rmb_t.rmb11 ! = g_rmb[l_ac].rmb11 THEN
             LET g_rmb[l_ac].rmb11 = s_digqty(g_rmb[l_ac].rmb11,g_rmb[l_ac].rmb04)
             DISPLAY BY NAME g_rmb[l_ac].rmb11
          END IF
       END IF
       LET g_rmb[l_ac].rmb14 = g_rmb[l_ac].rmb11*g_rmb[l_ac].rmb13
       DISPLAY g_rmb[l_ac].rmb14 TO rmb14
       IF p_cmd="u" AND g_rmb[l_ac].rmb04 IS NOT NULL THEN
           IF g_rmb[l_ac].rmb11 <> g_rmb[l_ac].rmb12 THEN
                   CALL cl_err('',9060,0)
           ELSE
              IF g_rmb[l_ac].rmb11=0  THEN
                   CALL cl_err('',9060,0)
              ELSE
                 MESSAGE ""
              END IF
           END IF
       END IF
   END IF
   RETURN TRUE 
END FUNCTION
#FUN-BB0084 ---------------End---------------
FUNCTION t110_rmb03(p_cmd)  #料件編號
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima021   LIKE ima_file.ima021,
           l_ima25    LIKE ima_file.ima25,
           l_imaacti  LIKE ima_file.imaacti,
           p_cmd      LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima25,imaacti
      INTO l_ima02,l_ima021,l_ima25,l_imaacti
      FROM ima_file WHERE ima01 = g_rmb[l_ac].rmb03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'arm-006'
                            LET l_ima02 = NULL
                            LET l_ima021= NULL
                            LET l_ima25 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------         
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'a'
    THEN
        LET g_rmb[l_ac].rmb04 = l_ima25
        LET g_rmb[l_ac].rmb05 = l_ima02
        LET g_rmb[l_ac].rmb06 = l_ima021
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        IF g_rmb[l_ac].rmb03 != g_rmb_t.rmb03 THEN
           LET g_rmb[l_ac].rmb04 = l_ima25
        END IF
        LET g_rmb[l_ac].rmb05 = l_ima02
        LET g_rmb[l_ac].rmb06 = l_ima021
    END IF
#FUN-BB0084 ------------Begin------------
    LET g_rmb[l_ac].rmb11 = s_digqty(g_rmb[l_ac].rmb11,g_rmb[l_ac].rmb04)
    DISPLAY BY NAME g_rmb[l_ac].rmb11
    DISPLAY BY NAME g_rmb[l_ac].rmb04  
#FUN-BB0084 ------------End--------------
END FUNCTION
 
FUNCTION t110_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON rmb02,rmb03,rmb05,rmb06,rmb04,rmb11,rmb12,
                       rmb13,rmb14,rmb15,rmb16,rmb17   # 螢幕上取單身條件
                       #No.FUN-840068 --start--
                       ,rmbud01,rmbud02,rmbud03,rmbud04,rmbud05
                       ,rmbud06,rmbud07,rmbud08,rmbud09,rmbud10
                       ,rmbud11,rmbud12,rmbud13,rmbud14,rmbud15
                       #No.FUN-840068 ---end---
            FROM s_rmb[1].rmb02,s_rmb[1].rmb03,s_rmb[1].rmb05,
                 s_rmb[1].rmb06,s_rmb[1].rmb04,s_rmb[1].rmb11,
                 s_rmb[1].rmb12,s_rmb[1].rmb13,s_rmb[1].rmb14,
                 s_rmb[1].rmb15,s_rmb[1].rmb16,s_rmb[1].rmb17
                 #No.FUN-840068 --start--
                 ,s_rmb[1].rmbud01,s_rmb[1].rmbud02,s_rmb[1].rmbud03
                 ,s_rmb[1].rmbud04,s_rmb[1].rmbud05,s_rmb[1].rmbud06
                 ,s_rmb[1].rmbud07,s_rmb[1].rmbud08,s_rmb[1].rmbud09
                 ,s_rmb[1].rmbud10,s_rmb[1].rmbud11,s_rmb[1].rmbud12
                 ,s_rmb[1].rmbud13,s_rmb[1].rmbud14,s_rmb[1].rmbud15
                 #No.FUN-840068 ---end---
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL t110_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t110_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    LET g_sql =
        "SELECT rmb02,rmb03,rmb05,rmb06,rmb04,rmb11,rmb12,rmb13,rmb14, ",
        "       rmb15,rmb16,rmb17, ",
        #No.FUN-840068 --start--
        "       rmbud01,rmbud02,rmbud03,rmbud04,rmbud05,",
        "       rmbud06,rmbud07,rmbud08,rmbud09,rmbud10,",
        "       rmbud11,rmbud12,rmbud13,rmbud14,rmbud15 ", 
        #No.FUN-840068 ---end---
        " FROM rmb_file,rma_file",
        " WHERE rmb01 ='",g_rma.rma01,"'",           #單頭
        " AND ",p_wc2 CLIPPED,                       #單身
        " AND rmb01 = rma01 ",
        " ORDER BY 1"
 
    PREPARE t110_pb FROM g_sql
    DECLARE rmb_cs                       #SCROLL CURSOR
        CURSOR FOR t110_pb
 
    CALL g_rmb.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH rmb_cs INTO g_rmb[g_cnt].*   #單身 ARRAY 填充
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
    #CKP
    CALL g_rmb.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rmb TO s_rmb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t110_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t110_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t110_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t110_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t110_fetch('L')
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
         #CKP
         CALL cl_set_field_pic(g_rma.rmaconf,"","","","","")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
   ON ACTION output                   #MOD-4A0197
      LET g_action_choice="output"    #MOD-4A0197
      EXIT DISPLAY                    #MOD-4A0197
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DISPLAY
 
   ON ACTION about         #MOD-4C0121
      CALL cl_about()      #MOD-4C0121
 
   ON ACTION exporttoexcel       #FUN-4B0035
      LET g_action_choice = 'exporttoexcel'
      EXIT DISPLAY
 
   ON ACTION related_document                #No.FUN-6A0018  相關文件
      LET g_action_choice="related_document"          
      EXIT DISPLAY     
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END   
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t110_y()                       # when g_rma.rmaconf='N' (Turn to 'Y')
   DEFINE g_i   LIKE type_file.num10,   #No.FUN-690010 integer,
          l_cnt LIKE type_file.num5    #No.FUN-690010 SMALLINT
   DEFINE l_rma16 LIKE rma_file.rma16,  #MOD-7A0186 
          l_rma17 LIKE rma_file.rma17   #MOD-7A0186
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
#CHI-C30107 ------------- add -------------- begin
   IF g_rma.rma01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rma.rma09   = '6' THEN CALL cl_err('rma09=6','arm-018',0) RETURN END IF
   IF g_rma.rmavoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rma.rmarecv = 'N' THEN CALL cl_err('recv=N','arm-029',0) RETURN END IF
   IF g_rma.rmaconf = 'Y' THEN CALL cl_err('conf=Y',9023,0) RETURN END IF
   CALL cl_upsw(18,10,'N') RETURNING g_i
   IF NOT g_i THEN
      DISPLAY BY NAME g_rma.rmaconf
      RETURN
   END IF
#CHI-C30107 ------------- add -------------- end
   SELECT * INTO g_rma.* FROM rma_file WHERE rma01 = g_rma.rma01
   IF g_rma.rma01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rma.rma09   = '6' THEN CALL cl_err('rma09=6','arm-018',0) RETURN END IF
   IF g_rma.rmavoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rma.rmarecv = 'N' THEN CALL cl_err('recv=N','arm-029',0) RETURN END IF
   IF g_rma.rmaconf = 'Y' THEN CALL cl_err('conf=Y',9023,0) RETURN END IF
 
   #MOD-7A0186-begin-add
   IF cl_null(g_rma.rma16) OR cl_null(g_rma.rma17) THEN
      CALL cl_getmsg('anm-040',g_lang) RETURNING g_msg
      CALL cl_err(g_msg,'anm-067',1) LET g_success = 'N' RETURN
      RETURN
   END IF 
   #MOD-7A0186-end-add
 
#---BUGNO:7379---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rmb_file
    WHERE rmb01=g_rma.rma01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
#---BUGNO:7379 END---------------
 
#CHI-C30107 --------------- mark ---------------- begin
#  CALL cl_upsw(18,10,'N') RETURNING g_i
#  IF NOT g_i THEN
#     DISPLAY BY NAME g_rma.rmaconf
#     RETURN
#  END IF
#CHI-C30107 -------------- mark ----------------- end
  #IF NOT cl_confirm('aap-222') THEN RETURN END IF
   BEGIN WORK
 
 
    OPEN t110_cl USING g_rma.rma01
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_rma.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t110_cl ROLLBACK WORK RETURN
    END IF
 
     LET g_success = 'Y'
      UPDATE rma_file SET rmaconf = 'Y',rmamodu=g_user,rmadate=g_today
           WHERE rma01 = g_rma.rma01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
  #       CALL cl_err('confirm',9050,1)  # FUN-660111
          CALL cl_err3("upd","rma_file",g_rma.rma01,"",9050,"","confirm",1) #FUN-660111
          LET g_success = 'N' RETURN
      END IF
    IF g_success='Y' THEN
        LET g_rma.rmaconf='Y'
        LET g_rma.rmamodu=g_user
        LET g_rma.rmadate=g_today
        COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    DISPLAY BY NAME g_rma.rmaconf,g_rma.rmamodu,g_rma.rmadate
    MESSAGE ''
    #CKP
    CALL cl_set_field_pic(g_rma.rmaconf,"","","","","")
END FUNCTION
 
FUNCTION t110_z()                       # when g_rma.rmaconf='Y' (Turn to 'N')
   DEFINE g_i     LIKE type_file.num10,   #No.FUN-690010 integer,
          g_rme01 like rme_file.rme01,
          g_cnt   LIKE type_file.num5     #No.FUN-690010 smallint
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   SELECT * INTO g_rma.* FROM rma_file WHERE rma01 = g_rma.rma01
   IF g_rma.rma01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rma.rma09   = '6' THEN CALL cl_err('rma09=6','arm-018',0) RETURN END IF
   IF g_rma.rmavoid = 'N' THEN CALL cl_err('void=N',9027,0) RETURN END IF
   IF g_rma.rmaconf = 'N' THEN CALL cl_err('conf=N',9025,0) RETURN END IF
   IF g_rma.rmarecv = 'Y' THEN CALL cl_err('recv=Y','arm-044',0) RETURN END IF   #MOD-640452 add
   SELECT rme01,count(*) INTO g_rme01,g_cnt FROM rme_file
      WHERE rme011=g_rma.rma01  #若此單號已有覆出資料,則不允許取消確認
        AND rmecong <> 'X'  #CHI-C80041
   IF g_cnt >=1 THEN
      CALL cl_err(g_rme01,'arm-020',0)  RETURN END IF
   CALL cl_upsw(18,10,'Y') RETURNING g_i
   IF NOT g_i THEN
      DISPLAY BY NAME g_rma.rmaconf
      RETURN
   END IF
  #IF NOT cl_confirm('arm-003') THEN RETURN END IF
   BEGIN WORK
 
 
    OPEN t110_cl USING g_rma.rma01
    IF STATUS THEN
       CALL cl_err("OPEN t110_cl:", STATUS, 1)
       CLOSE t110_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t110_cl INTO g_rma.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t110_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   UPDATE rma_file SET rmaconf = 'N',rmamodu=g_user,rmadate=g_today
           WHERE rma01 = g_rma.rma01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_err('',9050,1)   # FUN-660111
      CALL cl_err3("upd","rma_file",g_rma.rma01,"",9050,"","",1) #FUN-660111
      LET g_success = 'N' RETURN
   END IF
   IF g_success = 'Y' THEN
      LET g_rma.rmaconf='N'
      LET g_rma.rmamodu=g_user
      LET g_rma.rmadate=g_today
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_rma.rmaconf,g_rma.rmamodu,g_rma.rmadate
   MESSAGE ''
    #CKP
    CALL cl_set_field_pic(g_rma.rmaconf,"","","","","")
END FUNCTION
#genero
#單頭
FUNCTION t110_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       #CALL cl_set_comp_entry("rma01",TRUE) #MOD-5B0189 mark
       CALL cl_set_comp_entry("rma01,rma03",TRUE) #MOD-5B0189 add
   END IF
   IF INFIELD(rma16) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rma17",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t110_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           #CALL cl_set_comp_entry("rma01",FALSE) #MOD-5B0189 mark
           CALL cl_set_comp_entry("rma01,rma03",FALSE) #MOD-5B0189 add
       END IF
   END IF
   IF INFIELD(rma16) OR (NOT g_before_input_done) THEN
       IF g_rma.rma17 = '1' AND g_rma.rma16 = g_aza.aza17 THEN
           CALL cl_set_comp_entry("rma17",FALSE)
       END IF
   END IF
 
END FUNCTION
 
#Patch....NO.MOD-5A0095 <001> #
