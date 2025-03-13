# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: ammt200.4gl
# Descriptions...: 需求單維護作業
# Date & Author..: 00/12/18 By plum
# Modify.........: 01/02/16 By Chien
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4A0248 04/10/19 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0036 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0060 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-550054 05/05/28 By wujie 單據編號加大
# Modify.........: No.MOD-580322 05/08/30 By wujie  中文資訊修改進 ze_file
# Modify.........: No.TQC-5B0162 05/11/17 By Claire sub-146造成無窮迴路
# Modify.........: No.FUN-630010 06/03/08 By saki 流程訊息通知功能
# Modify.........: No.TQC-640006 06/04/03 By Claire 已確認單據不可修改單身
# Modify.........: No.TQC-660096 06/06/22 By saki 修改流程訊息成統一格式
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-690024 06/09/18 By jamie 判斷pmcacti
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加                                             
#                                                           g_rec_b初始化命令                                                       
#                                                          "LET g_rec_b =0"
# Modify.........: No.FUN-6B0030 06/11/13 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-710117 07/03/02 By Ray 1.更改按鈕無效，會刪除單身數據和需求單編號
#                                                2.取消結案按鈕無法使用
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840134 08/04/23 By kim  增加列印功能
# Modify.........: No.FUN-840202 08/05/06 By TSD.liquor 自定欄位功能修改
# Modify.........: No.TQC-940039 09/04/09 By chenyu BEFORE ROW最后不應該有NEXT FIELD 
# Modify.........: No.FUN-980004 09/08/28 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AA0062 10/11/02 By yinhy 倉庫權限使用控管修改 
# Modify.........: No.FUN-AB0056 10/11/15 By houlia 倉庫營運中心權限控管審核段控管
# Modify.........: No.TQC-AB0415 10/12/01 By vealxu mma21沒有show到畫面上
# Modify.........: No.MOD-B40235 11/04/26 by sabrina 單身作廢抓資料時應多加判斷mmb131及mmb132為null
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-910088 11/12/29 By chenjing 增加數量欄位小數取位
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30085 12/06/20 By lixiang 串CR報表改GR報表
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_mma   RECORD LIKE mma_file.*,
    g_mma_t RECORD LIKE mma_file.*,
    g_mma_o RECORD LIKE mma_file.*,
    g_mma_u RECORD LIKE mma_file.*,
    b_mmb           RECORD LIKE mmb_file.*,
    g_mmb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    mmb02     LIKE mmb_file.mmb02,
                    mmb05     LIKE mmb_file.mmb05,
                    mmc02     LIKE mmc_file.mmc02,
                    mmb06     LIKE mmb_file.mmb06,
                    mmb07     LIKE mmb_file.mmb07,
                    mmb08     LIKE mmb_file.mmb08,
                    pmc03     LIKE pmc_file.pmc03,
                    mmb09     LIKE mmb_file.mmb09,
                    mmb10     LIKE mmb_file.mmb10,
                    mmb11     LIKE mmb_file.mmb11,
                    mmb19     LIKE mmb_file.mmb19,
                    mmb12     LIKE mmb_file.mmb12,
                    mmb121    LIKE mmb_file.mmb121,
                    mmb13     LIKE mmb_file.mmb13,
                    mmb131    LIKE mmb_file.mmb131,
                    mmb132    LIKE mmb_file.mmb132,
                    mmb14     LIKE mmb_file.mmb14,
                    mmb141    LIKE mmb_file.mmb141,
                    mmbacti   LIKE mmb_file.mmbacti,
                    mmb15     LIKE mmb_file.mmb15,
                    #FUN-840202 --start---
                    mmbud01 LIKE mmb_file.mmbud01,
                    mmbud02 LIKE mmb_file.mmbud02,
                    mmbud03 LIKE mmb_file.mmbud03,
                    mmbud04 LIKE mmb_file.mmbud04,
                    mmbud05 LIKE mmb_file.mmbud05,
                    mmbud06 LIKE mmb_file.mmbud06,
                    mmbud07 LIKE mmb_file.mmbud07,
                    mmbud08 LIKE mmb_file.mmbud08,
                    mmbud09 LIKE mmb_file.mmbud09,
                    mmbud10 LIKE mmb_file.mmbud10,
                    mmbud11 LIKE mmb_file.mmbud11,
                    mmbud12 LIKE mmb_file.mmbud12,
                    mmbud13 LIKE mmb_file.mmbud13,
                    mmbud14 LIKE mmb_file.mmbud14,
                    mmbud15 LIKE mmb_file.mmbud15
                    #FUN-840202 --end--
                    END RECORD,
    g_mmb_t         RECORD
                    mmb02     LIKE mmb_file.mmb02,
                    mmb05     LIKE mmb_file.mmb05,
                    mmc02     LIKE mmc_file.mmc02,
                    mmb06     LIKE mmb_file.mmb06,
                    mmb07     LIKE mmb_file.mmb07,
                    mmb08     LIKE mmb_file.mmb08,
                    pmc03     LIKE pmc_file.pmc03,
                    mmb09     LIKE mmb_file.mmb09,
                    mmb10     LIKE mmb_file.mmb10,
                    mmb11     LIKE mmb_file.mmb11,
                    mmb19     LIKE mmb_file.mmb19,
                    mmb12     LIKE mmb_file.mmb12,
                    mmb121    LIKE mmb_file.mmb121,
                    mmb13     LIKE mmb_file.mmb13,
                    mmb131    LIKE mmb_file.mmb131,
                    mmb132    LIKE mmb_file.mmb132,
                    mmb14     LIKE mmb_file.mmb14,
                    mmb141    LIKE mmb_file.mmb141,
                    mmbacti   LIKE mmb_file.mmbacti,
                    mmb15     LIKE mmb_file.mmb15,
                    #FUN-840202 --start---
                    mmbud01 LIKE mmb_file.mmbud01,
                    mmbud02 LIKE mmb_file.mmbud02,
                    mmbud03 LIKE mmb_file.mmbud03,
                    mmbud04 LIKE mmb_file.mmbud04,
                    mmbud05 LIKE mmb_file.mmbud05,
                    mmbud06 LIKE mmb_file.mmbud06,
                    mmbud07 LIKE mmb_file.mmbud07,
                    mmbud08 LIKE mmb_file.mmbud08,
                    mmbud09 LIKE mmb_file.mmbud09,
                    mmbud10 LIKE mmb_file.mmbud10,
                    mmbud11 LIKE mmb_file.mmbud11,
                    mmbud12 LIKE mmb_file.mmbud12,
                    mmbud13 LIKE mmb_file.mmbud13,
                    mmbud14 LIKE mmb_file.mmbud14,
                    mmbud15 LIKE mmb_file.mmbud15
                    #FUN-840202 --end--
                    END RECORD,
    g_ima08         LIKE ima_file.ima08,
    g_oea   RECORD LIKE oea_file.*,
    g_oeb   RECORD LIKE oeb_file.*,
     g_wc,g_wc2,g_sql    STRING,                  #No.FUN-580092 HCN        #No.FUN-680100
    g_t1            LIKE mma_file.mma01,          #No.FUN-550054        #No.FUN-680100 VARCHAR(05)
    g_buf,g_buf1    LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(30)
    g_credit        LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    g_start,g_end   LIKE oea_file.oea01,          #No.FUN-680100 VARCHAR(16)
    exT             LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    tot1,tot2,tot3  LIKE bed_file.bed07,          #No.FUN-680100 DECIMAL(12,3)
    g_fun6_sw       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,          #單身筆數        #No.FUN-680100 SMALLINT
    g_flag          LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT        #No.FUN-680100 SMALLINT
#No.FUN-550054--begin
DEFINE g_argv1       LIKE oea_file.oea01          #No.FUN-680100 VARCHAR(16)# 單號
DEFINE g_argv2       LIKE oea_file.oea01          #No.FUN-680100 VARCHAR(16)# 單號
DEFINE g_argv3       LIKE oea_file.oea01          #No.FUN-680100 VARCHAR(16)# 單號
DEFINE g_argv4       STRING                       # No.FUN-630010 執行功能
DEFINE begin_no,end_no     LIKE oea_file.oea01    #No.FUN-680100 VARCHAR(16)# 單號
#No.FUN-550054--end
DEFINE g_ocf RECORD LIKE ocf_file.*
DEFINE p_row,p_col  LIKE type_file.num5           #No.FUN-680100 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  #No.FUN-680100
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680100 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1             #No.FUN-680100 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680100 INTEGER
DEFINE   g_i             LIKE type_file.num5             #count/index for any purpose        #No.FUN-680100 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680100 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680100 SMALLINT
DEFINE   g_mma10_t      LIKE mma_file.mma10          #FUN-910088--add--
 
FUNCTION t200(p_argv1,p_argv2,p_argv3,p_argv4)
#No.FUN-550054--begin
  DEFINE p_argv1       LIKE oea_file.oea01          #No.FUN-680100 # 單號
  DEFINE p_argv2       LIKE oea_file.oea01          #No.FUN-680100 # 單號
  DEFINE p_argv3       LIKE oea_file.oea01          #No.FUN-680100 # 單號
  DEFINE p_argv4       STRING                       # No.FUN-630010
#No.FUN-550054--end
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_wc2=' 1=1'
   LET g_forupd_sql = "SELECT * FROM mma_file WHERE mma01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t200_cl CURSOR FROM g_forupd_sql
 
   LET g_argv1=p_argv1
   LET g_argv2=p_argv2
   LET g_argv3=p_argv3
   LET g_argv4=p_argv4
 
   LET g_flag = 'N'
   LET g_fun6_sw='N'
   #No.FUN-630010 --start--
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv4
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
         #No.TQC-660096 --start--
         OTHERWISE
            CALL t200_q()
         #No.TQC-660096 ---end---
      END CASE
   END IF
   #No.FUN-630010 ---end---
   IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) THEN
      CALL t200_q()
   END IF
   CALL t200_menu()
 
END FUNCTION
 
FUNCTION t200_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   CALL g_mmb.clear()
   IF g_fun6_sw='Y' THEN
      LET g_wc=" 1=1 "
      LET g_wc2=" (mmb121 IS NULL OR mmb121>'",g_today,"') "
      LET g_fun6_sw='N'
   ELSE
      IF cl_null(g_argv1) AND cl_null(g_argv2) AND cl_null(g_argv3) THEN
   INITIALIZE g_mma.* TO NULL    #No.FUN-750051
         CONSTRUCT BY NAME g_wc ON mma01,mma02,mma021,mma03,mma05,mma10,mma06,
                                   mma07,mma08,mma09,mma14,mma20,mma15,mma21,mma211,mma16,
                                   mma17,mma04,mma18,mma19,mma13,mma11,mma12,
                                   mmauser,mmagrup,mmamodu,mmadate,mmaacti,
                                   #FUN-840202   ---start---
                                   mmaud01,mmaud02,mmaud03,mmaud04,mmaud05,
                                   mmaud06,mmaud07,mmaud08,mmaud09,mmaud10,
                                   mmaud11,mmaud12,mmaud13,mmaud14,mmaud15
                                   #FUN-840202    ----end----
            #--No.MOD-4A0248--------
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
           ON ACTION CONTROLP
              CASE
                  WHEN INFIELD(mma01) #需求單號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state= "c"
                      LET g_qryparam.form = "q_mma"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO mma01
                      NEXT FIELD mma01
                  WHEN INFIELD(mma02) #開發執行單號
                      CALL cl_init_qry_var()
                      LET g_qryparam.state= "c"
                      LET g_qryparam.form = "q_mmh05"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO mma02
                      NEXT FIELD mma02
                  WHEN INFIELD(mma05) #料件編號
#FUN-AA0059 --Begin--
                   #    CALL cl_init_qry_var()
                   #    LET g_qryparam.state= "c"
                   #    LET g_qryparam.form = "q_ima"
                   #    CALL cl_create_qry() RETURNING g_qryparam.multiret
                       CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret 
