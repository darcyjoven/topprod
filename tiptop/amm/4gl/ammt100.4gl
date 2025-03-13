# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: ammt100.4gl
# Descriptions...: 開發執行單維護作業 {* 仿 asfi301.4gl *}
# Date & Author..: 00/12/13 By Chien
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4A0248 04/10/19 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0036 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.FUN-4C0060 04/12/08 By pengu Data and Group權限控管
# Modify.........: NO.MOD-420449 05/07/12 BY Yiting key可更改
# Modify.........: No.MOD-580322 05/08/31 By jackie 將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.TQC-610073 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-630010 06/03/08 By saki ammt200參數改變
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660094 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680100 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加                                             
#                                                           g_rec_b初始化命令                                                       
#                                                          "LET g_rec_b =0" 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-710063 07/01/17 By xufeng  查詢多筆資料時，刪除非最后一筆資料后未顯示下一筆        
# Modify.........: No.TQC-720061 07/03/19 By Judy 單身字段"實際QPA"不可小于零
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7A0098 07/10/17 By Pengu 調整TQC-720061修改地方
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-840202 08/05/06 By TSD.liquor 自定欄位功能修改
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-940016 09/04/08 By destiny 在t100_b_mov_back函數中當mmh02值為空時向mmh_file插資料會出錯，需在if判斷里加一個條件
# Modify.........: No.FUN-980004 09/08/28 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990125 09/10/09 By lilingyu "模治具數 應發數量"未控管負數
# Modify.........: No:MOD-A10198 10/02/01 By Smapmin 生產數量不可小於等於0
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-AA0062 10/10/25 By yinhy 倉庫權限使用控管修改 
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AB0056 10/11/12 By houlia 倉庫營運中心權限控管審核段控管
# Modify.........: No.MOD-B50009 11/05/03 by sabrina 追加單身時應將BOM的所有元件都顯示在畫面上
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-910088 11/12/28 By chenjing 增加數量欄位小數取位
# Modify.........: No:FUN-BB0086 11/11/29 By tanxc 增加數量欄位小數取位

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C20192 12/02/24 By ck2yuan 當單身手動新增,部分欄位帶出預設值
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:MOD-C50249 12/05/30 By suncx 手動錄入單身時，項次自動編號錯誤
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30085 12/06/20 By lixiang 串CR報表改GR報表
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.FUN-D40103 13/05/08 By fengrui 添加庫位有效性檢查
# Modify.........: No.TQC-D50124 13/05/28 By lixiang 修正FUN-D40103部份邏輯控管
# Modify.........: No:TQC-DB0070 13/11/26 By wangrr 單身'倉庫''儲位'增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
#模組變數(Module Variables)
DEFINE
    g_mmg   RECORD LIKE mmg_file.*,
    g_mmg_t RECORD LIKE mmg_file.*,
    g_mmg_o RECORD LIKE mmg_file.*,
    g_yy,g_mm       LIKE type_file.num5,          #No.FUN-680100 SMALLINT
    b_mmh   RECORD LIKE mmh_file.*,
    g_ima   RECORD LIKE ima_file.*,
    g_bmb   RECORD LIKE bmb_file.*,
    g_g3de         LIKE type_file.chr4,          #No.FUN-680100 VARCHAR(04)
    g_mmh           DYNAMIC ARRAY OF RECORD      #程式變數(Prinram Variables)
                  mmh27      LIKE mmh_file.mmh27,
                  mmh03      LIKE mmh_file.mmh03,
                  ima02_b    LIKE ima_file.ima02,
                  mmh161     LIKE mmh_file.mmh161,
                  mmh05      LIKE mmh_file.mmh05,
                  mmh12      LIKE mmh_file.mmh12,
                  mmh13      LIKE mmh_file.mmh13,
                  ima08_b    LIKE ima_file.ima08,
                  mmh30      LIKE mmh_file.mmh30,
                  mmh31      LIKE mmh_file.mmh31,
                  #FUN-840202 --start---
                  mmhud01 LIKE mmh_file.mmhud01,
                  mmhud02 LIKE mmh_file.mmhud02,
                  mmhud03 LIKE mmh_file.mmhud03,
                  mmhud04 LIKE mmh_file.mmhud04,
                  mmhud05 LIKE mmh_file.mmhud05,
                  mmhud06 LIKE mmh_file.mmhud06,
                  mmhud07 LIKE mmh_file.mmhud07,
                  mmhud08 LIKE mmh_file.mmhud08,
                  mmhud09 LIKE mmh_file.mmhud09,
                  mmhud10 LIKE mmh_file.mmhud10,
                  mmhud11 LIKE mmh_file.mmhud11,
                  mmhud12 LIKE mmh_file.mmhud12,
                  mmhud13 LIKE mmh_file.mmhud13,
                  mmhud14 LIKE mmh_file.mmhud14,
                  mmhud15 LIKE mmh_file.mmhud15
                  #FUN-840202 --end--
                    END RECORD,
    g_mmh_t         RECORD
                  mmh27      LIKE mmh_file.mmh27,
                  mmh03      LIKE mmh_file.mmh03,
                  ima02_b    LIKE ima_file.ima02,
                  mmh161     LIKE mmh_file.mmh161,
                  mmh05      LIKE mmh_file.mmh05,
                  mmh12      LIKE mmh_file.mmh12,
                  mmh13      LIKE mmh_file.mmh13,
                  ima08_b    LIKE ima_file.ima08,
                  mmh30      LIKE mmh_file.mmh30,
                  mmh31      LIKE mmh_file.mmh31,
                  #FUN-840202 --start---
                  mmhud01 LIKE mmh_file.mmhud01,
                  mmhud02 LIKE mmh_file.mmhud02,
                  mmhud03 LIKE mmh_file.mmhud03,
                  mmhud04 LIKE mmh_file.mmhud04,
                  mmhud05 LIKE mmh_file.mmhud05,
                  mmhud06 LIKE mmh_file.mmhud06,
                  mmhud07 LIKE mmh_file.mmhud07,
                  mmhud08 LIKE mmh_file.mmhud08,
                  mmhud09 LIKE mmh_file.mmhud09,
                  mmhud10 LIKE mmh_file.mmhud10,
                  mmhud11 LIKE mmh_file.mmhud11,
                  mmhud12 LIKE mmh_file.mmhud12,
                  mmhud13 LIKE mmh_file.mmhud13,
                  mmhud14 LIKE mmh_file.mmhud14,
                  mmhud15 LIKE mmh_file.mmhud15
                  #FUN-840202 --end--
                    END RECORD,
    g_mmh29         ARRAY[400] OF LIKE mmh_file.mmh29,
    g_mmh11         ARRAY[400] OF LIKE mmh_file.mmh11,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_t1            LIKE type_file.chr3,          #No.FUN-680100 VARCHAR(03)
    g_ecu01         LIKE ecu_file.ecu01,
    g_buf           LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(20)
    g_rec_b         LIKE type_file.num5,          #單身筆數        #No.FUN-680100 SMALLINT
 #  g_pmn01         LIKE apm_file.apm08,          #No.FUN-680100 # P/O No    #No.TQC-6A0079
    p_row,p_col     LIKE type_file.num5,          #No.FUN-680100 SMALLINT
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT        #No.FUN-680100 SMALLINT
 DEFINE g_before_input_done  LIKE type_file.num5    #MOD-420449               #No.FUN-680100 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680100 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680100 INTEGER
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680100 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680100 SMALLINT
DEFINE g_argv1     LIKE mmg_file.mmg01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
DEFINE g_mmg23_t   LIKE mmg_file.mmg23     #FUN-910088--add--
DEFINE g_mmh12_t   LIKE mmh_file.mmh12     #No.FUN-BB0086
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8          #No.FUN-6A0076
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
   LET p_row = 2 LET p_col = 2
   OPEN WINDOW t100_w AT p_row,p_col WITH FORM "amm/42f/ammt100"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t100_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t100_a()
            END IF
         OTHERWISE        
            CALL t100_q() 
      END CASE
   END IF
   #--
 
   CALL t100()
   CLOSE WINDOW t100_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
 
END MAIN
 
FUNCTION t100()
  DEFINE l_za05    LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(40)
 
   LET g_forupd_sql = "SELECT * FROM mmg_file WHERE mmg01 = ? AND mmg02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t100_cl CURSOR FROM g_forupd_sql
 
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
   CALL t100_menu()
 
END FUNCTION
 
FUNCTION t100_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_mmh.clear()
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_mmg.* TO NULL    #No.FUN-750051
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" mmg01='",g_argv1,"'"       #FUN-7C0050
      LET g_wc2=" 1=1"                      #FUN-7C0050
   ELSE
   CONSTRUCT BY NAME g_wc ON mmg01,mmg02,mmg03,mmg05,mmg06,mmg07,mmg04,
                             mmg23,mmg21,mmg09,mmg10,mmg11,mmg12,mmg121,mmg13,
                             mmg15,mmg16,mmg20,mmg22,mmgacti,mmg14,mmg08,mmg17,mmg18,mmg19,
                             mmguser,mmggrup,mmgmodu,mmgdate,
                             #FUN-840202   ---start---
                             mmgud01,mmgud02,mmgud03,mmgud04,mmgud05,
                             mmgud06,mmgud07,mmgud08,mmgud09,mmgud10,
                             mmgud11,mmgud12,mmgud13,mmgud14,mmgud15
                             #FUN-840202    ----end----
 
       #--No.MOD-4A0248--------
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
        CASE
             WHEN INFIELD(mmg04) #料件編號
#FUN-AA0059 --Begin--
              #    CALL cl_init_qry_var()
              #    LET g_qryparam.state= "c"
              #    LET g_qryparam.form = "q_ima"
      	      #    CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
      	          DISPLAY g_qryparam.multiret TO mmg04
      	          NEXT FIELD mmg04
             WHEN INFIELD(mmg21) #製品料件
#FUN-AA0059 --Begin--
              #    CALL cl_init_qry_var()
              #    LET g_qryparam.state= "c"
              #    LET g_qryparam.form = "q_ima"
              #    CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO mmg21
                  NEXT FIELD mmg21
            WHEN INFIELD(mmg05) #工作性質
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_mmi"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO mmg05
                  NEXT FIELD mmg05
            WHEN INFIELD(mmg09) #承製單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO mmg09
                  NEXT FIELD mmg09
            WHEN INFIELD(mmg15) #入庫倉庫
#No.FUN-AA0062  --start--
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state= "c"
#                 LET g_qryparam.form = "q_imd"
#                 LET g_qryparam.arg1     = 'SW'
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_imd_1(TRUE,TRUE,g_mmg.mmg15,"SW","","","")
                    RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO mmg15
                  NEXT FIELD mmg15
            #No.FUN-AA0062  --end--
            WHEN INFIELD(mmg16) #入庫儲位
            #No.FUN-AA0062  --start--
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= "c"
#                  LET g_qryparam.form = "q_ime"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_ime_1(TRUE,TRUE,g_mmg.mmg16,"","","","","","")
                     RETURNING g_qryparam.multiret
            #No.FUN-AA0062  --end--
                  DISPLAY g_qryparam.multiret TO mmg16
                  NEXT FIELD mmg16
         OTHERWISE EXIT CASE
         END CASE
      #--END---------------
 
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
   IF INT_FLAG THEN
      RETURN
   END IF
 
 
 
   CONSTRUCT g_wc2 ON mmh27,mmh03,mmh161,mmh05,mmh12,mmh13,mmh30,mmh31
                      #No.FUN-840202 --start--
                      ,mmhud01,mmhud02,mmhud03,mmhud04,mmhud05
                      ,mmhud06,mmhud07,mmhud08,mmhud09,mmhud10
                      ,mmhud11,mmhud12,mmhud13,mmhud14,mmhud15
                      #No.FUN-840202 ---end---
                 FROM s_mmh[1].mmh27,s_mmh[1].mmh03,s_mmh[1].mmh161,
                      s_mmh[1].mmh05,s_mmh[1].mmh12,s_mmh[1].mmh13,
                      s_mmh[1].mmh30,s_mmh[1].mmh31
                      #No.FUN-840202 --start--
                      ,s_mmh[1].mmhud01,s_mmh[1].mmhud02,s_mmh[1].mmhud03,s_mmh[1].mmhud04,s_mmh[1].mmhud05
                      ,s_mmh[1].mmhud06,s_mmh[1].mmhud07,s_mmh[1].mmhud08,s_mmh[1].mmhud09,s_mmh[1].mmhud10
                      ,s_mmh[1].mmhud11,s_mmh[1].mmhud12,s_mmh[1].mmhud13,s_mmh[1].mmhud14,s_mmh[1].mmhud15
                      #No.FUN-840202 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      #TQC-DB0070--add--end
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(mmh27)
                 CALL q_sel_ima(TRUE,"q_ima","","","","","","","",'')
                      RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO mmh27
                 NEXT FIELD mmh27
              WHEN INFIELD(mmh03)
                 CALL q_sel_ima(TRUE,"q_ima","","","","","","","",'')
                      RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO mmh03
                 NEXT FIELD mmh03
              WHEN INFIELD(mmh30)
                 CALL q_imd_1(TRUE,TRUE,"","SW","","","")
                    RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO mmh30
                 NEXT FIELD mmh30
              WHEN INFIELD(mmh31)
                 CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","")
                     RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO mmh31
                 NEXT FIELD mmh31
           END CASE
      #TQC-DB0070--add--end
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
  END IF  #FUN-7C0050
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND mmguser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND mmggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND mmggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('mmguser', 'mmggrup')
   #End:FUN-980030
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT mmg02, mmg01 FROM mmg_file",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY mmg01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT DISTINCT mmg_file.mmg02, mmg01 ",
                  "  FROM mmg_file, mmh_file",
                  " WHERE mmg01 = mmh01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY mmg01"
   END IF
 
   PREPARE t100_prepare FROM g_sql
   DECLARE t100_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t100_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM mmg_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT mmg01) FROM mmg_file,mmh_file WHERE ",
                "mmh01=mmg01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t100_precount FROM g_sql
   DECLARE t100_count CURSOR FOR t100_precount
 
