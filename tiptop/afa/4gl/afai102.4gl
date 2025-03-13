# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afai102.4gl
# Descriptions...: 折畢再提維護作業(財簽/稅簽)
# Date & Autority: 01/01/03 By Kammy (修改成單據維護作業)
# Modify.........: 01/04/17 By Kammy (add fgh03=1 for 財簽 fgh03 = 2 for 稅簽)
# Modify.........: 01/05/31 by linda modify 稅簽狀態原本抓faj43改為faj201
# Modify.........: No.MOD-470515 04/07/27 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0019 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: NO.FUN-550034 05/05/17 By jackie 單據編號加大
# Modify.........: NO.FUN-570129 05/08/05 BY yiting 單身只有行序時只能放棄才能離
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.TQC-630004 06/03/06 By Smapmin 資產狀態已無'C'這個選項,故相關程式予以修正
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.TQC-640183 06/07/20 By Smapmin 第一次維護afai102時,insert apf_file
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0001 06/10/11 By jamie FUNCTION i102_q() 一開始應清空g_fgh.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.MOD-6B0091 06/12/05 By Smapmin 當月(或後續月份)資產若已有折舊時則不可取消確認
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780039 07/08/08 By Smapmin 當faj31>faj33表示已經超過一般預留殘值,
#                                                    此時單身預留殘值應採faj33計算而非faj31
# Modify.........: No.TQC-790086 07/09/13 By Judy 查詢狀態下異動單號開窗應查詢單據號
# Modify.........: No.TQC-780089 07/09/21 By Smapmin 自動產生或單身輸入資產編號時,當月有折舊不可輸入
# Modify.........: No.MOD-7A0118 07/10/22 By Smapmin 無法確認
# Modify.........: No.FUN-7A0079 07/11/28 By Nicola 多稅簽部份
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-850068 08/05/14 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-860009 08/06/09 By Sarah 再提否若沒有勾選時無法確認、取消確認
# Modify.........: No.CHI-860025 08/07/23 By Smapmin 根據TQC-780089的修改,需區分財簽與稅簽
# Modify.........: No.MOD-890214 08/10/01 By Sarah 組SQL時,faj28與faj61需抓取'1','3'
# Modify.........: No.MOD-890272 08/10/03 By Sarah 1.INSERT到fap_file的欄位太少,造成afaq100查出的資料大部分欄位都是空的
#                                                  2.折畢殘值fgi09計算,應區分財簽稅簽
# Modify.........: No.MOD-8B0268 08/11/26 By Sarah i102_z()段,應判斷g_argv1='1'時,afa-129抓fan_file判斷
#                                                                          ELSE時,afa-129抓fao_file判斷
# Modify.........: No.MOD-8C0123 08/12/15 By Sarah 1.i102_z()段,抓fgi08,fgi09的SQL條件應判斷g_argv1='1'時增加fgh03='1',ELSE增加fgh03='2'
#                                                  2.SLEECT/DELETE fap_file時,條件增加fap50=l_fgi.fgi01
# Modify.........: No.FUN-980003 09/08/06 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990151 09/09/15 By Sarah 單身增加顯示faj35
# Modify.........: No.MOD-990113 09/10/14 By sabrina 日期檢核應以s_azn01方式做檢核
# Modify.........: No:CHI-9B0032 09/11/30 By Sarah 寫入fap_file時,也應寫入fap77=faj43
# Modify.........: No.MOD-9C0282 09/12/23 By sabrina 附號應check是否有存在財產資料中
# Modify.........: No:FUN-9C0077 10/01/06 By baofei 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-AA0089 10/10/15 by Dido 刪除 fap_file 前的 STATUS 判斷予已取消 
# Modify.........: No.MOD-B30374 11/03/16 By lixia fgi09依本國幣取位
# Modify.........: No.FUN-AB0088 11/04/11 By lixiang 固定资料財簽二功能
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B60140 11/09/07 By minpp "財簽二二次改善" 追單
# Modify.........: No:MOD-BA0133 11/10/18 By johung 取消確認時回寫faj34/faj342/faj71改抓備份在fap_file的fap24/fap242/fap38
# Modify.........: No:MOD-BC0025 11/12/10 By johung 調整afa-092控卡的判斷
# Modify.........: No:MOD-C20086 12/02/13 By Dido 單身不允許有相同的財產編號+附號存在此作業中 
# Modify.........: No:MOD-C50044 12/05/09 By Elise 按下確認時，會出現afai900內當月份有做調整的單被當成是已提列折舊的單
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao 整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C60010 12/06/14 By wangrr   財簽二欄位需依財簽二幣別做取位
# Modify.........: No.CHI-C80041 13/02/05 By bart     無單身刪除單頭
# Modify.........: No.FUN-D20095 13/02/26 By Belle    增加取消作廢選項
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40121 13/05/30 By zhangweib 增加背景傳參,可以通過其他程序調用本程序

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_fgh           RECORD LIKE fgh_file.*,       #單頭
       g_fgh_t         RECORD LIKE fgh_file.*,       #單頭(舊值)
       g_fgh_o         RECORD LIKE fgh_file.*,       #單頭(舊值)
       g_fgh01_t       LIKE fgh_file.fgh01,   #單頭 (舊值)
       g_modify        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
       g_fgi           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                       fgi02   LIKE fgi_file.fgi02,
                       fgi06   LIKE fgi_file.fgi06,
                       fgi07   LIKE fgi_file.fgi07,
                       fgi04   LIKE fgi_file.fgi04,
                       fgi05   LIKE fgi_file.fgi05,
                       faj31   LIKE faj_file.faj31,
                       faj35   LIKE faj_file.faj35,  #MOD-990151 add
                       fgi11   LIKE fgi_file.fgi11,
                       fgi10   LIKE fgi_file.fgi10,
                       fgi08   LIKE fgi_file.fgi08,
                       fgi09   LIKE fgi_file.fgi09,
                       fgiud01 LIKE fgi_file.fgiud01,
                       fgiud02 LIKE fgi_file.fgiud02,
                       fgiud03 LIKE fgi_file.fgiud03,
                       fgiud04 LIKE fgi_file.fgiud04,
                       fgiud05 LIKE fgi_file.fgiud05,
                       fgiud06 LIKE fgi_file.fgiud06,
                       fgiud07 LIKE fgi_file.fgiud07,
                       fgiud08 LIKE fgi_file.fgiud08,
                       fgiud09 LIKE fgi_file.fgiud09,
                       fgiud10 LIKE fgi_file.fgiud10,
                       fgiud11 LIKE fgi_file.fgiud11,
                       fgiud12 LIKE fgi_file.fgiud12,
                       fgiud13 LIKE fgi_file.fgiud13,
                       fgiud14 LIKE fgi_file.fgiud14,
                       fgiud15 LIKE fgi_file.fgiud15
                       END RECORD,
       g_fgi_t         RECORD                 #程式變數 (舊值)
                       fgi02   LIKE fgi_file.fgi02,
                       fgi06   LIKE fgi_file.fgi06,
                       fgi07   LIKE fgi_file.fgi07,
                       fgi04   LIKE fgi_file.fgi04,
                       fgi05   LIKE fgi_file.fgi05,
                       faj31   LIKE faj_file.faj31,
                       faj35   LIKE faj_file.faj35,  #MOD-990151 add
                       fgi11   LIKE fgi_file.fgi11,
                       fgi10   LIKE fgi_file.fgi10,
                       fgi08   LIKE fgi_file.fgi08,
                       fgi09   LIKE fgi_file.fgi09,
                       fgiud01 LIKE fgi_file.fgiud01,
                       fgiud02 LIKE fgi_file.fgiud02,
                       fgiud03 LIKE fgi_file.fgiud03,
                       fgiud04 LIKE fgi_file.fgiud04,
                       fgiud05 LIKE fgi_file.fgiud05,
                       fgiud06 LIKE fgi_file.fgiud06,
                       fgiud07 LIKE fgi_file.fgiud07,
                       fgiud08 LIKE fgi_file.fgiud08,
                       fgiud09 LIKE fgi_file.fgiud09,
                       fgiud10 LIKE fgi_file.fgiud10,
                       fgiud11 LIKE fgi_file.fgiud11,
                       fgiud12 LIKE fgi_file.fgiud12,
                       fgiud13 LIKE fgi_file.fgiud13,
                       fgiud14 LIKE fgi_file.fgiud14,
                       fgiud15 LIKE fgi_file.fgiud15
                       END RECORD,
       g_fah           RECORD LIKE fah_file.*,       #單據檔
       g_wc,g_wc2,g_sql    string,                   #No.FUN-580092 HCN
       g_t1            LIKE type_file.chr5,          #No.FUN-550034               #No.FUN-680070 VARCHAR(05)
       g_argv1         LIKE fgh_file.fgh03,          #1.財簽  2.稅簽              #No.FUN-680070 VARCHAR(01)
       g_rec_b         LIKE type_file.num5,          #單身筆數                    #No.FUN-680070 SMALLINT
       l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT         #No.FUN-680070 SMALLINT
DEFINE g_forupd_sql STRING                        #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-680070 SMALLINT
DEFINE g_cnt        LIKE type_file.num10          #No.FUN-680070 INTEGER
DEFINE g_i          LIKE type_file.num5           #count/index for any purpose #No.FUN-680070 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000        #No.FUN-680070 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10          #No.FUN-680070 INTEGER
DEFINE g_curs_index LIKE type_file.num10          #No.FUN-680070 INTEGER
DEFINE g_jump       LIKE type_file.num10          #No.FUN-680070 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5           #No.FUN-680070 SMALLINT
DEFINE g_argv2      LIKE fgh_file.fgh01           #No.FUN-D40121   Add
DEFINE g_argv3      STRING                        #No.FUN-D40121   Add
 
MAIN
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680070 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1      = ARG_VAL(1) 
   LET g_argv2      = ARG_VAL(2)  #No.FUN-D40121   Add
   LET g_argv3      = ARG_VAL(3)  #No.FUN-D40121   Add

   #-----No:FUN-AB0088-----
   CASE g_argv1
      WHEN "1"
         LET g_prog='afai102'
      WHEN "2"
         LET g_prog='afai103'
      WHEN "3"
         LET g_prog='afai105'
         IF g_faa.faa31='N' THEN
            CALL cl_err('','afa-260',1)
            EXIT PROGRAM
         END IF
   END CASE
  #IF g_argv1 = "1" THEN
  #   LET g_prog="afai102"
  #ELSE
  #   LET g_prog="afai103"
  #END IF
  #-----No:FUN-AB0088 END----- 
  #No.FUN-D40121 ---Add--- Start
   IF NOT cl_null(g_argv2) THEN
      CASE
         WHEN g_argv3 = 'query'
            CALL i102_q()
         OTHERWISE
            CALL i102_q()
      END CASE
   END IF
  #No.FUN-D40121 ---Add--- End
  
  CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818 #NO.FUN
      RETURNING g_time                           #NO.FUN-6A0069

   LET g_forupd_sql = " SELECT * FROM fgh_file WHERE fgh01 = ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i102_cl CURSOR FROM g_forupd_sql

   LET p_row = 4 LET p_col = 15

   OPEN WINDOW i102_w AT p_row,p_col WITH FORM "afa/42f/afai102"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN

   CALL cl_ui_init()

   CALL i102_menu()

   CLOSE WINDOW i102_w                    #結束畫面

   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818 #NO.FUN
      RETURNING g_time                      #NO.FUN-6A0069

END MAIN

