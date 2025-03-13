# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afat111.4gl
# Descriptions...: 資產位置移轉作業
# Date & Author..: 96/06/04 By Sophia
# ModIFy.........: No:7837 03/08/19 By Wiky 呼叫自動取單號時應在 Transction中
# ModIFy.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# ModIFy.........: No.MOD-490235 04/09/13 By Yuna 自動生成改成用confirm的方式
# ModIFy.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# ModIFy.........: No.MOD-4A0248 04/10/25 By Yuna QBE開窗開不出來
# ModIFy.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# ModIFy.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# ModIFy.........: No.MOD-530200 05/03/22 By Smapmin 存放位置controlp無法帶出資料
# ModIFy.........: No.MOD-530567 05/03/26 By Smapmin 單頭(身),(新)保管人預帶出(新)保管部門
# ModIFy.........: NO.FUN-550034 05/05/17 By jackie 單據編號加大
# ModIFy.........: No.MOD-590470 05/10/24 By Sarah 判斷筆數之條件應排除已作廢之單據(找afa-309)
# ModIFy.........: No.FUN-580109 05/10/24 By Sarah 以EF為backEND engine,由TIPTOP處理前端簽核動作
# ModIFy.........: No.FUN-5B0018 05/11/04 By Sarah 移轉日期沒有判斷關帳日
# ModIFy.........: No.TQC-620120 06/03/02 By Smapmin 當附號為NULL時,LET 附號為空白
# ModIFy.........: No.TQC-630073 06/03/07 By Mandy 流程訊息通知功能
# ModIFy.........: No.FUN-640243 06/05/10 By Echo 自動執行確認功能
# ModIFy.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# ModIFy.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# ModIFy.........: No.FUN-6A0001 06/10/11 By jamie FUNCTION t111()_q 一開始應清空g_fbl.*值
# ModIFy.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# ModIFy.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# ModIFy.........: No.FUN-710028 07/01/30 By hellen 錯誤訊息匯總顯示修改
# ModIFy.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# ModIFy.........: No.TQC-760182 07/06/27 By chenl  自動產生QBE條件不可為空。
# ModIFy.........: No.TQC-780083 07/09/21 By Smapmin 異動類別改為'D'
# ModIFy.........: No.MOD-7B0250 07/11/29 By Smapmin 修改單身未觸發on row change
# ModIFy.........: No.MOD-7C0089 07/12/17 By Smapmin 修改原因性質
# ModIFy.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# ModIFy.........: No.FUN-850068 08/05/14 By TSD.Wind 自定欄位功能修改
# ModIFy.........: No.MOD-8B0150 08/11/14 By chenl   修正自動產生功能退出時，程序蕩出的問題。
# ModIFy.........: No.MOD-960143 09/06/12 By baofei  AFTER FIELD fbm04 應自動抓取gen03帶給fbm05
# ModIFy.........: No.FUN-980003 09/08/12 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# ModIFy.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# ModIFy.........: No:MOD-9C0002 09/12/01 By Sarah 依新的存放位置抓取新的存放營運中心,並回寫faj_file
# ModIFy.........: No.MOD-A10194 10/01/29 By Sarah 過帳與過帳還原段會回寫faj_file,也需同步回寫fga_file
# ModIFy.........: No.FUN-9B0098 10/02/24 by tommas deLETe cl_doc
# ModIFy.........: No:CHI-A60036 10/07/12 By Summer 過帳檢查改用s_azmm,增加aza63判斷
# ModIFy.........: No:MOD-A80137 10/08/19 By Dido 過帳與取消過帳應檢核關帳日 
# ModIFy.........: No.FUN-9A0059 10/08/26 By vealxu 新增列印功能
# ModIFy.........: No:MOD-B30187 11/03/18 By Sarah FUNCTION t111_fbm031()會帶出fbm04/fbm05/fbm06,請判斷當已有值時不要重帶
# ModIFy.........: No:MOD-B30189 11/03/18 By Sarah 新增單據時選擇MOVTE單據別，可是取到的編號是MOV-STD1011030003
# ModIFy.........: No.FUN-AB0088 11/04/02 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# ModIFy.........: No.TQC-B30156 11/05/12 By Dido 預設 fap56 為 0
# ModIFy.........: No.FUN-B50090 11/05/17 By suncx 財務關帳日期加嚴控管修正
# ModIFy.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# ModIFy.........: No.FUN-B50118 11/06/13 By belle 在自動產生鍵增加QBE查詢條件-族群編號
# ModIFy.........: No.TQC-B60072 11/06/15 By yinhy 自動產生功能的SQL語句有誤,有兩組WHERE條件
# ModIFy.........: No:TQC-B60194 11/06/20 By Sarah 隨便點了Ring Menu的任一ACTION，會出現btn_01~btn_20的按鈕
# ModIFy.........: No:MOD-B60256 11/07/01 By Dido faj432 判斷應增加faa31='Y'才需檢核 
# ModIFy.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正
# ModIFy.........: No:FUN-B60140 11/09/08 By minpp "財簽二二次改善" 追單
# ModIFy.........: No:FUN-BA0112 11/11/07 By Sakura 財簽二5.25與5.1程式比對不一致修改
# ModIFy.........: No:CHI-B80007 11/11/12 By johung 增加afa-309控卡 
 
# ModIFy.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# ModIFy.........: No:FUN-C20012 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# ModIFy.........: No:FUN-C30140 12/03/12 By Mandy 送簽中,應不可執行ACTION[自動產生]
# ModIFy.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# ModIFy.........: No:CHI-C60010 12/06/14 By jinjj 財簽二欄位需依財簽二幣別做取位
# ModIFy.........: No.MOD-C70265 12/07/27 By Polly 資產不存在時,將 afa-093 改用訊息 afa-134
# ModIFy.........: No.MOD-C80140 12/08/21 By Polly 異動自動產生不需有faj432條件將以mark
# ModIFy.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# ModIFy.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_fbl   RECORD LIKE fbl_file.*,
       g_fbl_t RECORD LIKE fbl_file.*,
       g_fbl_o RECORD LIKE fbl_file.*,
       g_fahprt       LIKE fah_file.fahprt,
       g_fahconf      LIKE fah_file.fahconf,
       g_fahpost      LIKE fah_file.fahpost,
       g_fahapr       LIKE fah_file.fahapr,     #FUN-640243
       g_fbm          DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                       fbm02     LIKE fbm_file.fbm02,
                       fbm03     LIKE fbm_file.fbm03,
                       fbm031    LIKE fbm_file.fbm031,
                       faj06     LIKE faj_file.faj06,
                       fbm04     LIKE fbm_file.fbm04,
                       fbm05     LIKE fbm_file.fbm05,
                       faj22     LIKE faj_file.faj22,
                       fbm06     LIKE fbm_file.fbm06,
                       #FUN-850068 --start---
                       fbmud01   LIKE fbm_file.fbmud01,
                       fbmud02   LIKE fbm_file.fbmud02,
                       fbmud03   LIKE fbm_file.fbmud03,
                       fbmud04   LIKE fbm_file.fbmud04,
                       fbmud05   LIKE fbm_file.fbmud05,
                       fbmud06   LIKE fbm_file.fbmud06,
                       fbmud07   LIKE fbm_file.fbmud07,
                       fbmud08   LIKE fbm_file.fbmud08,
                       fbmud09   LIKE fbm_file.fbmud09,
                       fbmud10   LIKE fbm_file.fbmud10,
                       fbmud11   LIKE fbm_file.fbmud11,
                       fbmud12   LIKE fbm_file.fbmud12,
                       fbmud13   LIKE fbm_file.fbmud13,
                       fbmud14   LIKE fbm_file.fbmud14,
                       fbmud15   LIKE fbm_file.fbmud15
                       #FUN-850068 --end--
                      END RECORD,
       g_fbm_t        RECORD
                       fbm02     LIKE fbm_file.fbm02,
                       fbm03     LIKE fbm_file.fbm03,
                       fbm031    LIKE fbm_file.fbm031,
                       faj06     LIKE faj_file.faj06,
                       fbm04     LIKE fbm_file.fbm04,
                       fbm05     LIKE fbm_file.fbm05,
                       faj22     LIKE faj_file.faj22,
                       fbm06     LIKE fbm_file.fbm06,
                       #FUN-850068 --start---
                       fbmud01   LIKE fbm_file.fbmud01,
                       fbmud02   LIKE fbm_file.fbmud02,
                       fbmud03   LIKE fbm_file.fbmud03,
                       fbmud04   LIKE fbm_file.fbmud04,
                       fbmud05   LIKE fbm_file.fbmud05,
                       fbmud06   LIKE fbm_file.fbmud06,
                       fbmud07   LIKE fbm_file.fbmud07,
                       fbmud08   LIKE fbm_file.fbmud08,
                       fbmud09   LIKE fbm_file.fbmud09,
                       fbmud10   LIKE fbm_file.fbmud10,
                       fbmud11   LIKE fbm_file.fbmud11,
                       fbmud12   LIKE fbm_file.fbmud12,
                       fbmud13   LIKE fbm_file.fbmud13,
                       fbmud14   LIKE fbm_file.fbmud14,
                       fbmud15   LIKE fbm_file.fbmud15
                       #FUN-850068 --end--
                      END RECORD,
       g_fah          RECORD LIKE fah_file.*,
       g_faj40        LIKE faj_file.faj40,
       g_fbl01_t      LIKE fbl_file.fbl01,
       g_wc,g_wc2     STRING,                   #No.FUN-580092 HCN
       g_sql          STRING,                   #No.FUN-580092 HCN
       l_modIFy_flag  LIKE type_file.chr1,      #No.FUN-680070 VARCHAR(1)
       l_flag         LIKE type_file.chr1,      #No.FUN-680070 VARCHAR(1)
       g_t1           LIKE type_file.chr5,      #No.FUN-550034       #No.FUN-680070 VARCHAR(5)
       g_buf          LIKE type_file.chr1000,   #No.FUN-680070 VARCHAR(30)
       g_rec_b        LIKE type_file.num5,      #單身筆數      #No.FUN-680070 SMALLINT
       l_ac           LIKE type_file.num5,      #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
       l_sl           LIKE type_file.num5       #目前處理的SCREEN LINE       #No.FUN-680070 SMALLINT
DEFINE g_argv1        LIKE fbl_file.fbl01       #異動單號   #FUN-580109
DEFINE g_argv2        STRING                    #指定執行功能:query or inser  #TQC-630073
DEFINE g_laststage    LIKE type_file.chr1       #FUN-580109    #No.FUN-680070 VARCHAR(1)
DEFINE p_row,p_col    LIKE type_file.num5       #No.FUN-680070 SMALLINT
DEFINE g_forupd_sql   STRING                    #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5  #No.FUN-680070 SMALLINT
DEFINE g_chr          LIKE type_file.chr1       #No.FUN-680070 VARCHAR(1)
DEFINE g_chr2         LIKE type_file.chr1       #FUN-580109    #No.FUN-680070 VARCHAR(1)
DEFINE g_cnt          LIKE type_file.num10      #No.FUN-680070 INTEGER
DEFINE g_i            LIKE type_file.num5       #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_msg          LIKE type_file.chr1000    #No.FUN-680070 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10      #No.FUN-680070 INTEGER
DEFINE g_curs_index   LIKE type_file.num10      #No.FUN-680070 INTEGER
DEFINE g_jump         LIKE type_file.num10      #No.FUN-680070 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5       #No.FUN-680070 SMALLINT
DEFINE g_bookno1        LIKE aza_file.aza81       #CHI-A60036 add
DEFINE g_bookno2        LIKE aza_file.aza82       #CHI-A60036 add
DEFINE g_flag           LIKE type_file.chr1       #CHI-A60036 add
#CHI-C60010---str---
DEFINE g_azi04_1  LIKE azi_file.azi04,
       g_faj143   LIKE faj_file.faj143
#CHI-C60010---end---
 
MAIN
#DEFINE l_time        LIKE type_file.chr8       #計算被使用時間       #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
DEFINE l_sql          LIKE type_file.chr1000    #No.FUN-680070 VARCHAR(200)
 
   #FUN-640243
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS                                #改變一些系統預設值
         INPUT NO WRAP
   END IF
   #END FUN-640243

   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_forupd_sql = " SELECT * FROM fbl_file WHERE fbl01 =?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t111_cl CURSOR FROM g_forupd_sql
 
   LET g_wc2 = ' 1=1'
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
 
   LET g_argv1 = ARG_VAL(1) #TQC-630073
   LET g_argv2 = ARG_VAL(2) #TQC-630073

   #FUN-640243
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      #顯示畫面
      LET p_row = 3 LET p_col = 10
      OPEN WINDOW t111_w AT p_row,p_col  WITH FORM "afa/42f/afat111"  
           ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
      CALL cl_ui_init()
   END IF
   #END FUN-640243
 
  #str FUN-580109
   IF fgl_getenv('EASYFLOW') = "1" THEN
      LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
   END IF
 
   #建立簽核模式時的 toolbar icon
   CALL aws_efapp_toolbar()
  #TQC-630073 mark
  #IF NOT cl_null(g_argv1) THEN
  #   CALL t111_q()
  #END IF
  #TQC-630073 add-----------------------
  IF NOT cl_null(g_argv1) THEN
     CASE g_argv2
        WHEN "query"
           LET g_action_choice = "query"
           IF cl_chk_act_auth() THEN
              CALL t111_q()
           END IF
        WHEN "insert"
           LET g_action_choice = "insert"
           IF cl_chk_act_auth() THEN
              CALL t111_a()
           END IF
         #FUN-640243
         WHEN "efconfirm"
            CALL t111_q()
            CALL t111_y_chk()          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               LET l_ac = 1
               CALL t111_y_upd()       #CALL 原確認的 UPDATE 段
            END IF
            EXIT PROGRAM
         #END FUN-640243
         OTHERWISE
            CALL t111_q()
     END CASE
  END IF
  #TQC-630073(end)-----------------
 
   #設定簽核功能及哪些 ACTION 在簽核狀態時是不可被執行的
   CALL aws_efapp_flowaction("insert, modIFy, deLETe, reproduce, detail, query, locale, void, undo_void,         #FUN-D20035 add--undo_void
                              confirm, undo_confirm, easyflow_approval, auto_generate, post, undo_post")
        RETURNING g_laststage
  #END FUN-580109
 
   CALL t111_menu()
   CLOSE WINDOW t111_w                    #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
END MAIN
 
FUNCTION t111_cs()
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01    #No.FUN-580031  HCN

   CLEAR FORM                             #清除畫面
   CALL g_fbm.clear()
  #start FUN-580109
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " fbl01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
   ELSE
  #end FUN-580109
      CALL cl_set_head_visible("","YES")          #No.FUN-6B0029
 
      CONSTRUCT BY NAME g_wc ON                   # 螢幕上取單頭條件
         fbl01,fbl02,fbl06,fbl03,fbl04,fbl05,fblconf,fblpost,
         fblmksg,fbl07,   #FUN-580109 增加簽核,狀況碼
         fbluser,fblgrup,fblmodu,fbldate,
         #FUN-850068   ---start---
         fblud01,fblud02,fblud03,fblud04,fblud05,
         fblud06,fblud07,fblud08,fblud09,fblud10,
         fblud11,fblud12,fblud13,fblud14,fblud15
         #FUN-850068    ----end----
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN

         ON ACTION controlp
            CASE
               WHEN INFIELD(fbl01)    #查詢單據性質
                 #  LET g_t1=g_fbl.fbl01[1,3]
                 #  CALL q_fah( FALSE, TRUE,g_t1,'C',g_sys) RETURNING g_t1
                 #  LET g_fbl.fbl01[1,3]=g_t1
                 #  DISPLAY BY NAME g_fbl.fbl01
                     #--No.MOD-4A0248--------
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                    LET g_qryparam.form = "q_fbl"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbl01
                    #--END---------------
                    NEXT FIELD fbl01
               WHEN INFIELD(fbl03)    #申請人員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbl03
                    NEXT FIELD fbl03
               WHEN INFIELD(fbl04)    #申請部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbl04
                    NEXT FIELD fbl04
               WHEN INFIELD(fbl06)    #異動原因
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_fag"
                    #LET g_qryparam.arg1 = "C"   #MOD-7C0089
                    LET g_qryparam.arg1 = "D"   #MOD-7C0089
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbl06
                    NEXT FIELD fbl06
               OTHERWISE EXIT CASE
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
            CONTINUE CONSTRUCT
 
         #No.FUN-580031 --start--     HCN
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
 
      CONSTRUCT g_wc2 ON fbm02,fbm03,fbm031,faj06,fbm04,fbm05,faj22,fbm06
                         #No.FUN-850068 --start--
                         ,fbmud01,fbmud02,fbmud03,fbmud04,fbmud05
                         ,fbmud06,fbmud07,fbmud08,fbmud09,fbmud10
                         ,fbmud11,fbmud12,fbmud13,fbmud14,fbmud15
                         #No.FUN-850068 ---end---
           FROM s_fbm[1].fbm02, s_fbm[1].fbm03, s_fbm[1].fbm031,s_fbm[1].faj06,
                s_fbm[1].fbm04, s_fbm[1].fbm05,
                s_fbm[1].faj22, s_fbm[1].fbm06
                #No.FUN-850068 --start--
                ,s_fbm[1].fbmud01,s_fbm[1].fbmud02,s_fbm[1].fbmud03
                ,s_fbm[1].fbmud04,s_fbm[1].fbmud05,s_fbm[1].fbmud06
                ,s_fbm[1].fbmud07,s_fbm[1].fbmud08,s_fbm[1].fbmud09
                ,s_fbm[1].fbmud10,s_fbm[1].fbmud11,s_fbm[1].fbmud12
                ,s_fbm[1].fbmud13,s_fbm[1].fbmud14,s_fbm[1].fbmud15
                #No.FUN-850068 ---end---
 
	 #No.FUN-580031 --start--     HCN
	 BEFORE CONSTRUCT
	    CALL cl_qbe_display_condition(lc_qbe_sn)
	 #No.FUN-580031 --end--       HCN

         ON ACTION controlp   #ok
            CASE
               WHEN INFIELD(fbm03)  #財產編號,財產附號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_faj"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbm03
                    NEXT FIELD fbm03
               WHEN INFIELD(fbm04)  #保管人員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbm04
                    NEXT FIELD fbm04
               WHEN INFIELD(fbm05)  #保管部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbm05
                    NEXT FIELD fbm05
               WHEN INFIELD(fbm06)  #存放位置
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_faf"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO fbm06   #MOD-530200
                    NEXT FIELD fbm06
               OTHERWISE
                  EXIT CASE
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
            CONTINUE CONSTRUCT
 
         #No.FUN-580031 --start--     HCN
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   END IF   #FUN-580109
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET g_wc = g_wc clipped," AND fbluser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET g_wc = g_wc clipped," AND fblgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET g_wc = g_wc clipped," AND fblgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fbluser', 'fblgrup')
   #End:FUN-980030
 
   IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
      LET g_sql = "SELECT fbl01 FROM fbl_file",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 1"
   ELSE                                       # 若單身有輸入條件
      LET g_sql = "SELECT DISTINCT fbl01 ",
                  "  FROM fbl_file, fbm_file",
                  " WHERE fbl01 = fbm01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY 1"
   END IF
   PREPARE t111_prepare FROM g_sql
   DECLARE t111_cs SCROLL CURSOR WITH HOLD FOR t111_prepare   #SCROLL CURSOR
 
   IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM fbl_file WHERE ",g_wc CLIPPED
   ELSE
       LET g_sql="SELECT COUNT(DISTINCT fbl01) FROM fbl_file,fbm_file",
                 " WHERE fbm01 = fbl01 ",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
   END IF
   PREPARE t111_precount FROM g_sql
   DECLARE t111_count CURSOR FOR t111_precount
END FUNCTION
 
FUNCTION t111_menu()
   DEFINE l_creator    LIKE type_file.chr1           #「不准」時是否退回填表人 #FUN-580109       #No.FUN-680070 VARCHAR(1)
   DEFINe l_flowuser   LIKE type_file.chr1           # 是否有指定加簽人員      #FUN-580109       #No.FUN-680070 VARCHAR(1)
 
   LET l_flowuser = "N"   #FUN-580109
 
   While true
      call t111_bp("G")
      case g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t111_a()
            end IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t111_q()
            end IF
         WHEN "deLETe"
            IF cl_chk_act_auth() THEN
               CALL t111_r()
            end IF
         WHEN "modIFy"
            IF cl_chk_act_auth() THEN
               CALL t111_u()
            end IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t111_b()
            elsE
               LET g_action_choice = NULL
            end IF
         #FUN-9A0059 ------------------------add start-----------------
         WHEN "output"
              IF cl_chk_act_auth() THEN                                           
               CALL t111_out()                                                  
            END IF
         #FUN-9A0059 ------------------------add end----------------------
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "auto_generate"
            IF cl_chk_act_auth() THEN
                #FUN-C30140---add---str---
                IF NOT cl_null(g_fbl.fbl07) AND g_fbl.fbl07 matches '[Ss]' THEN     
                    CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
                ELSE
                #FUN-C30140---add---end---
                    CALL t111_g()
                    CALL t111_b()
                END IF
            end IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t111_x()            #FUN-D20035
               CALL t111_x(1)           #FUN-D20035
            end IF

          #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t111_x(2)
            END IF
         #FUN-D20035---add---end

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               #start FUN-580109
               #CALL t111_y()
               CALL t111_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t111_y_upd()       #CALL 原確認的 UPDATE 段
               END IF
               #end FUN-580109
            end IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t111_z()
            end IF
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t111_s('S')
            end IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t111_w()
            end IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fbl.fbl01 IS NOT NULL THEN
                  LET g_doc.column1 = "fbl01"
                  LET g_doc.value1 = g_fbl.fbl01
                  CALL cl_doc()
               END IF
            end IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fbm),'','')
            END IF