#FUN-AA0059 --End--
                       DISPLAY g_qryparam.multiret TO mma05
                       NEXT FIELD mma05
                  WHEN INFIELD(mma14) #需求類別
                       CALL cl_init_qry_var()
                       LET g_qryparam.state= "c"
                       LET g_qryparam.form = "q_mmi"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO mma14
                       NEXT FIELD mma14
                  WHEN INFIELD(mma15) #部門
                       CALL cl_init_qry_var()
                       LET g_qryparam.state= "c"
                       LET g_qryparam.form = "q_gem"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO mma15
                       NEXT FIELD mma15
                  WHEN INFIELD(mma21) #預設倉庫
                      #No.FUN-AA0062  --Begin
                      # CALL cl_init_qry_var()
                      # LET g_qryparam.state="c"
                      # LET g_qryparam.form = "q_imd"
                      # LET g_qryparam.arg1 = 'SW'
                      # CALL cl_create_qry() RETURNING g_qryparam.multiret
                       CALL q_imd_1(TRUE,TRUE,g_mma.mma21,"","","","") RETURNING g_qryparam.multiret
                      #No.FUN-AA0062  --End
                       DISPLAY g_qryparam.multiret TO mma21
                       NEXT FIELD mma21
                  WHEN INFIELD(mma211) #預設儲位
                      #No.FUN-AA0062  --Begin
                      # CALL cl_init_qry_var()
                      # LET g_qryparam.state="c"
                      # LET g_qryparam.form = "q_ime"
                      # CALL cl_create_qry() RETURNING g_qryparam.multiret
                        CALL q_ime_1(TRUE,TRUE,g_mma.mma211,g_mma.mma21,"","","","","") RETURNING g_qryparam.multiret
                      #No.FUN-AA0062  --End
                       DISPLAY g_qryparam.multiret TO mma211
                       NEXT FIELD mma211
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
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond('mmauser', 'mmagrup') #FUN-980030
         IF INT_FLAG THEN RETURN END IF
 
         CONSTRUCT g_wc2 ON mmb02,mmb05,mmb06,mmb07,mmb08,mmb09,mmb10,mmb11,
                            mmb19,mmb12,mmb121,mmb13,mmb131,mmb132,mmb14,
                            mmb141,mmbacti,mmb15
                            #No.FUN-840202 --start--
                            ,mmbud01,mmbud02,mmbud03,mmbud04,mmbud05
                            ,mmbud06,mmbud07,mmbud08,mmbud09,mmbud10
                            ,mmbud11,mmbud12,mmbud13,mmbud14,mmbud15
                            #No.FUN-840202 ---end---
              FROM s_mmb[1].mmb02,s_mmb[1].mmb05,s_mmb[1].mmb06,s_mmb[1].mmb07,
                   s_mmb[1].mmb08,s_mmb[1].mmb09,s_mmb[1].mmb10,s_mmb[1].mmb11,
                   s_mmb[1].mmb19,s_mmb[1].mmb12,s_mmb[1].mmb121,s_mmb[1].mmb13,
                   s_mmb[1].mmb131,s_mmb[1].mmb132,s_mmb[1].mmb14,
                   s_mmb[1].mmb141,s_mmb[1].mmbacti,s_mmb[1].mmb15
                   #No.FUN-840202 --start--
                   ,s_mmb[1].mmbud01,s_mmb[1].mmbud02,s_mmb[1].mmbud03,s_mmb[1].mmbud04,s_mmb[1].mmbud05
                   ,s_mmb[1].mmbud06,s_mmb[1].mmbud07,s_mmb[1].mmbud08,s_mmb[1].mmbud09,s_mmb[1].mmbud10
                   ,s_mmb[1].mmbud11,s_mmb[1].mmbud12,s_mmb[1].mmbud13,s_mmb[1].mmbud14,s_mmb[1].mmbud15
                   #No.FUN-840202 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
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
      ELSE
         IF cl_null(g_argv2) AND cl_null(g_argv3) THEN
            LET g_wc =" mma01 ='",g_argv1,"'"
            LET g_wc2=" 1=1"
         ELSE
            LET g_wc =" mma02 ='",g_argv2,"' AND mma021='",g_argv3,"' "
            LET g_wc2=" 1=1"
         END IF
      END IF
   END IF
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  mma01 FROM mma_file LEFT OUTER JOIN ima_file ON ima_file.ima01 = mma05 ",
                  " WHERE  ", g_wc CLIPPED,
                  " ORDER BY mma01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE  mma01 ",
                  "  FROM mma_file LEFT OUTER JOIN ima_file ON mma05 = ima_file.ima01,mmb_file",
                  " WHERE mma01 = mmb01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY mma01"
   END IF
 
   PREPARE t200_prepare FROM g_sql
   DECLARE t200_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t200_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM mma_file,ima_file ",
                "WHERE ima01 = mma05 AND ",g_wc CLIPPED
   ELSE
       LET g_sql="SELECT COUNT(DISTINCT mma01) ",
                 "  FROM mma_file,mmb_file,ima_file ",
                 " WHERE mmb01=mma01 AND ima01 = mma05 AND ",g_wc CLIPPED,
                 " AND ",g_wc2 CLIPPED
   END IF
   PREPARE t200_precount FROM g_sql
   DECLARE t200_count CURSOR FOR t200_precount
 
END FUNCTION
 
FUNCTION t200_menu()
 
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
               CALL t200_b('A')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t200_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t200_z()
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t200_x()
               CALL t200_x(1)   #CHI-D20010
            END IF
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t200_x(2)
            END IF
         #CHI-D20010---end
         WHEN "detail_void"
            IF cl_chk_act_auth() THEN
               CALL t200_bx()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "close_the_case"
            IF cl_chk_act_auth() THEN
               CALL t200_2()
            END IF
#        WHEN "undo_close"     #No.TQC-710117
         WHEN "undo_close"
            IF cl_chk_act_auth() THEN
               CALL t200_3()
            END IF
         WHEN "add_detail"
            IF cl_chk_act_auth() THEN
               CALL t200_4()
            END IF
         WHEN "qry_w_o"
            IF cl_chk_act_auth() THEN
               LET g_msg="ammq200 '",g_mma.mma01,"' "
               CALL cl_cmdrun(g_msg CLIPPED)
            END IF
         WHEN "qry_completed_progress_late"
            IF cl_chk_act_auth() THEN
               LET g_fun6_sw='Y'
               CALL t200_q()
            END IF
         WHEN "exporttoexcel"     #FUN-4B0036
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mmb),'','')
            END IF
         #No.FUN-6B0079-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_mma.mma01 IS NOT NULL THEN
                    LET g_doc.column1 = "mma01"
                    LET g_doc.value1 = g_mma.mma01
                    CALL cl_doc()
                 END IF
              END IF
         #No.FUN-6B0079-------add--------end----
        #FUN-840134...............begin
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL t200_out()
           END IF
        #FUN-840134...............end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t200_a()
#No.FUN-550054--begin
DEFINE li_result             LIKE type_file.num5          #No.FUN-680100 SMALLINT
#No.FUN-550054--end
 
   IF s_ammshut(0) THEN
      RETURN
   END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_mmb.clear()
 
   INITIALIZE g_mma.* TO NULL
   LET g_mma_o.* = g_mma.*
   LET g_mma_t.* = g_mma.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_mma.mma07  =g_today
      LET g_mma.mma08  =g_today
      LET g_mma.mma04  ='N'
      LET g_mma.mma15  =g_grup
      LET g_mma.mma17  ='N'
      LET g_mma.mma18  =0
      LET g_mma.mma19  ='N'
      LET g_mma.mmaacti='Y'
      LET g_mma.mmauser=g_user
      LET g_mma.mmaoriu = g_user #FUN-980030
      LET g_mma.mmaorig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_mma.mmagrup=g_grup
      LET g_mma.mmadate=g_today
      LET g_mma.mmaplant = g_plant #FUN-980004 add
      LET g_mma.mmalegal = g_legal #FUN-980004 add
      SELECT mmd16 INTO g_mma.mma21 FROM mmd_file WHERE mmd00='0'
 
      CALL t200_i("a")                #輸入單頭
 
      IF INT_FLAG THEN
         INITIALIZE g_mma.* TO NULL
         LET INT_FLAG=0
         CALL cl_err('',9001,0)
         ROLLBACK WORK
         EXIT WHILE
      END IF
 
      IF g_mma.mma01 IS NULL THEN
         CONTINUE WHILE
      END IF
#No.FUN-550054--begin
      BEGIN WORK
      CALL s_auto_assign_no("asf",g_mma.mma01,g_mma.mma07,"M","mma_file","mma01","","","")
      RETURNING li_result,g_mma.mma01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_mma.mma01
#     IF g_smy.smyauno='Y' THEN
#        BEGIN WORK
#        CALL s_smyauno(g_mma.mma01,g_mma.mma07) RETURNING g_i,g_mma.mma01
#        IF g_i THEN
#           CONTINUE WHILE
#        END IF
#        DISPLAY BY NAME g_mma.mma01
#     END IF
#No.FUN-550054--end
      IF cl_null(g_mma.mma211) THEN
         LET g_mma.mma211=' '
      END IF
 
      IF cl_null(g_mma.mma18) THEN
         LET g_mma.mma18=' '
      END IF
 
      INSERT INTO mma_file VALUES (g_mma.*)
      IF STATUS THEN
         ROLLBACK WORK
         CALL cl_err(g_mma.mma01,STATUS,1)
         CONTINUE WHILE
      END IF
 
      SELECT mma01 INTO g_mma.mma01 FROM mma_file
       WHERE mma01 = g_mma.mma01
      COMMIT WORK
      CALL cl_flow_notify(g_mma.mma01,'I')
 
      LET g_mma_t.* = g_mma.*
      LET g_rec_b =0                     #NO.FUN-680064 
      CALL t200_b('A')                   #輸入單身
 
      # 新增自動確認功能 Modify by WUPN 96-05-06 ----------
#No.FUN-550054--begin
#     LET g_t1=g_mma.mma01[1,3]
      LET g_t1=s_get_doc_no(g_mma.mma01)
#No.FUN-550054--end
      SELECT * INTO g_smy.* FROM smy_file WHERE smyslip=g_t1
      IF STATUS THEN
#         CALL cl_err('sel smy_file',STATUS,0)
          CALL cl_err3("sel","smy_file",g_t1,"",STATUS,"","sel smy_file",1)       #NO.FUN-660094
      END IF
 
      IF g_smy.smydmy4='Y' THEN  #單據需自動確認
         CALL t200_y()
      END IF
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t200_u()
 
    IF s_ammshut(0) THEN
       RETURN
    END IF
 
    SELECT * INTO g_mma.*
      FROM mma_file
     WHERE mma01 = g_mma.mma01
 
    IF g_mma.mma01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    IF g_mma.mma04 = 'Y' THEN
       CALL cl_err('',9004,0)
       RETURN
    END IF
 
    IF g_mma.mma17 = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF
 
    IF g_mma.mma17 = 'Y' THEN
       CALL cl_err('','aap-086',0)
       RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_mma_o.* = g_mma.*
    LET g_mma10_t = g_mma.mma10     #FUN-910088--add--
    BEGIN WORK
 
    OPEN t200_cl USING g_mma.mma01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t200_cl INTO g_mma.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_mma.mma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL t200_show()
 
    WHILE TRUE
       LET g_mma.mmamodu=g_user
       LET g_mma.mmadate=g_today
 
       CALL t200_i("u")                      #欄位更改
 
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_mma.*=g_mma_t.*
          CALL t200_show()
          CALL cl_err('','9001',0)
          EXIT WHILE
       END IF
 
       IF cl_null(g_mma.mma211) THEN
          LET g_mma.mma211=' '
       END IF
 
       IF cl_null(g_mma.mma18)  THEN
          SELECT MIN(mmb02) INTO g_mma.mma18 FROM mmb_file
           WHERE mmb01 = g_mma.mma01
             AND mmbacti='Y'
          IF cl_null(g_mma.mma18) THEN
             LET g_mma.mma18 = 0
          END IF
       END IF
 
       UPDATE mma_file SET * = g_mma.* WHERE mma01 = g_mma.mma01
       IF STATUS THEN
#          CALL cl_err(g_mma.mma01,STATUS,0)
           CALL cl_err3("upd","mma_file",g_mma_t.mma01,"",STATUS,"","",1)       #NO.FUN-660094
          CONTINUE WHILE
       END IF
#No.TQC-710117 --begin
       IF g_mma.mma01 != g_mma_t.mma01 THEN
          UPDATE mmb_file SET mmb01=g_mma.mma01 WHERE mmb01=g_mma_t.mma01
          IF STATUS THEN
             CALL cl_err3("upd","mmb_file",g_mma_t.mma01,"",SQLCA.sqlcode,"","upd mmb01",1)
             ROLLBACK WORK
             RETURN
          END IF
       END IF
#No.TQC-710117 --end
       EXIT WHILE
    END WHILE
 
    CLOSE t200_cl
    COMMIT WORK
    CALL cl_flow_notify(g_mma.mma01,'U')
    LET g_t1=g_mma.mma01[1,g_doc_len]
    SELECT * INTO g_smy.* FROM smy_file WHERE smyslip=g_t1
 
    IF STATUS THEN
#       CALL cl_err('sel smy_file',STATUS,0)
        CALL cl_err3("sel","smy_file",g_t1,"",STATUS,"","sel smy_file",1)       #NO.FUN-660094
       RETURN
    END IF
 
    #單據已確認或單據不需自動確認
    IF g_smy.smydmy4='Y' THEN
       CALL t200_y()
    END IF
 
END FUNCTION
 
FUNCTION t200_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1          #a:輸入 u:更改        #No.FUN-680100 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1          #判斷必要欄位是否有輸入        #No.FUN-680100 VARCHAR(1)
  DEFINE l_n1            LIKE type_file.num5          #No.FUN-680100 SMALLINT
  DEFINE l_mma16         LIKE mma_file.mma16
  DEFINE l_ima56         LIKE ima_file.ima56
  DEFINE l_ima561        LIKE ima_file.ima561
  DEFINE l_yy,l_mm       LIKE type_file.num5          #No.FUN-680100 SMALLINT
  DEFINE l_mmh           RECORD LIKE mmh_file.*
  DEFINE l_mmg           RECORD LIKE mmg_file.*
  DEFINE l_n             LIKE type_file.num5          #No.FUN-680100 SMALLINT
  DEFINE g_i,sn1,sn2     LIKE type_file.num5          #No.FUN-680100 SMALLINT
#No.FUN-550054--begin
  DEFINE li_result       LIKE type_file.num5          #No.FUN-680100 SMALLINT
