# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afat200.4gl
# Descriptions...: 量測儀器校驗記錄維護作業
# Date & Author..: 00/03/20 By Iceman
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-490344 04/09/20 By Kitty  controlp 少display補入
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: NO.FUN-550034 05/05/17 By jackie 單據編號加大
# Modify.........: NO.TQC-5A0072 05/10/26 By Sarah 單據編碼不能寫死抓三碼
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-5C0013 06/06/20 By rainy 加Action 校驗記錄維護
# Modify.........: No.FUN-660136 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0001 06/10/11 By jamie FUNCTION t200()_q 一開始應清空g_fgf.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time 
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-710028 07/01/26 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740130 07/04/20 By rainy 單身無資料時，刪除不要show錯誤訊息
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-850068 08/05/14 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.FUN-870143 08/08/07 By Sarah 在主畫面增加一個ACTION "教驗記錄查詢",供查詢輸入過的資料
# Modify.........: No.MOD-8A0202 08/10/29 By Sarah 此作業無法對應單別設定,所以不需檢核fah_file
# Modify.........: No.MOD-8B0255 08/11/25 By Sarah 在afat2001的畫面點選匯出Excel時,欄位抬頭變成afat200單身的欄位抬頭
# Modify.........: No.MOD-8B0295 08/12/01 By Sarah 進入單身欄位後,中文名稱(fga06)、校驗週期(fga20)欄位內的值會不見
# Modify.........: No.TQC-8B0048 09/01/07 By Sarah fgc_file的key值調整為fgc01,fgc011,fgc03
# Modify.........: No.TQC-970408 09/07/31 BY Carrier 下次校驗日做 default
# Modify.........: No.FUN-980003 09/08/11 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0030 09/11/06 By liuxqa sql语法错误。
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-B20131 11/02/22 By yinhy 輸入單身儀器資料，修改“校驗日期”后“下次校驗日期”未根據修改加上週期重新帶出新值。
# Modify.........: No.TQC-B20136 11/02/22 By yinhy 單身自動帶出符合日期範圍內單身資料時，應該排除掉免檢類儀器資料 
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No.FUN-D10098 13/02/04 By lujh 大陸版本用gfag200
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_fgf     RECORD LIKE fgf_file.*,
       g_fgf_t   RECORD LIKE fgf_file.*,
       g_fgf_o   RECORD LIKE fgf_file.*,
       g_fahconf        LIKE fah_file.fahconf,
       g_fgg            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                         fgg02     LIKE fgg_file.fgg02,
                         fgg03     LIKE fgg_file.fgg03,
                         fga06     LIKE fga_file.fga06,
                         fgg04     LIKE fgg_file.fgg04,
                         fgg08     LIKE fgg_file.fgg08,
                         fga20     LIKE fga_file.fga20,
                         fgg05     LIKE fgg_file.fgg05,
                         gen02     LIKE gen_file.gen02,
                         fgg06     LIKE fgg_file.fgg06,
                         fge03     LIKE fge_file.fge03,
                         fgg07     LIKE fgg_file.fgg07,
                         #FUN-850068 --start---
                         fggud01 LIKE fgg_file.fggud01,
                         fggud02 LIKE fgg_file.fggud02,
                         fggud03 LIKE fgg_file.fggud03,
                         fggud04 LIKE fgg_file.fggud04,
                         fggud05 LIKE fgg_file.fggud05,
                         fggud06 LIKE fgg_file.fggud06,
                         fggud07 LIKE fgg_file.fggud07,
                         fggud08 LIKE fgg_file.fggud08,
                         fggud09 LIKE fgg_file.fggud09,
                         fggud10 LIKE fgg_file.fggud10,
                         fggud11 LIKE fgg_file.fggud11,
                         fggud12 LIKE fgg_file.fggud12,
                         fggud13 LIKE fgg_file.fggud13,
                         fggud14 LIKE fgg_file.fggud14,
                         fggud15 LIKE fgg_file.fggud15
                         #FUN-850068 --end--
                        END RECORD,
       g_fgg_t          RECORD
                         fgg02     LIKE fgg_file.fgg02,
                         fgg03     LIKE fgg_file.fgg03,
                         fga06     LIKE fga_file.fga06,
                         fgg04     LIKE fgg_file.fgg04,
                         fgg08     LIKE fgg_file.fgg08,
                         fga20     LIKE fga_file.fga20,
                         fgg05     LIKE fgg_file.fgg05,
                         gen02     LIKE gen_file.gen02,
                         fgg06     LIKE fgg_file.fgg06,
                         fge03     LIKE fge_file.fge03,
                         fgg07     LIKE fgg_file.fgg07,
                         #FUN-850068 --start---
                         fggud01 LIKE fgg_file.fggud01,
                         fggud02 LIKE fgg_file.fggud02,
                         fggud03 LIKE fgg_file.fggud03,
                         fggud04 LIKE fgg_file.fggud04,
                         fggud05 LIKE fgg_file.fggud05,
                         fggud06 LIKE fgg_file.fggud06,
                         fggud07 LIKE fgg_file.fggud07,
                         fggud08 LIKE fgg_file.fggud08,
                         fggud09 LIKE fgg_file.fggud09,
                         fggud10 LIKE fgg_file.fggud10,
                         fggud11 LIKE fgg_file.fggud11,
                         fggud12 LIKE fgg_file.fggud12,
                         fggud13 LIKE fgg_file.fggud13,
                         fggud14 LIKE fgg_file.fggud14,
                         fggud15 LIKE fgg_file.fggud15
                         #FUN-850068 --end--
                        END RECORD,
       g_fah            RECORD LIKE fah_file.*,
       g_desc           LIKE type_file.chr4,        #No.FUN-680070 VARCHAR(4)
       g_fgf01_t        LIKE fgf_file.fgf01,
       g_wc,g_wc2,g_sql STRING,                     #No.FUN-580092 HCN
       l_modify_flag    LIKE type_file.chr1,        #No.FUN-680070 VARCHAR(1)
       l_flag           LIKE type_file.chr1,        #No.FUN-680070 VARCHAR(1)
#      g_t1             LIKE type_file.chr3,        #No.FUN-680070 VARCHAR(3)
       g_t1             LIKE type_file.chr5,        #No.FUN-550034       #No.FUN-680070 VARCHAR(5)
       g_buf            LIKE type_file.chr1000,     #No.FUN-680070 VARCHAR(30)
       g_rec_b          LIKE type_file.num5,        #單身筆數       #No.FUN-680070 SMALLINT
       g_rec_for        LIKE type_file.num5,        #校驗記錄筆數 #FUN-5C0013 add       #No.FUN-680070 SMALLINT
       l_ac             LIKE type_file.num5,        #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
       l_ac_for         LIKE type_file.num5         #目前處理的ARRAY CNT       #FUN-870143 add
DEFINE g_forupd_sql     STRING                      #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5      #No.FUN-680070 SMALLINT
DEFINE g_chr            LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE g_cnt            LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_msg            LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_row_count      LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_curs_index     LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_jump           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_no_ask        LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_for            DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
                         for02     LIKE for_file.for02, #項次
                         for03     LIKE for_file.for03, #校正項目編號
                         fgd02     LIKE fgd_file.fgd02, #校正項目名稱
                         for04     LIKE for_file.for04  #檢驗結果
                        END RECORD
DEFINE w                ui.Window     #MOD-8B0255 add
DEFINE f                ui.Form       #MOD-8B0255 add
DEFINE page             om.DomNode    #MOD-8B0255 add
 
