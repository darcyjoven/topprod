# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: armt150.4gl
# Descriptions...: RMA點收維護作業
# Date & Author..: 98/03/15 By plum
#        Modify..: 03/08/14 By Nicola Bugno:7724 修改t150_out()的g_sql
#        Modify..: 03/08/20 By Wiky Bugno:7723 detail僅秀出未有出貨序號訊息,但捕登序號時應強制勾稽(養生)
# Modify.........: No.MOD-490371 04/09/22 By Kitty Controlp 未加display
# Modify.........: No.MOD-490413 04/09/23 By Wiky 單身數量輸入大於1時不會自動展開明細
#                :                                若產品序號空白,新增是可輸數量,修改時因為數量為1,所以不能修改
# Modify.........: No.MOD-490408 04/09/23 By Wiky controlo部份,單身有值時,會沒做用,新增新的row才有作用!
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0055 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510044 05/02/03 By Mandy 報表轉XML
# Modify.........: No.FUN-550064 05/05/28 By Trisy 單據編號加大
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: No.MOD-5B0136 05/11/23 By Rosayu RMA加開窗查詢
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0018 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7A0183 07/10/30 By ciare 維修次數只需警告不用控卡
# Modify.........: No.MOD-7A0186 07/10/30 By ciare 自動確認(rmz19)時,若幣別(rma16)匯率(rma17)是空白不可確認
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-840185 08/04/20 By jamie 收貨日期，改抓 armt110 的預計收貨日。
# Modify.........: No.MOD-840376 08/04/28 By lilingyu 當直接進入單身后，打入的產品序號不存在ogbb_file時,系統
#                                                      仍可接受,但若由右邊的"補登序號"按鈕登打不存在的產品序號時,
#                                                      程式則會stop,兩段的check邏輯不同
# Modify.........: NO.FUN-860018 08/06/23 BY TSD.jarlin 舊報表轉CR報表
# Modify.........: No.FUN-890102 08/09/23 By baofei  CR 追單到31區
# Modify.........: No.MOD-950061 09/05/08 By Smapmin 新增狀態時,輸入RMA序號後要能帶出料號/數量等預設值
#                                                    沒有打序號時,數量無法修改
# Modify.........: No.MOD-980066 09/08/11 By Smapmin 多insert rmc16/rmc09
# Modify.........: No.MOD-980067 09/08/11 By Smapmin 抓取rmc_file資料,或是回寫rmb_file資料時,條件不應納入品名
# Modify.........: No.MOD-980120 09/08/14 By lilingyu 審核時,如果遇到不成立的資料,應該回滾事務
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0198 10/01/04 By lilingyu 單身"數量"欄位未控管負數
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No:TQC-A20035 10/02/10 By sherry 修正INSERT rmc18時的問題
# Modify.........: No:TQC-A20036 10/02/10 By liingyu 若存在已經審核的客修單,則不允許修改和取消審核
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No:TQC-AC0013 10/12/14 By destiny 原出貨日期沒給值
# Modify.........: No:TQC-AB0025 10/12/17 By chenying Sybase調整
# Modify.........: No:FUN-BB0084 11/12/26 By lixh1 增加數量欄位小數取位
# Modify.........: No:MOD-C80068 12/08/09 By ck2yuan 單身輸入料號必須存在armt110單身中
# Modify.........: No:CHI-C60018 12/08/13 By ck2yuan 取消 after insert 時自動展開項次,新增action來展開項次
# Modify.........: No:FUN-D40030 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_no            LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #檢查重複用
    skipme          LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(01),
    g_rmb           RECORD LIKE rmb_file.*,       #RMA單號  (單頭)
    l_rmc           RECORD LIKE rmc_file.*,       #RMA單號  (單頭)
    g_rma           RECORD LIKE rma_file.*,       #RMA單號  (單頭)
    g_rma_t         RECORD LIKE rma_file.*,       #RMA單號  (舊值)
    g_rma_o         RECORD LIKE rma_file.*,       #RMA單號  (舊值)
    l_oga02         LIKE oga_file.oga02,   #oga:出貨日期
    g_rmb02         LIKE rmb_file.rmb02,   #CHI-C60018 add
    g_rma01_t       LIKE rma_file.rma01,   #簽核等級 (舊值)
    g_t1            LIKE oay_file.oayslip,                     #No.FUN-550064  #No.FUN-690010 VARCHAR(05)
    g_rmc16         LIKE rmc_file.rmc16,   #是否保固(Y/N)     #MOD-980066
    g_rmc09         LIKE rmc_file.rmc09,   #是否收費:Y/N      #MOD-980066
    g_rmc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        rmc07       LIKE rmc_file.rmc07,   #S/N
        rmc02       LIKE rmc_file.rmc02,   #項次
        rmc04       LIKE rmc_file.rmc04,   #料件編號
        rmc06       LIKE rmc_file.rmc06,   #品名
        rmc061      LIKE rmc_file.rmc061,  #規格
        rmc31       LIKE rmc_file.rmc31,   #數量
        ima131      LIKE ima_file.ima131,  #產品分類編號
        rmc05       LIKE rmc_file.rmc05,   #單位
        rmc25       LIKE rmc_file.rmc25,   #機型
        rmc32       LIKE rmc_file.rmc32    #說明
                    END RECORD,
    g_rmc_t         RECORD                 #程式變數 (舊值)
        rmc07       LIKE rmc_file.rmc07,   #S/N
        rmc02       LIKE rmc_file.rmc02,   #項次
        rmc04       LIKE rmc_file.rmc04,   #料件編號
        rmc06       LIKE rmc_file.rmc06,   #品名
        rmc061      LIKE rmc_file.rmc061,  #規格
        rmc31       LIKE rmc_file.rmc31,   #數量
        ima131      LIKE ima_file.ima131,  #產品分類編號
        rmc05       LIKE rmc_file.rmc05,   #單位
        rmc25       LIKE rmc_file.rmc25,   #機型
        rmc32       LIKE rmc_file.rmc32    #說明
                    END RECORD,
    g_rmc_o         RECORD                 #程式變數 (舊值)
        rmc07       LIKE rmc_file.rmc07,   #S/N
        rmc02       LIKE rmc_file.rmc02,   #項次
        rmc04       LIKE rmc_file.rmc04,   #料件編號
        rmc06       LIKE rmc_file.rmc06,   #品名
        rmc061      LIKE rmc_file.rmc061,  #規格
        rmc31       LIKE rmc_file.rmc31,   #數量
        ima131      LIKE ima_file.ima131,  #產品分類編號
        rmc05       LIKE rmc_file.rmc05,   #單位
        rmc25       LIKE rmc_file.rmc25,   #機型
        rmc32       LIKE rmc_file.rmc32    #說明
                    END RECORD,
    g_rmbc          RECORD                 #UPDATE rmb.rmc
        rmc01       LIKE rmc_file.rmc01,   #rmc:項次
        rmc04       LIKE rmc_file.rmc04,   #料件編號
        rmc06       LIKE rmc_file.rmc06,   #品名  #NO:7224
        rmc31       LIKE rmc_file.rmc31,   #數量
        rmb02       LIKE rmb_file.rmb02    #rmb:項次
                    END RECORD,
    g_argv1         LIKE rmc_file.rmc01,   # RMA 單號
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
 
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
DEFINE   l_table    STRING    #-----NO.FUN-860018 BY TSD.jarlin------#                                                              
DEFINE   g_str      STRING    #-----NO.FUN-860018 BY TSD.jarlin------# 
DEFINE   gs_rmc17       LIKE rmc_file.rmc17   #TQC-AC0013
MAIN
DEFINE
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
      LET g_sql = "rma01.rma_file.rma01,",                                                                                          
                  "rma03.rma_file.rma03,",                                                                                          
                  "rma04.rma_file.rma04,",                                                                                          
                  "rma20.rma_file.rma20,",                                                                                          
                  "rma21.rma_file.rma21,",                                                                                          
                  "rma18.rma_file.rma18,",                                                                                          
                  "rmc02.rmc_file.rmc02,",                                                                                          
                  "rmc04.rmc_file.rmc04,",                                                                                          
                  "rmc07.rmc_file.rmc07,",                                                                                          
                  "rmc25.rmc_file.rmc25,",                                                                                          
                  "rmc31.rmc_file.rmc31,",                                                                                          
                  "ima131.ima_file.ima131,",                                                                                        
                  "rmc05.rmc_file.rmc05,",                                                                                          
                  "rmc06.rmc_file.rmc06,",                                                                                          
                  "rmc061.rmc_file.rmc061,",                                                                                        
                  "rmc32.rmc_file.rmc32"       
      LET l_table = cl_prt_temptable('armt150',g_sql) CLIPPED                                                                       
      IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                      
      LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,                                                                       
                  " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"                                                                     
      PREPARE insert_prep FROM g_sql                                                                                                
      IF STATUS THEN                                                                                                                
         CALL cl_err('insert_prep:',status,1)                                                                                       
         EXIT PROGRAM                                                                                                               
      END IF                                                                                                                        
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
    LET p_row = 3 LET p_col = 3
    OPEN WINDOW t150_w AT p_row,p_col      #顯示畫面
         WITH FORM "arm/42f/armt150"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    LET g_forupd_sql = "SELECT rma01 FROM rma_file",
                       " WHERE rma01 = ?  FOR UPDATE " #g_rma_rowid
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t150_cl CURSOR FROM g_forupd_sql
    WHILE TRUE
      LET g_action_choice = ''
      CALL t150_menu()
      IF g_action_choice = 'exit' THEN EXIT WHILE END IF
    END WHILE
    CLOSE WINDOW t150_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION t150_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
  CLEAR FORM                                #清除畫面
   CALL g_rmc.clear()
  MESSAGE " "
  CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_rma.* TO NULL    #No.FUN-750051
  CONSTRUCT BY NAME g_wc ON                 #螢幕上取單頭條件
       rma01,rma03,rma04,rma20,rma21,rma12,rma18,rmaconf,rmarecv,rmavoid 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
     ON ACTION CONTROLP
         CASE
            WHEN INFIELD(rma01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rma4"
              LET g_qryparam.state = 'c'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO rma01
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
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmauser', 'rmagrup')
 
    CONSTRUCT g_wc2 ON rmc07,rmc02,rmc04,rmc06,rmc061,   #螢幕上取單身條件
                       rmc31,ima131,rmc05,rmc25,rmc32
            FROM s_rmc[1].rmc07,s_rmc[1].rmc02, s_rmc[1].rmc04,
                 s_rmc[1].rmc06,s_rmc[1].rmc061,s_rmc[1].rmc31,
                 s_rmc[1].ima131,s_rmc[1].rmc05,s_rmc[1].rmc25,
                 s_rmc[1].rmc32
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rmc04) #料件編號
#FUN-AA0059---------mod------------str-----------------               
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO rmc04
                  NEXT FIELD rmc04
               WHEN INFIELD(rmc05) #單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rmc05
                  NEXT FIELD rmc05
               WHEN INFIELD(rmc25) #
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bmi"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rmc25
                  NEXT FIELD rmc25
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
    IF g_wc2 = " 1=1" THEN                        #若單身未輸入條件
       LET g_sql = " SELECT rma01 FROM rma_file,oay_file ",
                   " WHERE ", g_wc CLIPPED,
                   " AND rma01 like ltrim(rtrim(oayslip)) || '-%'",      #No.FUN-550064
                   " AND oaytype='70' ",
                   " ORDER BY rma01"
     ELSE                                         #若單身有輸入條件
       LET g_sql = "SELECT UNIQUE rma01 ",
                   "  FROM rma_file, rmc_file,oay_file ",
                   " WHERE rma01 = rmc01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " AND rma01 like ltrim(rtrim(oayslip)) || '-%'",      #No.FUN-550064
                   " AND oaytype='70' ",
                   " ORDER BY rma01"
    END IF
 
    PREPARE t150_prepare FROM g_sql
    DECLARE t150_cs                               #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t150_prepare
 
    IF g_wc2 = " 1=1" THEN                        #取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM rma_file,oay_file WHERE ",
                   g_wc CLIPPED,
                   " AND rma01 like ltrim(rtrim(oayslip)) || '-%'",      #No.FUN-550064
                   " AND oaytype='70' "
    ELSE
        LET g_sql="SELECT COUNT(*) FROM rma_file,rmc_file,oay_file WHERE ",
                  "rmc01=rma01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   " AND rma01 like ltrim(rtrim(oayslip)) || '-%'",      #No.FUN-550064
                   " AND oaytype='70' "
    END IF
    PREPARE t150_precount FROM g_sql
    DECLARE t150_count CURSOR FOR t150_precount