#No.FUN-550054--end
  DEFINE l_tf            LIKE type_file.chr1          #FUN-910088--add--
 
   DISPLAY BY NAME g_mma.mma01,g_mma.mma02,g_mma.mma021,g_mma.mma03,g_mma.mma05,
                   g_mma.mma051,g_mma.mma06,g_mma.mma04,g_mma.mma13,g_mma.mma07,
                   g_mma.mma08,g_mma.mma09,g_mma.mma10,g_mma.mma16,g_mma.mma11,
                   g_mma.mma12,g_mma.mma14,g_mma.mma20,g_mma.mma15,
                   g_mma.mma21,g_mma.mma211 ,g_mma.mma16,
                   g_mma.mma18,g_mma.mma19,g_mma.mma17,g_mma.mmauser,
                   g_mma.mmagrup,g_mma.mmamodu,g_mma.mmadate,g_mma.mmaacti,
                   #FUN-840202     ---start---
                   g_mma.mmaud01,g_mma.mmaud02,g_mma.mmaud03,g_mma.mmaud04,
                   g_mma.mmaud05,g_mma.mmaud06,g_mma.mmaud07,g_mma.mmaud08,
                   g_mma.mmaud09,g_mma.mmaud10,g_mma.mmaud11,g_mma.mmaud12,
                   g_mma.mmaud13,g_mma.mmaud14,g_mma.mmaud15 
                   #FUN-840202     ----end----
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT BY NAME g_mma.mma01,g_mma.mma02,g_mma.mma021,g_mma.mma03,g_mma.mma05, g_mma.mmaoriu,g_mma.mmaorig,
                 g_mma.mma051,g_mma.mma06,g_mma.mma07,g_mma.mma08,g_mma.mma09,
                 g_mma.mma14,g_mma.mma20,g_mma.mma15,
                 g_mma.mma21,g_mma.mma211 ,g_mma.mma16,
                 #FUN-840202     ---start---
                 g_mma.mmaud01,g_mma.mmaud02,g_mma.mmaud03,g_mma.mmaud04,
                 g_mma.mmaud05,g_mma.mmaud06,g_mma.mmaud07,g_mma.mmaud08,
                 g_mma.mmaud09,g_mma.mmaud10,g_mma.mmaud11,g_mma.mmaud12,
                 g_mma.mmaud13,g_mma.mmaud14,g_mma.mmaud15 
                 #FUN-840202     ----end----
        WITHOUT DEFAULTS
 
      BEFORE INPUT
      #FUN-910088--add--start--
         IF p_cmd = 'a' THEN
            LET g_mma10_t = NULL            
         END IF
      #FUN-910088--add--end--
         LET g_before_input_done = FALSE
         CALL t200_set_entry(p_cmd)
         CALL t200_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
#No.FUN-550054--begin
         CALL cl_set_docno_format("mma01")
#No.FUN-550054--end
 
 
        AFTER FIELD mma01
           IF NOT cl_null(g_mma.mma01) THEN
#No.FUN-550054--begin
              LET g_t1=g_mma.mma01[1,g_doc_len]
#             CALL s_check_no("asf",g_t1,"","M","mma_file","mma01","")     #No.TQC-710117
              CALL s_check_no("asf",g_mma.mma01,g_mma_t.mma01,"M","mma_file","mma01","")     #No.TQC-710117
              RETURNING li_result,g_mma.mma01
              DISPLAY BY NAME g_mma.mma01
              IF ( NOT li_result) THEN
                 LET g_mma.mma01 = g_mma_o.mma01
                 # TQC-5B0162-begin
                 DISPLAY BY NAME g_mma.mma01
                 IF p_cmd='u' THEN
                    EXIT INPUT
                 ELSE
                    NEXT FIELD mma01
                 END IF
                 # TQC-5B0162-end
              END IF
#             CALL s_mfgslip(g_t1,'asf','M')     #檢查需求單別
#             IF NOT cl_null(g_errno) THEN               #抱歉, 有問題
#                CALL cl_err(g_t1,g_errno,0)
#                NEXT FIELD mma01
#             END IF
#             IF cl_null(g_mma.mma01[5,10]) AND g_smy.smyauno = 'N' THEN
#                NEXT FIELD mma01
#             END IF
#             IF g_mma.mma01 != g_mma_t.mma01 OR g_mma_t.mma01 IS NULL THEN
#                IF g_smy.smyauno = 'Y' AND NOT cl_chk_data_continue(g_mma.mma01[5,10]) THEN
#                   CALL cl_err('','9056',0)
#                   NEXT FIELD mma01
#                END IF
#                SELECT count(*) INTO g_cnt FROM mma_file
#                 WHERE mma01 = g_mma.mma01
#                IF g_cnt > 0 THEN   #資料重複
#                   CALL cl_err(g_mma.mma01,-239,0)
#                   LET g_mma.mma01 = g_mma_t.mma01
#                   DISPLAY BY NAME g_mma.mma01
#                   NEXT FIELD mma01
#                END IF
#             END IF
#No.FUN-550054--end
           END IF
 
       BEFORE FIELD mma02
          CALL t200_set_entry(p_cmd)
 
       AFTER FIELD mma02
          CALL t200_set_no_entry(p_cmd)
 
       AFTER FIELD mma021
          LET l_tf = NULL    #FUN-910088--add--
          #若執行工單為空白,而開發工單不為空白時,重新輸入
          IF NOT cl_null(g_mma.mma021) AND cl_null(g_mma.mma02) THEN
             CALL cl_err(g_mma.mma02,'amm-001',0)
             LET g_mma.mma02 =g_mma_t.mma02
             LET g_mma.mma021=g_mma_t.mma021
             DISPLAY BY NAME g_mma.mma02,g_mma.mma021
             NEXT FIELD mma02
          END IF
          #若開發工單為空白,而執行工單不為空白時,重新輸入
          IF cl_null(g_mma.mma021) AND NOT cl_null(g_mma.mma02) THEN
             CALL cl_err(g_mma.mma02,'amm-002',0)
             LET g_mma.mma02 =g_mma_t.mma02
             LET g_mma.mma021=g_mma_t.mma021
             DISPLAY BY NAME g_mma.mma02,g_mma.mma021
             NEXT FIELD mma02
          END IF
          INITIALIZE l_mmg.* TO NULL
          SELECT * INTO l_mmg.* FROM mmg_file
           WHERE mmg01=g_mma.mma02 AND mmg02=g_mma.mma021
             AND mmg14='N'
          IF SQLCA.SQLCODE THEN  #No.7926
#             CALL cl_err(g_mma.mma02,'amm-003',0)
              CALL cl_err3("sel","mmg_file",g_mma.mma02,g_mma.mma021,"amm-003","","",1)       #NO.FUN-660094
             LET g_mma.mma02 =g_mma_t.mma02
             LET g_mma.mma021=g_mma_t.mma021
             LET g_mma.mma20 =g_mma_t.mma20
             LET g_mma.mma08 =g_mma_t.mma08
             LET g_mma.mma09 =g_mma_t.mma09
             LET g_mma.mma05 =g_mma_t.mma05
             LET g_mma.mma051=g_mma_t.mma051
             LET g_mma.mma10 =g_mma_t.mma10
             DISPLAY BY NAME g_mma.mma02,g_mma.mma021,
                     g_mma.mma20,g_mma.mma08,g_mma.mma09,
                     g_mma.mma05,g_mma.mma051,g_mma.mma10
             NEXT FIELD mma02
          ELSE
             IF l_mmg.mmgacti <> 'Y' THEN
 #No.MOD-580322--begin
                CALL cl_err('','amm-109','1')
#               ERROR "此筆資料,尚未確認 !!!"
 #No.MOD-580322--end
                NEXT FIELD mma02
             END IF
             LET g_mma.mma20=l_mmg.mmg03
             LET g_mma.mma08=l_mmg.mmg07
             LET g_mma.mma09=l_mmg.mmg10
             LET g_mma.mma05=l_mmg.mmg04
             LET g_mma.mma10=l_mmg.mmg23
             SELECT ima55,ima56,ima561 INTO g_mma.mma10,l_ima56,l_ima561
               FROM ima_file WHERE ima01=g_mma.mma05
           #FUN-910088--add--start--
             CALL t200_mma09_check(l_ima561,l_ima56) RETURNING l_tf
           #FUN-910088--add--end--
          END IF
          DISPLAY BY NAME g_mma.mma20,g_mma.mma08,g_mma.mma09,
                          g_mma.mma05,g_mma.mma10
          #FUN-910088--add--start--
          LET g_mma10_t = g_mma.mma10
          IF NOT cl_null(l_tf) AND NOT l_tf THEN
             NEXT FIELD mma09
          END IF
          #FUN-910088--add--end--
 
       AFTER FIELD mma03
          #若開發工單不為空白,而執行工單不為空白時--> mmh_file
          IF NOT cl_null(g_mma.mma021) AND NOT cl_null(g_mma.mma02) AND
             cl_null(g_mma.mma03) THEN
             NEXT FIELD mma03
          END IF
          IF NOT cl_null(g_mma.mma021) AND NOT cl_null(g_mma.mma02) AND
             NOT cl_null(g_mma.mma03) THEN
             SELECT COUNT(*) INTO g_cnt FROM mma_file
              WHERE mma02=g_mma.mma02 AND mma021=g_mma.mma021
                AND mma03=g_mma.mma03
             IF g_cnt >0 THEN
                CALL cl_err(g_mma.mma03,'amm-004',0)
                LET g_mma.mma02 =g_mma_t.mma02
                LET g_mma.mma021=g_mma_t.mma021
                LET g_mma.mma03 =g_mma_t.mma03
                DISPLAY BY NAME g_mma.mma02,g_mma.mma021,g_mma.mma03
                NEXT FIELD mma02
             END IF
             INITIALIZE l_mmh.* TO NULL
             SELECT * INTO l_mmh.* FROM mmh_file
              WHERE mmh01=g_mma.mma02 AND mmh011=g_mma.mma021
                AND mmh02=g_mma.mma03
             IF SQLCA.SQLCODE THEN
#                CALL cl_err(g_mma.mma03,'amm-003',0)
                 CALL cl_err3("sel","mmh_file",g_mma.mma02,g_mma.mma021,"amm-003","","",1)       #NO.FUN-660094
                LET g_mma.mma05 = g_mma_t.mma05
                DISPLAY BY NAME g_mma.mma05
             ELSE
                LET g_mma.mma21 =l_mmh.mmh30
                LET g_mma.mma211=l_mmh.mmh31
                DISPLAY BY NAME g_mma.mma21,g_mma.mma211
                NEXT FIELD mma06
             END IF
          END IF
 
       AFTER FIELD mma05
          IF NOT cl_null(g_mma.mma05) THEN
            #FUN-AA0059 ------------------add start---------------
             IF NOT s_chk_item_no(g_mma.mma05,'') THEN
                CALL  cl_err('',g_errno,1)
                LET g_mma.mma05 =g_mma_t.mma05
                LET g_mma.mma10 =g_mma_t.mma10
                DISPLAY BY NAME g_mma.mma05,g_mma.mma10
                NEXT FIELD mma05
             END IF
            #FUN-AA059 ----------------add end---------------
             SELECT ima55,ima56,ima561,ima08
               INTO g_mma.mma10,l_ima56,l_ima561,g_ima08
               FROM ima_file
              WHERE ima01=g_mma.mma05
             IF SQLCA.SQLCODE THEN  #No.7926
#                CALL cl_err(g_mma.mma03,'asf-677',0)
                 CALL cl_err3("sel","ima_file",g_mma.mma05,"","asf-667","","",1)       #NO.FUN-660094
                LET g_mma.mma05 =g_mma_t.mma05
                LET g_mma.mma10 =g_mma_t.mma10
                DISPLAY BY NAME g_mma.mma05,g_mma.mma10
                NEXT FIELD mma05
             END IF
             DISPLAY g_ima08 TO ima08
             DISPLAY BY NAME g_mma.mma05,g_mma.mma10
          #FUN-910088--add--start--
             IF NOT t200_mma09_check(l_ima561,l_ima56) THEN
                LET g_mma10_t = g_mma.mma10
                NEXT FIELD mma09
             END IF
             LET g_mma10_t = g_mma.mma10
          #FUN-910088--add--end--
          END IF

 
       BEFORE FIELD mma09
          SELECT COUNT(*) INTO g_cnt FROM mmb_file WHERE mmb01=g_mma.mma01
          IF g_cnt >0 THEN NEXT FIELD NEXT END IF
 
       AFTER FIELD mma09
          IF NOT t200_mma09_check(l_ima561,l_ima56) THEN NEXT FIELD mma09 END IF    #FUN-910088--add--
      #FUN-910088--mark--start--
      #   IF NOT cl_null(g_mma.mma09) THEN
      #      IF g_mma.mma09 <=0 THEN
      #         NEXT FIELD mma09
      #      END IF
      #      #最少生產數量
      #      IF l_ima561 > 0 THEN
      #         IF g_mma.mma09<l_ima561 THEN
      #            CALL cl_err(l_ima561,'asf-307',0)
      #            NEXT FIELD mma09
      #         END IF
      #      END IF
      #      #生產單位批量
      #      IF NOT cl_null(l_ima56) AND l_ima56>0  THEN
      #         IF (g_mma.mma09 MOD l_ima56) > 0 THEN
      #            CALL cl_err(l_ima56,'asf-308',0)
      #            NEXT FIELD mma09
      #         END IF
      #      END IF
      #   END IF
      #FUN-910088--mark--end--
 
       AFTER FIELD mma14
          IF cl_null(g_mma.mma14) THEN NEXT FIELD mma14 END IF
          CALL t200_mma14()
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_mma.mma14,'amm-005',0)
             LET g_mma.mma14 =g_mma_t.mma14
             DISPLAY BY NAME g_mma.mma14
             NEXT FIELD mma14
          END IF
          IF (g_mma.mma14 = 'AA' OR g_mma.mma14 = 'BB') THEN
             IF g_mma.mma021 IS NULL OR g_mma.mma021 = ' ' THEN
                NEXT FIELD mma14
             END IF
          END IF
 
       AFTER FIELD mma20
          IF NOT cl_null(g_mma.mma20) THEN
             IF g_mma.mma20 NOT MATCHES '[1-4]' THEN
                NEXT FIELD mma20
             END IF
          END IF
 
       AFTER FIELD mma15
          IF NOT cl_null(g_mma.mma15) THEN
             CALL t200_mma15()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_mma.mma15,'aap-039',0)
                LET g_mma.mma15 =g_mma_t.mma15
                DISPLAY BY NAME g_mma.mma15
                NEXT FIELD mma15
             END IF
          END IF
 
      AFTER FIELD mma21
         IF NOT cl_null(g_mma.mma21) THEN
            #------>check-1  檢查倉庫須存在否
            CALL s_stkchk(g_mma.mma21,'A') RETURNING g_i
            IF NOT g_i THEN
               CALL cl_err('s_stkchk1:','mfg1100',0)
               NEXT FIELD mma21
            END IF
            #No.FUN-AA0062  --Begin
            IF NOT s_chk_ware(g_mma.mma21) THEN
               NEXT FIELD mma21
            END IF
            #No.FUN-AA0062  --End
            LET sn1=0 LET sn2=0
            #------>check-2  檢查是否為可用倉
            CALL s_swyn(g_mma.mma21) RETURNING sn1,sn2
            IF sn1=1 AND g_mma.mma21 != g_mma_t.mma21 THEN
               LET g_mma_t.mma21=g_mma.mma21
               CALL cl_err(g_mma.mma21,'mfg6080',0)
               NEXT FIELD mma21
            ELSE
               IF sn2=2 AND g_mma.mma21 != g_mma_t.mma21 THEN
                  CALL cl_err(g_mma.mma21,'mfg6085',0)
                  LET g_mma_t.mma21=g_mma.mma21
                  NEXT FIELD mma21
               END IF
            END IF
            LET sn1=0 LET sn2=0
         END IF
 
      AFTER FIELD mma211
         IF cl_null(g_mma.mma211) THEN
            LET g_mma.mma211=' '
         END IF
 
      #FUN-840202     ---start---
      AFTER FIELD mmaud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmaud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmaud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmaud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmaud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmaud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmaud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmaud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmaud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmaud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmaud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmaud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmaud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmaud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmaud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-840202     ----end----
 
 
       ON ACTION controlp
          CASE WHEN INFIELD(mma01) #查詢單据