END FUNCTION
 
FUNCTION t100_menu()
 
   WHILE TRUE
      CALL t100_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t100_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t100_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t100_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t100_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t100_b('A')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t100_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "gen_allotment"
            IF cl_chk_act_auth() THEN
               CALL t100_cralc()
            END IF
         WHEN "delete_allotment"
            IF cl_chk_act_auth() THEN
               CALL t100_dealc()
            END IF
         WHEN "close_the_case"
            IF cl_chk_act_auth() THEN
               CALL t100_1()
            END IF
         WHEN "add_detail"
            IF cl_chk_act_auth() THEN
               CALL t100_2()
            END IF
         WHEN "calculate_expense"
            IF cl_chk_act_auth() THEN
               CALL t100_3()
            END IF
         WHEN "other_expense"
            IF cl_chk_act_auth() THEN
               LET g_msg="ammt100_a '", g_mmg.mmg01,"' '", g_mmg.mmg02,"' "
               #CALL cl_cmdrun(g_msg CLIPPED)       #FUN-660162 remark
               CALL cl_cmdrun_wait(g_msg CLIPPED)   #FUN-660162 add
            END IF
         WHEN "qry_requisition_note"
            IF cl_chk_act_auth() THEN
               LET g_msg="ammt200 ' ' ' ' '",g_mmg.mmg01,"' '",g_mmg.mmg02,"' "
               #CALL cl_cmdrun(g_msg CLIPPED)      #FUN-660216 remark
               CALL cl_cmdrun_wait(g_msg CLIPPED)  #FUN-660216 add
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t100_firm1()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t100_firm2()
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t100_x()    #CHI-D20010
               CALL t100_x(1)   #CHI-D20010
            END IF
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t100_x(2)
            END IF 
         #CHI-D20010---end
         WHEN "exporttoexcel"     #FUN-4B0036
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mmh),'','')
            END IF
         #No.FUN-6B0079-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_mmg.mmg01 IS NOT NULL THEN
                 LET g_doc.column1 = "mmg01"
                 LET g_doc.value1 = g_mmg.mmg01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0079-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t100_a()
    DEFINE l_sfc      RECORD LIKE sfc_file.*
    DEFINE l_sfd      RECORD LIKE sfd_file.*
 
   IF s_ammshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_mmh.clear()
   INITIALIZE g_mmg.* TO NULL
   LET g_mmg_o.* = g_mmg.*
   LET g_mmg_t.* = g_mmg.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_mmg.mmg06   = TODAY
      LET g_mmg.mmg09   = g_grup
      LET g_mmg.mmg10   = 0
      LET g_mmg.mmg11   = 0
      LET g_mmg.mmg13   = TODAY
      LET g_mmg.mmg14   = 'N'
      LET g_mmg.mmgacti = 'N'
      LET g_mmg.mmguser = g_user
      LET g_mmg.mmgoriu = g_user #FUN-980030
      LET g_mmg.mmgorig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_mmg.mmggrup = g_grup
      LET g_mmg.mmgdate = TODAY
      LET g_mmg.mmgplant = g_plant #FUN-980004 add
      LET g_mmg.mmglegal = g_legal #FUN-980004 add
 
      CALL get_mmg09() RETURNING g_buf
      DISPLAY g_buf TO gem02
      BEGIN WORK
 
      CALL t100_i("a")                #輸入單頭
 
      IF INT_FLAG THEN
         LET INT_FLAG=0 CALL cl_err('',9001,0)
         INITIALIZE g_mmg.* TO NULL
         ROLLBACK WORK
         EXIT WHILE
      END IF
 
      IF (g_mmg.mmg01 IS NULL OR g_mmg.mmg02 IS NULL ) THEN
         CONTINUE WHILE
      END IF
 
      INSERT INTO mmg_file VALUES (g_mmg.*)
      IF STATUS THEN
#         CALL cl_err('ins mmg:',STATUS,1)    #NO.FUN-660094 
          CALL cl_err3("ins","mmg_file",g_mmg.mmg01,g_mmg.mmg02,STATUS,"","ins mmg:",1)  #NO.FUN-660094
         CONTINUE WHILE
      END IF
 
      COMMIT WORK
      SELECT mmg01 INTO g_mmg.mmg01 FROM mmg_file
       WHERE mmg01 = g_mmg.mmg01 AND mmg02 = g_mmg.mmg02
 
      LET g_mmg_t.* = g_mmg.*
      LET g_rec_b =0        #NO.FUN-680064
      CALL g_mmh.clear()
      IF g_sma.sma27='1' THEN
         CALL t100_cralc()
         CALL t100_b('A')
      END IF
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t100_u()
DEFINE
    l_cnt  LIKE type_file.num10         #No.FUN-680100 #INTEGER vic  00/11/28
 
   IF s_ammshut(0) THEN RETURN END IF
 
   IF g_mmg.mmg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_mmg.* FROM mmg_file
    WHERE mmg01 = g_mmg.mmg01
      AND mmg02 = g_mmg.mmg02
 
   IF g_mmg.mmgacti = 'X' THEN
      CALL cl_err('','aap-127',1)
      RETURN
   END IF
 
   IF g_mmg.mmg14 = 'Y' THEN
      CALL cl_err('','aap-197',1)
      RETURN
   END IF
 
   IF g_mmg.mmgacti = 'Y' THEN
      CALL cl_err('','aap-086',1)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_mmg_o.* = g_mmg.*
   LET g_mmg23_t = g_mmg.mmg23    #FUN-910088--add--
   BEGIN WORK
 
   OPEN t100_cl USING g_mmg.mmg01,g_mmg.mmg02
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t100_cl INTO g_mmg.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock mmg:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t100_show()
   WHILE TRUE
      LET g_mmg.mmgmodu=g_user
      LET g_mmg.mmgdate=g_today
      CALL t100_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_mmg.*=g_mmg_t.*
         CALL t100_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      UPDATE mmg_file SET * = g_mmg.* WHERE mmg01=g_mmg_t.mmg01 AND mmg02=g_mmg_t.mmg02
      IF STATUS THEN