FUNCTION i102_menu()

   WHILE TRUE
      CALL i102_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i102_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i102_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i102_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i102_u()
            END IF
         WHEN "previous"
            CALL i102_fetch('P')
         WHEN "next"
            CALL i102_fetch('N')
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i102_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fgh.fgh01 IS NOT NULL THEN
                  LET g_doc.column1 = "fgh01"
                  LET g_doc.value1 = g_fgh.fgh01
                  CALL cl_doc()
               END IF
            END IF
 
         WHEN "exit"
            EXIT WHILE
         WHEN "jump"
             CALL i102_fetch('/')
         WHEN "last"
             CALL i102_fetch('L')
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i102_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i102_z()
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fgi),'','')
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL i102_v()     #FUN-D20095 mark
               CALL i102_v(1)    #FUN-D20095
            END IF
         #CHI-C80041---end
         #FUN-D20095---add--str
         #取消作廢
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL i102_v(2)
            END IF
         #FUN-D20095---add--end

      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i102_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_fgi.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_fgh.* TO NULL    #No.FUN-750051
   IF cl_null(g_argv2) THEN        #No.FUN-D40121   Add
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
          fgh01,fgh02,fghconf,
          fghuser,fghgrup,fghmodu,fghdate,fghacti,
          fghud01,fghud02,fghud03,fghud04,fghud05,
          fghud06,fghud07,fghud08,fghud09,fghud10,
          fghud11,fghud12,fghud13,fghud14,fghud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
       ON ACTION controlp
          CASE
             WHEN INFIELD(fgh01) #單別
                CALL cl_init_qry_var()                                         
                LET g_qryparam.state= "c"                                      
                LET g_qryparam.form = "q_fgh"                                  
                CALL cl_create_qry() RETURNING g_qryparam.multiret             
                DISPLAY g_qryparam.multiret TO fgh01
                NEXT FIELD fgh01
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
 
 
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    CONSTRUCT g_wc2 ON fgi02,fgi06,fgi07,fgi04,fgi05,fgi10,fgi08,fgi09
                       ,fgiud01,fgiud02,fgiud03,fgiud04,fgiud05
                       ,fgiud06,fgiud07,fgiud08,fgiud09,fgiud10
                       ,fgiud11,fgiud12,fgiud13,fgiud14,fgiud15
                  FROM s_fgi[1].fgi02,s_fgi[1].fgi06,s_fgi[1].fgi07,
                       s_fgi[1].fgi04,s_fgi[1].fgi05,s_fgi[1].fgi10,
                       s_fgi[1].fgi08,s_fgi[1].fgi09
                       ,s_fgi[1].fgiud01,s_fgi[1].fgiud02,s_fgi[1].fgiud03
                       ,s_fgi[1].fgiud04,s_fgi[1].fgiud05,s_fgi[1].fgiud06
                       ,s_fgi[1].fgiud07,s_fgi[1].fgiud08,s_fgi[1].fgiud09
                       ,s_fgi[1].fgiud10,s_fgi[1].fgiud11,s_fgi[1].fgiud12
                       ,s_fgi[1].fgiud13,s_fgi[1].fgiud14,s_fgi[1].fgiud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp
           CASE
              WHEN INFIELD(fgi06) #詢價單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fgi06
                 NEXT FIELD fgi06
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
 
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
   #No.FUN-D40121 ---Add--- Start
    ELSE
       LET g_wc = " fgh01 = '",g_argv2,"'"
       LET g_wc2= " 1=1"
    END IF
   #No.FUN-D40121 ---Add--- End
 
    LET g_wc = g_wc CLIPPED, " AND fgh03 = '",g_argv1,"'"

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fghuser', 'fghgrup')
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT fgh01 FROM fgh_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1 "
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT fgh01 ",
                   "  FROM fgh_file, fgi_file ",
                   " WHERE fgh01 = fgi01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE i102_prepare FROM g_sql
    DECLARE i102_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i102_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fgh_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT fgh01) FROM fgh_file,fgi_file WHERE ",
                  " fgi01=fgh01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i102_precount FROM g_sql
    DECLARE i102_count CURSOR FOR i102_precount
END FUNCTION
 
#Add  輸入
FUNCTION i102_a()
  DEFINE li_result   LIKE type_file.num5         #No.FUN-680070 SMALLINT
    MESSAGE ""
    CLEAR FORM
    CALL g_fgi.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_fgh.* LIKE fgh_file.*             #DEFAULT 設定
    LET g_fgh01_t = NULL
    LET g_fgh_t.* = g_fgh.*
    LET g_fgh_o.* = g_fgh.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fgh.fgh02 = g_today

        #-----No:FUN-AB0088-----
        CASE g_argv1
           WHEN "1"
              LET g_fgh.fgh03 = '1' #財簽
           WHEN "2"
              LET g_fgh.fgh03 = '2' #稅簽
           WHEN "3"
              LET g_fgh.fgh03 = '3' #財簽二
        END CASE
       #IF g_argv1 = '1' THEN
       #   LET g_fgh.fgh03 = '1'  #財簽
       #ELSE
       #   LET g_fgh.fgh03 = '2'  #稅簽
       #END IF
       #-----No:FUN-AB0088 END-----
        LET g_fgh.fghconf='N'
        LET g_fgh.fghuser=g_user
        LET g_fgh.fghoriu = g_user #FUN-980030
        LET g_fgh.fghorig = g_grup #FUN-980030
        LET g_fgh.fghgrup=g_grup
        LET g_fgh.fghdate=g_today
        LET g_fgh.fghacti='Y'             #資料有效
 
        LET g_fgh.fghlegal=g_legal        #FUN-980003 add
 
        CALL i102_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_fgh.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_fgh.fgh01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
 
        BEGIN WORK
        CALL s_auto_assign_no("afa",g_fgh.fgh01,g_fgh.fgh02,"F","fgh_file","fgh01","","","")
             RETURNING li_result,g_fgh.fgh01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fgh.fgh01
 
        INSERT INTO fgh_file VALUES (g_fgh.*)
        LET g_t1 = s_get_doc_no(g_fgh.fgh01)       #No.FUN-550034
        IF SQLCA.sqlcode THEN                 #置入資料庫不成功
            CALL cl_err3("ins","fgh_file",g_fgh.fgh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        COMMIT WORK
        CALL cl_flow_notify(g_fgh.fgh01,'I')
        SELECT fgh01 INTO g_fgh.fgh01 FROM fgh_file
            WHERE fgh01 = g_fgh.fgh01
        LET g_fgh01_t = g_fgh.fgh01        #保留舊值
        LET g_fgh_t.* = g_fgh.*
        LET g_fgh_o.* = g_fgh.*
        LET g_rec_b=0
        CALL i102_g_b(10,20)
        CALL i102_b()                      #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i102_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fgh.fgh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_fgh.* FROM fgh_file WHERE fgh01=g_fgh.fgh01
    IF g_fgh.fghacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_fgh.fgh01,'mfg1000',0)
        RETURN
    END IF
    IF g_fgh.fghconf ='Y' THEN    #檢查資料是否為確認
        CALL cl_err(g_fgh.fgh01,'axm-101',0)
        RETURN
    END IF
    IF g_fgh.fghconf ='X' THEN RETURN END IF  #CHI-C80041
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fgh01_t = g_fgh.fgh01
    BEGIN WORK
 
    OPEN i102_cl USING g_fgh.fgh01
    IF STATUS THEN
       CALL cl_err("OPEN i102_cl:", STATUS, 1)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i102_cl INTO g_fgh.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fgh.fgh01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i102_cl
        RETURN
    END IF
    CALL i102_show()
    WHILE TRUE
        LET g_fgh01_t = g_fgh.fgh01
        LET g_fgh_o.* = g_fgh.*
        LET g_fgh.fghmodu=g_user
        LET g_fgh.fghdate=g_today
        CALL i102_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fgh.*=g_fgh_t.*
            CALL i102_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_fgh.fgh01 != g_fgh01_t THEN            # 更改單號
            UPDATE fgi_file SET fgi01 = g_fgh.fgh01
                WHERE fgi01 = g_fgh01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","fgi_file",g_fgh01_t,"",SQLCA.sqlcode,"","fgi",1)  #No.FUN-660136
                CONTINUE WHILE
            END IF
        END IF
        UPDATE fgh_file SET fgh_file.* = g_fgh.*
            WHERE fgh01 = g_fgh.fgh01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","fgh_file",g_fgh01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i102_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fgh.fgh01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION i102_i(p_cmd)
DEFINE
    l_pmc05   LIKE pmc_file.pmc05,
    l_pmc30   LIKE pmc_file.pmc30,
    l_n,l_yy,l_mm  LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    l_yy1,l_mm1    LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
DEFINE li_result   LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE l_bdate,l_edate  LIKE type_file.dat      #MOD-990113 add
 
    IF s_shut(0) THEN RETURN END IF
 
    DISPLAY BY NAME
        g_fgh.fgh01,g_fgh.fgh02, g_fgh.fghconf,g_fgh.fghuser,
        g_fgh.fghgrup,g_fgh.fghmodu,g_fgh.fghdate,g_fgh.fghacti
    CALL cl_set_head_visible("","YES")        #No.FUN-6B0029 
 
    INPUT BY NAME g_fgh.fghoriu,g_fgh.fghorig,
        g_fgh.fgh01,g_fgh.fgh02,g_fgh.fghconf,g_fgh.fghuser,
        g_fgh.fghgrup,g_fgh.fghmodu,g_fgh.fghdate,g_fgh.fghacti,
        g_fgh.fghud01,g_fgh.fghud02,g_fgh.fghud03,g_fgh.fghud04,
        g_fgh.fghud05,g_fgh.fghud06,g_fgh.fghud07,g_fgh.fghud08,
        g_fgh.fghud09,g_fgh.fghud10,g_fgh.fghud11,g_fgh.fghud12,
        g_fgh.fghud13,g_fgh.fghud14,g_fgh.fghud15 
                      WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i102_set_entry(p_cmd)
            CALL i102_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("fgh01")
 
        AFTER FIELD fgh01
            IF NOT cl_null(g_fgh.fgh01) AND (g_fgh.fgh01!=g_fgh01_t) THEN
    CALL s_check_no("afa",g_fgh.fgh01,g_fgh01_t,"F","fgh_file","fgh01","")
         RETURNING li_result,g_fgh.fgh01
    DISPLAY BY NAME g_fgh.fgh01
       IF (NOT li_result) THEN
          NEXT FIELD fgh01
       END IF

            END IF
 
            AFTER FIELD fgh02    #BUGNO:5259

              IF g_fgh.fgh03 = '1'OR g_fgh.fgh03 = '3' THEN     #財簽     #No:FUN-AB0088
                 CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate
              ELSE
                 CALL s_azn01(g_faa.faa11,g_faa.faa12) RETURNING l_bdate,l_edate
              END IF
              IF g_fgh.fgh02 < l_bdate OR g_fgh.fgh02 > l_edate THEN
                 CALL cl_err('','afa-308',0)
                 NEXT FIELD fgh02
              END IF
 
 
            AFTER FIELD fghud01
               IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
            
            AFTER FIELD fghud02
               IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
              #-----No:FUN-B60140-----
               CASE g_fgh.fgh03
                  WHEN "1"
                     CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate
                  WHEN "2"
                     CALL s_azn01(g_faa.faa11,g_faa.faa12) RETURNING l_bdate,l_edate
                  WHEN "3"
                     CALL s_azn01(g_faa.faa072,g_faa.faa082) RETURNING l_bdate,l_edate
               END CASE
              #-----No:FUN-B60140 END----- 
            AFTER FIELD fghud03
               IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
            AFTER FIELD fghud04
               IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
            AFTER FIELD fghud05
               IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
            AFTER FIELD fghud06
               IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
            AFTER FIELD fghud07
               IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
            AFTER FIELD fghud08
               IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
            AFTER FIELD fghud09
               IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
            AFTER FIELD fghud10
               IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
            AFTER FIELD fghud11
               IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
            AFTER FIELD fghud12
               IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
            AFTER FIELD fghud13
               IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
            AFTER FIELD fghud14
               IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
            AFTER FIELD fghud15
               IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
            ON ACTION controlp
            CASE
               WHEN INFIELD(fgh01) #單別
                  CALL q_fah( FALSE, TRUE,g_fgh.fgh01,'F','AFA') RETURNING g_fgh.fgh01   #TQC-670008
                  DISPLAY BY NAME g_fgh.fgh01
                  NEXT FIELD fgh01
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
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
END FUNCTION
 