#No.FUN-550054--begin
#                   LET g_t1=g_mma.mma01[1,3]
                    LET g_t1=s_get_doc_no(g_mma.mma01)
                   CALL q_smy(FALSE,TRUE,g_t1,'ASF','M') RETURNING g_t1 #TQC-670008
#                   CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                   LET g_mma.mma01[1,3]=g_t1
                    LET g_mma.mma01=g_t1
#No.FUN-550054--end
                    DISPLAY BY NAME g_mma.mma01
                    NEXT FIELD mma01
               WHEN INFIELD(mma02) OR INFIELD(mma021) OR INFIELD(mma03)
#                CALL q_mmh(0,0,g_mma.mma02,g_mma.mma021,g_mma.mma03)
#                     RETURNING g_mma.mma02,g_mma.mma021,g_mma.mma03
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_mmh"
                 LET g_qryparam.default1 = g_mma.mma02
                 LET g_qryparam.default2 = g_mma.mma021
                 LET g_qryparam.default3 = g_mma.mma03
                 CALL cl_create_qry() RETURNING g_mma.mma02,g_mma.mma021,g_mma.mma03
#                 CALL FGL_DIALOG_SETBUFFER( g_mma.mma02 )
#                 CALL FGL_DIALOG_SETBUFFER( g_mma.mma021 )
#                 CALL FGL_DIALOG_SETBUFFER( g_mma.mma03 )
                 DISPLAY BY NAME g_mma.mma02,g_mma.mma021,g_mma.mma03
                 IF INFIELD(mma02)  THEN NEXT FIELD mma02  END IF
                 IF INFIELD(mma021) THEN NEXT FIELD mma021 END IF
                 IF INFIELD(mma03)  THEN NEXT FIELD mma03  END IF
               WHEN INFIELD(mma14)
#                CALL q_mmi(0,0,g_mma.mma14,'2') RETURNING g_mma.mma14
#                CALL FGL_DIALOG_SETBUFFER( g_mma.mma14 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_mmi"
                 LET g_qryparam.default1 = g_mma.mma14
                 LET g_qryparam.where = " mmi03 = '2' "
                 CALL cl_create_qry() RETURNING g_mma.mma14
#                 CALL FGL_DIALOG_SETBUFFER( g_mma.mma14 )
                 DISPLAY BY NAME g_mma.mma14
                 NEXT FIELD mma14
               WHEN INFIELD(mma05)
#                CALL q_ima(0,0,g_mma.mma05) RETURNING g_mma.mma05
#                CALL FGL_DIALOG_SETBUFFER( g_mma.mma05 )
#FUN-AA0059 --Begin--
               #  CALL cl_init_qry_var()
               #  LET g_qryparam.form ="q_ima"
               #  LET g_qryparam.default1 = g_mma.mma05
               #  CALL cl_create_qry() RETURNING g_mma.mma05
                  CALL q_sel_ima(FALSE, "q_ima", "", g_mma.mma05, "", "", "", "" ,"",'' )  RETURNING g_mma.mma05
#FUN-AA0059 --End---
#                 CALL FGL_DIALOG_SETBUFFER( g_mma.mma05 )
                 DISPLAY BY NAME g_mma.mma05
                 NEXT FIELD mma05
               WHEN INFIELD(mma15)
#                CALL q_gem(05,11,g_mma.mma15) RETURNING g_mma.mma15
#                CALL FGL_DIALOG_SETBUFFER( g_mma.mma15 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_mma.mma15
                 CALL cl_create_qry() RETURNING g_mma.mma15
#                 CALL FGL_DIALOG_SETBUFFER( g_mma.mma15 )
                 DISPLAY BY NAME g_mma.mma15
                 NEXT FIELD mma15
            WHEN INFIELD(mma21)
#              CALL q_imd(0,0,g_mma.mma21,'A') RETURNING g_mma.mma21
#              CALL FGL_DIALOG_SETBUFFER( g_mma.mma21 )
#               CALL cl_init_qry_var()
#No.FUN-AA0062  --Begin
#               LET g_qryparam.form ="q_imd"
              #LET g_qryparam.default1 = g_mma.mma21,'A'
#                LET g_qryparam.default1 = g_mma.mma21 #MOD-4A0213
#                LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#               CALL cl_create_qry() RETURNING g_mma.mma21
                CALL q_imd_1(FALSE,TRUE,g_mma.mma21,"","","","") RETURNING g_mma.mma21
#No.FUN-AA0062  --End
#               CALL FGL_DIALOG_SETBUFFER( g_mma.mma21 )
               DISPLAY BY NAME g_mma.mma21
               NEXT FIELD mma21
            WHEN INFIELD(mma211)
#              CALL q_ime(2,0,g_mma.mma211,g_mma.mma21,'A')
#                         RETURNING g_mma.mma211
#              CALL FGL_DIALOG_SETBUFFER( g_mma.mma211 )
#No.FUN-AA0062  --Begin
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_ime"
#                LET g_qryparam.default1 = g_mma.mma211,g_mma.mma21,'A'
#                LET g_qryparam.default1 = g_mma.mma211          #MOD-4A0063
#                LET g_qryparam.arg1     = g_mma.mma21 #倉庫編號 #MOD-4A0063
#                LET g_qryparam.arg2     = 'SW'        #倉庫類別 #MOD-4A0063
#               CALL cl_create_qry() RETURNING g_mma.mma211
                CALL q_ime_1(FALSE,TRUE,g_mma.mma211,g_mma.mma21,"","","","","") RETURNING g_mma.mma211
#No.FUN-AA0062  --End
#               CALL FGL_DIALOG_SETBUFFER( g_mma.mma211 )
               DISPLAY BY NAME g_mma.mma211
               NEXT FIELD mma211
            END CASE
 
       ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       #MOD-650015 --start
       #ON ACTION CONTROLO                        # 沿用所有欄位
       #   IF INFIELD(mma01) THEN
       #       LET g_mma.* = g_mma_t.*
       #       CALL t200_show()
       #       NEXT FIELD mma01
       #   END IF
       #MOD-650015 --end
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       AFTER INPUT
          LET g_mma.mmauser = s_get_data_owner("mma_file") #FUN-C10039
          LET g_mma.mmagrup = s_get_data_group("mma_file") #FUN-C10039
          IF INT_FLAG THEN                         # 若按了DEL鍵
             EXIT INPUT
          END IF
          LET l_flag = 'N'
          IF cl_null(g_mma.mma01) THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME g_mma.mma01
          END IF
          IF NOT cl_null(g_mma.mma02) AND
          #  (cl_null(g_mma.mma021) OR cl_null(g_mma.mma03)) THEN
             cl_null(g_mma.mma021) THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME g_mma.mma02,g_mma.mma021,g_mma.mma03
 
          END IF
          IF cl_null(g_mma.mma05) THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME g_mma.mma05
          END IF
          IF cl_null(g_mma.mma07) THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME g_mma.mma07
          END IF
          IF cl_null(g_mma.mma08) THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME g_mma.mma08
          END IF
          IF cl_null(g_mma.mma09) THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME g_mma.mma09
          END IF
          IF cl_null(g_mma.mma14) THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME g_mma.mma14
          END IF
          IF cl_null(g_mma.mma15) THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME g_mma.mma15
          END IF
          IF l_flag = 'Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD mma01
          END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
 
END FUNCTION
 
FUNCTION t200_mma15()    #部門
   DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
          l_gem02     LIKE gem_file.gem02,
          l_gemacti   LIKE gem_file.gemacti
 
   LET g_errno = ' '
   SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
    WHERE gem01=g_mma.mma15
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                  LET l_gem02 = NULL
        WHEN l_gemacti='N' LET g_errno = '9028' LET l_gem02 = NULL
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   DISPLAY l_gem02 TO FORMONLY.gem02
 
END FUNCTION
 
FUNCTION t200_mma14()    #需求類別 mmi03='2'
   DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
          l_mmi02     LIKE mmi_file.mmi02,
          l_mmiacti   LIKE mmi_file.mmiacti
 
   LET g_errno = ' '
   SELECT mmi02,mmiacti INTO l_mmi02,l_mmiacti FROM mmi_file
    WHERE mmi01 = g_mma.mma14 AND mmi03='2'
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg3097'
         LET l_mmi02 = NULL
      WHEN l_mmiacti='N'
         LET g_errno = '9028'
         LET l_mmi02 = NULL
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   ERROR l_mmi02
 
END FUNCTION
 
FUNCTION t200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
 
    CALL t200_cs()
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_mma.* TO NULL
       RETURN
    END IF
 
    MESSAGE " SEARCHING ! "
 
    OPEN t200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_mma.* TO NULL
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
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680100 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680100 INTEGER
 
    MESSAGE ""
    CASE p_flag
       WHEN 'N' FETCH NEXT     t200_cs INTO g_mma.mma01
       WHEN 'P' FETCH PREVIOUS t200_cs INTO g_mma.mma01
       WHEN 'F' FETCH FIRST    t200_cs INTO g_mma.mma01
       WHEN 'L' FETCH LAST     t200_cs INTO g_mma.mma01
       WHEN '/'
          IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
          FETCH ABSOLUTE g_jump t200_cs INTO g_mma.mma01
          LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_mma.* TO NULL   #No.FUN-6B0079  add
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
 
    SELECT * INTO g_mma.* FROM mma_file WHERE mma01 = g_mma.mma01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_mma.mma01,SQLCA.sqlcode,0)
        CALL cl_err3("sel","mma_file",g_mma.mma01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660094
       INITIALIZE g_mma.* TO NULL
       RETURN
    ELSE
       LET g_data_owner=g_mma.mmauser           #FUN-4C0060權限控管
       LET g_data_group=g_mma.mmagrup
       LET g_data_plant = g_mma.mmaplant #FUN-980030
    END IF
 
    CALL t200_show()
 
END FUNCTION
 
FUNCTION t200_show()
 
   LET g_mma_t.* = g_mma.*                #保存單頭舊值
   DISPLAY BY NAME g_mma.mma01,g_mma.mma02,g_mma.mma021,g_mma.mma03,g_mma.mma05, g_mma.mmaoriu,g_mma.mmaorig,
 
 
                   g_mma.mma051,g_mma.mma06,g_mma.mma04,g_mma.mma13,g_mma.mma07,
                   g_mma.mma08,g_mma.mma09,g_mma.mma10,g_mma.mma16,g_mma.mma11,
                   g_mma.mma12,g_mma.mma14,g_mma.mma20,g_mma.mma15,g_mma.mma16,
                   g_mma.mma18, g_mma.mma19,g_mma.mma17,g_mma.mma21,g_mma.mma211,g_mma.mmauser,   #TQC-AB0415 add mma21 mma211
                   g_mma.mmagrup,g_mma.mmamodu,g_mma.mmadate,g_mma.mmaacti,
                   #FUN-840202     ---start---
                   g_mma.mmaud01,g_mma.mmaud02,g_mma.mmaud03,g_mma.mmaud04,
                   g_mma.mmaud05,g_mma.mmaud06,g_mma.mmaud07,g_mma.mmaud08,
                   g_mma.mmaud09,g_mma.mmaud10,g_mma.mmaud11,g_mma.mmaud12,
                   g_mma.mmaud13,g_mma.mmaud14,g_mma.mmaud15 
                   #FUN-840202     ----end----
 
    #CKP
    IF g_mma.mma17  ='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_mma.mma17,"","",g_mma.mma04,g_chr,"")
   SELECT ima08 INTO g_ima08 FROM ima_file
    WHERE ima01 = g_mma.mma05
 
   DISPLAY g_ima08 TO ima08
 
   CALL t200_mma15()
 
   CALL t200_mma14()
   CALL t200_b_fill(g_wc2)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t200_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
    IF s_ammshut(0) THEN
       RETURN
    END IF
 
    SELECT * INTO g_mma.* FROM mma_file WHERE mma01 = g_mma.mma01
 
    IF g_mma.mma01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    IF g_mma.mma17 = 'Y' THEN
       CALL cl_err('',9023,0)
       RETURN
    END IF
 
    IF g_mma.mma17 = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF
 
    BEGIN WORK
 
    OPEN t200_cl USING g_mma.mma01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t200_cl INTO g_mma.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_mma.mma01,SQLCA.sqlcode,0)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL t200_show()
 
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "mma01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_mma.mma01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       MESSAGE "Delete mma,mmb,ogc,oao,oap!"
       DELETE FROM mma_file
        WHERE mma01 = g_mma.mma01
       IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err('No mma deleted','',0)
           CALL cl_err3("del","mma_file",g_mma.mma01,"","","","No mma deleted",1)       #NO.FUN-660094
          ROLLBACK WORK
          RETURN
       END IF
 
       DELETE FROM mmb_file
        WHERE mmb01 = g_mma.mma01
       IF STATUS THEN