END FUNCTION
 
FUNCTION t150_menu()
 
   WHILE TRUE
      CALL t150_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t150_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t150_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t150_b('N')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t150_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "點收確認"
         WHEN "confirm_receiving"
            IF cl_chk_act_auth() THEN
               CALL t150_y()
            END IF
       #@WHEN "點收確認取消"
         WHEN "undo_confirm_receiving"
            IF cl_chk_act_auth() THEN
               CALL t150_z()
            END IF
       #@WHEN "補登序號"
         WHEN "enter_serial_no"
            IF cl_chk_act_auth() THEN
               CALL t150_j()
            END IF
      #CHI-C60018 str add-----
       #@WHEN "輸入項次"
         WHEN "enter_ret_no"
            IF cl_chk_act_auth() THEN
               CALL t150_retno()
            END IF
      #CHI-C60018 end add----- 
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rmc),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_rma.rma01 IS NOT NULL THEN
                 LET g_doc.column1 = "rma01"
                 LET g_doc.value1 = g_rma.rma01
                 CALL cl_doc()
               END IF
         END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION t150_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rma.* TO NULL               #No.FUN-6A0018
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_rmc.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t150_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rma.* TO NULL
        RETURN
    END IF
    OPEN t150_cs                               #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rma.* TO NULL
    ELSE
        OPEN t150_count
        FETCH t150_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t150_fetch('F')                   #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t150_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                    #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                    #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t150_cs INTO g_rma.rma01
        WHEN 'P' FETCH PREVIOUS t150_cs INTO g_rma.rma01
        WHEN 'F' FETCH FIRST    t150_cs INTO g_rma.rma01
        WHEN 'L' FETCH LAST     t150_cs INTO g_rma.rma01
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
            FETCH ABSOLUTE g_jump t150_cs INTO g_rma.rma01
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
        CALL cl_err3("sel","rma_file",g_rma.rma01,"",SQLCA.sqlcode,"","",1) #FUN-660111
        INITIALIZE g_rma.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_rma.rmauser #FUN-4C0055
        LET g_data_group = g_rma.rmagrup #FUN-4C0055
        LET g_data_plant = g_rma.rmaplant #FUN-980030
    END IF
 
    CALL t150_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t150_show()
    LET g_rma_t.* = g_rma.*                #保存單頭舊值
    DISPLAY BY NAME                        # 顯示單頭值
        g_rma.rma01,g_rma.rma03,g_rma.rma04,g_rma.rma12,
        g_rma.rma20,g_rma.rma21,g_rma.rma18,g_rma.rmaconf,g_rma.rmarecv,  
        g_rma.rmavoid
    #CKP
    CALL cl_set_field_pic(g_rma.rmarecv,"","","","","")
    CALL t150_b_fill(g_wc2)                #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t150_u()
 DEFINE l_ohc04 LIKE ohc_file.ohc04
   DEFINE l_count LIKE type_file.num5   #TQC-A20036
   
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    MESSAGE ""
    SELECT * INTO g_rma.* FROM rma_file WHERE rma01=g_rma.rma01
    IF g_rma.rma01 IS NULL THEN CALL cl_err('','-400',0) RETURN END IF     #No.FUN-6A0018
    IF g_rma.rmavoid ="N" THEN CALL cl_err('',9027,0) RETURN END IF
    IF g_rma.rmarecv ='Y' THEN CALL cl_err('recv=Y',9023,0) RETURN END IF
    IF g_rma.rmaconf="Y" THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_rma.rma09  ="6" THEN CALL cl_err('','arm-018',0) RETURN END IF
#TQC-A20036 --begin--
    SELECT COUNT(*) INTO l_count FROM rmn_file
     WHERE rmn05 = g_rma.rma01
       AND rmnconf = 'Y'
    IF l_count > 0 THEN 
       CALL cl_err('','arm-007',0)
       RETURN 
    END IF    
#TQC-A20036 --end--   
    
    LET g_rma_t.* = g_rma.*
    CALL cl_opmsg('u')
 
    BEGIN WORK
 
    OPEN t150_cl USING g_rma.rma01
    IF STATUS THEN
       CALL cl_err("OPEN t150_cl:", STATUS, 1)
       CLOSE t150_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t150_cl INTO g_rma.rma01      # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t150_cl ROLLBACK WORK RETURN
    END IF
 
    WHILE TRUE
        LET g_rma.rmamodu=g_user
        LET g_rma.rmadate=g_today
        IF NOT cl_null(g_rma.rma22) THEN
           SELECT ohc04 INTO l_ohc04 FROM ohc_file
            WHERE ohc01=g_rma.rma22
            IF NOT cl_null(l_ohc04) THEN
               SELECT rma06 INTO g_rma.rma20 FROM rma_file  #MOD-840185 mod
                WHERE rma01=g_rma.rma01                     #MOD-840185 mod
            END IF
        END IF
        IF cl_null(g_rma.rma20) THEN
           LET g_rma.rma20=g_today
        END IF
        CALL t150_i("u")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           LET g_rma.* = g_rma_t.*
           CALL t150_show() ROLLBACK WORK EXIT WHILE
        END IF
        IF  g_rma.rma12 IS NULL OR g_rma.rma12 = ' '   OR
            g_rma.rma20 IS NULL OR g_rma.rma20 = ' '   OR
            g_rma.rma21 IS NULL OR g_rma.rma21 = ' '   THEN
            DISPLAY BY NAME g_rma.rma12,g_rma.rma20,
                            g_rma.rma21
            CALL cl_err('',9033,1)
            CONTINUE WHILE
        END IF
        UPDATE rma_file
               set rma20=g_rma.rma20,rma21=g_rma.rma21,rma12=g_rma.rma12,
                   rmamodu=g_user,rmadate=g_today
               WHERE rma01=g_rma.rma01
        IF STATUS THEN 
        CALL cl_err3("upd","rma_file",g_rma_t.rma01,"",STATUS,"","",1) #FUN-660111 
        CONTINUE WHILE END IF
        LET g_rma_t.* = g_rma.*
        EXIT WHILE
    END WHILE
    COMMIT WORK
 
    #CKP
    CALL cl_set_field_pic(g_rma.rmarecv,"","","","","")
 
END FUNCTION
 