MAIN
#DEFINE l_time          LIKE type_file.chr8,        #計算被使用時間       #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
DEFINE l_sql            LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   LET g_forupd_sql = " SELECT * FROM fgf_file WHERE fgf01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t200_cl CURSOR FROM g_forupd_sql
 
   LET g_wc2 = ' 1=1'
 
   OPEN WINDOW t200_w WITH FORM "afa/42f/afat200"    #顯示畫面
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL t200_menu()
   CLOSE WINDOW t200_w                    #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t200_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_fgg.clear()
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_fgf.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
      fgf01,fgfconf,fgfuser,fgfgrup,fgfmodu,fgfdate,
      #FUN-850068   ---start---
      fgfud01,fgfud02,fgfud03,fgfud04,fgfud05,
      fgfud06,fgfud07,fgfud08,fgfud09,fgfud10,
      fgfud11,fgfud12,fgfud13,fgfud14,fgfud15
      #FUN-850068    ----end----
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
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND fgfuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND fgfgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND fgfgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fgfuser', 'fgfgrup')
   #End:FUN-980030
 
   CONSTRUCT g_wc2 ON fgg02,fgg03,fgg04,fgg08,fgg05,fgg06,fgg07,
                      #No.FUN-850068 --start--
                      fggud01,fggud02,fggud03,fggud04,fggud05,
                      fggud06,fggud07,fggud08,fggud09,fggud10,
                      fggud11,fggud12,fggud13,fggud14,fggud15
                      #No.FUN-850068 ---end---
           FROM s_fgg[1].fgg02, s_fgg[1].fgg03, s_fgg[1].fgg04,
                s_fgg[1].fgg08, s_fgg[1].fgg05, s_fgg[1].fgg06,
                s_fgg[1].fgg07,
                #No.FUN-850068 --start--
                s_fgg[1].fggud01,s_fgg[1].fggud02,s_fgg[1].fggud03,
                s_fgg[1].fggud04,s_fgg[1].fggud05,s_fgg[1].fggud06,
                s_fgg[1].fggud07,s_fgg[1].fggud08,s_fgg[1].fggud09,
                s_fgg[1].fggud10,s_fgg[1].fggud11,s_fgg[1].fggud12,
                s_fgg[1].fggud13,s_fgg[1].fggud14,s_fgg[1].fggud15
                #No.FUN-850068 ---end---
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(fgg03)  #財產編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fga"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fgg03
                 NEXT FIELD fgg03
            WHEN INFIELD(fgg05)  #保管人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fgg05
                 NEXT FIELD fgg05
            WHEN INFIELD(fgg06)  #不良代碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fge"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fgg06
                 NEXT FIELD fgg06
            OTHERWISE
                 EXIT CASE
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
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
      LET g_sql = "SELECT fgf01 FROM fgf_file",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 1"
   ELSE                                         # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE fgg01 ",
                  "  FROM fgf_file, fgg_file",
                  " WHERE fgf01 = fgg01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY 1"
   END IF
 
   PREPARE t200_prepare FROM g_sql
   DECLARE t200_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t200_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM fgf_file WHERE ",g_wc CLIPPED
   ELSE
       LET g_sql="SELECT COUNT(DISTINCT fgf01) FROM fgf_file,fgg_file",
                 " WHERE fgg01 = fgf01 ",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
   END IF
   PREPARE t200_count_pre FROM g_sql
   DECLARE t200_count CURSOR FOR t200_count_pre
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
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t200_x()                     #FUN-D20035
               CALL t200_x(1)                    #FUN-D20035
            END IF

         #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t200_x(2)
            END IF
         #FUN-D20035---add---end

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t200_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t200_z()
            END IF
        #str FUN-870143 add
         WHEN "calib_result_query"   #校驗紀錄查詢
            IF cl_chk_act_auth() THEN
               CALL t200_Calib_Result_q()
            END IF
        #end FUN-870143 add
         WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fgf.fgf01 IS NOT NULL THEN
                  LET g_doc.column1 = "fgf01"
                  LET g_doc.value1 = g_fgf.fgf01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fgg),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t200_a()
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fgg.clear()
    INITIALIZE g_fgf.* TO NULL
    LET g_fgf01_t = NULL
    LET g_fgf_o.* = g_fgf.*
    LET g_fgf_t.* = g_fgf.*
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fgf.fgfconf='N'
        LET g_fgf.fgfuser=g_user
        LET g_fgf.fgforiu = g_user #FUN-980030
        LET g_fgf.fgforig = g_grup #FUN-980030
        LET g_fgf.fgfgrup=g_grup
        LET g_fgf.fgfdate=g_today
        LET g_fgf.fgflegal= g_legal       #FUN-980003 add
 
        BEGIN WORK
        CALL t200_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0
           INITIALIZE g_fgf.* TO NULL
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_fgf.fgf01 IS NULL THEN       #KEY不可空白
           CONTINUE WHILE
        END IF
        INSERT INTO fgf_file VALUES (g_fgf.*)
        IF SQLCA.SQLCODE THEN
           CALL cl_err('Ins:',SQLCA.SQLCODE,0)
           CONTINUE WHILE
        END IF
        COMMIT WORK
        LET g_fgf_t.* = g_fgf.*
        LET g_fgf01_t = g_fgf.fgf01
        SELECT fgf01 INTO g_fgf.fgf01
          FROM fgf_file
         WHERE fgf01 = g_fgf.fgf01
        LET g_rec_b=0
 
        CALL t200_g_b()       #自動產生單身
        CALL t200_b()
        #---判斷是否確認---------
       #LET g_t1 = g_fgf.fgf01[1,3]            #TQC-5A0072 mark
        LET g_t1 = s_get_doc_no(g_fgf.fgf01)   #TQC-5A0072
       #str MOD-8A0202 mark
       #SELECT fahconf INTO g_fahconf
       #  FROM fah_file
       # WHERE fahslip = g_t1
       #IF g_fahconf = 'Y' THEN CALL t200_y() END IF
       #end MOD-8A0202 mark
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t200_u()
   IF s_shut(0) THEN RETURN END IF
 
    IF g_fgf.fgf01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_fgf.* FROM fgf_file WHERE fgf01 = g_fgf.fgf01
    IF g_fgf.fgfconf = 'Y' THEN
       CALL cl_err(' ','afa-096',0)
       RETURN
    END IF
    IF g_fgf.fgfconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fgf01_t = g_fgf.fgf01
    LET g_fgf_o.* = g_fgf.*
    BEGIN WORK
 
    OPEN t200_cl USING g_fgf.fgf01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_fgf.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fgf.fgf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t200_cl ROLLBACK WORK RETURN
    END IF
    CALL t200_show()
    WHILE TRUE
        LET g_fgf01_t = g_fgf.fgf01
        LET g_fgf.fgfmodu=g_user
        LET g_fgf.fgfdate=g_today
        CALL t200_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fgf.*=g_fgf_t.*
            CALL t200_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_fgf.fgf01 != g_fgf_t.fgf01 THEN
           UPDATE fgg_file SET fgg01=g_fgf.fgf01 WHERE fgg01=g_fgf_t.fgf01
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#              CALL cl_err('upd fgg01',SQLCA.SQLCODE,0)      #No.FUN-660127
               CALL cl_err3("upd","fgg_file",g_fgf01_t,"",SQLCA.sqlcode,"","upd fgg01",1)  #No.FUN-660127
              LET g_fgf.*=g_fgf_t.*
              CALL t200_show()
              CONTINUE WHILE
           END IF
        END IF
        UPDATE fgf_file SET * = g_fgf.*
         WHERE fgf01 = g_fgf.fgf01
        IF SQLCA.SQLERRD[3] = 0 OR SQLCA.SQLCODE THEN