#          CALL cl_err('No mma deleted','',0)
           CALL cl_err3("del","mmb_file",g_mma.mma01,"","","","No mma deleted",1)       #NO.FUN-660094
          ROLLBACK WORK
          RETURN
       END IF
 
       CLEAR FORM
       CALL g_mmb.clear()
       INITIALIZE g_mma.* TO NULL
       OPEN t200_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t200_cs
          CLOSE t200_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t200_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t200_cs
          CLOSE t200_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
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
 
       MESSAGE ""
    END IF
 
    CLOSE t200_cl
    COMMIT WORK
    CALL cl_flow_notify(g_mma.mma01,'D')
 
END FUNCTION
 
FUNCTION t200_b(p_kind)
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680100 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #No.FUN-680100 SMALLINT#分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用        #No.FUN-680100 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680100 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680100 VARCHAR(1)
    l_mmb02         LIKE mmb_file.mmb02,
    l_cmd           LIKE type_file.chr1000,             #No.FUN-680100 VARCHAR(30)
    m_mmb02         LIKE mmb_file.mmb02,
    p_kind          LIKE type_file.chr1,                #No.FUN-680100 CAHR(1)
    l_mmb14_m       LIKE mmb_file.mmb14,
    l_mmb14_n       LIKE mmb_file.mmb14,
    l_mmb02_m       LIKE mmb_file.mmb02,
    l_mmb02_n       LIKE mmb_file.mmb02,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680100 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680100 SMALLINT
 
   LET g_action_choice = ""  #TQC-640006
   IF g_mma.mma01 IS NULL THEN RETURN END IF
   IF p_kind = 'A' THEN
 
      SELECT * INTO g_mma.* FROM mma_file WHERE mma01 = g_mma.mma01
 
   #TQC-640006-begin
    IF g_mma.mma04 = 'Y' THEN
       CALL cl_err('',9004,1)   
       RETURN
    END IF
   #TQC-640006-end
 
      IF g_mma.mma17 = 'Y' THEN
         CALL cl_err('','aap-086',0)
         RETURN
      END IF
 
      IF g_mma.mma17 = 'X' THEN
         CALL cl_err('',9024,0)
         RETURN
      END IF
 
      #若單身全都已結轉,就不進入單身
      SELECT COUNT(*) INTO g_cnt FROM mmb_file
       WHERE mmb01=g_mma.mma01
 
      IF g_cnt !=0 THEN
         SELECT COUNT(*) INTO g_cnt FROM mmb_file
          WHERE mmb01=g_mma.mma01 AND mmb14 !='Y' AND mmbacti='Y'
 
         IF g_cnt =0 THEN
            CALL cl_err(g_mma.mma01,'amm-009',0)
            RETURN
         END IF
 
         SELECT COUNT(*) INTO g_cnt FROM mmb_file
          WHERE mmb01=g_mma.mma01 AND mmb13 !='2' AND mmbacti='Y'
 
         IF g_cnt =0 THEN
            CALL cl_err(g_mma.mma01,'amm-020',0)
            RETURN
         END IF
      END IF
 
      LET g_action_choice = ""
      #抓已結轉的最小項次值
      SELECT MIN(mmb02) INTO l_mmb02 FROM mmb_file
       WHERE mmb01=g_mma.mma01 AND mmb14 ='Y' AND mmbacti='Y'
      IF cl_null(l_mmb02) THEN
         LET l_mmb02 =0
      END IF
      CALL cl_opmsg('b')
   END IF
 
   LET g_forupd_sql = " SELECT * ",
                      " FROM mmb_file  WHERE mmb01=? AND mmb02=? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_mmb WITHOUT DEFAULTS FROM s_mmb.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         OPEN t200_cl USING g_mma.mma01
         IF STATUS THEN
            CALL cl_err("OPEN t200_cl:", STATUS, 1)
            CLOSE t200_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH t200_cl INTO g_mma.*  # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_mma.mma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
            CLOSE t200_cl ROLLBACK WORK RETURN
         END IF
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_mmb_t.* = g_mmb[l_ac].*
            OPEN t200_bcl USING g_mma.mma01,g_mmb_t.mmb02
            IF STATUS THEN
               CALL cl_err("OPEN t200_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t200_bcl INTO b_mmb.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('lock mmb',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL t200_b_move_to()
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
        #NEXT FIELD mmb02  #No.TQC-940039 mark
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_mmb[l_ac].* TO NULL
         INITIALIZE b_mmb.* TO NULL
         LET b_mmb.mmb01=g_mma.mma01
         LET g_mmb[l_ac].mmb07='S'
         LET g_mmb[l_ac].mmb13='1'
         LET g_mmb[l_ac].mmb14='N'
         LET g_mmb[l_ac].mmb09=g_mma.mma09
         LET g_mmb[l_ac].mmbacti='Y'
         LET g_mmb[l_ac].mmb10=0
         LET g_mmb[l_ac].mmb11=0
         LET g_mmb[l_ac].mmb19=0
         LET b_mmb.mmb07='S'
         LET b_mmb.mmb13='1'
         LET b_mmb.mmb14='N'
         LET b_mmb.mmb16= 0
         LET b_mmb.mmb17= 0
         LET b_mmb.mmb18= 0
         LET b_mmb.mmb19= 0
         LET b_mmb.mmb09= g_mma.mma09
         LET b_mmb.mmbplant = g_plant #FUN-980004 add
         LET b_mmb.mmblegal = g_legal #FUN-980004 add
         SELECT mmd15 INTO b_mmb.mmb19 FROM mmd_file WHERE mmd00='0'
         LET b_mmb.mmbacti='Y'
         LET g_mmb[l_ac].mmb19=b_mmb.mmb19
         IF l_ac = 1 THEN
            LET g_mmb[l_ac].mmb12  = g_mma.mma07
            LET g_mmb[l_ac].mmb121 = g_mma.mma07
         ELSE
            IF NOT cl_null(g_mmb[l_ac-1].mmb12) THEN
               LET g_mmb[l_ac].mmb12 = g_mmb[l_ac-1].mmb121
            END IF
            IF NOT cl_null(g_mmb[l_ac-1].mmb121) THEN
               LET g_mmb[l_ac].mmb121 = g_mmb[l_ac-1].mmb121
            END IF
         END IF
         LET g_mmb_t.* = g_mmb[l_ac].*             #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD mmb02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         CALL t200_b_move_back()
         INSERT INTO mmb_file VALUES(b_mmb.*)
         IF SQLCA.sqlcode THEN
#            CALL cl_err('ins mmb',SQLCA.sqlcode,0)
             CALL cl_err3("ins","mmb_file",b_mmb.mmb01,b_mmb.mmb02,SQLCA.SQLCODE,"","ins mmb",1)       #NO.FUN-660094
            LET g_mmb[l_ac].* = g_mmb_t.*
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            CALL t200_bu()
            COMMIT WORK
         END IF
 
      BEFORE FIELD mmb02                            #default 序號
         #若已結轉,不可再更改
         IF g_mmb[l_ac].mmb14='Y' THEN
            NEXT FIELD mmbacti
         END IF
         IF g_mmb[l_ac].mmb02 IS NULL OR g_mmb[l_ac].mmb02 = 0 THEN
            SELECT MAX(mmb02) INTO m_mmb02
              FROM mmb_file WHERE mmb01 = g_mma.mma01
            IF m_mmb02 IS NULL THEN
               LET g_mmb[l_ac].mmb02 = 1
            ELSE
               LET g_mmb[l_ac].mmb02 = m_mmb02 + 1
            END IF
         END IF
 
      AFTER FIELD mmb02                        #check 序號是否重複
         #若此筆資料已作廢,就不允許修改資料
         IF g_mmb[l_ac].mmbacti='X' THEN
            IF g_mmb[l_ac].mmb02 != g_mmb_t.mmb02 THEN
               LET g_mmb[l_ac].mmb02 = g_mmb_t.mmb02
               CALL cl_err('','axm-103',0) NEXT FIELD mmb02
            END IF
            NEXT FIELD mmbacti
         END IF
         IF NOT cl_null(g_mmb[l_ac].mmb02) THEN
            IF g_mmb[l_ac].mmb02 != g_mmb_t.mmb02 OR
               g_mmb_t.mmb02 IS NULL THEN
               SELECT count(*) INTO l_n FROM mmb_file
                WHERE mmb01 = g_mma.mma01 AND mmb02 = g_mmb[l_ac].mmb02
               IF l_n > 0 THEN
                  LET g_mmb[l_ac].mmb02 = g_mmb_t.mmb02
                  CALL cl_err('',-239,0) NEXT FIELD mmb02
               END IF
            END IF
            #若修改: 項次不可小於等於已結轉的最小項次
            IF g_mmb[l_ac].mmb02 != g_mmb_t.mmb02 AND
               l_mmb02 !=0 AND g_mmb[l_ac].mmb02 <= l_mmb02 THEN
               LET g_mmb[l_ac].mmb02 = g_mmb_t.mmb02
               CALL cl_err('','axm-168',0) NEXT FIELD mmb02
            END IF
            #追加的加工別不可插入已結轉的項次中
            IF p_kind = 'B' THEN
               SELECT MIN(mmb02) INTO l_mmb02_m FROM mmb_file
                WHERE mmb01 = g_mma.mma01
                  AND mmb02 > g_mmb[l_ac].mmb02
               IF NOT STATUS THEN
                  SELECT mmb14 INTO l_mmb14_m FROM mmb_file
                   WHERE mmb01 = g_mma.mma01
                     AND mmb02 = l_mmb02_m
                  SELECT MAX(mmb02) INTO l_mmb02_n FROM mmb_file
                   WHERE mmb01 = g_mma.mma01
                     AND mmb02 < g_mmb[l_ac].mmb02
                  SELECT mmb14 INTO l_mmb14_n FROM mmb_file
                   WHERE mmb01 = g_mma.mma01
                     AND mmb02 = l_mmb02_n
                  IF l_mmb14_n = 'Y' AND l_mmb14_m = 'Y' THEN
                     CALL cl_err('','amm-046',0)
                     NEXT FIELD mmb02
                  END IF
               END IF
            END IF
         END IF
 
      AFTER FIELD mmb05
         IF NOT cl_null(g_mmb[l_ac].mmb05) THEN
            CALL t200_mmb05('a')
            IF NOT cl_null(g_errno) THEN
               LET g_mmb[l_ac].mmb05 = g_mmb_t.mmb05
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_mmb[l_ac].mmb05
               #------MOD-5A0095 END------------
               CALL cl_err(g_mmb[l_ac].mmb05,g_errno,0)
               NEXT FIELD mmb05
            END IF
         END IF
 
      BEFORE FIELD mmb07
         CALL t200_set_entry_b(p_cmd)
 
      AFTER FIELD mmb07
         IF NOT cl_null(g_mmb[l_ac].mmb07) THEN
            IF g_mmb[l_ac].mmb07 NOT MATCHES '[PSM]' THEN
               NEXT FIELD mmb07
            END IF
           #表為初次加工項次 -> 不可為 S
            IF g_mma.mma18=0 OR g_mmb[l_ac].mmb02=g_mma.mma18 THEN
               IF g_mmb[l_ac].mmb07 NOT MATCHES '[PM]' THEN
                  LET g_mmb[l_ac].mmb07 = g_mmb_t.mmb07
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_mmb[l_ac].mmb07
                  #------MOD-5A0095 END------------
                  CALL cl_err(g_mmb[l_ac].mmb07,'amm-010',0)
                  NEXT FIELD mmb07
               END IF
            END IF
           #表不為初次加工項次 -> 不可為 P
            IF g_mma.mma18 !=0 AND g_mmb[l_ac].mmb02 !=g_mma.mma18 THEN
               IF g_mmb[l_ac].mmb07 NOT MATCHES '[MPS]' THEN
                  LET g_mmb[l_ac].mmb07 = g_mmb_t.mmb07
                  CALL cl_err(g_mmb[l_ac].mmb07,'amm-011',0)
                  NEXT FIELD mmb07
               END IF
            END IF
         END IF
         CALL t200_set_no_entry_b(p_cmd)
 
      AFTER FIELD mmb08
         IF NOT cl_null(g_mmb[l_ac].mmb08) THEN
            CALL t200_mmb08('a')
            IF NOT cl_null(g_errno) THEN
               LET g_mmb[l_ac].mmb08 = g_mmb_t.mmb08
               LET g_mmb[l_ac].pmc03 = g_mmb_t.pmc03
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_mmb[l_ac].mmb08
               DISPLAY BY NAME g_mmb[l_ac].pmc03
               #------MOD-5A0095 END------------
                  CALL cl_err(g_mmb[l_ac].mmb07,'amm-010',0)
               CALL cl_err(g_mmb[l_ac].mmb08,g_errno,0)
               NEXT FIELD mmb08
            END IF
         END IF
 
      AFTER FIELD mmb09
         IF NOT cl_null(g_mmb[l_ac].mmb09) THEN
            IF g_mmb[l_ac].mmb09 <= 0 THEN
               NEXT FIELD mmb09
            END IF
         END IF
 
      AFTER FIELD mmb10
         IF NOT cl_null(g_mmb[l_ac].mmb10) THEN
            IF g_mmb[l_ac].mmb10 <0 THEN
               NEXT FIELD mmb10
            END IF
         END IF
 
      AFTER FIELD mmb11
         IF NOT cl_null(g_mmb[l_ac].mmb11) THEN
            IF g_mmb[l_ac].mmb11 <0 THEN
               NEXT FIELD mmb11
            END IF
         END IF
 
      AFTER FIELD mmb19
         IF NOT cl_null(g_mmb[l_ac].mmb19) THEN
            IF g_mmb[l_ac].mmb19 <0 THEN
               NEXT FIELD mmb19
            END IF
         END IF
 
      AFTER FIELD mmb12
         IF NOT cl_null(g_mmb[l_ac].mmb12) THEN
            IF l_ac >1 THEN
               IF g_mmb[l_ac].mmb12 < g_mmb[l_ac-1].mmb121 THEN #警告
                  CALL cl_err(g_mmb[l_ac].mmb12,'amm-012',0)
               END IF
            END IF
         END IF
 
      AFTER FIELD mmb121
         IF NOT cl_null(g_mmb[l_ac].mmb121) THEN
            IF g_mmb[l_ac].mmb121 < g_mmb[l_ac].mmb12 THEN
               NEXT FIELD mmb121
            END IF
         END IF
 
      AFTER FIELD mmb13
         IF NOT cl_null(g_mmb[l_ac].mmb13) THEN
            IF g_mmb[l_ac].mmb13 NOT MATCHES '[012]' THEN
               NEXT FIELD mmb13
            END IF
         END IF
 
      #No.FUN-840202 --start--
      AFTER FIELD mmbud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmbud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmbud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmbud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmbud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmbud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmbud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmbud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmbud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmbud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmbud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmbud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmbud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmbud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmbud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #No.FUN-840202 ---end---
 
 
      BEFORE DELETE                            #是否取消單身
         IF g_mmb_t.mmb02 > 0 AND g_mmb_t.mmb02 IS NOT NULL THEN
            IF g_mmb[l_ac].mmb14='Y' THEN
               CALL cl_err('','amm-009',0)
               CANCEL DELETE
            END IF
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM mmb_file
             WHERE mmb01 = g_mma.mma01 AND mmb02 = g_mmb_t.mmb02
            IF SQLCA.sqlcode THEN
#               CALL cl_err('mmb_file DELETE Error',SQLCA.sqlcode,0)
                CALL cl_err3("del","mmb_file",g_mma.mma01,g_mmb_t.mmb02,SQLCA.SQLCODE,"","mmb_file DELETE Error",1)       #NO.FUN-660094
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
            LET g_mmb[l_ac].* = g_mmb_t.*
            CLOSE t200_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_mmb[l_ac].mmb02,-263,1)
            LET g_mmb[l_ac].* = g_mmb_t.*
         ELSE
            CALL t200_b_move_back()
            UPDATE mmb_file SET * = b_mmb.*
             WHERE mmb01=g_mma.mma01
               AND mmb02=g_mmb_t.mmb02
            IF SQLCA.sqlcode THEN