#處理INPUT
FUNCTION t150_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改  #No.FUN-690010 VARCHAR(1)
         l_flag          LIKE type_file.num5,    #No.FUN-690010 smallint,
         l_sme02 LIKE sme_file.sme02
 
    DISPLAY BY NAME g_rma.rma01,g_rma.rma03,g_rma.rma04,g_rma.rma20,
        g_rma.rma21,g_rma.rma12,g_rma.rma18,g_rma.rmaconf,
        g_rma.rmarecv,g_rma.rmavoid
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME
        g_rma.rma01,g_rma.rma20,g_rma.rma21,g_rma.rma12 WITHOUT DEFAULTS
 
     BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL t150_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
 
    AFTER FIELD rma20
        IF NOT cl_null(g_rma.rma20) THEN
            IF NOT cl_null(g_rma.rma07) THEN
               IF g_rma.rma07 > g_rma.rma20 THEN
                  CALL cl_err('rma07 > rma20:','arm-036',0)
                  NEXT FIELD rma20
               END IF
            END IF
            IF NOT cl_null(g_rma.rma21) THEN
               IF g_rma.rma20 > g_rma.rma21 THEN
                  CALL cl_err('','arm-010',0)
                  NEXT FIELD rma20
               END IF
            END IF
            IF NOT cl_null(g_rma.rma12) THEN
               IF g_rma.rma12 < g_rma.rma20 THEN
                  CALL cl_err('','arm-025',0)
                  NEXT FIELD rma20 END IF
            END IF
            IF cl_null(g_rma.rma12) THEN    #NO:7138
               LET g_rma.rma12=g_rma.rma20+g_rmz.rmz20
               IF NOT cl_null(g_rma.rma12) THEN
                   CALL s_wkday(g_rma.rma12)  RETURNING l_flag,g_rma.rma12
               END IF
            END IF
            IF cl_null(g_rma.rma21) THEN   #NO:7138
               LET g_rma.rma21=g_rma.rma20
            END IF
        END IF
 
    AFTER FIELD rma21
        IF NOT cl_null(g_rma.rma21) THEN
            IF NOT cl_null(g_rma.rma20) THEN
               IF g_rma.rma21 < g_rma.rma20 THEN
                  CALL cl_err('','arm-010',0)
                  NEXT FIELD rma21 END IF
            END IF
            IF NOT cl_null(g_rma.rma12) THEN
               IF g_rma.rma12 < g_rma.rma21 THEN
                  CALL cl_err('','arm-025',0)
                  NEXT FIELD rma21 END IF
            END IF
        END IF
 
    AFTER FIELD rma12
        IF NOT cl_null(g_rma.rma12) THEN
            IF NOT cl_null(g_rma.rma12) THEN
                CALL s_wkday(g_rma.rma12)  RETURNING l_flag,g_rma.rma12
            END IF
            SELECT sme02 INTO l_sme02 FROM sme_file
             WHERE sme01=g_rma.rma12
            IF l_sme02='N' OR cl_null(l_sme02) THEN
               CALL cl_err('','mfg3152',1)
               NEXT FIELD rma12
            END IF
            IF NOT cl_null(g_rma.rma20) OR NOT cl_null(g_rma.rma21) THEN
               IF g_rma.rma12 < g_rma.rma20 OR g_rma.rma12 < g_rma.rma21 THEN
                  CALL cl_err('','arm-025',0)
                  NEXT FIELD rma12 END IF
            END IF
        END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
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
FUNCTION t150_j()
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rma.* FROM rma_file WHERE rma01=g_rma.rma01
    IF g_rma.rma01 IS NULL THEN RETURN END IF
    IF g_rma.rmavoid ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_rma.rma01,'mfg1000',0)  RETURN END IF
    IF g_rma.rmarecv ='Y' THEN CALL cl_err('recv=Y',9023,0) RETURN END IF
    IF g_rma.rmaconf ='Y' THEN    #檢查資料是否為確認
        CALL cl_err(g_rma.rma01,9023,0)  RETURN  END IF
    IF g_rma.rma09  ="6" THEN CALL cl_err('','arm-018',0) RETURN END IF
    IF cl_null(g_rma.rma12) OR cl_null(g_rma.rma20) OR cl_null(g_rma.rma21) THEN
       DISPLAY BY NAME g_rma.rma12,g_rma.rma20, g_rma.rma21
       CALL cl_err('',9033,0) RETURN END IF
    CALL t150_b('Y')
END FUNCTION
#單身
FUNCTION t150_b(p_in)
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    g_n             LIKE type_file.num5,                #No.FUN-690010 SMALLINT,
    l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
    p_in            LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),               #處理狀態
    l_ima01         LIKE ima_file.ima01,   #料件編號
    l_ogb01         LIKE ogb_file.ogb01,   #出貨單號
    l_ogb03         LIKE ogb_file.ogb03,   #項次
    l_ogb04         LIKE ogb_file.ogb04,   #料件編號
    l_ogb05         LIKE ogb_file.ogb05,   #出貨單單位
    l_ima25         LIKE ima_file.ima25,   #料件編號: 單位
    l_ima148        LIKE ima_file.ima148,  #保證期(天)
    l_ohc04         LIKE ohc_file.ohc04,
    g_rmc17         LIKE rmc_file.rmc17,   #原出貨日期      NO:7181
    g_rmc18         LIKE rmc_file.rmc18,   #保証期(天數)    NO:7181
    g_rmc14         LIKE rmc_file.rmc14,   #修復狀態
    g_rmc31         LIKE rmc_file.rmc31,   #數量
    g_rmc02         LIKE rmc_file.rmc02,   #項次
    l_gfe01         LIKE gfe_file.gfe01,   #料件編號: 單位
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690010 SMALLINT
 DEFINE l_count      LIKE type_file.num5    #TQC-A20036
 DEFINE l_where      STRING                 #MOD-C80068 add
 
    LET g_action_choice = ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rma.* FROM rma_file WHERE rma01=g_rma.rma01
    IF g_rma.rma01 IS NULL THEN RETURN END IF
    IF g_rma.rmavoid ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_rma.rma01,'mfg1000',0)  RETURN END IF
    IF g_rma.rmarecv ='Y' THEN CALL cl_err('recv=Y',9023,0) RETURN END IF
    IF g_rma.rmaconf ='Y' THEN    #檢查資料是否為確認
        CALL cl_err(g_rma.rma01,9023,0)  RETURN  END IF
    IF g_rma.rma09  ="6" THEN CALL cl_err('','arm-018',0) RETURN END IF
    IF cl_null(g_rma.rma12) OR cl_null(g_rma.rma20) OR cl_null(g_rma.rma21) THEN
       DISPLAY BY NAME g_rma.rma12,g_rma.rma20, g_rma.rma21
       CALL cl_err('',9033,0) RETURN END IF
#TQC-A20036 --begin--
    SELECT COUNT(*) INTO l_count FROM rmn_file
     WHERE rmn05 = g_rma.rma01
       AND rmnconf = 'Y'
    IF l_count > 0 THEN 
       CALL cl_err('','arm-007',0)
       RETURN 
    END IF    