FUNCTION i102_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fgh01",TRUE)
    END IF
 
END FUNCTION
FUNCTION i102_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fgh01",FALSE)
    END IF
 
END FUNCTION
 
#Query 查詢
FUNCTION i102_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fgh.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_fgi.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i102_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_fgh.* TO NULL
        RETURN
    END IF
    OPEN i102_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fgh.* TO NULL
    ELSE
        OPEN i102_count
        FETCH i102_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i102_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i102_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i102_cs INTO g_fgh.fgh01
        WHEN 'P' FETCH PREVIOUS i102_cs INTO g_fgh.fgh01
        WHEN 'F' FETCH FIRST    i102_cs INTO g_fgh.fgh01
        WHEN 'L' FETCH LAST     i102_cs INTO g_fgh.fgh01
        WHEN '/'
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
         FETCH ABSOLUTE g_jump i102_cs INTO g_fgh.fgh01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fgh.fgh01,SQLCA.sqlcode,0)
        INITIALIZE g_fgh.* TO NULL  #TQC-6B0105
        LET g_fgh.fgh01 = NULL      #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_fgh.* FROM fgh_file WHERE fgh01 = g_fgh.fgh01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","fgh_file",g_fgh.fgh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
        INITIALIZE g_fgh.* TO NULL
        RETURN
    ELSE
       LET g_data_owner=g_fgh.fghuser   #FUN-4C0059
       LET g_data_group=g_fgh.fghgrup   #FUN-4C0059
       CALL i102_show()
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i102_show()
    LET g_fgh_t.* = g_fgh.*                #保存單頭舊值
    LET g_fgh_o.* = g_fgh.*                #保存單頭舊值
    DISPLAY BY NAME g_fgh.fghoriu,g_fgh.fghorig,                              # 顯示單頭值
        g_fgh.fgh01,g_fgh.fgh02,g_fgh.fghconf,g_fgh.fghuser,
        g_fgh.fghgrup,g_fgh.fghmodu,g_fgh.fghdate,g_fgh.fghacti,
        g_fgh.fghud01,g_fgh.fghud02,g_fgh.fghud03,g_fgh.fghud04,
        g_fgh.fghud05,g_fgh.fghud06,g_fgh.fghud07,g_fgh.fghud08,
        g_fgh.fghud09,g_fgh.fghud10,g_fgh.fghud11,g_fgh.fghud12,
        g_fgh.fghud13,g_fgh.fghud14,g_fgh.fghud15 
 
    CALL i102_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i102_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_fgh.fgh01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_fgh.fghconf = 'Y' THEN RETURN END IF
    IF g_fgh.fghconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_fgh.fghacti = 'N' THEN RETURN END IF
    BEGIN WORK
 
    OPEN i102_cl USING g_fgh.fgh01
    IF STATUS THEN
       CALL cl_err("OPEN i102_cl:", STATUS, 1)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i102_cl INTO g_fgh.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fgh.fgh01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i102_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fgh01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fgh.fgh01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
            DELETE FROM fgh_file WHERE fgh01 = g_fgh.fgh01
            DELETE FROM fgi_file WHERE fgi01 = g_fgh.fgh01
            CLEAR FORM
            CALL g_fgi.clear()
         OPEN i102_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i102_cs
             CLOSE i102_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i102_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i102_cs
             CLOSE i102_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i102_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i102_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i102_fetch('/')
         END IF
    END IF
    CLOSE i102_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fgh.fgh01,'D')
END FUNCTION
 