#               CALL cl_err('upd mmb',SQLCA.sqlcode,0)
                CALL cl_err3("upd","mmb_file",g_mma.mma01,g_mmb_t.mmb02,SQLCA.SQLCODE,"","upd mmb",1)       #NO.FUN-660094
               LET g_mmb[l_ac].* = g_mmb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               CALL t200_bu()
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac      #FUN-D40030 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_mmb[l_ac].* = g_mmb_t.*
            #FUN-D40030--add--str--
            ELSE
               CALL g_mmb.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE t200_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D40030 Add 
         CLOSE t200_bcl
         COMMIT WORK
 
      ON ACTION maintain_processing_code
         IF INFIELD(mmb05) THEN
            LET l_cmd = 'ammi010 '
            CALL cl_cmdrun(l_cmd CLIPPED)
            NEXT FIELD mmb05
         END IF
 
      ON KEY (CONTROL - O)
         IF INFIELD(mmb02) AND l_ac > 1 THEN
            LET g_mmb[l_ac].* = g_mmb[l_ac-1].*
            LET g_mmb[l_ac].mmb02 = NULL
            NEXT FIELD mmb02
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(mmb05)
#              CALL q_mmc(0,0,g_mmb[l_ac].mmb05) RETURNING g_mmb[l_ac].mmb05
#              CALL FGL_DIALOG_SETBUFFER( g_mmb[l_ac].mmb05 )
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_mmc"
               LET g_qryparam.default1 = g_mmb[l_ac].mmb05
               CALL cl_create_qry() RETURNING g_mmb[l_ac].mmb05
#               CALL FGL_DIALOG_SETBUFFER( g_mmb[l_ac].mmb05 )
                DISPLAY BY NAME g_mmb[l_ac].mmb05            #No.MOD-490371
               CALL t200_mmb05('a')
               NEXT FIELD mmb05
            WHEN INFIELD(mmb08)
               IF g_mmb[l_ac].mmb07='M' THEN
#                 CALL q_gem(0,0,g_mmb[l_ac].mmb08) RETURNING g_mmb[l_ac].mmb08
#                 CALL FGL_DIALOG_SETBUFFER( g_mmb[l_ac].mmb08 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem"
                  LET g_qryparam.default1 = g_mmb[l_ac].mmb08
                  CALL cl_create_qry() RETURNING g_mmb[l_ac].mmb08
#                  CALL FGL_DIALOG_SETBUFFER( g_mmb[l_ac].mmb08 )
               ELSE
#                 CALL q_pmc(0,0,g_mmb[l_ac].mmb08) RETURNING g_mmb[l_ac].mmb08
#                 CALL FGL_DIALOG_SETBUFFER( g_mmb[l_ac].mmb08 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pmc"
                  LET g_qryparam.default1 = g_mmb[l_ac].mmb08
                  CALL cl_create_qry() RETURNING g_mmb[l_ac].mmb08
#                  CALL FGL_DIALOG_SETBUFFER( g_mmb[l_ac].mmb08 )
               END IF
                DISPLAY BY NAME g_mmb[l_ac].mmb08            #No.MOD-490371
               CALL t200_mmb08('a')
               NEXT FIELD mmb08
         END CASE
 
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
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------ 
 
   END INPUT
 
   UPDATE mma_file SET mmamodu = g_user,mmadate = g_today
    WHERE mma01 = g_mma.mma01
 
   COMMIT WORK
   CLOSE t200_bcl
   CALL t200_delHeader()     #CHI-C30002 add
   IF NOT cl_null(g_mma.mma01) THEN  #CHI-C30002 add
      LET g_t1=g_mma.mma01[1,g_doc_len]
      SELECT * INTO g_smy.* FROM smy_file WHERE smyslip=g_t1
      IF STATUS THEN