#TQC-A20036 --end-- 
       
    CALL cl_opmsg('b')
    LET skipme = "N"
 
       LET g_forupd_sql =
       " SELECT rmc07,rmc02,rmc04,rmc06,rmc061,rmc31,' ',",
       "        rmc05,rmc25,rmc32 ",
       "   FROM rmc_file ",
       "    WHERE rmc01= ? ",
       "    AND rmc02= ? ",
       "  FOR UPDATE "
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE t150_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
       LET l_ac_t = 0
 
           LET l_allow_insert = cl_detail_input_auth("insert")
           LET l_allow_delete = cl_detail_input_auth("delete")
 
           INPUT ARRAY g_rmc WITHOUT DEFAULTS
            FROM s_rmc.*
                 ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                           INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                           APPEND ROW=l_allow_insert)
 
          BEFORE INPUT
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
 
              OPEN t150_cl USING g_rma.rma01
              IF STATUS THEN
                 CALL cl_err("OPEN t150_cl:", STATUS, 1)
                 CLOSE t150_cl
                 ROLLBACK WORK
                 RETURN
              END IF
              FETCH t150_cl INTO g_rma.rma01    # 鎖住將被更改或取消的資料
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                  CLOSE t150_cl ROLLBACK WORK RETURN
              END IF
 
              IF g_rec_b >= l_ac THEN
                 LET p_cmd='u'
                 LET g_rmc_t.* = g_rmc[l_ac].*  #BACKUP
                 LET g_rmc_o.* = g_rmc[l_ac].*  #BACKUP
 
                 OPEN t150_bcl USING g_rma.rma01,g_rmc_t.rmc02
                 IF STATUS THEN
                     CALL cl_err("OPEN t150_bcl:", STATUS, 1)
                 ELSE
                     FETCH t150_bcl INTO g_rmc[l_ac].*
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rmc_t.rmc02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                     END IF
                     SELECT ima131 INTO g_rmc[l_ac].ima131 FROM ima_file
                            WHERE ima01 = g_rmc[l_ac].rmc04
                 END IF
                 LET g_before_input_done = FALSE
                 CALL t150_set_entry_b(p_cmd)
                 CALL t150_set_no_entry_b(p_cmd)
                 LET g_before_input_done = TRUE
                 CALL cl_show_fld_cont()     #FUN-550037(smin)
              END IF
              IF l_ac < g_no AND skipme = 'Y' THEN
                 CALL cl_set_comp_entry("rmc02,rmc04,rmc06,rmc061,
                                         rmc31,ima131,rmc05,rmc25,rmc32",TRUE)
              END IF
              LET skipme = 'N'
 
          AFTER INSERT
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 #CKP
                 CANCEL INSERT
              END IF
              IF cl_null(g_rmc17) AND p_in ='N' THEN
                 LET g_rmc16='N'
                 LET g_rmc09='Y'
              END IF
              INSERT INTO rmc_file(rmc01,rmc02,rmc04,rmc07,
                  rmc25,rmc06,rmc05,rmc31,
                  rmc061,rmc32,rmc14,rmc21,
                  rmc311,rmc312,rmc313,
                  rmc10,rmc11,rmc12,rmc13,
                  rmc19,rmc28,rmc09,rmc16,rmc17,rmc18,
                  rmcplant,rmclegal)#FUN-980007
              VALUES(g_rma.rma01,g_rmc[l_ac].rmc02,
                  g_rmc[l_ac].rmc04,g_rmc[l_ac].rmc07,
                  g_rmc[l_ac].rmc25,g_rmc[l_ac].rmc06,
                  g_rmc[l_ac].rmc05,1,
                  g_rmc[l_ac].rmc061,g_rmc[l_ac].rmc32,
                  '0','0',0,0,0,0,0,0,0,0,0,g_rmc09,g_rmc16,g_rmc17,g_rmc18,
                  g_plant,g_legal)  #FUN-980007
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","rmc_file",g_rma.rma01,g_rmc[l_ac].rmc02,SQLCA.sqlcode,"","",1) #FUN-660111
                  #CKP
                  ROLLBACK WORK
                  CANCEL INSERT
              ELSE
                  MESSAGE 'INSERT O.K'
                  COMMIT WORK
                  LET g_rec_b=g_rec_b+1
                  LET g_success='Y'
                  IF g_rmc[l_ac].rmc31 >1 THEN
                     LET gs_rmc17=g_rmc17   #TQC-AC0013
                    #CALL t150_add_rmc(l_ac)   #CHI-C60018 mark
                     IF g_success="N" THEN
                        CALL cl_err('insert rmc!',9052,0)
                        ROLLBACK WORK
                        CALL t150_show()
                     END IF
                  END IF
                  LET g_no=g_rmc02+g_rmc31-1
              END IF
 
          BEFORE INSERT
             IF p_in ='Y' THEN  #NO:7181
                RETURN
             ELSE
                 LET l_n = ARR_COUNT()
                 LET p_cmd='a'
                 INITIALIZE g_rmc[l_ac].* TO NULL      #900423
                 LET g_rmc[l_ac].rmc31 =  1            #Body default
                 LET g_rmc_t.* = g_rmc[l_ac].*         #新輸入資料
                 LET g_rmc_o.* = g_rmc[l_ac].*         #新輸入資料
                 LET g_before_input_done = FALSE
                 CALL t150_set_entry_b(p_cmd)
                 CALL t150_set_no_entry_b(p_cmd)
                 LET g_before_input_done = TRUE
                 CALL cl_show_fld_cont()     #FUN-550037(smin)
                 NEXT FIELD rmc07
             END IF
 
          BEFORE FIELD rmc02                        #default 序號
              IF g_rmc[l_ac].rmc02 IS NULL OR
                 g_rmc[l_ac].rmc02 = 0 THEN
                 SELECT max(rmc02)+1 INTO g_rmc[l_ac].rmc02
                   FROM rmc_file WHERE rmc01 = g_rma.rma01
                 IF g_rmc[l_ac].rmc02 IS NULL THEN
                    LET g_rmc[l_ac].rmc02 = 1
                 END IF
              END IF
 
          AFTER FIELD rmc02                        #check 序號是否重複
              IF g_rmc[l_ac].rmc02 IS NULL THEN
                 LET g_rmc[l_ac].rmc02 = g_rmc_o.rmc02
              END IF
              IF NOT cl_null(g_rmc[l_ac].rmc02) THEN
                  IF g_rmc[l_ac].rmc02 != g_rmc_o.rmc02 OR
                     g_rmc_t.rmc02 IS NULL THEN
                     SELECT count(*) INTO l_n FROM rmc_file
                        WHERE rmc01 = g_rma.rma01 AND
                              rmc02 = g_rmc[l_ac].rmc02
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_rmc[l_ac].rmc02 = g_rmc_o.rmc02
                        NEXT FIELD rmc02
                     END IF
                  END IF
                  IF p_cmd = 'a' THEN   #MOD-950061
                     CALL t150_rmc02()   #MOD-950061
                  END IF   #MOD-950061
                  LET g_rmc_o.rmc02 = g_rmc[l_ac].rmc02
                  LET g_rmc02 = g_rmc[l_ac].rmc02
              END IF
          BEFORE FIELD rmc04
               CALL t150_set_entry_b(p_cmd)
 
          AFTER FIELD rmc04                  #料件編號
              IF g_rmc[l_ac].rmc04 IS NULL OR g_rmc[l_ac].rmc04 = ' ' THEN
                 CALL cl_err('','aap-099',0)
#FUN-AA0059 ---------------------start----------------------------
          #   END IF
              ELSE
                 IF NOT s_chk_item_no(g_rmc[l_ac].rmc04,"") THEN
                    CALL cl_err('',g_errno,1)
                    LET g_rmc[l_ac].rmc04= g_rmc_t.rmc04
                    NEXT FIELD rmc04
                 END IF
#FUN-AA0059 ---------------------end-------------------------------
                IF g_rmc_o.rmc04 IS NULL OR
                  (g_rmc[l_ac].rmc04 != g_rmc_o.rmc04 ) THEN
                   CALL t150_rmc04(p_cmd,g_rmc[l_ac].rmc04,'')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rmc[l_ac].rmc04,g_errno,0)
                      LET g_rmc[l_ac].rmc04 = g_rmc_t.rmc04
                      LET g_rmc[l_ac].rmc06 = g_rmc_t.rmc06
                      LET g_rmc[l_ac].rmc061 = g_rmc_t.rmc061
                      LET g_rmc[l_ac].ima131 = g_rmc_t.ima131
                      DISPLAY BY NAME g_rmc[l_ac].rmc04
                      DISPLAY BY NAME g_rmc[l_ac].rmc06
                      DISPLAY BY NAME g_rmc[l_ac].rmc061
                      DISPLAY BY NAME g_rmc[l_ac].ima131
                      NEXT FIELD rmc04
                    END IF
                    IF NOT cl_null(g_rma.rma22) THEN            #客訴單
                       SELECT ohc04 INTO l_ohc04 FROM ohc_file  #NO:出貨單
                        WHERE ohc01=g_rma.rma22
                           IF NOT cl_null(l_ohc04) THEN
                              SELECT oga02 INTO g_rma.rma20 FROM oga_file
                               WHERE oga01=l_ohc04
                           END IF
                    END IF
                    IF NOT cl_null(g_rma.rma20) THEN
                        SELECT ima148 INTO g_rmc18 FROM ima_file
                         WHERE ima01=g_rmc[l_ac].rmc04
                        IF cl_null(g_rmc18)  THEN
                            LET g_rmc18=0
                        END IF
                        LET g_rmc17=g_rma.rma20   # 原出貨日期
                        IF (g_rmc17+g_rmc18)>g_rma.rma02 THEN
                            LET g_rmc16='Y'   #保固
                            LET g_rmc09='N'   #不收費
                        ELSE
                            LET g_rmc16='N'   #不保固
                            LET g_rmc09='Y'   #收費
                         END IF
                    END IF
                  END IF
               END IF                                           #FUN-AA0059   
               IF INT_FLAG THEN                 #900423
                  CALL cl_err('',9001,0)
                  LET g_rmc[l_ac].* = g_rmc_t.*
                  EXIT INPUT
               END IF
               LET g_rmc_o.rmc04 = g_rmc[l_ac].rmc04
               CALL t150_set_no_entry_b(p_cmd)
 
          BEFORE FIELD rmc07
               CALL t150_set_entry_b(p_cmd)
          AFTER FIELD rmc07
              IF p_cmd='a' AND cl_null(g_rmc[l_ac].rmc07) AND cl_null(g_rmc[l_ac].rmc04) THEN
                 LET l_ogb01=NULL
                 LET l_ogb04=NULL
              END IF
              IF NOT cl_null(g_rmc[l_ac].rmc07) THEN
                  SELECT MAX(ogb01),ogb03,ogb04,ogb05 INTO l_ogb01,l_ogb03,l_ogb04,l_ogb05 from ogb_file,ogbb_file
                   WHERE ogbb02 = g_rmc[l_ac].rmc07
                     AND ogbb01 = ogb01
                     AND ogbb012= ogb03
                   GROUP BY ogb01,ogb03,ogb04,ogb05
                   IF SQLCA.SQLCODE THEN
                       LET l_ogb01=NULL
                       LET l_ogb03=NULL
                       LET l_ogb04=NULL
                       LET l_ogb05=NULL
                       IF  p_in='Y' THEN
                            CALL cl_err(g_rmc[l_ac].rmc07,'arm-519',1)               
                       ELSE
                           CALL cl_err(g_rmc[l_ac].rmc07,'arm-526',1)  #No:7723
                       END IF
                   ELSE                #check S/N是否有重復
                       IF NOT cl_null(l_ogb04) AND (g_rmc[l_ac].rmc07 != g_rmc_t.rmc07 OR
                              g_rmc_t.rmc07 IS NULL )THEN
                          SELECT COUNT(*) INTO l_n FROM rmc_file
                           WHERE rmc07=g_rmc[l_ac].rmc07
                             AND rmc04=l_ogb04
                             AND rmc14 IN ('0','1','2')    #NO:7181
                          IF l_n>0 THEN
                              CALL cl_err(l_n+1,'arm-011',1)  #MOD-7A0183 modify 0->1
                          END IF
                       END IF
                   END IF
              END IF
              IF NOT cl_null(l_ogb01) AND NOT cl_null(g_rmc[l_ac].rmc07) AND p_in='N' THEN    #判斷是否S/N存在ogbb_file中
                  SELECT COUNT(*) INTO l_n FROM ogbb_file
                   WHERE ogbb01=l_ogb01
                     AND ogbb02=g_rmc[l_ac].rmc07
                  IF l_n=0 THEN
                      CALL cl_err(g_rmc[l_ac].rmc07,'arm-519',0)
                      LET g_rmc[l_ac].rmc07=NULL
                  END IF
              END IF
              IF NOT cl_null(l_ogb04) AND p_in='N' AND (p_cmd = 'u' AND g_rmc[l_ac].rmc07 != g_rmc_t.rmc07 )THEN
                   SELECT COUNT(*) INTO l_n FROM rmc_file
                        WHERE rmc07=g_rmc[l_ac].rmc07
                          AND rmc04=l_ogb04
                          AND rmc14 IN ('0','1','2')    #NO:7181
                   IF l_n>1 THEN
                       CALL cl_err(l_n+1,'arm-011',1)  #MOD-7A0183 modify 0->1
                   END IF
              END IF
 
              IF NOT cl_null(l_ogb01) AND p_in='N' THEN
                  SELECT oga02 INTO g_rma.rma20 FROM oga_file
                   WHERE oga01=l_ogb01
                   IF NOT cl_null(g_rma.rma20) THEN
                       SELECT ima148 INTO g_rmc18 FROM ima_file
                        WHERE ima01=l_ogb04
                       IF cl_null(g_rmc18)  THEN
                           LET g_rmc18=0
                       END IF
                       LET g_rmc17=g_rma.rma20   # 原出貨日期
                       IF (g_rmc17+g_rmc18)>g_rma.rma02 THEN
                           LET g_rmc16='Y'   #保固
                           LET g_rmc09='N'   #不收費
                       ELSE
                           LET g_rmc16='N'   #不保固
                           LET g_rmc09='Y'   #收費
                       END IF
                   END IF
              END IF
 
              IF p_cmd='u' AND ((l_ogb04 !=g_rmc[l_ac].rmc04 )
                  AND NOT cl_null(g_rmc[l_ac].rmc07)
                  AND NOT cl_null(l_ogb04)
                  AND NOT cl_null(g_rmc[l_ac].rmc04)) THEN  #修改狀態
                  IF  p_in='Y' THEN
                      CALL cl_err(g_rmc[l_ac].rmc07,'arm-525',1)
                           NEXT FIELD rmc07
                      END IF
                  IF cl_confirm('arm-518') THEN       #重新產生資料
                      LET g_rmc[l_ac].rmc04=l_ogb04
                      IF NOT cl_null(l_ogb01) AND        #出貨單&項次有的話
                         NOT cl_null(l_ogb03) THEN       #單位defaul出貨單
                         CALL t150_rmc04(p_cmd,l_ogb04,l_ogb05)
                      ELSE
                         CALL t150_rmc04(p_cmd,l_ogb04,'')
                      END IF
                  END IF
              ELSE
                  IF g_rmc[l_ac].rmc02 IS NULL OR g_rmc[l_ac].rmc02 = 0 AND p_in='N' THEN
                       SELECT max(rmc02)+1 INTO g_rmc[l_ac].rmc02    #DEFAULT項次
                         FROM rmc_file WHERE rmc01 = g_rma.rma01
                       IF g_rmc[l_ac].rmc02 IS NULL THEN
                          LET g_rmc[l_ac].rmc02 = 1
                       END IF
                   END IF
                   IF p_cmd='a' AND p_in='N' THEN
                       LET g_rmc[l_ac].rmc04=l_ogb04     #NO:新增時
                       IF NOT cl_null(g_rmc[l_ac].rmc04) THEN
                          IF NOT cl_null(l_ogb01) AND    # 出貨單&項次有的話
                             NOT cl_null(l_ogb03) THEN   # 單位defaul出或單
                             CALL t150_rmc04(p_cmd,l_ogb04,l_ogb05)
                          ELSE
                             CALL t150_rmc04(p_cmd,l_ogb04,'')
                          END IF
                       END IF
                   END IF
               END IF
               IF NOT cl_null(g_errno) AND p_in='N' THEN
                   CALL cl_err(g_rmc[l_ac].rmc04,g_errno,0)
                   LET g_rmc[l_ac].rmc04  = g_rmc_t.rmc04
                   LET g_rmc[l_ac].rmc06  = g_rmc_t.rmc06
                   LET g_rmc[l_ac].rmc061 = g_rmc_t.rmc061
                   LET g_rmc[l_ac].ima131 = g_rmc_t.ima131
                END IF
                IF p_in='N' THEN                        #p_in表b單身輸入
                   IF cl_null(g_rmc[l_ac].rmc07) THEN   # S/N沒輸往下一FIELD 輸入
                      NEXT FIELD rmc02
                   ELSE
                      IF cl_null(l_ogb01) THEN          #S/N有輸可是不存在出貨單中的S/N
                         NEXT FIELD rmc02               #可以輸入下一FIELD
                      ELSE
                         CALL cl_set_comp_entry("rmc02,rmc04,rmc06,rmc061,
                                                 rmc31,ima131,rmc05,rmc25,rmc32",
                                                 FALSE)
                      END  IF                           #直接到下一RECORD
                   END IF
                ELSE
                   CALL cl_set_comp_entry("rmc02,rmc04,rmc06,rmc061,
                                           rmc31,ima131,rmc05,rmc25,rmc32",FALSE)
                END IF
                CALL t150_set_no_entry_b(p_cmd)
 
        AFTER FIELD rmc05
            IF cl_null(g_rmc[l_ac].rmc05) THEN
               LET g_rmc[l_ac].rmc05 = g_rmc_t.rmc05
               DISPLAY BY NAME g_rmc[l_ac].rmc05
            END IF
            IF NOT cl_null(g_rmc[l_ac].rmc05) THEN
               SELECT gfe01 INTO l_gfe01 FROM gfe_file  #須存在單位主檔
               WHERE  gfe01=g_rmc[l_ac].rmc05
               IF STATUS THEN
                  CALL cl_err3("sel","gfe_file",g_rmc[l_ac].rmc05,"","afa-319","","",1) #FUN-660111
                  NEXT FIELD rmc05
               END IF
            END IF
        #FUN-BB0084 ---------------Begin----------------
            IF NOT cl_null(g_rmc[l_ac].rmc05) AND NOT cl_null(g_rmc[l_ac].rmc31) THEN
               IF cl_null(g_rmc_o.rmc31) OR cl_null(g_rmc_o.rmc05) OR
                  g_rmc_o.rmc31 ! = g_rmc[l_ac].rmc31 OR g_rmc_o.rmc05 ! = g_rmc[l_ac].rmc05 THEN
                  LET g_rmc[l_ac].rmc31 = s_digqty(g_rmc[l_ac].rmc31,g_rmc[l_ac].rmc05)
                  DISPLAY BY NAME g_rmc[l_ac].rmc31
               END IF
            END IF
        #FUN-BB0084 ---------------End------------------
            LET g_rmc_o.rmc05 = g_rmc[l_ac].rmc05
 
        AFTER FIELD rmc25                  #DEFAULT值: IMA的產品預測料件
           IF NOT cl_null(g_rmc[l_ac].rmc25) THEN
              SELECT bmi01 FROM bmi_file WHERE bmi01 = g_rmc[l_ac].rmc25
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","bmi_file",g_rmc[l_ac].rmc25,"","arm_003","","",1) #FUN-660111
                  LET g_rmc[l_ac].rmc25 = g_rmc_t.rmc25
                  NEXT FIELD rmc25
              END IF
            END IF
            LET g_rmc_o.rmc25 = g_rmc[l_ac].rmc25
 
        AFTER FIELD rmc31
            IF NOT cl_null(g_rmc[l_ac].rmc31) THEN
               IF g_rmc[l_ac].rmc31 < 0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD CURRENT
                END IF 
        #FUN-BB0084 --------------Begin---------------
                IF NOT cl_null(g_rmc[l_ac].rmc05) THEN
                   IF cl_null(g_rmc_o.rmc31) OR cl_null(g_rmc_o.rmc05) OR
                      g_rmc_o.rmc31 ! = g_rmc[l_ac].rmc31 OR g_rmc_o.rmc05 ! = g_rmc[l_ac].rmc05 THEN
                      LET g_rmc[l_ac].rmc31 = s_digqty(g_rmc[l_ac].rmc31,g_rmc[l_ac].rmc05)
                      DISPLAY BY NAME g_rmc[l_ac].rmc31
                   END IF
                END IF
        #FUN-BB0084 --------------End----------------
                IF g_rmc[l_ac].rmc07 IS NOT NULL AND g_rmc[l_ac].rmc31 != 1 THEN
                   CALL cl_err('rmc31=1','arm-037',0)
                   NEXT FIELD rmc31
                END IF
                LET g_rmc_o.rmc31 = g_rmc[l_ac].rmc31
                LET g_rmc31=g_rmc[l_ac].rmc31
            END IF
 
 
        BEFORE DELETE            #是否取消單身
         IF  p_in ='Y' THEN      #NO:7181
            RETURN
         ELSE
            IF g_rmc_t.rmc02 > 0 AND
               g_rmc_t.rmc02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                SELECT rmc14 INTO g_rmc14 FROM rmc_file
                    WHERE rmc01 = g_rma.rma01 AND
                          rmc02 = g_rmc_t.rmc02
                IF g_rmc14 != '0' THEN
                    CALL cl_err(g_rmc14,'arm-038',0)
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM rmc_file
                    WHERE rmc01 = g_rma.rma01 AND
                          rmc02 = g_rmc_t.rmc02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","rmc_file",g_rma.rma01,g_rmc_t.rmc02,SQLCA.sqlcode,"","",1) #FUN-660111
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
            END IF
         END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rmc[l_ac].* = g_rmc_t.*
               CLOSE t150_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rmc[l_ac].rmc07,-263,1)
               LET g_rmc[l_ac].* = g_rmc_t.*
            ELSE
                UPDATE rmc_file SET
                       rmc02=g_rmc[l_ac].rmc02,
                       rmc04=g_rmc[l_ac].rmc04,
                       rmc07=g_rmc[l_ac].rmc07,
                       rmc25=g_rmc[l_ac].rmc25,
                       rmc06=g_rmc[l_ac].rmc06,
                       rmc05=g_rmc[l_ac].rmc05,
                       rmc31=g_rmc[l_ac].rmc31,
                       rmc061=g_rmc[l_ac].rmc061,
                       rmc32=g_rmc[l_ac].rmc32
                     WHERE rmc01=g_rma.rma01 AND
                           rmc02=g_rmc_t.rmc02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","rmc_file",g_rma.rma01,g_rmc_t.rmc02,SQLCA.sqlcode,"","",1) #FUN-660111
                    LET g_rmc[l_ac].* = g_rmc_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac      #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_rmc[l_ac].* = g_rmc_t.*
            #FUN-D40030--add--str--
               ELSE
                  CALL g_rmc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D40030--add--end--
               END IF
               CLOSE t150_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 add
            CLOSE t150_bcl
            COMMIT WORK
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rmc04) #料件編號
#FUN-AA0059---------mod------------str-----------------               
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.default1 = g_rmc[l_ac].rmc04
#                  CALL cl_create_qry() RETURNING g_rmc[l_ac].rmc04
                   LET l_where  = "ima01 in (SELECT rmb03 FROM rmb_file WHERE rmb01='",g_rma.rma01,"')"   #MOD-C80068 add
                   CALL q_sel_ima(FALSE, "q_ima",l_where,g_rmc[l_ac].rmc04,"","","","","",'' )            #MOD-C80068 add l_where
                     RETURNING  g_rmc[l_ac].rmc04

