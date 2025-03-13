# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axrt200.4gl
# Descriptions...: 銷售信用狀維護作業
# Date & Author..: 96/01/16 By Danny
#                96-09-23 By Charis 1.立即確認 2.編碼方式 3.單身輸入完畢,回至
#                Menu Bar 再按detail時,無法按向上鍵 
# Modify.........: No:7837 03/08/19 By Wiky 呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-4A0252 04/10/19 By Smapmin 增加收狀單號開窗功能
# Modify.........: No.FUN-4B0017 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4B0056 04/11/25 By ching add 匯率開窗 call s_rate
# Modify ........: No.FUN-4C0013 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-4C0049 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0078 04/12/16 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大 
# Modify.........: No.FUN-560089 05/06/19 By Smapmin 單位數量改抓計價單位計價數量
# Modify.........: No.MOD-570352 05/07/28 By Smapmin 收狀單別沒有控制做輸入值檢查
# Modify.........: No.FUN-570273 05/07/29 By Dido  單身未輸入確認無法跳出視窗
# Modify.........: No.MOD-590523 05/09/28 By Smapmin 輸入客戶代號後帶出相關資料
# Modify.........: No.MOD-5B0009 05/11/08 By Smapmin 幣別是本國幣別時,匯率不可異動.
#                                                    已結案之單據,不可做進出口or會計的確認or取消確認
# Modify.........: No.FUN-5B0116 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: NO.TQC-630066 06/03/07 By Kevin 流程訊息通知功能修改
# Modify.........: No.TQC-630015 06/03/28 By Smapmin ola271取40位後再insert到ole081
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: NO.TQC-660088 06/06/21 By Claire 流程訊息通知功能修改
# Modify.........: No.TQC-610059 06/06/26 By Smapmin 修改列印參數傳遞
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670060 06/07/18 By Carrier 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-670088 06/08/04 By Sarah 單頭增加部門、成本中心欄位,單身增加成本中心欄位
# Modify.........: No.FUN-670047 06/08/15 By day 多帳套修改
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6B0042 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0051 06/12/13 By xufeng  控管開狀銀行、通知銀行、押匯銀行的輸入；單價為負時報錯。        
# Modify.........: No.FUN-710050 07/01/29 By yjkhero 錯誤訊息匯整
# Modify.........: No.MOD-720083 07/03/01 By Smapmin 取消olb09,olb10
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740009 07/04/03 By Ray 會計科目加帳套 
# Modify.........: No.TQC-750041 07/05/21 By mike 畫面欄位添加
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770025 07/07/04 By Rayven 收狀單別為無效時,錄入此單別無控管
# Modify.........: No.TQC-770046 07/07/09 By chenl  已做押匯不可刪除及取消審核。
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-850038 08/05/09 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-860075 08/06/10 By Carrier 直接拋轉總帳時，aba07(來源單號)沒有取得值
# Modify.........: No.FUN-8A0086 08/10/21 By dongbg 修正FUN-710050錯誤
# Modify.........: No.TQC-970036 09/07/03 By xiaofeizhu 將報錯信息'axr-035'改為'aap-265'
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-810036 09/08/19 By xiaofeizhu 拋轉憑証時，傳入參數內的user應為資料所有者
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30163 10/03/31 By destiny construct 增加orig,oriu 两个字段
# Modify.........: No.TQC-A40053 10/04/09 by xiaofeizhu ¡§¤º/¥~¾P¡¨Ã«¬ola113¥i¥H©I3­q³檺¡§¤º¥~¾P¡¨Ã§O
# Modify.........: No.MOD-A50157 10/05/25 by sabrina 單價及金額未依幣別做取位
# Modify.........: No.FUN-A50102 10/06/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60056 10/06/29 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No.MOD-A90032 10/09/07 by Dido 作廢時應刪除分錄底稿 
# Modify.........: No.TQC-AB0366 11/01/13 By vealxu 單別維護作業（axri010）維護了總帳單別也可以拋轉總賬
# Modify.........: No.FUN-B40056 11/05/12 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/06/07 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50064 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修正
# Modify.........: No.MOD-B80067 11/08/05 By johung 單身輸入排除合約訂單
# Modify.........: No.TQC-B80179 11/08/24 By guoch 取消审核时，审核人未清除
# Modify.........: No.TQC-B90172 11/09/27 By Carrier 取消财务模块中制造单号FORMAT的功能
# Modify.........: No.FUN-910088 11/12/29 By chenjing 增加數量欄位小數取位

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30085 12/06/29 By lixiang 串CR報表改GR報表
# Modify.........: No:FUN-C50136 12/07/11 By xujing  增加信用管控邏輯處理
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No.FUN-D20035 13/02/19 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D20058 13/03/28 By chenjing 取消確認賦值確認異動人員
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: NO:FUN-E80012 18/11/27 By lixwz 修改付款日期之後,tic現金流量明細重複

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_ola   RECORD LIKE ola_file.*,
    b_olb   RECORD LIKE olb_file.*,
    g_ola_t RECORD LIKE ola_file.*,
    g_ola_o RECORD LIKE ola_file.*,
    g_olb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    olb02     LIKE olb_file.olb02,      #項次
                    olb04     LIKE olb_file.olb04,      #訂單單號
                    olb05     LIKE olb_file.olb05,      #訂單項次
                    olb11     LIKE olb_file.olb11,      #料件編號 
                    ima02     LIKE ima_file.ima02,      #品名規格
                    olb03     LIKE olb_file.olb03,      #單位
                    olb06     LIKE olb_file.olb06,      #單價
                    olb07     LIKE olb_file.olb07,      #數量
                    olb08     LIKE olb_file.olb08,      #金額
                    #olb09    LIKE olb_file.olb09,      #押匯數量   #MOD-720083
                    #olb10    LIKE olb_file.olb10,      #押匯金額   #MOD-720083
                    olb930    LIKE olb_file.olb930,     #成本中心       #FUN-670088 add
                    gem02     LIKE gem_file.gem02,      #成本中心名稱   #FUN-670088 add
                    #FUN-850038 --start---
                    olbud01   LIKE olb_file.olbud01,
                    olbud02   LIKE olb_file.olbud02,
                    olbud03   LIKE olb_file.olbud03,
                    olbud04   LIKE olb_file.olbud04,
                    olbud05   LIKE olb_file.olbud05,
                    olbud06   LIKE olb_file.olbud06,
                    olbud07   LIKE olb_file.olbud07,
                    olbud08   LIKE olb_file.olbud08,
                    olbud09   LIKE olb_file.olbud09,
                    olbud10   LIKE olb_file.olbud10,
                    olbud11   LIKE olb_file.olbud11,
                    olbud12   LIKE olb_file.olbud12,
                    olbud13   LIKE olb_file.olbud13,
                    olbud14   LIKE olb_file.olbud14,
                    olbud15   LIKE olb_file.olbud15
                    #FUN-850038 --end--
                    END RECORD,
    g_olb_t         RECORD
                    olb02     LIKE olb_file.olb02,      #項次
                    olb04     LIKE olb_file.olb04,      #訂單單號
                    olb05     LIKE olb_file.olb05,      #訂單項次
                    olb11     LIKE olb_file.olb11,      #料件編號 
                    ima02     LIKE ima_file.ima02,      #品名規格
                    olb03     LIKE olb_file.olb03,      #單位
                    olb06     LIKE olb_file.olb06,      #單價
                    olb07     LIKE olb_file.olb07,      #數量
                    olb08     LIKE olb_file.olb08,      #金額
                    #olb09    LIKE olb_file.olb09,      #押匯數量   #MOD-720083
                    #olb10    LIKE olb_file.olb10,      #押匯金額   #MOD-720083
                    olb930    LIKE olb_file.olb930,     #成本中心       #FUN-670088 add
                    gem02     LIKE gem_file.gem02,      #成本中心名稱   #FUN-670088 add
                    #FUN-850038 --start---
                    olbud01   LIKE olb_file.olbud01,
                    olbud02   LIKE olb_file.olbud02,
                    olbud03   LIKE olb_file.olbud03,
                    olbud04   LIKE olb_file.olbud04,
                    olbud05   LIKE olb_file.olbud05,
                    olbud06   LIKE olb_file.olbud06,
                    olbud07   LIKE olb_file.olbud07,
                    olbud08   LIKE olb_file.olbud08,
                    olbud09   LIKE olb_file.olbud09,
                    olbud10   LIKE olb_file.olbud10,
                    olbud11   LIKE olb_file.olbud11,
                    olbud12   LIKE olb_file.olbud12,
                    olbud13   LIKE olb_file.olbud13,
                    olbud14   LIKE olb_file.olbud14,
                    olbud15   LIKE olb_file.olbud15
                    #FUN-850038 --end--
                    END RECORD,
    g_wc,g_wc2      STRING,  #No.FUN-580092 HCN
    g_sql           STRING,  #No.FUN-580092 HCN
    g_t1            LIKE ooy_file.ooyslip,                #No.FUN-680123 VARCHAR(5),               #No.FUN-550071
    g_buf           LIKE gem_file.gem02,                #No.FUN-680123 VARCHAR(40),
    g_rec_b         LIKE type_file.num5,                #No.FUN-680123 SMALLINT,              #單身筆數
    g_tot           LIKE olb_file.olb08,
    g_rate,m_rate   LIKE type_file.num20_6,             #No.FUN-680123 DEC(20,10),  #FUN-4C0013              #No.7952
    l_ac            LIKE type_file.num5,                #No.FUN-680123 SMALLINT,              #目前處理的ARRAY CNT
    l_sl            LIKE type_file.num5                #No.FUN-680123 SMALLINT               #目前處理的SCREEN LINE
 
#主程式開始
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_before_input_done LIKE type_file.num5         #No.FUN-680123 SMALLINT
DEFINE  g_chr               LIKE type_file.chr1         #No.FUN-680123 VARCHAR(1)
DEFINE  g_cnt               LIKE type_file.num10        #No.FUN-680123 INTEGER   
DEFINE  g_i                 LIKE type_file.num5         #No.FUN-680123 SMALLINT   #count/index for any purpose
DEFINE  g_msg               LIKE type_file.chr1000      #No.FUN-680123 VARCHAR(72)
DEFINE  g_str               STRING                      #No.FUN-670060
DEFINE  g_wc_gl             STRING                      #No.FUN-670060
DEFINE  g_dbs_gl 	    LIKE type_file.chr21        #No.FUN-680123 VARCHAR(21)   #No.FUN-670060
DEFINE  g_row_count         LIKE type_file.num10        #No.FUN-680123 INTEGER
DEFINE  g_curs_index        LIKE type_file.num10        #No.FUN-680123 INTEGER
DEFINE  g_jump              LIKE type_file.num10        #No.FUN-680123 INTEGER
DEFINE  mi_no_ask           LIKE type_file.num5         #No.FUN-680123 SMALLINT
DEFINE  g_argv1             LIKE ola_file.ola01         #No.TQC-630066
DEFINE  g_argv2             STRING                      #No.TQC-630066
 
MAIN
#       l_time    LIKE type_file.chr8               #No.FUN-6A0095
DEFINE p_row,p_col   LIKE type_file.num5       #No.FUN-680123 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_argv1=ARG_VAL(1)           #No.TQC-630066
    LET g_argv2=ARG_VAL(2)           #No.TQC-630066
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
         RETURNING g_time    #No.FUN-6A0095
 
    LET g_forupd_sql = " SELECT * FROM ola_file  WHERE ola01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t200_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 4
    OPEN WINDOW t200_w AT p_row,p_col WITH FORM "axr/42f/axrt200"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    #-----TQC-630066 --start--
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t200_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t200_a()
            END IF
         OTHERWISE             #TQC-660088 
               CALL t200_q()   #TQC-660088
      END CASE
    END IF
    #-----TQC-630066 --end--
 
    CALL cl_set_comp_visible("ola930,gem02b,olb930,gem02",g_aaz.aaz90='Y')   #FUN-670088 add
 
    CALL t200_menu()
    CLOSE WINDOW t200_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
         RETURNING g_time    #No.FUN-6A0095
END MAIN
 
FUNCTION t200_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                          #清除畫面
    CALL g_olb.clear()
 
    IF NOT cl_null(g_argv1) THEN   #No.TQC-630066
        LET g_wc = " ola01 = '",g_argv1,"'"
        LET g_wc2= " 1=1 "
    ELSE
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_ola.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON           # 螢幕上取單頭條件
          ola11,ola01,ola011,ola02,ola05 ,
          ola42,ola930,                           #FUN-670088 add
          ola28,olaconf,ola40,ola33,ola39 ,
          ola12,olauser,olagrup,
          olamodu,oladate,                        #No.TQC-750041
          olaorig,olaoriu,                        #No.TQC-A30163
          ola06,ola07,ola15,ola09,ola10,
          ola04,ola21,ola22,ola23,ola31,ola32,
          ola24,ola25,ola14,ola37,ola38 ,
          ola29,ola30,ola16,ola17,ola18,
          ola19,ola20,ola271,
          #FUN-850038   ---start---
          olaud01,olaud02,olaud03,olaud04,olaud05,
          olaud06,olaud07,olaud08,olaud09,olaud10,
          olaud11,olaud12,olaud13,olaud14,olaud15
          #FUN-850038    ----end----
          #No.FUN-580031 --start--     HCN
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
          #No.FUN-580031 --end--       HCN
 
          ON ACTION controlp       #ok
             CASE
                WHEN INFIELD(ola01)  #hot key  #MOD-4A0252
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ola"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ola01
#                  LET g_t1=g_ola.ola01[1,3]
#                  CALL q_ooy( FALSE, TRUE, g_t1,'40',g_sys) RETURNING g_t1
#                  CALL q_ooy( FALSE, TRUE, 0,0,g_t1,'40',g_sys) RETURNING g_t1
#                  DISPLAY BY NAME g_ola.ola01
                  NEXT FIELD ola01
                WHEN INFIELD(ola05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_occ"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ola05
                  NEXT FIELD ola05
                WHEN INFIELD(ola06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ola06
                  NEXT FIELD ola06
                WHEN INFIELD(ola21)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ola21
                  NEXT FIELD ola21
                WHEN INFIELD(ola22)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ola22
                  NEXT FIELD ola22
                WHEN INFIELD(ola23)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ola23
                  NEXT FIELD ola23
                WHEN INFIELD(ola15)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oag"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ola15
                  NEXT FIELD ola15
                #-- NO:0132 modify in 99/05/12 ---#
                WHEN INFIELD(ola32)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ool"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ola32
                  NEXT FIELD ola32
               #start FUN-670088 add
                WHEN INFIELD(ola42)   #部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ola42
                  NEXT FIELD ola42
                WHEN INFIELD(ola930)   #成本中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ola930
                  NEXT FIELD ola930
               #end FUN-670088 add
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('olauser', 'olagrup') #FUN-980030
      IF INT_FLAG THEN RETURN END IF
 
      CONSTRUCT g_wc2 ON olb02,olb04,olb05,olb11,olb03,olb06,olb07,
                         #olb08,olb09,olb10,olb930   #FUN-670088 add olb930   #MOD-720083
                         olb08,olb930   #FUN-670088 add olb930   #MOD-720083
                         #No.FUN-850038 --start--
                         ,olbud01,olbud02,olbud03,olbud04,olbud05
                         ,olbud06,olbud07,olbud08,olbud09,olbud10
                         ,olbud11,olbud12,olbud13,olbud14,olbud15
                         #No.FUN-850038 ---end---
                    FROM s_olb[1].olb02, s_olb[1].olb04,s_olb[1].olb05,
                         s_olb[1].olb11, s_olb[1].olb03,s_olb[1].olb06,
                         #s_olb[1].olb07, s_olb[1].olb08,s_olb[1].olb09,   #MOD-720083
                         #s_olb[1].olb10, s_olb[1].olb930   #FUN-670088 add s_olb[1].olb930   #MOD-720083
                         s_olb[1].olb07, s_olb[1].olb08,s_olb[1].olb930   #MOD-720083
                         #No.FUN-850038 --start--
                         ,s_olb[1].olbud01,s_olb[1].olbud02,s_olb[1].olbud03
                         ,s_olb[1].olbud04,s_olb[1].olbud05,s_olb[1].olbud06
                         ,s_olb[1].olbud07,s_olb[1].olbud08,s_olb[1].olbud09
                         ,s_olb[1].olbud10,s_olb[1].olbud11,s_olb[1].olbud12
                         ,s_olb[1].olbud13,s_olb[1].olbud14,s_olb[1].olbud15
                         #No.FUN-850038 ---end---
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 --end--       HCN
 
         ON ACTION controlp
             CASE
               WHEN INFIELD(olb04)
                 CALL q_oea(TRUE,TRUE,g_olb[1].olb04,g_ola.ola05,'3') 
                      RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO olb04
                 NEXT FIELD olb04
              #start FUN-670088 add
               WHEN INFIELD(olb930)   #成本中心
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_gem4"
                 LET g_qryparam.state = "c"   #多選
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO olb930
                 NEXT FIELD olb930
              #end FUN-670088 add
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
    END IF     #No.TQC-630066
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    IF g_wc2 = " 1=1" THEN		# 若單身未輸入條件
       LET g_sql = "SELECT ola01 FROM ola_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE ola_file.ola01 ",
                   "  FROM ola_file, olb_file",
                   " WHERE ola01 = olb01",
                   "   AND ", g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t200_prepare FROM g_sql
    DECLARE t200_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t200_prepare
 
    IF g_wc2 = " 1=1" THEN		# 若單身未輸入條件
       LET g_sql = "SELECT COUNT(*) FROM ola_file WHERE ", g_wc CLIPPED
    ELSE					# 若單身有輸入條件
       LET g_sql ="SELECT COUNT(DISTINCT ola01) FROM ola_file,olb_file ",
                  "WHERE ola01=olb01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
 
    PREPARE t200_precount FROM g_sql
    DECLARE t200_count CURSOR FOR t200_precount
END FUNCTION
 
FUNCTION t200_menu()
   DEFINE   l_cmd  LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(300)
 
 
   WHILE TRUE
      CALL t200_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL t200_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t200_q()
            END IF 
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t200_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL t200_u()
            END IF 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t200_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0017
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_olb),'','')
             END IF
         #--
 
         WHEN "void" 
            IF cl_chk_act_auth() THEN
               #CALL t200_x() #FUN-D20035 mark
               CALL t200_x(1) #FUN-D20035 end 
            END IF
       #FUN-D20035 add str
         WHEN "undo_void" 
            IF cl_chk_act_auth() THEN
               CALL t200_x(2)
            END IF
       #FUN-D20035 add end     
       #  WHEN "other_data"  
       #     IF cl_chk_act_auth() THEN
       #        CALL t200_d()
       #     END IF
         WHEN "amend_l_c"  
            IF cl_chk_act_auth() AND g_ola.olaconf != 'X'THEN
               LET l_cmd='axrt201 ',g_ola.ola01
               #CALL cl_cmdrun(l_cmd)      #FUN-660216 remark
               CALL cl_cmdrun_wait(l_cmd)  #FUN-660216 add
            END IF
         WHEN "gen_entry" 
            IF cl_chk_act_auth() THEN 
               CALL t200_v()
               CALL t200_npp02()  #No.+085 010426 by plum
            END IF
         WHEN "entry_sheet"
            IF cl_chk_act_auth() THEN
               CALL t200_vc()
            END IF
         #No.FUN-670047--begin
         WHEN "entry_sheet2"
            IF cl_chk_act_auth() THEN
               CALL t200_vc_1()
            END IF
         #No.FUN-670047--end  
         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_ola.olaconf = 'Y' THEN
                  #CALL cl_cmdrun('axrp590')      #FUN-660216 remark
                  #CALL cl_cmdrun_wait('axrp590')  #FUN-660216 add  #No.FUN-670060
                  CALL t200_carry_voucher()       #No.FUN-670060
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF
            END IF
         #No.FUN-670060  --Begin
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_ola.olaconf = 'Y' THEN
                  CALL t200_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF
            END IF
         #No.FUN-670060  --End  
         WHEN "close_the_case" 
            IF cl_chk_act_auth() THEN
               CALL t200_1()
            END IF
         WHEN "undo_close" 
            IF cl_chk_act_auth() THEN
               CALL t200_2()
            END IF
         WHEN "invoice_qry"
            IF cl_chk_act_auth() THEN
               CALL t200_3()
            END IF
         WHEN "avail_balance"
            IF cl_chk_act_auth() THEN 
               CALL s_t200_amt(g_ola.ola04,'y') 
            END IF
         WHEN "fin_imp_exp_confirm"
            IF cl_chk_act_auth() THEN
               CALL t200_5()
            END IF
         WHEN "undo_fin_imp_exp_confirm" 
            IF cl_chk_act_auth() THEN
               CALL t200_6()
            END IF
         WHEN "accounting_confirm"
            IF cl_chk_act_auth() THEN
               CALL t200_y()
            END IF
         WHEN "undo_tr_confirm"
            IF cl_chk_act_auth() THEN
               CALL t200_z()
            END IF
         WHEN "l_c_ckg_list" 
            IF cl_chk_act_auth() THEN
               #-----TQC-610059---------
               #LET g_msg = "axrr200 '",g_ola.ola01,"'"
              #LET g_msg = "axrr200 '' '' '",g_lang,"' 'Y' '' '' ", #FUN-C30085 mark
               LET g_msg = "axrg200 '' '' '",g_lang,"' 'Y' '' '' ", #FUN-C30085 add
                           "'ola01 =\"",g_ola.ola01,"\"'"
               #-----END TQC-610059-----
               CALL cl_cmdrun(g_msg)
            END IF
         #No.FUN-6B0042-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_ola.ola01 IS NOT NULL THEN
                 LET g_doc.column1 = "ola01"
                 LET g_doc.value1 = g_ola.ola01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0042-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t200_a()
    DEFINE  li_result LIKE type_file.num5     #No.FUN-680123 SMALLINT   #No.FUN-550071
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_olb.clear()
    INITIALIZE g_ola.* TO NULL
    LET g_ola_o.* = g_ola.* 
    LET g_ola_t.* = g_ola.* 
    CALL cl_opmsg('a')
    WHILE TRUE
        #No.TQC-630066 --start--
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_ola.ola01 = g_argv1
        END IF     
        #No.TQC-630066 --end--
        LET g_ola.ola011 = 0
        LET g_ola.ola02 = g_today  
        LET g_ola.ola14 = g_today  
        LET g_ola.ola11 = '2'
        LET g_ola.ola16 = 'Y'
        LET g_ola.ola17 = 'N'
        LET g_ola.ola18 = 'Y'
        LET g_ola.ola24 = g_today      
        LET g_ola.ola25 = g_today    
        LET g_ola.ola09 = 0 
        LET g_ola.ola10 = 0
        LET g_ola.ola29 = 'N'
        LET g_ola.ola30 = 'N'
        LET g_ola.ola40 = 'N'  
        LET g_ola.ola37 = 'N'   
        LET g_ola.ola38 = ''   
        LET g_ola.ola39 = ''   
        LET g_ola.ola42 = g_grup   #FUN-670088 add
        LET g_ola.ola930=s_costcenter(g_ola.ola42)  #FUN-670088 add
        LET g_ola.olaconf = 'N'
        LET g_ola.olauser = g_user
        LET g_ola.olaoriu = g_user #FUN-980030
        LET g_ola.olaorig = g_grup #FUN-980030
        LET g_ola.oladate = g_today
        LET g_ola.olagrup = g_grup
        LET g_ola.olalegal = g_legal #FUN-980011 add
        CALL t200_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0) 
           INITIALIZE g_ola.* TO NULL
           ROLLBACK WORK EXIT WHILE
        END IF
        IF g_ola.ola01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK  #No:7837