#           CALL cl_err(g_fgf.fgf01,SQLCA.SQLCODE,0)          #No.FUN-660127
            CALL cl_err3("upd","fgf_file",g_fgf_o.fgf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t200_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION t200_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,        #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
         l_flag          LIKE type_file.chr1,        #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
         l_bdate,l_edate LIKE type_file.dat,         #No.FUN-680070 DATE
         l_n1            LIKE type_file.num5         #No.FUN-680070 SMALLINT
    CALL cl_set_head_visible("","YES")               #No.FUN-6B0029
 
    INPUT BY NAME g_fgf.fgforiu,g_fgf.fgforig,
        g_fgf.fgf01,g_fgf.fgfconf,g_fgf.fgfuser,g_fgf.fgfgrup,
        g_fgf.fgfmodu,g_fgf.fgfdate
        #FUN-850068     ---start---
        ,g_fgf.fgfud01,g_fgf.fgfud02,g_fgf.fgfud03,g_fgf.fgfud04,
        g_fgf.fgfud05,g_fgf.fgfud06,g_fgf.fgfud07,g_fgf.fgfud08,
        g_fgf.fgfud09,g_fgf.fgfud10,g_fgf.fgfud11,g_fgf.fgfud12,
        g_fgf.fgfud13,g_fgf.fgfud14,g_fgf.fgfud15 
        #FUN-850068     ----end----
           WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t200_set_entry(p_cmd)
            CALL t200_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
       # AFTER FIELD fgf01
#---------保留規格是否加單編號
          {#LET g_t1=g_fgf.fgf01[1,3]            #TQC-5A0072 mark
            LET g_t1=s_get_doc_no(g_fgf.fgf01)   #TQC-5A0072
	    CALL s_afgflip(g_t1,'3')	    #檢查移轉單別
	    IF NOT cl_null(g_errno) THEN	    #抱歉, 有問題
	       CALL cl_err(g_t1,g_errno,0)
               LET g_fgf.fgf01 = g_fgf_o.fgf01
               NEXT FIELD fgf01
	    END IF
            SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
            IF p_cmd = 'a' THEN
              #IF g_fgf.fgf01[1,3] IS NOT NULL  AND            #TQC-5A0072 mark
               IF s_get_doc_no(g_fgf.fgf01) IS NOT NULL  AND   #TQC-5A0072
                  cl_null(g_fgf.fgf01[5,10]) AND g_fah.fahauno = 'N' THEN
                  NEXT FIELD fgf01
               ELSE
                  NEXT FIELD fgf01
               END IF
            END IF
            IF g_fgf.fgf01 != g_fgf_t.fgf01 OR g_fgf_t.fgf01 IS NULL THEN
                IF g_fah.fahauno = 'Y' AND NOT cl_chk_data_continue(g_fgf.fgf01[5,10]) THEN
                   CALL cl_err('','9056',0)
                   NEXT FIELD fgf01
                END IF
                SELECT count(*) INTO g_cnt FROM fgf_file
                 WHERE fgf01 = g_fgf.fgf01
                IF g_cnt > 0 THEN   #資料重複
                    CALL cl_err(g_fgf.fgf01,-239,0)
                    LET g_fgf.fgf01 = g_fgf_t.fgf01
                    DISPLAY BY NAME g_fgf.fgf01 #
                    NEXT FIELD fgf01
                END IF
            END IF
            LET g_fgf_o.fgf01 = g_fgf.fgf01
     }
 
        #FUN-850068     ---start---
        AFTER FIELD fgfud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgfud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgfud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgfud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgfud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgfud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgfud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgfud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgfud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgfud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgfud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgfud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgfud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgfud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgfud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-850068     ----end----
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #MOD-650015 --start 
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(fgf01) THEN
       #         LET g_fgf.* = g_fgf_t.*
       #         LET g_fgf.fgf01 = ' '
       #         LET g_fgf.fgfconf = 'N'
       #         CALL t200_show()
       #         NEXT FIELD fgf01
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
FUNCTION t200_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fgf01",TRUE)
    END IF
 
END FUNCTION
FUNCTION t200_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fgf01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t200_fgg03(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_fga06    LIKE fga_file.fga06,
          l_fga20    LIKE fga_file.fga20,
          l_fga25    LIKE fga_file.fga25,
          l_fgaacti  LIKE fga_file.fgaacti
 
    LET g_errno = ' '
    SELECT fga06,fga20,fga25,fgaacti INTO l_fga06,l_fga20,l_fga25,l_fgaacti
      FROM fga_file
     WHERE fga01 = g_fgg[l_ac].fgg03
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='afa-410'
                                 LET l_fga06 = NULL
                                 LET l_fgaacti = NULL
        WHEN l_fgaacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
    LET g_fgg[l_ac].fga06=l_fga06
    LET g_fgg[l_ac].fga20=l_fga20
    LET g_fgg[l_ac].fgg05=l_fga25
   IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY g_fgg[l_ac].fga06 TO s_fgg[l_ac].fga06
           DISPLAY g_fgg[l_ac].fga20 TO s_fgg[l_ac].fga20
           DISPLAY g_fgg[l_ac].fgg05 TO s_fgg[l_ac].fgg05
   END IF
END FUNCTION
 
FUNCTION t200_fgg05(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_gen02    LIKE gen_file.gen02,
          l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file
     WHERE gen01 = g_fgg[l_ac].fgg05
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='anm-047'
                                 LET l_gen02 = NULL
                                 LET l_genacti = NULL
        WHEN l_genacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd='a' THEN LET g_fgg[l_ac].gen02 = l_gen02 END IF
   IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY g_fgg[l_ac].gen02 TO s_fgg[l_ac].gen02
   END IF
END FUNCTION
 
FUNCTION t200_fgg06(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_fge03    LIKE fge_file.fge03,
          l_fgeacti  LIKE fge_file.fgeacti
 
    LET g_errno = ' '
    SELECT fge03,fgeacti INTO l_fge03,l_fgeacti
      FROM fge_file
     WHERE fge01 = g_fgg[l_ac].fgg06
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='afa-099'
                                 LET l_fge03 = NULL
                                 LET l_fgeacti = NULL
        WHEN l_fgeacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd='a' THEN LET g_fgg[l_ac].fge03 = l_fge03 END IF
   IF cl_null(g_errno) OR p_cmd = 'd'
      THEN
           DISPLAY g_fgg[l_ac].fge03 TO s_fgg[l_ac].fge03
   END IF
END FUNCTION
 
FUNCTION t200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fgf.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t200_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_fgf.* TO NULL
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fgf.* TO NULL
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
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t200_cs INTO g_fgf.fgf01
        WHEN 'P' FETCH PREVIOUS t200_cs INTO g_fgf.fgf01
        WHEN 'F' FETCH FIRST    t200_cs INTO g_fgf.fgf01
        WHEN 'L' FETCH LAST     t200_cs INTO g_fgf.fgf01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE  g_jump t200_cs INTO g_fgf.fgf01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fgf.fgf01,SQLCA.sqlcode,0)
        INITIALIZE g_fgf.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_fgf.* FROM fgf_file WHERE fgf01 = g_fgf.fgf01
    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_fgf.fgf01,SQLCA.sqlcode,0)     #No.FUN-660127
         CALL cl_err3("sel","fgf_file",g_fgf.fgf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
        INITIALIZE g_fgf.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fgf.fgfuser   #FUN-4C0059
    LET g_data_group = g_fgf.fgfgrup   #FUN-4C0059
    CALL t200_show()
END FUNCTION
 
FUNCTION t200_show()
    LET g_fgf_t.* = g_fgf.*                #保存單頭舊值
    DISPLAY BY NAME g_fgf.fgforiu,g_fgf.fgforig,
        g_fgf.fgf01,g_fgf.fgfconf,
        g_fgf.fgfuser,g_fgf.fgfgrup,g_fgf.fgfmodu,g_fgf.fgfdate
        #FUN-850068     ---start---
        ,g_fgf.fgfud01,g_fgf.fgfud02,g_fgf.fgfud03,g_fgf.fgfud04,
        g_fgf.fgfud05,g_fgf.fgfud06,g_fgf.fgfud07,g_fgf.fgfud08,
        g_fgf.fgfud09,g_fgf.fgfud10,g_fgf.fgfud11,g_fgf.fgfud12,
        g_fgf.fgfud13,g_fgf.fgfud14,g_fgf.fgfud15 
        #FUN-850068     ----end----
    IF g_fgf.fgfconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_fgf.fgfconf,"","","",g_chr,"")
    CALL t200_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t200_r()
 DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fgf.fgf01 IS NULL THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_fgf.* FROM fgf_file WHERE fgf01 = g_fgf.fgf01
    IF g_fgf.fgfconf = 'Y' THEN
       CALL cl_err('','afa-096',0) RETURN
    END IF
    IF g_fgf.fgfconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    BEGIN WORK
 
    OPEN t200_cl USING g_fgf.fgf01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_fgf.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fgf.fgf01,SQLCA.sqlcode,0)
       CLOSE t200_cl ROLLBACK WORK  RETURN
    END IF
    CALL t200_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fgf01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fgf.fgf01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete fgf,fgg!"
        DELETE FROM fgf_file WHERE fgf01 = g_fgf.fgf01
        IF SQLCA.SQLERRD[3]=0 THEN
          #CALL cl_err('No fgf deleted','',0) #No.+045 010403 by plum
#           CALL cl_err('No fgf deleted',SQLCA.SQLCODE,0)          #No.FUN-660127
            CALL cl_err3("del","fgf_file",g_fgf.fgf01,"",SQLCA.sqlcode,"","No fgf deleted",1)  #No.FUN-660127
        END IF 
        DELETE FROM fgg_file WHERE fgg01 = g_fgf.fgf01
        #IF SQLCA.SQLERRD[3]=0 THEN    #MOD-740130
        IF SQLCA.SQLCODE THEN          #MOD-740130
          #CALL cl_err('No fgg deleted','',0) #No.+045 010403 by plum
#           CALL cl_err('No fgg deleted',SQLCA.SQLCODE,0)           #No.FUN-660127
            CALL cl_err3("del","fgg_file",g_fgf.fgf01,"",SQLCA.sqlcode,"","No fgg deleted",1)  #No.FUN-660127
        END IF
        CLEAR FORM
        CALL g_fgg.clear()
        INITIALIZE g_fgf.* LIKE fgf_file.*
        OPEN t200_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE t200_cs
             CLOSE t200_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        FETCH t200_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t200_cs
             CLOSE t200_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t200_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t200_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET g_no_ask = TRUE
           CALL t200_fetch('/')
        END IF
 
    END IF
    CLOSE t200_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t200_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_row,l_col     LIKE type_file.num5,  		   #分段輸入之行,列數       #No.FUN-680070 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    l_b2      	    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
    l_faj06         LIKE faj_file.faj06,
    l_faj100        LIKE faj_file.faj100,
    l_qty	    LIKE type_file.num20_6,      #No.FUN-680070 DECMIAL(15,3)
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
    LET g_action_choice = ""
    IF g_fgf.fgf01 IS NULL THEN RETURN END IF
    IF g_fgf.fgfconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fgf.fgfconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT fgg02,fgg03,'',fgg04,fgg08,'',fgg05,'',fgg06,'',fgg07 ",
                       "   FROM fgg_file ",
                       "  WHERE fgg01 =? ",
                       "    AND fgg02 =? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    #CKP2
    IF g_rec_b=0 THEN CALL g_fgg.clear() END IF
 
 
    INPUT ARRAY g_fgg WITHOUT DEFAULTS FROM s_fgg.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
#         DISPLAY l_ac TO FORMONLY.cn3
         #LET g_fgg_t.* = g_fgg[l_ac].*  #BACKUP
          LET l_lock_sw = 'N'                   #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
 
          OPEN t200_cl USING g_fgf.fgf01
          IF STATUS THEN
             CALL cl_err("OPEN t200_cl:", STATUS, 1)
             CLOSE t200_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH t200_cl INTO g_fgf.*          # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_fgf.fgf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
             CLOSE t200_cl ROLLBACK WORK RETURN
          END IF
 
         #IF g_fgg[l_ac].fgg02 IS NOT NULL THEN
          IF g_rec_b>=l_ac THEN
             LET p_cmd='u'
             LET g_fgg_t.* = g_fgg[l_ac].*  #BACKUP
             LET l_flag = 'Y'
 
             OPEN t200_bcl USING g_fgf.fgf01,g_fgg_t.fgg02
             IF STATUS THEN
                CALL cl_err("OPEN t200_bcl:", STATUS, 1)
                CLOSE t200_bcl
                ROLLBACK WORK
                LET l_lock_sw = "Y"
                RETURN
             ELSE
                FETCH t200_bcl INTO g_fgg[l_ac].*
                IF SQLCA.sqlcode THEN
                    CALL cl_err('lock fgg',SQLCA.sqlcode,0)
                    LET l_lock_sw = "Y"
                ELSE
                  #FETCH t200_bcl INTO g_fgg[l_ac].*
                  #IF SQLCA.sqlcode THEN
                  #   CALL cl_err('lock fgg',SQLCA.sqlcode,0)
                  #   LET l_lock_sw = "Y"
                  #ELSE
                  #   SELECT fga06,fga20
                  #     INTO g_fgg[l_ac].fga06,g_fgg[l_ac].fga20
                  #     FROM fga_file
                  #    WHERE fga01=g_fgg[l_ac].fgg03
                  #str MOD-8B0295 add
                   SELECT fga06,fga20 INTO g_fgg[l_ac].fga06,g_fgg[l_ac].fga20
                     FROM fga_file
                    WHERE fga01=g_fgg[l_ac].fgg03
                   DISPLAY BY NAME g_fgg[l_ac].fga06,g_fgg[l_ac].fga20
                  #end MOD-8B0295 add
                   SELECT gen02 INTO g_fgg[l_ac].gen02
                     FROM  gen_file
                    WHERE gen01=g_fgg[l_ac].fgg05
                   SELECT fge03 INTO g_fgg[l_ac].fge03
                     FROM fge_file
                    WHERE fge01=g_fgg[l_ac].fgg06
                   LET g_fgg_t.fga06 =g_fgg[l_ac].fga06
                   LET g_fgg_t.fga20 =g_fgg[l_ac].fga20
                   LET g_fgg_t.fge03 =g_fgg[l_ac].fge03
                   LET g_fgg_t.gen02 =g_fgg[l_ac].gen02
                  #END IF
                END IF
             END IF
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
         #NEXT FIELD fgg02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             #CKP2
             INITIALIZE g_fgg[l_ac].* TO NULL  #重要欄位空白,無效
             DISPLAY g_fgg[l_ac].* TO s_fgg.*
             CALL g_fgg.deleteElement(l_ac)
             ROLLBACK WORK
             EXIT INPUT
            #CANCEL INSERT
          END IF
          INSERT INTO fgg_file(fgg01,fgg02,fgg03,fgg04,fgg05,fgg06,  #No:BUG-470041  #No.MOD-470565
                              fgg07,fgg08,fggacti,fgguser,fgggrup,
                              fggmodu,fggdate
                              #No.FUN-850068 --start--
                              ,fggud01,fggud02,fggud03,fggud04,fggud05,
                              fggud06,fggud07,fggud08,fggud09,fggud10,
                              fggud11,fggud12,fggud13,fggud14,fggud15,
                              #No.FUN-850068 ---end---
                              fgglegal,fggoriu,fggorig)      #FUN-980003 add
          VALUES(g_fgf.fgf01,g_fgg[l_ac].fgg02,g_fgg[l_ac].fgg03,
               g_fgg[l_ac].fgg04,g_fgg[l_ac].fgg05,g_fgg[l_ac].fgg06,
               g_fgg[l_ac].fgg07,g_fgg[l_ac].fgg08,'Y',g_user,
               g_grup,'',g_today
               #No.FUN-850068 --start--
               ,g_fgg[l_ac].fggud01,g_fgg[l_ac].fggud02,g_fgg[l_ac].fggud03,
               g_fgg[l_ac].fggud04,g_fgg[l_ac].fggud05,g_fgg[l_ac].fggud06,
               g_fgg[l_ac].fggud07,g_fgg[l_ac].fggud08,g_fgg[l_ac].fggud09,
               g_fgg[l_ac].fggud10,g_fgg[l_ac].fggud11,g_fgg[l_ac].fggud12,
               g_fgg[l_ac].fggud13,g_fgg[l_ac].fggud14,g_fgg[l_ac].fggud15,
               #No.FUN-850068 ---end---
               g_legal, g_user, g_grup)       #FUN-980003 add      #No.FUN-980030 10/01/04  insert columns oriu, orig
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0  THEN
#            CALL cl_err('ins fgg',SQLCA.sqlcode,0)           #No.FUN-660127
             CALL cl_err3("ins","fgg_file",g_fgf.fgf01,g_fgg[l_ac].fgg02,SQLCA.sqlcode,"","ins fgg",1)  #No.FUN-660127
            #LET g_fgg[l_ac].* = g_fgg_t.*
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
             COMMIT WORK
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd = 'a'
          INITIALIZE g_fgg[l_ac].* TO NULL      #900423
#         CALL t200_fgg03('d')
#         CALL t200_fgg05('d')
#         CALL t200_fgg06('d')
          LET g_fgg[l_ac].fgg07=1
         #Genero mark
         #CALL t200_fgg07('d',g_fgg[l_ac].fgg07) RETURNING g_desc
         #LET g_fgg[l_ac].desc = g_desc
         #DISPLAY g_fgg[l_ac].desc TO s_fgg[l_ac].desc #
          LET g_fgg_t.* = g_fgg[l_ac].*             #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD fgg02
 
       BEFORE FIELD fgg02                            #defgflt 序號
          IF p_cmd = 'a' OR p_cmd = 'u' THEN
             IF g_fgg[l_ac].fgg02 IS NULL OR g_fgg[l_ac].fgg02 = 0 THEN
                SELECT max(fgg02)+1 INTO g_fgg[l_ac].fgg02
                  FROM fgg_file WHERE fgg01 = g_fgf.fgf01
                IF g_fgg[l_ac].fgg02 IS NULL THEN
                   LET g_fgg[l_ac].fgg02 = 1
                END IF
             END IF
          END IF
 
       AFTER FIELD fgg02                        #check 序號是否重複
          IF NOT cl_null(g_fgg[l_ac].fgg02) THEN
             IF g_fgg[l_ac].fgg02 != g_fgg_t.fgg02 OR
                g_fgg_t.fgg02 IS NULL THEN
                SELECT count(*) INTO l_n FROM fgg_file
                 WHERE fgg01 = g_fgf.fgf01
                   AND fgg02 = g_fgg[l_ac].fgg02
                IF l_n > 0 THEN
                   LET g_fgg[l_ac].fgg02 = g_fgg_t.fgg02
                   CALL cl_err('',-239,0)
                   NEXT FIELD fgg02
                END IF
             END IF
          END IF
 
    #  輸入修改時如存在別張校驗單相同儀器編號且未確認,則不允許輸入。
       AFTER FIELD fgg03
          IF NOT cl_null(g_fgg[l_ac].fgg03) THEN
             IF g_fgg[l_ac].fgg03 != g_fgg_t.fgg03 OR
                g_fgg_t.fgg03 IS NULL THEN
                CALL t200_fgg03('a')
                IF NOT cl_null(g_errno) THEN
                   LET g_fgg[l_ac].fgg03 = g_fgg_t.fgg03
                   CALL cl_err(g_fgg[l_ac].fgg03,g_errno,0)
                   NEXT FIELD fgg03
                END IF
                SELECT count(*) INTO l_n FROM fgg_file,fgf_file
                 WHERE fgg01 = fgf01
                   AND fgg03 = g_fgg[l_ac].fgg03
                   AND fgfconf = 'N'
                IF l_n > 0 THEN
                   LET g_fgg[l_ac].fgg03= g_fgg_t.fgg03
                   CALL cl_err('','afa-412',0)
                   NEXT FIELD fgg03
                END IF
             END IF
          END IF
 
       BEFORE FIELD fgg04
          IF NOT cl_null(g_fgg[l_ac].fgg03) THEN
            IF g_fgg[l_ac].fgg04 != g_fgg_t.fgg04 OR g_fgg_t.fgg04 IS NULL THEN  #No.TQC-B20131
               IF l_ac = 1 THEN LET g_fgg[l_ac].fgg04 = g_today
                  ELSE LET g_fgg[l_ac].fgg04=g_fgg[l_ac-1].fgg04
               END IF
            END IF  #No.TQC-B20131
             DISPLAY BY NAME g_fgg[l_ac].fgg04   #MOD-5A0095             
          END IF
 
       #No.TQC-970408  --Begin
       BEFORE FIELD fgg08
          #IF cl_null(g_fgg[l_ac].fgg08) THEN  #No.TQC-B20131 mark
             IF NOT cl_null(g_fgg[l_ac].fgg04) AND NOT cl_null(g_fgg[l_ac].fga20) THEN
                LET g_fgg[l_ac].fgg08 = g_fgg[l_ac].fgg04 + g_fgg[l_ac].fga20
             END IF
          #END IF                              #No.TQC-B20131 mark
       #No.TQC-970408  --End  
 
       AFTER FIELD fgg05
          IF NOT cl_null(g_fgg[l_ac].fgg05) THEN
             CALL t200_fgg05('a')
             IF NOT cl_null(g_errno) THEN
                LET g_fgg[l_ac].fgg05 = g_fgg_t.fgg05
                DISPLAY BY NAME g_fgg[l_ac].fgg05   #MOD-5A0095
                CALL cl_err(g_fgg[l_ac].fgg05,g_errno,0)
                NEXT FIELD fgg05
             END IF
          END IF
 
       AFTER FIELD fgg06
          IF NOT cl_null(g_fgg[l_ac].fgg06) THEN
             CALL t200_fgg06('a')
             IF NOT cl_null(g_errno) THEN
                LET g_fgg[l_ac].fgg06 = g_fgg_t.fgg06
                CALL cl_err(g_fgg[l_ac].fgg06,g_errno,0)
                NEXT FIELD fgg06
             END IF
          ELSE
             LET g_fgg[l_ac].fge03=''
             DISPLAY BY NAME g_fgg[l_ac].fge03   #MOD-5A0095
          END IF
 
       AFTER FIELD fgg07
          IF NOT  cl_null(g_fgg[l_ac].fgg07) THEN
             IF g_fgg[l_ac].fgg07 NOT MATCHES'[1234]'
                THEN NEXT FIELD fgg07
             END IF
             #Genero mark
             #CALL t200_fgg07('a',g_fgg[l_ac].fgg07) RETURNING g_desc
             #LET g_fgg[l_ac].desc = g_desc
             #IF NOT cl_null(g_errno) THEN
             #   LET g_fgg[l_ac].fgg07 = g_fgg_t.fgg07
             #   CALL cl_err(g_fgg[l_ac].fgg07,g_errno,0)
             #   NEXT FIELD fgg07
             #END IF
          END IF
 
      #BEFORE FIELD fgg08
      #   IF g_fgg[l_ac].fgg04 IS NOT NULL OR  g_fgg[l_ac].fgg04 <>' '
      #      THEN LET g_fgg[l_ac].fgg08=g_fgg[l_ac].fgg04+g_fgg[l_ac].fga20
      #   END IF
 
       #No.FUN-850068 --start--
       AFTER FIELD fggud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fggud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fggud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fggud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fggud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fggud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fggud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fggud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fggud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fggud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fggud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fggud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fggud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fggud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fggud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       #No.FUN-850068 ---end---
 
       BEFORE DELETE                            #是否取消單身
          IF g_fgg_t.fgg02 > 0 AND g_fgg_t.fgg02 IS NOT NULL THEN
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
             DELETE FROM fgg_file
              WHERE fgg01 = g_fgf.fgf01
                AND fgg02 = g_fgg_t.fgg02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fgg_t.fgg02,SQLCA.sqlcode,0)         #No.FUN-660127
                CALL cl_err3("del","fgg_file",g_fgf.fgf01,g_fgg_t.fgg02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_fgg[l_ac].* = g_fgg_t.*
             CLOSE t200_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_fgg[l_ac].fgg02,-263,1)
             LET g_fgg[l_ac].* = g_fgg_t.*
          ELSE
             UPDATE fgg_file SET
                    fgg01=g_fgf.fgf01,fgg02=g_fgg[l_ac].fgg02,
                    fgg03=g_fgg[l_ac].fgg03,fgg04=g_fgg[l_ac].fgg04,
                    fgg08=g_fgg[l_ac].fgg08,fgg05=g_fgg[l_ac].fgg05,
                    fgg06=g_fgg[l_ac].fgg06,fgg07=g_fgg[l_ac].fgg07
                    #No.FUN-850068 --start--
                    ,fggud01 = g_fgg[l_ac].fggud01,
                    fggud02 = g_fgg[l_ac].fggud02,
                    fggud03 = g_fgg[l_ac].fggud03,
                    fggud04 = g_fgg[l_ac].fggud04,
                    fggud05 = g_fgg[l_ac].fggud05,
                    fggud06 = g_fgg[l_ac].fggud06,
                    fggud07 = g_fgg[l_ac].fggud07,
                    fggud08 = g_fgg[l_ac].fggud08,
                    fggud09 = g_fgg[l_ac].fggud09,
                    fggud10 = g_fgg[l_ac].fggud10,
                    fggud11 = g_fgg[l_ac].fggud11,
                    fggud12 = g_fgg[l_ac].fggud12,
                    fggud13 = g_fgg[l_ac].fggud13,
                    fggud14 = g_fgg[l_ac].fggud14,
                    fggud15 = g_fgg[l_ac].fggud15
                    #No.FUN-850068 ---end---
              WHERE fgg01=g_fgf.fgf01 AND fgg02=g_fgg_t.fgg02
             IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#               CALL cl_err('upd fgg',SQLCA.sqlcode,0)            #No.FUN-660127
                CALL cl_err3("upd","fgg_file",g_fgf.fgf01,g_fgg_t.fgg02,SQLCA.sqlcode,"","upd fgg",1)  #No.FUN-660127
                LET g_fgg[l_ac].* = g_fgg_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
       #  LET l_ac_t = l_ac    #FUN-D30032 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_fgg[l_ac].* = g_fgg_t.*
            #FUN-D30032--add--str--
             ELSE
                CALL g_fgg.deleteElement(l_ac)
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
         #LET g_fgg_t.* = g_fgg[l_ac].*
          LET l_ac_t = l_ac  #FUN-D30032 add
          CLOSE t200_bcl
          COMMIT WORK
          #CKP2
          CALL g_fgg.deleteElement(g_rec_b+1)
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(fgg02) AND l_ac > 1 THEN
             LET g_fgg[l_ac].* = g_fgg[l_ac-1].*
             LET g_fgg[l_ac].fgg02 = NULL
             NEXT FIELD fgg02
          END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(fgg03)  #財產編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_fga"
                  LET g_qryparam.default1 = g_fgg[l_ac].fgg03
                  CALL cl_create_qry() RETURNING g_fgg[l_ac].fgg03