#FUN-AA0059---------mod------------end-----------------
                   DISPLAY BY NAME g_rmc[l_ac].rmc04    #No.MOD-490371
                  NEXT FIELD rmc04
               WHEN INFIELD(rmc05) #單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_rmc[l_ac].rmc05
                  CALL cl_create_qry() RETURNING g_rmc[l_ac].rmc05
                   DISPLAY BY NAME g_rmc[l_ac].rmc05    #No.MOD-490371
                  NEXT FIELD rmc05
               WHEN INFIELD(rmc25) #
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bmi"
                  LET g_qryparam.default1 = g_rmc[l_ac].rmc25
                  CALL cl_create_qry() RETURNING g_rmc[l_ac].rmc25
                   DISPLAY BY NAME g_rmc[l_ac].rmc25    #No.MOD-490371
                  NEXT FIELD rmc25
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
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
 
        END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
    END IF
    LET g_success="Y"
    CALL t150_up_rmbc()
    IF g_success="Y" THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION t150_add_rmc(l_ac)      #傳在陣列第幾筆,在螢幕第幾筆
   DEFINE g_n,g_n1,g_rmc02,l_ac LIKE type_file.num5    #No.FUN-690010 SMALLINT
   #TQC-A20035---Begin
   DEFINE g_rmc18  LIKE rmc_file.rmc18

   SELECT ima148 INTO g_rmc18 FROM ima_file
    WHERE ima01 = g_rmc[l_ac].rmc04
   #TQC-A20035---End
   FOR g_n1=2 TO g_rmc[l_ac].rmc31   #MOD-950061
       SELECT MAX(rmc02)+1 INTO g_rmc02
              FROM rmc_file WHERE rmc01=g_rma.rma01
       INSERT INTO rmc_file(rmc01,rmc02,rmc04,rmc07,
                rmc25,rmc06,rmc05,rmc31,
                rmc061,rmc32,rmc17,rmc14,rmc21,
                rmc311,rmc312,rmc313,
                rmc10,rmc11,rmc12,rmc13,rmc18,
                rmc19,rmc28,rmc16,rmc09, #MOD-980066
                rmcplant,rmclegal)       #FUN-980007 
       VALUES(g_rma.rma01,g_rmc02,
              g_rmc[l_ac].rmc04,g_rmc[l_ac].rmc07,
              g_rmc[l_ac].rmc25,g_rmc[l_ac].rmc06,
              g_rmc[l_ac].rmc05,1,
              #g_rmc[l_ac].rmc061,g_rmc[l_ac].rmc32,'',       #TQC-AC0013
              g_rmc[l_ac].rmc061,g_rmc[l_ac].rmc32,gs_rmc17,  #TQC-AC0013
              #'0','0',0,0,0,0,0,0,0,0,0,0,g_rmc16,g_rmc09,   #MOD-980066  #TQC-A20035
              '0','0',0,0,0,0,0,0,0,g_rmc18,0,0,g_rmc16,g_rmc09,   #TQC-A20035
              g_plant,g_legal )          #FUN-980007
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rmc_file",g_rma.rma01,g_rmc02,SQLCA.sqlcode,"","",1) #FUN-660111
         LET g_success="N"
         RETURN
      END IF
   END FOR
 
   LET skipme = "Y"
   CALL t150_b_fill(' 1=1')