#start FUN-580109
        #@WHEN "簽核狀況"
        WHEN "approval_status"
             IF cl_chk_act_auth() THEN  #DISPLAY ONLY
                IF aws_condition2() THEN
                   CALL aws_efstat2()
                END IF
             END IF
 
        ##EasyFlow送簽
        WHEN "easyflow_approval"
             IF cl_chk_act_auth() THEN
               #FUN-C20012 add str---
                SELECT * INTO g_fbl.* FROM fbl_file
                 WHERE fbl01 = g_fbl.fbl01
                CALL t111_show()
                CALL t111_b_fill(' 1=1')
               #FUN-C20012 add end---
                CALL t111_ef()
                CALL t111_show()  #FUN-C20012 add
             END IF
 
        #@WHEN "准"
        WHEN "agree"
             IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有>
                CALL t111_y_upd()      #CALL 原確認的 UPDATE 段
             ELSE
                LET g_success = "Y"
                IF NOT aws_efapp_formapproval() THEN
                   LET g_success = "N"
                END IF
             END IF
             IF g_success = 'Y' THEN
                IF cl_confirm('aws-081') THEN
                   IF aws_efapp_getnextforminfo() THEN
                      LET l_flowuser = 'N'
                      LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                      IF NOT cl_null(g_argv1) THEN
                         CALL t111_q()
                         #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                         CALL aws_efapp_flowaction("insert, modIFy, deLETe, reproduce, detail, query, locale, void, undo_void,    #FUN-D20035 add--undo_void
                                                    confirm, undo_confirm, easyflow_approval, auto_generate, post, undo_post")
                              RETURNING g_laststage
                      ELSE
                         EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                ELSE
                   EXIT WHILE
                END IF
             END IF
 
        #@WHEN "不准"
        WHEN "deny"
            IF ( l_creator := aws_efapp_backflow()) IS NOT NULL THEN
               IF aws_efapp_formapproval() THEN
                  IF l_creator = "Y" THEN
                     LET g_fbl.fbl07 = 'R'
                     DISPLAY BY NAME g_fbl.fbl07
                  END IF
                  IF cl_confirm('aws-081') THEN
                     IF aws_efapp_getnextforminfo() THEN
                        LET l_flowuser = 'N'
                        LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                        IF NOT cl_null(g_argv1) THEN
                           CALL t111_q()
                           #設定簽核功能及哪些 action 在簽核狀態時是不可被執行>
                           CALL aws_efapp_flowaction("insert, modIFy, deLETe, reproduce, detail, query, locale, void, undo_void,  #FUN-D20035 add--undo_void
                                                      confirm, undo_confirm, easyflow_approval, auto_generate, post, undo_post")
                                RETURNING g_laststage
                        ELSE
                           EXIT WHILE
                        END IF
                     ELSE
                        EXIT WHILE
                     END IF
                  ELSE
                     EXIT WHILE
                  END IF
               END IF
             END IF
 
        #@WHEN "加簽"
        WHEN "modIFy_flow"
             IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                LET l_flowuser = 'Y'
             ELSE
                LET l_flowuser = 'N'
             END IF
 
        #@WHEN "撤簽"
        WHEN "withdraw"
             IF cl_confirm("aws-080") THEN
                IF aws_efapp_formapproval() THEN
                   EXIT WHILE
                END IF
             END IF
 
        #@WHEN "抽單"
        WHEN "org_withdraw"
             IF cl_confirm("aws-079") THEN
                IF aws_efapp_formapproval() THEN
                   EXIT WHILE
                END IF
             END IF
 
        #@WHEN "簽核意見"
        WHEN "phrase"
             CALL aws_efapp_phrase()
#end FUN-580109
      end case
   End while
END FUNCTION
 
FUNCTION t111_a()
    DEFINE li_result   LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    message ""
    clear form
    call g_fbm.clear()
    initialize g_fbl.* TO NULL
    LET g_fbl01_t = NULL
    LET g_fbl_o.* = g_fbl.*
    LET g_fbl_t.* = g_fbl.*
 
    call cl_opmsg('a')
    while true
        LET g_fbl.fbl02  =g_today
        LET g_fbl.fbl05  =g_today
        LET g_fbl.fblconf='N'
        LET g_fbl.fblpost='N'
        LET g_fbl.fblprsw=0
        LET g_fbl.fbluser=g_user
        LET g_fbl.fbloriu = g_user #FUN-980030
        LET g_fbl.fblorig = g_grup #FUN-980030
        LET g_fbl.fblgrup=g_grup
        LET g_fbl.fbldate=g_today
        LET g_fbl.fblmksg = "N"   #FUN-580109
        LET g_fbl.fbl07 = "0"     #FUN-580109
        LET g_fbl.fbllegal = g_legal    #FUN-980003 add
        call t111_i("a")                #輸入單頭
        IF int_FLAG THEN
           LET INT_FLAG=0
           initIALIZE g_fbl.* TO NULL
           call cl_err('',9001,0)
           rollBACK WORK
           exit WHILE
        end IF
        IF g_fbl.fbl01 IS NULL THEN       #KEY不可空白
           contINUE WHILE
        end IF
#       BEGIN wORK  #No:7837   #No.FUN-710028
        BEGIN WORK  #No.FUN-710028
#No.FUN-550034 --start--
        CALL s_auto_assign_no("afa",g_fbl.fbl01,g_fbl.fbl02,"C","fbl_file","fbl01","","","")
             RETURNING li_result,g_fbl.fbl01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fbl.fbl01
#       IF g_fah.fahauno='Y' THEN
#          call s_afaauno(g_fbl.fbl01,g_fbl.fbl02)
#               RETURNING g_i,g_fbl.fbl01
#          IF g_i THEN CONTINUE WHILE END IF    #有問題
#          dispLAY BY NAME g_fbl.fbl01
#       end IF
#No.FUN-550034 ---end--
 
        INSERT INTO fbl_file VALUES (g_fbl.*)
        IF sqlcA.SQLCODE THEN
           CALL cl_err3("ins","fbl_file",g_fbl.fbl01,"",SQLCA.SQLCODE,"","Ins:",1)  #No.FUN-660136   #No.FUN-B80054---調整至回滾事務前---
           rollBACK WORK  #No:7837
#          call cl_err('Ins:',SQLCA.SQLCODE,0)  #No.FUN-660136
           contINUE WHILE
        ELSE
           commIT WORK   #No:7837
           call cl_flow_notIFy(g_fbl.fbl01,'I')
        end IF
        LET g_rec_b=0
        LET g_fbl_t.* = g_fbl.*
        LET g_fbl01_t = g_fbl.fbl01
        select fbl01 INTO g_fbl.fbl01
          from fbl_file
         where fbl01 = g_fbl.fbl01
 
        call t111_g()
        call t111_b()       #自動產生單身
        #---判斷是否直接列印,確認,過帳---------
        LET g_t1 = s_get_doc_no(g_fbl.fbl01)       #No.FUN-550034
        #FUN-640243
        SELECT fahprt,fahconf,fahpost,fahapr
           INTO g_fahprt,g_fahconf,g_fahpost,g_fahapr
        FROM fah_file WHERE fahslip = g_t1
 
        IF g_fahconf = 'Y' AND g_fahapr <> 'Y' THEN
           LET g_action_choice = "insert"
        #END FUN-640243
 
           #start FUN-580109
           #CALL t111_y()
           CALL t111_y_chk()          #CALL 原確認的 check 段
           IF g_success = "Y" THEN
              CALL t111_y_upd()       #CALL 原確認的 UPDATE 段
           END IF
           #end FUN-580109
        END IF
        IF g_fahpost = 'Y' THEN
           CALL t111_s('S')
        END IF
        exit whILE
    end while
END FUNCTION
 
FUNCTION t111_u()
   IF s_shut(0) THEN RETURN END IF
 
    IF g_fbl.fbl01 IS NULL THEN
       call cl_err('',-400,0)
       return
    end IF
    select * INTO g_fbl.* FROM fbl_file WHERE fbl01 = g_fbl.fbl01
    IF g_fbl.fblconf = 'X' THEN
       call cl_err(' ','9024',0)
       return
    end IF
    IF g_fbl.fblconf = 'Y' THEN
       call cl_err(' ','afa-096',0)
       return
    end IF
    IF g_fbl.fblpost = 'Y' THEN
       call cl_err(' ','afa-101',0)
       return
    end IF
   #start FUN-580109
    IF g_fbl.fbl07 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
   #end FUN-580109
    message ""
    call cl_opmsg('u')
    LET g_fbl01_t = g_fbl.fbl01
    LET g_fbl_o.* = g_fbl.*
#   BEGIN WORK    #No.FUN-710028
    BEGIN WORK    #No.FUN-710028
 
    open t111_cl USING g_fbl.fbl01
    IF status tHEN
       call cl_err("OPEN t111_cl:", STATUS, 1)
       close t111_cl
       rollback WORK
       return
    end IF
    fetch t111_cl INTO g_fbl.*          # 鎖住將被更改或取消的資料
    IF sqlca.sqlcode THEN
        call cl_err(g_fbl.fbl01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        close t111_cl ROLLBACK WORK RETURN
    end IF
    call t111_show()
    while true
        LET g_fbl01_t = g_fbl.fbl01
        LET g_fbl.fblmodu=g_user
        LET g_fbl.fbldate=g_today
        call t111_i("u")                      #欄位更改
        IF int_FLAG THEN
            LET INT_FLAG = 0
            LET g_fbl.*=g_fbl_t.*
            calL t111_show()
            calL cl_err('','9001',0)
            exiT WHILE
        end IF
        LET g_fbl.fbl07 = '0'   #FUN-580109
        IF g_fbl.fbl01 != g_fbl_t.fbl01 THEN
           updaTE fbm_file SET fbm01=g_fbl.fbl01 WHERE fbm01=g_fbl_t.fbl01
           IF sQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#             cALL cl_err('upd fbm01',SQLCA.SQLCODE,0)    #No.FUN-660136
              CALL cl_err3("upd","fbm_file",g_fbl_t.fbl01,"",SQLCA.SQLCODE,"","upd fbm01",1)  #No.FUN-660136
              lET g_fbl.*=g_fbl_t.*
              cALL t111_show()
              cONTINUE WHILE
           end IF
        end IF
        UPDATE fbl_file SET * = g_fbl.*
         where fbl01 = g_fbl.fbl01
        IF sqlcA.SQLERRD[3] = 0 OR SQLCA.SQLCODE THEN
           call cl_err(g_fbl.fbl01,SQLCA.SQLCODE,0)   #No.FUN-660136
           CALL cl_err3("upd","fbl_file",g_fbl_t.fbl01,"",SQLCA.SQLCODE,"","",1)  #No.FUN-660136
           contINUE WHILE
        end IF
       #start FUN-580109
        DISPLAY BY NAME g_fbl.fbl07
        IF g_fbl.fblconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_fbl.fbl07 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_fbl.fblconf,g_chr2,g_fbl.fblpost,"",g_chr,"")
       #end FUN-580109
        exit whILE
    end while
    close t111_cl
    commit WORK
    call cl_flow_notIFy(g_fbl.fbl01,'U')
END FUNCTION
 
#處理input
FUNCTION t111_i(p_cmd)
  DEfine p_cmd           LIKE type_file.chr1,   #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
         l_flag          LIKE type_file.chr1,   #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
         l_bdate,l_edate LIKE type_file.dat,    #No.FUN-680070 DATE
         l_n1            LIKE type_file.num5    #No.FUN-680070 SMALLINT
  DEFINE li_result   LIKE type_file.num5        #No.FUN-680070 SMALLINT
    CALL cl_set_head_visible("","YES")          #No.FUN-6B0029
 
    INPUT BY NAME g_fbl.fbloriu,g_fbl.fblorig,
        g_fbl.fbl01,g_fbl.fbl02,g_fbl.fbl06,g_fbl.fbl03,g_fbl.fbl04,g_fbl.fbl05,
        g_fbl.fblconf,g_fbl.fblpost,
        g_fbl.fblmksg,g_fbl.fbl07,   #FUN-580109
        g_fbl.fbluser,g_fbl.fblgrup,g_fbl.fblmodu,g_fbl.fbldate,
        #FUN-850068     ---start---
        g_fbl.fblud01,g_fbl.fblud02,g_fbl.fblud03,g_fbl.fblud04,
        g_fbl.fblud05,g_fbl.fblud06,g_fbl.fblud07,g_fbl.fblud08,
        g_fbl.fblud09,g_fbl.fblud10,g_fbl.fblud11,g_fbl.fblud12,
        g_fbl.fblud13,g_fbl.fblud14,g_fbl.fblud15 
        #FUN-850068     ----end----
           withOUT DEFAULTS
 
        before INPUT
           LET g_before_input_done = FALSE
           call t111_set_entry(p_cmd)
           call t111_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
#No.FUN-550034 --start--
         CALL cl_set_docno_format("fbl01")
#No.FUN-550034 ---end---
 
        AFTER FIELD fbl01
          IF NOT cl_null(g_fbl.fbl01) AND (g_fbl.fbl01!=g_fbl01_t) THEN                                 #MOD-B30189 mark
          # IF NOT cl_null(g_fbl.fbl01) AND (g_fbl.fbl01 != g_fbl_t.fbl01 OR g_fbl_t.fbl01 IS NULL) THEN  #MOD-B30189
#No.FUN-550034 --start--
              CALL s_check_no("afa",g_fbl.fbl01,g_fbl01_t,"C","fbl_file","fbl01","")
                   RETURNING li_result,g_fbl.fbl01
              DISPLAY BY NAME g_fbl.fbl01
              IF (NOT li_result) THEN
                 NEXT FIELD fbl01
              END IF
#             LET g_t1=g_fbl.fbl01[1,3]
#             CALL s_afaslip(g_t1,'C',g_sys)          #檢查移轉單別
#             IF NOT cl_null(g_errno) THEN            #抱歉, 有問題
#                CALL cl_err(g_t1,g_errno,0)
#                LET g_fbl.fbl01 = g_fbl_o.fbl01
#                NEXT FIELD fbl01
#             END IF
              LET g_t1 = s_get_doc_no(g_fbl.fbl01)  #No.FUN-550034
              SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
#             IF p_cmd = 'a' THEN
#                IF g_fbl.fbl01[1,3] IS NOT NULL  AND
#                   cl_null(g_fbl.fbl01[5,10]) AND g_fah.fahauno = 'N' THEN
#                   NEXT FIELD fbl01
#                ELSE
#                   NEXT FIELD fbl02
#                END IF
#             END IF
#             IF g_fbl.fbl01 != g_fbl_t.fbl01 OR g_fbl_t.fbl01 IS NULL THEN
#                 IF g_fah.fahauno = 'Y' AND NOT cl_chk_data_continue(g_fbl.fbl01[5,10]) THEN
#                    CALL cl_err('','9056',0)
#                    NEXT FIELD fbl01
#                 END IF
#                 SELECT count(*) INTO g_cnt FROM fbl_file
#                  WHERE fbl01 = g_fbl.fbl01
#                 IF g_cnt > 0 THEN   #資料重複
#                     CALL cl_err(g_fbl.fbl01,-239,0)
#                     LET g_fbl.fbl01 = g_fbl_t.fbl01
#                     DISPLAY BY NAME g_fbl.fbl01
#                     NEXT FIELD fbl01
#                 END IF
#             END IF
#No.FUN-550034 ---end--
            END IF
           #start FUN-580109 帶出單據別設定的"簽核否"值,狀況碼預設為0
            SELECT fahapr,'0' INTO g_fbl.fblmksg,g_fbl.fbl07
              FROM fah_file
             WHERE fahslip = g_t1
            IF cl_null(g_fbl.fblmksg) THEN            #FUN-640243
               LET g_fbl.fblmksg = 'N'
            END IF
 
            DISPLAY BY NAME g_fbl.fblmksg,g_fbl.fbl07
           #end FUN-580109
            LET g_fbl_o.fbl01 = g_fbl.fbl01
 
        AFTER FIELD fbl02
            IF NOT cl_null(g_fbl.fbl02) THEN
               CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate
               IF g_fbl.fbl02 < l_bdate THEN
                  CALL cl_err(g_fbl.fbl02,'afa-130',0)
                  NEXT FIELD fbl02
               END IF
               #-----No:FUN-B60140-----
              IF g_faa.faa31 = "Y" THEN
                 CALL s_azn01(g_faa.faa072,g_faa.faa082) RETURNING l_bdate,l_edate
                 IF g_fbl.fbl02 < l_bdate THEN
                    CALL cl_err(g_fbl.fbl02,'afa-130',0)
                    NEXT FIELD fbl02
                 END IF
                 IF g_fbl.fbl02 <= g_faa.faa092 THEN
                    CALL cl_err('','mfg9999',1)
                    NEXT FIELD fbl02
                 END IF
              END IF
              #-----No:FUN-B60140 END-----
            END IF
           #start FUN-5B0018
            IF NOT cl_null(g_fbl.fbl02) THEN
               IF g_fbl.fbl02 <= g_faa.faa09 THEN
                  CALL cl_err('','mfg9999',1)
                  NEXT FIELD fbl02
               END IF
            END IF
           #end FUN-5B0018
 
        AFTER FIELD fbl03
            IF NOT cl_null(g_fbl.fbl03) THEN
               CALL t111_fbl03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fbl.fbl03,g_errno,0)
                  LET g_fbl.fbl03 = g_fbl_t.fbl03
                  DISPLAY BY NAME g_fbl.fbl03
                  NEXT FIELD fbl03
               END IF
            end IF
            LET g_fbl_o.fbl03 = g_fbl.fbl03
 #MOD-530567
            SELECT gen03 INTO g_fbl.fbl04 FROM gen_file
                   WHERE gen01 = g_fbl.fbl03
 #END MOD-530567
        AFTER FIELD fbl04
            IF NOT cl_null(g_fbl.fbl04) THEN
               CALL t111_fbl04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fbl.fbl04,g_errno,0)
                  LET g_fbl.fbl04 = g_fbl_t.fbl04
                  DISPLAY BY NAME g_fbl.fbl04
                  NEXT FIELD fbl04
               END IF
            end IF
            LET g_fbl_o.fbl04 = g_fbl.fbl04
 
        AFTER FIELD fbl06
            IF NOT cl_null(g_fbl.fbl06) THEN
               CALL t111_fbl06('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fbl.fbl06,g_errno,0)
                    LET g_fbl_t.fbl06 = g_fbl.fbl06
                    DISPLAY BY NAME g_fbl.fbl06
                    NEXT FIELD fbl06
                 END IF
            end IF
 
        #FUN-850068     ---start---
        AFTER FIELD fblud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fblud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fblud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fblud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fblud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fblud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fblud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fblud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fblud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fblud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fblud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fblud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fblud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fblud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fblud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-850068     ----end----
 
       after inPUT   #97/05/22 modIFy
          LET g_fbl.fbluser = s_get_data_owner("fbl_file") #FUN-C10039
          LET g_fbl.fblgrup = s_get_data_group("fbl_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
       on actioN controlp               #ok
           case
            WHEN INFIELD(fbl01)    #查詢單據性質
                 LET g_t1 = s_get_doc_no(g_fbl.fbl01)  #No.FUN-550034
                 CALL q_fah( FALSE, TRUE,g_t1,'C',g_sys) RETURNING g_t1
#                 CALL FGL_DIALOG_SETBUFFER( g_t1 )
                LET g_fbl.fbl01 = g_t1       #No.FUN-550034
                DISPLAY BY NAME g_fbl.fbl01
                 NEXT FIELD fbl01
            WHEN INFIELD(fbl03)    #申請人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fbl.fbl03
                 CALL cl_create_qry() RETURNING g_fbl.fbl03
#                 CALL FGL_DIALOG_SETBUFFER( g_fbl.fbl03 )
                 DISPLAY BY NAME g_fbl.fbl03
                 NEXT FIELD fbl03
            WHEN INFIELD(fbl04)    #申請部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fbl.fbl04
                 CALL cl_create_qry() RETURNING g_fbl.fbl04
#                 CALL FGL_DIALOG_SETBUFFER( g_fbl.fbl04 )
                 DISPLAY BY NAME g_fbl.fbl04
                 NEXT FIELD fbl04
            WHEN INFIELD(fbl06)    #異動原因
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fag"
                 #LET g_qryparam.arg1 = "C"   #MOD-7C0089
                 LET g_qryparam.arg1 = "D"   #MOD-7C0089
                 LET g_qryparam.default1 = g_fbl.fbl06
                 CALL cl_create_qry() RETURNING g_fbl.fbl06
#                 CALL FGL_DIALOG_SETBUFFER( g_fbl.fbl06 )
                 DISPLAY BY NAME g_fbl.fbl06
                 NEXT FIELD fbl06
              oTHERWISE EXIT CASE
           end CASE
 
        ON ACTION CONTROLF                  #欄位說明
         call cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         call cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLO                        # 沿用所有欄位
            IF INFIELD(fbl01) THEN
                LET g_fbl.* = g_fbl_t.*
                LET g_fbl.fbl01 = ' '
                LET g_fbl.fblconf = 'N'
                LET g_fbl.fblpost = 'N'
                CALL t111_show()
                NEXT FIELD fbl01
            end IF
 
         on actION CONTROLR
            calL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
       on idle g_idle_seconds
          call cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
          contiNUE INPUT
 
    end input
END FUNCTION
FUNCTION t111_set_entry(p_cmd)
 DEFine p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    call cl_set_comp_entry("fbl01",TRUE)
    end IF
 
END FUNCTION
 
FUNCTION t111_set_no_entry(p_cmd)
  DEfine p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    call cl_set_comp_entry("fbl01",FALSE)
    end IF
 
END FUNCTION
 
FUNCTION t111_fbl03(p_cmd)
 DEFine   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_gen02    LIKE gen_file.gen02,
          l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    select gen02,genacti INTO l_gen02,l_genacti
      from gen_file
     where gen01 = g_fbl.fbl03
    case
        WHEN sqLCA.SQLCODE = 100 LET g_errno ='afa-034'
                                 LET l_gen02 = NULL
                                 LET l_genacti = NULL
        WHEN l_genacti = 'N' LET g_errno = '9028'
        otherwiSE            LET g_errno = SQLCA.SQLCODE USING '-------'
   End case
   IF cl_null(g_errno) OR p_cmd = 'd'
   Then display l_gen02 TO FORMONLY.gen02
   End IF
END FUNCTION
 
FUNCTION t111_fbl04(p_cmd)
 DEFine   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_gem02    LIKE gem_file.gem02,
          l_gemacti  LIKE gem_file.gemacti
 
    LET g_errno = ' '
    select gem02,gemacti INTO l_gem02,l_gemacti
      from gem_file
     where gem01 = g_fbl.fbl04
    case
        WHEN sqLCA.SQLCODE = 100 LET g_errno ='afa-038'
                                 LET l_gem02 = NULL
                                 LET l_gemacti = NULL
        WHEN l_gemacti = 'N' LET g_errno = '9028'
        otherwiSE            LET g_errno = SQLCA.SQLCODE USING '-------'
   End case
   IF cl_null(g_errno) OR p_cmd = 'd'
   Then display l_gem02 TO FORMONLY.gem02
   End IF
END FUNCTION
 
FUNCTION t111_fbl06(p_cmd)
 DEFine   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_fag01    LIKE fag_file.fag01,
          l_fag03    LIKE fag_file.fag03,
          l_fagacti  LIKE fag_file.fagacti
 
    LET g_errno = ' '
    select fag01,fagacti,fag03 INTO l_fag01,l_fagacti,l_fag03
      from fag_file
     where fag01 = g_fbl.fbl06
       #and fag02 = 'C'   #MOD-7C0089
       and fag02 = 'D'   #MOD-7C0089
    case
        WHEN sqLCA.SQLCODE = 100 LET g_errno ='afa-099'
                                 LET l_fag01 = NULL
                                 LET l_fag03 = NULL
                                 LET l_fagacti = NULL
        WHEN l_fagacti = 'N' LET g_errno = '9028'
        otherwiSE            LET g_errno = SQLCA.SQLCODE USING '-------'
   End case
   Display l_fag03 TO FORMONLY.fag03
END FUNCTION
 
FUNCTION t111_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    call cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fbl.* TO NULL             #No.FUN-6A0001
   #message ""
    CALL cl_msg("")                              #FUN-640243
 
    call cl_opmsg('q')
    display '   ' TO FORMONLY.cnt
    call t111_cs()
    IF int_flag THEN
       LET int_FLAG = 0
       initialiZE g_fbl.* TO NULL
       return
    end IF
   #message " sEARCHING ! "
    CALL cl_msg(" SEARCHING ! ")                 #FUN-640243
 
    open t111_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF sqlca.sqlcode THEN
        call cl_err('',SQLCA.sqlcode,0)
        initialIZE g_fbl.* TO NULL
    ELSE
        open t111_count
        fetch t111_count INTO g_row_count
        display g_row_count TO FORMONLY.cnt
        call t111_fetch('F')                  # 讀出TEMP第一筆並顯示
    end IF
   #message ""
    CALL cl_msg("")                              #FUN-640243
 
END FUNCTION
 
FUNCTION t111_fetch(p_flag)
DEFIne
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    case p_flag
        WHEN 'N' FETCH NEXT     t111_cs INTO g_fbl.fbl01
        WHEN 'P' FETCH PREVIOUS t111_cs INTO g_fbl.fbl01
        WHEN 'F' FETCH FIRST    t111_cs INTO g_fbl.fbl01
        WHEN 'L' FETCH LAST     t111_cs INTO g_fbl.fbl01
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
            end IF
            fetCH ABSOLUTE g_jump t111_cs INTO g_fbl.fbl01
            LET mi_no_ask = FALSE
    end case
 
    IF sqlca.sqlcode THEN
        call cl_err(g_fbl.fbl01,SQLCA.sqlcode,0)
        INITIALIZE g_fbl.* TO NULL   #No.TQC-6B0105
        return
    ELSE
       case p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       end case
 
       call cl_navigator_setting( g_curs_index, g_row_count )
    end IF
    select * INTO g_fbl.* FROM fbl_file WHERE fbl01 = g_fbl.fbl01
    IF sqlca.sqlcode THEN
#       call cl_err(g_fbl.fbl01,SQLCA.sqlcode,0)    #No.FUN-660136
        CALL cl_err3("sel","fbl_file",g_fbl.fbl01,"",SQLCA.SQLCODE,"","",1)  #No.FUN-660136
        initialIZE g_fbl.* TO NULL
        return
    end IF
    LET g_data_owner = g_fbl.fbluser   #FUN-4C0059
    LET g_data_group = g_fbl.fblgrup   #FUN-4C0059
 
    call t111_show()
END FUNCTION
 
FUNCTION t111_show()
    LET g_fbl_t.* = g_fbl.*                #保存單頭舊值
    DISPLAY BY NAME g_fbl.fbloriu,g_fbl.fblorig,
        g_fbl.fbl01,g_fbl.fbl02,g_fbl.fbl03,g_fbl.fbl04,g_fbl.fbl05,
        g_fbl.fbl06,
        g_fbl.fblconf,g_fbl.fblpost,
        g_fbl.fblmksg,g_fbl.fbl07,   #FUN-580109 增加簽核,狀況碼
        g_fbl.fbluser,g_fbl.fblgrup,g_fbl.fblmodu,g_fbl.fbldate,
        #FUN-850068     ---start---
        g_fbl.fblud01,g_fbl.fblud02,g_fbl.fblud03,g_fbl.fblud04,
        g_fbl.fblud05,g_fbl.fblud06,g_fbl.fblud07,g_fbl.fblud08,
        g_fbl.fblud09,g_fbl.fblud10,g_fbl.fblud11,g_fbl.fblud12,
        g_fbl.fblud13,g_fbl.fblud14,g_fbl.fblud15 
        #FUN-850068     ----end----
    IF g_fbl.fblconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   #start FUN-580109
    IF g_fbl.fbl07 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   #CALL cl_set_field_pic(g_fbl.fblconf,"",g_fbl.fblpost,"",g_chr,"")
    CALL cl_set_field_pic(g_fbl.fblconf,g_chr2,g_fbl.fblpost,"",g_chr,"")
   #end FUN-580109
    CALL t111_fbl03('d')
    CALL t111_fbl04('d')
    CALL t111_fbl06('d')
    CALL t111_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t111_r()
 DEFine l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fbl.fbl01 IS NULL THEN
       call cl_err('',-400,0) RETURN
    end IF
    select * INTO g_fbl.* FROM fbl_file WHERE fbl01 = g_fbl.fbl01
    IF g_fbl.fblconf = 'X' THEN
       call cl_err('','9024',0) RETURN
    end IF
    IF g_fbl.fblconf = 'Y' THEN
       call cl_err('','afa-096',0) RETURN
    end IF
    IF g_fbl.fblpost = 'Y' THEN
       call cl_err(' ','afa-101',0) RETURN
    end IF
   #start FUN-580109
    IF g_fbl.fbl07 matches '[Ss1]' THEN
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF
   #end FUN-580109
    BEGIN WORK
 
    open t111_cl USING g_fbl.fbl01
    IF status tHEN
       call cl_err("OPEN t111_cl:", STATUS, 1)
       close t111_cl
       rollback WORK
       return
    end IF
    fetch t111_cl INTO g_fbl.*
    IF sqlca.sqlcode THEN
       call cl_err(g_fbl.fbl01,SQLCA.sqlcode,0)
       close t111_cl ROLLBACK WORK RETURN
    end IF
    call t111_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fbl01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fbl.fbl01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        message "DeLETe fbl,fbm!"
        deLETe FROM fbl_file WHERE fbl01 = g_fbl.fbl01
        IF sqlcA.SQLERRD[3]=0 THEN
#          call cl_err('No fbl deLETed',SQLCA.SQLCODE,0)   #No.FUN-660136
           CALL cl_err3("del","fbl_file",g_fbl.fbl01,"",SQLCA.SQLCODE,"","No fbl deLETed",1)  #No.FUN-660136
        ELSE
           deleTE FROM fbm_file WHERE fbm01 = g_fbl.fbl01  
           cleaR FORM
           call g_fbm.clear()
        end IF
        initialIZE g_fbl.* LIKE fbl_file.*
        open t111_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE t111_cs
             CLOSE t111_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        fetch t111_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t111_cs
             CLOSE t111_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        display g_row_count TO FORMONLY.cnt
        open t111_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           call t111_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           call t111_fetch('/')
        end IF
 
    end IF
    close t111_cl
    commit WORK
    call cl_flow_notIFy(g_fbl.fbl01,'D')
END FUNCTION
 
FUNCTION t111_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
       l_row,l_col     LIKE type_file.num5,                #分段輸入之行,列數       #No.FUN-680070 SMALLINT
       l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
       l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
       l_b2            LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
       l_faj06         LIKE faj_file.faj06,
       l_faj100        LIKE faj_file.faj100,
       l_qty           LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(15,3)
       l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
       l_allow_deLETe  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
DEFINE l_fbl07         LIKE fbl_file.fbl07    #FUN-580109
 
    LET g_action_choice = ""
    LET l_fbl07 = g_fbl.fbl07   #FUN-580109
 
    IF g_fbl.fbl01 IS NULL THEN RETURN END IF
    IF g_fbl.fblconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_fbl.fblconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fbl.fblpost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
   #start FUN-580109
    IF g_fbl.fbl07 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
   #end FUN-580109
 
    call cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT fbm02,fbm03,fbm031,'',fbm04,fbm05,'',fbm06, ",
                       #No.FUN-850068 --start--
                       "        fbmud01,fbmud02,fbmud03,fbmud04,fbmud05,",
                       "        fbmud06,fbmud07,fbmud08,fbmud09,fbmud10,",
                       "        fbmud11,fbmud12,fbmud13,fbmud14,fbmud15 ", 
                       #No.FUN-850068 ---end---
                       " FROM fbm_file ",
                       " WHERE fbm01 = ? ",
                       " AND fbm02 = ? ",
                       " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    declare t111_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_deLETe = cl_detail_input_auth("deLETe")
 
   #ckp2
   IF g_rec_b=0 THEN CALL g_fbm.clear() END IF
 
 
    input array g_fbm WITHOUT DEFAULTS FROM s_fbm.*
          attriBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_deLETe,APPEND ROW=l_allow_insert)
 
        before INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            end IF
 
        before ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            disPLAY l_ac TO FORMONLY.cn3
           #LET g_fbm_t.* = g_fbm[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            begIN WORK
 
            opeN t111_cl USING g_fbl.fbl01
            IF STATUS THEN
               CALL cl_err("OPEN t111_cl:", STATUS, 1)
               CLOSE t111_cl
               ROLLBACK WORK
               RETURN
            end IF
            fetCH t111_cl INTO g_fbl.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fbl.fbl01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t111_cl ROLLBACK WORK RETURN
            end IF
           #IF g_fbm[l_ac].fbm02 IS NOT NULL THEN
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_fbm_t.* = g_fbm[l_ac].*  #BACKUP
                LET l_flag = 'Y'
 
                OPEN t111_bcl USING g_fbl.fbl01,g_fbm_t.fbm02
                IF STATUS THEN
                   CALL cl_err("OPEN t111_bcl:", STATUS, 1)   
                   CLOSE t111_bcl
                   LET l_lock_sw = "Y"
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t111_bcl INTO g_fbm[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock fbm',SQLCA.sqlcode,0)   
                       LET l_lock_sw = "Y"
                   END IF
                END IF
            elsE
                LET l_flag = 'N'
            end IF
           #LET g_fbm_t.* = g_fbm[l_ac].*  #BACKUP
            IF l_ac <= l_n then                   #DISPLAY NEWEST
                CALL t111_fbm031(' ')
            end IF
           #nexT FIELD fbm02
 
        after iNSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              iNITIALIZE g_fbm[l_ac].* TO NULL  #重要欄位空白,無效
              dISPLAY g_fbm[l_ac].* TO s_fbm.*
              cALL g_fbm.deLETeElement(l_ac)
              rOLLBACK WORK
              eXIT INPUT
             #cANCEL INSERT
            end IF
            IF g_fbm[l_ac].fbm03 IS NOT NULL AND g_fbm[l_ac].fbm03 != ' ' THEN
               CALL t111_fbm031('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fbm[l_ac].fbm031,g_errno,0)
                  NEXT FIELD fbm02
               END IF
            end IF
            IF g_fbm[l_ac].fbm03 IS NULL OR
                g_fbm[l_ac].fbm031 IS NULL THEN
                INITIALIZE g_fbm[l_ac].* TO NULL
            end IF
            IF cl_null(g_fbm[l_ac].fbm04) THEN
               LET g_fbm[l_ac].fbm04 = ' '
            end IF
            IF cl_null(g_fbm[l_ac].fbm05) THEN
               LET g_fbm[l_ac].fbm05 = ' '
            end IF
            IF cl_null(g_fbm[l_ac].fbm06) THEN
               LET g_fbm[l_ac].fbm06 = ' '
            end IF
            #-----TQC-620120---------
            IF cl_null(g_fbm[l_ac].fbm031) THEN
               LET g_fbm[l_ac].fbm031 = ' '
            END IF
            #-----END TQC-620120-----
             INSERT INTO fbm_file(fbm01,fbm02,fbm03,fbm031,fbm04,fbm05,fbm06,  #No:BUG-470041 #No.MOD-470565
                                  #FUN-850068 --start--
                                  fbmud01,fbmud02,fbmud03,
                                  fbmud04,fbmud05,fbmud06,
                                  fbmud07,fbmud08,fbmud09,
                                  fbmud10,fbmud11,fbmud12,
                                  fbmud13,fbmud14,fbmud15,
                                  #FUN-850068 --end--
                                  fbmlegal)     #FUN-980003 add
                 VALUES(g_fbl.fbl01,g_fbm[l_ac].fbm02,g_fbm[l_ac].fbm03,
                        g_fbm[l_ac].fbm031,g_fbm[l_ac].fbm04,
                        g_fbm[l_ac].fbm05,g_fbm[l_ac].fbm06,
                        #FUN-850068 --start--
                        g_fbm[l_ac].fbmud01,g_fbm[l_ac].fbmud02,
                        g_fbm[l_ac].fbmud03,g_fbm[l_ac].fbmud04,
                        g_fbm[l_ac].fbmud05,g_fbm[l_ac].fbmud06,
                        g_fbm[l_ac].fbmud07,g_fbm[l_ac].fbmud08,
                        g_fbm[l_ac].fbmud09,g_fbm[l_ac].fbmud10,
                        g_fbm[l_ac].fbmud11,g_fbm[l_ac].fbmud12,
                        g_fbm[l_ac].fbmud13,g_fbm[l_ac].fbmud14,
                        g_fbm[l_ac].fbmud15,
                        #FUN-850068 --end--
                        g_legal)     #FUN-980003 add
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0  THEN
#              CALL cl_err('ins fbm',SQLCA.sqlcode,0)   #No.FUN-660136
               CALL cl_err3("ins","fbm_file",g_fbl.fbl01,g_fbm[l_ac].fbm02,SQLCA.SQLCODE,"","ins fbm",1)  #No.FUN-660136
              #LET g_fbm[l_ac].* = g_fbm_t.*
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET l_fbl07 = '0'   #FUN-580109
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        before INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd = 'a'
            iniTIALIZE g_fbm[l_ac].* TO NULL      #900423
            LET g_fbm_t.* = g_fbm[l_ac].*             #新輸入資料
            nexT FIELD fbm02
 
        before FIELD fbm02                            #defbllt 序號
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
               IF g_fbm[l_ac].fbm02 IS NULL OR g_fbm[l_ac].fbm02 = 0 THEN
                   SELECT max(fbm02)+1 INTO g_fbm[l_ac].fbm02
                      FROM fbm_file WHERE fbm01 = g_fbl.fbl01
                   IF g_fbm[l_ac].fbm02 IS NULL THEN
                       LET g_fbm[l_ac].fbm02 = 1
                   END IF
               END IF
            end IF
 
        AFTER FIELD fbm02                        #check 序號是否重複
            IF NOT cl_null(g_fbm[l_ac].fbm02) THEN
               IF g_fbm[l_ac].fbm02 != g_fbm_t.fbm02 OR
                  g_fbm_t.fbm02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM fbm_file
                    WHERE fbm01 = g_fbl.fbl01
                      AND fbm02 = g_fbm[l_ac].fbm02
                   IF l_n > 0 THEN
                       LET g_fbm[l_ac].fbm02 = g_fbm_t.fbm02
                       CALL cl_err('',-239,0)
                       NEXT FIELD fbm02
                   END IF
               END IF
            end IF
 
        AFTER FIELD fbm031
           IF g_fbm[l_ac].fbm031 IS NULL THEN
              lET g_fbm[l_ac].fbm031 = ' '
           end IF
           seleCT COUNT(*) INTO g_cnt FROM fca_file
            wheRE fca03  = g_fbm[l_ac].fbm03
              aND fca031 = g_fbm[l_ac].fbm031
              aND fca15  = 'N'
           IF g_cnt > 0 THEN
              cALL cl_err(g_fbm[l_ac].fbm03,'afa-097',0)
              nEXT FIELD fbm03
           end IF
           call t111_fbm031('a')
           IF nOT cl_null(g_errno) THEN
              cALL cl_err(g_fbm[l_ac].fbm031,g_errno,0)
              nEXT FIELD fbm03
           end IF
           LET g_fbm_t.fbm03  = g_fbm[l_ac].fbm03
           LET g_fbm_t.fbm031 = g_fbm[l_ac].fbm031
 
        AFTER FIELD fbm04
           IF nOT cl_null(g_fbm[l_ac].fbm04) THEN
              cALL t111_fbm04('a')
              iF NOT cl_null(g_errno) THEN
                 LET g_fbm[l_ac].fbm04 = g_fbm_t.fbm04
                 CALL cl_err(g_fbm[l_ac].fbm04,g_errno,0)
                 NEXT FIELD fbm04
              eND IF
          end iF
 
        AFTER FIELD fbm05
           IF nOT cl_null(g_fbm[l_ac].fbm05) THEN
              cALL t111_fbm05('a')
              iF NOT cl_null(g_errno) THEN
                  LET g_fbm[l_ac].fbm05 = g_fbm_t.fbm05
                  CALL cl_err(g_fbm[l_ac].fbm05,g_errno,0)
                  NEXT FIELD fbm05
              eND IF
           end IF
 
        AFTER FIELD fbm06
           IF nOT cl_null(g_fbm[l_ac].fbm06) THEN
              cALL t111_fbm06('a')
              iF NOT cl_null(g_errno) THEN
                 LET g_fbm[l_ac].fbm06 = g_fbm_t.fbm06
                 CALL cl_err(g_fbm[l_ac].fbm06,g_errno,0)
                 NEXT FIELD fbm06
              eND IF
           end IF
           DISPLAY BY NAME g_fbm[l_ac].fbm06   #MOD-7B0250
 
        #No.FUN-850068 --start--
        AFTER FIELD fbmud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbmud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbmud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbmud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbmud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbmud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbmud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbmud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbmud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbmud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbmud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbmud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbmud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbmud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbmud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-850068 ---end---
 
        before DELETE                            #是否取消單身
            IF g_fbm_t.fbm02 > 0 AND g_fbm_t.fbm02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                     ROLLBACK WORK
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM fbm_file
                 WHERE fbm01 = g_fbl.fbl01
                   AND fbm02 = g_fbm_t.fbm02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_fbm_t.fbm02,SQLCA.sqlcode,0)   #No.FUN-660136
                    CALL cl_err3("del","fbm_file",g_fbl.fbl01,g_fbm_t.fbm02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET l_fbl07 = '0'   #FUN-580109
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            end IF
 
        on row CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbm[l_ac].* = g_fbm_t.*
               CLOSE t111_bcl
               ROLLBACK WORK
               EXIT INPUT
            end IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fbm[l_ac].fbm02,-263,1)
               LET g_fbm[l_ac].* = g_fbm_t.*
            elsE
               IF g_fbm[l_ac].fbm03 IS NOT NULL AND g_fbm[l_ac].fbm03 != ' ' THEN
                  CALL t111_fbm031('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_fbm[l_ac].fbm031,g_errno,0)
                     NEXT FIELD fbm02
                  END IF
               END IF
               IF g_fbm[l_ac].fbm03 IS NULL OR
                  g_fbm[l_ac].fbm031 IS NULL THEN
                  INITIALIZE g_fbm[l_ac].* TO NULL
               END IF
               IF cl_null(g_fbm[l_ac].fbm04) THEN
                  LET g_fbm[l_ac].fbm04 = ' '
               END IF
               IF cl_null(g_fbm[l_ac].fbm05) THEN
                  LET g_fbm[l_ac].fbm05 = ' '
               END IF
               IF cl_null(g_fbm[l_ac].fbm06) THEN
                  LET g_fbm[l_ac].fbm06 = ' '
               END IF
               UPDATE fbm_file SET
                      fbm01=g_fbl.fbl01,fbm02=g_fbm[l_ac].fbm02,
                      fbm03=g_fbm[l_ac].fbm03,fbm031=g_fbm[l_ac].fbm031,
                      fbm04=g_fbm[l_ac].fbm04,fbm05=g_fbm[l_ac].fbm05,
                      fbm06=g_fbm[l_ac].fbm06,
                      #FUN-850068 --start--
                      fbmud01 = g_fbm[l_ac].fbmud01,
                      fbmud02 = g_fbm[l_ac].fbmud02,
                      fbmud03 = g_fbm[l_ac].fbmud03,
                      fbmud04 = g_fbm[l_ac].fbmud04,
                      fbmud05 = g_fbm[l_ac].fbmud05,
                      fbmud06 = g_fbm[l_ac].fbmud06,
                      fbmud07 = g_fbm[l_ac].fbmud07,
                      fbmud08 = g_fbm[l_ac].fbmud08,
                      fbmud09 = g_fbm[l_ac].fbmud09,
                      fbmud10 = g_fbm[l_ac].fbmud10,
                      fbmud11 = g_fbm[l_ac].fbmud11,
                      fbmud12 = g_fbm[l_ac].fbmud12,
                      fbmud13 = g_fbm[l_ac].fbmud13,
                      fbmud14 = g_fbm[l_ac].fbmud14,
                      fbmud15 = g_fbm[l_ac].fbmud15
                      #FUN-850068 --end-- 
               WHERE fbm01=g_fbl.fbl01 AND fbm02=g_fbm_t.fbm02
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#                 CALL cl_err('upd fbm',SQLCA.sqlcode,0)   #No.FUN-660136
                  CALL cl_err3("upd","fbm_file",g_fbl.fbl01,g_fbm_t.fbm02,SQLCA.sqlcode,"","upd fbm",1)  #No.FUN-660136
                  LET g_fbm[l_ac].* = g_fbm_t.*
                  DISPLAY g_fbm[l_ac].* TO s_fbm[l_sl].*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  LET l_fbl07 = '0'   #FUN-580109
                  COMMIT WORK
               END IF
            end IF
 
        after rOW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_fbm[l_ac].* = g_fbm_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_fbm.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE t111_bcl
               ROLLBACK WORK
               EXIT INPUT
            end IF
            LET l_ac_t = l_ac  #FUN-D30032 add
           #LET g_fbm_t.* = g_fbm[l_ac].*  #FUN-D30032 mark
            cloSE t111_bcl
            comMIT WORK
            #ckP2
           #calL g_fbm.deLETeElement(g_rec_b+1) #FUN-D30032 mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fbm02) AND l_ac > 1 THEN
                LET g_fbm[l_ac].* = g_fbm[l_ac-1].*
                LET g_fbm[l_ac].fbm02 = NULL
                NEXT FIELD fbm02
            end IF
        ON ACTION controlp
           case
              wHEN INFIELD(fbm03)  #財產編號,財產附號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_faj"
                   LET g_qryparam.default1 = g_fbm[l_ac].fbm03
                   LET g_qryparam.default2 = g_fbm[l_ac].fbm031
                   CALL cl_create_qry() RETURNING g_fbm[l_ac].fbm03,g_fbm[l_ac].fbm031
#                   CALL FGL_DIALOG_SETBUFFER( g_fbm[l_ac].fbm03 )
#                   CALL FGL_DIALOG_SETBUFFER( g_fbm[l_ac].fbm031 )
                   DISPLAY g_fbm[l_ac].fbm03,g_fbm[l_ac].fbm031 TO
                           s_fbm[l_sl].fbm03,s_fbm[l_sl].fbm031
                   CALL t111_fbm031('d')
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err(' ',g_errno,0)
                         NEXT FIELD fbm03
                      END IF
                   NEXT FIELD fbm03
              wHEN INFIELD(fbm04)  #保管人員
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gen"
                   LET g_qryparam.default1 =g_fbm[l_ac].fbm04
                   CALL cl_create_qry() RETURNING g_fbm[l_ac].fbm04
#                   CALL FGL_DIALOG_SETBUFFER( g_fbm[l_ac].fbm04 )
                   DISPLAY g_fbm[l_ac].fbm04 TO s_fbm[l_sl].fbm04
                   NEXT FIELD fbm04
              wHEN INFIELD(fbm05)  #保管部門
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem"
                   LET g_qryparam.default1 = g_fbm[l_ac].fbm05
                   CALL cl_create_qry() RETURNING g_fbm[l_ac].fbm05
#                   CALL FGL_DIALOG_SETBUFFER( g_fbm[l_ac].fbm05 )
                   DISPLAY g_fbm[l_ac].fbm05 TO s_fbm[l_sl].fbm05
                   NEXT FIELD fbm05
              wHEN INFIELD(fbm06)  #存放位置
                   CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_faf3"       #No:7292   #MOD-530200
                   LET g_qryparam.arg1 = g_fbm[l_ac].faj22 CLIPPED
                   LET g_qryparam.default1 = g_fbm[l_ac].fbm06
                   CALL cl_create_qry() RETURNING g_fbm[l_ac].fbm06
#                   CALL FGL_DIALOG_SETBUFFER( g_fbm[l_ac].fbm06 )
                   DISPLAY g_fbm[l_ac].fbm06 TO s_fbm[l_sl].fbm06
                   NEXT FIELD fbm06
              oTHERWISE
                 EXIT CASE
           end CASE
 
        ON ACTION CONTROLF
         call cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         call cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           call cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
         on idlE g_idle_seconds
            calL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
     
            conTINUE INPUT
#No.FUN-6B0029--BEGIN                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
      end input
 
     #start FUN-580109
      UPDATE fbl_file SET fbl07=l_fbl07 WHERE fbl01 = g_fbl.fbl01
      LET g_fbl.fbl07 = l_fbl07
      DISPLAY BY NAME g_fbl.fbl07
      IF g_fbl.fblconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
      IF g_fbl.fbl07 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
      CALL cl_set_field_pic(g_fbl.fblconf,g_chr2,g_fbl.fblpost,"",g_chr,"")
     #end FUN-580109
 
      IF p_cmd = 'u' THEN CLOSE t111_bcl END IF
      COMMIT WORK
      CALL t111_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- BEGIN
FUNCTION t111_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---BEGIN
      CALL s_get_doc_no(g_fbl.fbl01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fbl_file ",
                  "  WHERE fbl01 LIKE '",l_slip,"%' ",
                  "    AND fbl01 > '",g_fbl.fbl01,"'"
      PREPARE t111_pb1 FROM l_sql 
      EXECUTE t111_pb1 INTO l_cnt 
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'deLETe'
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
        #CALL t111_x()            #FUN-D20035
         CALL t111_x(1)           #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fbl_file WHERE fbl01 = g_fbl.fbl01
         INITIALIZE g_fbl.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t111_fbm031(p_cmd)
DEFIne   p_cmd       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_n         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
         l_faj06     LIKE faj_file.faj06,
         l_faj19     LIKE faj_file.faj19,
         l_faj20     LIKE faj_file.faj20,
         l_faj21     LIKE faj_file.faj21,
         l_faj22     LIKE faj_file.faj22,
         l_faj43     LIKE faj_file.faj43
DEFINE   l_faj432    LIKE faj_file.faj432        #FUN-AB0088
 
    LET g_errno = ' '
    #CHI-B80007 -- BEGIN --
    SELECT count(*) INTO l_n FROM fbm_file,fbl_file
      WHERE fbm01 = fbl01
       AND fbm03  = g_fbm[l_ac].fbm03
       AND fbm031 = g_fbm[l_ac].fbm031
       AND fbl02 <= g_fbl.fbl02
       AND fblpost = 'N'
       AND fbl01 != g_fbl.fbl01
       AND fblconf <> 'X'
    IF l_n  > 0 THEN
       LET g_errno = 'afa-309'
       RETURN
    END IF
    #CHI-B80007 -- end --
    SELECT faj06,faj19,faj20,faj21,faj22,faj43,faj432                  #FUN-AB0088 add faj432
      INTO l_faj06,l_faj19,l_faj20,l_faj21,l_faj22,l_faj43,l_faj432    #FUN-AB0088 add l_faj432
      FROM faj_file
     WHERE faj02  = g_fbm[l_ac].fbm03
       AND faj022 = g_fbm[l_ac].fbm031
       AND fajconf = 'Y'
    CASE
      #WHEN SQLCA.SQLCODE = 100        LET g_errno = 'afa-093'    #MOD-C70265 mark
       WHEN SQLCA.SQLCODE = 100        LET g_errno = 'afa-134'    #MOD-C70265 add
       WHEN l_faj43 MATCHES '[056X]'   LET g_errno = 'afa-093'
       WHEN l_faj432 MATCHES '[056X]' AND g_faa.faa31 ='Y'    #MOD-B60256
            LET g_errno = 'afa-093'   #FUN-AB0088
       OTHERWISE                      LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'a' OR p_cmd = 'u'  THEN
       IF cl_null(g_fbm[l_ac].fbm04) THEN   #MOD-B30187 add
          LET g_fbm[l_ac].fbm04 = l_faj19
       END IF                               #MOD-B30187 add
       IF cl_null(g_fbm[l_ac].fbm05) THEN   #MOD-B30187 add
          LET g_fbm[l_ac].fbm05 = l_faj20
       END IF                               #MOD-B30187 add
       IF cl_null(g_fbm[l_ac].fbm06) THEN
          LET g_fbm[l_ac].fbm06 = l_faj21
       END IF
       DISPLAY g_fbm[l_ac].fbm04 TO fbm04
       DISPLAY g_fbm[l_ac].fbm05 TO fbm05
       DISPLAY g_fbm[l_ac].fbm06 TO fbm06
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_fbm[l_ac].faj06 = l_faj06
       LET g_fbm[l_ac].faj22 = l_faj22
       DISPLAY g_fbm[l_ac].faj06 TO faj06
       DISPLAY g_fbm[l_ac].faj22 TO faj22
    END IF
END FUNCTION
 
 
FUNCTION t111_fbm04(p_cmd)
DEFIne
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_gen01    LIKE gen_file.gen01,
      l_gen03    LIKE gen_file.gen03,         #MOD-960143 
      l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
#   SELECT gen01,genacti INTO l_gen01,l_genacti   #MOD-960143
    SELECT gen01,gen03,genacti INTO l_gen01,l_gen03,l_genacti  #MOD-960143 
      FROM gen_file
     WHERE gen01 = g_fbm[l_ac].fbm04
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gen01 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'     LET g_errno = '9028'
       OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #darcy:2023/01/11 mark s---
    # 财务需求，保管人不带出保管部门
    #IF cl_null(g_fbm[l_ac].fbm05) THEN   #MOD-B30187 add
    #   LET g_fbm[l_ac].fbm05 = l_gen03   #MOD-960143                                                                                    
    #END IF                               #MOD-B30187 add
    #DISPLAY BY NAME g_fbm[l_ac].fbm05    #MOD-960143
    #darcy:2023/01/11 mark e---
END FUNCTION
 
 
FUNCTION t111_fbm05(p_cmd)
DEFIne
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_gem01    LIKE gem_file.gem01,
      l_gemacti  LIKE gem_file.gemacti
 
    LET g_errno = ' '
    select gem01,gemacti INTO l_gem01,l_gemacti
      from gem_file
     where gem01 = g_fbm[l_ac].fbm05
    case
       WHEN sqlCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gem01 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N'  LET g_errno = '9028'
       otherwisE             LET g_errno = SQLCA.SQLCODE USING '-------'
    end case
END FUNCTION
 
FUNCTION t111_fbm06(p_cmd)
DEFIne
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_faf01    LIKE faf_file.faf01,
      l_faf03    LIKE faf_file.faf03,
      l_fafacti  LIKE faf_file.fafacti
 
     LET g_errno = ' '
     select faf01,faf03,fafacti INTO l_faf01,l_faf03,l_fafacti
       from faf_file
      where faf01 = g_fbm[l_ac].fbm06
     case
       WHEN sqlCA.SQLCODE = 100 LET g_errno = 'afa-039'
                                LET l_faf01 = NULL
                                LET l_faf03 = NULL
                                LET l_fafacti = NULL
       WHEN l_fafacti = 'N'  LET g_errno = '9028'
       otherwisE             LET g_errno = SQLCA.SQLCODE USING '-------'
    end case
END FUNCTION
 
FUNCTION t111_b_askkey()
DEFIne l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    construct l_wc2 ON fbm02,fbm03,fbm031,fbm04,fbm05,faj22,fbm06,faj06
                       #No.FUN-850068 --start--
                       ,fbmud01,fbmud02,fbmud03,fbmud04,fbmud05
                       ,fbmud06,fbmud07,fbmud08,fbmud09,fbmud10
                       ,fbmud11,fbmud12,fbmud13,fbmud14,fbmud15
                       #No.FUN-850068 ---end---
         from s_fbm[1].fbm02, s_fbm[1].fbm03,s_fbm[1].fbm031,s_fbm[1].fbm04,
              s_fbm[1].fbm05,s_fbm[1].faj22,s_fbm[1].fbm06,s_fbm[1].faj06
              #No.FUN-850068 --start--
              ,s_fbm[1].fbmud01,s_fbm[1].fbmud02,s_fbm[1].fbmud03
              ,s_fbm[1].fbmud04,s_fbm[1].fbmud05,s_fbm[1].fbmud06
              ,s_fbm[1].fbmud07,s_fbm[1].fbmud08,s_fbm[1].fbmud09
              ,s_fbm[1].fbmud10,s_fbm[1].fbmud11,s_fbm[1].fbmud12
              ,s_fbm[1].fbmud13,s_fbm[1].fbmud14,s_fbm[1].fbmud15
              #No.FUN-850068 ---end---
       on idle g_idle_seconds
          call cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
          contiNUE CONSTRUCT
 
    end construCT
    IF int_flag THEN
       LET int_FLAG = 0
       return
    end IF
    call t111_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t111_b_fill(p_wc2)              #BODY FILL UP
DEFIne p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
        " selecT fbm02,fbm03,fbm031,faj06,fbm04,fbm05,faj22,fbm06, ",
        #No.FUN-850068 --start--
        "        fbmud01,fbmud02,fbmud03,fbmud04,fbmud05,",
        "        fbmud06,fbmud07,fbmud08,fbmud09,fbmud10,",
        "        fbmud11,fbmud12,fbmud13,fbmud14,fbmud15 ", 
        #No.FUN-850068 ---end---
        "   froM fbm_file, faj_file ",
        "  wherE fbm01  ='",g_fbl.fbl01,"'",  #單頭
        "    anD fbm03  = faj02",
        "    anD fbm031 = faj022",
        "    anD ",p_wc2 CLIPPED,                     #單身
        "  ordeR BY 1"
 
    prepare t111_pb FROM g_sql
    declare fbm_curs                       #SCROLL CURSOR
        cursor FOR t111_pb
 
    call g_fbm.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    foreach fbm_curs INTO g_fbm[g_cnt].*   #單身 ARRAY 填充
        IF statUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         call cl_err( '', 9035, 0 )
	 exit fOREACH
      end IF
      # genero shell add g_max_rec check END
    end foreach
    call g_fbm.deLETeElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    display g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t111_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 CHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fbm TO s_fbm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()    #TQC-B60194 add
 
      ##########################################################################
      # standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         exit dISPLAY
      ON ACTION query
         LET g_action_choice="query"
         exit dISPLAY
      ON ACTION deLETe
         LET g_action_choice="deLETe"
         exit dISPLAY
      ON ACTION modIFy
         LET g_action_choice="modIFy"
         exit dISPLAY
      ON ACTION first
         call t111_fetch('F')
         call cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         call fgl_set_arr_curr(1)  ######add in 040505
           end IF
 
 
      ON ACTION previous
         call t111_fetch('P')
         call cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         call fgl_set_arr_curr(1)  ######add in 040505
           end IF
 
 
      ON ACTION jump
         call t111_fetch('/')
         call cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         call fgl_set_arr_curr(1)  ######add in 040505
           end IF
 
 
      ON ACTION next
         call t111_fetch('N')
         call cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         call fgl_set_arr_curr(1)  ######add in 040505
           end IF
 
 
      ON ACTION last
         call t111_fetch('L')
         call cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         call fgl_set_arr_curr(1)  ######add in 040505
           end IF
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         exit dISPLAY

      #FUN-9A0059 --------------------add start---------------------
      ON ACTION output                                                          
         LET g_action_choice="output"                                           
         EXIT DISPLAY
      #FUN-9A0059 --------------------add end------------------------

      ON ACTION help
         LET g_action_choice="help"
         exit dISPLAY
 
      ON ACTION locale
         call cl_dynamic_locale()
         #ckp
         IF g_fbl.fblconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        #start FUN-580109
         IF g_fbl.fbl07 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        #CALL cl_set_field_pic(g_fbl.fblconf,"",g_fbl.fblpost,"",g_chr,"")
         CALL cl_set_field_pic(g_fbl.fblconf,g_chr2,g_fbl.fblpost,"",g_chr,"")
        #end FUN-580109
 
      ON ACTION exit
         LET g_action_choice="exit"
         exit dISPLAY
 
      ##########################################################################
      # special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         exit dISPLAY
      #@ON ACTION 自動產生
      ON ACTION auto_generate
         LET g_action_choice="auto_generate"
         exit dISPLAY
      #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         exit dISPLAY

      #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add--end

      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         exit dISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         exit dISPLAY
      #@ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         exit dISPLAY
      #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         exit dISPLAY
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         exit dISPLAY
 
   On action accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      exit dispLAY
 
   On action cancel
      LET g_action_choice="exit"
      exit dispLAY
 
      on idle g_idle_seconds
         call cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
         continUE DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
#start FUN-580109
     ON ACTION easyflow_approval
        LET g_action_choice = 'easyflow_approval'
        EXIT DISPLAY
 
     ON ACTION approval_status
        LET g_action_choice="approval_status"
        EXIT DISPLAY
 
     ON ACTION agree
        LET g_action_choice = 'agree'
        EXIT DISPLAY
 
     ON ACTION deny
        LET g_action_choice = 'deny'
        EXIT DISPLAY
 
     ON ACTION modIFy_flow
        LET g_action_choice = 'modIFy_flow'
        EXIT DISPLAY
 
     ON ACTION withdraw
        LET g_action_choice = 'withdraw'
        EXIT DISPLAY
 
     ON ACTION org_withdraw
        LET g_action_choice = 'org_withdraw'
        EXIT DISPLAY
 
     ON ACTION phrase
        LET g_action_choice = 'phrase'
        EXIT DISPLAY
#end FUN-580109
 
#No.FUN-6B0029--BEGIN                                             
     ON ACTION controls                                        
        CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
      #FUN-810046
      &include "qry_string.4gl"
 
   END DISPLAY
   Call cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION t111_bp_refresh()
   Display arraY g_fbm TO s_fbm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      before diSPLAY
         exit dISPLAY
      on idle g_idle_seconds
         call cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         continUE DISPLAY
 
   End display
END FUNCTION
 
#---自動產生-------
FUNCTION t111_g()
 DEFine ls_tmp STRING
 DEFine  l_wc        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(300)
         l_sql       LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(800)
         tm          RECORD
               a         LIKE faj_file.faj19,
               b         LIKE faj_file.faj20,
               d         LIKE faj_file.faj21
               END RECORD,
         l_faj       RECORD
               faj02     LIKE faj_file.faj02,
               faj022    LIKE faj_file.faj022,
               faj19     LIKE faj_file.faj19,
               faj20     LIKE faj_file.faj20,
               faj21     LIKE faj_file.faj21
               END RECORD,
         ans         LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_gen02     LIKE gen_file.gen02,
         l_gem01     LIKE gem_file.gem01,
         l_gem02     LIKE gem_file.gem02,
         l_faf02     LIKE faf_file.faf02,
         l_fbi02     LIKE fbi_file.fbi02,
         l_cnt       LIKE type_file.num5,        #CHI-B80007 add
         i           LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbl.fbl01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fbl.fblconf='X' THEN CALL cl_err(g_fbl.fbl01,'9024',0) RETURN END IF
   IF g_fbl.fblconf='Y' THEN CALL cl_err(g_fbl.fbl01,'afa-107',0) RETURN END IF
    IF not cl_confirm('afa-103') THEN RETURN END IF     #No.MOD-490235
      LET int_fLAG = 0
 
  # call cl_getmsg('afa-103',g_lang) RETURNING g_msg
  #          leT INT_FLAG = 0  ######add for prompt bug
  # prompt g_msg CLIPPED ,': ' FOR ans
  #    on idle g_idle_seconds
  #       call cl_on_idle()
 
   #   ON ACTION about         #MOD-4C0121
   #      CALL cl_about()      #MOD-4C0121
 
   #   ON ACTION help          #MOD-4C0121
   #      CALL cl_show_help()  #MOD-4C0121
 
   #   ON ACTION controlg      #MOD-4C0121
   #      CALL cl_cmdask()     #MOD-4C0121
 
  #        contINUE PROMPT
  # end prompt
  #---------詢問是否自動新增單身--------------
  # IF ans matcHES  '[yY]' THEN
      LET p_row = 4 LET p_col = 10
      open windOW t111_w2 AT p_row,p_col WITH FORM "afa/42f/afat1112"
           attrIBUTE (STYLE = g_win_style)
 
      call cl_ui_locale("afat1112")
 
     #construct l_wc ON faj01,faj02,faj022,faj19,faj20,faj22,faj21        #No.FUN-B50118 mark
     #             FROM faj01,faj02,faj022,faj19,faj20,faj22,faj21        #No.FUN-B50118 mark
      CONSTRUCT l_wc ON faj01,faj93,faj02,faj022,faj19,faj20,faj22,faj21  #No.FUN-B50118 add
                   FROM faj01,faj93,faj02,faj022,faj19,faj20,faj22,faj21  #No.FUN-B50118 add
         on idlE g_idle_seconds
            calL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            conTINUE CONSTRUCT
 
      end constRUCT
     #No.TQC-760182--BEGIN--
      IF l_wc = " 1=1" THEN
         CALL cl_err('','abm-997',1)
         LET INT_FLAG = 1
      END IF
     #No.TQC-760182--end--
      IF int_flAG THEN LET INT_FLAG = 0 CLOSE WINDOW t111_w2 RETURN END IF
      input by NAME tm.a,tm.b,tm.d
            witHOUT DEFAULTS
         after FIELD a    #-->保管人
            IF NOT cl_null(tm.a) THEN
               SELECT gen02 INTO l_gen02 FROM gen_file
                           WHERE gen01 = tm.a AND genacti = 'Y'
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(tm.a,'afa-034',0)   #No.FUN-660136
                  CALL cl_err3("sel","gen_file",tm.a,"","afa-034","","",1)  #No.FUN-660136
                  DISPLAY l_gen02 TO FORMONLY.gen02
                  NEXT FIELD a
               END IF
                  DISPLAY l_gen02 TO FORMONLY.gen02
            end IF
 #MOD-530567
            SELECT gen03 INTO l_gem01 FROM gen_file
                   WHERE gen01 = tm.a
            LET tm.b = l_gem01
 #END MOD-530567
         after FIELD b    #-->保管部門
            IF NOT cl_null(tm.b) THEN
               SELECT gem02 INTO l_gem02 FROM gem_file
                           WHERE gem01 = tm.b AND gemacti = 'Y'
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(tm.a,'afa-038',0)   #No.FUN-660136
                  CALL cl_err3("sel","gem_file",tm.b,"","afa-038","","",1)  #No.FUN-660136
                  LET l_gem02 = ' '
                  DISPLAY l_gem02 TO FORMONLY.gem02
                  NEXT FIELD b
               END IF
               DISPLAY l_gem02 TO FORMONLY.gem02
            elsE NEXT FIELD d
            end IF
 
         after FIELD d    #-->存放位置
            IF NOT cl_null(tm.d) THEN
               SELECT faf02 INTO l_faf02  FROM faf_file
                           WHERE faf01 = tm.d AND fafacti = 'Y'
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(tm.d,'afa-039',0)   #No.FUN-660136
                  CALL cl_err3("sel","faf_file",tm.d,"","afa-039","","",1)  #No.FUN-660136
                  LET l_faf02 = ' '
                  DISPLAY l_faf02 TO FORMONLY.faf02
                  NEXT FIELD d
               END IF
               DISPLAY l_faf02 TO FORMONLY.faf02
            end IF
        ON ACTION controlp      #ok
           case
            WHEN INFIELD(a)   #保管人
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = tm.a
                 CALL cl_create_qry() RETURNING tm.a
#                 CALL FGL_DIALOG_SETBUFFER( tm.a )
                 DISPLAY tm.a TO FORMONLY.a
                 NEXT FIELD a
            WHEN INFIELD(b)   #保管部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = tm.b
                 CALL cl_create_qry() RETURNING tm.b
#                 CALL FGL_DIALOG_SETBUFFER( tm.b )
                 DISPLAY tm.b TO FORMONLY.b
                 NEXT FIELD b
            WHEN INFIELD(d)   #存放位置
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faf"
                 LET g_qryparam.default1 = tm.d
                 CALL cl_create_qry() RETURNING tm.d
#                 CALL FGL_DIALOG_SETBUFFER( tm.d )
                 DISPLAY tm.d TO FORMONLY.d
                 NEXT FIELD d
           end CASE
        on idle g_idle_seconds
           call cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
           contINUE INPUT
 
     end input
     IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t111_w2 RETURN END IF   #No.MOD-8B0150 add close window
     #------自動產生------
      BEGIN worK
      LET l_sql ="SELECT faj02,faj022,faj19,faj20,faj21",
                 "  FROM faj_file",
                 " WHERE faj43 NOT IN ('0','5','6','X')",
                #" WHERE faj432 NOT IN ('0','5','6','X')",   #FUN-AB0088 add  #TQC-B60072
                #"   AND faj432 NOT IN ('0','5','6','X')",    #TQC-B60072 #MOD-C80140 mark
                 "   AND fajconf = 'Y' ",
                 "   AND ",l_wc CLIPPED,
                 " ORDER BY 1"
     prepare t111_prepare_g FROM l_sql
     IF sqlca.sQLCODE != 0 THEN
        call cl_err('prepare:',SQLCA.sqlcode,0)
        rollbacK WORK RETURN
     end IF
     declare t111_curs2 CURSOR FOR t111_prepare_g
 
     select max(fbm02)+1 INTO i FROM fbm_file WHERE fbm01 = g_fbl.fbl01
     IF cl_null(i) THEN LET i = 1 END IF
     foreach t111_curs2 INTO l_faj.*
       IF sqlca.sqlcode != 0 THEN
          call cl_err('foreach:',SQLCA.sqlcode,0)
          exit FOREACH
       end IF
       #no:4532檢查資產盤點期間應不可做異動
       select cOUNT(*) INTO g_cnt FROM fca_file
        where fca03  = l_faj.faj02
          and fca031 = l_faj.faj022
          and fca15  = 'N'
           IF g_cnt > 0 THEN
              cONTINUE FOREACH
           end IF
       #no:4532
       #CHI-B80007 -- BEGIN --
       SELECT count(*) INTO l_cnt FROM fbm_file,fbl_file
         WHERE fbm01 = fbl01
          AND fbm03  = l_faj.faj02
          AND fbm031 = l_faj.faj022
          AND fbl02 <= g_fbl.fbl02
          AND fblpost = 'N'
          AND fbl01 != g_fbl.fbl01
          AND fblconf <> 'X'
       IF l_cnt > 0 THEN
          CONTINUE FOREACH
       END IF
       #CHI-B80007 -- end --
       IF not cl_null(tm.a) THEN LET l_faj.faj19 = tm.a END IF
       IF not cl_null(tm.b) THEN LET l_faj.faj20 = tm.b END IF
       IF not cl_null(tm.d) THEN LET l_faj.faj21 = tm.d END IF
       IF cl_null(l_faj.faj022) THEN LET l_faj.faj022 = ' ' END IF   #TQC-620120
        INSERT INTO fbm_file(fbm01,fbm02,fbm03,fbm031,fbm04,fbm05,fbm06,fbmlegal)  #No:BUG-470041 #No.MOD-470565 #FUN-980003 add
            VALUES (g_fbl.fbl01,i,l_faj.faj02,l_faj.faj022,l_faj.faj19,
                    l_faj.faj20,l_faj.faj21,g_legal)   #FUN-980003 add
              iF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#                CALL cl_err('ins fbm',STATUS,0)   #No.FUN-660136
                 CALL cl_err3("ins","fbm_file",g_fbl.fbl01,i,SQLCA.SQLCODE,"","ins fbm",1)  #No.FUN-660136
                 ROLLBACK WORK
                 CLOSE WINDOW t111_w2  #No.MOD-8B0150
                 RETURN
              eND IF
              lET i = i + 1
     end foreacH
     close windOW t111_w2
     commit worK
     call t111_b_fill(l_wc)
  #End IF
END FUNCTION
 
FUNCTION t111_y()
  DEfine l_bdate,l_edate        LIKE type_file.dat          #No.FUN-680070 DATE
  DEfine l_flag                 LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
  DEfine l_cnt                  LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
   Select * intO g_fbl.* FROM fbl_file WHERE fbl01 = g_fbl.fbl01
   IF g_fbl.fblconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_fbl.fblconf='Y' THEN RETURN END IF
   #bugno:7341 add......................................................
   Select count(*) INTO l_cnt FROM fbm_file
    where fbm01= g_fbl.fbl01
   IF l_cnt = 0 THEN
      call cl_err('','mfg-009',0)
      return
   End IF
   #bugno:7341 end......................................................
   #-->折舊年月判斷
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)   
       RETURNING g_flag,g_bookno1,g_bookno2
   #-----No:FUN-B60140-----
   LET g_bookno2 = g_faa.faa02c
   #IF g_aza.aza63 = 'Y' THEN
   #   CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
   #ELSE
       CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   #END IF
   #-----No:FUN-B60140 END-----
   #CHI-A60036 add --end--
   IF g_fbl.fbl02 < l_bdate THEN
      call cl_err(g_fbl.fbl02,'afa-308',0)
      return
   End IF
   #FUN-B50090 add BEGIN-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期小於關帳日期
   IF g_fbl.fbl02 < g_faa.faa09 THEN
      call cl_err(g_fbl.fbl01,'aap-176',1) RETURN
   END IF

   #-----No:FUN-B60140-----
   IF g_faa.faa31 = "Y" THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate
      IF g_fbl.fbl02 < l_bdate THEN
         CALL cl_err(g_fbl.fbl02,'afa-308',0)
         RETURN
      END IF
      #-->立帳日期小於關帳日期
      IF g_fbl.fbl02 < g_faa.faa092 THEN
         CALL cl_err(g_fbl.fbl01,'aap-176',1) RETURN
      END IF
   END IF
   #-----No:FUN-B60140 END-----
   IF not cl_confirm('axm-108') THEN RETURN END IF
   Begin WORK
 
   Open t111_cl USING g_fbl.fbl01
   IF status thEN
      call cl_err("OPEN t111_cl:", STATUS, 1)
      close t111_cl
      rollback WORK
      return
   End IF
   Fetch t111_cl INTO g_fbl.*          # 鎖住將被更改或取消的資料
   IF sqlca.sqlcode THEN
       call cl_err(g_fbl.fbl01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       close t111_cl ROLLBACK WORK RETURN
   End IF
   Let g_success = 'Y'
   Update fbl_file SET fblconf = 'Y' WHERE fbl01 = g_fbl.fbl01
       IF statuS OR SQLCA.sqlerrd[3] = 0 THEN
#         call cl_err('upd fblconf',STATUS,0)   #No.FUN-660136
          CALL cl_err3("upd","fbl_file",g_fbl.fbl01,"",SQLCA.SQLCODE,"","upd fblconf",1)  #No.FUN-660136
          LET g_success = 'N'
       end IF
       close t111_cl
       IF g_success = 'Y' THEN
          LET g_fbl.fblconf='Y'
          commiT WORK
          displAY BY NAME g_fbl.fblconf
          call cl_flow_notIFy(g_fbl.fbl01,'Y')
       ELSE
          LET g_fbl.fblconf='N'
          rollbACK WORK
       end IF
    IF g_fbl.fblconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   #start FUN-580109
    IF g_fbl.fbl07 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   #CALL cl_set_field_pic(g_fbl.fblconf,"",g_fbl.fblpost,"",g_chr,"")
    CALL cl_set_field_pic(g_fbl.fblconf,g_chr2,g_fbl.fblpost,"",g_chr,"")
   #end FUN-580109
END FUNCTION
 
#start FUN-580109
FUNCTION t111_y_chk()
  DEFINE l_bdate,l_edate        LIKE type_file.dat          #No.FUN-680070 DATE
  DEFINE l_flag                 LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
  DEFINE l_cnt                  LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
  LET g_success = 'Y'   #FUN-580109
 
  SELECT * intO g_fbl.* FROM fbl_file WHERE fbl01 = g_fbl.fbl01
  IF g_fbl.fblconf='X' THEN
     LET g_success = 'N'   #FUN-580109
     CALL cl_err('','9024',0)
     RETURN
  END IF
  IF g_fbl.fblconf='Y' THEN
     LET g_success = 'N'        #FUN-580109
     CALL cl_err('','9023',0)   #FUN-580109
     RETURN
  END IF
  #MODNO:7341 add......................................................
  SELECT count(*) INTO l_cnt FROM fbm_file
   WHERE fbm01= g_fbl.fbl01
  IF l_cnt = 0 THEN
     LET g_success = 'N'   #FUN-580109
     CALL cl_err('','mfg-009',0)
     RETURN
  END IF
  #MODNO:7341 END......................................................
  #-->折舊年月判斷
  #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
  #CHI-A60036 add --start--
  CALL s_get_bookno(g_faa.faa07)   
      RETURNING g_flag,g_bookno1,g_bookno2
  #-----No:FUN-B60140-----
  LET g_bookno2 = g_faa.faa02c
  #IF g_aza.aza63 = 'Y' THEN
  #   CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
  #ELSE
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
  #END IF
  ##-----No:FUN-B60140 END-----
  #CHI-A60036 add --end--
  IF g_fbl.fbl02 < l_bdate THEN
     LET g_success = 'N'   #FUN-580109
     CALL cl_err(g_fbl.fbl02,'afa-308',0)
     RETURN
  END IF
  #FUN-B50090 add BEGIN-------------------------
  #重新抓取關帳日期
  SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
  #FUN-B50090 add -end--------------------------
  #-->立帳日期小於關帳日期
  IF g_fbl.fbl02 < g_faa.faa09 THEN
     LET g_success = 'N'   #FUN-580109
     CALL cl_err(g_fbl.fbl01,'aap-176',1)
     RETURN
  END IF

  #-----No:FUN-B60140-----
  IF g_faa.faa31 = 'Y' THEN
     CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate
     IF g_fbl.fbl02 < l_bdate THEN
        LET g_success = 'N'
        CALL cl_err(g_fbl.fbl02,'afa-308',0)
        RETURN
     END IF
     #-->立帳日期小於關帳日期
     IF g_fbl.fbl02 < g_faa.faa092 THEN
        LET g_success = 'N'
        CALL cl_err(g_fbl.fbl01,'aap-176',1)
        RETURN
     END IF
  END IF
  #-----No:FUN-B60140 END-----

  IF g_success = 'N' THEN RETURN END IF
 
  #IF g_success = 'N' THEN RETURN END IF  #No:FUN-BA0112 mark
 
END FUNCTION
 
FUNCTION t111_y_upd()
   #CHI-B80007 -- BEGIN --
   DEFINE l_fbm     RECORD LIKE fbm_file.*
   DEFINE l_msg     LIKE type_file.chr1000
   DEFINE l_cnt     LIKE type_file.num5
   #CHI-B80007 -- BEGIN --
 
   LET g_success = 'Y'
   IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
      g_action_choice CLIPPED = "insert"     #FUN-640243
   THEN
      IF g_fbl.fblmksg='Y'   THEN
          IF g_fbl.fbl07 != '1' THEN
             CALL cl_err('','aws-078',1)
             LET g_success = 'N'
             RETURN
          END IF
      END IF
      IF NOT cl_confirm('axm-108') THEN RETURN END IF
   END IF
  
   BEGIN WORK
   LET g_success = 'Y'
  
   OPEN t111_cl USING g_fbl.fbl01
   IF STATUS thEN
      CALL cl_err("OPEN t111_cl:", STATUS, 1)
      CLOSE t111_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t111_cl INTO g_fbl.*          # 鎖住將被更改或取消的資料
   IF SQLCA.SQLCODE THEN
       CALL cl_err(g_fbl.fbl01,SQLCA.SQLCODE,0)     # 資料被他人LOCK
       CLOSE t111_cl ROLLBACK WORK RETURN
   END IF

   #CHI-B80007 -- BEGIN --
   DECLARE t111_fbm_cur CURSOR FOR
      SELECT * FROM fbm_file WHERE fbm01=g_fbl.fbl01
   FOREACH t111_fbm_cur INTO l_fbm.*
      SELECT count(*) INTO l_cnt FROM fbm_file,fbl_file
       WHERE fbm01 = fbl01
         AND fbm03 = l_fbm.fbm03
         AND fbm031= l_fbm.fbm031 AND fbl02 <= g_fbl.fbl02
         AND fblpost = 'N'
         AND fbl01 != g_fbl.fbl01
         AND fblconf <> 'X'
      IF l_cnt  > 0 THEN
         LET l_msg = l_fbm.fbm01,' ',l_fbm.fbm02,' ',
                     l_fbm.fbm03,' ',l_fbm.fbm031
         CALL s_errmsg('','',l_msg,'afa-309',1)
         LET g_success = 'N'
      END IF
   END FOREACH
   IF g_success = 'N' THEN
      CALL s_showmsg()
      RETURN
   END IF
   #CHI-B80007 -- end --

   LET g_success = 'Y'
   UPDATE fbl_file SET fblconf = 'Y' WHERE fbl01 = g_fbl.fbl01
   IF statuS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd fblconf',STATUS,0)   #No.FUN-660136
      CALL cl_err3("upd","fbl_file",g_fbl.fbl01,"",SQLCA.SQLCODE,"","upd fblconf",1)  #No.FUN-660136
      LET g_success = 'N'
   END IF
  #start FUN-580109
   IF g_success = 'Y' THEN
      IF g_fbl.fblmksg = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
             WHEN 0  #呼叫 EasyFlow 簽核失敗
                  LET g_fbl.fblconf="N"
                  LET g_success = "N"
                  ROLLBACK WORK
                  RETURN
             WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                  LET g_fbl.fblconf="N"
                  ROLLBACK WORK
                  RETURN
         END CASE
      END IF
  #end FUN-580109
      CLOSE t111_cl
      IF g_success = 'Y' THEN
         #start FUN-580109
         LET g_fbl.fbl07='1'         #執行成功, 狀態值顯示為 '1' 已核准
         UPDATE fbl_file SET fbl07 = g_fbl.fbl07 WHERE fbl01=g_fbl.fbl01
         IF SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
         END IF
         #end FUN-580109
         LET g_fbl.fblconf='Y'       #執行成功, 確認碼顯示為 'Y' 已確認
         COMMIT WORK
         DISPLAY BY NAME g_fbl.fblconf
         DISPLAY BY NAME g_fbl.fbl07   #FUN-580109
         CALL cl_flow_notIFy(g_fbl.fbl01,'Y')
      ELSE
         LET g_fbl.fblconf='N'
         LET g_success = 'N'   #FUN-580109
         ROLLBACK WORK
      END IF
  #start FUN-580109
   ELSE
      LET g_fbl.fblconf='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
  #end FUN-580109
  
   IF g_fbl.fblconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #start FUN-580109
   IF g_fbl.fbl07 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #CALL cl_set_field_pic(g_fbl.fblconf,"",g_fbl.fblpost,"",g_chr,"")
   CALL cl_set_field_pic(g_fbl.fblconf,g_chr2,g_fbl.fblpost,"",g_chr,"")
  #end FUN-580109
 
END FUNCTION
 
FUNCTION t111_ef()
 
  CALL t111_y_chk()      #CALL 原確認的 check 段
  IF g_success = "N" THEN
     RETURN
  END IF
 
  CALL aws_condition()   #判斷送簽資料
  IF g_success = 'N' THEN
     RETURN
  END IF
 
######################################
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
######################################
 
  IF aws_efcli2(base.TypeInfo.create(g_fbl),base.TypeInfo.create(g_fbm),'','','','')
  THEN
     LET g_success='Y'
     LET g_fbl.fbl07='S'
     DISPLAY BY NAME g_fbl.fbl07
  ELSE
     LET g_success='N'
  END IF
END FUNCTION
#end FUN-580109
 
FUNCTION t111_z()
 DEFine l_bdate,l_edate   LIKE type_file.dat,          #No.FUN-680070 DATE
        l_fbl02           LIKE fbl_file.fbl02
 
   SELECT * INTO g_fbl.* FROM fbl_file WHERE fbl01 = g_fbl.fbl01
   IF g_fbl.fbl07  ='S' THEN CALL cl_err("","mfg3557",0) RETURN END IF   #FUN-580109
   IF g_fbl.fblconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_fbl.fblconf='N' THEN RETURN END IF
   IF g_fbl.fblpost='Y' THEN
      call cl_err('fblpost=Y:','afa-101',0)
      return
   End IF
   #-->折舊年月判斷
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)   
       RETURNING g_flag,g_bookno1,g_bookno2
   #-----No:FUN-B60140-----
   LET g_bookno2 = g_faa.faa02c
   #IF g_aza.aza63 = 'Y' THEN
   #   CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
   #ELSE
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #No:FUN-BA0112 remark
   #END IF
   ##-----No:FUN-B60140 END-----
   #CHI-A60036 add --end--
   IF g_fbl.fbl02 < l_bdate THEN
      call cl_err(g_fbl.fbl02,'afa-308',0)
      return
   End IF
   #FUN-B50090 add BEGIN-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_fbl.fbl02 < g_faa.faa09 THEN
      call cl_err(g_fbl.fbl01,'aap-176',1) RETURN
   End IF
   
   #-----No:FUN-B60140-----
   IF g_faa.faa31 = 'Y' THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate
      IF g_fbl.fbl02 < l_bdate THEN
         CALL cl_err(g_fbl.fbl02,'afa-308',0)
         RETURN
      END IF
      #-->立帳日期不可小於關帳日期
      IF g_fbl.fbl02 < g_faa.faa092 THEN
         CALL cl_err(g_fbl.fbl01,'aap-176',1) RETURN
      END IF
   END IF
   #-----No:FUN-B60140 END-----   

   IF not cl_confirm('axm-109') THEN RETURN END IF
   Begin WORK
 
    open t111_cl USING g_fbl.fbl01
    IF status tHEN
       call cl_err("OPEN t111_cl:", STATUS, 1)
       close t111_cl
       rollback WORK
       return
    end IF
    fetch t111_cl INTO g_fbl.*          # 鎖住將被更改或取消的資料
    IF sqlca.sqlcode THEN
        call cl_err(g_fbl.fbl01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        close t111_cl ROLLBACK WORK RETURN
    end IF
   Let g_success = 'Y'
  #UPDATE fbl_file SET fblconf = 'N'              #FUN-580109 mark
   UPDATE fbl_file SET fblconf = 'N',fbl07 ='0'   #FUN-580109
    WHERE fbl01 = g_fbl.fbl01
   IF sqlca.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN LET g_success = 'N' END IF
   Close t111_cl
   IF g_success = 'Y' THEN
      LET g_fbl.fblconf='N'
      LET g_fbl.fbl07='0'   #FUN-580109
      commit woRK
      display bY NAME g_fbl.fblconf
      DISPLAY BY NAME g_fbl.fbl07   #FUN-580109
   Else
      LET g_fbl.fblconf='Y'
      rollback WORK
   End IF
   IF g_fbl.fblconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #start FUN-580109
   IF g_fbl.fbl07 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #CALL cl_set_field_pic(g_fbl.fblconf,"",g_fbl.fblpost,"",g_chr,"")
   CALL cl_set_field_pic(g_fbl.fblconf,g_chr2,g_fbl.fblpost,"",g_chr,"")
  #end FUN-580109
END FUNCTION
#----過帳--------
FUNCTION t111_s(p_cmd)
   Define p_cmd       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
          l_fbm       RECORD LIKE fbm_file.*,
          l_faj       RECORD LIKE faj_file.*,
          l_yy        LIKE type_file.chr4,         #No.FUN-680070 VARCHAR(4)
          l_mm        LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(2)
          l_cnt       LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_bdate,l_edate     LIKE type_file.dat,          #No.FUN-680070 DATE
          l_flag      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
          l_fbl02     LIKE fbl_file.fbl02,
          l_faf03     LIKE faf_file.faf03,
          l_msg       LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(40)
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbl.fbl01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    select * INTO g_fbl.* FROM fbl_file WHERE fbl01 = g_fbl.fbl01
   IF g_fbl.fblconf != 'Y' OR g_fbl.fblpost != 'N' THEN
      call cl_err(g_fbl.fbl01,'afa-100',0)
      return
   End IF
   #FUN-B50090 add BEGIN-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fbl.fbl02 < g_faa.faa09 THEN
      call cl_err(g_fbl.fbl01,'aap-176',1) RETURN
   End IF
  #-MOD-A80137-end-
   #--->折舊年月判斷
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)   
       RETURNING g_flag,g_bookno1,g_bookno2
   ##-----No:FUN-B60140-----
   LET g_bookno2 = g_faa.faa02c
   #IF g_aza.aza63 = 'Y' THEN
   #   CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
   #ELSE
       CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   #END IF
   ##-----No:FUN-B60140 END-----
   #CHI-A60036 add --end--
   IF g_fbl.fbl02 < l_bdate OR g_fbl.fbl02 > l_edate THEN
      call cl_err(g_fbl.fbl02,'afa-308',0)
      return
   End IF

   #-----No:FUN-B60140-----
   IF g_faa.faa31 = 'Y' THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate
      IF g_fbl.fbl02 < l_bdate THEN
         CALL cl_err(g_fbl.fbl02,'afa-308',0)
         RETURN
      END IF
      #-->立帳日期不可小於關帳日期
      IF g_fbl.fbl02 < g_faa.faa092 THEN
         CALL cl_err(g_fbl.fbl01,'aap-176',1) RETURN
      END IF
   END IF
   #-----No:FUN-B60140 END-----
   IF not cl_sure(18,20) THEN RETURN END IF
#  Begin WORK #No.FUN-710028
   BEGIN WORK #No.FUN-710028
 
    open t111_cl USING g_fbl.fbl01
    IF status tHEN
       call cl_err("OPEN t111_cl:", STATUS, 1)
       close t111_cl
       rollback WORK
       return
    end IF
    fetch t111_cl INTO g_fbl.*          # 鎖住將被更改或取消的資料
    IF sqlca.sqlcode THEN
        call cl_err(g_fbl.fbl01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        close t111_cl ROLLBACK WORK RETURN
    end IF
   Let g_success = 'Y'
   #--------- 過帳(2)insert fap_file
   Declare t111_cur2 CURSOR FOR
      select * FROM fbm_file WHERE fbm01=g_fbl.fbl01
   CALL s_showmsg_init()     #No.FUN-710028
   Foreach t111_cur2 INTO l_fbm.*
#No.FUN-710028 --BEGIN                                                                                                              
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
#No.FUN-710028 --end
 
      IF sqlca.sqlcode != 0 THEN
#        call cl_err('foreach:',SQLCA.sqlcode,0)                       #No.FUN-710028
         call s_errmsg('fbm01',g_fbl.fbl01,'foreach:',SQLCA.sqlcode,0) #No.FUN-710028
         exit fOREACH
      end IF
      #------- 先找出對應之 faj_file 資料
      select * INTO l_faj.* FROM faj_file WHERE faj02=l_fbm.fbm03
                                            AND faj022=l_fbm.fbm031
      IF status THEN #No.7926
#        call cl_err('sel faj',STATUS,0)              #No.FUN-710028
         LET g_showmsg = l_fbm.fbm03,"/",l_fbm.fbm031 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)  #No.FUN-710028
         LET g_success = 'N'
      end IF
      #-->免稅資料
      IF l_faj.faj40 = '3' AND p_cmd = 'S' THEN
         LET l_msg = l_faj.faj02,' ',l_faj.faj022 clipped
#        call cl_err(l_msg,'afa-305',1)          #No.FUN-710028
         CALL s_errmsg('','',l_msg,'afa-305',1)  #No.FUN-710028
         LET g_success = 'N'
#        exit fOREACH      #No.FUN-710028
         CONTINUE fOREACH  #No.FUN-710028
      end IF
      #-->判斷輸入日期之前是否有未過帳
      select count(*) INTO l_cnt FROM fbm_file,fbl_file
                     WHERE fbm01 = fbl01
                       AND fbm03 = l_fbm.fbm03
                       AND fbm031= l_fbm.fbm031
                       AND fbl02 <= l_fbl02
                       AND fblpost = 'N'
                       AND fbl01 != g_fbl.fbl01
                       AND fblconf <> 'X'   #MOD-590470
      IF l_cnt  > 0 THEN
         LET l_msg = l_fbm.fbm01,' ',l_fbm.fbm02,' ',
                     l_fbm.fbm03,' ',l_fbm.fbm031
#        call cl_err(l_msg,'afa-309',1)  #No.FUN-710028
         CALL s_errmsg('','',l_msg,'afa-309',1)  #No.FUN-710028
         LET g_success = 'N'
#        exit fOREACH      #No.FUN-710028
         CONTINUE fOREACH  #No.FUN-710028
      end IF
      #-----TQC-620120---------
      IF cl_null(l_fbm.fbm031) THEN
         LET l_fbm.fbm031 = ' '
      END IF
      #-----END TQC-620120-----
     #CHI-C60010---str---
      SELECT aaa03 INTO g_faj143 FROM aaa_file
       WHERE aaa01 = g_faa.faa02c
      IF NOT cl_null(g_faj143) THEN
         SELECT azi04 INTO g_azi04_1 FROM azi_file
          WHERE azi01 = g_faj143
      END IF
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
     #CHI-C60010---end---
      INSERT INTO fap_file (fap01,fap02,fap021,fap03,fap04,fap05,fap06,fap07,
                            fap08,fap09,fap10,fap101,fap11,fap12,fap13,fap14,
                            fap15,fap16,fap17,fap18,fap19,fap20,fap201,fap21,
                            fap22,fap23,fap24,fap25,fap26,fap30,fap31,fap32,
                            fap33,fap34,fap341,fap35,fap36,fap37,fap38,fap39,
                            fap40,fap41,fap50,fap501,fap58,fap59,fap60,fap61,
                            fap62,fap63,fap64,fap65,fap77,fap56,              #TQC-B30156 add fap56
                            #FUN-AB0088---add---str---
                            fap052,fap062,fap072,fap082,
                            fap092,fap103,fap1012,fap112,
                            fap152,fap162,fap212,fap222,
                            fap232,fap242,fap252,fap262,fap772,
                            #FUN-AB0088---add---end---
                            faplegal)      #FUN-980003 add
                    #VALUES (l_faj.faj01,l_fbm.fbm03,l_fbm.fbm031,'C',   #TQC-780083
                    VALUES (l_faj.faj01,l_fbm.fbm03,l_fbm.fbm031,'D',   #TQC-780083
                            g_fbl.fbl02,l_faj.faj43,l_faj.faj28,l_faj.faj30,
                            l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33,
                            l_faj.faj32,l_faj.faj53,l_faj.faj54,l_faj.faj55,
                            l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
                            l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
                            l_faj.faj59,l_faj.faj60,l_faj.faj34,l_faj.faj35,
                            l_faj.faj36,l_faj.faj61,l_faj.faj65,l_faj.faj66,
                            l_faj.faj62,l_faj.faj63,l_faj.faj68,l_faj.faj67,
                            l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
                            l_faj.faj73,l_faj.faj100,l_fbm.fbm01,l_fbm.fbm02,
                            l_faj.faj53,l_faj.faj54,l_faj.faj55,l_faj.faj23,
                            l_faj.faj24,l_fbm.fbm05,l_fbm.fbm04,l_fbm.fbm06,
                            l_faj.faj43,0,       #TQC-B30156 add 0
                            #FUN-AB0088---add---str---
                            l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
                            l_faj.faj142,l_faj.faj1412,l_faj.faj332+l_faj.faj3312,l_faj.faj322,
                            l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
                            l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,l_faj.faj432,
                            #FUN-AB0088---add---end---
                            g_legal)             #FUN-980003 add
      IF status OR SQLCA.sqlerrd[3]= 0 THEN
#        call cl_err('ins fap',STATUS,0)   #No.FUN-660136
#        CALL cl_err3("ins","fbl_file",l_faj.faj01,l_fbm.fbm03,SQLCA.SQLCODE,"","ins fap",1)  #No.FUN-660136 #No.FUN-710028
         #LET g_showmsg = l_fbm.fbm03,"/",l_fbm.fbm031,"/",'C',"/",g_fbl.fbl02     #No.FUN-710028   #TQC-780083
         LET g_showmsg = l_fbm.fbm03,"/",l_fbm.fbm031,"/",'D',"/",g_fbl.fbl02     #No.FUN-710028   #TQC-780083
         CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'ins fap',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      end IF
      select faf03 INTO l_faf03 FROM faf_file WHERE faf01 = l_fbm.fbm06
      IF sqlca.sqlcode THEN LET l_faf03 = ' ' END IF
      #--------- 過帳(3)UPDATE faj_file
      UPDATE faj_file SET faj19  = l_fbm.fbm04, #保管人
                          faj20  = l_fbm.fbm05, #保管部門
                          faj21  = l_fbm.fbm06, #存放位置
                          faj22  = l_faf03,     #存放工廠   #MOD-9C0002 add
                          faj100 = g_fbl.fbl02  #最近異動日
       WHERE faj02=l_fbm.fbm03 AND faj022=l_fbm.fbm031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#        CALL cl_err('upd faj',STATUS,0)   #No.FUN-660136
#        CALL cl_err3("upd","fbl_file",l_fbm.fbm03,l_fbm.fbm031,SQLCA.SQLCODE,"","upd faj",1)  #No.FUN-660136 #No.FUN-710028
         LET g_showmsg = l_fbm.fbm03,"/",l_fbm.fbm031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
     #str MOD-A10194 add
      #--------- 過帳(4)UPDATE fga_file
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fga_file
       WHERE fga03=l_fbm.fbm03 AND fga031=l_fbm.fbm031
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt > 0 THEN
         UPDATE fga_file SET fga12  = l_fbm.fbm04, #保管人
                             fga13  = l_fbm.fbm05, #保管部門
                             fga14  = l_fbm.fbm06, #存放位置
                             fga15  = l_faf03      #存放工廠
          WHERE fga03=l_fbm.fbm03 AND fga031=l_fbm.fbm031
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            LET g_showmsg = l_fbm.fbm03,"/",l_fbm.fbm031
            CALL s_errmsg('fga03,fga031',g_showmsg,'upd fga',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
     #end MOD-A10194 add
   END FOREACH
#No.FUN-710028 --BEGIN                                                                                                              
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
#No.FUN-710028 --end
 
   Close t111_cl
   IF g_success = 'Y' THEN
      #--------- 過帳(1)UPDATE fblpost
      UPDATE fbl_file SET fblpost = 'Y' WHERE fbl01 = g_fbl.fbl01
          IF stATUS OR SQLCA.sqlerrd[3] = 0 THEN
#            caLL cl_err('upd fblpost',STATUS,0)   #No.FUN-660136
#            CALL cl_err3("upd","fbl_file",g_fbl.fbl01,"",SQLCA.SQLCODE,"","upd fblpost",1)  #No.FUN-660136 #No.FUN-710028
             CALL s_errmsg('fbl01',g_fbl.fbl01,'upd fblpost',STATUS,1)                       #No.FUN-710028
             leT g_fbl.fblpost='N'
             leT g_success = 'N'
          ELSE
             leT g_fbl.fblpost='Y'
             leT g_success = 'Y'
          end iF
   End IF
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN
       rollback WORK
   Else
       commit wORK
       call cl_flow_notIFy(g_fbl.fbl01,'S')
   End IF
   Display by nAME g_fbl.fblpost #
   IF g_fbl.fblconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #start FUN-580109
   IF g_fbl.fbl07 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #CALL cl_set_field_pic(g_fbl.fblconf,"",g_fbl.fblpost,"",g_chr,"")
   CALL cl_set_field_pic(g_fbl.fblconf,g_chr2,g_fbl.fblpost,"",g_chr,"")
  #end FUN-580109
END FUNCTION
 
FUNCTION t111_w()
   Define l_fbm    RECORD LIKE fbm_file.*,
          l_faj    RECORD LIKE faj_file.*,
          l_fap17  LIKE fap_file.fap17,
          l_fap18  LIKE fap_file.fap18,
          l_fap19  LIKE fap_file.fap19,
          l_fap41  LIKE fap_file.fap41,
          l_fbl02  LIKE fbl_file.fbl02,
          l_faf03  LIKE faf_file.faf03,
          l_cnt             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_msg             LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(70)
          l_bdate,l_edate   LIKE type_file.dat          #No.FUN-680070 DATE
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fbl.fbl01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   #FUN-B50090 add BEGIN-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fbl.fbl02 < g_faa.faa09 THEN
      call cl_err(g_fbl.fbl01,'aap-176',1) RETURN
   End IF
  #-MOD-A80137-end-
    SELECT * INTO g_fbl.* FROM fbl_file WHERE fbl01 = g_fbl.fbl01
   #--->折舊年月判斷必須為當月
   Select fbl02 INTO l_fbl02 FROM fbl_file WHERE fbl01 = g_fbl.fbl01
   IF sqlca.sqlcode THEN LET l_fbl02 = ' '  RETURN END IF
   #CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_faa.faa07)   
       RETURNING g_flag,g_bookno1,g_bookno2
   ##-----No:FUN-B60140-----
   LET g_bookno2 = g_faa.faa02c
   #IF g_aza.aza63 = 'Y' THEN
   #   CALL s_azmm(g_faa.faa07,g_faa.faa08,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
   #ELSE
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   #END IF
   ##-----No:FUN-B60140 END-----
   #CHI-A60036 add --end--
   IF g_fbl.fbl02 < l_bdate OR g_fbl.fbl02 > l_edate THEN
      call cl_err(g_fbl.fbl02,'afa-339',0)
      return
   End IF
   
   #-----No:FUN-B60140-----
   IF g_faa.faa31 = 'Y' THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate
      IF g_fbl.fbl02 < l_bdate THEN
         CALL cl_err(g_fbl.fbl02,'afa-308',0)
         RETURN
      END IF
      #-->立帳日期不可小於關帳日期
      IF g_fbl.fbl02 < g_faa.faa092 THEN
         CALL cl_err(g_fbl.fbl01,'aap-176',1) RETURN
      END IF
   END IF
   #-----No:FUN-B60140 END-----

   IF g_fbl.fblpost != 'Y' THEN
      call cl_err(g_fbl.fbl01,'afa-108',0)
      return
   End IF
   IF not cl_sure(18,20) THEN RETURN END IF
#  Begin WORK  #No.FUN-710028
   BEGIN WORK  #No.FUN-710028
 
    open t111_cl USING g_fbl.fbl01
    IF status tHEN
       call cl_err("OPEN t111_cl:", STATUS, 1)
       close t111_cl
       rollback WORK
       return
    end IF
    fetch t111_cl INTO g_fbl.*          # 鎖住將被更改或取消的資料
    IF sqlca.sqlcode THEN
        call cl_err(g_fbl.fbl01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        close t111_cl ROLLBACK WORK RETURN
    end IF
 
   Let g_success = 'Y'
   #--------- 還原過帳(2)UPDATE faj_file
   Declare t111_cur3 CURSOR FOR
      select * FROM fbm_file WHERE fbm01=g_fbl.fbl01
   CALL s_showmsg_init()    #No.FUN-710028
   Foreach t111_cur3 INTO l_fbm.*
#No.FUN-710028 --BEGIN                                                                                                              
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
#No.FUN-710028 --end
 
      IF sqlca.sqlcode != 0 THEN
#        call cl_err('foreach:',SQLCA.sqlcode,0)                         #No.FUN-710028
         CALL s_errmsg('fbm01',g_fbl.fbl01,'foreach:',SQLCA.sqlcode,0)   #No.FUN-710028
         exit fOREACH
      end IF
      #-->判斷輸入日期之前是否有已過帳
      select count(*) INTO l_cnt FROM fbm_file,fbl_file
                      WHERE fbm01  = fbl01
                        AND fbm03  = l_fbm.fbm03
                        AND fbm031 = l_fbm.fbm031
                        AND fbl02 >= l_fbl02
                        AND fblpost= 'Y'
                        AND fbl01 != g_fbl.fbl01
      IF l_cnt  > 0 THEN
         LET l_msg = l_fbm.fbm01,' ',l_fbm.fbm02,' ',
                     l_fbm.fbm03,' ',l_fbm.fbm031
#        call cl_err(l_msg,'afa-310',1)          #No.FUN-710028
         CALL s_errmsg('','',l_msg,'afa-310',1)  #No.FUN-710028
         LET g_success = 'N'
#        exit fOREACH      #No.FUN-710028
         CONTINUE fOREACH  #No.FUN-710028
      end IF
      #--> 找出 faj_file 中對應之財產編號+附號
      select * INTO l_faj.* FROM faj_file WHERE faj02=l_fbm.fbm03
                                            AND faj022=l_fbm.fbm031
      IF status THEN #No.7926
#        call cl_err('sel faj',STATUS,0)   #No.FUN-660136
#        CALL cl_err3("sel","faj_file",l_fbm.fbm03,l_fbm.fbm031,SQLCA.SQLCODE,"","sel faj",1)  #No.FUN-660136 #No.FUN-710028
         LET g_showmsg = l_fbm.fbm03,"/",l_fbm.fbm031                 #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,0)   #No.FUN-710028
         return
         CONTINUE fOREACH  #No.FUN-710028
      end IF
      #----- 找出 fap_file 之 fap05 以便 UPDATE faj_file.faj43
      select fap17,fap18,fap19,fap41
        into l_fap17, l_fap18,l_fap19,l_fap41
        from fap_file
       #where fap50=l_fbm.fbm01 AND fap501=l_fbm.fbm02 AND fap03='C'   #TQC-780083
       where fap50=l_fbm.fbm01 AND fap501=l_fbm.fbm02 AND fap03='D'   #TQC-780083
          IF stATUS THEN #No.7926
#            caLL cl_err('sel fap',STATUS,0)     #No.FUN-660136
#            CALL cl_err3("sel","faj_file",l_fbm.fbm01,l_fbm.fbm02,SQLCA.SQLCODE,"","sel fap",1)  #No.FUN-660136 #No.FUN-710028
             #LET g_showmsg = l_fbm.fbm02,"/",'C' #No.FUN-710028   #TQC-780083
             LET g_showmsg = l_fbm.fbm02,"/",'D' #No.FUN-710028   #TQC-780083
             CALL s_errmsg('fap501,fap03',g_showmsg,'sel fap',STATUS,1)   #No.FUN-710028
             leT g_success = 'N'
          end iF
      SELECT faf03 INTO l_faf03 FROM faf_file WHERE faf01=l_fap19  #MOD-9C0002 add
      IF sqlca.sqlcode THEN LET l_faf03 = ' ' END IF               #MOD-9C0002 add
      UPDATE faj_file set faj19  = l_fap18,  #保管人員
                          faj20  = l_fap17,  #保管部門
                          faj21  = l_fap19,  #存放位置
                          faj22  = l_faf03,  #存放工廠   #MOD-9C0002 add
                          faj100 = l_fap41   #異動日期
       WHERE faj02=l_fbm.fbm03 AND faj022=l_fbm.fbm031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#        CALL cl_err('upd faj',STATUS,0)                 #No.FUN-660136
#        CALL cl_err3("upd","faj_file",l_fbm.fbm03,l_fbm.fbm031,SQLCA.SQLCODE,"","upd faj",1)  #No.FUN-660136 #No.FUN-710028
         LET g_showmsg = l_fbm.fbm03,"/",l_fbm.fbm031    #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)  #No.FUN-710028
         LET g_success = 'N'
      END IF
     #str MOD-A10194 add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fga_file
       WHERE fga03=l_fbm.fbm03 AND fga031=l_fbm.fbm031
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt > 0 THEN
         UPDATE fga_file SET fga12  = l_fap18,  #保管人
                             fga13  = l_fap17,  #保管部門
                             fga14  = l_fap19,  #存放位置
                             fga15  = l_faf03   #存放工廠
          WHERE fga03=l_fbm.fbm03 AND fga031=l_fbm.fbm031
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            LET g_showmsg = l_fbm.fbm03,"/",l_fbm.fbm031
            CALL s_errmsg('fga03,fga031',g_showmsg,'upd fga',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
     #end MOD-A10194 add
      #--------- 還原過帳(3)deLETe fap_file
      deLETe frOM fap_file WHERE fap50=l_fbm.fbm01 AND fap501= l_fbm.fbm02
                             #AND fap03 = 'C'   #TQC-780083
                             AND fap03 = 'D'   #TQC-780083
      IF status OR SQLCA.sqlerrd[3]= 0 THEN
#        call cl_err('del fap',STATUS,0)                       #No.FUN-660136
#        CALL cl_err3("del","fap_file",l_fbm.fbm01,l_fbm.fbm02,SQLCA.SQLCODE,"","del fap",1)  #No.FUN-660136 #No.FUN-710028
         #LET g_showmsg = l_fbm.fbm01,"/",l_fbm.fbm02,"/",'C'   #No.FUN-710028   #TQC-780083
         LET g_showmsg = l_fbm.fbm01,"/",l_fbm.fbm02,"/",'D'   #No.FUN-710028   #TQC-780083
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'del fap',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      end IF
   End foreach
#No.FUN-710028 --BEGIN                                                                                                              
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
#No.FUN-710028 --end
 
   #--------- 還原過帳(1)UPDATE fbl_file
   IF g_success = 'Y' THEN
      UPDATE fbl_file SET fblpost = 'N' WHERE fbl01 = g_fbl.fbl01
         IF staTUS OR SQLCA.sqlerrd[3] = 0 THEN
#           calL cl_err('upd fblpost',STATUS,0)   #No.FUN-660136
#           CALL cl_err3("upd","fbl_file",g_fbl.fbl01,"",SQLCA.SQLCODE,"","upd fblpost",1)  #No.FUN-660136 #No.FUN-710028
            CALL s_errmsg('fbl01',g_fbl.fbl01,'upd fblpost',STATUS,1)                       #No.FUN-710028
            LET g_fbl.fblpost='Y'
            LET g_success = 'N'
         ELSE
            LET g_fbl.fblpost='N'
            LET g_success = 'Y'
         end IF
   End IF
   Close t111_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'N' THEN ROLLBACK WORK ELSE COMMIT WORK END IF
   Display by nAME g_fbl.fblpost #
   IF g_fbl.fblconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #start FUN-580109
   IF g_fbl.fbl07 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #CALL cl_set_field_pic(g_fbl.fblconf,"",g_fbl.fblpost,"",g_chr,"")
   CALL cl_set_field_pic(g_fbl.fblconf,g_chr2,g_fbl.fblpost,"",g_chr,"")
  #end FUN-580109
END FUNCTION
 
#FUNCTION t111_x()                    #FUN-D20035
FUNCTION t111_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035

   IF s_shut(0) THEN RETURN END IF
   Select * intO g_fbl.* FROM fbl_file WHERE fbl01=g_fbl.fbl01
  #start FUN-580109
   IF g_fbl.fbl07 MATCHES '[Ss1]' THEN
      CALL cl_err("","mfg3557",0) RETURN
   END IF
  #end FUN-580109
   IF g_fbl.fbl01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fbl.fblconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
 #  IF g_fbl.fblconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
 #  IF not cl_confirm('axr-152') THEN RETURN END IF

   #FUN-D20035---BEGIN
   #作废操作
   IF p_type = 1 THEN
      IF g_fbl.fblconf ='X' THEN RETURN END IF
   ELSE
   #取消作废
      IF g_fbl.fblconf <>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   Begin WORK
   Let g_success='Y'
 
   Open t111_cl USING g_fbl.fbl01
   IF status thEN
      call cl_err("OPEN t111_cl:", STATUS, 1)
      close t111_cl
      rollback WORK
      return
   End IF
   Fetch t111_cl INTO g_fbl.*          #鎖住將被更改或取消的資料
   IF sqlca.sqlcode THEN
      call cl_err(g_fbl.fbl01,SQLCA.sqlcode,0)      #資料被他人LOCK
      close t111_cl ROLLBACK WORK RETURN
   End IF
  #-->作廢轉換01/08/01
 #IF cl_void(0,0,g_fbl.fblconf)   THEN                                 #FUN-D20035
  IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF     #FUN-D20035
  IF cl_void(0,0,l_flag) THEN                                          #FUN-D20035
     LET g_chr=g_fbl.fblconf
    #IF g_fbl.fblconf ='N' THEN                                         #FUN-D20035
     IF p_type = 1 THEN                                                 #FUN-D20035
        LET g_fbl.fblconf='X'
        LET g_fbl.fbl07 = '9'   #FUN-580109
     ELSE
        LET g_fbl.fblconf='N'
        LET g_fbl.fbl07 = '0'   #FUN-580109
     END IF
 
     UPDATE fbl_file SET fblconf =g_fbl.fblconf,
                         fbl07   =g_fbl.fbl07,    #FUN-580109
                         fblmodu =g_user,
                         fbldate =TODAY
                   WHERE fbl01 = g_fbl.fbl01
     IF status THEN 
#       CALL cl_err('upd fblconf:',STATUS,1)    #No.FUN-660136
        CALL cl_err3("upd","fbl_file",g_fbl.fbl01,"",SQLCA.SQLCODE,"","upd fblconf:",1)  #No.FUN-660136
        LET g_success='N' 
     END IF
     IF g_success='Y' THEN
        COMMIT WORK
       #start FUN-580109
        IF g_fbl.fblconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_fbl.fbl07 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_fbl.fblconf,g_chr2,g_fbl.fblpost,"",g_chr,"")
       #end FUN-580109
        CALL cl_flow_notIFy(g_fbl.fbl01,'V')
     ELSE
        ROLLBACK WORK
     END IF
    #SELECT fblconf INTO g_fbl.fblconf                     #FUN-580109 mark
     SELECT fblconf,fbl07 INTO g_fbl.fblconf,g_fbl.fbl07   #FUN-580109
       FROM fbl_file
      WHERE fbl01 = g_fbl.fbl01
     DISPLAY BY NAME g_fbl.fblconf
     DISPLAY BY NAME g_fbl.fbl07   #FUN-580109
  END IF
 #IF g_fbl.fblconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF   #FUN-580109 mark
 #CALL cl_set_field_pic(g_fbl.fblconf,"",g_fbl.fblpost,"",g_chr,"")   #FUN-580109 mark
END FUNCTION

#FUN-9A0059 ------------------add start------------------------------
FUNCTION t111_out()                                                             
   DEFINE l_cmd         LIKE type_file.chr1000,                                 
          l_wc,l_wc2    LIKE type_file.chr50,                                   
          l_prtway      LIKE type_file.chr1                                     
                                                                                
      CALL cl_wait()                                                            
      LET l_wc='fbl01="',g_fbl.fbl01,'"'                                        
      SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afar111'  
      IF SQLCA.sqlcode OR l_wc2 IS NULL THEN                                    
         LET l_wc2 = " '3' '3' "                                                
      END IF                                                                    
      LET l_cmd = "afar111",                                                    
                   " '",g_today CLIPPED,"' ''",                                 
                   " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",              
                   " '",l_wc CLIPPED,"' ",l_wc2                                 
      CALL cl_cmdrun(l_cmd)                                                     
   ERROR ' '                                                                    
END FUNCTION
#FUN-9A0059 --------------------------add end--------------------------------------