#                 CALL FGL_DIALOG_SETBUFFER( g_fgg[l_ac].fgg03 )
                  DISPLAY g_fgg[l_ac].fgg03 TO fgg03               #No.MOD-490344
                  CALL t200_fgg03('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(' ',g_errno,0)
                     NEXT FIELD fgg03
                  END IF
                  NEXT FIELD fgg03
             WHEN INFIELD(fgg05)  #保管人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_fgg[l_ac].fgg05
                  CALL cl_create_qry() RETURNING g_fgg[l_ac].fgg05
#                 CALL FGL_DIALOG_SETBUFFER( g_fgg[l_ac].fgg05 )
                  DISPLAY g_fgg[l_ac].fgg05 TO fgg05               #No.MOD-490344
                  CALL t200_fgg05('a')
                  NEXT FIELD fgg05
             WHEN INFIELD(fgg06)  #不良代碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_fge"
                  LET g_qryparam.default1 = g_fgg[l_ac].fgg06
                  CALL cl_create_qry() RETURNING g_fgg[l_ac].fgg06
#                 CALL FGL_DIALOG_SETBUFFER( g_fgg[l_ac].fgg06 )
                  DISPLAY g_fgg[l_ac].fgg06 TO fgg06               #No.MOD-490344
                  CALL t200_fgg06('a')
                  NEXT FIELD fgg06
             OTHERWISE
                  EXIT CASE
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
 
       ON ACTION about          #MOD-4C0121
          CALL cl_about()       #MOD-4C0121
   
       ON ACTION help           #MOD-4C0121
          CALL cl_show_help()   #MOD-4C0121
 
       #FUN-5C0013 add --start
       ON ACTION Calib_Result   #校驗紀錄維護
          CALL t200_Calib_Result()
       #FUN-5C0013 add --end
 
       #No.FUN-6B0029--begin                                             
       ON ACTION controls                                        
          CALL cl_set_head_visible("","AUTO")                    
       #No.FUN-6B0029--end
    END INPUT
 
   #start FUN-5A0029
    LET g_fgf.fgfmodu = g_user
    LET g_fgf.fgfdate = g_today
    UPDATE fgf_file SET fgfmodu = g_fgf.fgfmodu,fgfdate = g_fgf.fgfdate
     WHERE fgf01 = g_fgf.fgf01
    DISPLAY BY NAME g_fgf.fgfmodu,g_fgf.fgfdate
   #end FUN-5A0029
 
    CLOSE t200_bcl
    COMMIT WORK
    CALL t200_delHeader()     #CHI-C30002 add
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
      CALL s_get_doc_no(g_fgf.fgf01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fgf_file ",
                  "  WHERE fgf01 LIKE '",l_slip,"%' ",
                  "    AND fgf01 > '",g_fgf.fgf01,"'"
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
        #CALL t200_x()             #FUN-D20035
         CALL t200_x(1)             #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fgf_file WHERE fgf01 = g_fgf.fgf01
         INITIALIZE g_fgf.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t200_fgg04(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_gen01    LIKE gen_file.gen01,
      l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen01,genacti INTO l_gen01,l_genacti
      FROM gen_file
     WHERE gen01 = g_fgg[l_ac].fgg04
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gen01 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
{--Genero mark
FUNCTION  t200_fgg07(p_cmd,l_fgg07)
DEFINE
      p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_fgg07   LIKE fgg_file.fgg07,
      l_bn      LIKE type_file.chr4         #No.FUN-680070 VARCHAR(4)
 
#－0:未校 1:正常 2:停用 3.退修 4.報廢
     CASE l_fgg07
         WHEN '0'
            CALL cl_getmsg('afa-404',g_lang) RETURNING l_bn
         WHEN '1'
            CALL cl_getmsg('afa-405',g_lang) RETURNING l_bn
         WHEN '2'
            CALL cl_getmsg('afa-406',g_lang) RETURNING l_bn
         WHEN '3'
            CALL cl_getmsg('afa-407',g_lang) RETURNING l_bn
         WHEN '4'
            CALL cl_getmsg('afa-408',g_lang) RETURNING l_bn
         OTHERWISE EXIT CASE
      END CASE
      RETURN(l_bn)
END FUNCTION
----}
 
FUNCTION t200_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON fgg02,fgg03,fgg04,fgg08,fgg05,fgg06,fgg07
         FROM s_fgg[1].fgg02, s_fgg[1].fgg03,s_fgg[1].fgg04,s_fgg[1].fgg08,
              s_fgg[1].fgg05,s_fgg[1].fgg06,s_fgg[1].fgg07
 
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
DEFINE p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
        "SELECT fgg02,fgg03,fga06,fgg04,fgg08,fga20,fgg05, ",
        "       gen02,fgg06,fge03,fgg07",
        #No.FUN-850068 --start--
        "       ,fggud01,fggud02,fggud03,fggud04,fggud05,",
        "       fggud06,fggud07,fggud08,fggud09,fggud10,",
        "       fggud11,fggud12,fggud13,fggud14,fggud15", 
        #No.FUN-850068 ---end---
        "  FROM fgg_file LEFT OUTER JOIN fga_file ON fgg03=fga01 LEFT OUTER JOIN fge_file ON fgg06=fge01 LEFT OUTER JOIN gen_file ON fgg05=gen01  ",
        " WHERE fgg01  ='",g_fgf.fgf01,"'",          #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t200_pb FROM g_sql
    DECLARE fgg_curs                       #SCROLL CURSOR
        CURSOR FOR t200_pb
 
    CALL g_fgg.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fgg_curs INTO g_fgg[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
        #Genero mark
        #CALL t200_fgg07('d',g_fgg[g_cnt].fgg07) RETURNING g_desc
        #LET g_fgg[g_cnt].desc=g_desc
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_fgg.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fgg TO s_fgg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF g_fgf.fgfconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         CALL cl_set_field_pic(g_fgf.fgfconf,"","","",g_chr,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add--end
 
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
     #str FUN-870143 add
      ON ACTION calib_result_query    #校驗紀錄查詢
         LET g_action_choice="calib_result_query"
         EXIT DISPLAY
     #end FUN-870143 add
 
#@    ON ACTION 相關文件
      ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
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
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
      #No.FUN-6B0029--end
 
      #FUN-7C0050
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
{
FUNCTION t200_out()
   DEFINE l_cmd        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
          l_wc,l_wc2    LIKE type_file.chr50,        #No.FUN-680070 VARCHAR(50)
          l_prtway    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
      CALL cl_wait()
      LET l_wc='fgf01="',g_fgf.fgf01,'"'
      #SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afar102'  #FUN-C30085 mark
      #FUN-D10098--add--str--
      IF g_aza.aza26 = '2' THEN
         SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'gfag102'
      ELSE
      #FUN-D10098--add--end--
         SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afag102'  #FUN-C30085 add
      END IF   #FUN-D10098 add
      IF SQLCA.sqlcode OR l_wc2 IS NULL THEN
         LET l_wc2 = " '3' '3' 'N' "
      END IF
      #LET l_cmd = "afar102",  #FUN-C30085 mark
      #FUN-D10098--add--str--
      IF g_aza.aza26 = '2' THEN
         LET l_cmd = "gfag102",  
                     " '",g_today CLIPPED,"' ''",
                     " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                     " '",l_wc CLIPPED,"' ",l_wc2
      ELSE
      #FUN-D10098--add--end--
         LET l_cmd = "afag102",  #FUN-C30085 add
                     " '",g_today CLIPPED,"' ''",
                     " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                     " '",l_wc CLIPPED,"' ",l_wc2
      END IF   #FUN-D10098 add
      CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
}
 
FUNCTION t200_y()
  DEFINE l_flag  LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
  DEFINE l_n     LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE l_cnt   LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE l_fgg   RECORD LIKE fgg_file.*
  DEFINE l_fgc   RECORD LIKE fgc_file.*
 
#CHI-C30107 ------------ add ------------ begin
   IF g_fgf.fgfconf='Y' THEN
   CALL cL_err('','9023',0)
   RETURN END IF
   IF g_fgf.fgfconf = 'X' THEN
      CALL cl_err('','9024',0) RETURN
   END IF   
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ------------ add ------------ end 
   SELECT * INTO g_fgf.* FROM fgf_file WHERE fgf01 = g_fgf.fgf01
   IF g_fgf.fgfconf='Y' THEN 
   CALL cL_err('','9023',0)      
   RETURN END IF
   IF g_fgf.fgfconf = 'X' THEN
      CALL cl_err('','9024',0) RETURN
   END IF
   #bugno:7341 add......................................................
   SELECT COUNT(*) INTO l_cnt FROM fgg_file WHERE fgg01=g_fgf.fgf01
   IF l_cnt = 0 THEN CALL cl_err('','mfg-009',0) RETURN END IF
   #bugno:7341 end......................................................
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
   BEGIN WORK
 
   OPEN t200_cl USING g_fgf.fgf01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_fgf.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fgf.fgf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t200_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
   DECLARE t200_y1 CURSOR FOR
      SELECT * FROM fgg_file WHERE fgg01 = g_fgf.fgf01
   CALL s_showmsg_init()   #No.FUN-710028
   FOREACH t200_y1 INTO l_fgg.*
#No.FUN-710028 --begin                                                                                                              
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
#No.FUN-710028 --end
      IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)         #No.FUN-710028
         CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0) #No.FUN-710028
         EXIT FOREACH
      END IF
      SELECT COUNT(*) INTO l_n FROM fgc_file
       WHERE fgc01=l_fgg.fgg03
      IF l_n IS NULL THEN LET l_n=0 END IF
      LET l_fgc.fgc01 =l_fgg.fgg03   #儀器編號
      LET l_fgc.fgc011=l_n           #項次       #TQC-8B0048 mod
      LET l_fgc.fgc02 =l_fgg.fgg04   #校驗日期
      LET l_fgc.fgc03 =g_fgf.fgf01   #校驗編號
      LET l_fgc.fgc04 =l_fgg.fgg05   #校驗人員
      LET l_fgc.fgc05 =l_fgg.fgg06   #校驗不良原因
      LET l_fgc.fgc06 =l_fgg.fgg07   #校驗結果
      LET l_fgc.fgc07 =l_fgg.fgg08   #下次校驗日
      INSERT INTO fgc_file VALUES (l_fgc.*)
      IF SQLCA.SQLCODE THEN
#        CALL cl_err('Ins:',SQLCA.SQLCODE,1)                             #No.FUN-660127
         CALL cl_err3("ins","fgc_file",l_fgc.fgc01,l_fgc.fgc011,SQLCA.sqlcode,"","ins:",1)  #No.FUN-660127 #No.FUN-710028
         LET g_showmsg = l_fgc.fgc01,"/",l_fgc.fgc011                    #No.FUN-710028
         CALL s_errmsg('fgc01,fgc011',g_showmsg,'Ins:',SQLCA.SQLCODE,1)  #No.FUN-710028
         LET g_success='N'
      END IF
#------------Update 量測儀器資料維護作業
      UPDATE fga_file SET fga22=l_fgg.fgg04,fga24=l_fgg.fgg07,
                          fga23=l_fgg.fgg08,fga25=l_fgg.fgg05
       WHERE fga01 = l_fgg.fgg03
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err('upd fgaerr',STATUS,0)                        #No.FUN-660127
#        CALL cl_err3("upd","fga_file",l_fgg.fgg03,"",STATUS,"","upd fgaerr",1)  #No.FUN-660127 #No.FUN-710028
         CALL s_errmsg('fga01',l_fgg.fgg03,'upd fgaerr',STATUS,1)  #No.FUN-710028
         LET g_success = 'N'
      END IF
   END FOREACH
#No.FUN-710028 --begin                                                                                                              
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
#No.FUN-710028 --end
 
   UPDATE fgf_file SET fgfconf = 'Y' WHERE fgf01 = g_fgf.fgf01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd fgfconf',STATUS,0)                       #No.FUN-660127
#     CALL cl_err3("upd","fgf_file",g_fgf.fgf01,"",STATUS,"","upd fgfconf",1) #No.FUN-660127 #No.FUN-710028
      CALL s_errmsg('fgf01',g_fgf.fgf01,'upd fgfconf',STATUS,1) #No.FUN-710028
      LET g_success = 'N'
      ROLLBACK WORK RETURN
   END IF
   CLOSE t200_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      LET g_fgf.fgfconf='Y'
      COMMIT WORK
      DISPLAY BY NAME g_fgf.fgfconf
   ELSE
      LET g_fgf.fgfconf='N'
      ROLLBACK WORK
   END IF
   IF g_fgf.fgfconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_fgf.fgfconf,"","","",g_chr,"")
END FUNCTION
 
FUNCTION t200_z()
  DEFINE l_flag    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
  DEFINE l_n       LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE l_fgc02   LIKE fgc_file.fgc02
  DEFINE l_fgg     RECORD LIKE fgg_file.*
  DEFINE l_fgc     RECORD LIKE fgc_file.*
  DEFINE l_fgc011  LIKE fgc_file.fgc011
  DEFINE l_fgc03   LIKE fgc_file.fgc03         #TQC-8B0048 add
 
#  1-1 必須檢查儀器校驗異動檔內相同儀器是否有校驗日期大於本次校驗日者,
#      若有,則本筆不可取消確認
 
   SELECT * INTO g_fgf.* FROM fgf_file WHERE fgf01 = g_fgf.fgf01
   IF g_fgf.fgfconf='N' THEN CALL cl_err('','9025',0) RETURN END IF
   IF g_fgf.fgfconf = 'X' THEN
      CALL cl_err('','9024',0) RETURN
   END IF
   IF NOT cl_confirm('aim-304') THEN RETURN END IF
   BEGIN WORK
 
   OPEN t200_cl USING g_fgf.fgf01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_fgf.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fgf.fgf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t200_cl ROLLBACK WORK RETURN
   END IF
 
   LET g_success = 'Y'
 
   DECLARE t200_z1 CURSOR FOR
      SELECT * FROM fgg_file WHERE fgg01 = g_fgf.fgf01
   CALL s_showmsg_init()  #No.FUN-710028
   FOREACH t200_z1 INTO l_fgg.*
#No.FUN-710028 --begin                                                                                                              
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
#No.FUN-710028 --end
      IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)         #No.FUN-710028
         CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1) #No.FUN-710028
         EXIT FOREACH
      END IF
      SELECT MAX(fgc02) INTO l_fgc02 FROM fgc_file WHERE fgc01=l_fgg.fgg03
      IF l_fgc02 > l_fgg.fgg04 THEN CALL cl_err('','afa-413',0) RETURN END IF
     #str TQC-8B0048 add
      LET l_fgc011 = ''
      SELECT fgc011 INTO l_fgc011 FROM fgc_file 
       WHERE fgc01=l_fgg.fgg03 AND fgc03=g_fgf.fgf01
     #end TQC-8B0048 add