END FUNCTION
 
FUNCTION t150_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rmc TO s_rmc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t150_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t150_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t150_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t150_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t150_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 點收確認
      ON ACTION confirm_receiving
         LET g_action_choice="confirm_receiving"
         EXIT DISPLAY
    #@ON ACTION 點收確認取消
      ON ACTION undo_confirm_receiving
         LET g_action_choice="undo_confirm_receiving"
         EXIT DISPLAY
    #@ON ACTION 補登序號
      ON ACTION enter_serial_no
         LET g_action_choice="enter_serial_no"
         EXIT DISPLAY
   #CHI-C60018 str add-----
    #@ON ACTION 輸入項次
      ON ACTION enter_ret_no
         LET g_action_choice="enter_ret_no"
         EXIT DISPLAY
   #CHI-C60018 end add-----
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t150_up_rmbc()
    DEFINE l_n        LIKE type_file.num5    #No.FUN-690010 SMALLINT
    DEFINE l_rmc31    LIKE rmc_file.rmc31
    DEFINE l_rmc04    LIKE rmc_file.rmc04
    DEFINE l_rmc06    LIKE rmc_file.rmc06
    DEFINE l_rmc05    LIKE rmc_file.rmc05
    DEFINE l_rmc061   LIKE rmc_file.rmc061
 
    BEGIN WORK  #5456
   #update rmb:  rmb12 (rmc01+rmc04+rmc06->rmb01+rmb03+rmb05: rmb12=sum(rmc31) )
   #update rmc:  rmc03 (rmb01+rmb04+rmb05->rmc01+rmc04+rmc06: rmb02=rmc03)
    DELETE FROM rmb_file WHERE rmb01=g_rma.rma01 AND rmb11=0 AND
#TQC-AB0025----------mod------------------------str---------------------
#               rmb03 NOT IN (SELECT UNIQUE(rmc04) FROM rmc_file
#                             WHERE rmc01=g_rma.rma01 AND rmc04=rmb03 )
                rmb03 NOT IN (SELECT UNIQUE(rmc04) FROM rmc_file LEFT OUTER JOIN rmb_file 
                              ON rmc04=rmb03
                              WHERE rmc01=g_rma.rma01 )
#TQC-AB0025----------mod------------------------end-------------------
    IF SQLCA.sqlcode THEN  #5456
       LET g_success="N"
       CALL cl_err3("del","rmb_file",g_rma.rma01,"",STATUS,"","del rmb:",1) #FUN-660111
       RETURN
    END IF
    DECLARE z_curs CURSOR FOR
      SELECT '','',DISTINCT(rmc04),rmc06,rmc061,rmc07,rmc31,'',rmc05,rmc25,rmc32,''
        FROM rmc_file
       WHERE rmc01 = g_rmbc.rmc01 AND rmc04 = g_rmbc.rmc04
         AND rmc06 = g_rmbc.rmc06
    DECLARE rmbc_cs  CURSOR FOR              #SCROLL CURSOR
        SELECT rmc01,rmc04,rmc06,sum(rmc31),rmb02 from rmc_file LEFT JOIN rmb_file ON rmc01=rmb_file.rmb01
            where rmc01=g_rma.rma01 AND rmc04=rmb_file.rmb03
            group by rmc01,rmc04,rmc06,rmb02  order by rmc01,rmc04,rmc06,rmb02
    LET g_cnt = 1
 
 
    OPEN t150_cl USING g_rma.rma01
    IF STATUS THEN
       CALL cl_err("OPEN t150_cl:", STATUS, 1)
       CLOSE t150_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t150_cl INTO g_rma.rma01    # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t150_cl RETURN
    END IF
 
    FOREACH rmbc_cs INTO g_rmbc.*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            LET g_success="N"
            CALL cl_err('foreach:',STATUS,0)
            RETURN
        END IF
        IF g_rmbc.rmc31 IS NULL THEN LET g_rmbc.rmc31=0 END IF
        SELECT COUNT(*) INTO l_n FROM rmb_file 
                    WHERE rmb01=g_rma.rma01
                    AND rmb03=g_rmbc.rmc04 
        IF l_n=0 THEN
           INITIALIZE g_rmb.* TO NULL
           SELECT MAX(rmb02)+1 INTO g_rmb.rmb02 FROM rmb_file
                  WHERE rmb01=g_rma.rma01
           IF g_rmb.rmb02 IS NULL THEN LET g_rmb.rmb02=1 END IF
           SELECT DISTINCT(rmc04),rmc06,rmc061,rmc05
             INTO l_rmc04,l_rmc06,l_rmc061,l_rmc05
             FROM rmc_file
             WHERE rmc01 = g_rmbc.rmc01
               AND rmc04 = g_rmbc.rmc04
           IF NOT cl_null(l_rmc04) THEN
              LET g_rmb.rmb04=l_rmc05 LET g_rmb.rmb05=l_rmc06
              LET g_rmb.rmb06=l_rmc061
           ELSE
              SELECT ima25,ima02,ima021 INTO g_rmb.rmb04,g_rmb.rmb05,
                      g_rmb.rmb06
                FROM ima_file
               WHERE ima01=g_rmbc.rmc04
           END IF
           LET g_rmb.rmb01=g_rma.rma01   LET g_rmb.rmb03=g_rmbc.rmc04
           LET g_rmb.rmb11=0             LET g_rmb.rmb12=g_rmbc.rmc31
           LET g_rmb.rmb13=0             LET g_rmb.rmb14=0
           LET g_rmb.rmb111=0            LET g_rmb.rmb121=0
           LET g_rmb.rmbplant = g_plant #FUN-980007
           LET g_rmb.rmblegal = g_legal #FUN-980007
           INSERT INTO rmb_file VALUES(g_rmb.*)
           IF SQLCA.sqlcode THEN
              LET g_success="N"
              CALL cl_err3("ins","rmb_file",g_rmb.rmb01,g_rmb.rmb02,SQLCA.sqlcode,"","ins rmb:",1) #FUN-660111
              RETURN END IF
           LET g_rmbc.rmb02=g_rmb.rmb02
        ELSE
           SELECT SUM(rmc31) INTO l_rmc31 FROM rmc_file
            WHERE rmc01 = g_rmbc.rmc01
              AND rmc04 = g_rmbc.rmc04
           IF cl_null(l_rmc31) THEN LET l_rmc31 = 0 END IF
           UPDATE rmb_file set rmb12=l_rmc31
               WHERE rmb01 = g_rmbc.rmc01
                 AND rmb03 = g_rmbc.rmc04
           IF SQLCA.sqlcode THEN
              LET g_success="N"
              CALL cl_err3("upd","rmb_file",g_rmbc.rmc01,g_rmbc.rmc04,SQLCA.sqlcode,"","up rmb:",1) #FUN-660111
               RETURN END IF
        END IF
        UPDATE rmc_file set rmc03=g_rmbc.rmb02   #rmb02->rmc03
             WHERE rmc01=g_rmbc.rmc01 AND rmc04=g_rmbc.rmc04
        IF SQLCA.sqlcode THEN
           LET g_success="N"
           CALL cl_err3("upd","rmc_file",g_rmbc.rmc01,g_rmbc.rmc04,SQLCA.sqlcode,"","up rmc:",1) #FUN-660111
           RETURN END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
    CLOSE z_curs
    LET g_cnt = g_cnt - 1
    IF g_cnt=0 THEN RETURN END IF