#單身
FUNCTION i102_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    l_fgi04         LIKE fgi_file.fgi04,
    l_fgi05         LIKE fgi_file.fgi05,
    l_fgi10         LIKE fgi_file.fgi10,
    l_fgi08         LIKE fgi_file.fgi08,
    l_fgi09         LIKE fgi_file.fgi09,
    l_faj36         LIKE faj_file.faj36,
    l_faj35         LIKE faj_file.faj35,
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_fgh.fgh01 IS NULL THEN RETURN END IF
    SELECT * INTO g_fgh.* FROM fgh_file WHERE fgh01=g_fgh.fgh01
    IF g_fgh.fghacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_fgh.fgh01,'mfg1000',0)
        RETURN
    END IF
    IF g_fgh.fghconf='Y' THEN RETURN END IF
    IF g_fgh.fghconf ='X' THEN RETURN END IF  #CHI-C80041
    LET g_success='Y'
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT fgi02,fgi06,fgi07,fgi04,fgi05,'','',",  #MOD-990151 add ''
                       "       fgi11,fgi10,fgi08,fgi09, ",
                       #No.FUN-850068 --start--
                       "       fgiud01,fgiud02,fgiud03,fgiud04,fgiud05,",
                       "       fgiud06,fgiud07,fgiud08,fgiud09,fgiud10,",
                       "       fgiud11,fgiud12,fgiud13,fgiud14,fgiud15 ", 
                       #No.FUN-850068 ---end---
                       " FROM fgi_file ",
                       " WHERE fgi01=? AND fgi02=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i102_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_fgi.clear() END IF
 
 
        INPUT ARRAY g_fgi WITHOUT DEFAULTS FROM s_fgi.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN i102_cl USING g_fgh.fgh01
            IF STATUS THEN
               CALL cl_err("OPEN i102_cl:", STATUS, 1)
               CLOSE i102_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i102_cl INTO g_fgh.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_fgh.fgh01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i102_cl
              RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_fgi_t.* = g_fgi[l_ac].*  #BACKUP
 
                OPEN i102_bcl USING g_fgh.fgh01,g_fgi_t.fgi02
                IF STATUS THEN
                   CALL cl_err("OPEN i102_bcl:", STATUS, 1)
                   CLOSE i102_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i102_bcl INTO g_fgi[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_fgi_t.fgi02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                FETCH i102_bcl INTO g_fgi[l_ac].*
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            IF l_ac <= l_n then                  #DISPLAY NEWEST
                CALL i102_fgi07('a',g_fgi[l_ac].fgi06,g_fgi[l_ac].fgi07)
                  RETURNING l_fgi04,l_fgi05,
                            g_fgi[l_ac].faj31,g_fgi[l_ac].fgi11,
                            l_fgi10,l_fgi08,l_fgi09
               LET g_fgi[l_ac].faj35 = l_fgi09   #MOD-990151 add
               DISPLAY BY NAME g_fgi[l_ac].fgi11,g_fgi[l_ac].faj31,  #MOD-990151 add
                               g_fgi[l_ac].faj35                     #MOD-990151 add
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              INITIALIZE g_fgi[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fgi[l_ac].* TO s_fgi.*
              CALL g_fgi.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
            END IF
            INSERT INTO fgi_file(fgi01,fgi02,fgi04,fgi05,fgi06,
                                 fgi07,fgi08,fgi09,fgi10,fgi11,
                                 fgiud01,fgiud02,fgiud03,
                                 fgiud04,fgiud05,fgiud06,
                                 fgiud07,fgiud08,fgiud09,
                                 fgiud10,fgiud11,fgiud12,
                                 fgiud13,fgiud14,fgiud15,
                                 fgilegal)   #FUN-980003 add
            VALUES(g_fgh.fgh01,g_fgi[l_ac].fgi02,
                   g_fgi[l_ac].fgi04,g_fgi[l_ac].fgi05,
                   g_fgi[l_ac].fgi06,g_fgi[l_ac].fgi07,
                   g_fgi[l_ac].fgi08,g_fgi[l_ac].fgi09,
                   g_fgi[l_ac].fgi10,g_fgi[l_ac].fgi11,
                   g_fgi[l_ac].fgiud01,g_fgi[l_ac].fgiud02,
                   g_fgi[l_ac].fgiud03,g_fgi[l_ac].fgiud04,
                   g_fgi[l_ac].fgiud05,g_fgi[l_ac].fgiud06,
                   g_fgi[l_ac].fgiud07,g_fgi[l_ac].fgiud08,
                   g_fgi[l_ac].fgiud09,g_fgi[l_ac].fgiud10,
                   g_fgi[l_ac].fgiud11,g_fgi[l_ac].fgiud12,
                   g_fgi[l_ac].fgiud13,g_fgi[l_ac].fgiud14,
                   g_fgi[l_ac].fgiud15,
                   g_legal)     #FUN-980003 add
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","fgi_file",g_fgh.fgh01,g_fgi[l_ac].fgi02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                CANCEL INSERT
            ELSE
                IF g_success='Y' THEN
                   COMMIT WORK
                ELSE
                   CALL cl_rbmsg(1) ROLLBACK WORK
                END IF
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_fgi[l_ac].* TO NULL       #900423
            LET g_fgi_t.* = g_fgi[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fgi02
 
        BEFORE FIELD fgi02                        #default 序號
            IF g_fgi[l_ac].fgi02 IS NULL OR g_fgi[l_ac].fgi02 = 0 THEN
                SELECT max(fgi02)+1
                   INTO g_fgi[l_ac].fgi02
                   FROM fgi_file
                   WHERE fgi01 = g_fgh.fgh01
                IF g_fgi[l_ac].fgi02 IS NULL THEN
                    LET g_fgi[l_ac].fgi02 = 1
                END IF
            END IF
 
        AFTER FIELD fgi02                        #check 序號是否重複
            IF NOT g_fgi[l_ac].fgi02 IS NULL THEN
               IF g_fgi[l_ac].fgi02 != g_fgi_t.fgi02 OR
                  g_fgi_t.fgi02 IS NULL THEN
                   SELECT count(*) INTO l_n
                       FROM fgi_file
                       WHERE fgi01 = g_fgh.fgh01 AND
                             fgi02 = g_fgi[l_ac].fgi02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_fgi[l_ac].fgi02 = g_fgi_t.fgi02
                       NEXT FIELD fgi02
                   END IF
               END IF
            END IF
 
        AFTER FIELD fgi06
           IF NOT cl_null(g_fgi[l_ac].fgi06) THEN
              SELECT * FROM faj_file
               WHERE faj02 = g_fgi[l_ac].fgi06
              IF STATUS = 100 THEN
                 CALL cl_err3("sel","faj_file",g_fgi[l_ac].fgi06,"",SQLCA.sqlcode,"","sel faj:",1)  #No.FUN-660136
                 NEXT FIELD fgi06
              END IF
           END IF
 
        AFTER FIELD fgi07
           IF g_fgi[l_ac].fgi07 IS NULL THEN LET g_fgi[l_ac].fgi07 = ' ' END IF

          #-MOD-C20086-add-
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt 
             FROM fgh_file,fgi_file
            WHERE fgh01 = fgh01 AND fgi06 = g_fgi[l_ac].fgi06 
              AND fgi07 = g_fgi[l_ac].fgi07
              AND fgh01 = g_fgh.fgh01
           IF l_cnt > 0 THEN
              CALL cl_err(g_fgi[l_ac].fgi06,'aec-010',0)
              LET g_fgi[l_ac].fgi06 = g_fgi_t.fgi06
              LET g_fgi[l_ac].fgi07 = g_fgi_t.fgi07
              NEXT FIELD fgi06
           END IF
          #-MOD-C20086-end-

           IF (g_fgi[l_ac].fgi06 != g_fgi_t.fgi06 OR
                g_fgi_t.fgi06 IS NULL) OR
               (g_fgi[l_ac].fgi07 != g_fgi_t.fgi07 OR
                g_fgi_t.fgi07 IS NULL) THEN
            # IF g_argv1 = '1' THEN   #CHI-860025
              CASE g_argv1   #No:FUN-AB0088
                 WHEN '1'    #財簽   #No:FUN-AB0088
                    LET l_cnt = 0    #MOD-C20086
                    SELECT COUNT(*) INTO l_cnt FROM fan_file
                     WHERE fan01 = g_fgi[l_ac].fgi06
                       AND fan02 = g_fgi[l_ac].fgi07
                       AND ((fan03 = YEAR(g_fgh.fgh02) AND
                             fan04>= MONTH(g_fgh.fgh02)) OR
                             fan03 > YEAR(g_fgh.fgh02))
                       AND fan041 = '1'   #MOD-BC0025 add
           #  ELSE
                 WHEN '2'    #稅簽    #No:FUN-AB0088
                    LET l_cnt = 0    #MOD-C20086
                    SELECT COUNT(*) INTO l_cnt FROM fao_file
                     WHERE fao01 = g_fgi[l_ac].fgi06
                      AND fao02 = g_fgi[l_ac].fgi07
                      AND ((fao03 = YEAR(g_fgh.fgh02) AND
                            fao04>= MONTH(g_fgh.fgh02)) OR
                            fao03 > YEAR(g_fgh.fgh02))
                      AND fao041 = '1'   #MOD-BC0025 add
                 #-----No:FUN-AB0088-----
                 WHEN '3'    #財簽二
                    LET l_cnt = 0    #MOD-C20086
                    SELECT COUNT(*) INTO l_cnt FROM fbn_file
                     WHERE fbn01 = g_fgi[l_ac].fgi06
                       AND fbn02 = g_fgi[l_ac].fgi07
                       AND ((fbn03 = YEAR(g_fgh.fgh02) AND
                             fbn04>= MONTH(g_fgh.fgh02)) OR
                             fbn03 > YEAR(g_fgh.fgh02))
                       AND fbn041 = '1'   #MOD-BC0025 add
                 #-----No:FUN-AB0088 END-----
           #  END IF    #No:FUN-AB0088
              END CASE
              IF l_cnt > 0 THEN
                 CALL cl_err(g_fgi[l_ac].fgi06,'afa-092',0)
                 NEXT FIELD fgi07
              END IF
              CALL i102_fgi07('a',g_fgi[l_ac].fgi06,g_fgi[l_ac].fgi07)
                   RETURNING g_fgi[l_ac].fgi04,g_fgi[l_ac].fgi05,
                             g_fgi[l_ac].faj31,g_fgi[l_ac].fgi11,
                             l_fgi10,l_faj36,g_fgi[l_ac].faj35  #MOD-990151 mod
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD fgi07
              ELSE
                 IF cl_null(g_fgi[l_ac].fgi10) THEN
                    LET g_fgi[l_ac].fgi10 = l_fgi10
                 END IF
                 IF cl_null(g_fgi[l_ac].fgi08) THEN
                    LET g_fgi[l_ac].fgi08 = l_faj36
                 END IF
                 IF cl_null(g_fgi[l_ac].fgi09) THEN
                    LET g_fgi[l_ac].fgi09 = g_fgi[l_ac].faj35  #MOD-990151 mod
                 END IF
                 DISPLAY g_fgi[l_ac].fgi04 TO fgi04
                 DISPLAY g_fgi[l_ac].fgi05 TO fgi05
                 DISPLAY g_fgi[l_ac].faj31 TO faj31
                 DISPLAY g_fgi[l_ac].faj35 TO faj35   #MOD-990151 add
                 DISPLAY g_fgi[l_ac].fgi11 TO fgi11
                 DISPLAY g_fgi[l_ac].fgi10 TO fgi10
                 DISPLAY g_fgi[l_ac].fgi08 TO fgi08
                 DISPLAY g_fgi[l_ac].fgi09 TO fgi09
              END IF
            END IF
            CALL i102_fgi07('a',g_fgi[l_ac].fgi06,g_fgi[l_ac].fgi07)
                RETURNING l_fgi04,l_fgi05,
                          g_fgi[l_ac].faj31,g_fgi[l_ac].fgi11,
                          l_fgi10,l_faj36,g_fgi[l_ac].faj35  #MOD-990151 mod
            DISPLAY BY NAME g_fgi[l_ac].faj31  #MOD-5A0095
            DISPLAY BY NAME g_fgi[l_ac].fgi11  #MOD-990151 add
            DISPLAY BY NAME g_fgi[l_ac].faj35  #MOD-990151 add
 
        AFTER FIELD fgi10
            IF NOT cl_null(g_fgi[l_ac].fgi10) THEN
               IF g_fgi[l_ac].fgi10 NOT MATCHES '[YN]' THEN
                  NEXT FIELD fgi10
               END IF
               IF g_fgi[l_ac].fgi10 = 'N' THEN
                  LET g_fgi[l_ac].fgi08 = 0
                  LET g_fgi[l_ac].fgi09 = 0
                  DISPLAY g_fgi[l_ac].fgi08 TO fgi08
                  DISPLAY g_fgi[l_ac].fgi09 TO fgi09
               END IF
            END IF
 
        AFTER FIELD fgi08
          IF g_fgi[l_ac].fgi10 = 'N' THEN
             LET g_fgi[l_ac].fgi08 = 0
          ELSE
             IF g_faa.faa25 = 0 THEN    #預設殘值年限
                LET g_fgi[l_ac].fgi09 = 0
             ELSE
                IF g_argv1 = '1'OR g_argv1 = '3'  THEN   #財簽    #MOD-890272 add  #No:FUN-AB0088
                   IF g_fgi[l_ac].fgi11 = '7' THEN   #折畢續提   #MOD-780039
                      LET g_fgi[l_ac].fgi09 =
                         g_fgi[l_ac].faj35/(g_fgi[l_ac].fgi08+g_faa.faa25)*g_faa.faa25   #MOD-990151 mod
                   ELSE
                      LET g_fgi[l_ac].fgi09 =
                         g_fgi[l_ac].faj31/(g_fgi[l_ac].fgi08+g_faa.faa25)*g_faa.faa25
                   END IF
                ELSE                    #稅簽
                   IF g_fgi[l_ac].fgi11 = '7' THEN   #折畢續提
                      LET g_fgi[l_ac].fgi09 = g_fgi[l_ac].faj35/10  #MOD-990151 mod
                   ELSE
                      LET g_fgi[l_ac].fgi09 = g_fgi[l_ac].faj31/10
                   END IF
                END IF
              END IF
              LET g_fgi[l_ac].fgi09 = cl_digcut(g_fgi[l_ac].fgi09,g_azi04) #MOD-B30374
              DISPLAY BY NAME g_fgi[l_ac].fgi09
            END IF
 
        AFTER FIELD fgi09
            IF g_fgi[l_ac].fgi10 = 'N' THEN LET g_fgi[l_ac].fgi09 = 0 END IF
             DISPLAY BY NAME g_fgi[l_ac].fgi10
 
        AFTER FIELD fgiud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgiud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgiud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgiud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgiud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgiud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgiud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgiud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgiud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgiud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgiud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgiud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgiud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgiud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgiud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_fgi_t.fgi02 > 0 AND
               g_fgi_t.fgi02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM fgi_file
                    WHERE fgi01 = g_fgh.fgh01 AND
                          fgi02 = g_fgi_t.fgi02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","fgi_file",g_fgh.fgh01,g_fgi_t.fgi02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fgi[l_ac].* = g_fgi_t.*
               CLOSE i102_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fgi[l_ac].fgi02,-263,1)
               LET g_fgi[l_ac].* = g_fgi_t.*
            ELSE
               UPDATE fgi_file SET
                      fgi02=g_fgi[l_ac].fgi02,fgi04=g_fgi[l_ac].fgi04,
                      fgi05=g_fgi[l_ac].fgi05,fgi06=g_fgi[l_ac].fgi06,
                      fgi07=g_fgi[l_ac].fgi07,fgi08=g_fgi[l_ac].fgi08,
                      fgi09=g_fgi[l_ac].fgi09,fgi10=g_fgi[l_ac].fgi10,
                      fgi11=g_fgi[l_ac].fgi11,
                      fgiud01 = g_fgi[l_ac].fgiud01,
                      fgiud02 = g_fgi[l_ac].fgiud02,
                      fgiud03 = g_fgi[l_ac].fgiud03,
                      fgiud04 = g_fgi[l_ac].fgiud04,
                      fgiud05 = g_fgi[l_ac].fgiud05,
                      fgiud06 = g_fgi[l_ac].fgiud06,
                      fgiud07 = g_fgi[l_ac].fgiud07,
                      fgiud08 = g_fgi[l_ac].fgiud08,
                      fgiud09 = g_fgi[l_ac].fgiud09,
                      fgiud10 = g_fgi[l_ac].fgiud10,
                      fgiud11 = g_fgi[l_ac].fgiud11,
                      fgiud12 = g_fgi[l_ac].fgiud12,
                      fgiud13 = g_fgi[l_ac].fgiud13,
                      fgiud14 = g_fgi[l_ac].fgiud14,
                      fgiud15 = g_fgi[l_ac].fgiud15
               WHERE fgi01=g_fgh.fgh01 AND fgi02=g_fgi_t.fgi02
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","fgi_file",g_fgh.fgh01,g_fgi_t.fgi02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                   LET g_fgi[l_ac].* = g_fgi_t.*
               ELSE
                   IF g_success='Y' THEN
                      COMMIT WORK
                   ELSE
                      CALL cl_rbmsg(1) ROLLBACK WORK
                   END IF
                   MESSAGE 'UPDATE O.K'
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac     #FUN-D30032 mark
            IF cl_null(g_fgi[l_ac].fgi08) THEN
               LET g_fgi[l_ac].fgi08 = 0
            END IF
            IF cl_null(g_fgi[l_ac].fgi09) THEN
               LET g_fgi[l_ac].fgi09 = 0
            END IF
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                 LET g_fgi[l_ac].* = g_fgi_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_fgi.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
               END IF
               CLOSE i102_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
            CLOSE i102_bcl
            COMMIT WORK
            CALL g_fgi.deleteElement(g_rec_b+1)
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fgi02) AND l_ac > 1 THEN
                LET g_fgi[l_ac].* = g_fgi[l_ac-1].*
                LET g_fgi[l_ac].fgi02 = NULL   #TQC-620018
                NEXT FIELD fgi02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
        ON ACTION controlp
           CASE
              WHEN INFIELD(fgi06) #詢價單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.default1 = g_fgi[l_ac].fgi06
                 LET g_qryparam.default2 = g_fgi[l_ac].fgi07
                 CALL cl_create_qry() RETURNING g_fgi[l_ac].fgi06,g_fgi[l_ac].fgi07
                 DISPLAY g_fgi[l_ac].fgi06 TO fgi06
                 DISPLAY g_fgi[l_ac].fgi07 TO fgi07
                 NEXT FIELD fgi06
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
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT
 
    LET g_fgh.fghmodu = g_user
    LET g_fgh.fghdate = g_today
    UPDATE fgh_file SET fghmodu = g_fgh.fghmodu,fghdate = g_fgh.fghdate
     WHERE fgh01 = g_fgh.fgh01
    DISPLAY BY NAME g_fgh.fghmodu,g_fgh.fghdate
 
    CLOSE i102_bcl
    COMMIT WORK
#   CALL i102_delall()   #CHI-C30002 mark
    CALL i102_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i102_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fgh.fgh01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fgh_file ",
                  "  WHERE fgh01 LIKE '",l_slip,"%' ",
                  "    AND fgh01 > '",g_fgh.fgh01,"'"
      PREPARE i102_pb1 FROM l_sql 
      EXECUTE i102_pb1 INTO l_cnt      
      
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
        #CALL i102_v()    #FUN-D20095 mark
         CALL i102_v(1)   #FUN-D20095
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fgh_file WHERE fgh01 = g_fgh.fgh01
         INITIALIZE g_fgh.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#CHI-C30002 -------- mark -------- begin
#FUNCTION i102_delall()
#   SELECT COUNT(*) INTO g_cnt FROM fgi_file
#       WHERE fgi01 = g_fgh.fgh01
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM fgh_file WHERE fgh01 = g_fgh.fgh01   #NO:7341 WHERE fgi01寫錯已更正fgh01
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i102_fgi04()
DEFINE p_cmd        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_fab04      LIKE fab_file.fab04,
       l_fab08      LIKE fab_file.fab08,
       l_fab10      LIKE fab_file.fab10
 
     LET g_errno = ' '
     SELECT fab04,fab08,fab10 INTO l_fab04,l_fab08,l_fab10
       FROM fab_file
      WHERE fab01 = g_fgi[l_ac].fgi04 AND fab04 = '1'
     CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-045'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
END FUNCTION
 
FUNCTION i102_fgi07(p_cmd,l_fgi06,l_fgi07)
DEFINE p_cmd        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_fgi06      LIKE fgi_file.fgi06,
       l_fgi07      LIKE fgi_file.fgi07,
       l_faj04      LIKE faj_file.faj04,
       l_faj05      LIKE faj_file.faj05,
       l_faj31      LIKE faj_file.faj31,
       l_faj43      LIKE faj_file.faj43,
       l_faj34      LIKE faj_file.faj34,
       l_faj36      LIKE faj_file.faj36,
       l_faj35      LIKE faj_file.faj35,
       l_faj33      LIKE faj_file.faj33   #MOD-780039
 
   LET g_errno = ' '
 # IF g_argv1 = '1' THEN #財簽 
   CASE g_argv1   #No:FUN-AB0088
       WHEN '1'   #財簽
          SELECT faj04,faj05,faj31,faj43,faj36,faj35,faj34,faj33   #MOD-780039
           INTO l_faj04,l_faj05,l_faj31,l_faj43,l_faj36,l_faj35,l_faj34,l_faj33   #MOD-780039
           FROM faj_file
           WHERE faj02 = l_fgi06 AND faj022= l_fgi07
             AND faj28 IN ('1','3') AND faj31 > 0   #MOD-890214
             AND ((faj43 = '4' AND faj33 > 0)
             OR (faj43  IN ('7') ))   #TQC-630004
#  ELSE
      WHEN '2'   #稅簽
         SELECT faj04,faj05,faj66,faj201,faj73,faj72,faj71,faj68   #MOD-780039
           INTO l_faj04,l_faj05,l_faj31,l_faj43,l_faj36,l_faj35,l_faj34,l_faj33   #MOD-780039
           FROM faj_file
          WHERE faj02 = l_fgi06 AND faj022= l_fgi07
            AND faj61 IN ('1','3') AND faj66 > 0   #MOD-890214
            AND ((faj201 = '4' AND faj68 > 0)
            OR (faj201  IN ('7') ))   #TQC-630004
      #-----No:FUN-AB0088-----
       WHEN '3'   #財簽二
          SELECT faj04,faj05,faj312,faj432,faj362,faj352,faj342,faj332
            INTO l_faj04,l_faj05,l_faj31,l_faj43,l_faj36,l_faj35,l_faj34,l_faj33
            FROM faj_file
           WHERE faj02 = l_fgi06 AND faj022= l_fgi07
            #AND faj282 MATCHES '[13]' AND faj312 > 0   #MOD-BA0133 mark
             AND faj282 IN ('1','3') AND faj312 > 0     #MOD-BA0133
             AND ((faj432 = '4' AND faj332 > 0)
             #OR (faj432 MATCHES '[7]' ))               #MOD-BA0133 mark
              OR (faj432 IN ('7')))                     #MOD-BA0133
      #-----No:FUN-AB0088 END-----
  #END IF
   END CASE   #No:FUN-AB0088
   IF l_faj31 > l_faj33 THEN
      LET l_faj31 = l_faj33
   END IF
   CASE
      WHEN SQLCA.SQLCODE = 100  LET g_errno = 'afa-919'   #MOD-9C0282 g_errno取消mark
      OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(l_faj04) THEN LET l_faj04=' ' END IF   #MOD-990151 add
   IF cl_null(l_faj05) THEN LET l_faj05=' ' END IF   #MOD-990151 add
   IF cl_null(l_faj31) THEN LET l_faj31=0   END IF   #MOD-990151 add
   IF cl_null(l_faj43) THEN LET l_faj43=' ' END IF   #MOD-990151 add
   IF cl_null(l_faj34) THEN LET l_faj34=' ' END IF   #MOD-990151 add
   IF cl_null(l_faj36) THEN LET l_faj36=0   END IF   #MOD-990151 add
   IF cl_null(l_faj35) THEN LET l_faj35=0   END IF   #MOD-990151 add
   RETURN l_faj04,l_faj05,l_faj31,l_faj43,l_faj34,l_faj36,l_faj35
END FUNCTION
 
FUNCTION i102_b_askkey()
    CLEAR FORM
   CALL g_fgi.clear()
    CONSTRUCT g_wc2 ON fgi02,fgi06,fgi07,fgi04,fgi05,fgi10,fgi08,fgi09
                       ,fgiud01,fgiud02,fgiud03,fgiud04,fgiud05
                       ,fgiud06,fgiud07,fgiud08,fgiud09,fgiud10
                       ,fgiud11,fgiud12,fgiud13,fgiud14,fgiud15
                  FROM s_fgi[1].fgi02,s_fgi[1].fgi06,
                       s_fgi[1].fgi07,s_fgi[1].fgi04,
                       s_fgi[1].fgi05,s_fgi[1].fgi10,
                       s_fgi[1].fgi08,s_fgi[1].fgi09
                       ,s_fgi[1].fgiud01,s_fgi[1].fgiud02,s_fgi[1].fgiud03
                       ,s_fgi[1].fgiud04,s_fgi[1].fgiud05,s_fgi[1].fgiud06
                       ,s_fgi[1].fgiud07,s_fgi[1].fgiud08,s_fgi[1].fgiud09
                       ,s_fgi[1].fgiud10,s_fgi[1].fgiud11,s_fgi[1].fgiud12
                       ,s_fgi[1].fgiud13,s_fgi[1].fgiud14,s_fgi[1].fgiud15
 
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
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i102_b_fill(g_wc2)
    LET g_modify = 'Y'
END FUNCTION
 
FUNCTION i102_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           STRING,      #No.FUN-680070 VARCHAR(200) #MOD-C20086 mod 1000 -> STRING
       l_fgi04         LIKE fgi_file.fgi04,
       l_fgi05         LIKE fgi_file.fgi05,
       l_fgi10         LIKE fgi_file.fgi10,
       l_fgi11         LIKE fgi_file.fgi11,
       l_faj36         LIKE faj_file.faj36,
       l_faj35         LIKE faj_file.faj35,
       l_faj31         LIKE faj_file.faj31   #MOD-990151 add

    #-----No:FUN-AB0088-----
    IF g_argv1 = '3' THEN   #財簽二
       LET g_sql = "SELECT fgi02,fgi06,fgi07,fgi04,fgi05,faj312,faj352,fgi11,fgi10,fgi08,fgi09, "
    ELSE
       LET g_sql = "SELECT fgi02,fgi06,fgi07,fgi04,fgi05,faj31,faj35,fgi11,fgi10,fgi08,fgi09, "
    END IF
    #-----No:FUN-AB0088 END----- 
 #  LET g_sql =                               #-----No:FUN-AB0088-----
 #      "SELECT fgi02,fgi06,fgi07,fgi04,fgi05,faj31,faj35,fgi11,fgi10,fgi08,fgi09, ",  #MOD-990151 add faj35
    LET g_sql = g_sql,   #No:FUN-AB0088
        "       fgiud01,fgiud02,fgiud03,fgiud04,fgiud05,",
        "       fgiud06,fgiud07,fgiud08,fgiud09,fgiud10,",
        "       fgiud11,fgiud12,fgiud13,fgiud14,fgiud15 ", 
"  FROM fgh_file,fgi_file LEFT OUTER JOIN faj_file ON fgi06 = faj_file.faj02 AND fgi07 = faj_file.faj022 ",
        " WHERE fgh01 = fgi01 ",
        "   AND fgh01 = '",g_fgh.fgh01,"'",
        "   AND ", p_wc2 CLIPPED,                     #單身
        " ORDER BY fgi02 "
 
    PREPARE i102_pb FROM g_sql
    DECLARE fgi_curs CURSOR FOR i102_pb
 
    CALL g_fgi.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH fgi_curs INTO g_fgi[g_cnt].*   #單身 ARRAY 填充  
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       CALL i102_fgi07('a',g_fgi[g_cnt].fgi06,g_fgi[g_cnt].fgi07)
       RETURNING l_fgi04,l_fgi05,l_faj31,         #MOD-990151 mod
                 l_fgi11,l_fgi10,l_faj36,l_faj35  #MOD-990151 mod
       LET g_fgi[g_cnt].faj31=l_faj31   #MOD-990151 add
       LET g_fgi[g_cnt].faj35=l_faj35   #MOD-990151 add
    LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    MESSAGE ""
    CALL g_fgi.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fgi TO s_fgi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION previous
         CALL i102_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i102_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION first
         CALL i102_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i102_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i102_fetch('L')
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
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #FUN-C20095---Begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-C20095---End
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
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i102_g_b(p_row,p_col)         #以下皆為已確認
 DEFINE p_row LIKE type_file.num5         #No.FUN-680070 SMALLINT
 DEFINE p_col LIKE type_file.num5         #No.FUN-680070 SMALLINT
 DEFINE l_wc  STRING      #No.FUN-680070 VARCHAR(300) #MOD-C20086 mod 1000 -> STRING
 DEFINE l_sql STRING      #No.FUN-680070 VARCHAR(900) #MOD-C20086 mod 1000 -> STRING
 DEFINE i       LIKE type_file.num5,         #No.FUN-680070 smallint
        l_year  LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_month LIKE type_file.num5         #No.FUN-680070 SMALLINT
 DEFINE l_fgi RECORD LIKE fgi_file.*
 DEFINE l_faj04    LIKE  faj_file.faj04
 DEFINE l_faj05    LIKE  faj_file.faj05
 DEFINE l_faj02    LIKE  faj_file.faj02
 DEFINE l_faj022   LIKE  faj_file.faj022
 DEFINE l_faj31    LIKE  faj_file.faj31
 DEFINE l_faj35_t  LIKE  faj_file.faj35
 DEFINE l_faj43    LIKE  faj_file.faj43
 DEFINE l_faj36    LIKE  faj_file.faj36
 DEFINE l_faj30    LIKE  faj_file.faj30
 DEFINE l_faj33    LIKE  faj_file.faj33   #MOD-780039
 DEFINE sr   RECORD
             faj34   LIKE faj_file.faj34,  #再提否
             faj36   LIKE faj_file.faj36   #再提年限
             END RECORD
 
   LET p_row = 10 LET p_col = 30
   OPEN WINDOW i102_t_w AT p_row,p_col
        WITH FORM "afa/42f/afai1021"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afai1021")
 
 
   LET sr.faj34 = 'Y' LET sr.faj36 = 24
   WHILE TRUE
      CONSTRUCT BY NAME l_wc ON faj04,faj02,faj022
 
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
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW i102_t_w
         RETURN
      END IF
      IF l_wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
      EXIT WHILE
   END WHILE
 
   INPUT BY NAME sr.faj34,sr.faj36 WITHOUT DEFAULTS
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW i102_t_w RETURN
   END IF
   LET l_year = YEAR(g_fgh.fgh02)
   LET l_month= MONTH(g_fgh.fgh02)
#  IF g_argv1 = '1' THEN #財簽
   CASE g_argv1   #No:FUN-AB0088
      WHEN '1'   #財簽   #No:FUN-AB0088 
         LET l_sql= " SELECT faj02,faj022,faj31,faj43,faj35,faj36,",
                    "        faj30,faj04,faj05,faj33 ",   #MOD-780039
                    "   FROM faj_file ",
                    " WHERE faj28 IN ('1','3') AND faj31 > 0 ",   #MOD-890214
                    " AND ((faj43 = '4' AND faj33 > 0) OR ",
                    "      (faj43  IN ('7') AND faj30 = 0)) ",   #TQC-630004
                    " AND ", l_wc CLIPPED
#  ELSE                  #稅簽
      WHEN '2'           #稅簽   #No:FUN-AB0088
         LET l_sql= " SELECT faj02,faj022,faj66,faj201,faj72,faj73,",
                    "        faj65,faj04,faj05,faj68 ",   #MOD-780039
                    "   FROM faj_file ",
                    " WHERE faj61 IN ('1','3') AND faj66 > 0 ",   #MOD-890214
                    " AND ((faj201 = '4' AND faj68 > 0) OR ",      #No.+154
                    "      (faj201  IN ('7') AND faj65 = 0)) ",   #TQC-630004
                    " AND ", l_wc CLIPPED
      #-----No:FUN-AB0088-----
      WHEN '3'   #財簽二
         LET l_sql= " SELECT faj02,faj022,faj312,faj432,faj352,faj362,",
                    "        faj302,faj04,faj05,faj332 ",
                    "   FROM faj_file ",
                   #" WHERE faj282 MATCHES '[13]' AND faj312 > 0 ",   #MOD-BA0133 mark
                    " WHERE faj282 IN ('1','3') AND faj312 > 0 ",     #MOD-BA0133
                    " AND ((faj432 = '4' AND faj332 > 0) OR ",
                   #"      (faj432 MATCHES '[7]' AND faj302 = 0)) ",  #MOD-BA0133 mark
                    "      (faj432 IN ('7') AND faj302 = 0)) ",       #MOD-BA0133
                    " AND ", l_wc CLIPPED
      #-----No:FUN-AB0088 END-----
  #END IF
   END CASE   #No:FUN-AB0088 
   PREPARE i102_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN
   END IF
   DECLARE i102_curs1 CURSOR WITH HOLD FOR i102_prepare1
 
   LET i = 1
   FOREACH i102_curs1 INTO l_faj02,l_faj022,l_faj31,l_faj43,
                           l_faj35_t,l_faj36,l_faj30,
                           #l_faj04,l_faj05   #MOD-780039
                           l_faj04,l_faj05,l_faj33   #MOD-780039
      IF SQLCA.sqlcode THEN
         CALL cl_err('i102_curs1',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      IF l_faj31 > l_faj33 THEN
         LET l_faj31 = l_faj33
      END IF
  #   IF g_argv1 = '1' THEN #財簽   #NO:4862 
      CASE g_argv1   #No:FUN-AB0088
         WHEN '1'  #財簽   #No:FUN-AB0088 
            SELECT COUNT(*) INTO g_cnt FROM fan_file
              WHERE fan01 = l_faj02       #財編
                AND fan02 = l_faj022      #附號
                AND ((fan03 = l_year AND fan04 >= l_month) # TQC-780089
                OR fan03 > l_year)                        # TQC-780089
                AND fan041 = '1'   #MOD-BC0025 add
  #   ELSE
         WHEN '2'   #稅簽     #No:FUN-AB0088
            SELECT COUNT(*) INTO g_cnt FROM fao_file   #稅簽   #NO:4862
              WHERE fao01 = l_faj02       #財編
                AND fao02 = l_faj022      #附號
                AND ((fao03 = l_year AND fao04 >= l_month) # TQC-780089
                OR fao03 > l_year)                        # TQC-780089
                AND fao041 = '1'   #MOD-BC0025 add
         #-----No:FUN-AB0088-----
         WHEN '3'  #財簽二
            SELECT COUNT(*) INTO g_cnt FROM fbn_file
             WHERE fbn01 = l_faj02       #財編
               AND fbn02 = l_faj022      #附號
               AND ((fbn03 = l_year AND fbn04 >= l_month) # TQC-780089
                OR fbn03 > l_year)                        # TQC-780089
               AND fbn041 = '1'   #MOD-BC0025 add
         #-----No:FUN-AB0088 END-----
     #END IF
      END CASE   #No:FUN-AB0088
      IF g_cnt > 0 THEN
         CALL cl_err(l_faj02,'afa-092',0)      # TQC-780089
         CONTINUE FOREACH
      END IF
      BEGIN WORK LET g_success = 'Y'
         message l_faj02,' ',l_faj022
         INITIALIZE l_fgi.* TO NULL    #FUN-850068 
         LET l_fgi.fgi01 = g_fgh.fgh01
         LET l_fgi.fgi02 = i
         LET l_fgi.fgi04 = l_faj04
         LET l_fgi.fgi05 = l_faj05
         LET l_fgi.fgi06 = l_faj02
         LET l_fgi.fgi07 = l_faj022
         LET l_fgi.fgi10 = sr.faj34
         LET l_fgi.fgi11 = l_faj43
 
         LET l_fgi.fgilegal = g_legal     #FUN-980003 add
 
         IF sr.faj34 = 'N' THEN #不提了
            LET l_fgi.fgi08 = 0
            LET l_fgi.fgi09 = 0
         ELSE
            LET l_fgi.fgi08 = sr.faj36      #再提年限
 
            #計算折畢殘值
            IF g_faa.faa25 = 0 THEN
               LET l_fgi.fgi09 = 0
            ELSE
               IF g_argv1 = '1' OR g_argv1 = '3'  THEN   #財簽    #MOD-890272 add   #No:FUN-AB0088
                  LET l_fgi.fgi09
                      = l_faj31 / (sr.faj36 + g_faa.faa25) * g_faa.faa25
                  IF l_faj43 = '7' THEN   #TQC-630004
                     LET l_fgi.fgi09
                         = l_faj35_t / (sr.faj36 + g_faa.faa25) * g_faa.faa25   #MOD-780039
                  ELSE
                     LET l_fgi.fgi09
                         = l_faj31 / (sr.faj36 + g_faa.faa25) * g_faa.faa25
                  END IF
               ELSE                    #稅簽
                  IF l_faj43 = '7' THEN
                     LET l_fgi.fgi09 = l_faj35_t/10
                  ELSE
                     LET l_fgi.fgi09 = l_faj31/10
                  END IF
               END IF
               LET l_fgi.fgi09 = cl_digcut(l_fgi.fgi09,g_azi04) #MOD-B30374
            END IF
         END IF
         INSERT INTO fgi_file VALUES(l_fgi.*)
         IF STATUS THEN
            CALL cl_err3("ins","fgi_file",l_fgi.fgi01,l_fgi.fgi02,STATUS,"","",1)  #No.FUN-660136
            LET g_success='N'
         END IF
         LET i = i + 1
    IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
  END FOREACH
  CLOSE WINDOW i102_t_w
  CALL i102_b_fill(' 1=1')
END FUNCTION
 
FUNCTION i102_y()
 DEFINE l_fgi RECORD LIKE fgi_file.*
 DEFINE l_faj43  LIKE faj_file.faj43
 DEFINE l_yy,l_mm    LIKE type_file.num5         #No.FUN-680070 SMALLINT
 DEFINE l_yy1,l_mm1  LIKE type_file.num5         #No.FUN-680070 SMALLINT
 DEFINE l_status LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 DEFINE l_faj RECORD LIKE faj_file.*   #TQC-640183
 DEFINE l_cnt   LIKE type_file.num5     #TQC-640183       #No.FUN-680070 SMALLINT
 DEFINE l_azi04 LIKE azi_file.azi04   #CHI-C60010 add
 
   IF g_fgh.fgh01 IS NULL THEN RETURN END IF
#CHI-C30107 ------- add -------- begin
   IF g_fgh.fghconf='Y' THEN RETURN END IF
   IF g_fgh.fghconf ='X' THEN RETURN END IF  #CHI-C80041
   IF g_fgh.fghacti='N' THEN CALL cl_err('','9024',0) RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ------- add -------- end
   SELECT * INTO g_fgh.* FROM fgh_file WHERE fgh01=g_fgh.fgh01
   IF g_fgh.fghconf='Y' THEN RETURN END IF
   IF g_fgh.fghconf ='X' THEN RETURN END IF  #CHI-C80041
   IF g_fgh.fghacti='N' THEN CALL cl_err('','9024',0) RETURN END IF
   #-----No:FUN-B60140--start---
   #-----No:FUN-AB0088-----
   #IF g_fgh.fgh03 = '1' OR g_fgh.fgh03 = '3' THEN     #財簽
   #   LET l_yy= YEAR(g_faa.faa09)
   #   LET l_mm=MONTH(g_faa.faa09)
   #ELSE
   #   LET l_yy= YEAR(g_faa.faa13)
   #   LET l_mm=MONTH(g_faa.faa13)
   #END IF
   #-----No:FUN-AB0088 END-----
   CASE g_fgh.fgh03
      WHEN "1"
         LET l_yy= YEAR(g_faa.faa09)
         LET l_mm=MONTH(g_faa.faa09)
      WHEN "2"
         LET l_yy= YEAR(g_faa.faa13)
         LET l_mm=MONTH(g_faa.faa13)
      WHEN "3"
         LET l_yy= YEAR(g_faa.faa092)
         LET l_mm=MONTH(g_faa.faa092)
    END CASE
    #-----No:FUN-B60140 END-----
   LET l_yy= YEAR(g_faa.faa09)
   LET l_mm=MONTH(g_faa.faa09)
   LET l_yy1=YEAR(g_fgh.fgh02)
   LET l_mm1=MONTH(g_fgh.fgh02)
   IF (l_yy1*12+l_mm1)<=(l_yy*12+l_mm) THEN
      CALL  cl_err('','afa-924',0)
      RETURN	
   END IF
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN i102_cl USING g_fgh.fgh01
   IF STATUS THEN
      CALL cl_err("OPEN i102_cl:", STATUS, 1)
      CLOSE i102_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i102_cl INTO g_fgh.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_fgh.fgh01,SQLCA.sqlcode,0)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   #回寫 faj_file 資產檔
   DECLARE firm_cs CURSOR FOR
    SELECT fgi_file.* FROM fgi_file,faj_file
     WHERE fgi01 = g_fgh.fgh01 AND fgi06 = faj02 AND fgi07 = faj022
   FOREACH firm_cs INTO l_fgi.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM fap_file
        WHERE fap02 = l_fgi.fgi06 AND fap021 = l_fgi.fgi07 AND fap03 = 'C'
          AND fap50 = l_fgi.fgi01   #MOD-8C0123 add
     #IF l_cnt = 0 THEN                         #MOD-AA0089 mark
      IF l_cnt = 0 AND l_fgi.fgi10 = 'Y' THEN   #MOD-AA0089
         SELECT * INTO l_faj.* FROM faj_file
           WHERE faj02 = l_fgi.fgi06 AND faj022 = l_fgi.fgi07
        #CHI-C60010--add--str--
         IF g_faa.faa31='Y' THEN
            SELECT azi04 INTO l_azi04 FROM azi_file,aaa_file
             WHERE azi01=aaa03 AND aaa01=g_faa.faa02c
            LET l_faj.faj1412=cl_digcut(l_faj.faj1412,l_azi04)
            LET l_faj.faj142=cl_digcut(l_faj.faj142,l_azi04)
            LET l_faj.faj312=cl_digcut(l_faj.faj312,l_azi04)
            LET l_faj.faj322=cl_digcut(l_faj.faj322,l_azi04)
            LET l_faj.faj332=cl_digcut(l_faj.faj332,l_azi04)
            LET l_faj.faj352=cl_digcut(l_faj.faj352,l_azi04)
            LET l_faj.faj592=cl_digcut(l_faj.faj592,l_azi04)
            LET l_faj.faj602=cl_digcut(l_faj.faj602,l_azi04)
         END IF
        #CHI-C60010--add--end
         INSERT INTO fap_file (fap01,fap02,fap021,fap03,fap04,fap05,fap06,
                               fap07,fap08,fap09,fap10,fap101,fap11,fap12,
                               fap13,fap14,fap15,fap16,fap17,fap18,fap19,
                               fap20,fap201,fap21,fap22,fap23,fap24,fap25,
                               fap26,fap30,fap31,fap32,fap33,fap34,fap341,
                               fap35,fap36,fap37,fap38,fap39,fap40,fap41,
                               fap42,fap50,fap501,fap66,fap661,fap55,fap58,
                               fap59,fap60,fap61,fap62,fap63,fap65,fap75,fap76,
                               fap121,fap131,fap141,fap581,fap591,fap601,fap77,  #CHI-9B0032 add fap77
                               fap052,fap062,fap072,fap082,           #No:FUN-AB0088
                              #fap092,fap102,fap1012,fap112,          #No:FUN-AB0088
                               fap092,fap103,fap1012,fap112,          #No:FUN-AB0088   
                               fap152,fap162,fap212,fap222,           #No:FUN-AB0088
                               fap232,fap242,fap252,fap262,           #No:FUN-AB0088
                               fap552,fap612,fap622,fap6612,fap772,   #No:FUN-AB0088
                               faplegal)   #FUN-980003 add
              VALUES (l_faj.faj01,l_fgi.fgi06,l_fgi.fgi07,'C',g_fgh.fgh02,
                      l_faj.faj43,l_faj.faj28,l_faj.faj30,l_faj.faj31,
                      l_faj.faj14,l_faj.faj141,l_faj.faj33,l_faj.faj32,
                      l_faj.faj53,l_faj.faj54,l_faj.faj55,l_faj.faj23,
                      l_faj.faj24,l_faj.faj20,l_faj.faj19,l_faj.faj21,
                      l_faj.faj17,l_faj.faj171,l_faj.faj58,l_faj.faj59,
                      l_faj.faj60,l_faj.faj34,l_faj.faj35,l_faj.faj36,
                      l_faj.faj61,l_faj.faj65,l_faj.faj66,l_faj.faj62,
                      l_faj.faj63,l_faj.faj68,l_faj.faj67,l_faj.faj69,
                      l_faj.faj70,l_faj.faj71,l_faj.faj72,l_faj.faj73,
                      l_faj.faj100,l_faj.faj201,l_fgi.fgi01,l_fgi.fgi02,
                      l_faj.faj17,l_faj.faj14,l_faj.faj32,l_faj.faj53,
                      l_faj.faj54,l_faj.faj55,l_faj.faj23,l_faj.faj24,
                      l_faj.faj20,l_faj.faj21,l_fgi.fgi06,l_fgi.fgi07,
                      l_faj.faj531,l_faj.faj541,l_faj.faj551,
                      l_faj.faj531,l_faj.faj541,l_faj.faj551,l_faj.faj43,   #CHI-9B0032 add faj43
                      l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,   #No:FUN-AB0088
                      l_faj.faj142,l_faj.faj1412,l_faj.faj332,l_faj.faj322,  #No:FUN-AB0088
                      l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,   #No:FUN-AB0088
                      l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,   #No:FUN-AB0088
                      l_faj.faj322,l_faj.faj232,l_faj.faj242,l_faj.faj142,l_faj.faj432,      #No:FUN-AB0088
                      g_legal)     #FUN-980003 add
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('ins fap:',SQLCA.sqlcode,0)
            LET g_success='N'
         END IF
      END IF
      IF l_fgi.fgi10 = 'N' THEN  #不提
         LET l_status = '4'
      END IF
      IF l_fgi.fgi10 = 'Y' THEN  #要提
         #資產狀態
         CASE l_fgi.fgi11
           WHEN '4' LET l_status = '7'
           OTHERWISE LET l_status = l_fgi.fgi11
         END CASE
       END IF
       IF l_fgi.fgi10 = 'Y' THEN
       #  IF g_argv1 = '1' THEN    #財簽
          CASE g_argv1  #No:FUN-AB0088
             WHEN '1'   #財簽    #No:FUN-AB0088 
                UPDATE faj_file SET faj34 = l_fgi.fgi10,
                                    faj36 = l_fgi.fgi08,
                                    faj35 = l_fgi.fgi09,
                                    faj43 = l_status,
                                    faj30 = l_fgi.fgi08
                   WHERE faj02 = l_fgi.fgi06 AND faj022 = l_fgi.fgi07
       #  ELSE                     #稅簽
             WHEN '2'   #稅簽    #No:FUN-AB0088 
                UPDATE faj_file SET faj71 = l_fgi.fgi10,
                                    faj73 = l_fgi.fgi08,
                                    faj72 = l_fgi.fgi09,
                                  # faj43 = l_status,
                                    faj201= l_status,
                                    faj65 = l_fgi.fgi08
                   WHERE faj02 = l_fgi.fgi06 AND faj022 = l_fgi.fgi07
             WHEN '3'   #財簽二
                UPDATE faj_file SET faj342 = l_fgi.fgi10,
                                    faj362 = l_fgi.fgi08,
                                    faj352 = l_fgi.fgi09,
                                    faj432 = l_status,
                                    faj302 = l_fgi.fgi08
                 WHERE faj02 = l_fgi.fgi06 AND faj022 = l_fgi.fgi07
             #-----No:FUN-AB0088 END-----
        # END IF
          END CASE   #No:FUN-AB0088
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","faj_file",l_fgi.fgi06,l_fgi.fgi07,SQLCA.sqlcode,"","upd faj:",1)  #No.FUN-660136
          LET g_success='N'
       END IF
       END IF   #MOD-860009 add
   END FOREACH
   UPDATE fgh_file SET fghconf='Y'
    WHERE fgh01 = g_fgh.fgh01
   IF STATUS THEN
      CALL cl_err3("upd","fgh_file",g_fgh.fgh01,"",SQLCA.sqlcode,"","upd cofconf",1)  #No.FUN-660136
      LET g_success='N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_fgh.fgh01,'Y')
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT fghconf INTO g_fgh.fghconf FROM fgh_file
    WHERE fgh01 = g_fgh.fgh01
   DISPLAY BY NAME g_fgh.fghconf
END FUNCTION
 
FUNCTION i102_z()
   DEFINE l_fgi RECORD LIKE fgi_file.*
   DEFINE l_faj43  LIKE faj_file.faj43
   DEFINE l_status LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
          l_year   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_month  LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE l_yy,l_mm    LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE l_yy1,l_mm1  LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE l_fgi08  LIKE fgi_file.fgi08   #TQC-640183
   DEFINE l_fgi09  LIKE fgi_file.fgi09   #TQC-640183
   DEFINE l_cnt,l_yy2,l_mm2    LIKE type_file.num5 
   DEFINE l_fgi06  LIKE fgi_file.fgi06
   DEFINE l_fgi07  LIKE fgi_file.fgi07
   #MOD-BA0133 -- begin --
   DEFINE l_fap24  LIKE fap_file.fap24
   DEFINE l_fap242 LIKE fap_file.fap242
   DEFINE l_fap38  LIKE fap_file.fap38
   #MOD-BA0133 -- end --
 
   IF g_fgh.fgh01 IS NULL THEN RETURN END IF
   SELECT * INTO g_fgh.* FROM fgh_file WHERE fgh01=g_fgh.fgh01
   IF g_fgh.fghconf='N' THEN RETURN END IF
   IF g_fgh.fghconf ='X' THEN RETURN END IF  #CHI-C80041
   IF g_fgh.fghacti='N' THEN CALL cl_err('','9024',0) RETURN END IF
   LET l_cnt = 0
   LET l_yy2 = YEAR(g_fgh.fgh02)
   LET l_mm2 = MONTH(g_fgh.fgh02)
 
   DECLARE fgi_curs_2 CURSOR FOR
        SELECT fgi06,fgi07 FROM fgh_file,fgi_file
          WHERE fgh01 = fgi01
                AND fgh01 = g_fgh.fgh01
 
   FOREACH fgi_curs_2 INTO l_fgi06,l_fgi07
     #檢查需區分財簽、稅簽
   #  IF g_argv1 = '1' THEN                          #財簽   #NO:4862
      CASE g_argv1   #No:FUN-AB0088
         WHEN '1'   #財簽    #No:FUN-AB0088 
            SELECT COUNT(*) INTO l_cnt FROM fan_file
               WHERE fan01 = l_fgi06
                 AND fan02 = l_fgi07
                 AND (fan03 * 12 + fan04) >= (l_yy2 * 12 + l_mm2)
   #  ELSE                                           #稅簽   #NO:4862
         WHEN '2'    #稅簽      #No:FUN-AB0088 
            SELECT COUNT(*) INTO l_cnt FROM fao_file
               WHERE fao01 = l_fgi06
                 AND fao02 = l_fgi07
                 AND (fao03 * 12 + fao04) >= (l_yy2 * 12 + l_mm2)
         #-----No:FUN-AB0088-----
         WHEN '3'   #財簽二
            SELECT COUNT(*) INTO l_cnt FROM fbn_file
             WHERE fbn01 = l_fgi06
               AND fbn02 = l_fgi07
               AND (fbn03 * 12 + fbn04) >= (l_yy2 * 12 + l_mm2)
         #-----No:FUN-AB0088 END-----
     #END IF
      END CASE   #No:FUN-AB0088

      IF l_cnt > 0 THEN
         CALL cl_err(l_fgi06,'afa-129',0)
         RETURN
      END IF
   END FOREACH
 
  #-----No:FUN-B60140-----
  #-----No:FUN-AB0088-----
  #IF g_fgh.fgh03 = '1' OR g_fgh.fgh03 = '3' THEN     #財簽
  #   LET l_yy= YEAR(g_faa.faa09)
  #   LET l_mm=MONTH(g_faa.faa09)
  #ELSE
  #   LET l_yy= YEAR(g_faa.faa13)
  #   LET l_mm=MONTH(g_faa.faa13)
  #END IF
  ##-----No:FUN-AB0088 END-----
   CASE g_fgh.fgh03
      WHEN "1"
         LET l_yy= YEAR(g_faa.faa09)
         LET l_mm=MONTH(g_faa.faa09)
      WHEN "2"
         LET l_yy= YEAR(g_faa.faa13)
         LET l_mm=MONTH(g_faa.faa13)
      WHEN "3"
         LET l_yy= YEAR(g_faa.faa092)
         LET l_mm=MONTH(g_faa.faa092)
   END CASE
  #-----No:FUN-B60140 END-----
   LET l_yy= YEAR(g_faa.faa09)
   LET l_mm=MONTH(g_faa.faa09)
   LET l_yy1=YEAR(g_fgh.fgh02)
   LET l_mm1=MONTH(g_fgh.fgh02)
   IF (l_yy1*12+l_mm1)<=(l_yy*12+l_mm) THEN
      CALL  cl_err('','afa-924',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   LET g_success='Y'
   BEGIN WORK
 
   OPEN i102_cl USING g_fgh.fgh01
   IF STATUS THEN
      CALL cl_err("OPEN i102_cl:", STATUS, 1)
      CLOSE i102_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i102_cl INTO g_fgh.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_fgh.fgh01,SQLCA.sqlcode,0)
       CLOSE i102_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   LET l_year = YEAR(g_fgh.fgh02)
   LET l_month= MONTH(g_fgh.fgh02)
   #回寫 faj_file 資產檔
   DECLARE unfirm_cs CURSOR FOR
    SELECT fgi_file.* FROM fgi_file,faj_file
     WHERE fgi01 = g_fgh.fgh01 AND fgi06 = faj02 AND fgi07 = faj022
   FOREACH unfirm_cs INTO l_fgi.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
      #---01/05/17 modify 若下個月有提折舊則不可取消確認
   #  IF g_argv1 = '1' THEN #財簽   #NO:4862 
      CASE g_argv1   #No:FUN-AB0088
         WHEN '1'    #財簽   #No:FUN-AB0088 
          SELECT COUNT(*) INTO g_cnt FROM fan_file
           WHERE fan01 = l_fgi.fgi06   #財編
             AND fan02 = l_fgi.fgi07   #附號
             AND fan03*12+fan04 > (l_year*12+l_month)
             AND fan041 = '1'          #MOD-C50044 add
   #  ELSE
         WHEN '2'   #稅簽     #No:FUN-AB0088 
          SELECT COUNT(*) INTO g_cnt FROM fao_file     #稅簽   #NO:4862
           WHERE fao01 = l_fgi.fgi06   #財編
             AND fao02 = l_fgi.fgi07   #附號
             AND fao03*12+fao04 > (l_year*12+l_month) 
             AND fao041 = '1'          #MOD-C50044 add
         #-----No:FUN-AB0088-----
         WHEN '3'    #財簽二
            SELECT COUNT(*) INTO g_cnt FROM fbn_file
             WHERE fbn01 = l_fgi.fgi06   #財編
               AND fbn02 = l_fgi.fgi07   #附號
               AND fbn03*12+fbn04 > (l_year*12+l_month)
               AND fbn041 = '1'          #MOD-C50044 add
         #-----No:FUN-AB0088 END-----
    # END IF
      END CASE   #No:FUN-AB0088

      IF g_cnt > 0 THEN
         CALL cl_err(l_fgi.fgi06,'afa-348',0)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF l_fgi.fgi10 = 'N' THEN  #不提
         LET l_status = '4'
      END IF
      IF l_fgi.fgi10 = 'Y' THEN  #要提

         LET l_status = l_fgi.fgi11
       END IF
       IF l_fgi.fgi10 = 'Y' THEN
          #-----No:FUN-AB0088-----
          CASE g_argv1
             WHEN "1"   #財簽
                SELECT fgi08,fgi09 INTO l_fgi08,l_fgi09
                  FROM fgi_file,fgh_file
                  WHERE fgh01=fgi01
                    AND fgi06=l_fgi.fgi06
                    AND fgi07=l_fgi.fgi07
                    AND fgh02=(SELECT MAX(fgh02) FROM fgi_file,fgh_file
                                WHERE fgh01=fgi01 AND fgi06=l_fgi.fgi06
                                  AND fgi07=l_fgi.fgi07
                                  AND fghconf <> 'X'  #CHI-C80041
                                  AND fgh02 < g_fgh.fgh02)
                    AND fgh03='1'   #MOD-8C0123 add
             WHEN "2"   #稅簽
                SELECT fgi08,fgi09 INTO l_fgi08,l_fgi09
                  FROM fgi_file,fgh_file
                  WHERE fgh01=fgi01
                    AND fgi06=l_fgi.fgi06
                    AND fgi07=l_fgi.fgi07
                    AND fgh02=(SELECT MAX(fgh02) FROM fgi_file,fgh_file
                                WHERE fgh01=fgi01 AND fgi06=l_fgi.fgi06
                                  AND fgi07=l_fgi.fgi07
                                  AND fghconf <> 'X'  #CHI-C80041
                                  AND fgh02 < g_fgh.fgh02)
                    AND fgh03='2'   #MOD-8C0123 add
             WHEN "3"   #財簽二
                SELECT fgi08,fgi09 INTO l_fgi08,l_fgi09
                  FROM fgi_file,fgh_file
                  WHERE fgh01=fgi01
                    AND fgi06=l_fgi.fgi06
                    AND fgi07=l_fgi.fgi07
                    AND fgh02=(SELECT MAX(fgh02) FROM fgi_file,fgh_file
                                WHERE fgh01=fgi01 AND fgi06=l_fgi.fgi06
                                  AND fgi07=l_fgi.fgi07
                                  AND fghconf <> 'X'  #CHI-C80041
                                  AND fgh02 < g_fgh.fgh02)
                    AND fgh03='3'   #MOD-8C0123 add
          END CASE

      #   IF g_argv1 = '1' THEN    #財簽   #MOD-8C0123 add
      #      SELECT fgi08,fgi09 INTO l_fgi08,l_fgi09
      #        FROM fgi_file,fgh_file
      #        WHERE fgh01=fgi01
      #          AND fgi06=l_fgi.fgi06
      #          AND fgi07=l_fgi.fgi07
      #          AND fgh02=(SELECT MAX(fgh02) FROM fgi_file,fgh_file
      #                      WHERE fgh01=fgi01 AND fgi06=l_fgi.fgi06
      #                        AND fgi07=l_fgi.fgi07
      #                        AND fgh02 < g_fgh.fgh02)
      #          AND fgh03='1'   #MOD-8C0123 add
      #   ELSE                     #稅簽
      #      SELECT fgi08,fgi09 INTO l_fgi08,l_fgi09
      #        FROM fgi_file,fgh_file
      #        WHERE fgh01=fgi01
      #          AND fgi06=l_fgi.fgi06
      #          AND fgi07=l_fgi.fgi07
      #          AND fgh02=(SELECT MAX(fgh02) FROM fgi_file,fgh_file
      #                      WHERE fgh01=fgi01 AND fgi06=l_fgi.fgi06
      #                        AND fgi07=l_fgi.fgi07
      #                        AND fgh02 < g_fgh.fgh02)
      #          AND fgh03='2'   #MOD-8C0123 add
      #   END IF
      #-----No:FUN-AB0088 END-----
         #IF STATUS THEN   #MOD-AA0089 mark
         #-----No:FUN-AB0088-----
          IF g_argv1='3' THEN     #財簽二
             SELECT fap252,fap262 INTO l_fgi09,l_fgi08 FROM fap_file
              WHERE fap02=l_fgi.fgi06 AND fap021=l_fgi.fgi07 AND fap03='C'
                AND fap50=l_fgi.fgi01   #MOD-8C0123 add
          ELSE
             SELECT fap25,fap26 INTO l_fgi09,l_fgi08 FROM fap_file
              WHERE fap02=l_fgi.fgi06 AND fap021=l_fgi.fgi07 AND fap03='C'
                AND fap50=l_fgi.fgi01   #MOD-8C0123 add
          END IF
          #-----No:FUN-AB0088 END-----
          #MOD-BA0133 -- begin --
          SELECT fap24,fap242,fap38 INTO l_fap24,l_fap242,l_fap38 FROM fap_file
           WHERE fap02 = l_fgi.fgi06 AND fap021 = l_fgi.fgi07
             AND fap50 = l_fgi.fgi01
          #MOD-BA0133 -- end --
          DELETE FROM fap_file
           WHERE fap02=l_fgi.fgi06 AND fap021=l_fgi.fgi07 AND fap03='C'
             AND fap50=l_fgi.fgi01   #MOD-8C0123 add
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err('del fap:',SQLCA.sqlcode,0)
             LET g_success='N'
          END IF
         #END IF           #MOD-AA0089 mark
      #   IF g_argv1 = '1' THEN    #財簽 
          CASE g_argv1     #No:FUN-AB0088
             WHEN '1'   #財簽      #No:FUN-AB0088  
            #UPDATE faj_file SET faj34 = l_fgi.fgi10,   #MOD-BA0133 mark
             UPDATE faj_file SET faj34 = l_fap24,       #MOD-BA0133
                                #faj36 = 0,   #TQC-640183
                                #faj35 = 0,   #TQC-640183
                                 faj36 = l_fgi08,   #TQC-640183
                                 faj35 = l_fgi09,   #TQC-640183
                                 faj43 = l_status,
                                 faj30 = 0
              WHERE faj02 = l_fgi.fgi06 AND faj022 = l_fgi.fgi07
      #   ELSE                     #稅簽
             WHEN '2'   #稅簽      #No:FUN-AB0088      
            #UPDATE faj_file SET faj71 = l_fgi.fgi10,   #MOD-BA0133 mark
             UPDATE faj_file SET faj71 = l_fap38,       #MOD-BA0133
                                #faj73 = 0,   #TQC-640183
                                #faj72 = 0,   #TQC-640183
                                 faj73 = l_fgi08,   #TQC-640183
                                 faj72 = l_fgi09,   #TQC-640183
                               # faj43 = l_status,
                                 faj201= l_status,
                                 faj65 = 0
              WHERE faj02 = l_fgi.fgi06 AND faj022 = l_fgi.fgi07
            #-----No:FUN-AB0088-----
             WHEN '3'   #財簽二
               #UPDATE faj_file SET faj342 = l_fgi.fgi10,   #MOD-BA0133 mark
                UPDATE faj_file SET faj342 = l_fap242,      #MOD-BA0133
                                    faj362 = l_fgi08,
                                    faj352 = l_fgi09,
                                    faj432 = l_status,
                                    faj302 = 0
                 WHERE faj02 = l_fgi.fgi06 AND faj022 = l_fgi.fgi07
             #-----No:FUN-AB0088 END-----
         #END IF
          END CASE   #No:FUN-AB0088

       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","faj_file",l_fgi.fgi06,l_fgi.fgi07,SQLCA.sqlcode,"","upd faj:",1)  #No.FUN-660136
          LET g_success='N'
       END IF   #MOD-860009 add
     END IF
   END FOREACH
   UPDATE fgh_file SET fghconf='N'
    WHERE fgh01 = g_fgh.fgh01
   IF STATUS THEN
      CALL cl_err3("upd","fgh_file",g_fgh.fgh01,"",STATUS,"","upd cofconf",1)  #No.FUN-660136
      LET g_success='N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT fghconf INTO g_fgh.fghconf FROM fgh_file
    WHERE fgh01 = g_fgh.fgh01
   DISPLAY BY NAME g_fgh.fghconf
END FUNCTION
 
#No.FUN-9C0077 程式精簡
#CHI-C80041---begin
#FUNCTION i102_v()       #FUN-D20095 mark
FUNCTION i102_v(p_type)  #FUN-D20095
DEFINE p_type    LIKE type_file.chr1  #FUN-D20095
DEFINE l_flag    LIKE type_file.chr1  #FUN-D20095
DEFINE l_chr     LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_fgh.fgh01) THEN CALL cl_err('',-400,0) RETURN END IF  

   #FUN-D20095---begin
   IF p_type = 1 THEN
      IF g_fgh.fghconf='X' THEN RETURN END IF
   ELSE
      IF g_fgh.fghconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20095---end
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN i102_cl USING g_fgh.fgh01
   IF STATUS THEN
      CALL cl_err("OPEN i102_cl:", STATUS, 1)
      CLOSE i102_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i102_cl INTO g_fgh.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fgh.fgh01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE i102_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_fgh.fghconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
  #IF cl_void(0,0,g_fgh.fghconf) THEN    #FUN-D20095 mark
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #FUN-D20095
   IF cl_void(0,0,l_flag) THEN                                         #FUN-D20095
        LET l_chr=g_fgh.fghconf
       #IF g_fgh.fghconf='N' THEN    #FUN-D20095 mark
        IF p_type = 1 THEN           #FUN-D20095 
            LET g_fgh.fghconf='X' 
        ELSE
            LET g_fgh.fghconf='N'
        END IF
        UPDATE fgh_file
            SET fghconf=g_fgh.fghconf,  
                fghmodu=g_user,
                fghdate=g_today
            WHERE fgh01=g_fgh.fgh01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","fgh_file",g_fgh.fgh01,"",SQLCA.sqlcode,"","",1)  
            LET g_fgh.fghconf=l_chr 
        END IF
        DISPLAY BY NAME g_fgh.fghconf
   END IF
 
   CLOSE i102_cl
   COMMIT WORK
   CALL cl_flow_notify(g_fgh.fgh01,'V')
 
END FUNCTION
#CHI-C80041---end