#No.FUN-550071 --start--
        IF g_ooy.ooyauno='Y' THEN
            CALL  s_auto_assign_no("axr",g_ola.ola01,g_ola.ola02,"40","oma_file","oma01",
                  "","","")
                  RETURNING li_result,g_ola.ola01
            IF (NOT li_result) THEN
            LET g_success = 'N'
             CONTINUE WHILE
            END IF
	  DISPLAY BY NAME g_ola.ola01
#	  CALL s_axrauno(g_ola.ola01,g_ola.ola02,'40') RETURNING g_i,g_ola.ola01
#          IF g_i THEN CONTINUE WHILE END IF	#有問題
#	  DISPLAY BY NAME g_ola.ola01
#      END IF
       END IF
#No.FUN-550071--end
        LET g_ola.ola41 = g_plant    #FUN-A60056
        INSERT INTO ola_file VALUES (g_ola.*)
       #No.+041 010330 by plum
       #IF STATUS THEN CALL cl_err(g_ola.ola01,STATUS,1) CONTINUE WHILE END IF
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("ins","ola_file",g_ola.ola01,"",SQLCA.SQLCODE,"","",1)  #No.FUN-660116       #FUN-B80072   ADD
           ROLLBACK WORK  #No:7837
#          CALL cl_err(g_ola.ola01,SQLCA.SQLCODE,1)    #No.FUN-660116
          # CALL cl_err3("ins","ola_file",g_ola.ola01,"",SQLCA.SQLCODE,"","",1)  #No.FUN-660116      #FUN-B80072   MARK
           CONTINUE WHILE 
        ELSE
           COMMIT WORK   #No:7837
           CALL cl_flow_notify(g_ola.ola01,'I')
        END IF
       #No.+041 ..end
        SELECT ola01 INTO g_ola.ola01 FROM ola_file WHERE ola01 = g_ola.ola01
        LET g_ola_t.* = g_ola.*
        CALL g_olb.clear()
        LET g_rec_b = 0
        CALL t200_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t200_u()
DEFINE l_tic01     LIKE tic_file.tic01   #FUN-E80012 add
DEFINE l_tic02     LIKE tic_file.tic02   #FUN-E80012 add
    IF s_shut(0) THEN RETURN END IF
    IF g_ola.ola01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ola.* FROM ola_file WHERE ola01 = g_ola.ola01
    IF g_ola.ola40 = 'Y' THEN CALL cl_err('','axr-248',0) RETURN END IF
    IF g_ola.ola37 = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF
    IF g_ola.olaconf = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF
    IF g_ola.olaconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ola_o.* = g_ola.*
    BEGIN WORK
 
    OPEN t200_cl USING g_ola.ola01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_ola.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ola.ola01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t200_cl ROLLBACK WORK RETURN
    END IF
    CALL t200_show()
    WHILE TRUE
        LET g_ola.olamodu = g_user
        LET g_ola.oladate = g_today
        CALL t200_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ola.*=g_ola_t.*
            CALL t200_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE ola_file SET * = g_ola.* WHERE ola01 = g_ola_t.ola01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ola.ola01,SQLCA.sqlcode,0)   #No.FUN-660116
            CALL cl_err3("upd","ola_file",g_ola_o.ola01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
            CONTINUE WHILE
        END IF
        IF g_ola.ola01 != g_ola_t.ola01 THEN            # 更改單號
            UPDATE olb_file SET olb01 = g_ola.ola01
                WHERE olb01 = g_ola_t.ola01
            IF SQLCA.sqlcode THEN
#               CALL cl_err('update olb01',SQLCA.sqlcode,0)   #No.FUN-660116
                CALL cl_err3("upd","olb_file",g_ola_t.ola01,"",SQLCA.sqlcode,"","update olb01",1)  #No.FUN-660116
                CONTINUE WHILE
            END IF
        END IF
       #No.+085 010426 by plum
        IF g_ola.ola02 != g_ola_t.ola02 THEN            # 更改單號
           UPDATE npp_file SET npp02=g_ola.ola02
            WHERE npp01 = g_ola.ola01 AND npp00 = 41
              AND nppsys = 'AR'  AND npp011 = g_ola.ola011 #異動序號
           IF STATUS THEN 
              CALL cl_err('upd npp02:',STATUS,1)   #No.FUN-660116
              CALL cl_err3("upd","olb_file",g_ola.ola01,g_ola.ola011,STATUS,"","upd npp02:",1)  #No.FUN-660116
           END IF
           #FUN-E80012---add---str---
           SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
           IF g_nmz.nmz70 = '3' THEN
              LET l_tic01=YEAR(g_ola.ola02)
              LET l_tic02=MONTH(g_ola.ola02)
              UPDATE tic_file SET tic01=l_tic01,
                                  tic02=l_tic02
              WHERE tic04=g_ola.ola01
              IF STATUS THEN
                 CALL cl_err3("upd","tic_file",g_ola.ola01,g_ola.ola011,STATUS,"","upd tic01 tic02",1)
              END IF
           END IF
           #FUN-E80012---add---end---
        END IF
       #No.+085..end
        EXIT WHILE
    END WHILE
    CLOSE t200_cl
    COMMIT WORK
    CALL cl_flow_notify(g_ola.ola01,'U')
# 新增自動確認功能 Modify by Charis 96-09-23
#    LET g_t1=g_ola.ola01[1,3]
    CALL s_get_doc_no(g_ola.ola01) RETURNING g_t1     #No.FUN-550071
    SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
    IF STATUS THEN 
#      CALL cl_err('sel ooy_file',STATUS,0) #No.FUN-660116
       CALL cl_err3("sel","ooy_file",g_t1,"",STATUS,"","sel ooy_file",1)  #No.FUN-660116
       RETURN 
    END IF
    IF (g_ola.olaconf='Y' OR g_ooy.ooyconf='N') #單據已確認或單據不需自動確認
       THEN RETURN 
    ELSE CALL t200_5() 
         IF g_ola.ola37='Y' THEN   ##進出口已確認,會計才可確認
            CALL t200_y() 
         END IF
    END IF
# ----------------- :-)
END FUNCTION
 
#No.+085 010426 by plum
FUNCTION t200_npp02()
DEFINE l_tic01     LIKE tic_file.tic01   #FUN-E80012 add
DEFINE l_tic02     LIKE tic_file.tic02   #FUN-E80012 add 
 
  IF g_ola.ola28 IS NULL OR g_ola.ola28=' ' THEN
     UPDATE npp_file SET npp02=g_ola.ola02
      WHERE npp01 = g_ola.ola01 AND npp00 = 41
        AND nppsys = 'AR'  AND npp011 = g_ola.ola011 #異動序號
     IF STATUS THEN 
#       CALL cl_err('upd npp02:',STATUS,1)  #No.FUN-660116
        CALL cl_err3("upd","npp_file",g_ola.ola01,g_ola.ola011,STATUS,"","upd npp02:",1)  #No.FUN-660116
     END IF
     #FUN-E80012---add---str---
     SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
     IF g_nmz.nmz70 = '3' THEN
        LET l_tic01=YEAR(g_ola.ola02)
        LET l_tic02=MONTH(g_ola.ola02)
        UPDATE tic_file SET tic01=l_tic01,
                            tic02=l_tic02
        WHERE tic04=g_ola.ola01
        IF STATUS THEN
           CALL cl_err3("upd","tic_file",g_ola.ola01,g_ola.ola011,STATUS,"","upd tic01 tic02",1)
        END IF
     END IF
     #FUN-E80012---add---end---
  END IF
 
END FUNCTION
#No.+085..end
 
#處理INPUT
FUNCTION t200_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)                #a:輸入 u:更改
  DEFINE l_flag          LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)               #判斷必要欄位是否有輸入
  DEFINE l_n1            LIKE type_file.num5,      #No.FUN-680123 SMALLINT,
         l_amt           LIKE ola_file.ola09 
  DEFINE l_occ           RECORD LIKE occ_file.* 
  DEFINE l_ool           RECORD LIKE ool_file.* 
  DEFINE li_result       LIKE type_file.num5       #No.FUN-680123 SMALLINT         #No.FUN-550071
  DEFINE l_n             LIKE type_file.num5       #No.TQC-6B0051
  DEFINE l_nma21,l_nma22,l_nma23         LIKE nma_file.nma10 #No.TQC-6B0051 
  DEFINE l_ooyacti       LIKE ooy_file.ooyacti     #No.TQC-770025
  DEFINE t_azi03         LIKE azi_file.azi03       #MOD-A50157 add
  DEFINE t_azi04         LIKE azi_file.azi04       #MOD-A50157 add
 
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
      INPUT BY NAME g_ola.olaoriu,g_ola.olaorig,
          g_ola.ola11,g_ola.ola01,g_ola.ola011,g_ola.ola02,g_ola.ola05 ,
          g_ola.ola42,g_ola.ola930,   #FUN-670088 add
          g_ola.ola28,g_ola.olaconf,g_ola.ola40,g_ola.ola33,g_ola.ola39 ,
          g_ola.ola12,g_ola.olauser,g_ola.olagrup, 
          g_ola.ola06,g_ola.ola07,g_ola.ola15,g_ola.ola09,g_ola.ola10,
          g_ola.ola04,g_ola.ola21,g_ola.ola22 ,g_ola.ola23,g_ola.ola31, 
          g_ola.ola32,
          g_ola.ola24,g_ola.ola25 ,g_ola.ola14,g_ola.ola37,g_ola.ola38 ,
          g_ola.ola29,g_ola.ola30, g_ola.ola16,g_ola.ola17,g_ola.ola18,
          g_ola.ola19,g_ola.ola20,g_ola.ola271,
          #FUN-850038     ---start---
          g_ola.olaud01,g_ola.olaud02,g_ola.olaud03,g_ola.olaud04,
          g_ola.olaud05,g_ola.olaud06,g_ola.olaud07,g_ola.olaud08,
          g_ola.olaud09,g_ola.olaud10,g_ola.olaud11,g_ola.olaud12,
          g_ola.olaud13,g_ola.olaud14,g_ola.olaud15 
          #FUN-850038     ----end----
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t200_set_entry(p_cmd)
           CALL t200_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
        #No.FUN-550071 --start--
           CALL cl_set_docno_format("ola01")
        #No.FUN-550071 ---end---
 
 
        BEFORE FIELD ola01 
          IF p_cmd = 'u' AND g_chkey = 'N' THEN
             IF g_ola.ola40 = 'Y' THEN CALL cl_err('','axr-248',0) RETURN END IF
             NEXT FIELD ola02
          END IF
 
        AFTER FIELD ola01  
          IF NOT cl_null(g_ola.ola01) THEN
#No.FUN-550071 --start--
             LET g_t1=g_ola.ola01[1,g_doc_len]
             #No.TQC-770025 --start--
             LET l_ooyacti = NULL
             SELECT ooyacti INTO l_ooyacti FROM ooy_file
              WHERE ooyslip = g_t1
             IF l_ooyacti <> 'Y' THEN
                CALL cl_err(g_t1,'axr-956',1)
                NEXT FIELD ola01
             END IF
             #No.TQC-770025 --end--
              #LET g_buf=NULL   #MOD-570352
              #SELECT ooytype INTO g_buf FROM ooy_file WHERE ooyslip=g_t1   #MOD-570352
              #CALL  s_check_no("axr",g_ola.ola01,g_ola_t.ola01,g_buf,"ola_file","ola01","")    #MOD-570352
              CALL  s_check_no("axr",g_ola.ola01,g_ola_t.ola01,"40","ola_file","ola01","")   #MOD-570352
                   RETURNING li_result,g_ola.ola01
             DISPLAY BY NAME g_ola.ola01
             IF (NOT li_result) THEN
                NEXT FIELD ola01
             END IF
 