#      CALL cl_err('sel smy_file',STATUS,0)
          CALL cl_err3("sel","smy_file",g_t1,"",STATUS,"","sel smy_file",1)       #NO.FUN-660094
          RETURN
      END IF
 
      IF g_smy.smydmy4='Y' AND g_mma.mma17='N' THEN #單據已確認或單據不需自動確認
         CALL t200_y()
      END IF
   END IF           #CHI-C30002 add
 
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
      CALL s_get_doc_no(g_mma.mma01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM mma_file ",
                  "  WHERE mma01 LIKE '",l_slip,"%' ",
                  "    AND mma01 > '",g_mma.mma01,"'"
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
        #CALL t200_x()  #CHI-D20010
         CALL t200_x(1) #CHI-D20010
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end  
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM mma_file WHERE mma01 = g_mma.mma01
         INITIALIZE g_mma.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t200_mmb05(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
          l_mmc02     LIKE mmc_file.mmc02,
          l_mmcacti   LIKE mmc_file.mmcacti
 
   LET g_errno = ' '
   SELECT mmc02,mmcacti INTO l_mmc02,l_mmcacti FROM mmc_file
    WHERE mmc01=g_mmb[l_ac].mmb05
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'amm-029'
         LET l_mmc02 = NULL
      WHEN l_mmcacti='N'
         LET g_errno = '9028'
         LET l_mmc02 = NULL
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF p_cmd='a' THEN
      LET g_mmb[l_ac].mmc02=l_mmc02
      #------MOD-5A0095 START----------
      DISPLAY BY NAME g_mmb[l_ac].mmc02
      #------MOD-5A0095 END------------
   END IF
 
END FUNCTION
 
FUNCTION t200_mmb08(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
          l_pmc03     LIKE gem_file.gem02,          #No.FUN-680100 VARCHAR(10)
          l_pmcacti   LIKE type_file.chr1           #No.FUN-680100 VARCHAR(1)
 
   LET g_errno = ' '
   IF g_mmb[l_ac].mmb07 ='M' THEN
      SELECT gem02,gemacti INTO l_pmc03,l_pmcacti FROM gem_file
       WHERE gem01=g_mmb[l_ac].mmb08
   ELSE
      SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti FROM pmc_file
       WHERE pmc01=g_mmb[l_ac].mmb08
   END IF
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg3097'
         LET l_pmc03 = NULL
      WHEN l_pmcacti='N'
         LET g_errno = '9028'
         LET l_pmc03 = NULL
   #FUN-690024------mod-------
      WHEN l_pmcacti MATCHES '[PH]'       
         LET g_errno = '9038'
         LET l_pmc03 = NULL
   #FUN-690024------mod-------
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF p_cmd='a' THEN
      LET g_mmb[l_ac].pmc03=l_pmc03
      #------MOD-5A0095 START----------
      DISPLAY BY NAME g_mmb[l_ac].pmc03
      #------MOD-5A0095 END------------
                  CALL cl_err(g_mmb[l_ac].mmb07,'amm-010',0)
   END IF
 
END FUNCTION
 
FUNCTION t200_b_move_to()
 
   LET g_mmb[l_ac].mmb02 = b_mmb.mmb02
   LET g_mmb[l_ac].mmb05 = b_mmb.mmb05
   LET g_mmb[l_ac].mmb06 = b_mmb.mmb06
   LET g_mmb[l_ac].mmb07 = b_mmb.mmb07
   LET g_mmb[l_ac].mmb08 = b_mmb.mmb08
   LET g_mmb[l_ac].mmb09 = b_mmb.mmb09
   LET g_mmb[l_ac].mmb10 = b_mmb.mmb10
   LET g_mmb[l_ac].mmb11 = b_mmb.mmb11
   LET g_mmb[l_ac].mmb19 = b_mmb.mmb19
   LET g_mmb[l_ac].mmb12 = b_mmb.mmb12
   LET g_mmb[l_ac].mmb121= b_mmb.mmb121
   LET g_mmb[l_ac].mmb13 = b_mmb.mmb13
   LET g_mmb[l_ac].mmb131= b_mmb.mmb131
   LET g_mmb[l_ac].mmb132= b_mmb.mmb132
   LET g_mmb[l_ac].mmb14 = b_mmb.mmb14
   LET g_mmb[l_ac].mmb141= b_mmb.mmb141
   LET g_mmb[l_ac].mmb15 = b_mmb.mmb15
   LET g_mmb[l_ac].mmbacti = b_mmb.mmbacti
 
   #NO.FUN-840202 --start--
   LET g_mmb[l_ac].mmbud01 = b_mmb.mmbud01
   LET g_mmb[l_ac].mmbud02 = b_mmb.mmbud02
   LET g_mmb[l_ac].mmbud03 = b_mmb.mmbud03
   LET g_mmb[l_ac].mmbud04 = b_mmb.mmbud04
   LET g_mmb[l_ac].mmbud05 = b_mmb.mmbud05
   LET g_mmb[l_ac].mmbud06 = b_mmb.mmbud06
   LET g_mmb[l_ac].mmbud07 = b_mmb.mmbud07
   LET g_mmb[l_ac].mmbud08 = b_mmb.mmbud08
   LET g_mmb[l_ac].mmbud09 = b_mmb.mmbud09
   LET g_mmb[l_ac].mmbud10 = b_mmb.mmbud10
   LET g_mmb[l_ac].mmbud11 = b_mmb.mmbud11
   LET g_mmb[l_ac].mmbud12 = b_mmb.mmbud12
   LET g_mmb[l_ac].mmbud13 = b_mmb.mmbud13
   LET g_mmb[l_ac].mmbud14 = b_mmb.mmbud14
   LET g_mmb[l_ac].mmbud15 = b_mmb.mmbud15
   #NO.FUN-840202 --end--
 
END FUNCTION
 
FUNCTION t200_b_move_back()
 
   LET b_mmb.mmb02 = g_mmb[l_ac].mmb02
   LET b_mmb.mmb05 = g_mmb[l_ac].mmb05
   LET b_mmb.mmb06 = g_mmb[l_ac].mmb06
   LET b_mmb.mmb07 = g_mmb[l_ac].mmb07
   LET b_mmb.mmb08 = g_mmb[l_ac].mmb08
   LET b_mmb.mmb09 = g_mmb[l_ac].mmb09
   LET b_mmb.mmb10 = g_mmb[l_ac].mmb10
   LET b_mmb.mmb11 = g_mmb[l_ac].mmb11
   LET b_mmb.mmb19 = g_mmb[l_ac].mmb19
   LET b_mmb.mmb12 = g_mmb[l_ac].mmb12
   LET b_mmb.mmb121= g_mmb[l_ac].mmb121
   LET b_mmb.mmb13 = g_mmb[l_ac].mmb13
   LET b_mmb.mmb131= g_mmb[l_ac].mmb131
   LET b_mmb.mmb132= g_mmb[l_ac].mmb132
   LET b_mmb.mmb14 = g_mmb[l_ac].mmb14
   LET b_mmb.mmb141= g_mmb[l_ac].mmb141
   LET b_mmb.mmb15 = g_mmb[l_ac].mmb15
   LET b_mmb.mmbacti = g_mmb[l_ac].mmbacti
 
   IF cl_null(b_mmb.mmb16) THEN
      LET b_mmb.mmb16 = 0
   END IF
 
   IF cl_null(b_mmb.mmb17) THEN
      LET b_mmb.mmb17 = 0
   END IF
 
   IF cl_null(b_mmb.mmb18) THEN
      LET b_mmb.mmb18 = 0
   END IF
 
   #No.FUN-840202 --start--
   LET b_mmb.mmbud01 = g_mmb[l_ac].mmbud01
   LET b_mmb.mmbud02 = g_mmb[l_ac].mmbud02
   LET b_mmb.mmbud03 = g_mmb[l_ac].mmbud03
   LET b_mmb.mmbud04 = g_mmb[l_ac].mmbud04
   LET b_mmb.mmbud05 = g_mmb[l_ac].mmbud05
   LET b_mmb.mmbud06 = g_mmb[l_ac].mmbud06
   LET b_mmb.mmbud07 = g_mmb[l_ac].mmbud07
   LET b_mmb.mmbud08 = g_mmb[l_ac].mmbud08
   LET b_mmb.mmbud09 = g_mmb[l_ac].mmbud09
   LET b_mmb.mmbud10 = g_mmb[l_ac].mmbud10
   LET b_mmb.mmbud11 = g_mmb[l_ac].mmbud11
   LET b_mmb.mmbud12 = g_mmb[l_ac].mmbud12
   LET b_mmb.mmbud13 = g_mmb[l_ac].mmbud13
   LET b_mmb.mmbud14 = g_mmb[l_ac].mmbud14
   LET b_mmb.mmbud15 = g_mmb[l_ac].mmbud15
   #NO.FUN-840202 --end--
END FUNCTION
 
FUNCTION t200_bu()
 
   LET g_mma.mma11 = NULL
   LET g_mma.mma12 = NULL
   LET g_mma.mma18 = NULL
 
   SELECT MIN(mmb12) INTO g_mma.mma11 FROM mmb_file
    WHERE mmb01 = g_mma.mma01
      AND mmbacti='Y'
   IF cl_null(g_mma.mma11) THEN
      LET g_mma.mma11 = NULL
   END IF
 
   SELECT MAX(mmb121) INTO g_mma.mma12 FROM mmb_file
    WHERE mmb01 = g_mma.mma01
      AND mmbacti='Y'
   IF cl_null(g_mma.mma12) THEN
      LET g_mma.mma12 = NULL
   END IF
 
   SELECT MIN(mmb02) INTO g_mma.mma18 FROM mmb_file
    WHERE mmb01 = g_mma.mma01
      AND mmbacti='Y'
   IF cl_null(g_mma.mma18) THEN
      LET g_mma.mma18 = 0
   END IF
 
   UPDATE mma_file SET mma11=g_mma.mma11,
                       mma12=g_mma.mma12,
                       mma18=g_mma.mma18
    WHERE mma01 = g_mma.mma01
   IF STATUS THEN
#      CALL cl_err('_bu():upd mma',STATUS,0)
       CALL cl_err3("upd","mma_file",g_mma.mma01,"",STATUS,"","_bu():upd mma",1)       #NO.FUN-660094
   END IF
 
   SELECT mma11,mma12,mma18 INTO g_mma.mma11,g_mma.mma12,g_mma.mma18
     FROM mma_file
    WHERE mma01=g_mma.mma01
 
   DISPLAY BY NAME g_mma.mma11,g_mma.mma12,g_mma.mma18
 
END FUNCTION
 
FUNCTION t200_b_askkey()
DEFINE l_wc2          LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(300)
 
   CONSTRUCT l_wc2 ON mmb02,mmb05,mmb06,mmb07,mmb08,mmb09,mmb10,mmb11,mmb19,
                      mmb12,mmb121,mmb13,mmb131,mmb132,mmb14,mmb141,mmb15,mmbacti
                 FROM s_mmb[1].mmb02,s_mmb[1].mmb05,s_mmb[1].mmb06,
                      s_mmb[1].mmb07,s_mmb[1].mmb08,s_mmb[1].mmb09,
                      s_mmb[1].mmb10,s_mmb[1].mmb11,s_mmb[1].mmb19,
                      s_mmb[1].mmb12,s_mmb[1].mmb121,s_mmb[1].mmb13,
                      s_mmb[1].mmb131,s_mmb[1].mmb132,s_mmb[1].mmb14,
                      s_mmb[1].mmb141,s_mmb[1].mmb15,s_mmb[1].mmbacti
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
 
   CALL t200_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t200_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2        LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(300)
 
   LET g_sql = "SELECT mmb02,mmb05,mmc02,mmb06,mmb07,mmb08,'',",
               "       mmb09,mmb10,mmb11,mmb19,mmb12,mmb121,mmb13,",
               "       mmb131,mmb132,mmb14,mmb141,mmbacti,mmb15, ",
               #No.FUN-840202 --start--
               "       mmbud01,mmbud02,mmbud03,mmbud04,mmbud05,",
               "       mmbud06,mmbud07,mmbud08,mmbud09,mmbud10,",
               "       mmbud11,mmbud12,mmbud13,mmbud14,mmbud15", 
               #No.FUN-840202 ---end---
               "  FROM mmb_file LEFT OUTER JOIN mmc_file ON mmb05=mmc_file.mmc01 ",
               " WHERE mmb01 ='",g_mma.mma01,"'",  #單頭
               "   AND ",p_wc2 CLIPPED,                     #單身
               " ORDER BY mmb02"
 
   PREPARE t200_pb FROM g_sql
   DECLARE mmb_curs                       #SCROLL CURSOR
       CURSOR FOR t200_pb
 
   CALL g_mmb.clear()
   LET g_cnt = 1
   FOREACH mmb_curs INTO g_mmb[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF g_mmb[g_cnt].mmb07 ='M' THEN
         SELECT gem02 INTO g_mmb[g_cnt].pmc03 FROM gem_file
          WHERE gem01=g_mmb[g_cnt].mmb08
      ELSE
         SELECT pmc03 INTO g_mmb[g_cnt].pmc03 FROM pmc_file
          WHERE pmc01=g_mmb[g_cnt].mmb08
      END IF
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_mmb.deleteElement(g_cnt)
   LET g_rec_b=g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mmb TO s_mmb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
 
      ON ACTION jump
         CALL t200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t200_fetch('N')
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
      #FUN-840134
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
         IF g_mma.mma17  ='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         CALL cl_set_field_pic(g_mma.mma17,"","",g_mma.mma04,g_chr,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
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
#@    ON ACTION 單身作廢
      ON ACTION detail_void
         LET g_action_choice="detail_void"
         EXIT DISPLAY
#@    ON ACTION 結案
      ON ACTION close_the_case
         LET g_action_choice="close_the_case"
         EXIT DISPLAY
#@    ON ACTION 結案還原
      ON ACTION undo_close
         LET g_action_choice="undo_close"
         EXIT DISPLAY
#@    ON ACTION 追加單身
      ON ACTION add_detail
         LET g_action_choice="add_detail"
         EXIT DISPLAY
#@    ON ACTION 查詢加工單
      ON ACTION qry_w_o
         LET g_action_choice="qry_w_o"
         EXIT DISPLAY
#@    ON ACTION 完工進度延遲查詢
      ON ACTION qry_completed_progress_late
         LET g_action_choice="qry_completed_progress_late"
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
 
 
      ON ACTION exporttoexcel       #FUN-4B0036
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------ 
 
     ON ACTION related_document                #No.FUN-6B0079  相關文件
        LET g_action_choice="related_document"          
        EXIT DISPLAY   
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t200_y()                   # when g_mma.mma17='N' (Turn to 'Y')
 DEFINE l_yy,l_mm,l_n   LIKE type_file.num5,          #No.FUN-680100 SMALLINT
        cware,cloc      LIKE type_file.chr20          #No.FUN-680100 VARCHAR(20)
 
#CHI-C30107 -------- add --------- begin
   IF g_mma.mma17 = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF

   IF g_mma.mma17 = 'X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN
      RETURN
   END IF
#CHI-C30107 -------- add --------- end
   SELECT * INTO g_mma.* FROM mma_file WHERE mma01 = g_mma.mma01
   IF g_mma.mma17 = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF
 
   IF g_mma.mma17 = 'X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF
 
   #若單身無資料,不可取消確認
   SELECT COUNT(*) INTO g_cnt FROM mmb_file
    WHERE mmb01=g_mma.mma01
   IF g_cnt = 0 THEN
      CALL cl_err(g_mma.mma01,'arm-034',0)
      RETURN
   END IF
 
#CHI-C30107 -------- mark --------- begin
#  IF NOT cl_confirm('axm-108') THEN
#     RETURN
#  END IF
#CHI-C30107 -------- mark --------- end
 
   BEGIN WORK
 
   OPEN t200_cl USING g_mma.mma01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_mma.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mma.mma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t200_cl
   #add FUN-AB0056
      ROLLBACK WORK
   #end FUN-AB0056
      RETURN
   END IF
   
   #add FUN-AB0056
   IF NOT s_chk_ware(g_mma.mma21) THEN #检查仓库是否属于当前门店 
      LET g_success='N'
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   #end FUN-AB0056
   
   UPDATE mma_file SET mma17='Y' WHERE mma01=g_mma.mma01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#      CALL cl_err('upd mma17',SQLCA.SQLCODE,1)
       CALL cl_err3("upd","mma_file",g_mma.mma01,"",SQLCA.SQLCODE,"","upd mma17",1)       #NO.FUN-660094
      LET g_mma.mma17='N'
      ROLLBACK WORK
   ELSE
      LET g_mma.mma17='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_mma.mma01,'Y')
   END IF
 
   DISPLAY BY NAME g_mma.mma17
   MESSAGE ''
   CLOSE t200_cl
    #CKP
    IF g_mma.mma17  ='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_mma.mma17,"","",g_mma.mma04,g_chr,"")
 
END FUNCTION
 
FUNCTION t200_z()                   # when g_mma.mma17='Y' (Turn to 'N')
 
   SELECT * INTO g_mma.* FROM mma_file WHERE mma01 = g_mma.mma01
 
   IF g_mma.mma17 = 'N' THEN
      RETURN
   END IF
 
   IF g_mma.mma17 = 'X' THEN
      CALL cl_err('','axr-103',0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO g_cnt FROM mmb_file WHERE mmb01=g_mma.mma01
   IF g_cnt !=0 THEN
     #-->若單身已有結轉資料,就不可取消確認
      SELECT COUNT(*) INTO g_cnt FROM mmb_file
       WHERE mmb01=g_mma.mma01
         AND mmb14 ='Y'
         AND mmbacti='Y'
      IF g_cnt >0 THEN
         CALL cl_err(g_mma.mma01,'amm-013',0)
         RETURN
      END IF
      #-->若單身已有通知單資料,就不可取消確認
      SELECT COUNT(*) INTO g_cnt FROM mmb_file
       WHERE mmb01=g_mma.mma01
         AND mmb13 ='2'
         AND mmbacti='Y'
      IF g_cnt >0 THEN
         CALL cl_err(g_mma.mma01,'amm-020',0)
         RETURN
      END IF
   END IF
 
   IF NOT cl_confirm('axm-109') THEN
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t200_cl USING g_mma.mma01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t200_cl INTO g_mma.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mma.mma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t200_cl
      RETURN
   END IF
 
   UPDATE mma_file SET mma17='N' WHERE mma01=g_mma.mma01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#      CALL cl_err('upd mma17',SQLCA.SQLCODE,1)
       CALL cl_err3("upd","mma_file",g_mma.mma01,"",SQLCA.SQLCODE,"","upd mma17",1)       #NO.FUN-660094
      LET g_mma.mma17='Y'
      ROLLBACK WORK
   ELSE
      LET g_mma.mma17='N'
      COMMIT WORK
   END IF
 
   DISPLAY BY NAME g_mma.mma17
   MESSAGE ''
   CLOSE t200_cl
   COMMIT WORK
    #CKP
    IF g_mma.mma17  ='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_mma.mma17,"","",g_mma.mma04,g_chr,"")
 
END FUNCTION
 
#FUNCTION t200_x()    #CHI-D20010
FUNCTION t200_x(p_type)  #CHI-D20010
DEFINE l_flag LIKE type_file.chr1  #CHI-D20010
DEFINE p_type LIKE type_file.chr1  #CHI-D20010
 
   IF s_ammshut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_mma.mma01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_mma.mma17 ='X' THEN RETURN END IF
   ELSE
      IF g_mma.mma17 <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t200_cl USING g_mma.mma01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t200_cl INTO g_mma.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mma.mma01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   #-->確認不可作廢
   IF g_mma.mma17 = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF

   IF g_mma.mma17 = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
 
  #IF cl_void(0,0,g_mma.mma17)   THEN #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN  #CHI-D20010
      LET g_chr=g_mma.mma17
     #IF g_mma.mma17 ='N' THEN  #CHI-D20010
      IF p_type = 1 THEN      #CHI-D20010
         LET g_mma.mma17='X'
      ELSE
         LET g_mma.mma17='N'
      END IF
      UPDATE mma_file SET mma17 = g_mma.mma17,
                          mmamodu = g_user,
                          mmadate = g_today
       WHERE mma01 = g_mma.mma01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_mma.mma01,SQLCA.sqlcode,0)
          CALL cl_err3("upd","mma_file",g_mma.mma01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660094
         LET g_mma.mma17=g_chr
      END IF
   END IF
   CLOSE t200_cl
   COMMIT WORK
 
    #CKP
    DISPLAY BY NAME g_mma.mma17
    IF g_mma.mma17  ='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_mma.mma17,"","",g_mma.mma04,g_chr,"")
 
   CALL cl_flow_notify(g_mma.mma01,'V')
 
END FUNCTION
 
FUNCTION t200_bx()
   DEFINE d_mmb     DYNAMIC ARRAY OF RECORD
                    mmb02     LIKE mmb_file.mmb02,
                    mmb03     LIKE mmb_file.mmb03,
                    mmb04     LIKE mmb_file.mmb04,
                    mmb05     LIKE mmb_file.mmb05,
                    mmc02     LIKE mmc_file.mmc02,
                    mmb06     LIKE mmb_file.mmb06,
                    mmb07     LIKE mmb_file.mmb07,
                    mmb08     LIKE mmb_file.mmb08,
                    pmc03     LIKE gem_file.gem02,        #No.FUN-680100 VARCHAR(10)
                    mmb09     LIKE mmb_file.mmb09,
                    mmb13     LIKE mmb_file.mmb13,
                    mmb14     LIKE mmb_file.mmb14,
                    mmbacti   LIKE mmb_file.mmbacti
                    END RECORD,
          d_mmb_t   RECORD
                    mmb02     LIKE mmb_file.mmb02,
                    mmb03     LIKE mmb_file.mmb03,
                    mmb04     LIKE mmb_file.mmb04,
                    mmb05     LIKE mmb_file.mmb05,
                    mmc02     LIKE mmc_file.mmc02,
                    mmb06     LIKE mmb_file.mmb06,
                    mmb07     LIKE mmb_file.mmb07,
                    mmb08     LIKE mmb_file.mmb08,
                    pmc03     LIKE gem_file.gem02,        #No.FUN-680100 VARCHAR(10)
                    mmb09     LIKE mmb_file.mmb09,
                    mmb13     LIKE mmb_file.mmb13,
                    mmb14     LIKE mmb_file.mmb14,
                    mmbacti   LIKE mmb_file.mmbacti
                    END RECORD
   DEFINE l_n       LIKE type_file.num5          #No.FUN-680100 SMALLINT
   DEFINE l_flag    LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
   DEFINE l_rec_b   LIKE type_file.num5          #No.FUN-680100 SMALLINT
   DEFINE g_cnt1,g_cnt2     LIKE type_file.num5,       #No.FUN-680100 SMALLINT
   l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680100 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680100 SMALLINT
 
   IF cl_null(g_mma.mma01) THEN
      RETURN
   END IF
 
   IF g_mma.mma17 = 'X' THEN
      CALL cl_err('',9024,0)
      RETURN
   END IF
 
   IF g_mma.mma17 = 'N' THEN
      CALL cl_err('',9029,0)
      RETURN
   END IF
 
   IF g_mma.mma04 = 'Y' THEN
      CALL cl_err('',9004,0)
      RETURN
   END IF
 
   LET p_row = 5 LET p_col = 6
   OPEN WINDOW t2003_w AT p_row,p_col WITH FORM "amm/42f/ammt200_b"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("ammt200_b")
 
 
   DECLARE t2003_c CURSOR FOR
      SELECT mmb02,mmb03,mmb04,mmb05,'',mmb06,mmb07,mmb08,'',
             mmb09,mmb13,mmb14,mmbacti
        FROM mmb_file
       WHERE mmb01=g_mma.mma01
         AND mmb14 = 'N'
        #MOD-B40235---modify---start---
        #AND mmb13 <> '2'
         AND (mmb13 <> '2'
          OR (mmb131 IS NULL AND mmb132 IS NULL)) 
        #MOD-B40235---modify---end---
         AND mmbacti = 'Y'
 
   CALL d_mmb.clear()
 
   LET g_cnt=1
   FOREACH t2003_c INTO d_mmb[g_cnt].*
      SELECT mmc02 INTO d_mmb[g_cnt].mmc02 FROM mmc_file
       WHERE mmc01=d_mmb[g_cnt].mmb05
      IF d_mmb[l_ac].mmb07='M' THEN
         SELECT gem02 INTO d_mmb[g_cnt].pmc03 FROM gem_file
          WHERE gem01=d_mmb[g_cnt].mmb08
      ELSE
         SELECT pmc03 INTO d_mmb[g_cnt].pmc03 FROM pmc_file
          WHERE pmc01=d_mmb[g_cnt].mmb08
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > 500 THEN
         EXIT FOREACH
      END IF
   END FOREACH
   CALL d_mmb.deleteElement(g_cnt)
   LET l_rec_b = g_cnt - 1
 
   INPUT ARRAY d_mmb WITHOUT DEFAULTS FROM s_mmb1.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
      BEFORE INPUT
         CALL fgl_set_arr_curr(l_ac)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET d_mmb_t.* = d_mmb[l_ac].*
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD mmbacti
 
      AFTER FIELD mmbacti
         IF NOT cl_null(d_mmb[l_ac].mmb02) AND (cl_null(d_mmb[l_ac].mmbacti) OR
            d_mmb[l_ac].mmbacti NOT MATCHES '[YX]') THEN
            NEXT FIELD mmbacti
         END IF
 
      AFTER ROW
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET d_mmb[l_ac].* = d_mmb_t.*
            EXIT INPUT
         END IF
         IF d_mmb[l_ac].mmb02 IS NOT NULL THEN
            UPDATE mmb_file SET mmbacti=d_mmb[l_ac].mmbacti
             WHERE mmb01=g_mma.mma01
               AND mmb02=d_mmb[l_ac].mmb02
            IF SQLCA.sqlcode THEN
#               CALL cl_err('upd mmb',SQLCA.sqlcode,0)
                CALL cl_err3("upd","mmb_file",g_mma.mma01,d_mmb[l_ac].mmb02,SQLCA.SQLCODE,"","upd mmb",1)       #NO.FUN-660094
               LET d_mmb[l_ac].* = d_mmb_t.*
            ELSE
               MESSAGE 'UPDATE OK.'
            END IF
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
 
   CLOSE WINDOW t2003_w
 
 
END FUNCTION
 
FUNCTION t200_2()
 
   IF s_ammshut(0) THEN
      RETURN
   END IF
 
   IF g_mma.mma04 = 'Y' THEN
      RETURN
   END IF
 
   IF cl_null(g_mma.mma01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #-->未確認不需結案
   IF g_mma.mma17 <> 'Y' THEN
      CALL cl_err('',9026,0)
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t200_cl USING g_mma.mma01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t200_cl INTO g_mma.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mma.mma01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF NOT cl_confirm('amm-049') THEN
      RETURN
   END IF
 
   UPDATE mma_file SET mma04='Y' WHERE mma01=g_mma.mma01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#      CALL cl_err('upd mma17',SQLCA.SQLCODE,1)
       CALL cl_err3("upd","mma_file",g_mma.mma01,"",SQLCA.SQLCODE,"","upd mma17",1)       #NO.FUN-660094
      LET g_mma.mma04='N'
      ROLLBACK WORK
   ELSE
      LET g_mma.mma04='Y'
      COMMIT WORK
   END IF
 
   DISPLAY BY NAME g_mma.mma04
   MESSAGE ''
   CLOSE t200_cl
   COMMIT WORK
    #CKP
    IF g_mma.mma17  ='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_mma.mma17,"","",g_mma.mma04,g_chr,"")
 
END FUNCTION
 
FUNCTION t200_3()
 DEFINE l_mmg14  LIKE mmg_file.mmg14
 
   IF s_ammshut(0) THEN
      RETURN
   END IF
 
   IF g_mma.mma04 <> 'Y' THEN
      RETURN
   END IF
 
   IF cl_null(g_mma.mma01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #-->執行單已結案,需求單不可還原
   SELECT mmg14 INTO l_mmg14  FROM mmg_file
    WHERE mmg01= g_mma.mma02 AND mmg02=g_mma.mma021
   IF l_mmg14 <>'N' THEN
      CALL cl_err(g_mma.mma01,'amm-048 ',0)
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t200_cl USING g_mma.mma01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t200_cl INTO g_mma.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mma.mma01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF NOT cl_confirm('amm-050') THEN
      RETURN
   END IF
 
   UPDATE mma_file SET mma04='N' WHERE mma01=g_mma.mma01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('upd mma17',SQLCA.SQLCODE,1)
      LET g_mma.mma04='Y'
      ROLLBACK WORK
   ELSE
      LET g_mma.mma04='N'
      COMMIT WORK
   END IF
 
   DISPLAY BY NAME g_mma.mma04
   MESSAGE ''
   CLOSE t200_cl
   COMMIT WORK
    #CKP
    IF g_mma.mma17  ='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_mma.mma17,"","",g_mma.mma04,g_chr,"")
 
END FUNCTION
 
FUNCTION t200_4()
DEFINE m_mmb02   LIKE mmb_file.mmb02
 
   IF g_mma.mma01 IS NULL THEN
      RETURN
   END IF
 
   IF g_mma.mma04 = 'Y' THEN
      CALL cl_err('',9004,0)
      RETURN
   END IF
 
   IF g_mma.mma17 = 'N' THEN
      CALL cl_err('',9029,0)
      RETURN
   END IF
 
   IF g_mma.mma17 = 'X' THEN
      CALL cl_err('',9029,0)
      RETURN
   END IF
 
   LET p_row = 7 LET p_col = 7
   OPEN WINDOW t2001_w AT p_row,p_col WITH FORM "amm/42f/ammt200_1"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("ammt200_1")
 
 
   CALL g_mmb.clear()
   LET g_rec_b = 0
   CALL t200_b('B')
   CLOSE WINDOW t2001_w
   CALL t200_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t200_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("mma01,mma02,mma021,mma03,mma05,mma051",TRUE)
   END IF
 
   IF INFIELD(mma02) THEN
      CALL cl_set_comp_entry("mma021,mma03",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t200_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("mma01,mma02,mma021,mma03,mma05,mma051",FALSE)
   END IF
 
   IF INFIELD(mma02) THEN
      IF cl_null(g_mma.mma02) THEN
         CALL cl_set_comp_entry("mma021,mma03",FALSE)
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t200_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
   IF INFIELD(mmb07) THEN
      CALL cl_set_comp_entry("mmb10,mmb11",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t200_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
   IF INFIELD(mmb07) THEN
      IF g_mmb[l_ac].mmb07 = 'M' THEN
         CALL cl_set_comp_entry("mmb10",FALSE)
      END IF
      IF g_mmb[l_ac].mmb07 = 'P' OR g_mmb[l_ac].mmb07 = 'S' THEN
         CALL cl_set_comp_entry("mmb11",FALSE)
      END IF
   END IF
 
END FUNCTION
 
#FUN-840134..............begin
FUNCTION t200_out()
   DEFINE l_wc STRING
   LET l_wc = 'mma01 = "',g_mma.mma01,'"'
  #LET g_sql = "ammr200 ",    #FUN-C30085 mark 
   LET g_sql = "ammg200 ",    #FUN-C30085 add
               " '",g_today,"'",
               " '",g_user,"'",
                " '",g_lang,"'",
               " 'Y'",
               " ' '",
               " '1'",
               " '",l_wc clipped,"'",
               " 'N'",
               " 'N'"
   CALL cl_cmdrun(g_sql)
END FUNCTION
#FUN-840134..............end
#Patch....NO.MOD-5A0095 <003,001,002,004,005> #

#FUN-910088--add--start--
FUNCTION t200_mma09_check(p_ima561,p_ima56)
   DEFINE p_ima561  LIKE ima_file.ima561
   DEFINE p_ima56   LIKE ima_file.ima56
   IF NOT cl_null(g_mma.mma09) AND NOT cl_null(g_mma.mma10) THEN
      IF cl_null(g_mma10_t) OR cl_null(g_mma_t.mma09) OR g_mma10_t != g_mma.mma10 OR g_mma_t.mma09 != g_mma.mma09 THEN
         LET g_mma.mma09 = s_digqty(g_mma.mma09,g_mma.mma10)
         DISPLAY BY NAME g_mma.mma09
      END IF
   END IF
   IF NOT cl_null(g_mma.mma09) THEN
      IF g_mma.mma09 <=0 THEN
         RETURN FALSE    
      END IF
      #最少生產數量
      IF p_ima561 > 0 THEN
         IF g_mma.mma09<p_ima561 THEN
            CALL cl_err(p_ima561,'asf-307',0)
            RETURN FALSE    
         END IF
      END IF
      #生產單位批量
      IF NOT cl_null(p_ima56) AND p_ima56>0  THEN
         IF (g_mma.mma09 MOD p_ima56) > 0 THEN
            CALL cl_err(p_ima56,'asf-308',0)
            RETURN FALSE     
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--