#         CALL cl_err(g_mmg.mmg01,STATUS,0) #No.FUN-660094
          CALL cl_err3("upd","mmg_file",g_mmg.mmg01,g_mmg.mmg02,STATUS,"","",1)       #NO.FUN-660094
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t100_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t100_i(p_cmd)
  DEFINE p_cmd          LIKE type_file.chr1          #a:輸入 u:更改        #No.FUN-680100 VARCHAR(1)
  DEFINE g_flag         LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
  DEFINE l_str1,l_str2  STRING    #No.MOD-580322
  DEFINE l_case     STRING        #FUN-910088--add--
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT BY NAME g_mmg.mmg01,g_mmg.mmg02,g_mmg.mmg03,g_mmg.mmg05,g_mmg.mmg06, g_mmg.mmgoriu,g_mmg.mmgorig,
                 g_mmg.mmg07,g_mmg.mmg04,g_mmg.mmg23,g_mmg.mmg21,
                 g_mmg.mmg09,g_mmg.mmg10,g_mmg.mmg11,g_mmg.mmg12,g_mmg.mmg121,
                 g_mmg.mmg13,g_mmg.mmg15,g_mmg.mmg16,g_mmg.mmg20,g_mmg.mmg22,
                 g_mmg.mmgacti,g_mmg.mmg14,g_mmg.mmg17,g_mmg.mmg18,g_mmg.mmg19,
                 g_mmg.mmguser,g_mmg.mmggrup,g_mmg.mmgmodu,g_mmg.mmgdate,
                 #FUN-840202     ---start---
                 g_mmg.mmgud01,g_mmg.mmgud02,g_mmg.mmgud03,g_mmg.mmgud04,
                 g_mmg.mmgud05,g_mmg.mmgud06,g_mmg.mmgud07,g_mmg.mmgud08,
                 g_mmg.mmgud09,g_mmg.mmgud10,g_mmg.mmgud11,g_mmg.mmgud12,
                 g_mmg.mmgud13,g_mmg.mmgud14,g_mmg.mmgud15 
                 #FUN-840202     ----end----
       WITHOUT DEFAULTS
 
     #MOD-420449
     BEFORE INPUT
      #FUN-910088--add--start--
        IF p_cmd = 'a' THEN
           LET g_mmg23_t = NULL
        END IF
      #FUN-910088--add--end--
        LET g_before_input_done = FALSE
        CALL t100_set_entry(p_cmd)
        CALL t100_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
     #--END
 
       #BEFORE FIELD mmg01   #MOD-420449
      #   IF p_cmd = 'u' THEN NEXT FIELD mmg03 END IF
 
      AFTER FIELD mmg02
         IF NOT cl_null(g_mmg.mmg02) THEN
            IF (g_mmg.mmg01 != g_mmg_t.mmg01 OR g_mmg_t.mmg01 IS NULL ) OR
              (g_mmg.mmg02 != g_mmg_t.mmg02 OR g_mmg_t.mmg02 IS NULL ) THEN
               SELECT COUNT(*) INTO g_cnt FROM mmg_file
                WHERE mmg01 = g_mmg.mmg01
                  AND mmg02 = g_mmg.mmg02
               IF g_cnt > 0 THEN   #資料重複
                  CALL cl_err(g_mmg.mmg02,-239,0)
                  LET g_mmg.mmg01 = g_mmg_t.mmg01
                  LET g_mmg.mmg02 = g_mmg_t.mmg02
                  DISPLAY BY NAME g_mmg_t.mmg01,g_mmg.mmg02
                  NEXT FIELD mmg01
               END IF
            END IF
         END IF
 
      AFTER FIELD mmg03
         IF NOT cl_null(g_mmg.mmg03) THEN
            CALL get_g3de() RETURNING g_g3de
            DISPLAY g_g3de TO g3de
         END IF
 
      AFTER FIELD mmg04
         IF NOT cl_null(g_mmg.mmg04) THEN
           #FUN-AA0059 ------------------add start--------------
            IF NOT s_chk_item_no(g_mmg.mmg04,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD mmg04
            END IF
           #FUN-AA0059 -----------------add end------------------ 
            IF (g_mmg.mmg04 != g_mmg_t.mmg04 OR g_mmg_t.mmg04 IS NULL) THEN
               SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_mmg.mmg04
               IF STATUS THEN
#                  CALL cl_err('sel ima',STATUS,1) #No.FUN-660094
                   CALL cl_err3("sel","ima_file",g_mmg.mmg04,"",STATUS,"","sel ima",1)       #NO.FUN-660094
                  NEXT FIELD mmg04
               END IF
               IF g_ima.imaacti = 'N' THEN
                  CALL cl_err(g_mmg.mmg04,'9028',0)
                  NEXT FIELD mmg04
               END IF
               IF g_ima.ima08 MATCHES "[ACDZ]" THEN
#No.MOD-580322 --start--
                  CALL cl_getmsg('amm1001',g_lang) RETURNING l_str1
                  ERROR l_str1
#                  ERROR "此料件不可制作模治具,請檢查來源碼不可為ACDZ"
                  NEXT FIELD mmg04
               END IF
               IF g_ima.ima08 MATCHES "[XP]" THEN
                  CALL cl_getmsg('amm1002',g_lang) RETURNING l_str2
                  ERROR l_str2
#                  ERROR "注意 !!! 此料件為虛擬料件或為采購料件 "
#No.MOD-580322 --end--
               END IF
               LET g_mmg.mmg15 = g_mmd.mmd16
               LET g_mmg.mmg23 = g_ima.ima55
           #FUN-910088--add--start--
               LET l_case = NULL
               IF NOT t100_mmg10_check() THEN 
                  LET l_case = 'mmg10'
               END IF
               IF NOT t100_mmg11_check() THEN
                  LET l_case = 'mmg11'
               END IF
           #FUN-910088--add--end--
               DISPLAY g_ima.ima02,g_mmg.mmg15,g_mmg.mmg23 TO ima02,mmg15,mmg23
           #FUN-910088--add--start--
               LET g_mmg23_t = g_mmg.mmg23
               CASE l_case
                  WHEN "mmg10"
                     NEXT FIELD mmg10
                  WHEN "mmg11"
                     NEXT FIELD mmg11
                  OTHERWISE EXIT CASE
               END CASE
            #FUN-910088--add--end--
            END IF
         END IF
 
      AFTER FIELD mmg05
         IF NOT cl_null(g_mmg.mmg05) THEN
            SELECT mmi02 INTO g_buf FROM mmi_file
             WHERE mmi01 = g_mmg.mmg05  AND mmi03 = '1'
            IF STATUS THEN
#               CALL cl_err('sel mmi',STATUS,0)  #No.FUN-660094
                CALL cl_err3("sel","mmi_file",g_mmg.mmg05,"",STATUS,"","sel mmi",1)       #NO.FUN-660094
               NEXT FIELD mmg05
            END IF
            ERROR g_buf
         END IF
 
      AFTER FIELD mmg09
         IF NOT cl_null(g_mmg.mmg09) THEN
            CALL get_mmg09() RETURNING g_buf
            IF cl_null(g_buf) THEN
               CALL cl_err(g_mmg.mmg09,100,0)
               NEXT FIELD mmg09
            END IF
            DISPLAY g_buf TO gem02
         END IF
 
      BEFORE FIELD mmg10
         IF p_cmd = 'u' THEN
            SELECT COUNT(*) INTO g_cnt FROM mmh_file
             WHERE mmh01 = g_mmg.mmg01
               AND mmh011 = g_mmg.mmg02
            IF g_cnt > 0 THEN
               NEXT FIELD mmg11
            END IF
         END IF
 
      AFTER FIELD mmg10
         IF NOT t100_mmg10_check() THEN NEXT FIELD mmg10 END IF    #FUN-910088--add--
#FUN-910088--mark--start--
#        IF NOT cl_null(g_mmg.mmg10) THEN
#           IF g_mmg.mmg10=0 THEN NEXT FIELD mmg10 END IF
#TQC-990125 --begin--
#           IF g_mmg.mmg10 < 0 THEN 
#              CALL cl_err('','aec-020',0)
#              NEXT FIELD mmg10
#           END IF 
#TQC-990125 --end--            
#           # --------(check 最小生產數量) ---
#           IF g_ima.ima561 > 0 THEN #生產單位批量&最少生產數量
#              IF g_mmg.mmg10 < g_ima.ima561 THEN
#                 CALL cl_err(g_ima.ima561,'amm-307',0)
#              END IF
#           END IF
#           IF NOT cl_null(g_ima.ima56) AND g_ima.ima56>0  THEN #生產單位批量
#              IF (g_mmg.mmg10 MOD g_ima.ima56) > 0 THEN
#                 CALL cl_err(g_ima.ima56,'amm-308',0)
#              END IF
#           END IF
#        END IF
#FUN-910088--mark--end--
 
      AFTER FIELD mmg11
         IF NOT t100_mmg11_check() THEN NEXT FIELD mmg11 END IF    #FUN-910088--add--
     #FUN-910088--mark--start--
     #   IF NOT cl_null(g_mmg.mmg11) THEN
     #      IF g_mmg.mmg11 < 0 THEN
     #         NEXT FIELD mmg11
     #      END IF
     #   END IF
     #FUN-910088--mark--end--
 
      AFTER FIELD mmg15
         IF NOT cl_null(g_mmg.mmg15) THEN
            SELECT * FROM imd_file WHERE imd01=g_mmg.mmg15
                                      AND imdacti = 'Y' #MOD-4B0169
            IF STATUS THEN         
#               CALL cl_err('sel imd:',STATUS,2) #No.FUN-660094
                CALL cl_err3("sel","imd_file",g_mmg.mmg15,"",STATUS,"","sel imd",1)       #NO.FUN-660094
               NEXT FIELD mmg15
            END IF
         #No.FUN-AA0062 --start--
            IF NOT s_chk_ware(g_mmg.mmg15) THEN
               NEXT FIELD mmg15
            END IF
         #No.FUN-AA0062 --end--
         END IF
	 IF NOT s_imechk(g_mmg.mmg15,g_mmg.mmg16) THEN NEXT FIELD mmg16 END IF  #FUN-D40103 add
 
      AFTER FIELD mmg16
	 #FUN-D40103--mark--str--
        # IF NOT cl_null(g_mmg.mmg16) THEN
        #    SELECT * FROM ime_file
        #     WHERE ime01 = g_mmg.mmg15 AND ime02 = g_mmg.mmg16
        #    IF STATUS THEN
#       #        CALL cl_err('sel imd:',STATUS,2) #No.FUN-660094
        #        CALL cl_err3("sel","ime_file",g_mmg.mmg15,g_mmg.mmg16,STATUS,"","sel imd",1)       #NO.FUN-660094
        #       NEXT FIELD mmg16
        #    END IF
        # END IF
	#FUN-D40103--mark--end--
         IF cl_null(g_mmg.mmg16) THEN LET g_mmg.mmg16 = ' ' END IF              #FUN-D40103 add 
         IF NOT s_imechk(g_mmg.mmg15,g_mmg.mmg16) THEN NEXT FIELD mmg16 END IF  #FUN-D40103 add 
      AFTER FIELD mmg21
         IF NOT cl_null(g_mmg.mmg21) THEN
           #FUN-AA0059 ----------------add start---------------
            IF NOT s_chk_item_no(g_mmg.mmg21,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD mmg21
            END IF
           #FUN-AA0059 -------------------add end--------------
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_mmg.mmg21
            IF STATUS THEN
#               CALL cl_err('sel ima',STATUS,1) #No.FUN-660094
                CALL cl_err3("sel","ima_file",g_mmg.mmg21,"",STATUS,"","sel ima",1)       #NO.FUN-660094
               NEXT FIELD mmg21
            END IF
            IF g_ima.imaacti = 'N' THEN
               CALL cl_err(g_mmg.mmg21,'9028',0)
               NEXT FIELD mmg21
            END IF
         END IF
 
      #FUN-840202     ---start---
      AFTER FIELD mmgud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmgud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmgud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmgud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmgud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmgud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmgud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmgud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmgud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmgud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmgud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmgud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmgud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmgud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmgud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-840202     ----end----
 
      AFTER INPUT
         LET g_mmg.mmguser = s_get_data_owner("mmg_file") #FUN-C10039
         LET g_mmg.mmggrup = s_get_data_group("mmg_file") #FUN-C10039
         LET g_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_mmg.mmg03 IS NULL THEN
            LET g_flag='Y'
            DISPLAY BY NAME g_mmg.mmg03
         END IF
         IF g_mmg.mmg04 IS NULL THEN
            LET g_flag='Y'
            DISPLAY BY NAME g_mmg.mmg04
         END IF
         IF g_mmg.mmg05 IS NULL THEN
            LET g_flag='Y'
            DISPLAY BY NAME g_mmg.mmg05
         END IF
         IF g_mmg.mmg07 IS NULL THEN
            LET g_flag='Y'
            DISPLAY BY NAME g_mmg.mmg07
         END IF
         IF g_mmg.mmg15 IS NULL THEN
            LET g_flag='Y'
            DISPLAY BY NAME g_mmg.mmg15
         END IF
         IF g_mmg.mmg16 IS NULL THEN LET g_mmg.mmg16 = ' ' END IF
         IF g_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD mmg01
         END IF
         #-----MOD-A10198---------
         IF g_mmg.mmg10<=0 THEN 
            CALL cl_err('','aec-042',0)                                      
            NEXT FIELD mmg10
         END IF
         #-----END MOD-A10198-----
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(mmg04)
#FUN-AA0059 --Begin--
           #   #CALL q_ima(10,2,g_mmg.mmg04) RETURNING g_mmg.mmg04
           #    CALL cl_init_qry_var()
           #    LET g_qryparam.form     = "q_ima"
           #    LET g_qryparam.default1 = g_mmg.mmg04
           #    CALL cl_create_qry() RETURNING g_mmg.mmg04
#          #     CALL FGL_DIALOG_SETBUFFER( g_mmg.mmg04 )
               CALL q_sel_ima(FALSE, "q_ima", "", g_mmg.mmg04, "", "", "", "" ,"",'' )  RETURNING g_mmg.mmg04
#FUN-AA0059 --End--
               DISPLAY BY NAME g_mmg.mmg04
               NEXT FIELD mmg04
            WHEN INFIELD(mmg05)
              #CALL q_mmi(0,0,g_mmg.mmg05,'1') RETURNING g_mmg.mmg05
               CALL cl_init_qry_var()
               LET g_qryparam.form     ="q_mmi"
               LET g_qryparam.default1 = g_mmg.mmg05
                LET g_qryparam.where    = " mmi03 = '1' "  #No.MOD-470520
               CALL cl_create_qry() RETURNING g_mmg.mmg05
#               CALL FGL_DIALOG_SETBUFFER( g_mmg.mmg05 )
               DISPLAY BY NAME g_mmg.mmg05  #NO:6876
               NEXT FIELD mmg05
            WHEN INFIELD(mmg09) #item
              #CALL q_gem(10,2,g_mmg.mmg09) RETURNING g_mmg.mmg09
               CALL cl_init_qry_var()
               LET g_qryparam.form     ="q_gem"
               LET g_qryparam.default1 = g_mmg.mmg09
               CALL cl_create_qry() RETURNING g_mmg.mmg09
#               CALL FGL_DIALOG_SETBUFFER( g_mmg.mmg09 )
               DISPLAY BY NAME g_mmg.mmg09
               NEXT FIELD mmg09
            WHEN INFIELD(mmg15) #item
              #CALL q_imd(0,0,g_mmg.mmg15,'A') RETURNING g_mmg.mmg15
            #No.FUN-AA0062  --start--
            #   CALL cl_init_qry_var()
            #   LET g_qryparam.form     ="q_imd"
            #   LET g_qryparam.default1 = g_mmg.mmg15
            #   #LET g_qryparam.arg1     = "A"         #MOD-4A0213
            #    LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
            #   CALL cl_create_qry() RETURNING g_mmg.mmg15
#               CALL FGL_DIALOG_SETBUFFER( g_mmg.mmg15 )
               CALL q_imd_1(FALSE,TRUE,g_mmg.mmg15,'','','','')
                   RETURNING g_mmg.mmg15
               DISPLAY BY NAME g_mmg.mmg15
               NEXT FIELD mmg15
            #No.FUN-AA0062  --end--
            WHEN INFIELD(mmg16) #item
              #CALL q_ime(0,0,g_mmg.mmg16,g_mmg.mmg15,'A') RETURNING g_mmg.mmg09
               CALL cl_init_qry_var()
               LET g_qryparam.form     ="q_ime"
               LET g_qryparam.default1 = g_mmg.mmg16
               #MOD-4A0063
              #LET g_qryparam.arg1     = g_mmg.mmg15
              #LET g_qryparam.arg2     = "A"
              #IF g_qryparam.arg2 != 'A' THEN
              #    LET g_qryparam.where = g_qryparam.where CLIPPED, " AND ime04='",g_qryparam.arg2,"'"
              #END IF
              #LET g_qryparam.where = g_qryparam.where CLIPPED, " ORDER BY ime02"
                LET g_qryparam.arg1     = g_mmg.mmg15 #倉庫編號 #MOD-4A0063
                LET g_qryparam.arg2     = 'SW'        #倉庫類別 #MOD-4A0063
                CALL cl_create_qry() RETURNING g_mmg.mmg16 #MOD-4A0063
#               CALL FGL_DIALOG_SETBUFFER( g_mmg.mmg09 )
               DISPLAY BY NAME g_mmg.mmg16
               NEXT FIELD mmg16
            WHEN INFIELD(mmg21)
              #CALL q_ima(10,2,g_mmg.mmg21) RETURNING g_mmg.mmg21
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form     = "q_ima"
             #  LET g_qryparam.default1 = g_mmg.mmg21
             #  CALL cl_create_qry() RETURNING g_mmg.mmg21
                CALL q_sel_ima(FALSE, "q_ima", "", g_mmg.mmg21, "", "", "", "" ,"",'' )  RETURNING g_mmg.mmg21
#FUN-AA0059 --End--
#               CALL FGL_DIALOG_SETBUFFER( g_mmg.mmg21 )
               DISPLAY BY NAME g_mmg.mmg21
               NEXT FIELD mmg21
         END CASE
 
      #MOD-650015 --start 
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(mmg01) THEN
      #      LET g_mmg.* = g_mmg_t.*
      #      CALL t100_show()
      #      NEXT FIELD mmg01
      #   END IF
      #MOD-650015 --end 
 
      ON ACTION CONTROLZ
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
 
FUNCTION t100_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t100_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_mmg.* TO NULL
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_mmg.* TO NULL
   ELSE
      OPEN t100_count
      FETCH t100_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t100_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
 
END FUNCTION
 
FUNCTION t100_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680100 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680100 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t100_cs INTO g_mmg.mmg02,g_mmg.mmg01
        WHEN 'P' FETCH PREVIOUS t100_cs INTO g_mmg.mmg02,g_mmg.mmg01
        WHEN 'F' FETCH FIRST    t100_cs INTO g_mmg.mmg02,g_mmg.mmg01
        WHEN 'L' FETCH LAST     t100_cs INTO g_mmg.mmg02,g_mmg.mmg01
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
            FETCH ABSOLUTE g_jump t100_cs INTO g_mmg.mmg02,g_mmg.mmg01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_mmg.mmg01,SQLCA.sqlcode,0)
       INITIALIZE g_mmg.* TO NULL   #No.FUN-6B0079  add
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
    SELECT * INTO g_mmg.* FROM mmg_file WHERE mmg01 = g_mmg.mmg01 AND mmg02 = g_mmg.mmg02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_mmg.mmg01,SQLCA.sqlcode,0) #No.FUN-660094
        CALL cl_err3("sel","mmg_file",g_mmg.mmg01,g_mmg.mmg02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660094
       INITIALIZE g_mmg.* TO NULL
       RETURN
    ELSE
       LET g_data_owner=g_mmg.mmguser           #FUN-4C0060權限控管
       LET g_data_group=g_mmg.mmggrup
       LET g_data_plant = g_mmg.mmgplant #FUN-980030
 
    END IF
 
    CALL t100_show()
END FUNCTION
 
FUNCTION t100_show()
DEFINE l_g3de    LIKE mmh_file.mmh12,        #No.FUN-680100 VARCHAR(04)
       l_gem02   LIKE gem_file.gem02
 
   LET g_mmg_t.* = g_mmg.*                #保存單頭舊值
   DISPLAY BY NAME g_mmg.mmg01,g_mmg.mmg02,g_mmg.mmg03,g_mmg.mmg05,g_mmg.mmg06, g_mmg.mmgoriu,g_mmg.mmgorig,
                   g_mmg.mmg07,g_mmg.mmg08,g_mmg.mmg04,g_mmg.mmg23,g_mmg.mmg21,
                   g_mmg.mmg09,g_mmg.mmg10,g_mmg.mmg11,g_mmg.mmg12,g_mmg.mmg121,
                   g_mmg.mmg13,g_mmg.mmg15,g_mmg.mmg16,g_mmg.mmg14,g_mmg.mmg17,
                   g_mmg.mmg18,g_mmg.mmg19,g_mmg.mmg20,g_mmg.mmg22,g_mmg.mmgacti,
                   g_mmg.mmguser,g_mmg.mmggrup,g_mmg.mmgmodu,g_mmg.mmgdate,
                   #FUN-840202     ---start---
                   g_mmg.mmgud01,g_mmg.mmgud02,g_mmg.mmgud03,g_mmg.mmgud04,
                   g_mmg.mmgud05,g_mmg.mmgud06,g_mmg.mmgud07,g_mmg.mmgud08,
                   g_mmg.mmgud09,g_mmg.mmgud10,g_mmg.mmgud11,g_mmg.mmgud12,
                   g_mmg.mmgud13,g_mmg.mmgud14,g_mmg.mmgud15 
                   #FUN-840202     ----end----
 
    #CKP
    IF g_mmg.mmgacti='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_mmg.mmgacti,"","","",g_chr,"")
 
   SELECT ima02 INTO g_buf FROM ima_file WHERE ima01 = g_mmg.mmg04
   DISPLAY g_buf TO ima02
   CALL get_g3de() RETURNING g_buf
   DISPLAY g_buf TO g3de
   CALL get_mmg09() RETURNING g_buf
   DISPLAY g_buf TO gem02
   CALL t100_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t100_b(p_kind)
DEFINE
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT        #No.FUN-680100 SMALLINT
   l_row,l_col     LIKE type_file.num5,          #No.FUN-680100 SMALLINT#分段輸入之行,列數
   l_n,l_cnt       LIKE type_file.num5,          #檢查重複用        #No.FUN-680100 SMALLINT
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        #No.FUN-680100 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,          #處理狀態          #No.FUN-680100 VARCHAR(1)
   l_b2            LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(30)
   l_ima35,l_ima36 LIKE ima_file.ima35,          #No.FUN-680100 VARCHAR(10)
   l_bmb01         LIKE bmb_file.bmb01,
   l_qpa           LIKE mmh_file.mmh161,
#   l_qty           LIKE ima_file.ima26,          #No.FUN-680100 DECIMAL(15,3) #FUN-A20044
   l_qty           LIKE type_file.num15_3,       #FUN-A20044
#   l_qty2          LIKE ima_file.ima26,          #No.FUN-680100 DECIMAL(15,3) #FUN-A20044
   l_qty2          LIKE type_file.num15_3,       #FUN-A20044
   l_flag          LIKE type_file.num10,         #No.FUN-680100 INTEGER
   l_code          LIKE type_file.num5,          #No.FUN-680100 SMALLINT
   p_kind          LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
  #MOD-C20192 str add-----
   l_mmh09      LIKE mmh_file.mmh09,
   l_mmh14      LIKE mmh_file.mmh14,
   l_mmh15      LIKE mmh_file.mmh15,
   l_mmh29      LIKE mmh_file.mmh29,
   l_mmhacti    LIKE mmh_file.mmhacti,
   l_flag2      LIKE type_file.chr1,
  #MOD-C20192 end add-----
   l_allow_insert  LIKE type_file.num5,          #可新增否        #No.FUN-680100 SMALLINT
   l_allow_delete  LIKE type_file.num5           #可刪除否        #No.FUN-680100 SMALLINT
 
   LET g_action_choice = ""
   IF g_mmg.mmg01 IS NULL THEN RETURN END IF
 
   IF g_mmg.mmg14 = 'Y' THEN
      CALL cl_err('','aap-730',0)
      RETURN
   END IF
 
   IF g_mmg.mmgacti = 'X' THEN
      CALL cl_err('','aap-127',1)
      RETURN
   END IF
 
   IF g_mmg.mmgacti = 'Y' AND p_kind = 'A' THEN
      CALL cl_err('','aap-086',1)
      RETURN
   END IF
   IF p_kind = 'A' THEN
      CALL cl_opmsg('b')
   END IF
 
   LET g_forupd_sql = "SELECT * FROM mmh_file ",
                      "  WHERE mmh01 =? AND mmh011 =? AND mmh08 = ' '",
                      "   AND mmh03 =? AND mmh12 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR #6876 WITH HOLD拿掉
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_mmh WITHOUT DEFAULTS FROM s_mmh.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
          LET g_mmh12_t = NULL   #No.FUN-BB0086
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         OPEN t100_cl USING g_mmg.mmg01,g_mmg.mmg02
         IF STATUS THEN
            CALL cl_err("OPEN t100_cl:", STATUS, 1)
            CLOSE t100_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH t100_cl INTO g_mmg.*  # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err('lock mmg:',SQLCA.sqlcode,0)     # 資料被他人LOCK
            CLOSE t100_cl
            ROLLBACK WORK
            RETURN
         END IF
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_mmh_t.* = g_mmh[l_ac].*  #BACKUP
            LET g_mmh12_t = g_mmh[l_ac].mmh12   #No.FUN-BB0086
            OPEN t100_bcl USING g_mmg.mmg01,g_mmg.mmg02,
                                g_mmh_t.mmh03,g_mmh_t.mmh12
            IF STATUS THEN
               CALL cl_err("OPEN t100_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t100_bcl INTO b_mmh.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('lock mmh',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL t100_b_move_to()
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
        #MOD-C20192 str add-----
         LET l_flag2 = 'N'
         IF cl_null(g_mmh[l_ac].mmh03) THEN
           LET l_flag2 = 'Y'
         END IF
        #MOD-C20192 end add-----
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_mmh[l_ac].* TO NULL      #900423
         LET g_mmh29[l_ac] = NULL
         INITIALIZE g_mmh_t.* ,b_mmh.* TO NULL
         LET b_mmh.mmh01  = g_mmg.mmg01
         LET b_mmh.mmh011 = g_mmg.mmg02
         LET b_mmh.mmh08  = ' '
         LET b_mmh.mmh16  = 0
         LET b_mmh.mmh06  = 0
         LET b_mmh.mmh07  = 0
         LET b_mmh.mmh061 = 0
         LET b_mmh.mmh062 = 0
         LET b_mmh.mmh063 = 0
         LET b_mmh.mmh064 = 0
         LET b_mmh.mmh065 = 0
         LET b_mmh.mmh066 = 0
         LET b_mmh.mmh25  = 0
         LET b_mmh.mmh26  = '0'
         LET b_mmh.mmh28  = 1
         LET b_mmh.mmhplant = g_plant #FUN-980004 add
         LET b_mmh.mmhlegal = g_legal #FUN-980004 add
         LET g_mmh[l_ac].mmh30 = ' '
         LET g_mmh[l_ac].mmh31 = ' '
         LET g_mmh[l_ac].mmh161=0
         LET g_mmh[l_ac].mmh05 =0
         LET g_mmh11[l_ac]  = 'N'
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD mmh27
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         CALL t100_b_move_back()
         #MOD-C50249 add begin----------------------
         LET b_mmh.mmh02 = null
         SELECT MAX(mmh02) INTO b_mmh.mmh02 FROM mmh_file
          WHERE mmh01 = b_mmh.mmh01
            AND mmh011= b_mmh.mmh011 
         IF STATUS OR cl_null(b_mmh.mmh02)THEN          #No.TQC-940016
            LET b_mmh.mmh02 = 1
         ELSE
         	  LET b_mmh.mmh02 = b_mmh.mmh02 + 1
         END IF
         #MOD-C50249 add end-------------------------
         INSERT INTO mmh_file VALUES(b_mmh.*)
         IF SQLCA.sqlcode THEN
#            CALL cl_err('ins mmh',SQLCA.sqlcode,0) #No.FUN-660094
             CALL cl_err3("ins","mmh_file",b_mmh.mmh01,b_mmh.mmh03,SQLCA.SQLCODE,"","ins mmh",1)       #NO.FUN-660094
            LET g_mmh[l_ac].* = g_mmh_t.*
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE FIELD mmh161
         IF NOT cl_null(g_mmh[l_ac].mmh27) THEN
            LET g_errno=''
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_mmh[l_ac].mmh27
            IF STATUS THEN
#               CALL cl_err('sel ima',STATUS,1) #No.FUN-660094
                CALL cl_err3("sel","ima_file",g_mmh[l_ac].mmh27,"",STATUS,"","sel ima",1)       #NO.FUN-660094
               NEXT FIELD mmh27
            END IF
            IF g_ima.ima70='Y' THEN
               LET g_mmh11[l_ac] ='E'
            END IF
            INITIALIZE g_bmb.* TO NULL
            DECLARE t100_bmb_c CURSOR FOR
             SELECT * INTO g_bmb.* FROM bmb_file
              WHERE bmb01 = g_mmg.mmg04
                AND bmb03 = g_mmh[l_ac].mmh27
                AND (bmb04 <= g_mmg.mmg13 OR bmb04 IS NULL)
                AND (g_mmg.mmg13 < bmb05 OR bmb05 IS NULL)
            FOREACH t100_bmb_c INTO g_bmb.*
               IF STATUS THEN CALL cl_err('for bmb:',STATUS,1)
                  EXIT FOREACH
               END IF
               EXIT FOREACH            # 僅讀取第一筆
            END FOREACH
            ## 檢查是否存在BOM中
            IF g_bmb.bmb03 IS NULL OR g_bmb.bmb03 = ' ' THEN
               CALL i301_bom_check(g_mmg.mmg04,g_mmh[l_ac].mmh27,g_mmg.mmg13 )
                     RETURNING g_bmb.*,g_errno
            END IF
            IF NOT cl_null(g_errno) THEN
               IF g_sma.sma887[1]='Y' THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD mmh27
               END IF
            ELSE        #TQC-720061
               IF g_sma.sma887[1]='W' THEN
                  CALL cl_err('',g_errno,0)
               END IF
            END IF
           #-----No.MOD-7A0098 modify
            IF g_bmb.bmb01 IS NULL THEN     #FUN-720061 mark
           #IF g_bmb.bmb01 IS NOT NULL THEN     #FUN-720061     
           #-----No.MOD-7A0098 end
               IF g_sma.sma887[1]='Y' THEN
                  CALL cl_err('sel bmb:','mfg2631',0)
                  NEXT FIELD mmh27
               END IF
               IF g_sma.sma887[1]='W' THEN
                  IF NOT cl_confirm('mfg2632') THEN
                     NEXT FIELD mmh27
                  END IF
               END IF
            END IF
            IF g_bmb.bmb16 IS NOT NULL THEN
               LET b_mmh.mmh16 = g_bmb.bmb06/g_bmb.bmb07*(1+g_bmb.bmb08/100)
               LET g_mmh[l_ac].mmh161= b_mmh.mmh16
               LET g_mmh[l_ac].mmh12 = g_bmb.bmb10
               #No.FUN-BB0086--add--begin--
               LET g_mmh[l_ac].mmh05 = s_digqty(g_mmh[l_ac].mmh05,g_mmh[l_ac].mmh12)  
               DISPLAY BY NAME g_mmh[l_ac].mmh05
               #No.FUN-BB0086--add--end-- 
               LET g_mmh[l_ac].mmh13 = g_bmb.bmb10_fac
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_mmh[l_ac].mmh161
               DISPLAY BY NAME g_mmh[l_ac].mmh12
               DISPLAY BY NAME g_mmh[l_ac].mmh13
               #------MOD-5A0095 END------------
            END IF
            IF g_mmh[l_ac].mmh12 IS NULL THEN
               LET g_mmh[l_ac].mmh12 = g_ima.ima63
               #No.FUN-BB0086--add--begin--
               LET g_mmh[l_ac].mmh05 = s_digqty(g_mmh[l_ac].mmh05,g_mmh[l_ac].mmh12)   
               DISPLAY BY NAME g_mmh[l_ac].mmh05
               #No.FUN-BB0086--add--end--
               LET g_mmh[l_ac].mmh13 = g_ima.ima63_fac
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_mmh[l_ac].mmh12
               DISPLAY BY NAME g_mmh[l_ac].mmh13
               DISPLAY BY NAME g_mmh[l_ac].mmh13
               #------MOD-5A0095 END------------
            END IF
            LET g_mmh[l_ac].mmh30   = g_ima.ima35
            LET g_mmh[l_ac].mmh31   = g_ima.ima36
            LET g_mmh[l_ac].mmh03   = g_mmh[l_ac].mmh27
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_mmh[l_ac].mmh30
            DISPLAY BY NAME g_mmh[l_ac].mmh31
            DISPLAY BY NAME g_mmh[l_ac].mmh03
            #------MOD-5A0095 END------------
         END IF
 
    # BEFORE FIELD mmh03
         IF cl_null(g_mmh29[l_ac]) THEN
            SELECT MAX(mmh29) INTO g_mmh29[l_ac] FROM mmh_file
             WHERE mmh01  = g_mmg.mmg01
               AND mmh011 = g_mmg.mmg02
               AND mmh27  = g_mmh[l_ac].mmh27
            IF STATUS THEN
#               CALL cl_err('sel mmh29',STATUS,0) #No.FUN-660094
                CALL cl_err3("sel","mmh_file",g_mmg.mmg01,g_mmg.mmg02,STATUS,"","sel mmh29",1)       #NO.FUN-660094
            END IF
         END IF
         SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_mmh[l_ac].mmh27
         IF STATUS THEN
#            CALL cl_err('sel ima',STATUS,1)  #No.FUN-660094
             CALL cl_err3("sel","ima_file",g_mmh[l_ac].mmh27,"",STATUS,"","sel ima",1)       #NO.FUN-660094
             NEXT FIELD mmh27 
         END IF
         LET g_mmh[l_ac].ima02_b = g_ima.ima02 CLIPPED,g_ima.ima021 CLIPPED
         LET g_mmh[l_ac].ima08_b = g_ima.ima08
 
#TQC-720061.....begin                                                           
      AFTER FIELD mmh161                                                        
         IF g_mmh[l_ac].mmh161 < 0 THEN                                         
            CALL cl_err('','amm-110',0)                                         
            NEXT FIELD mmh161                                                   
         END IF                                                                 
#TQC-720061.....end 
 
      AFTER FIELD mmh03
         IF NOT cl_null(g_mmh[l_ac].mmh03) THEN
           #FUN-AA0059 -------------------add start------------
            IF NOT s_chk_item_no(g_mmh[l_ac].mmh03,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD mmh03
            END IF
           #FUN-AA0059 -------------------add end---------------
            SELECT COUNT(*) INTO l_n FROM bmd_file      #檢查是否存在取替代檔
             WHERE bmd01 =  g_mmh[l_ac].mmh27
               AND (bmd08 = g_mmh29[l_ac] OR bmd08='ALL')
               AND bmd04  = g_mmh[l_ac].mmh03
               AND bmdacti = 'Y'                                          #CHI-910021
            IF l_n=0 THEN
                #MOD-490046
               {
               IF g_sma.sma887[1]='Y' THEN
                  CALL cl_err('sel bmd:','mfg2636',0)
                  NEXT FIELD mmh03
               END IF
               IF g_sma.sma887[1]='W' THEN
                  IF NOT cl_confirm('mfg2637') THEN
                     NEXT FIELD mmh03
                  END IF
               END IF
               }
               #--
            END IF
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_mmh[l_ac].mmh03
            IF STATUS THEN
#               CALL cl_err('s ima',STATUS,1) #No.FUN-660094
                CALL cl_err3("sel","ima_file",g_mmh[l_ac].mmh03,"",STATUS,"","s ima",1)       #NO.FUN-660094
               NEXT FIELD mmh03
            END IF
            LET g_mmh[l_ac].ima02_b = g_ima.ima02 CLIPPED,g_ima.ima021 CLIPPED
            LET g_mmh[l_ac].ima08_b = g_ima.ima08
            LET g_mmh[l_ac].mmh30 = g_ima.ima35
            IF NOT s_chk_ware(g_ima.ima35) THEN
                LET g_ima.ima35 = ''
                LET g_ima.ima36 = ''
            END IF
            LET g_mmh[l_ac].mmh31 = g_ima.ima36
         END IF
 
#TQC-990125 --begin--
      AFTER FIELD mmh05
         IF NOT t100_mmh05_check() THEN NEXT FIELD mmh05 END IF   #No.FUN-BB0086
         #No.FUN-BB0086--mark--begin--
         #IF NOT cl_null(g_mmh[l_ac].mmh05) THEN
         #   IF g_mmh[l_ac].mmh05 < 0 THEN
         #      CALL cl_err('','aec-020',0)
         #      NEXT FIELD mmh05
         #   END IF 
         #END IF 
         #No.FUN-BB0086--mark--end--
#TQC-990125 --end--
 
      AFTER FIELD mmh12
         IF NOT cl_null(g_mmh[l_ac].mmh12) THEN
            IF g_mmh_t.mmh03 IS NULL THEN
               SELECT count(*) INTO l_n FROM mmh_file
                WHERE mmh01 = g_mmg.mmg01
                  AND mmh011 = g_mmg.mmg02
                  AND mmh03 = g_mmh[l_ac].mmh03
                  AND mmh08 = b_mmh.mmh08
                  AND mmh12=g_mmh[l_ac].mmh12
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD mmh27
               END IF
            END IF
            CALL s_umfchk(g_mmh[l_ac].mmh03,g_mmh[l_ac].mmh12,g_ima.ima25)
                          RETURNING l_n,g_mmh[l_ac].mmh13
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_mmh[l_ac].mmh13
            #------MOD-5A0095 END------------
            IF l_n = 1 THEN
               CALL cl_err('','mfg3075',0)
               NEXT FIELD mmh12
            END IF
            #No.FUN-BB0086--add--begin--
            IF NOT t100_mmh05_check() THEN 
               LET g_mmh12_t = g_mmh[l_ac].mmh12
               NEXT FIELD mmh05 
            END IF 
            LET g_mmh12_t = g_mmh[l_ac].mmh12
            #No.FUN-BB0086--add--end--
         END IF
 
 
      AFTER FIELD mmh30
         IF NOT cl_null(g_mmh[l_ac].mmh30) THEN
            SELECT * FROM imd_file
             WHERE imd01=g_mmh[l_ac].mmh30
                AND imdacti = 'Y' #MOD-4B0169
            IF STATUS THEN
#               CALL cl_err('imd:','mfg1100',0) #No.FUN-660094
                CALL cl_err3("sel","imd_file",g_mmh[l_ac].mmh30,"","mfg1100","","imd",1)       #NO.FUN-660094
               NEXT FIELD mmh30
            END IF
            IF NOT s_imfchk1(g_mmh[l_ac].mmh27,g_mmh[l_ac].mmh30) THEN
               CALL cl_err(g_mmh[l_ac].mmh30,'mfg9036',0)
               NEXT FIELD mmh30
            END IF
            CALL s_stkchk(g_mmh[l_ac].mmh30,'A') RETURNING l_code
            IF NOT l_code THEN
               CALL cl_err(g_mmh[l_ac].mmh30,'mfg1100',0)
               NEXT FIELD mmh30
            END IF
            #No.FUN-AA0062  --start--
            IF NOT s_chk_ware(g_mmh[l_ac].mmh30) THEN
               NEXT FIELD mmh30
            END IF
            #No.FUN-AA0062  --end--
         END IF
	 #IF NOT s_imechk(g_mmh[l_ac].mmh30,g_mmh[l_ac].mmh31) THEN NEXT FIELD mmh31 END IF  #FUN-D40103 add #TQC-D50124 mark
 
      AFTER FIELD mmh31
         IF NOT cl_null(g_mmh[l_ac].mmh31) THEN
            IF NOT s_imfchk(g_mmh[l_ac].mmh27,g_mmh[l_ac].mmh30,g_mmh[l_ac].mmh31) THEN
               CALL cl_err(g_mmh[l_ac].mmh31,'mfg6095',0)
               NEXT FIELD mmh31
            END IF
         END IF
 	 #IF cl_null(g_mmh[l_ac].mmh31) THEN LET g_mmh[l_ac].mmh31 = ' ' END IF              #FUN-D40103 add #TQC-D50124 mark
        #IF NOT s_imechk(g_mmh[l_ac].mmh30,g_mmh[l_ac].mmh31) THEN NEXT FIELD mmh31 END IF  #FUN-D40103 add #TQC-D50124 mark

      BEFORE FIELD mmh05
         IF g_mmh_t.mmh05 IS NULL THEN
            LET b_mmh.mmh04 = g_mmg.mmg10 * b_mmh.mmh16
            LET b_mmh.mmh04 = s_digqty(b_mmh.mmh04,b_mmh.mmh12)   #No.FUN-BB0086
            LET g_mmh[l_ac].mmh05 = g_mmg.mmg10 * g_mmh[l_ac].mmh161
            LET g_mmh[l_ac].mmh05 = s_digqty(g_mmh[l_ac].mmh05,g_mmh[l_ac].mmh12)   #No.FUN-BB0086
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_mmh[l_ac].mmh05
            #------MOD-5A0095 END------------
         END IF
 
      #No.FUN-840202 --start--
      AFTER FIELD mmhud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmhud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmhud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmhud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmhud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmhud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmhud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmhud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmhud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmhud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmhud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmhud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmhud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmhud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmhud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #No.FUN-840202 ---end---
 
 
      BEFORE DELETE                            #是否取消單身
         IF g_mmh_t.mmh03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM mmh_file
             WHERE mmh01 = g_mmg.mmg01
               AND mmh011 = g_mmg.mmg02
               AND mmh03 = g_mmh_t.mmh03
               AND mmh08 = b_mmh.mmh08
               AND mmh12 = g_mmh_t.mmh12
            IF SQLCA.sqlcode THEN
#               CALL cl_err('del mmh:',SQLCA.sqlcode,0) #No.FUN-660094
                CALL cl_err3("del","mmh_file",g_mmg.mmg01,g_mmg.mmg02,SQLCA.SQLCODE,"","del mmh:",1)       #NO.FUN-660094
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
            LET g_mmh[l_ac].* = g_mmh_t.*
            CLOSE t100_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CALL t100_b_move_back()
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_mmh[l_ac].mmh03,-263,1)
            LET g_mmh[l_ac].* = g_mmh_t.*
         ELSE
            UPDATE mmh_file SET * = b_mmh.*
             WHERE mmh01  = g_mmg.mmg01
               AND mmh011 = g_mmg.mmg02
               AND mmh03  = g_mmh_t.mmh03
               AND mmh08  = b_mmh.mmh08
               AND mmh12  = g_mmh_t.mmh12
            IF SQLCA.sqlcode THEN
#               CALL cl_err('upd mmh',SQLCA.sqlcode,0) #No.FUN-660094
                CALL cl_err3("upd","mmh_file",g_mmg.mmg01,g_mmg.mmg02,SQLCA.SQLCODE,"","upd mmh:",1)       #NO.FUN-660094
               LET g_mmh[l_ac].* = g_mmh_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D40030 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_mmh[l_ac].* = g_mmh_t.*
            #FUN-D40030--add--str--
            ELSE
               CALL g_mmh.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE t100_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D40030 Add
         CLOSE t100_bcl
         COMMIT WORK
        #MOD-C20192 str add----
         SELECT ima86 INTO l_mmh14 FROM ima_file WHERE ima01 = g_mmh[l_ac].mmh03
         CALL s_umfchk(g_mmh[l_ac].mmh03,g_mmh[l_ac].mmh12,l_mmh14)
            RETURNING l_flag,l_mmh15
         IF l_flag = 1 THEN LET l_mmh15 = 1 END IF
         UPDATE mmh_file SET mmh15 = l_mmh15
          WHERE mmh01 = g_mmg.mmg01 AND mmh011 = g_mmg.mmg02 AND mmh03 = g_mmh[l_ac].mmh03
         IF l_flag2 = 'Y' THEN
           LET l_mmh09 = 0
           LET l_mmh29 = g_mmg.mmg04
           LET l_mmhacti = 'Y'
           UPDATE mmh_file SET mmh09=l_mmh09,mmh14=l_mmh14,mmh29=l_mmh29,mmhacti=l_mmhacti
            WHERE mmh01 = g_mmg.mmg01 AND mmh011 = g_mmg.mmg02
         END IF
        #MOD-C20192 end add---- 
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(mmh03) AND l_ac > 1 THEN
            LET g_mmh[l_ac].mmh27 = g_mmh[l_ac-1].mmh27
            LET g_mmh[l_ac].mmh03 = g_mmh[l_ac-1].mmh03
            LET g_mmh[l_ac].mmh05 = 0
            NEXT FIELD mmh27
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(mmh27)
              #CALL q_ima(0,0,g_mmh[l_ac].mmh27) RETURNING g_mmh[l_ac].mmh27
              #CALL FGL_DIALOG_SETBUFFER( g_mmh[l_ac].mmh27 )
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form     = "q_ima"
             #  LET g_qryparam.default1 = g_mmh[l_ac].mmh27
             #  CALL cl_create_qry() RETURNING g_mmh[l_ac].mmh27
                CALL q_sel_ima(FALSE, "q_ima", "", g_mmh[l_ac].mmh27, "", "", "", "" ,"",'' )  RETURNING g_mmh[l_ac].mmh27 
#FUN-AA0059 --End--
#               CALL FGL_DIALOG_SETBUFFER( g_mmh[l_ac].mmh27 )
                DISPLAY BY NAME g_mmh[l_ac].mmh27           #No.MOD-490371
               NEXT FIELD mmh27
            WHEN INFIELD(mmh03)
              #CALL q_ima(0,0,g_mmh[l_ac].mmh03) RETURNING g_mmh[l_ac].mmh03
              #CALL FGL_DIALOG_SETBUFFER( g_mmh[l_ac].mmh03 )
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form     = "q_ima"
             #  LET g_qryparam.default1 = g_mmh[l_ac].mmh03
             #  CALL cl_create_qry() RETURNING g_mmh[l_ac].mmh03
                CALL q_sel_ima(FALSE, "q_ima", "", g_mmh[l_ac].mmh03, "", "", "", "" ,"",'' )  RETURNING g_mmh[l_ac].mmh03
#FUN-AA0059 --End--
#               CALL FGL_DIALOG_SETBUFFER( g_mmh[l_ac].mmh03 )
                DISPLAY BY NAME g_mmh[l_ac].mmh03           #No.MOD-490371
               NEXT FIELD mmh03
            #TQC-DB0070--add--str--
            WHEN INFIELD(mmh30)
                 CALL q_imd_1(FALSE,TRUE,g_mmh[l_ac].mmh30,'','','','')
                   RETURNING g_mmh[l_ac].mmh30
                 DISPLAY BY NAME g_mmh[l_ac].mmh30
                 NEXT FIELD mmh30
              WHEN INFIELD(mmh31)
                 CALL q_ime_1(FALSE,TRUE,g_mmh[l_ac].mmh31,g_mmh[l_ac].mmh30,"",g_plant,"","","")
                     RETURNING g_mmh[l_ac].mmh31
                 DISPLAY BY NAME g_mmh[l_ac].mmh31
                 NEXT FIELD mmh31
            #TQC-DB0070--add--end
         END CASE
 
      ON ACTION CONTROLZ
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
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
   END INPUT
 
   UPDATE mmg_file SET mmgmodu=g_user,mmgdate=g_today
    WHERE mmg01=g_mmg.mmg01 AND mmg02 = g_mmg.mmg02
   CLOSE t100_bcl
   COMMIT WORK
   CALL t100_delHeader()     #CHI-C30002 add
   CALL t100_b_fill(' 1=1')
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t100_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() THEN
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
        #CALL t100_x()   #CHI-D20010
         CALL t100_x(1)  #CHI-D20010
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM mmg_file WHERE mmg01 =g_mmg.mmg01 AND mmg02 = g_mmg.mmg02
         INITIALIZE g_mmg.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t100_b_move_to()
 
   LET g_mmh[l_ac].mmh27 = b_mmh.mmh27
   LET g_mmh[l_ac].mmh03 = b_mmh.mmh03
   LET g_mmh[l_ac].mmh12 = b_mmh.mmh12
   LET g_mmh[l_ac].mmh13 = b_mmh.mmh13
   LET g_mmh[l_ac].mmh161= b_mmh.mmh161
   LET g_mmh[l_ac].mmh05 = b_mmh.mmh05
   LET g_mmh[l_ac].mmh30 = b_mmh.mmh30
   LET g_mmh[l_ac].mmh31 = b_mmh.mmh31
   LET g_mmh29[l_ac] = b_mmh.mmh29
   LET g_mmh11[l_ac] = b_mmh.mmh11
   #NO.FUN-840202 --start--
   LET g_mmh[l_ac].mmhud01 = b_mmh.mmhud01
   LET g_mmh[l_ac].mmhud02 = b_mmh.mmhud02
   LET g_mmh[l_ac].mmhud03 = b_mmh.mmhud03
   LET g_mmh[l_ac].mmhud04 = b_mmh.mmhud04
   LET g_mmh[l_ac].mmhud05 = b_mmh.mmhud05
   LET g_mmh[l_ac].mmhud06 = b_mmh.mmhud06
   LET g_mmh[l_ac].mmhud07 = b_mmh.mmhud07
   LET g_mmh[l_ac].mmhud08 = b_mmh.mmhud08
   LET g_mmh[l_ac].mmhud09 = b_mmh.mmhud09
   LET g_mmh[l_ac].mmhud10 = b_mmh.mmhud10
   LET g_mmh[l_ac].mmhud11 = b_mmh.mmhud11
   LET g_mmh[l_ac].mmhud12 = b_mmh.mmhud12
   LET g_mmh[l_ac].mmhud13 = b_mmh.mmhud13
   LET g_mmh[l_ac].mmhud14 = b_mmh.mmhud14
   LET g_mmh[l_ac].mmhud15 = b_mmh.mmhud15
   #NO.FUN-840202 --end--
 
END FUNCTION
 
FUNCTION t100_b_move_back()
 
   LET b_mmh.mmh01  = g_mmg.mmg01
   LET b_mmh.mmh011 = g_mmg.mmg02
   LET b_mmh.mmh27 = g_mmh[l_ac].mmh27
   LET b_mmh.mmh03 = g_mmh[l_ac].mmh03
   LET b_mmh.mmh12 = g_mmh[l_ac].mmh12
   LET b_mmh.mmh13 = g_mmh[l_ac].mmh13
   LET b_mmh.mmh161= g_mmh[l_ac].mmh161
   LET b_mmh.mmh05 = g_mmh[l_ac].mmh05
   LET b_mmh.mmh30 = g_mmh[l_ac].mmh30
   LET b_mmh.mmh31 = g_mmh[l_ac].mmh31
   LET b_mmh.mmh29 = g_mmh29[l_ac]
   LET b_mmh.mmh11 = g_mmh11[l_ac]
   SELECT MAX(mmh02) INTO b_mmh.mmh02 FROM mmh_file
    WHERE mmh01 = b_mmh.mmh01
      AND mmh02 = b_mmh.mmh02
      AND mmh03 = b_mmh.mmh03
      AND mmh08 = ' '
      AND mmh12 = b_mmh.mmh12
  #IF STATUS THEN                                 #No.TQC-940016 
   IF STATUS OR cl_null(b_mmh.mmh02)THEN          #No.TQC-940016
      LET b_mmh.mmh02 = 1
   END IF
   #No.FUN-840202 --start--
   LET b_mmh.mmhud01 = g_mmh[l_ac].mmhud01
   LET b_mmh.mmhud02 = g_mmh[l_ac].mmhud02
   LET b_mmh.mmhud03 = g_mmh[l_ac].mmhud03
   LET b_mmh.mmhud04 = g_mmh[l_ac].mmhud04
   LET b_mmh.mmhud05 = g_mmh[l_ac].mmhud05
   LET b_mmh.mmhud06 = g_mmh[l_ac].mmhud06
   LET b_mmh.mmhud07 = g_mmh[l_ac].mmhud07
   LET b_mmh.mmhud08 = g_mmh[l_ac].mmhud08
   LET b_mmh.mmhud09 = g_mmh[l_ac].mmhud09
   LET b_mmh.mmhud10 = g_mmh[l_ac].mmhud10
   LET b_mmh.mmhud11 = g_mmh[l_ac].mmhud11
   LET b_mmh.mmhud12 = g_mmh[l_ac].mmhud12
   LET b_mmh.mmhud13 = g_mmh[l_ac].mmhud13
   LET b_mmh.mmhud14 = g_mmh[l_ac].mmhud14
   LET b_mmh.mmhud15 = g_mmh[l_ac].mmhud15
   #NO.FUN-840202 --end--
 
END FUNCTION
 
FUNCTION t100_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON mmh27,mmh03,mmh161,mmh05,mmh12,mmh13,mmh30,nmh31
                       #No.FUN-840202 --start--
                       ,mmhud01,mmhud02,mmhud03,mmhud04,mmhud05
                       ,mmhud06,mmhud07,mmhud08,mmhud09,mmhud10
                       ,mmhud11,mmhud12,mmhud13,mmhud14,mmhud15
                       #No.FUN-840202 ---end---
                  FROM s_mmh[1].mmh27,s_mmh[1].mmh03,s_mmh[1].mmh161,s_mmh[1].mmh05,
                       s_mmh[1].mmh12,s_mmh[1].mmh13,s_mmh[1].mmh30,s_mmh[1].mmh31
                      #No.FUN-840202 --start--
                      ,s_mmh[1].mmhud01,s_mmh[1].mmhud02,s_mmh[1].mmhud03,s_mmh[1].mmhud04,s_mmh[1].mmhud05
                      ,s_mmh[1].mmhud06,s_mmh[1].mmhud07,s_mmh[1].mmhud08,s_mmh[1].mmhud09,s_mmh[1].mmhud10
                      ,s_mmh[1].mmhud11,s_mmh[1].mmhud12,s_mmh[1].mmhud13,s_mmh[1].mmhud14,s_mmh[1].mmhud15
                      #No.FUN-840202 ---end---
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
 
    CALL t100_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t100_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2          LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(200)
       l_ima021       LIKE ima_file.ima021,
       l_mmh02        LIKE mmh_file.mmh02
 
   IF cl_null(p_wc2) THEN    #NO:6876
      LET p_wc2=" 1=1 "
   END IF
   LET g_sql = "SELECT mmh02,mmh27,mmh03,ima02,mmh161,mmh05,mmh12,mmh13,ima08,mmh30,mmh31,",
               #No.FUN-840202 --start--
               "       mmhud01,mmhud02,mmhud03,mmhud04,mmhud05,",
               "       mmhud06,mmhud07,mmhud08,mmhud09,mmhud10,",
               "       mmhud11,mmhud12,mmhud13,mmhud14,mmhud15,", 
               #No.FUN-840202 ---end---
               "       ima021,mmh29,mmh11 ",
               "  FROM mmh_file LEFT OUTER JOIN ima_file ON mmh03 = ima01 ",
               " WHERE mmh01 ='",g_mmg.mmg01,"'",  #單頭
               "   AND mmh011 = '",g_mmg.mmg02,"'",
               "    AND ",p_wc2 CLIPPED,
               " ORDER BY mmh02 "
 
   PREPARE t100_pb FROM g_sql
   DECLARE mmh_curs CURSOR FOR t100_pb
 
   CALL g_mmh.clear()
   LET l_ima021 = NULL
   LET g_cnt = 1
   #單身 ARRAY 填充
   FOREACH mmh_curs INTO l_mmh02, g_mmh[g_cnt].*,
                         l_ima021,g_mmh29[g_cnt],g_mmh11[g_cnt]
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_mmh[g_cnt].ima02_b = g_mmh[g_cnt].ima02_b CLIPPED,l_ima021 CLIPPED
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_mmh.deleteElement(g_cnt)
   LET g_rec_b=g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t100_b1_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2          LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(200)
       l_ima021       LIKE ima_file.ima021,
       l_mmh01        LIKE mmh_file.mmh01,
       l_mmh011       LIKE mmh_file.mmh011,
       l_mmh02        LIKE mmh_file.mmh02,
       l_con          LIKE type_file.num5          #No.FUN-680100 SMALLINT
 
   IF cl_null(p_wc2) THEN   #NO:6876
      LET p_wc2=" 1=1 "
   END IF
 
   LET g_sql = "SELECT mmh01,mmh011,mmh02,mmh27,mmh03,mmh161,mmh05,mmh12,",
               "       mmh13,mmh30,mmh31,ima02,ima08,ima021,mmh29,mmh11",
               "  FROM mmh_file LEFT OUTER JOIN ima_file ON mmh03 = ima01 ",
               " WHERE mmh01 ='",g_mmg.mmg01,"'",  #單頭
               "   AND mmh011 = '",g_mmg.mmg02,"'",
               "    AND ",p_wc2 CLIPPED,
               " ORDER BY mmh02 "
 
   PREPARE t100_pb1 FROM g_sql
   DECLARE mmh_curs1 CURSOR FOR t100_pb1
 
   CALL g_mmh.clear()
   LET l_ima021 = NULL
   LET g_cnt = 1
  #單身 ARRAY 填充
   FOREACH mmh_curs1 INTO l_mmh01,l_mmh011,l_mmh02, g_mmh[g_cnt].*,l_ima021,
                          g_mmh29[g_cnt],g_mmh11[g_cnt]
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      SELECT COUNT(*) INTO l_con FROM mma_file
       WHERE mma02  = l_mmh01
         AND mma021 = l_mmh011
         AND mma03  = l_mmh02
      IF l_con > 0 THEN
         CONTINUE FOREACH
      END IF
      LET g_mmh[g_cnt].ima02_b = g_mmh[g_cnt].ima02_b CLIPPED,l_ima021 CLIPPED
      LET g_cnt = g_cnt + 1
   END FOREACH
   LET g_rec_b=g_cnt - 1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mmh TO s_mmh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
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
         CALL t100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t100_fetch('L')
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
         #CKP
         IF g_mmg.mmgacti='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         CALL cl_set_field_pic(g_mmg.mmgacti,"","","",g_chr,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION 產生備料
      ON ACTION gen_allotment
         LET g_action_choice="gen_allotment"
         EXIT DISPLAY
#@    ON ACTION 刪除備料
      ON ACTION delete_allotment
         LET g_action_choice="delete_allotment"
         EXIT DISPLAY
#@    ON ACTION 結案
      ON ACTION close_the_case
         LET g_action_choice="close_the_case"
         EXIT DISPLAY
#@    ON ACTION 追加單身
      ON ACTION add_detail
         LET g_action_choice="add_detail"
         EXIT DISPLAY
#@    ON ACTION 費用計算
      ON ACTION calculate_expense
         LET g_action_choice="calculate_expense"
         EXIT DISPLAY
#@    ON ACTION 其他費用資料維護
      ON ACTION other_expense
         LET g_action_choice="other_expense"
         EXIT DISPLAY
#@    ON ACTION 需求單查詢
      ON ACTION qry_requisition_note
         LET g_action_choice="qry_requisition_note"
         EXIT DISPLAY
#@    ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
#@    ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
 
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
 
      ON ACTION exporttoexcel       #FUN-4B0036
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t100_cralc()
  #-----No.FUN-670041 modify
  #DEFINE l_btflg   LIKE sma_file.sma29
   DEFINE l_btflg   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
  #-----No.FUN-670041 end
   DEFINE l_str3    STRING   #No.MOD-580322
 
   SELECT * INTO g_mmg.* FROM mmg_file WHERE mmg01 = g_mmg.mmg01
                                         AND mmg02 = g_mmg.mmg02
   IF g_mmg.mmg14   = 'Y'   THEN CALL cl_err('','aap-730',0) RETURN END IF
   IF g_mmg.mmgacti = 'X'   THEN CALL cl_err('','aap-127',1) RETURN END IF
   IF g_mmg.mmgacti = 'Y'  THEN CALL cl_err('','aap-086',1) RETURN END IF
   SELECT COUNT(mmh01) INTO g_cnt FROM mmh_file
    WHERE mmh01  = g_mmg.mmg01
      AND mmh011 = g_mmg.mmg02
 
   IF g_cnt > 0 THEN
#No.MOD-580322 --start--
      CALL cl_getmsg('amm1003',g_lang) RETURNING l_str3
      ERROR l_str3
#      ERROR "單據已確認或備料已產生!!"
#No.MOD-580322 --end--
      RETURN
   END IF
 
  #---------No.FUN-670041 modify
  #LET l_btflg = g_sma.sma29
   LET l_btflg = 'Y'
  #---------No.FUN-670041 modify
   CALL s_mm_cralc(g_mmg.mmg01,g_mmg.mmg02,g_mmg.mmg04,l_btflg,
                g_mmg.mmg10,g_mmg.mmg13,'Y',g_sma.sma71,0,'A')
        RETURNING g_cnt
   CALL t100_b_fill(' 1=1')
END FUNCTION
 
FUNCTION t100_dealc()
   DEFINE l_minopseq      LIKE type_file.num5          #No.FUN-680100 SMALLINT
 
   SELECT * INTO g_mmg.* FROM mmg_file WHERE mmg01 = g_mmg.mmg01
                                         AND mmg02 = g_mmg.mmg02
   IF g_mmg.mmg14 = 'Y' THEN CALL cl_err('','aap-730',0) RETURN END IF
   IF g_mmg.mmgacti = 'X' THEN CALL cl_err('','aap-127',1) RETURN END IF
   IF g_mmg.mmgacti = 'Y' THEN CALL cl_err('','aap-086',1) RETURN END IF
 
   DELETE FROM mmh_file
    WHERE mmh01 = g_mmg.mmg01
      AND mmh011 = g_mmg.mmg02
   IF STATUS THEN 
#   CALL cl_err('del mmh:',STATUS,1)  #No.FUN-660094
    CALL cl_err3("del","mmh_file",g_mmg.mmg01,g_mmg.mmg02,SQLCA.SQLCODE,"","del mmh:",1)       #NO.FUN-660094
   RETURN END IF
   CALL t100_b_fill(' 1=1')
 
END FUNCTION
 
#FUNCTION t100_x()        #CHI-D20010
FUNCTION t100_x(p_type)   #CHI-D20010
DEFINE l_flag LIKE type_file.chr1  #CHI-D20010
DEFINE p_type LIKE type_file.chr1  #CHI-D20010
 
   IF s_ammshut(0) THEN RETURN END IF
   IF cl_null(g_mmg.mmg01) THEN CALL cl_err('',-400,0) RETURN END IF
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_mmg.mmgacti ='X' THEN RETURN END IF
   ELSE
      IF g_mmg.mmgacti <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t100_cl USING g_mmg.mmg01,g_mmg.mmg02
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t100_cl INTO g_mmg.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mmg.mmg01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t100_cl ROLLBACK WORK RETURN
   END IF
   #-->已結案不可作廢
   IF g_mmg.mmg14   = 'Y'  THEN CALL cl_err('','aap-730',0) RETURN END IF
   #-->已確認不可作廢
   IF g_mmg.mmgacti = 'Y'  THEN CALL cl_err('','aap-086',1) RETURN END IF
   IF g_mmg.mmgacti = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
 
  #IF cl_void(0,0,g_mmg.mmgacti)   THEN  #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN  #CHI-D20010
      LET g_chr=g_mmg.mmgacti
     #IF g_mmg.mmgacti ='N' THEN  #CHI-D20010
      IF p_type = 1 THEN      #CHI-D20010
         LET g_mmg.mmgacti='X'
      ELSE
         LET g_mmg.mmgacti='N'
      END IF
      UPDATE mmg_file SET mmgacti=g_mmg.mmgacti,
                          mmgmodu=g_user,
                          mmgdate=g_today
       WHERE mmg01  =g_mmg.mmg01
         AND mmg02  =g_mmg.mmg02
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_mmg.mmgacti,SQLCA.sqlcode,0) #No.FUN-660094
          CALL cl_err3("upd","mmg_file",g_mmg.mmg01,g_mmg.mmg02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660094
         LET g_mmg.mmgacti=g_chr
      END IF
      DISPLAY BY NAME g_mmg.mmgacti,g_mmg.mmgmodu,g_mmg.mmgdate
   END IF
   CLOSE t100_cl
   COMMIT WORK
 
    #CKP
    IF g_mmg.mmgacti='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_mmg.mmgacti,"","","",g_chr,"")
 
END FUNCTION
 
FUNCTION t100_firm1()
  DEFINE l_cnt   LIKE type_file.num5          #No.FUN-680100 SMALLINT
  DEFINE l_mmh30 LIKE mmh_file.mmh30         #FUN-AB0056  add
 
#CHI-C30107 -------------- add ---------------- begin
   IF g_mmg.mmg14   = 'Y'  THEN CALL cl_err('','aap-730',0) RETURN END IF
   IF g_mmg.mmgacti = 'X'  THEN CALL cl_err('','aap-127',1) RETURN END IF
   IF g_mmg.mmgacti = 'Y'  THEN CALL cl_err('','aap-086',1) RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 -------------- add ---------------- end
   SELECT * INTO g_mmg.* FROM mmg_file WHERE mmg01 = g_mmg.mmg01
                                         AND mmg02 = g_mmg.mmg02
   IF g_mmg.mmg14   = 'Y'  THEN CALL cl_err('','aap-730',0) RETURN END IF
   IF g_mmg.mmgacti = 'X'  THEN CALL cl_err('','aap-127',1) RETURN END IF
   IF g_mmg.mmgacti = 'Y'  THEN CALL cl_err('','aap-086',1) RETURN END IF

 
   SELECT COUNT(*) INTO l_cnt  FROM mmh_file WHERE mmh01 = g_mmg.mmg01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t100_cl USING g_mmg.mmg01,g_mmg.mmg02
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t100_cl INTO g_mmg.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock mmg:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t100_cl ROLLBACK WORK RETURN
   END IF
   #add FUN-AB0056
   IF NOT s_chk_ware(g_mmg.mmg15) THEN #检查仓库是否属于当前门店 
      LET g_success='N'
      RETURN
   END IF
   #end FUN-AB0056
   #add FUN-AB0056
    DECLARE t100_mmh30 CURSOR FOR 
     SELECT mmh30 FROM mmh_file 
      WHERE mmh01 = g_mmg.mmg01
    FOREACH t100_mmh30 INTO l_mmh30
      IF NOT s_chk_ware(l_mmh30) THEN #检查仓库是否属于当前门店 
         LET g_success='N'
         RETURN
      END IF
    END FOREACH
    #end FUN-AB0056
   UPDATE mmg_file SET mmgacti = 'Y' WHERE mmg01 = g_mmg.mmg01
                                       AND mmg02 = g_mmg.mmg02
   IF STATUS THEN
#      CALL cl_err('upd mmgacti',STATUS,0) #No.FUN-660094
       CALL cl_err3("upd","mmg_file",g_mmg.mmg01,g_mmg.mmg02,STATUS,"","upd mmgacti",1)       #NO.FUN-660094
      LET g_success='N'
   END IF

   IF g_success='Y' THEN
      COMMIT WORK
      LET g_mmg.mmgacti ='Y'
      DISPLAY BY NAME  g_mmg.mmgacti
   ELSE
      ROLLBACK WORK
   END IF 
    #CKP
    IF g_mmg.mmgacti='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_mmg.mmgacti,"","","",g_chr,"")
   
 
END FUNCTION
 
FUNCTION t100_firm2()
 DEFINE l_str4  STRING  #No.MOD-580322
 
    SELECT * INTO g_mmg.* FROM mmg_file WHERE mmg01 = g_mmg.mmg01
                                          AND mmg02 = g_mmg.mmg02
    IF g_mmg.mmg14   = 'Y'  THEN CALL cl_err('','aap-730',0) RETURN END IF
 
    IF g_mmg.mmgacti = 'X'  THEN CALL cl_err('','9021',1) RETURN END IF
    IF g_mmg.mmgacti = 'N'  THEN CALL cl_err('','9025',1) RETURN END IF
 
    SELECT COUNT(*) INTO g_cnt FROM mma_file
     WHERE mma02  = g_mmg.mmg01
       AND mma021 = g_mmg.mmg02
    IF g_cnt > 0 THEN
#No.MOD-580322 --start--
       CALL cl_getmsg('amm1004',g_lang) RETURNING l_str4
       ERROR l_str4
#       ERROR "已有需求單產生, 請先取消需求單"
#No.MOD-580322 --end--
       RETURN
    END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF
    LET g_success='Y'
    BEGIN WORK
 
    OPEN t100_cl USING g_mmg.mmg01,g_mmg.mmg02
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t100_cl INTO g_mmg.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err('lock mmg:',SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t100_cl ROLLBACK WORK RETURN
    END IF
    UPDATE mmg_file SET mmgacti = 'N' WHERE mmg01 = g_mmg.mmg01
                                        AND mmg02 = g_mmg.mmg02
    IF STATUS THEN
#       CALL cl_err('upd mmgacti',STATUS,0) #No.FUN-660094
        CALL cl_err3("upd","mmg_file",g_mmg.mmg01,g_mmg.mmg02,STATUS,"","upd mmgacti",1)       #NO.FUN-660094
       LET g_success='N'
    END IF
    IF g_success='Y' THEN
       COMMIT WORK
       LET g_mmg.mmgacti ='N'
       DISPLAY BY NAME g_mmg.mmgacti
    ELSE
       ROLLBACK WORK
    END IF
    #CKP
    IF g_mmg.mmgacti='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_mmg.mmgacti,"","","",g_chr,"")
END FUNCTION
 
FUNCTION t100_1()
 DEFINE l_str5   STRING   #No.MOD-580322
 
   SELECT * INTO g_mmg.* FROM mmg_file WHERE mmg01 = g_mmg.mmg01
                                         AND mmg02 = g_mmg.mmg02
   IF g_mmg.mmg14   = 'Y'  THEN CALL cl_err('','aap-730',0) RETURN END IF
   IF g_mmg.mmgacti = 'X'  THEN CALL cl_err('','aap-127',1) RETURN END IF
   IF g_mmg.mmgacti = 'N' THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM mma_file
    WHERE mma02  = g_mmg.mmg01
      AND mma021 = g_mmg.mmg02
      AND mma04 <> 'Y'
   IF g_cnt > 0 THEN
#No.MOD-580322 --start--
      CALL cl_getmsg('amm1005',g_lang) RETURNING l_str5
      ERROR l_str5
#      ERROR "尚有需求單未結案,請先對需求單結案"
#No.MOD-580322 --end--
      RETURN
   END IF
   IF NOT cl_confirm('aap-163') THEN RETURN END IF
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t100_cl USING g_mmg.mmg01,g_mmg.mmg02
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t100_cl INTO g_mmg.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock mmg:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t100_cl ROLLBACK WORK RETURN
   END IF
   UPDATE mmg_file SET mmg14 = 'Y' WHERE mmg01 = g_mmg.mmg01
                                     AND mmg02 = g_mmg.mmg02
   IF STATUS THEN
#      CALL cl_err('upd mmg14',STATUS,0)    #NO.FUN-660094 
       CALL cl_err3("upd","mmg_file",g_mmg.mmg01,g_mmg.mmg02,STATUS,"","upd mmg14",1)  #NO.FUN-660094 
      LET g_success='N'
   END IF
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_mmg.mmg14 ='Y'
      DISPLAY BY NAME  g_mmg.mmg14
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t100_2()
#-----No.FUN-670041 modify
#DEFINE l_btflg   LIKE sma_file.sma29
 DEFINE l_btflg   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
#-----No.FUN-670041 end
DEFINE m_mmh02   LIKE mmh_file.mmh02
 
   IF g_mmg.mmg01 IS NULL THEN RETURN END IF
   IF g_mmg.mmgacti = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF g_mmg.mmgacti = 'N' THEN CALL cl_err('',9029,0) RETURN END IF
   IF g_mmg.mmg14   = 'Y' THEN CALL cl_err('',9004,0) RETURN END IF
 
   LET p_row = 7 LET p_col = 2
   OPEN WINDOW t1003_w AT 07,02 WITH FORM "amm/42f/ammt100_b"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("ammt100_b")
 
 
   SELECT MAX(mmh02) INTO m_mmh02 FROM mmh_file
    WHERE mmh01 = g_mmg.mmg01
      AND mmh011 = g_mmg.mmg02
   IF cl_null(m_mmh02) OR STATUS THEN
      LET m_mmh02 = 0
   END IF
   #因BOM會修改,所以先產差異部份
  #---------No.FUN-670041 modify
  #LET l_btflg = g_sma.sma29
   LET l_btflg = 'Y'
  #---------No.FUN-670041 modify
   CALL s_mm_cralc(g_mmg.mmg01,g_mmg.mmg02,g_mmg.mmg04,l_btflg,
                g_mmg.mmg10,g_mmg.mmg13,'Y',g_sma.sma71,m_mmh02,'B')
        RETURNING g_cnt
   IF g_cnt = 0 THEN
      CALL cl_err(g_mmg.mmg01,'amm-047',0)
   END IF
   CALL t100_b_fill(g_wc2)      #MOD-B50009 add
   CALL t100_b('B')
   CLOSE WINDOW t1003_w
   CALL t100_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t100_3()
   DEFINE l_fee      LIKE mmg_file.mmg18,
          l_hr  LIKE mmg_file.mmg19,
          l_rmo LIKE mmg_file.mmg17,
          l_rso LIKE mmg_file.mmg17
 
   SELECT SUM(mmb16*mmb18) INTO g_mmg.mmg18 FROM mmb_file,mma_file
    WHERE mmbacti='Y' AND mmb01=mma01
      AND mma02=g_mmg.mmg01 AND mma021=g_mmg.mmg02
 
   SELECT SUM(mmb17*mmb18) INTO g_mmg.mmg19 FROM mmb_file,mma_file
    WHERE mmbacti='Y' AND mmb01=mma01
      AND mma02=g_mmg.mmg01 AND mma021=g_mmg.mmg02
 
   SELECT COUNT(mmb14) INTO l_rso FROM mmb_file,mma_file
    WHERE mmb14='Y' AND mmbacti='Y' AND mmb01=mma01
          AND mma02=g_mmg.mmg01 AND mma021=g_mmg.mmg02
   SELECT COUNT(mmb14) INTO l_rmo FROM mmb_file,mma_file
    WHERE mmbacti='Y' AND mmb01=mma01
      AND mma02=g_mmg.mmg01 AND mma021=g_mmg.mmg02
 
   LET g_mmg.mmg17=l_rso/l_rmo*100
   UPDATE mmg_file SET mmg17=g_mmg.mmg17,
                       mmg18=g_mmg.mmg18,
                       mmg19=g_mmg.mmg19
    WHERE mmg01=g_mmg.mmg01 AND mmg02=g_mmg.mmg02
 
   DISPLAY BY NAME g_mmg.mmg17,g_mmg.mmg18,g_mmg.mmg19
 
END FUNCTION
 
FUNCTION get_g3de()
DEFINE l_name   LIKE mmh_file.mmh12        #No.FUN-680100 VARCHAR(04)
 
   CASE g_mmg.mmg03
      WHEN '1'
           LET l_name = '治具'
      WHEN '2'
           LET l_name = '塑模'
      WHEN '3'
           LET l_name = '沖模'
      WHEN '4'
           LET l_name = '其他'
    END CASE
    RETURN l_name
 
END FUNCTION
 
FUNCTION get_mmg09()
DEFINE p_gem02   LIKE gem_file.gem02
 
   SELECT gem02 INTO p_gem02 FROM gem_file WHERE gem01=g_mmg.mmg09
      AND gemacti='Y'
   IF STATUS THEN
      LET p_gem02 = NULL
   END IF
   RETURN p_gem02
 
END FUNCTION
 
FUNCTION t100_r()
 DEFINE l_chr,l_sure LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
    IF s_ammshut(0) THEN RETURN END IF
    IF g_mmg.mmg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_mmg.* FROM mmg_file WHERE mmg01 = g_mmg.mmg01
                                          AND mmg02 = g_mmg.mmg02
    IF g_mmg.mmg14   = 'Y'  THEN CALL cl_err('','aap-730',0) RETURN END IF
    IF g_mmg.mmgacti = 'X'  THEN CALL cl_err('','aap-127',1) RETURN END IF
    IF g_mmg.mmgacti = 'Y' THEN RETURN END IF
    BEGIN WORK
 
    OPEN t100_cl USING g_mmg.mmg01,g_mmg.mmg02
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t100_cl INTO g_mmg.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_mmg.mmg01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
    END IF
    CALL t100_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "mmg01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_mmg.mmg01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       MESSAGE "Delete mmg,mmh!"
       DELETE FROM mmg_file WHERE mmg01 = g_mmg.mmg01
                              AND mmg02 = g_mmg.mmg02
       IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err('No mmg deleted','',0) #No.FUN-660094
           CALL cl_err3("del","mmg_file",g_mmg.mmg01,g_mmg.mmg02,"","","No mmg deleted",1)       #NO.FUN-660094
          ROLLBACK WORK RETURN
       END IF
       DELETE FROM mmh_file WHERE mmh01  = g_mmg.mmg01
                              AND mmh011 = g_mmg.mmg02
       IF STATUS THEN
#          CALL cl_err('del mmg',STATUS,0)  #No.FUN-660094 
           CALL cl_err3("del","mmh_file",g_mmg.mmg01,g_mmg.mmg02,"STATUS","","del mmg",1)       #NO.FUN-660094
          ROLLBACK WORK RETURN
       END IF
       CLEAR FORM
       CALL g_mmh.clear()
       INITIALIZE g_mmg.* TO NULL
       MESSAGE ""
    END IF
    CLOSE t100_cl
    COMMIT WORK
    #No.TQC-710063  --begin
    OPEN t100_count                                                                                                                 
    #FUN-B50063-add-start--
    IF STATUS THEN
       CLOSE t100_cs
       CLOSE t100_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50063-add-end-- 
    FETCH t100_count INTO g_row_count                                                                                               
    #FUN-B50063-add-start--
    IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
       CLOSE t100_cs
       CLOSE t100_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50063-add-end--
    DISPLAY g_row_count TO FORMONLY.cnt                                                                                             
    OPEN t100_cs                                                                                                                    
    IF g_curs_index = g_row_count + 1 THEN                                                                                          
       LET g_jump = g_row_count                                                                                                     
       CALL t100_fetch('L')                                                                                                         
    ELSE                                                                                                                            
       LET g_jump = g_curs_index                                                                                                    
       LET mi_no_ask = TRUE                                                                                                         
       CALL t100_fetch('/')                                                                                                         
    END IF             
    #No.TQC-710063  --begin
 
END FUNCTION
 
 
FUNCTION t100_out()
DEFINE l_no1  LIKE mmg_file.mmg01,
       l_no2  LIKE mmg_file.mmg02
 
    IF g_mmg.mmg01 IS NULL THEN RETURN END IF
    LET l_no1  = g_mmg.mmg01
    LET l_no2  = g_mmg.mmg02
    LET g_wc = 'mmg01 = "',l_no1,'" AND mmg02 = "',l_no2,'"'
   #LET g_sql = "ammr100 ",    #FUN-C30085 mark
    LET g_sql = "ammg100 ",    #FUN-C30085 add
                " '",g_today,"'",
                " '",g_user,"'",
                 " '",g_lang,"'",  #No.MOD-470532
                " 'Y'",
                " ' '",
                " '1'",
                " '",g_wc clipped,"'",
                " 'Y' "          #No.MOD-470532
                #" 'N' "           #No.MOD-470532   #TQC-610073
display 'g_sql=',g_sql
    CALL cl_cmdrun(g_sql)
 
END FUNCTION
 
 #MOD-420449
FUNCTION t100_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("mmg01,mmg02",TRUE)
   END IF
END FUNCTION
 
FUNCTION t100_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("mmg01,mmg02",FALSE)
   END IF
END FUNCTION
#--END
 
 
#Patch....NO.MOD-5A0095 <003,001,002,004,005> #

#FUN-910088--add--start--
FUNCTION t100_mmg10_check()
   IF NOT cl_null(g_mmg.mmg10) AND NOT cl_null(g_mmg.mmg23) THEN 
      IF cl_null(g_mmg23_t) OR cl_null(g_mmg_t.mmg10) OR g_mmg23_t != g_mmg.mmg23 OR g_mmg_t.mmg10 != g_mmg.mmg10 THEN
         LET g_mmg.mmg10 = s_digqty(g_mmg.mmg10,g_mmg.mmg23)
         DISPLAY BY NAME g_mmg.mmg10
      END IF
   END IF
   IF NOT cl_null(g_mmg.mmg10) THEN
      IF g_mmg.mmg10=0 THEN RETURN FALSE END IF
      IF g_mmg.mmg10 < 0 THEN 
         CALL cl_err('','aec-020',0)
         RETURN FALSE      
      END IF 
      # --------(check 最小生產數量) ---
      IF g_ima.ima561 > 0 THEN #生產單位批量&最少生產數量
         IF g_mmg.mmg10 < g_ima.ima561 THEN
            CALL cl_err(g_ima.ima561,'amm-307',0)
         END IF
      END IF
      IF NOT cl_null(g_ima.ima56) AND g_ima.ima56>0  THEN #生產單位批量
         IF (g_mmg.mmg10 MOD g_ima.ima56) > 0 THEN
            CALL cl_err(g_ima.ima56,'amm-308',0)
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t100_mmg11_check()
   IF NOT cl_null(g_mmg.mmg11) AND NOT cl_null(g_mmg.mmg23) THEN
      IF cl_null(g_mmg23_t) OR cl_null(g_mmg_t.mmg11) OR g_mmg23_t != g_mmg.mmg23 OR g_mmg_t.mmg11 != g_mmg.mmg11 THEN
         LET g_mmg.mmg11 = s_digqty(g_mmg.mmg11,g_mmg.mmg23)
         DISPLAY BY NAME g_mmg.mmg11
      END IF
   END IF
   IF NOT cl_null(g_mmg.mmg11) THEN
      IF g_mmg.mmg11 < 0 THEN
         RETURN FALSE     
      END IF
   END IF
   RETURN TRUE
END FUNCTION

#FUN-910088--add--end--

#No.FUN-BB0086---add---begin---
FUNCTION t100_mmh05_check()
   IF NOT cl_null(g_mmh[l_ac].mmh05) AND NOT cl_null(g_mmh[l_ac].mmh12) THEN
      IF cl_null(g_mmh[l_ac].mmh05) OR cl_null(g_mmh12_t) OR g_mmh_t.mmh05 != g_mmh[l_ac].mmh05 OR g_mmh12_t != g_mmh[l_ac].mmh12 THEN
         LET g_mmh[l_ac].mmh05=s_digqty(g_mmh[l_ac].mmh05,g_mmh[l_ac].mmh12)
         DISPLAY BY NAME g_mmh[l_ac].mmh05
      END IF
   END IF
   IF NOT cl_null(g_mmh[l_ac].mmh05) THEN
      IF g_mmh[l_ac].mmh05 < 0 THEN
         CALL cl_err('','aec-020',0)
         RETURN FALSE 
      END IF 
   END IF 
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086---add---end---