#             LET g_t1=g_ola.ola01[1,3]
#             LET g_buf=NULL
#             SELECT ooytype INTO g_buf FROM ooy_file WHERE ooyslip=g_t1
#             SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = g_t1
#             CALL s_axrslip(g_t1,g_buf,g_sys)	     #檢查單別
#     	     IF NOT cl_null(g_errno)THEN 
#                CALL cl_err(g_t1,g_errno,0) 
#                NEXT FIELD ola01
#             END IF
#             IF p_cmd = 'a' AND cl_null(g_ola.ola01[5,10]) AND g_ooy.ooyauno = 'N'
#  	        THEN NEXT FIELD ola01
#             END IF
#             IF g_ooy.ooyauno = 'Y' AND NOT cl_chk_data_continue(g_ola.ola01[5,10]) THEN
#                CALL cl_err('','9056',0) NEXT FIELD ola01
#             END IF
#             IF g_ola.ola01 != g_ola_t.ola01 OR g_ola_t.ola01 IS NULL THEN
#                SELECT count(*) INTO g_cnt FROM ola_file WHERE ola01 = g_ola.ola01
#                IF g_cnt > 0 THEN   #資料重複
#                   CALL cl_err(g_ola.ola01,-239,0)
#                   LET g_ola.ola01 = g_ola_t.ola01
#                   DISPLAY BY NAME g_ola.ola01
#                   NEXT FIELD ola01
#                END IF
#             END IF
#No.FUN-550071--end
          END IF
 
          AFTER FIELD ola11
             IF cl_null(g_ola.ola11) THEN 
                IF g_ola.ola11 NOT MATCHES '[12]' THEN
                   NEXT FIELD ola11 
                END IF
             END IF
 
          AFTER FIELD ola05
             IF NOT cl_null(g_ola.ola05) THEN 
                LET g_buf = NULL
#                IF p_cmd='a' OR g_ola.ola06 IS NULL THEN   #MOD-590523
                SELECT occ02,occ42,occ45 INTO g_buf,g_ola.ola06,g_ola.ola15
                   FROM occ_file 
                 WHERE occ01=g_ola.ola05 AND occacti = 'Y'
                IF SQLCA.SQLCODE THEN 
#                  CALL cl_err('select occ',SQLCA.SQLCODE,0)   #No.FUN-660116
                   CALL cl_err3("sel","occ_file",g_ola.ola05,"",SQLCA.sqlcode,"","select occ",1)  #No.FUN-660116
                   NEXT FIELD ola05
                END IF
                DISPLAY g_buf TO occ02
                DISPLAY BY NAME g_ola.ola06
                DISPLAY BY NAME g_ola.ola15
#                END IF   #MOD-590523
             END IF
 
         #start FUN-670088 add
          AFTER FIELD ola42   #部門
             IF NOT cl_null(g_ola.ola42) THEN
                SELECT gem02 INTO g_buf FROM gem_file
                 WHERE gem01=g_ola.ola42
                   AND gemacti='Y'   #NO:6950
                   AND gem05 = 'Y'   #No.MOD-530272
                IF STATUS THEN
                   CALL cl_err3("sel","gem_file",g_ola.ola42,"","agl-202","","sel gem",1)
                   NEXT FIELD ola42
                END IF
                CALL t200_ola42(p_cmd)       #No.MOD-490461
                IF STATUS THEN
                   CALL cl_err('select gem',STATUS,0)
                   NEXT FIELD ola42
                END IF
                LET g_ola.ola930=s_costcenter(g_ola.ola42)
                DISPLAY BY NAME g_ola.ola930
                DISPLAY s_costcenter_desc(g_ola.ola930) TO FORMONLY.gem02b
             END IF
 
          AFTER FIELD ola930   #成本中心
             IF NOT s_costcenter_chk(g_ola.ola930) THEN
                LET g_ola.ola930=NULL
                DISPLAY BY NAME g_ola.ola930
                DISPLAY NULL TO FORMONLY.gem02b
                NEXT FIELD ola930
             ELSE
                DISPLAY s_costcenter_desc(g_ola.ola930) TO FORMONLY.gem02b
             END IF
         #end FUN-670088 add
 
          AFTER FIELD ola06
             IF NOT cl_null(g_ola.ola06) THEN 
                LET g_buf = NULL
                SELECT azi02,azi03,azi04 INTO g_buf,t_azi03,t_azi04 FROM azi_file WHERE azi01=g_ola.ola06   #MOD-A50157 add azi03,azi04,t_azi03,t_azi04
                IF SQLCA.SQLCODE THEN 
#                  CALL cl_err('select azi',STATUS,0)    #No.FUN-660116
                   CALL cl_err3("sel","azi_file",g_ola.ola06,"",STATUS,"","select azi",1)  #No.FUN-660116
                   NEXT FIELD ola06
                END IF
                IF g_ola.ola07 IS NULL THEN 
                   CALL s_curr3(g_ola.ola06,g_ola.ola02,g_ooz.ooz17) RETURNING g_ola.ola07
                   DISPLAY BY NAME g_ola.ola07
                END IF 
                #No.TQC-6B0051  --begin
                IF NOT cl_null(g_ola.ola21) OR NOT cl_null(g_ola.ola22) OR NOT cl_null(g_ola.ola23) THEN
                   IF l_nma21 <> g_ola.ola06 OR l_nma22 <> g_ola.ola06 OR l_nma23 <> g_ola.ola06 THEN
                      CALL cl_err(' ','axr-104',0)
                      NEXT FIELD ola06
                   END IF
                END IF
                #No.TQC-6B0051  --end
             END IF 
             CALL t200_set_entry(p_cmd)   #MOD-5B0009
 
#MOD-5B0009
          BEFORE FIELD ola07
             CALL t200_set_no_entry(p_cmd)
#END MOD-5B0009
 
 
          #FUN-4C0078
          AFTER FIELD ola07    #匯率             
              IF g_ola.ola06 =g_aza.aza17 THEN
                 LET g_ola.ola07=1
                 DISPLAY BY NAME g_ola.ola07
              END IF
          #--END
 
 
          AFTER FIELD ola15
             IF NOT cl_null(g_ola.ola15) THEN
                LET g_buf = NULL
                SELECT oag02 INTO g_buf FROM oag_file WHERE oag01=g_ola.ola15
                IF STATUS THEN 
#                  CALL cl_err('select oag',STATUS,1)    #No.FUN-660116
                   CALL cl_err3("sel","oag_file",g_ola.ola15,"",STATUS,"","select oag",1)  #No.FUN-660116
                   NEXT FIELD ola15
                END IF
                ERROR g_buf 
             END IF
          AFTER FIELD ola09
             IF NOT cl_null(g_ola.ola09) THEN
                LET g_ola.ola09 = cl_digcut(g_ola.ola09,t_azi04)   #MOD-A50157 add
                LET g_ola.ola10 = cl_digcut(g_ola.ola10,t_azi04)   #MOD-A50157 add
                LET l_amt = g_ola.ola09 - g_ola.ola10 
                LET l_amt = cl_digcut(l_amt,t_azi04)               #MOD-A50157 add
                DISPLAY BY NAME g_ola.ola09,g_ola.ola10            #MOD-A50157 add
                DISPLAY l_amt TO FORMONLY.net_amt
             END IF
 
          AFTER FIELD ola04
             IF NOT cl_null(g_ola.ola04) THEN 
            #------97/08/25 modify 
               IF g_ola.ola04 != g_ola_t.ola04 OR g_ola_t.ola04 IS NULL THEN
                   SELECT count(*) INTO g_cnt FROM ola_file 
                    WHERE ola04 = g_ola.ola04
                   IF g_cnt > 0 THEN   #資料重複
                      CALL cl_err(g_ola.ola04,-239,0)
                      LET g_ola.ola04 = g_ola_t.ola04
                      DISPLAY BY NAME g_ola.ola04
                      NEXT FIELD ola04
                   END IF
                END IF
             END IF
            #-----------------------
          AFTER FIELD ola29
             IF NOT cl_null(g_ola.ola29) THEN 
                IF g_ola.ola29 NOT MATCHES '[YN]' THEN 
                   NEXT FIELD ola29 
                END IF
             END IF
          AFTER FIELD ola30
             IF NOT cl_null(g_ola.ola30) THEN
                IF g_ola.ola30 NOT MATCHES '[YN]' THEN 
                   NEXT FIELD ola30 
                END IF
             END IF
          #-- NO:0132 modify in 99/05/12 ---#
          AFTER FIELD ola32
             IF NOT cl_null(g_ola.ola32) THEN 
                IF NOT cl_null(g_ola.ola32) THEN
                   SELECT * INTO l_ool.* FROM ool_file WHERE ool01=g_ola.ola32
                   IF STATUS THEN 
#                     CALL cl_err('select ool',STATUS,0)    #No.FUN-660116
                      CALL cl_err3("sel","ool_file",g_ola.ola32,"",STATUS,"","select ool",1)  #No.FUN-660116
                      NEXT FIELD ola32
                   END IF
                END IF
             END IF
       
          AFTER FIELD ola16
             IF NOT cl_null(g_ola.ola16) THEN
                IF g_ola.ola16 NOT MATCHES '[YN]' THEN
                   NEXT FIELD ola16
                END IF
             END IF
 
          AFTER FIELD ola17
             IF NOT cl_null(g_ola.ola17) THEN
                IF g_ola.ola17 NOT MATCHES '[YN]' THEN
                    NEXT FIELD ola17
                END IF
             END IF
 
          AFTER FIELD ola18
             IF NOT cl_null(g_ola.ola18) THEN
                IF g_ola.ola18 NOT MATCHES '[YN]' THEN
                   NEXT FIELD ola18
                END IF
             END IF
 
          AFTER FIELD ola19
            IF NOT cl_null(g_ola.ola19) AND g_ola.ola19 NOT MATCHES '[123]' THEN
               NEXT FIELD ola19
            END IF
 
          AFTER FIELD ola20
            IF NOT cl_null(g_ola.ola20) AND g_ola.ola20 NOT MATCHES '[123]' THEN
               NEXT FIELD ola20
            END IF
 
          #---------------------------------#
 
          #No.TQC-6B0051    --begin
          AFTER FIELD ola21
            IF NOT cl_null(g_ola.ola21) THEN
               SELECT COUNT(*) INTO l_n FROM nma_file WHERE nma01=g_ola.ola21
               IF  l_n = 0 THEN
#                  CALL cl_err(' ','axr-035',0)           #TQC-970036 Mark                                                          
                   CALL cl_err(' ','aap-265',0)           #TQC-970036
                   NEXT FIELD ola21
               END IF
               SELECT nma10 INTO l_nma21 FROM nma_file WHERE nma01=g_ola.ola21
               IF NOT cl_null(g_ola.ola06) THEN
                  IF l_nma21 <> g_ola.ola06 THEN
                     CALL cl_err(' ','axr-104',0)
                     NEXT FIELD ola21
                  END IF 
               ELSE 
                  IF NOT cl_null(g_ola.ola22) THEN
                     IF l_nma21 <> l_nma22 THEN
                        CALL cl_err(' ','axr-036',0)
                        NEXT FIELD ola21
                     END IF
                  END IF       
                  IF NOT cl_null(g_ola.ola23) THEN
                     IF l_nma21 <> l_nma23 THEN
                        CALL cl_err(' ','axr-036',0)
                        NEXT FIELD ola21
                     END IF
                  END IF       
               END IF
            END IF
          
          AFTER FIELD ola22
            IF NOT cl_null(g_ola.ola22) THEN
               SELECT count(*) INTO l_n FROM nma_file WHERE nma01=g_ola.ola22
               IF  l_n = 0 THEN
#                  CALL cl_err(' ','axr-035',0)           #TQC-970036 Mark                                                          
                   CALL cl_err(' ','aap-265',0)           #TQC-970036
                   NEXT FIELD ola22
               END IF
               SELECT nma10 INTO l_nma22 FROM nma_file WHERE nma01=g_ola.ola22
               IF NOT cl_null(g_ola.ola06) THEN
                  IF l_nma22 <> g_ola.ola06 THEN
                     CALL cl_err(' ','axr-104',0)
                          NEXT FIELD ola22
                  END IF 
               ELSE 
                  IF NOT cl_null(g_ola.ola21) THEN
                     IF l_nma22 <> l_nma21 THEN
                        CALL cl_err(' ','axr-036',0)
                        NEXT FIELD ola22
                     END IF
                  END IF
                  IF NOT cl_null(g_ola.ola23) THEN
                     IF l_nma22 <>l_nma23 THEN
                        CALL cl_err(' ','axr-036',0)
                        NEXT FIELD ola22
                     END IF
                  END IF
               END IF
            END IF
   
          AFTER FIELD ola23
            IF NOT cl_null(g_ola.ola23) THEN
               SELECT count(*) INTO l_n FROM nma_file WHERE nma01=g_ola.ola23
               IF  l_n = 0 THEN