#------------DELETE 異動檔
      DELETE FROM fgc_file
       WHERE fgc01 =l_fgg.fgg03
     #   AND fgc011=l_fgg.fgg02   #TQC-8B0048 mark
         AND fgc011=l_fgc011      #TQC-8B0048
         AND fgc03 =g_fgf.fgf01   #TQC-8B0048 add
      IF STATUS THEN
#        CALL cl_err('del fgcerr',STATUS,0)                              #No.FUN-710028
#        CALL cl_err3("del","fgc_file",l_fgg.fgg03,l_fgg.fgg02,STATUS,"","del fgcerr",1)  #No.FUN-660127 #No.FUN-710028
         LET g_showmsg = l_fgg.fgg03,"/",l_fgg.fgg02                     #No.FUN-710028
         CALL s_errmsg('fgc01,fgc011',g_showmsg,'del fgcerr',STATUS,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
#--------------取最大項次
      INITIALIZE l_fgc.* TO NULL   #TQC-8B0048 add
      SELECT MAX(fgc011) INTO l_fgc011 FROM fgc_file WHERE fgc01 = l_fgg.fgg03
     #str TQC-8B0048 add
      IF NOT cl_null(l_fgc011) THEN
         SELECT fgc03 INTO l_fgc03 FROM fgc_file
          WHERE fgc01=l_fgg.fgg03 AND fgc011=l_fgc011
     #end TQC-8B0048 add
         SELECT * INTO l_fgc.* FROM fgc_file
          WHERE fgc01 =l_fgg.fgg03
            AND fgc011=l_fgc011
            AND fgc03 =l_fgc03   #TQC-8B0048 add
         IF STATUS THEN
#           CALL cl_err('sel fgc_file',STATUS,0)                              #No.FUN-660127
#           CALL cl_err3("sel","fgc_file",l_fgg.fgg03,l_fgc011,STATUS,"","sel fgc_file",1)  #No.FUN-660127 #No.FUN-710028
            LET g_showmsg = l_fgg.fgg03,"/",l_fgc011                          #No.FUN-710028              
            CALL s_errmsg('fgc01,fgc011',g_showmsg,'sel fgc_file',STATUS,1)   #No.FUN-710028
            LET g_success = 'N'
         END IF
      END IF   #TQC-8B0048 add
#------------Update 量測儀器資料維護作業
      UPDATE fga_file SET fga22=l_fgc.fgc02,fga24=l_fgc.fgc06,
                          fga23=l_fgc.fgc07,fga25=l_fgc.fgc04
       WHERE fga01 = l_fgg.fgg03
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err('upd fgaerr',STATUS,0)                        #No.FUN-660127
#        CALL cl_err3("upd","fga_file",l_fgg.fgg03,"",STATUS,"","upd fgaerr",1)  #No.FUN-660127 #No.FUN-710028
         CALL s_errmsg('fga01',l_fgg.fgg03,'upd fgaerr',STATUS,1)  #No.FUN-710028
         LET g_success = 'N'
      END IF
   END FOREACH
#No.FUN-710028 --begin                                                                                                              
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
#No.FUN-710028 --end
 
   UPDATE fgf_file SET fgfconf = 'N' WHERE fgf01 = g_fgf.fgf01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd fgfconf',STATUS,0)                         #No.FUN-660127
#     CALL cl_err3("upd","fgf_file",g_fgf.fgf01,"",STATUS,"","upd fgfconf",1)  #No.FUN-660127 #No.FUN-710028
      CALL s_errmsg('fgf01',g_fgf.fgf01,'upd fgfconf',STATUS,1)   #No.FUN-710028
      LET g_success = 'N'
      ROLLBACK WORK RETURN
   END IF
   CLOSE t200_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      LET g_fgf.fgfconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_fgf.fgfconf
   ELSE
      LET g_fgf.fgfconf='Y'
      ROLLBACK WORK
   END IF
   IF g_fgf.fgfconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_fgf.fgfconf,"","","",g_chr,"")