END FUNCTION
 
FUNCTION t150_rmc04(p_cmd,l_rmc04,l_ogb05)  #料件編號
    DEFINE l_ima02    LIKE ima_file.ima02,   #品名
           l_ima25    LIKE ima_file.ima25,   #庫存單位
           l_ima021   LIKE ima_file.ima021,  #規格
           l_ima133   LIKE ima_file.ima133,  #產品預測料號
           l_imaacti  LIKE ima_file.imaacti,
           l_ima131   LIKE ima_file.ima131,  #產品分類編號
           l_rmc04    LIKE rmc_file.rmc04,   #NO:7181
           l_ogb05    LIKE ogb_file.ogb05,     #NO:7181
           p_cmd      LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima25,ima133,imaacti,ima131
      INTO l_ima02,l_ima021,l_ima25,l_ima133,l_imaacti,l_ima131
      FROM ima_file WHERE ima01 = l_rmc04   #NO:7181
       AND ima01 in (SELECT rmb03 FROM rmb_file WHERE rmb01=g_rma.rma01)    #MOD-C80068 add
 
   #CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'arm-006'                  #MOD-C80068 mark
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'arm-052'                  #MOD-C80068 add
                            LET l_ima02 = NULL
                            LET l_ima25 = NULL
                            LET l_ima133 = NULL
                            LET l_ima131 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = ' '
    END CASE
    IF p_cmd = 'a' OR (g_rmc[l_ac].rmc04 != g_rmc_o.rmc04) THEN  #No:7723
        IF NOT cl_null(l_ogb05) THEN
            LET g_rmc[l_ac].rmc05 =l_ogb05   #NO:DEFAULT 出貨單身單位
        ELSE
            LET g_rmc[l_ac].rmc05 = l_ima25
        END IF
    END IF
#FUN-BB0084 ----------------Begin-----------------
    IF NOT cl_null(g_rmc[l_ac].rmc31) THEN
       LET g_rmc[l_ac].rmc31 = s_digqty(g_rmc[l_ac].rmc31,g_rmc[l_ac].rmc05)
       DISPLAY BY NAME g_rmc[l_ac].rmc31
    END IF
#FUN-BB0084 ----------------End-------------------   
    
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_rmc[l_ac].rmc06 = l_ima02
       LET g_rmc[l_ac].rmc061 = l_ima021
       LET g_rmc[l_ac].ima131 = l_ima131
    END IF
END FUNCTION
 
FUNCTION t150_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON rmc02,rmc04,rmc06,rmc061,rmc07,rmc31,ima131,
                       rmc05,rmc25,rmc32              # 螢幕上取單身條件
            FROM s_rmc[1].rmc02,s_rmc[1].rmc04,s_rmc[1].rmc06,
                 s_rmc[1].rmc061,s_rmc[1].rmc07,s_rmc[1].rmc31,
                 s_rmc[1].ima131,s_rmc[1].rmc05,s_rmc[1].rmc25,
                 s_rmc[1].rmc32
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
    CALL t150_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t150_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    LET g_sql =
        "SELECT rmc07,rmc02,rmc04,rmc06,rmc061,rmc31,ima131,",
        " rmc05,rmc25,rmc32    ",
        " FROM rmc_file LEFT JOIN ima_file ON rmc04=ima_file.ima01,rma_file ",
        " WHERE rmc01 ='",g_rma.rma01,"'",  #單頭
        " AND ",p_wc2 CLIPPED,              #單身
        " AND rmc01=rma01 ",
        " ORDER BY rmc02"
    PREPARE t150_pb FROM g_sql
    DECLARE rmc_cs                       #SCROLL CURSOR
        CURSOR FOR t150_pb
 
    CALL g_rmc.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH rmc_cs INTO g_rmc[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_rmc.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t150_y()            # when g_rma.rmarecv='N' (Turn to 'Y')
   DEFINE g_i   LIKE type_file.num10    #No.FUN-690010 integer
   DEFINE l_cnt LIKE type_file.num5    #No.FUN-690010 SMALLINT
   DEFINE l_rma16 LIKE rma_file.rma16,  #MOD-7A0186 
          l_rma17 LIKE rma_file.rma17   #MOD-7A0186
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   SELECT * INTO g_rma.* FROM rma_file WHERE rma01 = g_rma.rma01
   IF g_rma.rma01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rma.rmavoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rma.rmarecv = 'Y' THEN CALL cl_err('recv=Y',9023,0) RETURN END IF
   IF g_rma.rma09   = '6' THEN CALL cl_err('rma09=6','arm-018',0) RETURN END IF
 
#---BUGNO:7379---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rmc_file
    WHERE rmc01=g_rma.rma01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   CALL cl_upsw(18,10,'N') RETURNING g_i
   IF NOT g_i THEN
      DISPLAY BY NAME g_rma.rmarecv
      RETURN
   END IF
   BEGIN WORK
 
 
    OPEN t150_cl USING g_rma.rma01
    IF STATUS THEN
       CALL cl_err("OPEN t150_cl:", STATUS, 1)
       CLOSE t150_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t150_cl INTO g_rma.rma01    # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t150_cl ROLLBACK WORK RETURN
    END IF
 
    LET g_success = 'Y'
    UPDATE rma_file SET rmarecv = 'Y',rmamodu=g_user,rmadate=g_today
         WHERE rma01 = g_rma.rma01
    IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","rma_file",g_rma.rma01,"",9050,"","confirm",1) #FUN-660111
        LET g_success = 'N' 
        ROLLBACK WORK             #MOD-980120
        RETURN
    END IF
    IF g_rmz.rmz19='Y' AND g_rma.rma08='1' THEN   #rma08為內銷'1'
        SELECT rma16,rma17 INTO l_rma16,l_rma17 
          FROM rma_file 
         WHERE rma01 = g_rma.rma01
        IF cl_null(l_rma16) OR cl_null(l_rma17) THEN
           CALL cl_getmsg('anm-040',g_lang) RETURNING g_msg
           CALL cl_err(g_msg,'anm-067',1)  # LET g_success = 'N' RETURN  #MOD-980120 mark
           LET g_success = 'N'
        END IF 
        LET g_rma.rmaconf='Y'
        LET g_rma.rma07=g_rma.rma02
        UPDATE rma_file SET rmaconf = g_rma.rmaconf,rma07=g_rma.rma07
         WHERE rma01 = g_rma.rma01
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            CALL cl_err3("upd","rma_file",g_rma.rma01,"",9050,"","rmaconf",1) #FUN-660111
            LET g_success = 'N' # RETURN  #MOD-980120 mark
        END IF
    END IF
    IF g_success='Y' THEN
        LET g_rma.rmarecv='Y'
        COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    DISPLAY BY NAME g_rma.rmarecv
    DISPLAY BY NAME g_rma.rmaconf
    MESSAGE ''
    #CKP
    CALL cl_set_field_pic(g_rma.rmarecv,"","","","","")
END FUNCTION
 
FUNCTION t150_z()             # when g_rma.rmarecv='Y' (Turn to 'N')
   DEFINE g_i  LIKE type_file.num10   #No.FUN-690010 integer
    DEFINE l_count LIKE type_file.num5    #TQC-A20036
    
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   SELECT * INTO g_rma.* FROM rma_file WHERE rma01 = g_rma.rma01
   IF g_rma.rma01 IS NULL THEN CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rma.rmavoid = 'N' THEN CALL cl_err('void=N',9027,0) RETURN END IF
   IF g_rma.rmarecv = 'N' THEN CALL cl_err('recv=N',9025,0) RETURN END IF
   IF g_rmz.rmz19<>'Y' AND g_rma.rma08<>'1' THEN   #rma08為內銷'1'
      IF g_rma.rmaconf = 'Y' THEN CALL cl_err('conf=Y',9023,0) RETURN END IF
   END IF                                                         
   IF g_rma.rma09   = '6' THEN CALL cl_err('rma09=6','arm-018',0) RETURN END IF
#TQC-A20036 --begin--
    SELECT COUNT(*) INTO l_count FROM rmn_file
     WHERE rmn05 = g_rma.rma01
       AND rmnconf = 'Y'
    IF l_count > 0 THEN 
       CALL cl_err('','arm-007',0)
       RETURN 
    END IF    
#TQC-A20036 --end--       
   
   CALL cl_upsw(18,10,'Y') RETURNING g_i
   IF NOT g_i THEN
      DISPLAY BY NAME g_rma.rmarecv
      RETURN
   END IF
   BEGIN WORK
 
 
    OPEN t150_cl USING g_rma.rma01
    IF STATUS THEN
       CALL cl_err("OPEN t150_cl:", STATUS, 1)
       CLOSE t150_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t150_cl INTO g_rma.rma01    # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rma.rma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t150_cl ROLLBACK WORK RETURN
    END IF
 
    LET g_success = 'Y'
    UPDATE rma_file SET rmarecv = 'N',rmamodu=g_user,rmadate=g_today
            WHERE rma01 = g_rma.rma01
    IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_err('',9050,1) LET g_success = 'N' RETURN
    END IF
    IF g_rmz.rmz19='Y' AND g_rma.rma08='1' THEN   #rma08為內銷'1'
        LET g_rma.rmaconf='N'
        UPDATE rma_file SET rmaconf = g_rma.rmaconf WHERE rma01 = g_rma.rma01
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
            CALL cl_err('rmaconf',9050,1) LET g_success = 'N' RETURN
            LET g_rma.rmaconf='Y'
            LET g_success='N'
        END IF
    END IF
    IF g_success = 'Y' THEN
       LET g_rma.rmarecv='N'
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    DISPLAY BY NAME g_rma.rmarecv
    DISPLAY BY NAME g_rma.rmaconf
    MESSAGE ''
    #CKP
    CALL cl_set_field_pic(g_rma.rmarecv,"","","","","")
END FUNCTION
 
FUNCTION t150_out()
DEFINE
    sr              RECORD
        rma01       LIKE rma_file.rma01,   # RMA單號
        rma03       LIKE rma_file.rma03,   # 客戶編號
        rma04       LIKE rma_file.rma04,   # 客戶簡稱
        rma20       LIKE rma_file.rma20,   # 收貨日期
        rma21       LIKE rma_file.rma21,   # 點收日期
        rma18       LIKE rma_file.rma18,   # 備註
        rmc02       LIKE rmc_file.rmc02,   # 項次
        rmc04       LIKE rmc_file.rmc04,   # 料件編號
        rmc07       LIKE rmc_file.rmc07,   # S/N
        rmc25       LIKE rmc_file.rmc25,   # 機型
        rmc31       LIKE rmc_file.rmc31,   # 數量
        ima131      LIKE ima_file.ima131,  # 產品分類
        rmc05       LIKE rmc_file.rmc05,   # 單位
        rmc06       LIKE rmc_file.rmc06,   # 品名
        rmc061      LIKE rmc_file.rmc061,  # 規格
        rmc32       LIKE rmc_file.rmc32    # 說明
                    END RECORD,
    l_name          LIKE type_file.chr20                #External(Disk) file name  #No.FUN-690010 VARCHAR(20)
    DEFINE l_sql STRING                                                                                                             
    CALL cl_del_data(l_table)                                                                                                       
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                        
 
    IF cl_null(g_rma.rma01) THEN
       CALL cl_err('','arm-019',0) RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql=" SELECT rma01,rma03,rma04,rma20,rma21,rma18,rmc02,",
              "        rmc04,rmc07,rmc25,rmc31,ima131,rmc05,rmc06, ",
              "        rmc061,rmc32 ",
              " FROM rma_file,rmc_file LEFT JOIN ima_file ON rmc04=ima_file.ima01 ",
              " WHERE rma01=rmc01 ",
              " AND rmc01 ='",g_rma.rma01,"'",     #No:7724
              " ORDER BY rma01,rmc02 "
    PREPARE t150_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t150_co                         # SCROLL CURSOR
        CURSOR FOR t150_p1
 
    FOREACH t150_co INTO sr.*
        EXECUTE insert_prep USING sr.rma01,sr.rma03,sr.rma04,sr.rma20,                                                              
                                  sr.rma21,sr.rma18,sr.rmc02,sr.rmc04,                                                              
                                  sr.rmc07,sr.rmc25,sr.rmc31,sr.ima131,                                                             
                                  sr.rmc05,sr.rmc06,sr.rmc061,sr.rmc32                                                              
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
    END FOREACH
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,                                                                               
                 l_table CLIPPED,                                                                                                   
                " ORDER BY rma01,rmc02"                                                                                             
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'rma01,rma03,rma04,rma20,rma12,rma18,                                                                     
                           rmaconf,rmarecv,rmavoid')                                                                                
       RETURNING g_str                                                                                                              
    ELSE                                                                                                                            
       LET g_str = ''                                                                                                               
    END IF                                                                                                                          
    LET g_str = g_str                                                                                                               
    CALL cl_prt_cs3('armt150','armt150',l_sql,g_str)                                                                                
    CLOSE t150_co
    MESSAGE ""
END FUNCTION
 
FUNCTION t150_rmc02()
  SELECT rmb03,rmb05,rmb06,rmb11,rmb04 
    INTO g_rmc[l_ac].rmc04,g_rmc[l_ac].rmc06,g_rmc[l_ac].rmc061,
         g_rmc[l_ac].rmc31,g_rmc[l_ac].rmc05
    FROM rmb_file
   WHERE rmb01 = g_rma.rma01 
     AND rmb02 = g_rmc[l_ac].rmc02
  DISPLAY BY NAME g_rmc[l_ac].rmc04,g_rmc[l_ac].rmc06,g_rmc[l_ac].rmc061,
                  g_rmc[l_ac].rmc31,g_rmc[l_ac].rmc05
END FUNCTION
 
#單身
FUNCTION t150_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rmc07,rmc02,rmc04,rmc06,rmc061,
                               rmc31,ima131,rmc05,rmc25,rmc32", TRUE)
   END IF
   IF INFIELD(rmc04) THEN 
       CALL cl_set_comp_entry("rmc06,rmc25",TRUE)   
   END IF     
   IF INFIELD(rmc07) THEN 
       CALL cl_set_comp_entry("rmc31",TRUE)   
   END IF     
 
END FUNCTION

#CHI-C60018 str add-----
FUNCTION  t150_retno()
DEFINE l_rma01          LIKE rma_file.rma01
DEFINE l_rmb02          LIKE rmb_file.rmb02
         
      IF g_rma.rmarecv !='N' OR g_rma.rmavoid !='Y' THEN
         CALL cl_err('','arm-018',0)
         RETURN  
      END IF 
      IF g_rma.rma01 IS NULL THEN RETURN END IF
      IF  g_rma.rma12 IS NULL OR g_rma.rma12 = ' '   OR
          g_rma.rma20 IS NULL OR g_rma.rma20 = ' '   OR
          g_rma.rma21 IS NULL OR g_rma.rma21 = ' '   THEN
          DISPLAY BY NAME g_rma.rma12,g_rma.rma20,
                          g_rma.rma21
          CALL cl_err('',9033,1)
          RETURN
      END IF
      LET g_wc=''              
      OPEN WINDOW t150_wa WITH FORM "arm/42f/armt150a"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
      CALL cl_ui_init()
      CALL cl_ui_locale("armt150a")
      CALL cl_load_act_sys("armt150a")
      CALL cl_load_act_list("armt150a")
      CONSTRUCT BY NAME g_wc ON rmb02
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()


         ON ACTION exit
              LET INT_FLAG = 1
         BEFORE CONSTRUCT
           LET l_rma01=g_rma.rma01
           DISPLAY BY NAME g_rma.rma01

         AFTER CONSTRUCT
           IF INT_FLAG THEN
              EXIT CONSTRUCT
           END IF
           SELECT MAX(rmc02) INTO l_ac
             FROM rmc_file WHERE rmc01=g_rma.rma01
           IF l_ac IS NOT NULL THEN
              IF cl_confirm('arm-051')THEN
                 LET l_ac = 0
                 DELETE FROM rmc_file
                  WHERE rmc01 = g_rma.rma01
              ELSE
                #CONTINUE CONSTRUCT
              END IF
           ELSE
             LET l_ac = 0
           END IF

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rmb02)
               CALL cl_init_qry_var()
               LET g_qryparam.state= 'c'
               LET g_qryparam.form = "q_rma6"
               LET g_qryparam.arg1 = g_rma.rma01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rmb02
            END CASE

      END CONSTRUCT

      IF INT_FLAG THEN
         CLOSE WINDOW t150_wa
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         LET INT_FLAG = 0
         RETURN
      END IF
      IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
      LET g_sql=" SELECT rmb02 FROM rmb_file WHERE rmb01 ='",g_rma.rma01,"' AND ",g_wc
      PREPARE t150_rmb02_pre1 FROM g_sql
      DECLARE t150_rmb02_curs1 CURSOR FOR t150_rmb02_pre1
      FOREACH t150_rmb02_curs1 INTO g_rmb02
         LET l_ac = l_ac + 1
         LET g_rmc[l_ac].rmc02 = l_ac
         CALL t150_add_rmc1()
         CALL t150_add_rmc(l_ac)
         SELECT MAX(rmc02) INTO l_ac
           FROM rmc_file WHERE rmc01=g_rma.rma01
      END FOREACH
      CLOSE WINDOW t150_wa