#                  CALL cl_err(' ','axr-035',0)           #TQC-970036 Mark                                                          
                   CALL cl_err(' ','aap-265',0)           #TQC-970036
                   NEXT FIELD ola23
               END IF
               SELECT nma10 INTO l_nma23 FROM nma_file WHERE nma01=g_ola.ola23
               IF NOT cl_null(g_ola.ola06) THEN
                  IF l_nma23 <> g_ola.ola06 THEN
                     CALL cl_err(' ','axr-104',0)
                     NEXT FIELD ola23
                  END IF 
               ELSE 
                  IF NOT cl_null(g_ola.ola21) THEN
                     IF l_nma23 <> l_nma21 THEN
                        CALL cl_err(' ','axr-036',0)
                        NEXT FIELD ola23
                     END IF
                  END IF
                  IF NOT cl_null(g_ola.ola22) THEN
                     IF l_nma23 <>l_nma22 THEN
                        CALL cl_err(' ','axr-036',0)
                        NEXT FIELD ola23
                     END IF
                  END IF
               END IF
            END IF
          #No.TQC-6B0051  --end
     
          #FUN-850038     ---start---
          AFTER FIELD olaud01
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD olaud02
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD olaud03
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD olaud04
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD olaud05
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD olaud06
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD olaud07
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD olaud08
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD olaud09
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD olaud10
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD olaud11
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD olaud12
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD olaud13
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD olaud14
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD olaud15
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          #FUN-850038     ----end----
 
          AFTER INPUT
             LET g_ola.olauser = s_get_data_owner("ola_file") #FUN-C10039
             LET g_ola.olagrup = s_get_data_group("ola_file") #FUN-C10039
             IF INT_FLAG THEN EXIT INPUT END IF
             IF g_ola.ola07 IS NULL THEN 
                CALL s_curr3(g_ola.ola06,g_ola.ola02,g_ooz.ooz17) RETURNING g_ola.ola07
                DISPLAY BY NAME g_ola.ola07
             END IF 
             IF g_ola.ola32 IS NULL THEN  #科目類別
                CALL cl_err(g_ola.ola32,'aap-099',0)
                DISPLAY BY NAME g_ola.ola32
                NEXT FIELD ola32
             END IF 
             #---------------------------------------------------------------#
        
         ON ACTION controlp     
            CASE
               WHEN INFIELD(ola01)
         #        LET g_t1=g_ola.ola01[1,3]
                 CALL s_get_doc_no(g_ola.ola01) RETURNING g_t1    #No.FUN-550071
                 CALL cl_init_qry_var()
                 #CALL q_ooy( FALSE, TRUE, g_t1,'40',g_sys) RETURNING g_t1 #TQC-670008
                 CALL q_ooy( FALSE, TRUE, g_t1,'40','AXR') RETURNING g_t1  #TQC-670008
         #        LET g_ola.ola01[1,3]=g_t1
                 LET g_ola.ola01=g_t1                             #No.FUN-550071
                 DISPLAY BY NAME g_ola.ola01
                 NEXT FIELD ola01
               WHEN INFIELD(ola05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.default1 = g_ola.ola05
                 CALL cl_create_qry() RETURNING g_ola.ola05
                 DISPLAY BY NAME g_ola.ola05
                 NEXT FIELD ola05
               WHEN INFIELD(ola06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_ola.ola06
                 CALL cl_create_qry() RETURNING g_ola.ola06
                 DISPLAY BY NAME g_ola.ola06
                 NEXT FIELD ola06
               WHEN INFIELD(ola21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma"
                 LET g_qryparam.default1 = g_ola.ola21
                 CALL cl_create_qry() RETURNING g_ola.ola21
                 DISPLAY BY NAME g_ola.ola21
                 NEXT FIELD ola21
               WHEN INFIELD(ola22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma"
                 LET g_qryparam.default1 = g_ola.ola22
                 CALL cl_create_qry() RETURNING g_ola.ola22
                 DISPLAY BY NAME g_ola.ola22
                 NEXT FIELD ola22
               WHEN INFIELD(ola23)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma"
                 LET g_qryparam.default1 = g_ola.ola23
                 CALL cl_create_qry() RETURNING g_ola.ola23
                 DISPLAY BY NAME g_ola.ola23
                 NEXT FIELD ola23
               WHEN INFIELD(ola15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oag"
                 LET g_qryparam.default1 = g_ola.ola15
                 CALL cl_create_qry() RETURNING g_ola.ola15
                 DISPLAY BY NAME g_ola.ola15
                 NEXT FIELD ola15
               #-- NO:0132 modify in 99/05/12 ---#
               WHEN INFIELD(ola32)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ool"
                 LET g_qryparam.default1 = g_ola.ola32
                 CALL cl_create_qry() RETURNING g_ola.ola32
                 DISPLAY BY NAME g_ola.ola32
                 NEXT FIELD ola32
               #FUN-4B0056
               WHEN INFIELD(ola07)
                  CALL s_rate(g_ola.ola06,g_ola.ola07)
                  RETURNING g_ola.ola07
                  DISPLAY BY NAME g_ola.ola07
                  NEXT FIELD ola07
               #--
              #start FUN-670088 add
               WHEN INFIELD(ola42)    #部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem1"
                  LET g_qryparam.default1 = g_ola.ola42
                  CALL cl_create_qry() RETURNING g_ola.ola42
                  DISPLAY BY NAME g_ola.ola42
                  NEXT FIELD ola42
               WHEN INFIELD(ola930)   #成本中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem4"
                  CALL cl_create_qry() RETURNING g_ola.ola930
                  DISPLAY BY NAME g_ola.ola930
                  NEXT FIELD ola930
              #end FUN-670088 add
               END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(ola01) THEN
      #          LET g_ola.* = g_ola_t.*
      #          CALL t200_show()
      #          NEXT FIELD ola01
      #      END IF
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
 
FUNCTION t200_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680123 VARCHAR(01)
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ola01",TRUE)
    END IF
    CALL cl_set_comp_entry("ola07",TRUE)   #MOD-5B0009
END FUNCTION
 
FUNCTION t200_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680123 VARCHAR(01)
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    IF g_ola.ola40 = 'Y' THEN CALL cl_err('','axr-248',0) RETURN END IF
       CALL cl_set_comp_entry("ola01",FALSE)
    END IF
#MOD-5B0009
    IF g_ola.ola06 = g_aza.aza17 THEN
       CALL cl_set_comp_entry("ola07",FALSE)
    END IF
#MOD-5B0009
END FUNCTION
 
#start FUN-670088 add
FUNCTION t200_ola42(p_cmd)  #部門名稱
   DEFINE p_cmd     LIKE type_file.chr1       #No.FUN-680123 VARCHAR(01)
   DEFINE l_gem02   LIKE gem_file.gem02
 
   LET g_errno = ' '
   LET l_gem02 = ' '
   SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_ola.ola42
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg-3097'
                                  LET l_gem02 = NULL
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02a
   END IF
 
END FUNCTION
#end FUN-670088 add
 
FUNCTION t200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ola.* TO NULL              #No.FUN-6B0042
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t200_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_ola.* TO NULL RETURN 
    END IF
    MESSAGE " SEARCHING ! " 
    OPEN t200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ola.* TO NULL
    ELSE
        OPEN t200_count
        FETCH t200_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL t200_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t200_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,       #No.FUN-680123 VARCHAR(1),               #處理方式
    l_abso          LIKE type_file.num10       #No.FUN-680123 INTEGER                #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t200_cs INTO g_ola.ola01
        WHEN 'P' FETCH PREVIOUS t200_cs INTO g_ola.ola01
        WHEN 'F' FETCH FIRST    t200_cs INTO g_ola.ola01
        WHEN 'L' FETCH LAST     t200_cs INTO g_ola.ola01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump t200_cs INTO g_ola.ola01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ola.ola01,SQLCA.sqlcode,0)
        INITIALIZE g_ola.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_ola.* FROM ola_file WHERE ola01 = g_ola.ola01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ola.ola01,SQLCA.sqlcode,0)   #No.FUN-660116
       CALL cl_err3("sel","ola_file",g_ola.ola01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
       INITIALIZE g_ola.* TO NULL
       RETURN
    ELSE
       LET g_data_owner = g_ola.olauser     #No.FUN-4C0049
       LET g_data_group = g_ola.olagrup     #No.FUN-4C0049
       CALL t200_show()
    END IF
 
END FUNCTION
 
FUNCTION t200_show()
    DEFINE l_amt  LIKE ola_file.ola09
    DEFINE t_azi04    LIKE azi_file.azi04  #MOD-A50157 add
 
    SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_ola.ola06   #MOD-A50157 add
    LET g_ola_t.* = g_ola.*                #保存單頭舊值
    DISPLAY BY NAME  g_ola.olaoriu,g_ola.olaorig,
 
          g_ola.ola11,g_ola.ola01,g_ola.ola011,g_ola.ola02,g_ola.ola05 ,
          g_ola.ola42,g_ola.ola930,   #FUN-670088 add
          g_ola.ola28,g_ola.olaconf,g_ola.ola40,g_ola.ola33,g_ola.ola39 ,
          g_ola.ola12,g_ola.olauser,g_ola.olagrup,
          g_ola.olamodu,g_ola.oladate,                   #No.TQC-750041
          g_ola.ola06,g_ola.ola07,g_ola.ola15,g_ola.ola09,g_ola.ola10,
          g_ola.ola04,g_ola.ola21,g_ola.ola22 ,g_ola.ola23,g_ola.ola31,
          g_ola.ola32,
          g_ola.ola24,g_ola.ola25 ,g_ola.ola14,g_ola.ola37,g_ola.ola38 ,
          g_ola.ola29,g_ola.ola30, g_ola.ola16,g_ola.ola17,g_ola.ola18,
          g_ola.ola19,g_ola.ola20,g_ola.ola271,
          #FUN-850038     ---start---
          g_ola.olaud01,g_ola.olaud02,g_ola.olaud03,g_ola.olaud04,
          g_ola.olaud05,g_ola.olaud06,g_ola.olaud07,g_ola.olaud08,
          g_ola.olaud09,g_ola.olaud10,g_ola.olaud11,g_ola.olaud12,
          g_ola.olaud13,g_ola.olaud14,g_ola.olaud15 
          #FUN-850038     ----end----
 
    IF g_ola.olaconf ='X' THEN
       LET g_chr='Y'
    ELSE
       LET g_chr='N'
    END IF
    #CKP
    CALL cl_set_field_pic(g_ola.olaconf,"","",g_ola.ola40,g_chr,"")
 
    SELECT occ02 INTO g_buf FROM occ_file 
     WHERE occ01=g_ola.ola05 AND occacti='Y'
    IF SQLCA.SQLCODE THEN LET g_buf='' END IF
    DISPLAY g_buf TO occ02
 
   #start FUN-670088 add
    CALL t200_ola42('d')
    DISPLAY s_costcenter_desc(g_ola.ola930) TO FORMONLY.gem02b
   #end FUN-670088 add
 
    LET l_amt = g_ola.ola09 - g_ola.ola10
    LET l_amt = cl_digcut(l_amt,t_azi04)               #MOD-A50157 add
    DISPLAY l_amt TO FORMONLY.net_amt
    CALL t200_b_fill(g_wc2)
    CALL t200_olb08()
    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t200_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)
    DEFINE l_n          LIKE type_file.num5       #No.TQC-770046 
 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ola.ola01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ola.* FROM ola_file WHERE ola01 = g_ola.ola01
    IF g_ola.olaconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    IF g_ola.ola40 = 'Y' THEN CALL cl_err('','axr-248',0) RETURN END IF
    IF g_ola.ola37 = 'Y' THEN CALL cl_err('','axr-355',0) RETURN END IF
    IF g_ola.olaconf = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF
 
   #No.TQC-770046--begin--
    SELECT COUNT(*) INTO l_n FROM olc_file WHERE olc29=g_ola.ola01
    IF l_n > 0 THEN
       CALL cl_err(g_ola.ola01,'axr-038',0)
       RETURN
    END IF 
   #No.TQC-770046--end--
 
    BEGIN WORK
 
    OPEN t200_cl USING g_ola.ola01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_ola.*
    IF STATUS THEN CALL cl_err('sel ola',STATUS,0) ROLLBACK WORK RETURN END IF
    CALL t200_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ola01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ola.ola01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete ola,olb,npp,npq!"
        DELETE FROM ola_file WHERE ola01 = g_ola.ola01   #L/C 單頭檔
        IF SQLCA.SQLERRD[3]=0 THEN
#               CALL cl_err('No ola deleted','',0)   #No.FUN-660116
                CALL cl_err3("del","ola_file",g_ola.ola01,"","","","No ola deleted",1)  #No.FUN-660116
                ROLLBACK WORK RETURN
        END IF
        DELETE FROM olb_file WHERE olb01 = g_ola.ola01   #L/C 單身檔
        DELETE FROM ole_file WHERE ole01 = g_ola.ola01   #歷史單頭檔
        DELETE FROM olf_file WHERE olf01 = g_ola.ola01   #歷史單身檔
        #----modify by kammy (必須依序號刪除，否則會刪到別的)----#
        DELETE FROM npp_file WHERE npp01 = g_ola.ola01
                               AND nppsys= 'AR'
                               AND npp00 = 41
                               AND npp011= g_ola.ola011 
        DELETE FROM npq_file WHERE npq01 = g_ola.ola01
                               AND npqsys= 'AR'
                               AND npq00 = 41
                               AND npq011= g_ola.ola011
      #FUN-B40056--add--str--
        DELETE FROM tic_file WHERE tic04 = g_ola.ola01
      #FUN-B40056--add--end--
        #---------------------------------------------------------#
        LET g_msg=TIME
        INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980011 add
           VALUES ('axrt200',g_user,g_today,g_msg,g_ola.ola01,'delete',g_plant,g_legal) #FUN-980011 add
        CLEAR FORM
        CALL g_olb.clear()
        CALL g_olb.clear()
    	INITIALIZE g_ola.* TO NULL
        MESSAGE ""
        OPEN t200_count
        #FUN-B50064-add-start--
        IF STATUS THEN
           CLOSE t200_cl
           CLOSE t200_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        FETCH t200_count INTO g_row_count
        #FUN-B50064-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t200_cl
           CLOSE t200_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t200_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t200_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t200_fetch('/')
        END IF
    END IF
    CLOSE t200_cl
    COMMIT WORK
    CALL cl_flow_notify(g_ola.ola01,'D')
END FUNCTION
 
FUNCTION t200_b()
DEFINE
    l_ac_t          LIKE type_file.num5,       #No.FUN-680123 SMALLINT,              #未取消的ARRAY CNT
    l_row,l_col     LIKE type_file.num5,       #No.FUN-680123 SMALLINT,			   #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,       #No.FUN-680123 SMALLINT,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,       #No.FUN-680123 VARCHAR(1), #單身鎖住否
    p_cmd           LIKE type_file.chr1,       #No.FUN-680123 VARCHAR(1), #處理狀態
    l_b2            LIKE type_file.chr1000,    #No.FUN-680123 VARCHAR(30),
    l_flag          LIKE type_file.num10,      #No.FUN-680123 INTEGER,
    l_oea32         LIKE oea_file.oea32,
    l_oeb           RECORD LIKE oeb_file.*,
    l_allow_insert  LIKE type_file.num5,       #No.FUN-680123 SMALLINT,              #可新增否
    l_allow_delete  LIKE type_file.num5        #No.FUN-680123 SMALLINT               #可刪除否
DEFINE l_oea08      LIKE oea_file.oea08        #TQC-A40053
DEFINE t_axi03      LIKE azi_file.azi03        #MOD-A50157 add
DEFINE t_axi04      LIKE azi_file.azi04        #MOD-A50157 add
 
    LET g_action_choice = ""
    IF g_ola.ola01 IS NULL THEN RETURN END IF
    IF g_ola.olaconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    IF g_ola.ola40 = 'Y' THEN CALL cl_err('','axr-248',0) RETURN END IF
    IF g_ola.ola37 = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF
    IF g_ola.olaconf = 'Y' THEN CALL cl_err('','axr-101',0) RETURN END IF
    SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file WHERE azi01 = g_ola.ola06   #MOD-A50157 add
    #--97/08/25 modify
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT * FROM olb_file    ",
                       "  WHERE olb01=?   ",
                       "   AND olb02=?   ",    
                       "   FOR UPDATE              "   
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_olb WITHOUT DEFAULTS FROM s_olb.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            #No.TQC-B90172  --Begin
            ##No.FUN-550071--begin
            #CALL cl_set_docno_format("olb04")
            ##No.FUN-550071--end
            #No.TQC-B90172  --End  
        BEFORE ROW
           LET p_cmd = ''
            LET l_ac = ARR_CURR() 
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t200_cl USING g_ola.ola01
            IF STATUS THEN
               CALL cl_err("OPEN t200_cl:", STATUS, 1)
               CLOSE t200_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t200_cl INTO g_ola.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ola.ola01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t200_cl ROLLBACK WORK RETURN
            END IF
             IF g_rec_b>=l_ac THEN 
                LET g_olb_t.* = g_olb[l_ac].*  #BACKUP
                LET p_cmd='u'
 
                OPEN t200_bcl USING g_ola.ola01,g_olb_t.olb02
                IF STATUS THEN
                   CALL cl_err("OPEN t200_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y" 
                ELSE
                   FETCH t200_bcl INTO b_olb.*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('lock olb',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      CALL t200_b_move_to()
                      LET g_olb[l_ac].gem02=s_costcenter_desc(g_olb[l_ac].olb930)   #FUN-670088 add
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
             END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            CALL t200_b_move_back()
            INSERT INTO olb_file VALUES(b_olb.*)
            IF SQLCA.sqlcode THEN
#              CALL cl_err('ins olb',SQLCA.sqlcode,0)   #No.FUN-660116
               CALL cl_err3("ins","olb_file",b_olb.olb01,b_olb.olb02,SQLCA.sqlcode,"","ins olb",1)  #No.FUN-660116
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
	       COMMIT WORK
               CALL t200_olb08()
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_olb[l_ac].* TO NULL      #900423
            LET g_olb_t.* = g_olb[l_ac].*             #新輸入資料
            LET b_olb.olb01 = g_ola.ola01
            #LET g_olb[l_ac].olb09=0   #MOD-720083
            #LET g_olb[l_ac].olb10=0   #MOD-720083
           #start FUN-670088 add
            LET g_olb[l_ac].olb930=g_ola.ola930
            LET g_olb[l_ac].gem02 =s_costcenter_desc(g_olb[l_ac].olb930)
            DISPLAY BY NAME g_olb[l_ac].olb930,g_olb[l_ac].gem02
           #end FUN-670088 add
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD olb02
 
        BEFORE FIELD olb02                            #default 序號
            IF g_olb[l_ac].olb02 IS NULL OR g_olb[l_ac].olb02 = 0 THEN
                SELECT max(olb02)+1 INTO g_olb[l_ac].olb02
                   FROM olb_file WHERE olb01 = g_ola.ola01
                IF g_olb[l_ac].olb02 IS NULL THEN
                    LET g_olb[l_ac].olb02 = 1
                END IF
#               DISPLAY g_olb[l_ac].olb02 TO olb02 #No.FUN-570273預設值不可使用
            END IF
 
        AFTER FIELD olb02                        #check 序號是否重複
            IF NOT cl_null(g_olb[l_ac].olb02) THEN 
               IF g_olb[l_ac].olb02 != g_olb_t.olb02 OR
                  g_olb_t.olb02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM olb_file
                       WHERE olb01 = g_ola.ola01 AND olb02 = g_olb[l_ac].olb02
                   IF l_n > 0 THEN
                       LET g_olb[l_ac].olb02 = g_olb_t.olb02
                       CALL cl_err('',-239,0) NEXT FIELD olb02
                   END IF
               END IF
            END IF
        AFTER FIELD olb04
            IF NOT cl_null(g_olb[l_ac].olb04) THEN
               IF p_cmd='a' OR g_olb[l_ac].olb04 != g_olb_t.olb04 THEN
                 #FUN-A60056--mod--str--
                 #SELECT oea32 INTO l_oea32 FROM oea_file 
                 # WHERE oea01=g_olb[l_ac].olb04 
                  LET g_sql = "SELECT oea32 FROM ",cl_get_target_table(g_plant,'oea_file'),
                              " WHERE oea01='",g_olb[l_ac].olb04,"'"
                              ," AND oea00 <> '0' AND oeaconf = 'Y'"   #MOD-B80067 add
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
                  PREPARE sel_oea32 FROM g_sql
                  EXECUTE sel_oea32 INTO l_oea32
                 #FUN-A60056--mod--end
                  IF STATUS THEN 
#                    CALL cl_err(g_olb[l_ac].olb04,'axr-134',1)   #No.FUN-660116
                     CALL cl_err3("sel","oea_file",g_olb[l_ac].olb04,"","axr-134","","",1)  #No.FUN-660116
                     NEXT FIELD olb04
                  END IF
                  #TQC-A40053--Add--Begin                                                                                           
                 #FUN-A60056--mod--str--
                 #SELECT oea08 INTO l_oea08 FROM oea_file                                                                           
                 # WHERE oea01=g_olb[l_ac].olb04                                                                                    
                  LET g_sql = "SELECT oea08 FROM ",cl_get_target_table(g_plant,'oea_file'),
                              " WHERE oea01='",g_olb[l_ac].olb04,"'"
                              ," AND oea00 <> '0' AND oeaconf = 'Y'"   #MOD-B80067 add
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
                  PREPARE sel_oea08 FROM g_sql
                  EXECUTE sel_oea08 INTO l_oea08
                 #FUN-A60056--mod--end
                  IF l_oea08 <> g_ola.ola11 THEN                                                                                    
                     CALL cl_err(g_olb[l_ac].olb04,'axr-919',1)                                                                     
                     NEXT FIELD olb04                                                                                               
                  END IF                                                                                                            
                  #TQC-A40053--Add--End
               END IF
            END IF
        AFTER FIELD olb05
            IF NOT cl_null(g_olb[l_ac].olb05) THEN 
               IF p_cmd='a' OR g_olb[l_ac].olb04 != g_olb_t.olb04 OR 
                  g_olb[l_ac].olb05 != g_olb_t.olb05 THEN
                  SELECT count(*) INTO l_n FROM olb_file
                   WHERE olb01 = g_ola.ola01
                     AND olb04 = g_olb[l_ac].olb04
                     AND olb05 = g_olb[l_ac].olb05
                  IF l_n > 0 THEN
                     LET g_olb[l_ac].olb05 = g_olb_t.olb05
                     CALL cl_err('',-239,0) NEXT FIELD olb05
                  END IF
                 #FUN-A60056--mod--str--
                 #SELECT * INTO l_oeb.* FROM oeb_file
                 # WHERE oeb01=g_olb[l_ac].olb04 AND oeb03=g_olb[l_ac].olb05
                  LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant,'oeb_file'),
                              " WHERE oeb01='",g_olb[l_ac].olb04,"'",
                              "   AND oeb03='",g_olb[l_ac].olb05,"'"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
                  PREPARE sel_oeb FROM g_sql
                  EXECUTE sel_oeb INTO l_oeb.*
                 #FUN-A60056--mod--end
                  IF STATUS THEN 
#                    CALL cl_err(g_olb[l_ac].olb05,'axr-134',1)   #No.FUN-660116
                     CALL cl_err3("sel","oeb_file",g_olb[l_ac].olb04,g_olb[l_ac].olb05,"axr-134","","",1)  #No.FUN-660116
                     NEXT FIELD olb05
                  END IF
                  LET g_olb[l_ac].olb11 =l_oeb.oeb04
                  LET g_olb[l_ac].ima02 =l_oeb.oeb06
                  #LET g_olb[l_ac].olb03=l_oeb.oeb05   #FUN-560089
                  LET g_olb[l_ac].olb03 =l_oeb.oeb916   #FUN-560089
                  LET g_olb[l_ac].olb06 =l_oeb.oeb13
                  #LET g_olb[l_ac].olb07=l_oeb.oeb12   #FUN-560089
                  LET g_olb[l_ac].olb07 =l_oeb.oeb917   #FUN-560089   
                  LET g_olb[l_ac].olb08 =l_oeb.oeb14
                 #start FUN-670088 add
                  LET g_olb[l_ac].olb930=l_oeb.oeb930
                  LET g_olb[l_ac].gem02 =s_costcenter_desc(g_olb[l_ac].olb930)
                  DISPLAY BY NAME g_olb[l_ac].olb930,g_olb[l_ac].gem02
                 #end FUN-670088 add
 
                 { 
                  DISPLAY g_olb[l_ac].olb11,g_olb[l_ac].ima02,
                          g_olb[l_ac].olb03,g_olb[l_ac].olb06,
                          g_olb[l_ac].olb07,g_olb[l_ac].olb08 
                       TO s_olb[l_sl].olb11,s_olb[l_sl].ima02,
                          s_olb[l_sl].olb03,s_olb[l_sl].olb06,
                          s_olb[l_sl].olb07,s_olb[l_sl].olb08
                 }
               END IF
            END IF
        AFTER FIELD olb06
            IF NOT cl_null(g_olb[l_ac].olb06) THEN
               LET g_olb[l_ac].olb06 = cl_digcut(g_olb[l_ac].olb06,t_azi03)               #MOD-A50157 add
               IF g_olb[l_ac].olb06 <=0 THEN 
                  CALL cl_err(' ','axr-033',0)     #No.TQC-6B0051
                  NEXT FIELD olb06
               END IF
            END IF
        AFTER FIELD olb07
            IF NOT cl_null(g_olb[l_ac].olb07) THEN
               LET g_olb[l_ac].olb07 = s_digqty(g_olb[l_ac].olb07,g_olb[l_ac].olb03)    #FUN-910088--add--
               DISPLAY BY NAME g_olb[l_ac].olb07                                        #FUN-910088--add--
               IF g_olb[l_ac].olb07 <=0 THEN 
                  CALL cl_err(' ','axr-034',0)     #No.TQC-6B0051
                  NEXT FIELD olb07
               END IF
            END IF
            LET g_olb[l_ac].olb08 = g_olb[l_ac].olb06 * g_olb[l_ac].olb07
            LET g_olb[l_ac].olb08 = cl_digcut(g_olb[l_ac].olb08,t_azi04)               #MOD-A50157 add
            DISPLAY g_olb[l_ac].olb08 TO s_olb[l_sl].olb08
 
       #start FUN-670088 add
        AFTER FIELD olb930   #成本中心
           IF NOT s_costcenter_chk(g_olb[l_ac].olb930) THEN
              LET g_olb[l_ac].olb930=g_olb_t.olb930
              LET g_olb[l_ac].gem02 =g_olb_t.gem02 
              DISPLAY BY NAME g_olb[l_ac].olb930,g_olb[l_ac].gem02
              NEXT FIELD olb930
           ELSE
              LET g_olb[l_ac].gem02=s_costcenter_desc(g_olb[l_ac].olb930)
              DISPLAY BY NAME g_olb[l_ac].gem02
           END IF
       #enf FUN-670088 add
 
        #No.FUN-850038 --start--
        AFTER FIELD olbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD olbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-850038 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_olb_t.olb02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                # genero shell add end
                DELETE FROM olb_file
                    WHERE olb01 = g_ola.ola01 AND olb02 = g_olb_t.olb02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_olb_t.olb02,SQLCA.sqlcode,0)   #No.FUN-660116
                    CALL cl_err3("del","olb_file",g_ola.ola01,g_olb_t.olb02,SQLCA.sqlcode,"","",1)  #No.FUN-660116
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
	        COMMIT WORK
                CALL t200_olb08()
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_olb[l_ac].* = g_olb_t.*
               CLOSE t200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_olb[l_ac].olb02,-263,1)
               LET g_olb[l_ac].* = g_olb_t.*
            ELSE
               CALL t200_b_move_back()
               UPDATE olb_file SET * = b_olb.*
                WHERE olb01=g_ola.ola01 AND olb02=g_olb_t.olb02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('upd olb',SQLCA.sqlcode,0)   #No.FUN-660116
                  CALL cl_err3("upd","olb_file",g_ola.ola01,g_olb_t.olb02,SQLCA.sqlcode,"","upd olb",1)  #No.FUN-660116
                  LET g_olb[l_ac].* = g_olb_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
   	            	      COMMIT WORK
                  CALL t200_olb08()
               END IF
            END IF
 
        AFTER ROW
             LET l_ac = ARR_CURR()
             #LET l_ac_t = l_ac  #FUN-D30032
             IF INT_FLAG THEN                 #900423
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd = 'u' THEN
                   LET g_olb[l_ac].* = g_olb_t.*
                #FUN-D30032--add--str--
                ELSE
                   CALL g_olb.deleteElement(l_ac)
                   IF g_rec_b != 0 THEN
                      LET g_action_choice = "detail"
                      LET l_ac = l_ac_t
                   END IF
                #FUN-D30032--add--end--
                END IF
                CLOSE t200_bcl
                ROLLBACK WORK
                EXIT INPUT
             END IF
             LET l_ac_t = l_ac  #FUN-D30032
             CLOSE t200_bcl
             COMMIT WORK
 
        ON ACTION controlp    
           CASE
             WHEN INFIELD(olb04)
               CALL q_oea(FALSE,TRUE,g_olb[l_ac].olb04,g_ola.ola05,'3') 
                    RETURNING g_olb[l_ac].olb04
#               CALL FGL_DIALOG_SETBUFFER( g_olb[l_ac].olb04 )
               NEXT FIELD olb04
            #start FUN-670088 add
             WHEN INFIELD(olb930)   #成本中心
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem4"
                CALL cl_create_qry() RETURNING g_olb[l_ac].olb930
                DISPLAY BY NAME g_olb[l_ac].olb930
                NEXT FIELD olb930
            #end FUN-670088 add
           END CASE
 
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(olb02) AND l_ac > 1 THEN
               LET g_olb[l_ac].* = g_olb[l_ac-1].*
               LET g_olb[l_ac].olb02 = NULL
               NEXT FIELD olb02
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
    
    IF g_action_choice = "detail" THEN RETURN END IF  #FUN-D30032 add
    #FUN-5B0116-begin
     UPDATE ola_file SET olamodu = g_user,oladate = g_today
      WHERE ola01 = g_ola.ola01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#       CALL cl_err('upd ola',SQLCA.SQLCODE,1)   #No.FUN-660116
        CALL cl_err3("upd","ola_file",g_ola.ola01,"",SQLCA.sqlcode,"","upd ola",1)  #No.FUN-660116
     END IF
    #FUN-5B0116-end
 
    CLOSE t200_bcl
    COMMIT WORK
    CALL t200_delHeader()     #CHI-C30002 add
    IF cl_null(g_ola.ola01) THEN RETURN END IF #CHI-C30002 add  #若單身無資料用戶選擇清空單頭則退出
# 新增自動確認功能 Modify by Charis 96-09-23
#    LET g_t1=g_ola.ola01[1,3]
    CALL s_get_doc_no(g_ola.ola01) RETURNING g_t1      #No.FUN-550071
    SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
    IF STATUS THEN 
#      CALL cl_err('sel ooy_file',STATUS,0)   #No.FUN-660116
       CALL cl_err3("sel","ooy_file",g_t1,"",STATUS,"","sel ooy_file",1)  #No.FUN-660116 
       RETURN 
    END IF
    IF (g_ola.olaconf='Y' OR g_ooy.ooyconf='N') #單據已確認或單據不需自動確認
       THEN RETURN 
    ELSE CALL t200_5() 
         IF g_ola.ola37='Y' THEN   ##進出口已確認,會計才可確認
            CALL t200_y() 
         END IF
    END IF
# ----------------- :-)
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t200_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ola.ola01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ola_file ",
                  "  WHERE ola01 LIKE '",l_slip,"%' ",
                  "    AND ola01 > '",g_ola.ola01,"'"
      PREPARE t200_pb1 FROM l_sql 
      EXECUTE t200_pb1 INTO l_cnt
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         #CALL t200_x() #FUN-D20035 mark
         CALL t200_x(1) #FUN-D20035 add
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM ole_file WHERE ole01 = g_ola.ola01
         DELETE FROM olf_file WHERE olf01 = g_ola.ola01
         DELETE FROM npp_file WHERE npp01 = g_ola.ola01
                                AND nppsys= 'AR'
                                AND npp00 = 41
                                AND npp011= g_ola.ola011 
         DELETE FROM npq_file WHERE npq01 = g_ola.ola01
                                AND npqsys= 'AR'
                                AND npq00 = 41
                                AND npq011= g_ola.ola011

         DELETE FROM tic_file WHERE tic04 = g_ola.ola01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ola_file WHERE ola01 = g_ola.ola01
         INITIALIZE g_ola.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t200_olb08()
   DEFINE  l_tot    LIKE ola_file.ola10
   DEFINE  t_azi05  LIKE azi_file.azi05   #MOD-A50157 add

   SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01 = g_ola.ola06    #MOD-A50157 add
   SELECT SUM(olb08) INTO l_tot FROM olb_file WHERE olb01=g_ola.ola01
   IF STATUS THEN LET l_tot=0 END IF
   LET l_tot = cl_digcut(l_tot,t_azi05)    #MOD-A50157 add
   DISPLAY l_tot TO FORMONLY.tot
END FUNCTION
 
FUNCTION t200_b_move_to()
   LET g_olb[l_ac].olb02 = b_olb.olb02 
   LET g_olb[l_ac].olb04 = b_olb.olb04 
   LET g_olb[l_ac].olb05 = b_olb.olb05 
   LET g_olb[l_ac].olb11 = b_olb.olb11 
   LET g_olb[l_ac].olb03 = b_olb.olb03 
   LET g_olb[l_ac].olb06 = b_olb.olb06 
   LET g_olb[l_ac].olb07 = b_olb.olb07 
   LET g_olb[l_ac].olb08 = b_olb.olb08 
   #LET g_olb[l_ac].olb09 = b_olb.olb09    #MOD-720083
   #LET g_olb[l_ac].olb10 = b_olb.olb10    #MOD-720083
   LET g_olb[l_ac].olb930= b_olb.olb930   #FUN-670088 add 
   #NO.FUN-850038 --start--
   LET g_olb[l_ac].olbud01 = b_olb.olbud01
   LET g_olb[l_ac].olbud02 = b_olb.olbud02
   LET g_olb[l_ac].olbud03 = b_olb.olbud03
   LET g_olb[l_ac].olbud04 = b_olb.olbud04
   LET g_olb[l_ac].olbud05 = b_olb.olbud05
   LET g_olb[l_ac].olbud06 = b_olb.olbud06
   LET g_olb[l_ac].olbud07 = b_olb.olbud07
   LET g_olb[l_ac].olbud08 = b_olb.olbud08
   LET g_olb[l_ac].olbud09 = b_olb.olbud09
   LET g_olb[l_ac].olbud10 = b_olb.olbud10
   LET g_olb[l_ac].olbud11 = b_olb.olbud11
   LET g_olb[l_ac].olbud12 = b_olb.olbud12
   LET g_olb[l_ac].olbud13 = b_olb.olbud13
   LET g_olb[l_ac].olbud14 = b_olb.olbud14
   LET g_olb[l_ac].olbud15 = b_olb.olbud15
   #NO.FUN-850038 --end--
END FUNCTION
 
FUNCTION t200_b_move_back()
   LET b_olb.olb02 = g_olb[l_ac].olb02 
   LET b_olb.olb04 = g_olb[l_ac].olb04 
   LET b_olb.olb05 = g_olb[l_ac].olb05 
   LET b_olb.olb11 = g_olb[l_ac].olb11 
   LET b_olb.olb03 = g_olb[l_ac].olb03 
   LET b_olb.olb06 = g_olb[l_ac].olb06 
   LET b_olb.olb07 = g_olb[l_ac].olb07 
   LET b_olb.olb08 = g_olb[l_ac].olb08 
   #LET b_olb.olb09 = g_olb[l_ac].olb09    #MOD-720083
   #LET b_olb.olb10 = g_olb[l_ac].olb10    #MOD-720083
   LET b_olb.olb930= g_olb[l_ac].olb930   #FUN-670088 add 
   #No.FUN-850038 --start--
   LET b_olb.olbud01 = g_olb[l_ac].olbud01
   LET b_olb.olbud02 = g_olb[l_ac].olbud02
   LET b_olb.olbud03 = g_olb[l_ac].olbud03
   LET b_olb.olbud04 = g_olb[l_ac].olbud04
   LET b_olb.olbud05 = g_olb[l_ac].olbud05
   LET b_olb.olbud06 = g_olb[l_ac].olbud06
   LET b_olb.olbud07 = g_olb[l_ac].olbud07
   LET b_olb.olbud08 = g_olb[l_ac].olbud08
   LET b_olb.olbud09 = g_olb[l_ac].olbud09
   LET b_olb.olbud10 = g_olb[l_ac].olbud10
   LET b_olb.olbud11 = g_olb[l_ac].olbud11
   LET b_olb.olbud12 = g_olb[l_ac].olbud12
   LET b_olb.olbud13 = g_olb[l_ac].olbud13
   LET b_olb.olbud14 = g_olb[l_ac].olbud14
   LET b_olb.olbud15 = g_olb[l_ac].olbud15
   #NO.FUN-850038 --end--
   LET b_olb.olblegal = g_legal #FUN-980011 add
END FUNCTION
 
FUNCTION t200_b_askkey()
DEFINE l_wc2          LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON olb02,olb04,olb05,olb11,olb03,olb06,olb07,
                       #olb08,olb09,olb10   #MOD-720083
                       olb08   #MOD-720083
                       #No.FUN-850038 --start--
                       ,olbud01,olbud02,olbud03,olbud04,olbud05
                       ,olbud06,olbud07,olbud08,olbud09,olbud10
                       ,olbud11,olbud12,olbud13,olbud14,olbud15
                       #No.FUN-850038 ---end---
                  FROM s_olb[1].olb02, s_olb[1].olb04,s_olb[1].olb05,
                       s_olb[1].olb11, s_olb[1].olb03,s_olb[1].olb06,
                       #s_olb[1].olb07, s_olb[1].olb08,s_olb[1].olb09,   #MOD-720083
                       #s_olb[1].olb10   #MOD-720083
                       s_olb[1].olb07, s_olb[1].olb08  #MOD-720083
                       #No.FUN-850038 --start--
                       ,s_olb[1].olbud01,s_olb[1].olbud02,s_olb[1].olbud03
                       ,s_olb[1].olbud04,s_olb[1].olbud05,s_olb[1].olbud06
                       ,s_olb[1].olbud07,s_olb[1].olbud08,s_olb[1].olbud09
                       ,s_olb[1].olbud10,s_olb[1].olbud11,s_olb[1].olbud12
                       ,s_olb[1].olbud13,s_olb[1].olbud14,s_olb[1].olbud15
                       #No.FUN-850038 ---end---
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
    CALL t200_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t200_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2     LIKE type_file.chr1000, #No.FUN-680123 VARCHAR(200),
       l_tot     LIKE ola_file.ola10,
       t_azi05   LIKE azi_file.azi05     #MOD-A50157 add
 
    SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01 = g_ola.ola06     #MOD-A50157 add
    LET g_sql ="SELECT olb02,olb04,olb05,olb11,ima02,olb03,olb06,olb07,",
               #"       olb08,olb09,olb10,olb930,'' ",   #FUN-670088 add olb930,''   #MOD-720083
               "       olb08,olb930,'', ",   #FUN-670088 add olb930,''   #MOD-720083
               #No.FUN-850038 --start--
               "       olbud01,olbud02,olbud03,olbud04,olbud05,",
               "       olbud06,olbud07,olbud08,olbud09,olbud10,",
               "       olbud11,olbud12,olbud13,olbud14,olbud15 ", 
               #No.FUN-850038 ---end---
               " FROM olb_file LEFT OUTER JOIN ima_file ON ima_file.ima01=olb_file.olb11  ",
               " WHERE olb01 ='",g_ola.ola01,"'",  #單頭
               "   AND ",p_wc2 CLIPPED,                     #單身
               " ORDER BY 1"
 
    PREPARE t200_pb FROM g_sql
    DECLARE olb_curs                       #SCROLL CURSOR
        CURSOR FOR t200_pb
 
    CALL g_olb.clear()
    LET g_rec_b = 0   
 
    LET l_tot = 0
    LET g_cnt = 1
    FOREACH olb_curs INTO g_olb[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF cl_null(g_olb[g_cnt].olb06) THEN LET g_olb[g_cnt].olb06=0 END IF 
       IF cl_null(g_olb[g_cnt].olb07) THEN LET g_olb[g_cnt].olb07=0 END IF 
       IF cl_null(g_olb[g_cnt].olb08) THEN LET g_olb[g_cnt].olb08=0 END IF 
       #IF cl_null(g_olb[g_cnt].olb09) THEN LET g_olb[g_cnt].olb09=0 END IF    #MOD-720083
       #IF cl_null(g_olb[g_cnt].olb10) THEN LET g_olb[g_cnt].olb10=0 END IF    #MOD-720083
       #LET l_tot = l_tot + g_olb[g_cnt].olb10   #MOD-720083
       LET l_tot = l_tot + g_olb[g_cnt].olb08   #MOD-720083
       LET l_tot = cl_digcut(l_tot,t_azi05)     #MOD-A50157  add
       LET g_olb[g_cnt].gem02=s_costcenter_desc(g_olb[g_cnt].olb930)   #FUN-670088 add
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_olb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY l_tot TO FORMONLY.tot
END FUNCTION
 
FUNCTION t200_bp(p_ud)
   DEFINE   p_ud  LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_olb  TO s_olb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #No.FUN-670047--begin
         IF g_aza.aza63 = 'Y' THEN
            CALL cl_set_act_visible("entry_sheet2", TRUE)  
         ELSE
            CALL cl_set_act_visible("entry_sheet2", FALSE)  
         END IF
         #No.FUN-670047--end  
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL t200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL t200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
 
      ON ACTION next
         CALL t200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
       ON ACTION jump
         CALL t200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last 
         CALL t200_fetch('L')
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
         IF g_ola.olaconf ='X' THEN
            LET g_chr='Y'
         ELSE
            LET g_chr='N'
         END IF
         CALL cl_set_field_pic(g_ola.olaconf,"","",g_ola.ola40,g_chr,"")
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
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
      ON ACTION void #作廢
         LET g_action_choice="void"
         EXIT DISPLAY
      #FUN-D20035 add str
      ON ACTION undo_void #作廢
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035 add end     
      ON ACTION amend_l_c  #信用狀修改
         LET g_action_choice="amend_l_c"
         EXIT DISPLAY
     
      ON ACTION gen_entry #會計分錄產生
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
   
      ON ACTION entry_sheet   #分錄底稿
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY
     
      #No.FUN-670047--begin
      ON ACTION entry_sheet2  #分錄底稿
         LET g_action_choice="entry_sheet2"
         EXIT DISPLAY
      #No.FUN-670047--end  
 
      ON ACTION carry_voucher #傳票拋轉
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY
    
      #No.FUN-670060  --Begin
      ON ACTION undo_carry_voucher #傳票拋轉還原
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY
      #No.FUN-670060  --End   
    
      ON ACTION close_the_case  #結案
         LET g_action_choice="close_the_case"
         EXIT DISPLAY
    
      ON ACTION undo_close  #取消結案
         LET g_action_choice="undo_close"
         EXIT DISPLAY
    
      ON ACTION invoice_qry  #INVOICE查詢
         LET g_action_choice="invoice_qry"
         EXIT DISPLAY
    
      ON ACTION avail_balance  #可用餘額查詢
         LET g_action_choice="avail_balance"
         EXIT DISPLAY
    
      ON ACTION fin_imp_exp_confirm  #財務/進出口確認
         LET g_action_choice="fin_imp_exp_confirm"
         EXIT DISPLAY
    
      ON ACTION undo_fin_imp_exp_confirm  #財務/進出口取消確認
         LET g_action_choice="undo_fin_imp_exp_confirm"
         EXIT DISPLAY
    
      ON ACTION accounting_confirm  #會計確認
         LET g_action_choice="accounting_confirm"
         EXIT DISPLAY
     
      ON ACTION undo_tr_confirm #會計取消確認
         LET g_action_choice="undo_tr_confirm"
         EXIT DISPLAY
    
      ON ACTION l_c_ckg_list  #信用狀檢查表
         LET g_action_choice="l_c_ckg_list"
         EXIT DISPLAY
 
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
 
      #FUN-4B0017
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      ON ACTION related_document                #No.FUN-6B0042  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t200_d()
DEFINE p_row,p_col    LIKE type_file.num5       #No.FUN-680123 SMALLINT
DEFINE ls_tmp STRING
    IF cl_null(g_ola.ola01) THEN RETURN END IF
    IF g_ola.olaconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    LET p_row = 6 LET p_col = 32
    OPEN WINDOW t200_d_w AT p_row,p_col WITH FORM "axr/42f/axrt200_d"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axrt200_d")
 
    INPUT BY NAME g_ola.ola16,g_ola.ola17,g_ola.ola18,g_ola.ola19,
                  g_ola.ola20 WITHOUT DEFAULTS 
       AFTER FIELD ola16
         IF NOT cl_null(g_ola.ola16) THEN
            IF g_ola.ola16 NOT MATCHES '[YN]' THEN
               NEXT FIELD ola16
            END IF
         END IF
       AFTER FIELD ola17
         IF NOT cl_null(g_ola.ola17) THEN 
            IF g_ola.ola17 NOT MATCHES '[YN]' THEN
                NEXT FIELD ola17
            END IF
         END IF
       AFTER FIELD ola18
         IF NOT cl_null(g_ola.ola18) THEN
            IF g_ola.ola18 NOT MATCHES '[YN]' THEN
               NEXT FIELD ola18
            END IF
         END IF
       AFTER FIELD ola19
         IF NOT cl_null(g_ola.ola19) AND g_ola.ola19 NOT MATCHES '[123]' THEN
            NEXT FIELD ola19
         END IF
       AFTER FIELD ola20
         IF NOT cl_null(g_ola.ola20) AND g_ola.ola20 NOT MATCHES '[123]' THEN
            NEXT FIELD ola20
         END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
    END INPUT
    CLOSE WINDOW t200_d_w
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    UPDATE ola_file SET * = g_ola.* WHERE ola01 = g_ola.ola01
    IF SQLCA.SQLCODE THEN 
#      CALL cl_err('update ola',SQLCA.SQLCODE,0)   #No.FUN-660116
       CALL cl_err3("upd","ola_file",g_ola.ola01,"",SQLCA.sqlcode,"","update ola",1)  #No.FUN-660116
    END IF
END FUNCTION 
 
FUNCTION t200_1()          #結案
   DEFINE  l_ola12_o     LIKE ola_file.ola12
   DEFINE  l_amt         LIKE ola_file.ola09
   DEFINE  t_azi04       LIKE azi_file.azi04   #MOD-A50157 add
 
   SELECT * INTO g_ola.* FROM ola_file WHERE ola01 = g_ola.ola01
   IF g_ola.ola40 = 'Y' THEN RETURN END IF
   IF g_ola.olaconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_ola.ola06  #MOD-A50157 add
   LET l_amt = g_ola.ola09 - g_ola.ola10
   LET l_amt = cl_digcut(l_amt,t_azi04)               #MOD-A50157 add

{
#..押匯餘額=0,則不可結案
   IF l_amt = 0 THEN CALL cl_err('amt','axr-903',1) RETURN END IF 
#.......................
}
   IF NOT cl_confirm('axr-247') THEN RETURN END IF
   LET g_success = 'Y'
   BEGIN WORK 
 
   OPEN t200_cl USING g_ola.ola01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_ola.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ola.ola01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t200_cl ROLLBACK WORK RETURN
   END IF
   LET l_ola12_o = g_ola.ola12
   UPDATE ola_file SET ola40 = 'Y', ola12 = g_today WHERE ola01=g_ola.ola01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd ola40',SQLCA.SQLCODE,1)   #No.FUN-660116
      CALL cl_err3("upd","ola_file",g_ola.ola01,"",SQLCA.sqlcode,"","upd ola40",1)  #No.FUN-660116
      LET g_success = 'N' 
   END IF
   IF g_success = 'Y'
      THEN LET g_ola.ola40= 'Y' LET g_ola.ola12 = g_today   COMMIT WORK
      ELSE LET g_ola.ola40= 'N' LET g_ola.ola12 = l_ola12_o ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_ola.ola40,g_ola.ola12 
   #CKP
   IF g_ola.olaconf ='X' THEN
      LET g_chr='Y'
   ELSE
      LET g_chr='N'
   END IF
   CALL cl_set_field_pic(g_ola.olaconf,"","",g_ola.ola40,g_chr,"")
END FUNCTION
 
FUNCTION t200_2()           #取消結案
   DEFINE  l_ola12_o     LIKE ola_file.ola12
 
   SELECT * INTO g_ola.* FROM ola_file WHERE ola01 = g_ola.ola01
   IF g_ola.ola40 = 'N' THEN RETURN END IF
   IF g_ola.olaconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
   END IF
   IF NOT cl_confirm('axr-250') THEN RETURN END IF
   LET g_success = 'Y'
   BEGIN WORK 
 
   OPEN t200_cl USING g_ola.ola01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_ola.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ola.ola01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t200_cl ROLLBACK WORK RETURN
   END IF
   LET l_ola12_o = g_ola.ola12
  #UPDATE ola_file SET ola40 = 'N', ola12 = g_today WHERE ola01=g_ola.ola01   #No.TQC-750041
   UPDATE ola_file SET ola40 = 'N', ola12 = null    WHERE ola01=g_ola.ola01   #No.TQC-750041
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd ola40',SQLCA.SQLCODE,1)   #No.FUN-660116
      CALL cl_err3("upd","ola_file",g_ola.ola01,"",SQLCA.sqlcode,"","upd ola40",1)  #No.FUN-660116
      LET g_success = 'N' 
   END IF
   IF g_success = 'Y'
     #THEN LET g_ola.ola40= 'N' LET g_ola.ola12 = g_today   COMMIT WORK         #No.TQC-750041
      THEN LET g_ola.ola40= 'N' LET g_ola.ola12 = null      COMMIT WORK         #No.TQC-750041
      ELSE LET g_ola.ola40= 'Y' LET g_ola.ola12 = l_ola12_o ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_ola.ola40,g_ola.ola12 
   #CKP
   IF g_ola.olaconf ='X' THEN
      LET g_chr='Y'
   ELSE
      LET g_chr='N'
   END IF
   CALL cl_set_field_pic(g_ola.olaconf,"","",g_ola.ola40,g_chr,"")
END FUNCTION
 
FUNCTION t200_3()         #INVOICE查詢
    DEFINE  l_sql   LIKE type_file.chr1000,    #No.FUN-680123 VARCHAR(300),
  	    l_ofa   DYNAMIC ARRAY OF RECORD
	            ofa02 LIKE ofa_file.ofa02,
   		    ofa01 LIKE ofa_file.ofa01,
		    ofa50 LIKE ofa_file.ofa50,
		    ofaconf LIKE ofa_file.ofaconf,     #No.FUN-680123 VARCHAR(1),
		    olc12 LIKE olc_file.olc12,
		    olcconf LIKE olc_file.olcconf,     #No.FUN-680123 VARCHAR(1),
		    olc20 LIKE olc_file.olc20
		    END RECORD,
  	    l_olc11         LIKE olc_file.olc11,
     	    l_ofa23         LIKE ofa_file.ofa23,
            l_tot1,l_tot2   LIKE ofa_file.ofa50,
	    l_tot3          LIKE ofa_file.ofa50,
	    l_n,l_ac,l_sl   LIKE type_file.num5,       #No.FUN-680123 SMALLINT,
	    l_occ           RECORD LIKE occ_file.*,
    	    l_ola04         LIKE ola_file.ola04 
     DEFINE p_row,p_col     LIKE type_file.num5        #No.FUN-680123 SMALLINT
     DEFINE ls_tmp STRING
     DEFINE l_allow_insert  LIKE type_file.num5        #No.FUN-680123 SMALLINT              #可新增否
     DEFINE l_allow_delete  LIKE type_file.num5       #No.FUN-680123 SMALLINT              #可刪除否
 
     
 
   IF cl_null(g_ola.ola04) THEN RETURN END IF
  # OPTIONS INSERT KEY F20
  # OPTIONS DELETE KEY F20
   CALL s_curr3(g_aza.aza17,g_today,g_ooz.ooz17) RETURNING g_rate #取得本幣匯率
   CALL s_curr3(g_ola.ola06,g_ola.ola02,g_ooz.ooz17) RETURNING m_rate #取得L/C幣別匯率
 
   SELECT * INTO l_occ.* FROM occ_file
    WHERE occ01=g_ola.ola05 AND occacti = 'Y'
   IF STATUS THEN 
#     CALL cl_err('sel occ',STATUS,1)  #No.FUN-660116
      CALL cl_err3("sel","occ_file",g_ola.ola05,"",STATUS,"","sel occ",1)  #No.FUN-660116
   END IF
  #FUN-A60056--mod--str--
  #DECLARE ofa_curs CURSOR FOR 
  #   SELECT ofa02,ofa01,ofa50,ofaconf,olc12,olcconf,olc20,olc11,ofa23
  #     FROM ofa_file LEFT OUTER JOIN olc_file ON ofa_file.ofa01=olc_file.olc01 
  #     WHERE ofa61 = g_ola.ola04 
  #      AND ofaconf= 'Y'    #已確認 01/08/06 mandy
  #      AND olcconf= 'Y'    #已確認 01/08/06 mandy
  #    ORDER BY 1,2
   LET g_sql = "SELECT ofa02,ofa01,ofa50,ofaconf,olc12,olcconf,olc20,olc11,ofa23",
               "  FROM ",cl_get_target_table(g_plant,'ofa_file'),
               "  LEFT OUTER JOIN olc_file ON ofa_file.ofa01=olc_file.olc01",
               " WHERE ofa61 = '",g_ola.ola04,"'",
               "   AND ofaconf= 'Y' AND olcconf= 'Y' ",
               "  ORDER BY 1,2 "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
   PREPARE sel_ofa FROM g_sql
   DECLARE ofa_curs CURSOR FOR sel_ofa
  #FUN-A60056--mod--end
   IF STATUS THEN CALL cl_err('ofa_curs',STATUS,1) RETURN END IF
   LET p_row = 6 LET p_col = 20 
   OPEN WINDOW t2001_w AT p_row,p_col
 	 WITH FORM "axr/42f/axrt2001" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axrt2001")
 
   DISPLAY g_ola.ola04 TO FORMONLY.ola04
   CALL cl_opmsg('w')
   CALL l_ofa.clear()
   LET l_ac = 1
   LET l_tot1=0 LET l_tot2=0 LET l_tot3=0
   FOREACH ofa_curs INTO l_ofa[l_ac].*,l_olc11,l_ofa23
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach #1:',SQLCA.sqlcode,1) EXIT FOREACH 
      END IF
      #若出貨幣別不等於信用狀幣別,先將金額轉成本幣,再轉成信用幣別
      IF l_ofa23 != g_ola.ola06 THEN 
         LET l_ofa[l_ac].ofa50 = l_ofa[l_ac].ofa50 * g_rate
         LET l_ofa[l_ac].ofa50 = l_ofa[l_ac].ofa50 / m_rate
         LET l_olc11 = l_olc11 * g_rate
         LET l_olc11 = l_olc11 / m_rate
      END IF
      IF cl_null(l_ofa[l_ac].ofa50) THEN LET l_ofa[l_ac].ofa50=0 END IF
      IF cl_null(l_olc11) THEN LET l_olc11=0 END IF
      LET l_tot1 = l_tot1 + l_ofa[l_ac].ofa50
      IF NOT cl_null(l_ofa[l_ac].olc12) THEN 
         LET l_tot2 = l_tot2 + l_olc11
      END IF
      IF NOT cl_null(l_ofa[l_ac].olc20) THEN 
         LET l_tot3 = l_tot3 + l_olc11
      END IF
      LET l_ac = l_ac + 1
   END FOREACH 
   CALL l_ofa.deleteElement(l_ac)
   LET l_ac=l_ac-1
   DISPLAY l_tot1,l_tot2,l_tot3 TO tot1,tot2,tot3
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   DISPLAY ARRAY l_ofa TO s_ofa.* ATTRIBUTE(COUNT=l_ac)
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END DISPLAY
 
   IF INT_FLAG THEN CLOSE WINDOW t2001_w LET INT_FLAG = 0 RETURN END IF
   CLOSE WINDOW t2001_w
END FUNCTION
 
FUNCTION t200_5() 		  #會計/進出口確認
DEFINE  l_cnt LIKE type_file.num5       #No.FUN-680123 SMALLINT
 
   IF cl_null(g_ola.ola01) THEN RETURN END IF
   IF g_ola.olaconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
   END IF
#MOD-5B0009
   IF g_ola.ola40='Y' THEN
      CALL cl_err('','axr-013',0) RETURN
   END IF
#END MOD-5B0009
   #bugno:7341 add......................................................
   SELECT COUNT(*) INTO l_cnt FROM olb_file
    WHERE olb01= g_ola.ola01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   #bugno:7341 end......................................................
 
   SELECT * INTO g_ola.* FROM ola_file WHERE ola01 = g_ola.ola01
   IF g_ola.ola37 = 'Y' THEN RETURN END IF
   IF NOT cl_confirm('axm-304') THEN RETURN END IF
   #更新確認碼、確認者
   BEGIN WORK 
 
   OPEN t200_cl USING g_ola.ola01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_ola.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ola.ola01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t200_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
##No.      modify 1998/11/05 判斷收狀單號是否存在歷史檔
   {
   SELECT COUNT(*) INTO g_cnt FROM ole_file WHERE ole01 = g_ola.ola01
   IF g_cnt > 0 THEN
      CALL cl_err(g_ola.ola01,'axr-316',1)
   ELSE
      CALL t200_y1()      #產生信用狀歷史資料
   END IF
   }
## ----------------------------------------------------
   UPDATE ola_file SET ola37 = 'Y',ola38 = g_user WHERE ola01 = g_ola.ola01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd olaconf',SQLCA.SQLCODE,1)    #No.FUN-660116
      CALL cl_err3("upd","ola_file",g_ola.ola01,"",SQLCA.sqlcode,"","upd olaconf",1)  #No.FUN-660116
      LET g_ola.ola37 = 'N' 
      LET g_ola.ola38 = g_user  
      ROLLBACK WORK
   ELSE  
      LET g_ola.ola37 = 'Y' 
      LET g_ola.ola38 = g_user  
      COMMIT WORK
      CALL cl_flow_notify(g_ola.ola01,'Y')
   END IF
   DISPLAY BY NAME g_ola.ola37,g_ola.ola38 
END FUNCTION
 
FUNCTION t200_6() 		  #會計/進出口取消確認
 DEFINE l_ola38_o  LIKE   ola_file.ola38  #TQC-B80179 add
  
   IF cl_null(g_ola.ola01) THEN RETURN END IF
   IF g_ola.olaconf = 'X' THEN
      CALL cl_err('','9024',0) RETURN
   END IF
#MOD-5B0009
   IF g_ola.ola40='Y' THEN
      CALL cl_err('','axr-013',0) RETURN
   END IF
#END MOD-5B0009
   SELECT * INTO g_ola.* FROM ola_file WHERE ola01 = g_ola.ola01
   IF g_ola.ola37 = 'N' THEN RETURN END IF
   IF g_ola.olaconf = 'Y' THEN RETURN END IF
   LET g_cnt = 0 
##No.      modify 1998/11/05 若已確認不可再作會計/進出口取消確認
  {
   SELECT COUNT(*) INTO g_cnt FROM ole_file
    WHERE ole01 = g_ola.ola01
      AND oleconf = 'Y'
      AND ole02 > 0 
   IF g_cnt > 0 THEN
      CALL cl_err(g_ola.ola01,'axr-351',1)
      RETURN
   END IF
  }
## -------------------------------------------------------------
   IF NOT cl_confirm('axm-305') THEN RETURN END IF
   BEGIN WORK
 
   OPEN t200_cl USING g_ola.ola01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_ola.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ola.ola01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t200_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
##-------------------------------------------
   LET l_ola38_o = g_ola.ola38  #TQC-B80179 add
   #更新確認碼、確認者
   # UPDATE ola_file SET ola37 = 'N',ola38 = g_user WHERE ola01 = g_ola.ola01  #TQC-B80179 mark
   UPDATE ola_file SET ola37 = 'N',ola38 = '' WHERE ola01 = g_ola.ola01  #TQC-B80179 add
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd olaconf',SQLCA.SQLCODE,1)    #No.FUN-660116
      CALL cl_err3("upd","ola_file",g_ola.ola01,"",SQLCA.sqlcode,"","upd olaconf",1)  #No.FUN-660116
      LET g_ola.ola37 = 'Y' 
  #    LET g_ola.ola38 = g_user  #TQC-B80179 mark
      LET g_ola.ola38 = l_ola38_o  #TQC-B80179 add
      ROLLBACK WORK
   ELSE   
      LET g_ola.ola37 = 'N' 
   #   LET g_ola.ola38 = g_user   #TQC-B80179 mark
      LET g_ola.ola38 = ''  #TQC-B80179 add
      COMMIT WORK
      CALL cl_flow_notify(g_ola.ola01,'Y')
   END IF
   DISPLAY BY NAME g_ola.ola37,g_ola.ola38 
END FUNCTION
 
FUNCTION t200_y() 		  #確認
   DEFINE  l_ola39_o      LIKE ola_file.ola39,
           l_n            LIKE type_file.num10,      #No.FUN-680123 INTEGER,
           l_olb          RECORD LIKE olb_file.*
   DEFINE  l_flag         LIKE type_file.chr1       #No.FUN-740009
   DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-740009
   DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-740009
#  DEFINE  l_oia07        LIKE oia_file.oia07       #FUN-C50136 
#  DEFINE  l_oaz96        LIKE oaz_file.oaz96       #FUN-C50136
  
   LET g_success='Y'
   IF cl_null(g_ola.ola01) THEN RETURN END IF
#MOD-5B0009
   IF g_ola.ola40='Y' THEN
      CALL cl_err('','axr-013',0) RETURN
   END IF
#END MOD-5B0009
   SELECT * INTO g_ola.* FROM ola_file WHERE ola01 = g_ola.ola01
   IF g_ola.olaconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
   END IF
   IF g_ola.olaconf='Y' THEN RETURN END IF
   IF g_ola.ola37 != 'Y' THEN    #若會計/進出口未確認
      CALL cl_err('','axr-330',1) RETURN 
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   LET g_success = 'Y'
#   LET g_t1=g_ola.ola01[1,3]
   CALL s_get_doc_no(g_ola.ola01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
   #No.FUN-740009 --begin
   CALL s_get_bookno(YEAR(g_ola.ola02)) RETURNING l_flag,l_bookno1,l_bookno2
   IF l_flag = '1' THEN
      CALL cl_err(YEAR(g_ola.ola02),'aoo-081',1)
      LET g_success = 'N'
   END IF
   #No.FUN-740009 --end
   #No.FUN-670047--begin
#  IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'N' THEN  #No.FUN-670060
#     CALL s_chknpq(g_ola.ola01,'AR',0)
#  END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'N' THEN  #No.FUN-670060
#     CALL s_chknpq(g_ola.ola01,'AR',0,'0')       #No.FUN-740009
      CALL s_chknpq(g_ola.ola01,'AR',0,'0',l_bookno1)       #No.FUN-740009
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
#        CALL s_chknpq(g_ola.ola01,'AR',0,'1')       #No.FUN-740009
         CALL s_chknpq(g_ola.ola01,'AR',0,'1',l_bookno2)       #No.FUN-740009
      END IF
   END IF
   #No.FUN-670047--end  
   IF g_success='N' THEN RETURN END IF
   BEGIN WORK 
 
   OPEN t200_cl USING g_ola.ola01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_ola.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ola.ola01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t200_cl ROLLBACK WORK RETURN
   END IF
   LET l_ola39_o = g_ola.ola39
 
   #No.FUN-670060  --Begin
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      SELECT COUNT(*) INTO l_n FROM npq_file 
       WHERE npq01= g_ola.ola01
         AND npq00= 41  
         AND npqsys= 'AR'  
         AND npq011= g_ola.ola011
      IF l_n = 0 THEN
#        CALL t200_gen_glcr(g_ola.*,g_ooy.*)       #No.FUN-740009
         CALL t200_gen_glcr(g_ola.*,g_ooy.*,l_bookno1,l_bookno2)       #No.FUN-740009
      END IF
      IF g_success = 'Y' THEN 
         #No.FUN-670047--end  
#        CALL s_chknpq(g_ola.ola01,'AR',0)
#        CALL s_chknpq(g_ola.ola01,'AR',0,'0')       #No.FUN-740009
         CALL s_chknpq(g_ola.ola01,'AR',0,'0',l_bookno1)       #No.FUN-740009
         IF g_aza.aza63 = 'Y' THEN
#           CALL s_chknpq(g_ola.ola01,'AR',0,'1')       #No.FUN-740009
            CALL s_chknpq(g_ola.ola01,'AR',0,'1',l_bookno2)       #No.FUN-740009
         END IF
      #No.FUN-670047--end  
      END IF
      IF g_success = 'N' THEN RETURN END IF #No.FUN-670047
   END IF
   #No.FUN-670060  --End  
 
   #更新確認碼、確認者
   UPDATE ola_file SET olaconf = 'Y',ola39 = g_user WHERE ola01 = g_ola.ola01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd olaconf',SQLCA.SQLCODE,1)   #No.FUN-660116
      CALL cl_err3("upd","ola_file",g_ola.ola01,"",SQLCA.sqlcode,"","upd olaconf",1)  #No.FUN-660116
      LET g_success = 'N'  
   END IF
   #判斷收狀單號是否存在歷史檔
   SELECT COUNT(*) INTO l_n FROM ole_file WHERE ole01 = g_ola.ola01
   IF l_n > 0 THEN 
      CALL cl_err(g_ola.ola01,'axr-316',1) 
   ELSE
      CALL t200_y1()           #產生信用狀歷史資料
   END IF
##No.     modify 1998/12/23
##---------------------------
   CALL s_showmsg()            #NO.FUN-710050  

#  #FUN-C50136---add---str---
#  SELECT oaz96 INTO l_oaz96 FROM oaz_file WHERE oaz00 = '0'
#  IF l_oaz96 = 'Y' THEN
#     CALL s_ccc_oia07('N',g_ola.ola05) RETURNING l_oia07
#     IF NOT cl_null(l_oia07) AND l_oia07 = '0' THEN
#        CALL s_ccc_oia(g_ola.ola05,'N',g_ola.ola01,0,'')
#     END IF
#  END IF
#  #FUN-C50136---add---end--- 
   IF g_success = 'Y'
      THEN LET g_ola.olaconf='Y' LET g_ola.ola39 = g_user    COMMIT WORK
           CALL cl_flow_notify(g_ola.ola01,'Y')
      ELSE LET g_ola.olaconf='N' LET g_ola.ola39 = l_ola39_o ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_ola.olaconf,g_ola.ola39 
   #No.FUN-670060  --Begin
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_ola.ola01,'" AND npp011 = ',g_ola.ola011
#     LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ola.ola02,"' 'Y' '0' 'Y'"   #No.FUN-670047
     #LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ola.ola02,"' 'Y' '0' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"   #No.FUN-670047  #No.MOD-860075
#     LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ola.ola02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"   #No.FUN-670047  #No.MOD-860075 #TQC-810036 mark
      LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_ola.olauser,"' '",g_ola.olauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ola.ola02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"     #TQC-810036
      CALL cl_cmdrun_wait(g_str)
      SELECT ola28,ola33 INTO g_ola.ola28,g_ola.ola33 FROM ola_file
       WHERE ola01 = g_ola.ola01
      DISPLAY BY NAME g_ola.ola28
      DISPLAY BY NAME g_ola.ola33
   END IF
   #No.FUN-670060  --End
   #CKP
   IF g_ola.olaconf ='X' THEN
      LET g_chr='Y'
   ELSE
      LET g_chr='N'
   END IF
   CALL cl_set_field_pic(g_ola.olaconf,"","",g_ola.ola40,g_chr,"")
END FUNCTION
 
FUNCTION t200_y1() 		#產生信用狀歷史資料
     DEFINE  l_olb  RECORD LIKE olb_file.* 

      LET g_ola.ola271 = g_ola.ola271[1,40]   #TQC-630015
      INSERT INTO ole_file(ole01,ole02,ole03,ole04,ole05,ole06,ole07,ole081,
                           ole082,ole083,ole09,ole10,ole11,ole12,ole13,ole14,
                           ole15,ole28,ole29,oleconf,ole30,oleuser,
                           olegrup,oledate,olemodu, #No.TQC-750041
                           olelegal,oleoriu,oleorig,ole31)       #FUN-980011 add   #FUN-A60056 add ole31
                    VALUES(g_ola.ola01,0,g_ola.ola24,g_ola.ola14,g_ola.ola25,
                           g_ola.ola15,g_ola.ola09,g_ola.ola271,g_ola.ola272,
                           g_ola.ola273,g_ola.ola02,0,
                           g_ola.ola07,g_ola.ola32,g_ola.ola33,g_ola.ola28,
                           g_ola.ola06,'Y',g_user,'Y',g_user,
                           g_ola.olauser,g_ola.olagrup,g_ola.oladate,g_ola.olamodu,                          #No.TQC-750041
                           g_legal, g_user, g_grup,g_ola.ola41)       #FUN-980011 add      #No.FUN-980030 10/01/04  insert columns oriu, orig    #FUN-A60056 add ole31
     #No.+041 010330 by plum
     #IF STATUS THEN CALL cl_err('ins ole',STATUS,1) LET g_success='N' END IF
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('ins ole',SQLCA.SQLCODE,1) 
         LET g_success='N' 
      END IF
     #No.+041..end
      DECLARE olb_cur CURSOR FOR 
              SELECT * FROM olb_file WHERE olb01=g_ola.ola01
      CALL s_showmsg_init()                       #NO.FUN-710050  
      IF STATUS THEN CALL cl_err('olb_cur',STATUS,1) LET g_success='N' END IF 
      FOREACH olb_cur INTO l_olb.*
#     IF STATUS THEN CALL cl_err('foreach',STATUS,1) EXIT FOREACH END IF   #NO.FUN-710050
      IF STATUS THEN LET g_success = 'N' CALL s_errmsg('olb01',g_ola.ola01,'foreach',STATUS,1) EXIT FOREACH   END IF #NO.FUN-710050   #No.FUN-8A0086
#NO.FUN-710050--BEGIN                                                           
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
#NO.FUN-710050--END    
         INSERT INTO olf_file(olf01,olf011,olf02,olf03,olf04,olf05,olf06,olf07,
                              olf08,olf11,olflegal) #FUN-980011 add
                       VALUES(l_olb.olb01,0,l_olb.olb02,l_olb.olb03,
                              l_olb.olb04,l_olb.olb05,l_olb.olb06,
                              l_olb.olb07,l_olb.olb08,l_olb.olb11,
                              g_legal)   #FUN-980011 add
        #No.+041 010330 by plum
#         #IF STATUS THEN CALL cl_err('ins olf',STATUS,1) LET g_success='N' 
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('ins olf',SQLCA.SQLCODE,1)   #No.FUN-660116
#           CALL cl_err3("ins","olf_file",l_olb.olb01,l_olb.olb02,SQLCA.sqlcode,"","ins olf",1)  #No.FUN-660116 #NO.FUN-710050
            LET g_showmsg=l_olb.olb01,"/",'0',"/",l_olb.olb02                            #NO.FUN-710050
            CALL s_errmsg('olf01,,olf011,olf02',g_showmsg,'ins olf',SQLCA.SQLCODE,1)     #NO.FUN-710050
            LET g_success='N'
#           EXIT FOREACH                 #NO.FUN-710050
            CONTINUE FOREACH             #NO.FUN-710050
         END IF
        #No.+041..end
      END FOREACH
#NO.FUN-710050--BEGIN                                                           
      IF g_totsuccess="N" THEN                                                        
         LET g_success="N"                                                           
      END IF                                                                          
#NO.FUN-710050--END
END FUNCTION
 
FUNCTION t200_z() 		#取消確認	
   DEFINE  l_ola39_o      LIKE ola_file.ola39
   DEFINE  l_aba19        LIKE aba_file.aba19   #No.FUN-670060
   DEFINE  l_dbs          STRING                #No.FUN-670060
   DEFINE  l_sql          STRING                #No.FUN-670060
   DEFINE  l_n            LIKE type_file.num5   #No.TQC-770046
#  DEFINE  l_oia07        LIKE oia_file.oia07   #FUN-C50136
#  DEFINE  l_oaz96        LIKE oaz_file.oaz96   #FUN-C50136
 
   IF cl_null(g_ola.ola01) THEN RETURN END IF
#MOD-5B0009
   IF g_ola.ola40='Y' THEN
      CALL cl_err('','axr-013',0) RETURN
   END IF
#END MOD-5B0009
   SELECT * INTO g_ola.* FROM ola_file WHERE ola01 = g_ola.ola01
   IF g_ola.olaconf = 'X' THEN
      CALL cl_err('','9024',0) RETURN
   END IF
   IF g_ola.olaconf='N' THEN RETURN END IF
## No.       modify 1998/11/05 若已存在Amend則不可取消確認
   SELECT COUNT(*) INTO g_cnt FROM ole_file
    WHERE ole01 = g_ola.ola01
      AND oleconf = 'Y'
      AND ole02 <> 0
   IF g_cnt > 0 THEN  
      CALL cl_err('','aap-709',1)  #No.8887 
      RETURN
   END IF
  #No.TQC-770046--begin--
  #若已做押匯，則不可取消審核。
   SELECT COUNT(*) INTO l_n FROM olc_file WHERE olc29=g_ola.ola01
   IF l_n > 0 THEN
      CALL cl_err(g_ola.ola01,'axr-039',1)
      RETURN
   END IF
  #No.TQC-770046--end--
   #No.FUN-670060  --Begin
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_ola.ola01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
   IF NOT cl_null(g_ola.ola28) OR NOT cl_null(g_ola.ola33) THEN
      IF NOT (g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y') THEN
         CALL cl_err(g_ola.ola01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      LET g_plant_new=g_ooz.ooz02p 
      #CALL s_getdbs()         #FUN-A50102
      #LET l_dbs=g_dbs_new     #FUN-A50102
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                  "    AND aba01 = '",g_ola.ola28,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre FROM l_sql
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_ola.ola28,'axr-071',1)
         RETURN
      END IF
   END IF
   #No.FUN-670060  --End   
##--------------------------------------------------------
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   LET g_success = 'Y'

   #CHI-C90052 add begin---
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ola.ola28,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT ola28,ola33 INTO g_ola.ola28,g_ola.ola33 FROM ola_file
       WHERE ola01 = g_ola.ola01
      IF NOT cl_null(g_ola.ola28) THEN
         CALL cl_err(g_ola.ola28,'aap-929',1)
         RETURN
      END IF
      DISPLAY BY NAME g_ola.ola28
      DISPLAY BY NAME g_ola.ola33
   END IF
   #CHI-C90052 add end---

   BEGIN WORK 
 
   OPEN t200_cl USING g_ola.ola01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_ola.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ola.ola01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t200_cl ROLLBACK WORK RETURN
   END IF
   LET l_ola39_o = g_ola.ola39
   UPDATE ola_file SET olaconf = 'N',ola39 = g_user WHERE ola01 = g_ola.ola01  #TQC-B80179 mark  #FUN-D20058 remark
 # UPDATE ola_file SET olaconf = 'N',ola39 = '' WHERE ola01 = g_ola.ola01   #TQC-B80179 add      #FUN-D20058 mark
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd olaconf',SQLCA.SQLCODE,1)   #No.FUN-660116
      CALL cl_err3("upd","ola_file",g_ola.ola01,"",SQLCA.sqlcode,"","upd olaconf",1)  #No.FUN-660116
      LET g_success = 'N' 
   END IF
   #-----97/08/25 modify財務取消確認未刪除ole_file(當序號為0時)
    DELETE FROM ole_file WHERE ole01 = g_ola.ola01
                           AND ole02 = 0  #序號
  #IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
   IF STATUS THEN
#     CALL cl_err('del ole',SQLCA.SQLCODE,1)    #No.FUN-660116
      CALL cl_err3("del","ole_file",g_ola.ola01,"",SQLCA.sqlcode,"","del ole",1)  #No.FUN-660116
      LET g_success = 'N' 
   END IF
    DELETE FROM olf_file WHERE olf01 = g_ola.ola01
                           AND olf011= 0  #序號
  #IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN #No.+135 010521 by plum
   IF STATUS THEN
#     CALL cl_err('del olf',SQLCA.SQLCODE,1)    #No.FUN-660116
      CALL cl_err3("del","olf_file",g_ola.ola01,"",SQLCA.sqlcode,"","del olf",1)  #No.FUN-660116
      LET g_success = 'N' 
   END IF
  #----------------------

# #FUN-C50136---add---str---
#  SELECT oaz96 INTO l_oaz96 FROM oaz_file WHERE oaz00 = '0'
#  IF l_oaz96 = 'Y' THEN
#     CALL s_ccc_oia07('N',g_ola.ola05) RETURNING l_oia07
#     IF NOT cl_null(l_oia07) AND l_oia07 = '0' THEN
#        CALL s_ccc_rback(g_ola.ola05,'N',g_ola.ola01,0,'')
#     END IF
#  END IF
#  #FUN-C50136---add---end---

   IF g_success = 'Y'
      THEN LET g_ola.olaconf='N' LET g_ola.ola39 = g_user COMMIT WORK  #TQC-B80179 mark #FUN-D20058 remark
   #  THEN LET g_ola.olaconf='N' LET g_ola.ola39 = '' COMMIT WORK  #TQC-B80179 add      #FUN-D20058 mark
      ELSE LET g_ola.olaconf='Y' LET g_ola.ola39 = l_ola39_o ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_ola.olaconf,g_ola.ola39 

   #CHI-C90052 mark begin---
   ##No.FUN-670060  --Begin
   #IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
   #   LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ola.ola28,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str)
   #   SELECT ola28,ola33 INTO g_ola.ola28,g_ola.ola33 FROM ola_file
   #    WHERE ola01 = g_ola.ola01
   #   DISPLAY BY NAME g_ola.ola28
   #   DISPLAY BY NAME g_ola.ola33
   #END IF
   ##No.FUN-670060  --End   
   #CHI-C90052 mark end---
   
   #CKP
   IF g_ola.olaconf ='X' THEN
      LET g_chr='Y'
   ELSE
      LET g_chr='N'
   END IF
   CALL cl_set_field_pic(g_ola.olaconf,"","",g_ola.ola40,g_chr,"")
END FUNCTION
 
#----- add in 99/05/12 NO:0132 -----
FUNCTION t200_v()
   DEFINE l_wc    LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(100)
   DEFINE l_t1    LIKE type_file.chr3       #No.FUN-680123 VARCHAR(03)
   DEFINE l_ola01 LIKE ola_file.ola01
   DEFINE l_ola02 LIKE ola_file.ola02       #No.FUN-740009
   DEFINE only_one	LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)
   DEFINE p_row,p_col   LIKE type_file.num5       #No.FUN-680123 SMALLINT
   DEFINE ls_tmp STRING
   DEFINE  l_flag         LIKE type_file.chr1       #No.FUN-740009
   DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-740009
   DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-740009
   #------97/06/16 modify
    SELECT * INTO g_ola.* FROM ola_file WHERE ola01 = g_ola.ola01
    IF g_ola.olaconf = 'Y' THEN RETURN END IF
    IF g_ola.olaconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    LET p_row = 7 LET p_col = 32
    OPEN WINDOW t2009_w AT p_row,p_col WITH FORM "axr/42f/axrt2009"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axrt2009")
 
   LET only_one = '1'
   INPUT BY NAME only_one WITHOUT DEFAULTS
     AFTER FIELD only_one
      IF NOT cl_null(only_one) THEN
         IF only_one NOT MATCHES "[12]" THEN NEXT FIELD only_one END IF
      END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t2009_w RETURN END IF
   IF only_one = '1' THEN
      LET l_wc = " ola01 = '",g_ola.ola01,"' "
   ELSE
      CONSTRUCT BY NAME l_wc ON ola11,ola01,ola02,olauser,olagrup,
                                olamodu,oladate               #No.TQC-750041
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
         LET INT_FLAG=0
         CLOSE WINDOW t2009_w
         RETURN
      END IF
   END IF
   CLOSE WINDOW t2009_w
   MESSAGE "WORKING !" 
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz00='0'
   #FUN-B50090 add -end--------------------------
#  LET g_sql = "SELECT ola01 FROM ola_file",       #No.FUN-740009
   LET g_sql = "SELECT ola01,ola02 FROM ola_file",       #No.FUN-740009
               " WHERE ",l_wc CLIPPED
   IF NOT cl_null(g_ooz.ooz09) THEN
      LET g_sql = g_sql CLIPPED," AND ola02 >'",g_ooz.ooz09,"'"
   END IF
   PREPARE t200_v_p FROM g_sql
   DECLARE t200_v_c CURSOR FOR t200_v_p
   LET g_success='Y' #no.5573
   BEGIN WORK #no.5573
   CALL s_showmsg_init()                  #NO.FUN-710050
   FOREACH t200_v_c INTO l_ola01,l_ola02
      IF STATUS THEN LET g_success = 'N' EXIT FOREACH END IF    #No.FUN-8A0086
#      LET l_t1 = l_ola01[1,3]
#NO.FUN-710050--BEGIN                                                           
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
#NO.FUN-710050--END   
      CALL s_get_doc_no(g_ola.ola01) RETURNING l_t1     #No.FUN-550071
      SELECT ooydmy1 INTO g_chr FROM ooy_file
       WHERE ooyslip = l_t1   
      IF g_chr='N' THEN CONTINUE FOREACH END IF
      #No.FUN-740009 --begin
      CALL s_get_bookno(YEAR(l_ola02)) RETURNING l_flag,l_bookno1,l_bookno2
      IF l_flag = '1' THEN
         CALL cl_err(YEAR(l_ola02),'aoo-081',1)
         LET g_success = 'N'
      END IF
      #No.FUN-740009 --end
      #No.FUN-670047--begin
#     CALL s_t200_gl(l_ola01)       #No.FUN-740009
      CALL s_t200_gl(l_ola01,'0',l_bookno1)       #No.FUN-740009
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
#        CALL s_t200_gl(l_ola01,'1')       #No.FUN-740009
         CALL s_t200_gl(l_ola01,'1',l_bookno2)       #No.FUN-740009
      END IF
      #No.FUN-670047--end  
   END FOREACH
#NO.FUN-710050--BEGIN                                                           
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
  CALL s_showmsg()         #NO.FUN-710050 
#NO.FUN-710050--END
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF #no.5573
   MESSAGE ""
END FUNCTION
 
FUNCTION t200_vc()
    IF g_ola.ola01 IS NULL THEN RETURN END IF
    IF g_ola.olaconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
 
    # 2004/05/24 
#   IF NOT cl_prich3(g_ola.olauser,g_ola.olagrup,'U')
    LET g_action_choice="modify"
    IF NOT cl_chk_act_auth() THEN
       LET g_chr='D'
    ELSE
       LET g_chr='U'
    END IF
 
#--- 97-04-23 modify
#   CALL s_fsgl('AR',41,g_ola.ola01,0,g_ooz.ooz02b,g_ola.ola011,g_ola.olaconf)  #No.FUN-670047
    CALL s_showmsg_init()                 #NO.FUN-710050
    CALL s_fsgl('AR',41,g_ola.ola01,0,g_ooz.ooz02b,g_ola.ola011,g_ola.olaconf,'0',g_ooz.ooz02p)  #No.FUN-670047
    CALL s_showmsg()                      #NO.FUN-710050 
END FUNCTION 
#--------(end)
 
#No.FUN-670047--begin 
FUNCTION t200_vc_1()
    IF g_ola.ola01 IS NULL THEN RETURN END IF
    IF g_ola.olaconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
 
    LET g_action_choice="modify"
    IF NOT cl_chk_act_auth() THEN
       LET g_chr='D'
    ELSE
       LET g_chr='U'
    END IF
    CALL s_showmsg_init()                      #NO.FUN-710050
    CALL s_fsgl('AR',41,g_ola.ola01,0,g_ooz.ooz02c,g_ola.ola011,g_ola.olaconf,'1',g_ooz.ooz02p)  #No.FUN-670047
    CALL s_showmsg()                           #NO.FUN-710050
END FUNCTION 
#No.FUN-670047--end   
 
#FUNCTION t200_x() #FUN-D20035 mark
FUNCTION t200_x(p_type) #FUN-D20035 add
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035 add 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_ola.* FROM ola_file WHERE ola01=g_ola.ola01
   IF g_ola.ola01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_ola.olaconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   #FUN-D20035---begin 
    IF p_type = 1 THEN 
       IF g_ola.olaconf='X' THEN RETURN END IF
    ELSE
       IF g_ola.olaconf<>'X' THEN RETURN END IF
    END IF 
   #FUN-D20035---end  
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t200_cl USING g_ola.ola01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_ola.*#鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
   CALL cl_err(g_ola.ola01,SQLCA.sqlcode,0)#資料被他人LOCK
   CLOSE t200_cl ROLLBACK WORK RETURN
   END IF
  #-->作廢轉換01/08/04
  IF cl_void(0,0,g_ola.olaconf)   THEN
     LET g_chr=g_ola.olaconf
     IF g_ola.olaconf ='N' THEN
              LET g_ola.olaconf='X'
          ELSE
              LET g_ola.olaconf='N'
          END IF
     UPDATE ola_file SET olaconf = g_ola.olaconf,olamodu=g_user,oladate=TODAY
            WHERE ola01 = g_ola.ola01
     IF STATUS THEN CALL cl_err('upd olaconf:',STATUS,1) LET g_success='N' END IF
    #-MOD-A90032-add-
     DELETE FROM npp_file WHERE npp01 = g_ola.ola01
                            AND nppsys= 'AR'
                            AND npp00 = 41
                            AND npp011= g_ola.ola011 
     DELETE FROM npq_file WHERE npq01 = g_ola.ola01
                            AND npqsys= 'AR'
                            AND npq00 = 41
                            AND npq011= g_ola.ola011
    #-MOD-A90032-end-
    #FUN-B40056--add--str--
     DELETE FROM tic_file WHERE tic04 = g_ola.ola01
    #FUN-B40056--add--end--
     IF g_success='Y' THEN 
       COMMIT WORK 
       #CKP
       IF g_ola.olaconf ='X' THEN
          LET g_chr='Y'
       ELSE
          LET g_chr='N'
       END IF
       CALL cl_set_field_pic(g_ola.olaconf,"","",g_ola.ola40,g_chr,"")
        CALL cl_flow_notify(g_ola.ola01,'V') 
     ELSE 
        ROLLBACK WORK 
     END IF
     SELECT olaconf INTO g_ola.olaconf FROM ola_file
      WHERE ola01 = g_ola.ola01
     DISPLAY BY NAME g_ola.olaconf 
  END IF
END FUNCTION
 
#No.FUN-670060  --Begin
FUNCTION t200_gen_glcr(p_ola,p_ooy,p_bookno1,p_bookno2)       #No.FUN-740009
  DEFINE p_ola     RECORD LIKE ola_file.*
  DEFINE p_ooy     RECORD LIKE ooy_file.*
  DEFINE p_bookno1 LIKE aza_file.aza81       #No.FUN-740009
  DEFINE p_bookno2 LIKE aza_file.aza82       #No.FUN-740009
 
    IF cl_null(p_ooy.ooygslp) THEN
       CALL cl_err(p_ola.ola01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    #No.FUN-670047--begin
#   CALL s_t200_gl(p_ola.ola01)
#   CALL s_t200_gl(p_ola.ola01,'0')       #No.FUN-740009
    CALL s_t200_gl(p_ola.ola01,'0',p_bookno1)       #No.FUN-740009
    IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
#      CALL s_t200_gl(p_ola.ola01,'1')       #No.FUN-740009
       CALL s_t200_gl(p_ola.ola01,'1',p_bookno2)       #No.FUN-740009
    END IF
    #No.FUN-670047--end  
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t200_carry_voucher()
  DEFINE l_ooygslp    LIKE ooy_file.ooygslp
  DEFINE li_result    LIKE type_file.num5       #No.FUN-680123 SMALLINT 
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5       #No.FUN-680123 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_ola.ola01) RETURNING g_t1
    SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
    IF g_ooy.ooydmy1 = 'N' THEN RETURN END IF
   #IF g_ooy.ooyglcr = 'Y' THEN                                                           #TQC-AB0366 mark
    IF g_ooy.ooyglcr = 'Y' OR (g_ooy.ooyglcr != 'Y' AND NOT cl_null(g_ooy.ooygslp)) THEN  #TQC-AB0366 
       LET g_plant_new=g_ooz.ooz02p 
       #CALL s_getdbs()        #FUN-A50102
       #LET l_dbs=g_dbs_new    #FUN-A50102
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                   "    AND aba01 = '",g_ola.ola28,"'" 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre2 FROM l_sql
       DECLARE aba_cs2 CURSOR FOR aba_pre2 
       OPEN aba_cs2
       FETCH aba_cs2 INTO l_n
       IF l_n > 0 THEN 
          CALL cl_err(g_ola.ola28,'aap-991',1)
          RETURN
       END IF
 
       LET l_ooygslp = g_ooy.ooygslp
    ELSE
       CALL cl_err('','aap-992',1)
       RETURN
 
#      #開窗作業
#      LET g_plant_new= g_ooz.ooz02p
#      CALL s_getdbs()
#      LET g_dbs_gl=g_dbs_new      # 得資料庫名稱
 
#      OPEN WINDOW t200p AT 5,10 WITH FORM "axr/42f/axrt200_p" 
#           ATTRIBUTE (STYLE = g_win_style CLIPPED)
#      CALL cl_ui_locale("axrt200_p")
#       
#      INPUT l_ooygslp WITHOUT DEFAULTS FROM FORMONLY.gl_no
#   
#         AFTER FIELD gl_no
#            CALL s_check_no("agl",l_ooygslp,"","1","aac_file","aac01",g_dbs_gl) #No.FUN-560190
#                  RETURNING li_result,l_ooygslp
#            IF (NOT li_result) THEN
#               NEXT FIELD gl_no
#            END IF
#    
#         AFTER INPUT
#            IF INT_FLAG THEN
#               EXIT INPUT 
#            END IF
#            IF cl_null(l_ooygslp) THEN
#               CALL cl_err('','9033',0)
#               NEXT FIELD gl_no  
#            END IF
#   
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
#         ON ACTION CONTROLG
#            CALL cl_cmdask()
#         ON ACTION CONTROLP
#            IF INFIELD(gl_no) THEN
#               CALL q_m_aac(FALSE,TRUE,g_dbs_gl,l_ooygslp,'1',' ',' ','AGL') 
#               RETURNING l_ooygslp
#               DISPLAY l_ooygslp TO FORMONLY.gl_no
#               NEXT FIELD gl_no
#            END IF
#   
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
#    
#         ON ACTION about         #MOD-4C0121
#            CALL cl_about()      #MOD-4C0121
#    
#         ON ACTION help          #MOD-4C0121
#            CALL cl_show_help()  #MOD-4C0121
#    
#         ON ACTION exit  #加離開功能genero
#            LET INT_FLAG = 1
#            EXIT INPUT
 
#      END INPUT
#      CLOSE WINDOW t200p  
    END IF
    IF cl_null(l_ooygslp) THEN
       CALL cl_err(g_ola.ola01,'axr-070',1)
       RETURN
    END IF
    #No.FUN-670047--begin
    IF g_aza.aza63 = 'Y' AND cl_null(g_ooy.ooygslp1) THEN
       CALL cl_err(g_ola.ola01,'axr-070',1)
       RETURN
    END IF
    #No.FUN-670047--end  
    LET g_wc_gl = 'npp01 = "',g_ola.ola01,'" AND npp011 = ',g_ola.ola011
#   LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",l_ooygslp,"' '",g_ola.ola02,"' 'Y' '0' 'Y'"  #No.FUN-670047
   #LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",l_ooygslp,"' '",g_ola.ola02,"' 'Y' '0' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"  #No.FUN-670047  #No.MOD-860075
#   LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",l_ooygslp,"' '",g_ola.ola02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"  #No.FUN-670047  #No.MOD-860075 #TQC-810036 Mark
    LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_ola.olauser,"' '",g_ola.olauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",l_ooygslp,"' '",g_ola.ola02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"    #TQC-810036
    CALL cl_cmdrun_wait(g_str)
    SELECT ola28,ola33 INTO g_ola.ola28,g_ola.ola33 FROM ola_file
     WHERE ola01 = g_ola.ola01
    DISPLAY BY NAME g_ola.ola28
    DISPLAY BY NAME g_ola.ola33
    
END FUNCTION
 
FUNCTION t200_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_dbs      STRING 
  DEFINE l_sql      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_ola.ola01) RETURNING g_t1                                                                                   
    SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1                                                                          
    IF g_ooy.ooyglcr = 'N' THEN                                                                                                     
       CALL cl_err('','aap-990',1)                                                                                                  
       RETURN                                                                                                                       
    END IF
 
    LET g_plant_new=g_ooz.ooz02p 
    #CALL s_getdbs()       #FUN-A50102
    #LET l_dbs=g_dbs_new   #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                "    AND aba01 = '",g_ola.ola28,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_ola.ola28,'axr-071',1)
       RETURN
    END IF
    LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ola.ola28,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT ola28,ola33 INTO g_ola.ola28,g_ola.ola33 FROM ola_file
     WHERE ola01 = g_ola.ola01
    DISPLAY BY NAME g_ola.ola28
    DISPLAY BY NAME g_ola.ola33
END FUNCTION
#No.FUN-670060  --End   
 