END FUNCTION
 
FUNCTION t200_g_b()
    DEFINE l_fga    RECORD LIKE fga_file.*
    DEFINE seq      LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fgf.fgf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF NOT cl_confirm('afa-103') THEN RETURN END IF
    LET seq=1
    DECLARE fga_cur CURSOR FOR
       SELECT * FROM fga_file WHERE fga23<=g_today
                                AND fga21 <> '3'        #No.TQC-B20136
    FOREACH fga_cur INTO l_fga.*
       LET l_fga.fga23=g_today+l_fga.fga20
        INSERT INTO fgg_file(fgg01,fgg02,fgg03,fgg04,fgg05,fgg06,  #No:BUG-470041 #No.MOD-470565
                            fgg07,fgg08,fggacti,fgguser,fgggrup,
                            fggmodu,fggdate,fgglegal,fggoriu,fggorig)    #FUN-980003 add
            VALUES(g_fgf.fgf01,seq,l_fga.fga01,g_today,l_fga.fga25,' ',' ',
                   l_fga.fga23,'','','','','',g_legal, g_user, g_grup)   #FUN-980003 add      #No.FUN-980030 10/01/04  insert columns oriu, orig
       LET seq=seq+1
    END FOREACH
    CALL t200_b_fill(g_wc2)