END FUNCTION

FUNCTION t150_add_rmc1()
   DEFINE g_rmc17  LIKE rmc_file.rmc17
   DEFINE g_rmc18  LIKE rmc_file.rmc18

      SELECT rmb03,rmb05,rmb06,rmb11,rmb04
        INTO g_rmc[l_ac].rmc04,g_rmc[l_ac].rmc06,g_rmc[l_ac].rmc061,
             g_rmc[l_ac].rmc31,g_rmc[l_ac].rmc05
        FROM rmb_file
       WHERE rmb01 = g_rma.rma01
         AND rmb02 = g_rmb02

      SELECT ima148 INTO g_rmc18 FROM ima_file
       WHERE ima01=g_rmc[l_ac].rmc04
      IF cl_null(g_rmc18)  THEN
          LET g_rmc18=0
      END IF
      LET g_rmc17=g_rma.rma20   # 原出貨日期
      IF (g_rmc17+g_rmc18)>g_rma.rma02 THEN
          LET g_rmc16='Y'   #保固
          LET g_rmc09='N'   #不收費
      ELSE
          LET g_rmc16='N'   #不保固
          LET g_rmc09='Y'   #收費
       END IF


      INSERT INTO rmc_file(rmc01,rmc02,rmc04,rmc07,
          rmc25,rmc06,rmc05,rmc31,
          rmc061,rmc32,rmc14,rmc21,
          rmc311,rmc312,rmc313,
          rmc10,rmc11,rmc12,rmc13,
          rmc19,rmc28,rmc09,rmc16,rmc17,rmc18,
          rmcplant,rmclegal)
      VALUES(g_rma.rma01,g_rmc[l_ac].rmc02,
          g_rmc[l_ac].rmc04,g_rmc[l_ac].rmc07,
          g_rmc[l_ac].rmc25,g_rmc[l_ac].rmc06,
          g_rmc[l_ac].rmc05,1,
          g_rmc[l_ac].rmc061,g_rmc[l_ac].rmc32,
          '0','0',0,0,0,0,0,0,0,0,0,g_rmc09,g_rmc16,g_rmc17,g_rmc18,
          g_plant,g_legal)
END FUNCTION
#CHI-C60018 end add----- 
FUNCTION t150_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF INFIELD(rmc04) OR (NOT g_before_input_done) THEN
       IF g_rmc[l_ac].rmc04 != 'MISC' THEN
           CALL cl_set_comp_entry("rmc06,rmc25",FALSE)
       END IF
   END IF
   IF INFIELD(rmc07) OR (NOT g_before_input_done) THEN
       IF g_rmc[l_ac].rmc07 IS NOT NULL THEN   #MOD-950061
           CALL cl_set_comp_entry("rmc31",FALSE)
       END IF
   END IF
 
END FUNCTION
 
FUNCTION t150_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("rma01",FALSE)
   END IF
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