END FUNCTION
 
#FUNCTION t200_x()                                      #FUN-D20035
FUNCTION t200_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_fgf.* FROM fgf_file WHERE fgf01=g_fgf.fgf01
   IF g_fgf.fgf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fgf.fgfconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #FUN-D20035---begin
   #作废操作
   IF p_type = 1 THEN
      IF g_fgf.fgfconf ='X' THEN RETURN END IF
   ELSE
   #取消作废
      IF g_fgf.fgfconf <>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   BEGIN WORK
   LET g_success='Y'
 
   OPEN t200_cl USING g_fgf.fgf01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_fgf.*#鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fgf.fgf01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t200_cl ROLLBACK WORK RETURN
   END IF
  #-->作廢轉換01/08/02
  #IF cl_void(0,0,g_fgf.fgfconf)   THEN                #FUN-D20035
    IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF     #FUN-D20035
    IF cl_void(0,0,l_flag) THEN                                          #FUN-D20035
        LET g_chr=g_fgf.fgfconf
       #IF g_fgf.fgfconf ='N' THEN                                       #FUN-D20035
        IF p_type = 1 THEN                                               #FUN-D20035
            LET g_fgf.fgfconf='X'
        ELSE
            LET g_fgf.fgfconf='N'
        END IF
   UPDATE fgf_file SET fgfconf = g_fgf.fgfconf,fgfmodu=g_user,fgfdate=TODAY
          WHERE fgf01 = g_fgf.fgf01
   IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN 
#   CALL cl_err('upd fgfconf:',STATUS,1)            #No.FUN-660127
    CALL cl_err3("upd","fgf_file",g_fgf.fgf01,"",STATUS,"","upd fgfconf:",1)  #No.FUN-660127
   LET g_success='N' END IF
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
 
 
   SELECT fgfconf INTO g_fgf.fgfconf FROM fgf_file
    WHERE fgf01 = g_fgf.fgf01
   DISPLAY BY NAME g_fgf.fgfconf
  END IF
  IF g_fgf.fgfconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  CALL cl_set_field_pic(g_fgf.fgfconf,"","","",g_chr,"")
END FUNCTION
 
#str FUN-870143 add
FUNCTION t200_Calib_Result_q()   #校驗紀錄查詢
 
   LET g_rec_for = 0 
   IF cl_null(g_fgg[l_ac].fgg03) THEN
      RETURN
   END IF
 
   OPEN WINDOW t200_1 WITH FORM "afa/42f/afat2001"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_locale("afat2001")
 
   LET g_sql =" SELECT for02,for03,fgd02,for04 ",
              #"   FROM for_file LEFT OUTER fgd_file JOIN ON for03 = fgd01",   #No.TQC-9B0030 mark
              "   FROM for_file LEFT OUTER JOIN fgd_file ON for03 = fgd01",    #No.TQC-9B0030 mod
              "  WHERE for01 ='",g_fgf.fgf01 CLIPPED,"'", 
              "    AND for02 =" ,g_fgg[l_ac].fgg02
   PREPARE t200_for1 FROM g_sql
   DECLARE for_curs1 CURSOR FOR t200_for1    #SCROLL CURSOR
   IF STATUS THEN
      CALL cl_err("for_cus1",STATUS,1)
   END IF
 
   CALL g_for.clear()
   LET g_cnt = 1
   LET g_rec_for = 0
 
   FOREACH for_curs1 INTO g_for[g_cnt].* 
      IF SQLCA.sqlcode THEN
         CALL cl_err("foreach:",SQLCA.sqlcode,0)
         RETURN
      END IF
      LET g_cnt = g_cnt + 1 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_for.deleteElement(g_cnt)
   LET g_rec_for = g_cnt -1
   DISPLAY g_cnt to FORMONLY.cn4
 
   WHILE TRUE
      CALL cl_set_act_visible("accept,cancel", FALSE)
      DISPLAY ARRAY g_for TO s_for.* ATTRIBUTE(COUNT=g_rec_for,UNBUFFERED)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac_for = ARR_CURR()
            CALL cl_show_fld_cont()  
 
         ON ACTION help
            CALL cl_show_help()
            EXIT DISPLAY
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()        
 
         ON ACTION exit
            LET INT_FLAG=1
            LET g_action_choice="exit"
            EXIT DISPLAY
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION accept
            LET g_action_choice="detail"
            LET l_ac_for = ARR_CURR()
            EXIT DISPLAY
 
         ON ACTION cancel
            LET INT_FLAG=1
            LET g_action_choice="exit"
            EXIT DISPLAY
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
 
         ON ACTION about    
            CALL cl_about() 
      
         ON ACTION exporttoexcel   
            IF cl_chk_act_auth() THEN
              #str MOD-8B0255 mod
              #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_for),'','')
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               LET page = f.FindNode("Page","page01")
               CALL cl_export_to_excel(page,base.TypeInfo.create(g_for),'','')
              #end MOD-8B0255 mod
            END IF
            EXIT DISPLAY
 
         AFTER DISPLAY
            CONTINUE DISPLAY
      END DISPLAY
      CALL cl_set_act_visible("accept,cancel", TRUE)
      IF INT_FLAG=1 THEN 
         LET INT_FLAG=0 EXIT WHILE
      END IF
   END WHILE
 
   CLOSE WINDOW t200_1
END FUNCTION
#end FUN-870143 add
 
#FUN-5C0013 add
FUNCTION t200_Calib_Result()     #校驗紀錄維護
  DEFINE l_fgf01 LIKE fgf_file.fgf01         #校驗編號
  DEFINE l_fgg02 LIKE fgg_file.fgg02         #項次
  DEFINE l_fgg03 LIKE fgg_file.fgg03         #儀器編號
  DEFINE l_cnt   LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE l_sql   LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
  LET l_fgf01 = g_fgf.fgf01
  LET l_fgg02 = g_fgg[l_ac].fgg02
  LET l_fgg03 = g_fgg[l_ac].fgg03
 
  LET g_rec_for = 0 
  IF cl_null(l_fgg03) THEN
     RETURN
  END IF
 
  OPEN WINDOW t200_1 WITH FORM "afa/42f/afat2001"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  CALL cl_ui_locale("afat2001")
 
  CALL g_for.clear()
 
  LET l_cnt = 0
  SELECT count(for02) INTO l_cnt FROM for_file 
    WHERE for01 = l_fgf01 
      AND for02 = l_fgg02 
 
  IF l_cnt = 0 THEN
     #產生記錄
     CALL t200_gen_for()
  ELSE
     LET g_rec_for = l_cnt 
     DISPLAY l_cnt to FORMONLY.cn4
  END IF   
 
  LET l_sql =" SELECT for02,for03,fgd02,for04 ",
             #"   FROM for_file LEFT OUTER fgd_file JOIN ON for03 = fgd01",  #No.TQC-9B0030 mark
             "   FROM for_file LEFT OUTER JOIN fgd_file ON for03 = fgd01",   #No.TQC-9B0030 mod
             "  WHERE for01 ='", l_fgf01 CLIPPED,"'", 
             "    AND for02 =" , l_fgg02 
  PREPARE t200_for FROM l_sql
  DECLARE for_curs  CURSOR FOR t200_for    #SCROLL CURSOR
  IF STATUS THEN
     CALL cl_err("for_cus",STATUS,1)
  END IF
 
  LET l_cnt = 1
  BEGIN WORK
  FOREACH for_curs INTO g_for[l_cnt].* 
     IF SQLCA.sqlcode THEN
        CALL cl_err("foreach:",SQLCA.sqlcode,0)
        RETURN
     END IF
     LET l_cnt = l_cnt + 1 
  END FOREACH
 
  CALL g_for.deleteElement(l_cnt)
 
  #CALL cl_set_act_visible("accept,cancel", FALSE)
  #DISPLAY ARRAY g_for  TO  s_for.* ATTRIBUTE(COUNT=l_cnt,UNBUFFERED)
  #CALL cl_set_act_visible("accept,cancel", TRUE)
  
  CALL t200_modify_for()
  
  CLOSE WINDOW t200_1
END FUNCTION
 
#FUN-5C0013 add
FUNCTION t200_gen_for()
  DEFINE l_fgf01 LIKE fgf_file.fgf01    #校驗編號
  DEFINE l_fgg02 LIKE fgg_file.fgg02    #項次
  DEFINE l_fgg03 LIKE fgg_file.fgg03    #儀器編號
  DEFINE l_cnt   LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE l_sql   LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
  DEFINE l_for  DYNAMIC ARRAY OF RECORD
                for01     LIKE for_file.for01, #檢驗單號
                for02     LIKE for_file.for02, #項次
                for03     LIKE for_file.for03, #校正項目編號
                for04     LIKE for_file.for04  #檢驗結果
              END RECORD
  DEFINE l_err_flag LIKE type_file.num10        #No.FUN-680070 INTEGER
 
  LET l_fgf01 = g_fgf.fgf01             #校驗編號
  LET l_fgg02 = g_fgg[l_ac].fgg02       #項 次
  LET l_fgg03 = g_fgg[l_ac].fgg03       #儀器編號
 
  LET l_err_flag = 0
  LET l_sql = " SELECT fgb03 FROM fgb_file ",
              "  WHERE fgb01 ='", l_fgg03 ,"'"
 
  PREPARE t200_fgb FROM l_sql
  DECLARE fgb_curs  CURSOR FOR t200_fgb    #SCROLL CURSOR
 
  LET l_cnt = 1
  BEGIN WORK
  FOREACH fgb_curs INTO l_for[l_cnt].for03 
     LET l_for[l_cnt].for01 = l_fgf01 CLIPPED 
     LET l_for[l_cnt].for02 = l_fgg02 CLIPPED 
     LET l_for[l_cnt].for04 = "" 
     INSERT INTO for_file VALUES(l_for[l_cnt].*)
     IF SQLCA.sqlcode THEN
#        CALL cl_err("ins for",SQLCA.sqlcode,0)         #No.FUN-660127
         CALL cl_err3("ins","for_file",l_for[l_cnt].for01,l_for[l_cnt].for02,SQLCA.SQLCODE,"","ins for",1)  #No.FUN-660127
        LET l_err_flag = 1
        EXIT FOREACH
     END IF
     LET l_cnt = l_cnt + 1
  END FOREACH  
 
  IF l_err_flag THEN
     ROLLBACK WORK
  ELSE 
     COMMIT WORK
  END IF
  
  LET l_cnt = l_cnt - 1
  LET g_rec_for = l_cnt
  DISPLAY g_rec_for to FORMONLY.cn4  
END FUNCTION
 
#FUN-5C0012 add
FUNCTION t200_modify_for()
  DEFINE l_ac2     LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE l_sql     LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
  DEFINE l_lock_sw LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
  DEFINE l_for_t  RECORD 
           for02     LIKE for_file.for02, #項次
           for03     LIKE for_file.for03, #校正項目編號
           fgd02     LIKE fgd_file.fgd02, #校正項目名稱
           for04     LIKE for_file.for04  #檢驗結果
         END RECORD
 
  LET l_sql = " SELECT * FROM for_file WHERE for01 = ? AND for02=? AND for03=? FOR UPDATE "
  LET l_sql=cl_forupd_sql(l_sql)
  DECLARE t200_for_cl CURSOR FROM l_sql
 
  INPUT ARRAY g_for WITHOUT DEFAULTS FROM s_for.*
            ATTRIBUTE(COUNT=g_rec_for,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW= FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
        BEFORE INPUT
            IF g_rec_for != 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF
 
        BEFORE ROW
            LET l_ac2 = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
	    BEGIN WORK
 
            OPEN t200_for_cl USING g_fgf.fgf01,g_for[l_ac2].for02,g_for[l_ac2].for03
            IF STATUS THEN
               CALL cl_err("OPEN t200_for_cl:", STATUS, 1)
               CLOSE t200_for_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            LET l_for_t.* = g_for[l_ac2].*  #BACKUP
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_for[l_ac2].* = l_for_t.*
               CLOSE t200_for_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_for[l_ac2].for02,-263,1)
               LET g_for[l_ac2].* = l_for_t.*
            ELSE
                UPDATE for_file SET
                       for04=g_for[l_ac2].for04
                WHERE for01 = g_fgf.fgf01 
                  AND for02 = g_for[l_ac2].for02
                  AND for03 = g_for[l_ac2].for03
                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#                   CALL cl_err('upd for',SQLCA.sqlcode,0)         #No.FUN-660127
                    CALL cl_err3("upd","for_file",g_fgf.fgf01,g_for[l_ac2].for02,SQLCA.SQLCODE,"","upd for",1)  #No.FUN-660127
                   LET g_for[l_ac2].* = l_for_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
            END IF
 
 
        AFTER ROW
            LET l_ac2 = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_for[l_ac2].* = l_for_t.*
               CLOSE t200_for_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t200_for_cl
            COMMIT WORK
 
        ON ACTION CONTROLG 
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
  
        ON ACTION help          
           CALL cl_show_help()  
   
   END INPUT                   
 
END FUNCTION
 
 
#Patch....NO.MOD-5A0095 <002,003,001> #
