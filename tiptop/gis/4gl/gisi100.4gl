# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: gisi100.4gl
# Descriptions...: 銷項發票底稿維護作業
# Date & Author..: 02/04/15 By Danny
# Modify.........: No.FUN-4B0046 04/11/18 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0046 04/12/08 By Smapmin 加入權限控管
# Modify.........: No.FUN-540006 05/04/25 By day  新增"匯出"按鈕
# Modify.........: No.FUN-550074 05/05/23 By Will 單據編號放大
# Modify.........: No.FUN-570108 05/07/13 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-580006 05/08/11 By ice 修正發票底稿作業與航天金穗防偽稅控系統接口
# Modify.........: No.MOD-590044 05/10/21 By Carrier 修改發票匯出/產品類型碼內容
# Modify.........: No.MOD-5A0183 05/10/25 By day 調用gisi1001時，去除對isa11,isa12,isa14的非空限制
# Modify.........: No.TQC-5B0049 05/11/08 By Claire excel轉功能失效
# Modify.........: No.FUN-5B0116 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.TQC-5B0175 05/12/02 By ice 修改單頭后,一并更新單身;修改scroll cursor寫法
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680022 06/08/29 By Tracy s_rdatem()增加一個訂單日的參數
# Modify.........: No.FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No.FUN-690009 06/09/14 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-690022 06/09/19 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0009 06/10/13 By jamie 1.FUNCTION i100()_q 一開始應清空g_isa.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-680074 06/12/27 By Smapmin 為因應s_rdatem.4gl程式內對於dbname的處理,故LET g_dbs2=g_dbs,'.'
# Modify.........: No.MOD-720018 07/02/05 By Smapmin 刪除發票時,應將axrt300的發票號碼清空
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/09 By TSD.odyliao 自定欄位功能修改
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: No.TQC-8C0070 09/02/20 By mike MSV BUG
# Modify.........: No.FUN-920166 09/02/20 By alex g_dbs2改為使用s_dbstring
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980274 09/08/26 By Carrier isb08/isb09/isb09x/isb09t非負控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/10 By douzh GP5.2集團架構sub相關修改
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B90130 11/10/29 BY wujie  增加g_argv2，发票代码
# Modify.........: No.FUN-910088 12/01/16 By chenjing 增加數量欄位小數取位
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.FUN-C60033 12/06/12 By minpp 1.isa_file key增加 isa02，修改重複檢查判斷 2.增加IF g_oaz.oaz92 = 'Y' 则单身总金额不可超过单头金额
# Modify.........: No.FUN-C60033 12/07/03 By minpp 1.isb_file key增加isb11 2.若oaz92 = 'Y' 且大陆版时,账款编号开窗q_omf，放开票单号(07/06)
# Modify.........: No.FUN-C60033 12/07/11 By xuxz 修改串查接口
# Modify.........: No.FUN-C60033 12/07/13 By minpp isb08/isb09/isb09x/isb09t可以为负控管
# Modify.........: No.TQC-CB0046 12/11/15 By yuhuabao isa00的開啟mark掉
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D50034 13/05/14 By zhangweib 发票咨询写入isg_file/ish_file,并调整负数行至正数行中

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_isa           RECORD LIKE isa_file.*,
    g_isa_t         RECORD LIKE isa_file.*,
    g_buf           LIKE type_file.chr20,   #NO.FUN-690009 VARCHAR(20)
    g_wc,g_sql      STRING,  #No.FUN-580092 HCN
    g_argv1	    LIKE isa_file.isa04,
    g_isb           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                    isb03   LIKE isb_file.isb03,
                    isb04   LIKE isb_file.isb04,
                    isb05   LIKE isb_file.isb05,
                    isb06   LIKE isb_file.isb06,
                    isb07   LIKE isb_file.isb07,
                    isb08   LIKE isb_file.isb08,
                    isb09   LIKE isb_file.isb09,
                    isb09x  LIKE isb_file.isb09x,
                    isb09t  LIKE isb_file.isb09t,
                    isb10   LIKE isb_file.isb10
                    #FUN-840202 --start---
                   ,isbud01 LIKE isb_file.isbud01,
                    isbud02 LIKE isb_file.isbud02,
                    isbud03 LIKE isb_file.isbud03,
                    isbud04 LIKE isb_file.isbud04,
                    isbud05 LIKE isb_file.isbud05,
                    isbud06 LIKE isb_file.isbud06,
                    isbud07 LIKE isb_file.isbud07,
                    isbud08 LIKE isb_file.isbud08,
                    isbud09 LIKE isb_file.isbud09,
                    isbud10 LIKE isb_file.isbud10,
                    isbud11 LIKE isb_file.isbud11,
                    isbud12 LIKE isb_file.isbud12,
                    isbud13 LIKE isb_file.isbud13,
                    isbud14 LIKE isb_file.isbud14,
                    isbud15 LIKE isb_file.isbud15
                    #FUN-840202 --end--
                    END RECORD,
    g_isb_t         RECORD                 #程式變數 (舊值)
                    isb03   LIKE isb_file.isb03,
                    isb04   LIKE isb_file.isb04,
                    isb05   LIKE isb_file.isb05,
                    isb06   LIKE isb_file.isb06,
                    isb07   LIKE isb_file.isb07,
                    isb08   LIKE isb_file.isb08,
                    isb09   LIKE isb_file.isb09,
                    isb09x  LIKE isb_file.isb09x,
                    isb09t  LIKE isb_file.isb09t,
                    isb10   LIKE isb_file.isb10
                    #FUN-840202 --start---
                   ,isbud01 LIKE isb_file.isbud01,
                    isbud02 LIKE isb_file.isbud02,
                    isbud03 LIKE isb_file.isbud03,
                    isbud04 LIKE isb_file.isbud04,
                    isbud05 LIKE isb_file.isbud05,
                    isbud06 LIKE isb_file.isbud06,
                    isbud07 LIKE isb_file.isbud07,
                    isbud08 LIKE isb_file.isbud08,
                    isbud09 LIKE isb_file.isbud09,
                    isbud10 LIKE isb_file.isbud10,
                    isbud11 LIKE isb_file.isbud11,
                    isbud12 LIKE isb_file.isbud12,
                    isbud13 LIKE isb_file.isbud13,
                    isbud14 LIKE isb_file.isbud14,
                    isbud15 LIKE isb_file.isbud15
                    #FUN-840202 --end--
                    END RECORD,
     g_wc2          string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,    #NO.FUN-690009 SMALLINT     #單身筆數
    l_ac            LIKE type_file.num5     #NO.FUN-690009 SMALLINT     #目前處理的ARRAY CNT

DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt           LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE g_before_input_done    LIKE type_file.num5     #NO.FUN-690009 SMALLINT   #No.FUN-570108
DEFINE g_msg           LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE g_curs_index    LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE g_jump          LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE g_no_ask        LIKE type_file.num5     #NO.FUN-690009 SMALLINT
DEFINE g_chr           LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(01)
DEFINE g_dbs2          LIKE type_file.chr30    #TQC-680074
DEFINE g_plant2        LIKE type_file.chr10    #FUN-980020
DEFINE g_argv2         LIKE isa_file.isa02     #No.FUN-B90130
DEFINE g_isb07_t       LIKE isb_file.isb07     #FUN-910088--add--
#No.FUN-D50034 ---Add--- Start
DEFINE g_isg           RECORD LIKE isg_file.*
DEFINE g_ish           DYNAMIC ARRAY OF RECORD
          ish02        LIKE ish_file.ish02,
          ish03        LIKE ish_file.ish03,
          ish04        LIKE ish_file.ish04,
          ish06        LIKE ish_file.ish06,
          ish05        LIKE ish_file.ish05,
          ish07        LIKE ish_file.ish07,
          ish08        LIKE ish_file.ish08,
          ish09        LIKE ish_file.ish09,
          ish10        LIKE ish_file.ish10,
          ish11        LIKE ish_file.ish11,
          ish12        LIKE ish_file.ish12,
          ish13        LIKE ish_file.ish13,
          ish14        LIKE ish_file.ish14,
          ish15        LIKE ish_file.ish15,
          ish16        LIKE ish_file.ish16
                       END RECORD
DEFINE g_ish_t         RECORD
          ish02        LIKE ish_file.ish02,
          ish03        LIKE ish_file.ish03,
          ish04        LIKE ish_file.ish04,
          ish06        LIKE ish_file.ish06,
          ish05        LIKE ish_file.ish05,
          ish07        LIKE ish_file.ish07,
          ish08        LIKE ish_file.ish08,
          ish09        LIKE ish_file.ish09,
          ish10        LIKE ish_file.ish10,
          ish11        LIKE ish_file.ish11,
          ish12        LIKE ish_file.ish12,
          ish13        LIKE ish_file.ish13,
          ish14        LIKE ish_file.ish14,
          ish15        LIKE ish_file.ish15,
          ish16        LIKE ish_file.ish16
                       END RECORD
DEFINE g_rec_b1        LIKE type_file.num5
#No.FUN-D50034 ---Add--- End
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)  #No.FUN-B90130

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GIS")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098

#  #-----TQC-680074---------
#  IF cl_db_get_database_type() = 'IFX' THEN
#     LET g_dbs2 = g_dbs CLIPPED,':'
#  ELSE
#     LET g_dbs2 = g_dbs CLIPPED,'.'
#  END IF
#  #-----END TQC-680074-----
   LET g_plant2 = g_plant                    #FUN-980020
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)    #FUN-920166

    INITIALIZE g_isa.* TO NULL
    INITIALIZE g_isa_t.* TO NULL

    LET g_forupd_sql = "SELECT  * FROM isa_file WHERE isa01 = ? AND isa02=? AND isa04 = ? FOR UPDATE"  #FUN-C60033 add-isa02
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR

    OPEN WINDOW i100_w WITH FORM "gis/42f/gisi100"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()
    #FUN-C60033--add--by xuxz--str
    SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file
    IF g_oaz.oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
      #CALL cl_reset_qry_btn("isa04","axrt320")
       CALL cl_reset_qry_btn("isa04","axmt670")
    ELSE
       CALL cl_reset_qry_btn("isa04","axrt300")
    END IF
    #FUN-C60033--add--by xuxz --end

    IF NOT cl_null(g_argv1) THEN CALL i100_q() END IF
    CALL i100_menu()
    CLOSE WINDOW i100_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
END MAIN

FUNCTION i100_curs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    IF cl_null(g_argv1) THEN
       CLEAR FORM
       CALL g_isb.clear()
       CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

   INITIALIZE g_isa.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件  No.FUN-580006
	   isa00,  isa01, isa02, isa03, isa04, isa05, isa051, isa052, isa053,
           isa054, isa06, isa061,isa062,isa08, isa08x,isa08t, isa07,
	   isauser,isamodu,isadate,isagrup,isamodd
           #FUN-840202   ---start---
           ,isaud01,isaud02,isaud03,isaud04,isaud05,
           isaud06,isaud07,isaud08,isaud09,isaud10,
           isaud11,isaud12,isaud13,isaud14,isaud15
           #FUN-840202    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
           #FUN-C60033--07/06--STR
            IF INFIELD(isa04) THEN    #客戶
               SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file WHERE oaz00='0'
               IF g_oaz.oaz92='Y' AND g_aza.aza26='2' THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_omf"
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.where = " omf00=isa04 AND omf01=isa01 AND omf02=isa02 "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO isa04
                  NEXT FIELD isa04
               END IF
            END IF
           #FUN-C60033--07/06--end
            IF INFIELD(isa05) THEN    #客戶
#              CALL q_occ(0,0,g_isa.isa05) RETURNING g_isa.isa05
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO isa05
               NEXT FIELD isa05
            END IF
            IF INFIELD(isa06) THEN    #稅別
#              CALL q_gec(0,0,g_isa.isa06,'2') RETURNING g_isa.isa06
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gec"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO isa06
               NEXT FIELD isa06
            END IF
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF INT_FLAG THEN RETURN END IF
       CONSTRUCT g_wc2 ON isb03,isb04,isb05,isb06,isb07,isb08,isb09,
                          isb09x,isb09t,isb10
                          #No.FUN-840202 --start--
                          ,isbud01,isbud02,isbud03,isbud04,isbud05
                          ,isbud06,isbud07,isbud08,isbud09,isbud10
                          ,isbud11,isbud12,isbud13,isbud14,isbud15
                          #No.FUN-840202 ---end---
            FROM s_isb[1].isb03,s_isb[1].isb04,s_isb[1].isb05,
                 s_isb[1].isb06,s_isb[1].isb07,s_isb[1].isb08,
                 s_isb[1].isb09,s_isb[1].isb09x,s_isb[1].isb09t,
                 s_isb[1].isb10
                #No.FUN-840202 --start--
                ,s_isb[1].isbud01,s_isb[1].isbud02,s_isb[1].isbud03
                ,s_isb[1].isbud04,s_isb[1].isbud05,s_isb[1].isbud06
                ,s_isb[1].isbud07,s_isb[1].isbud08,s_isb[1].isbud09
                ,s_isb[1].isbud10,s_isb[1].isbud11,s_isb[1].isbud12
                ,s_isb[1].isbud13,s_isb[1].isbud14,s_isb[1].isbud15
                #No.FUN-840202 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            IF INFIELD(isb04) THEN    #料號
#              CALL q_ima(0,0,g_isb[1].isb04) RETURNING g_isb[1].isb04
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO isb04
               NEXT FIELD isb04
            END IF
            IF INFIELD(isb07) THEN    #單位
#              CALL q_gfe(0,0,g_isb[1].isb07) RETURNING g_isb[1].isb07
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO isb07
               NEXT FIELD isb07
            END IF
            IF INFIELD(isb10) THEN    #產品類別
#              CALL q_oba(0,0,g_isb[1].isb10) RETURNING g_isb[1].isb10
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oba"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO isb10
               NEXT FIELD isb10
            END IF
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
       LET g_wc=" isa04='",g_argv1,"' AND isa02 ='",g_argv2,"'"   #No.FUN-B90130
       LET g_wc2= ' 1=1'
    END IF

   #LET g_sql="SELECT isa01,isa04 FROM isa_file ", # 組合出 SQL 指令              #FUN-C60033
    LET g_sql="SELECT isa01,isa02,isa04 FROM isa_file ", # 組合出 SQL 指令        #FUN-C60033
              " WHERE ",g_wc CLIPPED, " ORDER BY isa04,isa01 " #MOD-590044
    PREPARE i100_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i100_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i100_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM isa_file WHERE ",g_wc CLIPPED
    PREPARE i100_precount FROM g_sql
    DECLARE i100_count CURSOR FOR i100_precount
END FUNCTION


FUNCTION i100_menu()

   WHILE TRUE
      CALL i100_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i100_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i100_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i100_u()
            END IF
#No.FUN-580006 --start--
         WHEN "other_file"
            IF cl_chk_act_auth() THEN
               CALL i100_1()
            END IF
#No.FUN-580006 --end--
        #No.FUN-D50034 ---Add--- Start
         WHEN "adjustment"
            IF cl_chk_act_auth() THEN
               CALL i100_adj()
            END IF
        #No.FUN-D50034 ---Add--- End
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i100_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#No.FUN-540006--begin
         WHEN "invoiceexport"
            IF cl_chk_act_auth() THEN
               LET g_msg="gisp110 '",g_isa.isa04,"'"
               #CALL cl_cmdrun(g_msg)      #FUN-660216 remark
               CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
            END IF
#No.FUN-540006--end
         WHEN "exporttoexcel"     #FUN-4B0046
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_isb),'','')
            END IF
         #No.FUN-6A0009-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_isa.isa01 IS NOT NULL THEN
                LET g_doc.column1 = "isa01"
               #LET g_doc.column2 = "isa02"       #TQC-8C0070
               #LET g_doc.column3 = "isa04" #TQC-8C0070
                LET g_doc.column2 = "isa04"       #TQC-8C0070
                LET g_doc.value1 = g_isa.isa01
               #LET g_doc.value2 = g_isa.isa02    #TQC-8C0070
               #LET g_doc.value3 = g_isa.isa04    #TQC-8C0070
                LET g_doc.value2 = g_isa.isa04    #TQC-8C0070
                CALL cl_doc()
             END IF
          END IF
        #No.FUN-6A0009-------add--------end----
      END CASE
   END WHILE
      CLOSE i100_cs
END FUNCTION

FUNCTION i100_a()
#No.FUN-580006 --start--
    DEFINE l_oma03 LIKE oma_file.oma03
    DEFINE l_oma32 LIKE oma_file.oma32
    DEFINE l_oma02 LIKE oma_file.oma02
    DEFINE l_oma11 LIKE oma_file.oma11
    DEFINE l_oma12 LIKE oma_file.oma12
    DEFINE l_isg   RECORD LIKE isg_file.*
#No.FUN-580006 --end--
    MESSAGE ""
    CLEAR FORM
    CALL g_isb.clear()
    INITIALIZE g_isa.* TO NULL
    LET g_isa_t.*=g_isa.*
    LET g_isa.isa00 = '1'      #人工
    LET g_isa.isa07 = '0'      #未匯出
    LET g_isa.isa08 = 0
    LET g_isa.isa08x= 0
    LET g_isa.isa08t= 0
    LET g_isa.isauser = g_user
    LET g_isa.isaoriu = g_user #FUN-980030
    LET g_isa.isaorig = g_grup #FUN-980030
    LET g_isa.isadate = g_today
    LET g_isa.isagrup = g_grup
    LET g_isa.isalegal = g_legal  #FUN-980011 add
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i100_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                      # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_isa.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_isb.clear()
            EXIT WHILE
        END IF
        IF cl_null(g_isa.isa04) THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        IF g_isa.isa01 IS NULL THEN LET g_isa.isa01 = ' ' END IF
        INSERT INTO isa_file VALUES(g_isa.*)
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_isa.isa04,SQLCA.sqlcode,0)   #No.FUN-660146
           CALL cl_err3("ins","isa_file",g_isa.isa01,g_isa.isa02,SQLCA.sqlcode,"","",1)  #No.FUN-660146
           CONTINUE WHILE
        END IF
#No.FUN-580006 --start--
        SELECT oma03,oma32,oma02 INTO l_oma03,l_oma32,l_oma02
          FROM oma_file
         WHERE oma01 = g_isa.isa04
        #LET p_dbs = g_dbs CLIPPED   #TQC-680074
        #CALL s_rdatem(l_oma03,l_oma32,l_oma02,g_isa.isa03,l_oma02,p_dbs)  #新增傳入參數p_dbs #No.FUN-680022 add l_oma02   #TQC-680074
        #CALL s_rdatem(l_oma03,l_oma32,l_oma02,g_isa.isa03,l_oma02,g_dbs2)  #No.FUN-680022 add l_oma02   #TQC-680074  #FUN-980020 mark
        CALL s_rdatem(l_oma03,l_oma32,l_oma02,g_isa.isa03,l_oma02,g_plant2) #FUN-980020
             RETURNING l_oma11,l_oma12
        UPDATE oma_file SET oma09=g_isa.isa03,oma10=g_isa.isa01,
                            oma11=l_oma11,    oma12 =l_oma12
        WHERE oma01 = g_isa.isa04
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_isa.isa04,SQLCA.sqlcode,0)   #No.FUN-660146
           CALL cl_err3("upd","oma_file",g_isa.isa04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660146
        END IF
#No.FUN-580006 --end--
      #FUN-C60033--MOD--STR
      # SELECT isa01,isa04 INTO g_isa.isa01,g_isa.isa04 FROM isa_file
      #  WHERE isa01 = g_isa.isa01 AND isa04 = g_isa.isa04
        SELECT isa01,isa02,isa04 INTO g_isa.isa01,g_isa.isa02,g_isa.isa04 FROM isa_file
         WHERE isa01 = g_isa.isa01 AND isa04 = g_isa.isa04 AND isa02=g_isa.isa02
      #FUN-C60033--MOD--END
        COMMIT WORK
        #No.FUN-D50034 ---Add--- Start
         INITIALIZE l_isg.* TO NULL
         LET l_isg.isg01 = g_isa.isa04
         LET l_isg.isg02 = 0
         LET l_isg.isg03 = g_isa.isa051
         LET l_isg.isg04 = g_isa.isa052
         LET l_isg.isg05 = g_isa.isa053
         LET l_isg.isg06 = g_isa.isa054
         LET l_isg.isg07 = g_isa.isa10
         LET l_isg.isg08 = Null
         LET l_isg.isg09 = Null
         LET l_isg.isg10 = Null
         LET l_isg.isg11 = g_isa.isa13
         LET l_isg.isg12 = g_isa.isa15
         LET l_isg.isg13 = NULL
         INSERT INTO isg_file VALUES(l_isg.*)
         IF STATUS != 0 OR SQLCA.sqlerrd[3] < 1 THEN
            CALL cl_err3("ins","isg_file",l_isg.isg01,"",SQLCA.SQLCODE,"","ins isg",1)
         END IF
        #No.FUN-D50034 ---Add--- End
        CALL i100_b()  #FUN-C60033
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i100_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(1)
        l_n             LIKE type_file.num5,    #NO.FUN-690009 SMALLINT
        l_n1            LIKE type_file.num5,    #FUN-C60033
        l_count         LIKE type_file.num5     #NO.FUN-690009 SMALLINT  #No.FUN-580006
    DEFINE li_result    LIKE type_file.num5     #FUN-C60033
#No.FUN-580006 --start--
    DISPLAY BY NAME
	g_isa.isa00, g_isa.isa01, g_isa.isa02, g_isa.isa03,
        g_isa.isa04, g_isa.isa05, g_isa.isa051,g_isa.isa052,
	g_isa.isa053,g_isa.isa054,
        g_isa.isa06, g_isa.isa061,g_isa.isa062,
        g_isa.isa08, g_isa.isa08x,g_isa.isa08t,g_isa.isa07,
        g_isa.isauser,g_isa.isadate,g_isa.isagrup,
        g_isa.isamodu,g_isa.isamodd
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT BY NAME g_isa.isaoriu,g_isa.isaorig,
	g_isa.isa00, g_isa.isa01, g_isa.isa02, g_isa.isa03,
        g_isa.isa04, g_isa.isa05, g_isa.isa051,g_isa.isa052,
	g_isa.isa053,g_isa.isa054,
        g_isa.isa06, g_isa.isa061,g_isa.isa062,
        g_isa.isa08, g_isa.isa08x,g_isa.isa08t,g_isa.isa07,
        g_isa.isauser,g_isa.isadate,g_isa.isagrup,
        g_isa.isamodu,g_isa.isamodd
        #FUN-840202     ---start---
        ,g_isa.isaud01,g_isa.isaud02,g_isa.isaud03,g_isa.isaud04,
        g_isa.isaud05,g_isa.isaud06,g_isa.isaud07,g_isa.isaud08,
        g_isa.isaud09,g_isa.isaud10,g_isa.isaud11,g_isa.isaud12,
        g_isa.isaud13,g_isa.isaud14,g_isa.isaud15
        #FUN-840202     ----end----
        WITHOUT DEFAULTS

       #NO.Fun-550074  --start
       BEFORE INPUT
           CALL cl_set_docno_format("isa04")
       #NO.Fun-550074  --end
#No.FUN-570108 --start--
           LET g_before_input_done = FALSE
           CALL i100_set_entry(p_cmd)
           CALL i100_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
#No.FUN-570108 --end--

        AFTER FIELD isa01
           SELECT count(*) INTO l_count FROM isa_file
           #  WHERE isa01 = g_isa.isa01 AND isa04 !=g_isa.isa04   #FUN-C60033  MARK
              WHERE isa01 = g_isa.isa01 AND isa02 !=g_isa.isa02 AND isa04 !=g_isa.isa04   #FUN-C60033 add
           IF l_count IS NULL THEN LET l_count =0 END IF
           IF l_count >1 THEN NEXT FIELD isa01 END IF
           #FUN-C60033--ADD--STR
           IF NOT cl_null(g_isa.isa01) THEN
              SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file WHERE oaz00='0'
              IF g_oaz.oaz92='Y' THEN
                 SELECT omf00,omf05,omf06,SUM(omf19),SUM(omf19x),SUM(omf19t) INTO g_isa.isa04,g_isa.isa05
                  ,g_isa.isa06,g_isa.isa08,g_isa.isa08x,g_isa.isa08t  FROM omf_file
                  WHERE omf01=g_isa.isa01
                    AND omf02=g_isa.isa02
                  GROUP BY omf00,omf05,omf06
                  DISPLAY g_isa.isa04 TO isa04
                  DISPLAY g_isa.isa05 TO isa05
                  DISPLAY g_isa.isa06 TO isa06
                  DISPLAY g_isa.isa08 TO isa08
                  DISPLAY g_isa.isa08x TO isa08x
                  DISPLAY g_isa.isa08t TO isa08t
                  IF NOT cl_null(g_isa.isa05) THEN
                     CALL i100_isa05('a')
                  END IF
                  IF NOT cl_null(g_isa.isa06) THEN
                     CALL i100_isa06('a')
                  END IF
               END IF
           END IF
           #FUN-C60033--ADD--END
        AFTER FIELD isa03
           IF g_isa.isa03 IS NULL THEN NEXT FIELD isa03 END IF
# Modify gisi100.per ...:Set isa051: REQUIRED
#No.FUN-580006 --end--

       #FUN-C60033---add--str
        AFTER FIELD isa02
            IF NOT cl_null(g_isa.isa02) THEN
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                  (p_cmd = "u" AND g_isa.isa02 != g_isa_t.isa02) THEN
                   SELECT COUNT(*) INTO l_n FROM isa_file
                    WHERE isa01 = g_isa.isa01
                      AND isa04 = g_isa.isa04
                      AND isa02 = g_isa.isa02
                   IF l_n > 0 THEN                  # Duplicated
                      CALL cl_err(g_isa.isa02,-239,0)
                      LET g_isa.isa04 = g_isa_t.isa02
                      DISPLAY BY NAME g_isa.isa02
                      NEXT FIELD isa02
                   END IF
                  SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file WHERE oaz00='0'
                  IF g_oaz.oaz92='Y' THEN
                     SELECT omf00,omf05,omf06,SUM(omf19),SUM(omf19x),SUM(omf19t) INTO g_isa.isa04,g_isa.isa05
                     ,g_isa.isa06,g_isa.isa08,g_isa.isa08x,g_isa.isa08t  FROM omf_file
                     WHERE omf01=g_isa.isa01
                       AND omf02=g_isa.isa02
                     GROUP BY omf00,omf05,omf06
                     DISPLAY g_isa.isa04 TO isa04
                     DISPLAY g_isa.isa05 TO isa05
                     DISPLAY g_isa.isa06 TO isa06
                     DISPLAY g_isa.isa08 TO isa08
                     DISPLAY g_isa.isa08x TO isa08x
                     DISPLAY g_isa.isa08t TO isa08t
                     IF NOT cl_null(g_isa.isa05) THEN
                        CALL i100_isa05('a')
                     END IF
                     IF NOT cl_null(g_isa.isa06) THEN
                        CALL i100_isa06('a')
                     END IF
                   END IF
               END IF

            END IF

       #FUN-C60033---add-end-

        AFTER FIELD isa04
            IF NOT cl_null(g_isa.isa04) THEN
                IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                  (p_cmd = "u" AND g_isa.isa04 != g_isa_t.isa04) THEN
                   SELECT COUNT(*) INTO l_n FROM isa_file
                    WHERE isa01 = g_isa.isa01
                      AND isa04 = g_isa.isa04
                      AND isa02 = g_isa.isa02       ##FUN-C60033 add
                   IF l_n > 0 THEN                  # Duplicated
                      CALL cl_err(g_isa.isa04,-239,0)
                      LET g_isa.isa04 = g_isa_t.isa04
                      DISPLAY BY NAME g_isa.isa04
                      NEXT FIELD isa04
                   END IF
                  #FUN-C60033--07/06--STR
                  SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file WHERE oaz00='0'
                  IF g_oaz.oaz92='Y' AND g_aza.aza26='2' THEN
                     LET l_n1=0
                     SELECT COUNT(*) INTO l_n1 FROM omf_file
                      WHERE omf00 = g_isa.isa04
                      IF l_n1<1 THEN
                         CALL cl_err(g_isa.isa04,'gis-006',0)
                         NEXT FIELD isa04
                      END IF
                   END IF
                 #FUN-C60033--07/06--END
                END IF
             END IF

        AFTER FIELD isa05
            IF NOT cl_null(g_isa.isa05) THEN
                IF g_isa_t.isa05 IS NULL OR g_isa.isa05 != g_isa_t.isa05 THEN
                   CALL i100_isa05('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_isa.isa05,g_errno,0) NEXT FIELD isa05
                   END IF
                END IF
            END IF

        AFTER FIELD isa06
            IF NOT cl_null(g_isa.isa06) THEN
               IF g_isa_t.isa06 IS NULL OR g_isa.isa06 != g_isa_t.isa06 THEN
                  CALL i100_isa06('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_isa.isa06,g_errno,0) NEXT FIELD isa06
                  END IF
               END IF
            END IF

        AFTER FIELD isa062
            IF NOT cl_null(g_isa.isa062) THEN
                IF g_isa.isa062 NOT MATCHES '[ABC]' THEN
                    NEXT FIELD isa062
                END IF
            END IF

        #FUN-840202     ---start---
        AFTER FIELD isaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----


        AFTER INPUT
           LET g_isa.isauser = s_get_data_owner("isa_file") #FUN-C10039
           LET g_isa.isagrup = s_get_data_group("isa_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF

        ON ACTION CONTROLP
            IF INFIELD(isa05) THEN    #客戶
#              CALL q_occ(0,0,g_isa.isa05) RETURNING g_isa.isa05
#              CALL FGL_DIALOG_SETBUFFER( g_isa.isa05 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ"
               LET g_qryparam.default1 = g_isa.isa05
               CALL cl_create_qry() RETURNING g_isa.isa05
#               CALL FGL_DIALOG_SETBUFFER( g_isa.isa05 )
               DISPLAY BY NAME g_isa.isa05
               NEXT FIELD isa05
            END IF
            IF INFIELD(isa06) THEN    #稅別
#              CALL q_gec(0,0,g_isa.isa06,'2') RETURNING g_isa.isa06
#              CALL FGL_DIALOG_SETBUFFER( g_isa.isa06 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gec"
               LET g_qryparam.default1 = g_isa.isa06
               LET g_qryparam.arg1 = '2'
               CALL cl_create_qry() RETURNING g_isa.isa06
#               CALL FGL_DIALOG_SETBUFFER( g_isa.isa06 )
               DISPLAY BY NAME g_isa.isa06
               NEXT FIELD isa06
            END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLF                        # 欄位說明
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

FUNCTION i100_isa05(p_cmd)
    DEFINE p_cmd      LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(1)
    DEFINE l_occ11    LIKE occ_file.occ11
    DEFINE l_occ18    LIKE occ_file.occ18
    DEFINE l_occ231   LIKE occ_file.occ231
    DEFINE l_occ261   LIKE occ_file.occ261
    DEFINE l_occacti  LIKE occ_file.occacti
    DEFINE l_ocj03    LIKE ocj_file.ocj03
    DEFINE l_nmt02    LIKE nmt_file.nmt02

    SELECT occ11,occ18,occ231,occ261,occacti
      INTO l_occ11,l_occ18,l_occ231,l_occ261,l_occacti
      FROM occ_file
     WHERE occ01 = g_isa.isa05
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100        LET g_errno = 'mfg2732'
         WHEN l_occacti = 'N'            LET g_errno = '9028'
   #FUN-690023------mod-------
         WHEN l_occacti MATCHES '[PH]'   LET g_errno = '9038'
  #FUN-690023------mod-------
         WHEN SQLCA.SQLCODE != 0         LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    DECLARE i100_curs2 CURSOR FOR
     SELECT ocj03,nmt02 FROM ocj_file,OUTER nmt_file
      WHERE ocj01 = g_isa.isa05 AND nmt_file.nmt01 = ocj02
    LET l_ocj03 = ''
    LET l_nmt02 = ''
    FOREACH i100_curs2 INTO l_ocj03,l_nmt02
       EXIT FOREACH
    END FOREACH
    LET g_isa.isa051 = l_occ18
    LET g_isa.isa052 = l_occ11
    LET g_isa.isa053 = l_occ231 CLIPPED,l_occ261 CLIPPED
    LET g_isa.isa054 = l_nmt02 CLIPPED,l_ocj03 CLIPPED
    DISPLAY BY NAME g_isa.isa051,g_isa.isa052,g_isa.isa053,g_isa.isa054
END FUNCTION

FUNCTION i100_isa06(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(1)
    DEFINE l_gec04   LIKE gec_file.gec04
    DEFINE l_gec05   LIKE gec_file.gec05
    DEFINE l_gec06   LIKE gec_file.gec06
    DEFINE l_gecacti LIKE gec_file.gecacti

    SELECT gec04,gec05,gec06,gecacti
      INTO l_gec04,l_gec05,l_gec06,l_gecacti
      FROM gec_file
     WHERE gec01 = g_isa.isa06 AND gec011='2'  #銷項
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3044'
         WHEN l_gecacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    LET g_isa.isa061 = l_gec04
    LET g_isa.isa062 = l_gec05     #發票種類
    DISPLAY BY NAME g_isa.isa061,g_isa.isa062
END FUNCTION

FUNCTION i100_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_isa.* TO NULL             #No.FUN-6A0009
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i100_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0 CLEAR FORM RETURN
       CALL g_isb.clear()
    END IF
    OPEN i100_count
    FETCH i100_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_isa.isa04,SQLCA.sqlcode,0)
        INITIALIZE g_isa.* TO NULL
    ELSE
        CALL i100_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i100_fetch(p_flisa)
    DEFINE
        p_flisa          LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(1)
        l_abso           LIKE type_file.num10    #NO.FUN-690009 INTEGER

    CASE p_flisa
        WHEN 'N' FETCH NEXT     i100_cs INTO g_isa.isa01,g_isa.isa02,g_isa.isa04    #FUN-C60033-add--isa02

        WHEN 'P' FETCH PREVIOUS i100_cs INTO g_isa.isa01,g_isa.isa02,g_isa.isa04    #FUN-C60033-add--isa02

        WHEN 'F' FETCH FIRST    i100_cs INTO g_isa.isa01,g_isa.isa02,g_isa.isa04    #FUN-C60033-add--isa02

        WHEN 'L' FETCH LAST     i100_cs INTO g_isa.isa01,g_isa.isa02,g_isa.isa04    #FUN-C60033-add--isa02

        WHEN '/'
         #CKP3
         IF (NOT g_no_ask) THEN
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
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump i100_cs INTO g_isa.isa01,g_isa.isa02,g_isa.isa04     #FUN-C60033-add--isa02

         LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
       CALL cl_err(g_isa.isa04,SQLCA.sqlcode,0)
       INITIALIZE g_isa.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flisa
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE

       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    #No.MOD-590044  --begin
    SELECT * INTO g_isa.* FROM isa_file WHERE isa01 = g_isa.isa01 AND isa04 = g_isa.isa04 AND isa02= g_isa.isa02  #No.TQC-5B0175  #FUN-C60033--add-isa02
    #No.MOD-590044  --end
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_isa.isa04,SQLCA.sqlcode,0)   #No.FUN-660146
       CALL cl_err3("sel","isa_file",g_isa.isa01,g_isa.isa04,SQLCA.sqlcode,"","",1)  #No.FUN-660146
    ELSE
       LET g_data_owner = g_isa.isauser  #FUN-4C0046
       LET g_data_group = g_isa.isagrup  #FUN-4C0046
       CALL i100_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION i100_show()
    DISPLAY BY NAME g_isa.isaoriu,g_isa.isaorig,
	g_isa.isa00, g_isa.isa01, g_isa.isa02, g_isa.isa03,
        g_isa.isa04, g_isa.isa05, g_isa.isa051,g_isa.isa052,
	g_isa.isa053,g_isa.isa054,g_isa.isa06, g_isa.isa061,
        g_isa.isa062,g_isa.isa08, g_isa.isa08x,g_isa.isa08t,
	g_isa.isa07, g_isa.isauser,g_isa.isadate,g_isa.isagrup,
        g_isa.isamodu,g_isa.isamodd
        #FUN-840202     ---start---
        ,g_isa.isaud01,g_isa.isaud02,g_isa.isaud03,g_isa.isaud04,
        g_isa.isaud05,g_isa.isaud06,g_isa.isaud07,g_isa.isaud08,
        g_isa.isaud09,g_isa.isaud10,g_isa.isaud11,g_isa.isaud12,
        g_isa.isaud13,g_isa.isaud14,g_isa.isaud15
        #FUN-840202     ----end----
        CALL i100_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

FUNCTION i100_u()
#No.FUN-580006 --start--
    DEFINE l_oma03 LIKE oma_file.oma03
    DEFINE l_oma32 LIKE oma_file.oma32
    DEFINE l_oma02 LIKE oma_file.oma02
    DEFINE l_oma11 LIKE oma_file.oma11
    DEFINE l_oma12 LIKE oma_file.oma12
#No.FUN-580006 --end--

   #IF cl_null(g_isa.isa04) THEN CALL cl_err('',-400,0) RETURN END IF           #FUN-C60033
    IF g_isa.isa04 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF            #FUN-C60033
    SELECT * INTO g_isa.* FROM isa_file
     WHERE isa01 = g_isa.isa01 AND isa04 = g_isa.isa04 AND isa02=g_isa.isa02    #FUN-C60033
    IF g_isa.isa07 != '0' THEN RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_isa_t.* = g_isa.*
    BEGIN WORK
    LET g_success = 'Y'

    OPEN i100_cl USING g_isa.isa01,g_isa.isa02,g_isa.isa04     #FUN-C60033--add--isa02
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl INTO g_isa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_isa.isa04,SQLCA.sqlcode,0)
       ROLLBACK WORK RETURN
    END IF
    CALL i100_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_isa.isamodu = g_user
        LET g_isa.isamodd = g_today
        CALL i100_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_isa.*=g_isa_t.*
            CALL i100_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF

        #No.TQC-5B0175 --start--
        #修改原單身key值
        IF g_isa.isa01 != g_isa_t.isa01 OR g_isa.isa04 != g_isa_t.isa04 OR g_isa.isa02 != g_isa_t.isa02 THEN   #FUN-C60033--add--isa02
           UPDATE isb_file SET isb01 = g_isa.isa01,
                               isb02 = g_isa.isa04,
                               isb11 = g_isa.isa02                 #FUN-C60033
                         WHERE isb01 = g_isa_t.isa01
                           AND isb02 = g_isa_t.isa04
                           AND isb11 = g_isa.isa02                 #FUN-C60033
           IF SQLCA.sqlcode THEN
#             CALL cl_err('isb',SQLCA.sqlcode,0)   #No.FUN-660146
              CALL cl_err3("upd","isb_file",g_isa_t.isa01,g_isa_t.isa04,SQLCA.sqlcode,"","isb",1)  #No.FUN-660146
              CONTINUE WHILE
           END IF
        END IF
        #No.TQC-5B0175 --end--
        UPDATE isa_file SET * = g_isa.*
         WHERE isa01 = g_isa_t.isa01 AND isa04 = g_isa_t.isa04  AND isa02 = g_isa_t.isa02  # COLAUTH?  #FUN-C60033--add--isa02
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_isa.isa04,SQLCA.sqlcode,0)   #No.FUN-660146
           CALL cl_err3("upd","isa_file",g_isa_t.isa01,g_isa_t.isa04,SQLCA.sqlcode,"","",1)  #No.FUN-660146
           CONTINUE WHILE
        END IF
#No.FUN-580006 --start--
        SELECT oma03,oma32,oma02 INTO l_oma03,l_oma32,l_oma02
          FROM oma_file
         WHERE oma01 = g_isa.isa04
        #CALL s_rdatem(l_oma03,l_oma32,l_oma02,g_isa.isa03,l_oma02,p_dbs)  #新增傳入參數p_dbs #No.FUN-680022 add l_oma02   #TQC-680074
        #CALL s_rdatem(l_oma03,l_oma32,l_oma02,g_isa.isa03,l_oma02,g_dbs2)  #No.FUN-680022 add l_oma02   #TQC-680074  #FUN-980020 mark
        CALL s_rdatem(l_oma03,l_oma32,l_oma02,g_isa.isa03,l_oma02,g_plant2) #No.FUN-980020
             RETURNING l_oma11,l_oma12
        UPDATE oma_file SET oma09=g_isa.isa03,oma10=g_isa.isa01,oma11=l_oma11,
                            oma12 =l_oma12
         WHERE oma01 = g_isa.isa04
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_isa.isa04,SQLCA.sqlcode,0)   #No.FUN-660146
           CALL cl_err3("upd","oma_file",g_isa.isa04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660146
        END IF
#No.FUN-580006 --end--
        EXIT WHILE
    END WHILE
    CLOSE i100_cl
    IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   #No.FUN-D50034 ---Add--- Start
    UPDATE isg_file SET isg05 = g_isa.isa053,
                        isg06 = g_isa.isa054
     WHERE isg01 = g_isa.isa04
   #No.FUN-D50034 ---Add--- End
END FUNCTION

FUNCTION i100_r()
   DEFINE l_cnt SMALLINT   #MOD-720018

    IF cl_null(g_isa.isa04) THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_isa.* FROM isa_file
     WHERE isa01 = g_isa.isa01 AND isa04 = g_isa.isa04 AND isa02 = g_isa.isa02 #FUN-C60033--add--isa02
    IF g_isa.isa07 != '0' THEN RETURN END IF
    BEGIN WORK

    OPEN i100_cl USING g_isa.isa01,g_isa.isa02,g_isa.isa04   #FUN-C60033--add--isa02
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl INTO g_isa.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_isa.isa04,SQLCA.sqlcode,0)
       ROLLBACK WORK RETURN
    END IF
    CALL i100_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL              #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "isa01"             #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "isa04"             #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "isa02"             #FUN-C60033
        LET g_doc.value1 = g_isa.isa01          #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_isa.isa04          #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_isa.isa02          #FUN-C60033
        CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
       DELETE FROM isa_file WHERE isa01 = g_isa.isa01
                              AND isa04 = g_isa.isa04
                              AND isa02 = g_isa.isa02         #FUN-C60033-add--isa02
       DELETE FROM isb_file WHERE isb01 = g_isa.isa01
                              AND isb02 = g_isa.isa04
      #No.FUN-D50034 ---Add--- Start
       IF g_isa.isa00 != '1' THEN
          DELETE FROM isg_file WHERE isg01 = g_isa.isa04
          DELETE FROM ish_file WHERE ish01 = g_isa.isa04
       END IF
      #No.FUN-D50034 ---Add--- End
       #-----MOD-720018---------
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM oma_file
         WHERE oma10 = g_isa.isa01
       IF l_cnt > 0 THEN
          UPDATE oma_file SET oma10 = NULL WHERE oma10 = g_isa.isa01
          IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err(g_isa.isa01,STATUS,0)
             ROLLBACK WORK
             RETURN
          END IF
       END IF
       #-----END MOD-720018-----
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)     #FUN-980011 add
          VALUES ('gisi100',g_user,g_today,g_msg,g_isa.isa04,'delete',g_plant,g_legal) #FUN-980011 add
       CLEAR FORM
       CALL g_isb.clear()
       INITIALIZE g_isa.* TO NULL
       MESSAGE ""
       CLEAR FORM
       CALL g_isb.clear()
         #CKP3
         OPEN i100_count
#FUN-B50065------begin---
         IF STATUS THEN
            CLOSE i100_count
            CLOSE i100_cl
            COMMIT WORK
            RETURN
         END IF
#FUN-B50065------end------
         FETCH i100_count INTO g_row_count
#FUN-B50065------begin---
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i100_count
            CLOSE i100_cl
            COMMIT WORK
            RETURN
         END IF
#FUN-B50065------end------
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i100_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i100_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i100_fetch('/')
         END IF
    END IF
    CLOSE i100_cl
    COMMIT WORK
END FUNCTION

FUNCTION i100_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #NO.FUN-690009  SMALLINT        #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,    #NO.FUN-690009  SMALLINT        #檢查重複用
    l_lock_sw       LIKE type_file.chr1,    #NO.FUN-690009  VARCHAR(1)         #單身鎖住否
    p_cmd           LIKE type_file.chr1,    #NO.FUN-690009  VARCHAR(1)         #處理狀態
    l_allow_insert  LIKE type_file.num5,    #NO.FUN-690009  SMALLINT        #可新增否
    l_allow_delete  LIKE type_file.num5,    #NO.FUN-690009  SMALLINT        #可刪除否
    l_isb09,l_isb09_1         LIKE isb_file.isb09     #FUN-C60033 ADD
  #No.FUN-D50034 ---Add--- Start 
   DEFINE l_flag    LIKE type_file.chr1    
   DEFINE l_cnt     LIKE type_file.num5    
   DEFINE l_gec07   LIKE gec_file.gec07    
   DEFINE l_ish     RECORD LIKE ish_file.* 
   DEFINE l_ish08   LIKE ish_file.ish08
   DEFINE t_ish08   LIKE ish_file.ish08
   DEFINE t_ish08_1 LIKE ish_file.ish08
   DEFINE l_ish01   LIKE ish_file.ish01
   DEFINE l_i       LIKE type_file.num5
  #No.FUN-D50034 ---Add--- End

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_isa.isa07 != '0' THEN RETURN END IF
    CALL cl_opmsg('b')

   #No.FUN-D50034 ---Add--- Start
    IF g_isa.isa00 <> '1' THEN RETURN END IF   
    LET l_flag = 'N'   
    DROP TABLE i100_tmpb
    SELECT * FROM ish_file WHERE 1 = 0 INTO TEMP i100_tmpb
    LET g_sql = "SELECT * FROM i100_tmpb WHERE ish08 < 0"
    PREPARE i100_sel_tmpb FROM g_sql
    DECLARE i100_tmpb_dec CURSOR FOR i100_sel_tmpb
    LET g_sql = "SELECT * FROM i100_tmpb ORDER BY ish01"
    PREPARE i100_sel_tmpb1 FROM g_sql
    DECLARE i100_tmpb_dec1 CURSOR FOR i100_sel_tmpb1
   #No.FUN-D50034 ---Add--- End
    
    LET g_forupd_sql =
       "SELECT isb03,isb04,isb05,isb06,isb07,isb08,isb09,isb09x,isb09t,isb10 ",
       ",isbud01,isbud02,isbud03,isbud04,isbud05,",
       "isbud06,isbud07,isbud08,isbud09,isbud10,",
       "isbud11,isbud12,isbud13,isbud14,isbud15",
       "  FROM isb_file ",
       "  WHERE isb01 = ?  ",
       "   AND isb02 = ? ",
       "   AND isb03 = ? ",
       "   AND isb11 = ? ",    #FUN-C60033-07/03
       "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t = 0

        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")

   #CKP2
   IF g_rec_b=0 THEN CALL g_isb.clear() END IF

   INPUT ARRAY g_isb WITHOUT DEFAULTS FROM s_isb.*

              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)


        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()

            #FUN-C60033--ADD--STR
            BEGIN WORK
            OPEN i100_cl USING g_isa.isa01,g_isa.isa02,g_isa.isa04
            IF STATUS THEN
               CALL cl_err("OPEN i100_cl:", STATUS, 1)
               CLOSE i100_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i100_cl INTO g_isa.*               # 對DB鎖定
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_isa.isa04,SQLCA.sqlcode,0)
               ROLLBACK WORK RETURN
            END IF
            #FUN-C60033--ADD--END

            IF g_rec_b >= l_ac THEN
               LET g_isb_t.* = g_isb[l_ac].*  #BACKUP
               LET g_isb07_t = g_isb[l_ac].isb07    #FUN-910088--add--
               LET p_cmd='u'
               #BEGIN WORK  #FUN-C60033

               OPEN i100_bcl USING g_isa.isa01,g_isa.isa04,g_isb_t.isb03,g_isa.isa02  #FUN-C60033-07/03 add-isa02
               IF STATUS THEN
                   CALL cl_err("OPEN i100_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
               ELSE
                   FETCH i100_bcl INTO g_isb[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_isb_t.isb03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_isb[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_isb[l_ac].* TO s_isb.*
              CALL g_isb.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            INSERT INTO isb_file(isb01,isb02,isb03,isb04,isb05,isb06,
                                 isb07,isb08,isb09,isb09x,isb09t,isb10,isb11   #FUN-C60033--07/03--isb11
                                  #FUN-840202 --start--
                                 ,isbud01,isbud02,isbud03,
                                  isbud04,isbud05,isbud06,
                                  isbud07,isbud08,isbud09,
                                  isbud10,isbud11,isbud12,
                                  isbud13,isbud14,isbud15,
                                  #FUN-840202 --end--
                                  isblegal) #FUN-980011 add
                   VALUES(g_isa.isa01,g_isa.isa04,g_isb[l_ac].isb03,
                          g_isb[l_ac].isb04,g_isb[l_ac].isb05,
                          g_isb[l_ac].isb06,g_isb[l_ac].isb07,
                          g_isb[l_ac].isb08,g_isb[l_ac].isb09,
                          g_isb[l_ac].isb09x,g_isb[l_ac].isb09t,
                          g_isb[l_ac].isb10,g_isa.isa02           #FUN-C60033--07/03--isa02
                          #FUN-840202 --start--
                         ,g_isb[l_ac].isbud01, g_isb[l_ac].isbud02,
                          g_isb[l_ac].isbud03, g_isb[l_ac].isbud04,
                          g_isb[l_ac].isbud05, g_isb[l_ac].isbud06,
                          g_isb[l_ac].isbud07, g_isb[l_ac].isbud08,
                          g_isb[l_ac].isbud09, g_isb[l_ac].isbud10,
                          g_isb[l_ac].isbud11, g_isb[l_ac].isbud12,
                          g_isb[l_ac].isbud13, g_isb[l_ac].isbud14,
                          g_isb[l_ac].isbud15,
                          #FUN-840202 --end--)
                          g_legal) #FUN-980011 add
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_isb[l_ac].isb03,SQLCA.sqlcode,0)   #No.FUN-660146
                CALL cl_err3("ins","isb_file",g_isa.isa01,g_isb[l_ac].isb03,SQLCA.sqlcode,"","",1)  #No.FUN-660146
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
                LET l_flag = 'Y'   #No.FUN-D50034   Add
            END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_isb[l_ac].* TO NULL      #900423
            LET g_isb_t.* = g_isb[l_ac].*         #新輸入資料
            LET g_isb[l_ac].isb08 = 0
            LET g_isb[l_ac].isb09 = 0
            LET g_isb[l_ac].isb09x= 0
            LET g_isb[l_ac].isb09t= 0
            LET g_isb07_t = NULL                  #FUN-910088--add--
            LET g_isb[l_ac].isb10=g_isf.isf02     #No.MOD-590044
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD isb03

        BEFORE FIELD isb03
            IF cl_null(g_isb[l_ac].isb03) THEN
               SELECT MAX(isb03) INTO g_isb[l_ac].isb03 FROM isb_file
                WHERE isb01 = g_isa.isa01 AND isb02 = g_isa.isa04
               IF cl_null(g_isb[l_ac].isb03) THEN LET g_isb[l_ac].isb03=0 END IF
               LET g_isb[l_ac].isb03 = g_isb[l_ac].isb03 + 1
            END IF

        BEFORE FIELD isb04                         #check 編號是否重複
           IF NOT cl_null(g_isa.isa01) AND
              NOT cl_null(g_isa.isa04) AND
              NOT cl_null(g_isb[l_ac].isb03) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_isb[l_ac].isb03 != g_isb_t.isb03) THEN
                  SELECT COUNT(*) INTO l_n FROM isb_file
                   WHERE isb01 = g_isa.isa01 AND isb02 = g_isa.isa04
                     AND isb03 = g_isb[l_ac].isb03 AND isb11 = g_isa.isa02  #FUN-C60033-07/03 add-isb11
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_isb[l_ac].isb03 = g_isb_t.isb03
                     #-------------NO.MOD-5A0095 START--------------
                     DISPLAY BY NAME g_isb[l_ac].isb03
                     #-------------NO.MOD-5A0095 END----------------
                     NEXT FIELD isb03
                  END IF
               END IF
           END IF

        AFTER FIELD isb04
           IF NOT cl_null(g_isb[l_ac].isb04) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_isb[l_ac].isb04 != g_isb_t.isb04) THEN
                  CALL i100_isb04(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_isb[l_ac].isb04,g_errno,0) NEXT FIELD isb04
                  END IF
               END IF
           END IF

        AFTER FIELD isb07
           IF NOT cl_null(g_isb[l_ac].isb07) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_isb[l_ac].isb07 != g_isb_t.isb07) THEN
                  SELECT gfe01 FROM gfe_file
                   WHERE gfe01 = g_isb[l_ac].isb07 AND gfeacti = 'Y'
                  IF STATUS THEN
#                    CALL cl_err(g_isb[l_ac].isb07,'aoo-012',0)    #No.FUN-660146
                     CALL cl_err3("sel","gfe_file",g_isb[l_ac].isb07,"","aoo-012","","",1)  #No.FUN-660146
                     NEXT FIELD isb07
                  END IF
               END IF
            #FUN-910088--add--start--
               IF NOT i100_isb08_check() THEN
                  LET g_isb07_t = g_isb[l_ac].isb07
                  NEXT FIELD isb08
               END IF
               LET g_isb07_t = g_isb[l_ac].isb07
            #FUN-910088--add--end--
           END IF

        #No.TQC-980274  --Begin
        AFTER FIELD isb08
           IF NOT i100_isb08_check() THEN NEXT FIELD isb08 END IF     #FUN-910088--add--
        #FUN-910088--mark--start--
        #  IF NOT cl_null(g_isb[l_ac].isb08) THEN
        #     IF g_isb[l_ac].isb08 < 0 THEN
        #        CALL cl_err(g_isb[l_ac].isb08,'axm-179',0)
        #        NEXT FIELD isb08
        #     END IF
        #  END IF
        #No.TQC-980274  --End
        #FUN-910088--mark--end--

        AFTER FIELD isb09
           IF NOT cl_null(g_isb[l_ac].isb09) THEN
           ##FUN-C60033--MARK--STR--07/13
           #  #No.TQC-980274  --Begin
           #  IF g_isb[l_ac].isb09 < 0 THEN
           #     CALL cl_err(g_isb[l_ac].isb09,'axm-179',0)
           #     NEXT FIELD isb09
           #  END IF
           #  #No.TQC-980274  --End
           # #FUN-C60033--MARK--END--07/13
               LET g_isb[l_ac].isb09x = g_isb[l_ac].isb09 * g_isa.isa061 /100
               LET g_isb[l_ac].isb09x = cl_digcut(g_isb[l_ac].isb09x,t_azi04)
               LET g_isb[l_ac].isb09t = g_isb[l_ac].isb09 + g_isb[l_ac].isb09x
               #-------------NO.MOD-5A0095 START--------------
               DISPLAY BY NAME g_isb[l_ac].isb09x
               DISPLAY BY NAME g_isb[l_ac].isb09t
               #-------------NO.MOD-5A0095 END----------------

               #FUN-C60033---ADD--STR
               SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file WHERE oaz00='0'
               IF g_oaz.oaz92='Y' THEN
                  SELECT SUM(isb09) INTO l_isb09 FROM isb_file
                   WHERE isb01=g_isa.isa01 AND isb02=g_isa.isa04 AND isb03<>g_isb[l_ac].isb03
                   IF cl_null(l_isb09) THEN
                      LET l_isb09=0
                   END IF

                   IF g_isb[l_ac].isb09+l_isb09 > g_isa.isa08  THEN
                      CALL cl_err(g_isb[l_ac].isb09+l_isb09,'gis-003',1)
                      NEXT FIELD isb09
                   END IF
               END IF
               #FUN-C60033---ADD---END
           END IF

        #No.TQC-980274  --Begin
        AFTER FIELD isb09x

           IF NOT cl_null(g_isb[l_ac].isb09x) THEN
         ##FUN-C60033--MARK--str--07/13
         #    IF g_isb[l_ac].isb09x < 0 THEN
         #       CALL cl_err(g_isb[l_ac].isb09x,'axm-179',0)
         #       NEXT FIELD isb09x
         #    END IF
         ##FUN-C60033--MARK--end--07/13
              #FUN-C60033---ADD--STR
               SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file WHERE oaz00='0'
               IF g_oaz.oaz92='Y' THEN
                  SELECT SUM(isb09x) INTO l_isb09 FROM isb_file
                   WHERE isb01=g_isa.isa01 AND isb02=g_isa.isa04 AND isb03<>g_isb[l_ac].isb03
                   IF cl_null(l_isb09) THEN
                      LET l_isb09=0
                   END IF
                   IF g_isb[l_ac].isb09x + l_isb09 > g_isa.isa08x  THEN
                      CALL cl_err(g_isb[l_ac].isb09x+l_isb09,'gis-004',1)
                      NEXT FIELD isb09x
                   END IF
               END IF
              #FUN-C60033---ADD---END
           END IF

        AFTER FIELD isb09t
           IF NOT cl_null(g_isb[l_ac].isb09t) THEN
          ##FUN-C60033--MARK--STR--07/13
          #   IF g_isb[l_ac].isb09t < 0 THEN
          #      CALL cl_err(g_isb[l_ac].isb09t,'axm-179',0)
          #      NEXT FIELD isb09t
          #   END IF
          ##FUN-C60033--MARK--end--07/13
              #FUN-C60033---ADD--STR
               SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file WHERE oaz00='0'
               IF g_oaz.oaz92='Y' THEN
                  SELECT SUM(isb09t) INTO l_isb09 FROM isb_file
                   WHERE isb01=g_isa.isa01 AND isb02=g_isa.isa04 AND isb03<>g_isb[l_ac].isb03
                   IF cl_null(l_isb09) THEN
                      LET l_isb09=0
                   END IF
                   IF g_isb[l_ac].isb09t + l_isb09 > g_isa.isa08t  THEN
                      CALL cl_err(g_isb[l_ac].isb09t +l_isb09,'gis-005',1)
                      NEXT FIELD isb09t
                   END IF
                END IF
               #FUN-C60033---ADD---END
           END IF
        #No.TQC-980274  --End

        #No.MOD-590044  --begin
        #AFTER FIELD isb10
        #   IF NOT cl_null(g_isb[l_ac].isb10) THEN
        #       IF p_cmd = 'a' OR
        #         (p_cmd = 'u' AND g_isb[l_ac].isb10 != g_isb_t.isb10) THEN
        #          SELECT oba01 FROM oba_file WHERE oba01 = g_isb[l_ac].isb10
        #          IF STATUS THEN
        #             CALL cl_err(g_isb[l_ac].isb10,STATUS,0) NEXT FIELD isb10
        #          END IF
        #       END IF
        #   END IF
        #No.MOD-590044  --end


        #No.FUN-840202 --start--
        AFTER FIELD isbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD isbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---

        BEFORE DELETE                            #是否取消單身
            IF g_isb_t.isb03 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
{ckp#1}         DELETE FROM isb_file WHERE isb01 = g_isa.isa01
                                       AND isb02 = g_isa.isa04
                                       AND isb03 = g_isb_t.isb03
                                       AND isb11 = g_isa.isa02    #FUN-C60033--07/03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_isb_t.isb03,SQLCA.sqlcode,0)  #No.FUN-660146
                    CALL cl_err3("del","isb_file",g_isa.isa01,g_isb_t.isb03,SQLCA.sqlcode,"","",1)  #NO.FUN-660146
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_isb[l_ac].* = g_isb_t.*
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_isb[l_ac].isb03,-263,1)
                LET g_isb[l_ac].* = g_isb_t.*
            ELSE
                UPDATE isb_file SET
                         isb03 = g_isb[l_ac].isb03,
                         isb04 = g_isb[l_ac].isb04,
                         isb05 = g_isb[l_ac].isb05,
                         isb06 = g_isb[l_ac].isb06,
                         isb07 = g_isb[l_ac].isb07,
                         isb08 = g_isb[l_ac].isb08,
                         isb09 = g_isb[l_ac].isb09,
                         isb09x= g_isb[l_ac].isb09x,
                         isb09t= g_isb[l_ac].isb09t,
                         isb10 = g_isb[l_ac].isb10
                         #FUN-840202 --start--
                        ,isbud01 = g_isb[l_ac].isbud01,
                         isbud02 = g_isb[l_ac].isbud02,
                         isbud03 = g_isb[l_ac].isbud03,
                         isbud04 = g_isb[l_ac].isbud04,
                         isbud05 = g_isb[l_ac].isbud05,
                         isbud06 = g_isb[l_ac].isbud06,
                         isbud07 = g_isb[l_ac].isbud07,
                         isbud08 = g_isb[l_ac].isbud08,
                         isbud09 = g_isb[l_ac].isbud09,
                         isbud10 = g_isb[l_ac].isbud10,
                         isbud11 = g_isb[l_ac].isbud11,
                         isbud12 = g_isb[l_ac].isbud12,
                         isbud13 = g_isb[l_ac].isbud13,
                         isbud14 = g_isb[l_ac].isbud14,
                         isbud15 = g_isb[l_ac].isbud15
                         #FUN-840202 --end--
                 WHERE isb01 = g_isa.isa01
                   AND isb02 = g_isa.isa04
                   AND isb03 = g_isb_t.isb03
                   AND isb11 = g_isa.isa02   #FUN-C60033--07/03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_isb[l_ac].isb03,SQLCA.sqlcode,0)   #No.FUN-660146
                    CALL cl_err3("upd","isb_file",g_isa.isa01,g_isb_t.isb03,SQLCA.sqlcode,"","",1)  #No.FUN-660146
                    LET g_isb[l_ac].* = g_isb_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D30032 Mark

            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_isb[l_ac].* = g_isb_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_isb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D30032 Add
            CLOSE i100_bcl
            COMMIT WORK
            #CKP2
            CALL g_isb.deleteElement(g_rec_b+1)


        ON ACTION CONTROLR
            CALL cl_show_req_fields()
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLP
            IF INFIELD(isb04) THEN    #料號
#              CALL q_ima(0,0,g_isb[l_ac].isb04) RETURNING g_isb[l_ac].isb04
#              CALL FGL_DIALOG_SETBUFFER( g_isb[l_ac].isb04 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.default1 = g_isb[l_ac].isb04
               CALL cl_create_qry() RETURNING g_isb[l_ac].isb04
#               CALL FGL_DIALOG_SETBUFFER( g_isb[l_ac].isb04 )
               DISPLAY g_isb[l_ac].isb04 TO isb04
               NEXT FIELD isb04
            END IF
            IF INFIELD(isb07) THEN    #單位
#              CALL q_gfe(0,0,g_isb[l_ac].isb07) RETURNING g_isb[l_ac].isb07
#              CALL FGL_DIALOG_SETBUFFER( g_isb[l_ac].isb07 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.default1 = g_isb[l_ac].isb07
               CALL cl_create_qry() RETURNING g_isb[l_ac].isb07
#               CALL FGL_DIALOG_SETBUFFER( g_isb[l_ac].isb07 )
               DISPLAY g_isb[l_ac].isb07 TO isb07
               NEXT FIELD isb07
            END IF
            IF INFIELD(isb10) THEN    #產品類別
#              CALL q_oba(0,0,g_isb[l_ac].isb10) RETURNING g_isb[l_ac].isb10
#              CALL FGL_DIALOG_SETBUFFER( g_isb[l_ac].isb10 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oba"
               LET g_qryparam.default1 = g_isb[l_ac].isb10
               CALL cl_create_qry() RETURNING g_isb[l_ac].isb10
#               CALL FGL_DIALOG_SETBUFFER( g_isb[l_ac].isb10 )
               DISPLAY g_isb[l_ac].isb10 TO isb10
               NEXT FIELD isb10
            END IF

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
       #FUN-C60033--07/06--STR
        IF g_isa.isa00='2' THEN
           SELECT SUM(isb09) INTO l_isb09_1 FROM isb_file
            WHERE isb01=g_isa.isa01
              AND isb02=g_isa.isa04
              AND isb11=g_isa.isa02
           IF cl_null(l_isb09_1) THEN
              LET l_isb09_1=0
           END IF
           IF l_isb09_1<>g_isa.isa08 THEN
              CALL cl_err(l_isb09_1,'gis-007',1)
              CALL i100_b()
            END IF
         END IF
       #FUN-C60033--07/06--END

        SELECT COUNT(*),SUM(isb09),SUM(isb09x),SUM(isb09t)
          INTO g_isa.isa09,g_isa.isa08,g_isa.isa08x,g_isa.isa08t
          FROM isb_file
         WHERE isb01 = g_isa.isa01 AND isb02 = g_isa.isa04 AND isb11 = g_isa.isa02  #FUN-C60033--add--isa02
        IF cl_null(g_isa.isa08) THEN LET g_isa.isa08 = 0 END IF
        IF cl_null(g_isa.isa08x) THEN LET g_isa.isa08x = 0 END IF
        IF cl_null(g_isa.isa08t) THEN LET g_isa.isa08t = 0 END IF
        IF cl_null(g_isa.isa09) THEN LET g_isa.isa09 = 0 END IF
        DISPLAY BY NAME g_isa.isa08,g_isa.isa08x,g_isa.isa08t
        UPDATE isa_file SET isa08 = g_isa.isa08, isa08x = g_isa.isa08x,
                            isa08t= g_isa.isa08t,isa09  = g_isa.isa09
         WHERE isa01 = g_isa.isa01  AND isa04 = g_isa.isa04 AND isa02 = g_isa.isa02 #FUN-C60033--add--isa02
        IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#          CALL cl_err('upd isa',STATUS,1)   #No.FUN-660146
           CALL cl_err3("upd","isa_file",g_isa.isa01,g_isa.isa04,STATUS,"","upd isa",1)  #No.FUN-660146
        END IF

       #FUN-5B0116-begin
        LET g_isa.isamodu = g_user
        LET g_isa.isamodd = g_today
        UPDATE isa_file SET isamodu = g_isa.isamodu,isamodd = g_isa.isadate
         WHERE isa01 = g_isa.isa01
           AND isa02 = g_isa.isa02                #FUN-C60033--add--isa02
           AND isa04 = g_isa.isa04
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#          CALL cl_err('upd isa',SQLCA.SQLCODE,1)   #No.FUN-660146
           CALL cl_err3("upd","isa_file",g_isa.isa01,g_isa.isa04,SQLCA.sqlcode,"","upd isa",1)  #No.FUN-660146
        END IF
        DISPLAY BY NAME g_isa.isamodu,g_isa.isamodd
       #FUN-5B0116-end

    CLOSE i100_bcl
    COMMIT WORK
    CALL i100_delHeader()     #CHI-C30002 add
  #No.FUN-D50034 ---Add--- Start
   IF g_rec_b > 0 AND l_flag = 'Y' THEN
      BEGIN WORK
      LET g_success = 'Y'
      SELECT gec07 INTO l_gec07 FROM gec_file WHERE gec01 = g_isa.isa06
      FOR l_cnt = 1 TO g_rec_b
         INITIALIZE l_ish.* TO NULL
         LET l_ish.ish01 = g_isa.isa04
         LET l_ish.ish02 = g_isb[l_cnt].isb03
         LET l_ish.ish03 = g_isb[l_cnt].isb04
         LET l_ish.ish04 = g_isb[l_cnt].isb05
         LET l_ish.ish05 = g_isb[l_cnt].isb07
         LET l_ish.ish06 = g_isb[l_cnt].isb06
         LET l_ish.ish07 = g_isb[l_cnt].isb08
         LET l_ish.ish08 = g_isb[l_cnt].isb09
         LET l_ish.ish09 = g_isa.isa061
         LET l_ish.ish10 = g_isb[l_cnt].isb10
         LET l_ish.ish11 = 0
         LET l_ish.ish12 = g_isb[l_cnt].isb09x
         LET l_ish.ish13 = 0
         LET l_ish.ish14 = 0
         IF l_gec07 = 'Y' THEN
            LET l_ish.ish15 = (l_ish.ish08 + l_ish.ish12) / l_ish.ish07
            LET l_ish.ish16 = '1'
         ELSE
            LET l_ish.ish15 = l_ish.ish08 / l_ish.ish07
            LET l_ish.ish16 = '0'
         END IF
         INSERT INTO i100_tmpb VALUES(l_ish.*)
         IF STATUS != 0 OR SQLCA.sqlerrd[3] < 1 THEN
            CALL cl_err3("ins","ish_file",l_ish.ish01,l_ish.ish02,SQLCA.SQLCODE,"","ins ish",1)
            LET g_success='N'
         END IF
      END FOR
      IF g_success = 'Y' THEN
         DELETE FROM ish_file WHERE ish01 = g_isa.isa06
     #是否有負數金額
      FOREACH i100_tmpb_dec INTO l_ish.*
         IF l_ish.ish03 = 'MISC' THEN
            SELECT MAX(ish08) INTO l_ish08 FROM i100_tmpb
             WHERE ish01 = l_ish.ish01
            IF cl_null(l_ish08) THEN LET l_ish08 = 0 END IF
            IF (l_ish08 + l_ish.ish08) > 0 THEN
               UPDATE i100_tmpb SET ish11 = (l_ish.ish08 + l_ish.ish12) * -1
                WHERE ish01 = l_ish.ish01
                  AND ish08 IN (SELECT MAX(ish08) FROM i100_tmpb WHERE ish01 = l_ish.ish01)
               DELETE FROM i100_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
            ELSE
               SELECT COUNT(*) INTO l_cnt FROM i100_tmpb WHERE ish01 = l_ish.ish01 AND ish08 > 0
               IF l_cnt > 0 THEN
                  LET t_ish08 = (l_ish.ish08 + l_ish.ish12) / l_cnt
                  LET t_ish08 =  cl_digcut(t_ish08,g_azi04)
                  LET t_ish08_1 = t_ish08 * l_cnt - (l_ish.ish08 + l_ish.ish12)
                  IF t_ish08_1 = 0 THEN LET t_ish08_1 = t_ish08 END IF
                  LET t_ish08 = t_ish08 * -1
                  LET t_ish08_1 = t_ish08_1 * -1
                  UPDATE i100_tmpb SET ish11 = t_ish08
                   WHERE ish01 = l_ish.ish01
                  UPDATE i100_tmpb SET ish11 = t_ish08_1
                   WHERE ish01 = l_ish.ish01
                     AND ish08 IN (SELECT MAX(ish08) FROM i100_tmpb WHERE ish01 = l_ish.ish01)
                  DELETE FROM i100_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
               END IF
            END IF
         ELSE
            SELECT MAX(ish08) INTO l_ish08 FROM i100_tmpb
             WHERE ish01 = l_ish.ish01
               AND ish03 = l_ish.ish03
            IF cl_null(l_ish08) THEN LET l_ish08 = 0 END IF
            IF (l_ish08 + l_ish.ish08) > 0 THEN
               UPDATE i100_tmpb SET ish11 = (l_ish.ish08 + l_ish.ish12) * -1
                WHERE ish01 = l_ish.ish01
                  AND ish08 IN (SELECT MAX(ish08) FROM i100_tmpb WHERE ish01 = l_ish.ish01)
               DELETE FROM i100_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
            ELSE
               SELECT COUNT(*) INTO l_cnt FROM i100_tmpb WHERE ish01 = l_ish.ish01 AND ish03 = l_ish.ish03 AND ish08 > 0
               IF l_cnt > 0 THEN
                  LET t_ish08 = (l_ish.ish08 + l_ish.ish12) / l_cnt
                  LET t_ish08 =  cl_digcut(t_ish08,g_azi04)
                  LET t_ish08_1 = t_ish08 * l_cnt - (l_ish.ish08 + l_ish.ish12)
                  IF t_ish08_1 = 0 THEN LET t_ish08_1 = t_ish08 END IF
                  LET t_ish08 = t_ish08 * -1
                  LET t_ish08_1 = t_ish08_1 * -1
                  UPDATE i100_tmpb SET ish11 = t_ish08
                   WHERE ish01 = l_ish.ish01
                  UPDATE i100_tmpb SET ish11 = t_ish08_1
                   WHERE ish01 = l_ish.ish01
                     AND ish08 IN (SELECT MAX(ish08) FROM i100_tmpb WHERE ish01 = l_ish.ish01)
                  DELETE FROM i100_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
               END IF
            END IF
         END IF
      END FOREACH
      LET l_ish01 = ' '
      FOREACH i100_tmpb_dec1 INTO l_ish.*
         IF l_ish01 != l_ish.ish01 THEN
            LET l_i = 1
         END IF
         LET l_ish.ish02 = l_i
         INSERT INTO ish_file VALUES(l_ish.*)
         IF STATUS != 0 OR SQLCA.sqlerrd[3] < 1 THEN
            CALL cl_err3("ins","ish_file",l_ish.ish01,l_ish.ish02,SQLCA.SQLCODE,"","ins ish",1)
            LET g_success='N'
         END IF
         UPDATE isg_file SET isg02 = l_ish.ish02
          WHERE isg01 = l_ish.ish01
         LET l_i = l_i + 1
         LET l_ish01 = l_ish.ish01
      END FOREACH
      END IF
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END IF
  #No.FUN-D50034 ---Add--- End
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i100_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM isa_file  WHERE isa01 = g_isa.isa01
                                 AND isa02 = g_isa.isa02    #FUN-C60033--add--isa02
                                 AND isa04 = g_isa.isa04
         INITIALIZE g_isa.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i100_isb04(p_cmd)
    DEFINE p_cmd     LIKE type_file.num5     #NO.FUN-690009 VARCHAR(1)
    DEFINE l_ima02   LIKE ima_file.ima02
    DEFINE l_ima021  LIKE ima_file.ima021
    DEFINE l_ima131  LIKE ima_file.ima131
    DEFINE l_imaacti LIKE ima_file.imaacti

    LET g_errno = ' '
    IF g_isb[l_ac].isb04 = 'MISC' THEN RETURN END IF
    SELECT ima02,ima021,ima131,imaacti
      INTO l_ima02,l_ima021,l_ima131,l_imaacti
      FROM ima_file
     WHERE ima01 = g_isb[l_ac].isb04
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1201'
         WHEN l_imaacti = 'N'     LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    LET g_isb[l_ac].isb05 = l_ima02
    LET g_isb[l_ac].isb06 = l_ima021
    #LET g_isb[l_ac].isb10 = l_ima131  #No.MOD-590044
END FUNCTION

FUNCTION i100_b_askkey()
    CLEAR FORM
    CALL g_isb.clear()
    CONSTRUCT g_wc2 ON isb03,isb04,isb05,isb06,isb07,isb08,isb09,
                       isb09x,isb09t,isb10
            FROM s_isb[1].isb03,s_isb[1].isb04,s_isb[1].isb05,
                 s_isb[1].isb06,s_isb[1].isb07,s_isb[1].isb08,
                 s_isb[1].isb09,s_isb[1].isb09x,s_isb[1].isb09t,
                 s_isb[1].isb10
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
    CALL i100_b_fill(g_wc2)
END FUNCTION

FUNCTION i100_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(200)

    LET g_sql =
        "SELECT isb03,isb04,isb05,isb06,isb07,isb08,isb09,",
        "       isb09x,isb09t,isb10 ",
        #No.FUN-840202 --start--
        ",isbud01,isbud02,isbud03,isbud04,isbud05,",
        "isbud06,isbud07,isbud08,isbud09,isbud10,",
        "isbud11,isbud12,isbud13,isbud14,isbud15",
        #No.FUN-840202 ---end---
        "  FROM isb_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        "   AND isb01 = '",g_isa.isa01,"'",
        "   AND isb02 = '",g_isa.isa04,"'",
        "   AND isb11 = '",g_isa.isa02,"'",        #FUN-C60033-07/03
        " ORDER BY isb03 "
    PREPARE i100_pb FROM g_sql
    DECLARE isb_curs CURSOR FOR i100_pb
    CALL g_isb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH isb_curs INTO g_isb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_isb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_isb TO s_isb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
#No.FUN-580006 --start--
      ON ACTION other_file
         LET g_action_choice="other_file"
         EXIT DISPLAY
#No.FUN-580006 --end--
      ON ACTION first
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION jump
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION last
         CALL i100_fetch('L')
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

     #No.FUN-D50034 ---Add--- Start
      ON ACTION adjustment
         LET g_action_choice="adjustment"
         EXIT DISPLAY
     #No.FUN-D50034 ---Add--- End

#No.FUN-540006--begin
      ON ACTION invoiceexport
         LET g_action_choice="invoiceexport"
         EXIT DISPLAY
#No.FUN-540006--end

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
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


      ON ACTION exporttoexcel       #FUN-4B0046
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY         #TQC-5B0049

      ON ACTION related_document                #No.FUN-6A0009  相關文件
         LET g_action_choice="related_document"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---

      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#No.FUN-580006 --start--
FUNCTION i100_1()
   DEFINE l_nma02   LIKE nma_file.nma02
   DEFINE l_nma04   LIKE nma_file.nma04
   DEFINE p_row     LIKE type_file.num5     #NO.FUN-690009 SMALLINT
   DEFINE p_col     LIKE type_file.num5     #NO.FUN-690009 SMALLINT
   DEFINE l_count   LIKE type_file.num5     #NO.FUN-690009 SMALLINT
  #No.FUN-D50034 ---Add--- Start
   DEFINE l_gen02   LIKE gen_file.gen02
   DEFINE m_gen02   LIKE gen_file.gen02
   DEFINE l_isa13   LIKE isa_file.isa13
  #No.FUN-D50034 ---Add--- End

   BEGIN WORK
   OPEN i100_cl USING g_isa.isa01,g_isa.isa02,g_isa.isa04    #FUN-C60033--add--isa02
   IF STATUS THEN
      CALL cl_err("OPEN i100_cl:", STATUS, 1)
      CLOSE i100_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i100_cl INTO g_isa.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_isa.isa04,SQLCA.sqlcode,0)
      ROLLBACK WORK RETURN
   END IF
   IF g_isa.isa04 IS NULL THEN RETURN END IF
   #No.MOD-590044  --begin
   IF g_isa.isa07 <> '0' THEN RETURN END IF
   #No.MOD-590044  --end
   LET p_row = 3 LET p_col = 11

   OPEN WINDOW i1001_w AT p_row,p_col WITH FORM "gis/42f/gisi1001"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_init()
   LET g_action_choice = "modify"
   DISPLAY BY NAME g_isa.isa11, g_isa.isa12, g_isa.isa14,
                   g_isa.isa15, g_isa.isa13, g_isa.isa10
   CALL i100_gen02(g_isa.isa11,'1')
   CALL i100_gen02(g_isa.isa12,'2')

   INPUT BY NAME g_isa.isa11,g_isa.isa12,g_isa.isa14,g_isa.isa15,
                 g_isa.isa13,g_isa.isa10 WITHOUT DEFAULTS HELP 1

      AFTER FIELD isa11
#        IF cl_null(g_isa.isa11) THEN NEXT FIELD isa11 END IF  #No.MOD-5A0183
         LET l_count = 0
         SELECT COUNT(*) INTO l_count FROM gen_file
          WHERE gen01 = g_isa.isa11
         IF l_count = 0 THEN NEXT FIELD isa11 END IF
         CALL i100_gen02(g_isa.isa11,'1')

      AFTER FIELD isa12
#        IF cl_null(g_isa.isa12) THEN NEXT FIELd isa12 END IF  #No.MOD-5A0183
         LET l_count = 0
         SELECT COUNT(*) INTO l_count FROM gen_file
          WHERE gen01 = g_isa.isa12
         IF l_count = 0 THEN NEXT FIELD isa12 END IF
         CALL i100_gen02(g_isa.isa12,'2')

      AFTER FIELD isa14
#        IF cl_null(g_isa.isa14) THEN NEXT FIELD isa14 END IF #No.MOD-5A0183
         IF NOT cl_null(g_isa.isa14) THEN
            SELECT nma02,nma04 INTO l_nma02,l_nma04 FROM nma_file
             WHERE nma01=g_isa.isa14
            IF STATUS THEN
               LET l_nma02 =''
               LET l_nma04 =''
            END IF
            LET g_isa.isa15 =l_nma02 ,l_nma04
            DISPLAY g_isa.isa15 TO isa15
         END IF

      AFTER FIELD isa15
#        IF cl_null(g_isa.isa15) THEN NEXT FIELD isa15 END IF  #No.MOD-5A0183

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(isa11)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_isa.isa11
               CALL cl_create_qry() RETURNING g_isa.isa11
               DISPLAY BY NAME g_isa.isa11
               CALL i100_gen02(g_isa.isa11,'1')
               NEXT FIELD isa11
            WHEN INFIELD(isa12)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_isa.isa12
               CALL cl_create_qry() RETURNING g_isa.isa12
               DISPLAY BY NAME g_isa.isa12
               CALL i100_gen02(g_isa.isa12,'2')
               NEXT FIELD isa12
            WHEN INFIELD(isa14)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nma"
               LET g_qryparam.default1 = g_isa.isa14
               CALL cl_create_qry() RETURNING g_isa.isa14
               DISPLAY BY NAME g_isa.isa14
               NEXT FIELD isa14
         END CASE

#--NO.MOD-860078 start---

        ON ACTION controlg
           CALL cl_cmdask()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about
           CALL cl_about()

        ON ACTION help
           CALL cl_show_help()

#--NO.MOD-860078 end-------
   END INPUT
   CLOSE WINDOW i1001_w
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   UPDATE isa_file SET * = g_isa.*
    WHERE isa01 = g_isa.isa01 AND isa04 = g_isa.isa04 AND isa02=g_isa.isa02  #FUN-C60033--add--isa02
   IF SQLCA.SQLCODE THEN
#     CALL cl_err('update isa',SQLCA.SQLCODE,0)   #No.FUN-660146
      CALL cl_err3("upd","isa_file",g_isa.isa01,g_isa.isa04,SQLCA.sqlcode,"","update isa",1)  #No.FUN-660146
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
  #No.FUN-D50034 ---Add--- Start
   SELECT * INTO g_isa.* FROM isa_file
    WHERE isa01 = g_isa.isa01
      AND isa04 = g_isa.isa04
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_isa.isa11
   SELECT gen02 INTO m_gen02 FROM gen_file WHERE gen01 = g_isa.isa12
   LET l_isa13 = g_isa.isa13 USING 'YYYYMMDD'
   UPDATE isg_file SET isg07 = g_isa.isa10,
                       isg08 = l_gen02,
                       isg09 = m_gen02,
                       isg11 = l_isa13,
                       isg12 = g_isa.isa15
  #No.FUN-D50034 ---Add--- End
END FUNCTION

FUNCTION i100_gen02(p_gen01,p_stat)
   DEFINE  p_gen01   LIKE gen_file.gen01
   DEFINE  p_stat    LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(01)
   DEFINE  l_gen02_1 LIKE gen_file.gen02
   DEFINE  l_gen02_2 LIKE gen_file.gen02

   LET p_gen01 = p_gen01 CLIPPED
   LET p_stat  = p_stat  CLIPPED
   IF cl_null(p_gen01) OR cl_null(p_stat) THEN RETURN END IF
   IF p_stat NOT MATCHES '[12]' THEN RETURN END IF

   CASE p_stat
      WHEN "1"
         SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = p_gen01
      WHEN "2"
         SELECT gen02 INTO l_gen02_2 FROM gen_file WHERE gen01 = p_gen01
   END CASE
   IF SQLCA.sqlcode THEN
#     CALL cl_err("select gen02 error:" ,SQLCA.sqlcode,0)   #No.FUN-660146
      CALL cl_err3("sel","gen_file",p_gen01,"",SQLCA.sqlcode,"","select gen02 error",1)  #No.FUN-660146
   END IF

   IF p_stat = "1" THEN
      DISPLAY l_gen02_1 TO FORMONLY.gen02_1
   ELSE
      DISPLAY l_gen02_2 TO FORMONLY.gen02_2
   END IF
END FUNCTION
#No.FUN-580006 --end--

#No.FUN-570108 --start--
FUNCTION i100_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(01)

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("isa01,isa02,isa04",TRUE)      #FUN-C60033--07/06--add--isa02
#    CALL cl_set_comp_entry("isa00,isa03,isa05,isa06,isa062,isa07,isa08,isa08x,isa08t",TRUE) #FUN-C60033--07/06--add  #TQC-CB0046 mark
     CALL cl_set_comp_entry("isa03,isa05,isa06,isa062,isa07,isa08,isa08x,isa08t",TRUE) #TQC-CB0046 add
   END IF
END FUNCTION

FUNCTION i100_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(01)

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      IF g_isa.isa00='2' THEN                                                                          #FUN-C60033--07/06
         CALL cl_set_comp_entry("isa01,isa02,isa03,isa04,isa05,isa06,isa062,isa07,isa08,isa08x,isa08t",FALSE) #FUN-C60033--07/06 #TQC-CB0046 del isa00
      ELSE                                                                                             #FUN-C60033--07/06
         CALL cl_set_comp_entry("isa01,isa02,isa04",FALSE)                                             #FUN-C60033--07/06--add--isa02
         CALL cl_set_comp_entry("isa03,isa05,isa06,isa062,isa07,isa08,isa08x,isa08t",TRUE)             #TQC-CB0046 del isa00
      END IF
    END IF
END FUNCTION
#No.FUN-570108 --end--
#Patch....NO.MOD-5A0095 <001,002> #
#Patch....NO.TQC-610037 <001> #

#FUN-910088--add--start--
FUNCTION i100_isb08_check()
   IF NOT cl_null(g_isb[l_ac].isb08) AND NOT cl_null(g_isb[l_ac].isb07) THEN
      IF cl_null(g_isb07_t) OR cl_null(g_isb_t.isb08) OR g_isb07_t != g_isb[l_ac].isb07 OR g_isb_t.isb08 != g_isb[l_ac].isb08 THEN
         LET g_isb[l_ac].isb08 = s_digqty(g_isb[l_ac].isb08,g_isb[l_ac].isb07)
         DISPLAY BY NAME g_isb[l_ac].isb08
      END IF
   END IF
  ##FUN-C60033---MARK--STR--07/13
  #IF NOT cl_null(g_isb[l_ac].isb08) THEN
  #   IF g_isb[l_ac].isb08 < 0 THEN
  #      CALL cl_err(g_isb[l_ac].isb08,'axm-179',0)
  #      RETURN FALSE
  #   END IF
  #END IF
  ##FUN-C60033--MARK--END--07/13
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--

#No.FUN-D50034 ---Add--- Start
FUNCTION i100_adj()
   DEFINE l_isg02         LIKE isg_file.isg02

   OPEN WINDOW i100_d WITH FORM "gis/42f/gisi100_d"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

      CALL cl_ui_locale("gisi100_d")

      LET g_sql = "SELECT ish02,ish03,ish04,ish06,ish05,ish07,ish08,",
                  "       ish09,ish10,ish11,ish12,ish13,ish14,ish15,ish16 ",
                  "  FROM ish_file",
                  " WHERE ish01 = '",g_isa.isa04,"'"
      PREPARE i100_ish_pre FROM g_sql
      DECLARE i100_ish_dec CURSOR FOR i100_ish_pre
      
      LET g_rec_b1 = 0
      LET l_ac = 1
      FOREACH i100_ish_dec INTO g_ish[l_ac].*
         LET l_ac = l_ac + 1
         LET g_rec_b1 = g_rec_b1 + 1
      END FOREACH
      CALL g_ish.deleteElement(l_ac)
      LET l_ac = 0
      SELECT isg02 INTO l_isg02 FROM isg_file WHERE isg01 = g_isa.isa04
      DISPLAY l_isg02 TO isg02
      WHILE TRUE
         CALL i100_bp1("G")
         CASE g_action_choice
            WHEN "detail"
               IF cl_chk_act_auth() THEN
                  CALL i100_adjustment()
               ELSE
                  LET g_action_choice = NULL
               END IF
            WHEN "help"
               CALL cl_show_help()
            WHEN "exit"
               EXIT WHILE
            WHEN "controlg"
               CALL cl_cmdask()
         END CASE
      END WHILE
   CLOSE WINDOW i100_d
END FUNCTION

FUNCTION i100_adjustment()
   DEFINE l_ac_t          LIKE type_file.num5        #未取消的ARRAY CNT
   DEFINE l_n             LIKE type_file.num5        #檢查重複用
   DEFINE l_lock_sw       LIKE type_file.chr1        #單身鎖住否
   DEFINE p_cmd           LIKE type_file.chr1        #處理狀態
   DEFINE l_allow_insert  LIKE type_file.num5        #可新增否
   DEFINE l_allow_delete  LIKE type_file.num5        #可刪除否
   DEFINE l_ish08         LIKE ish_file.ish08
   DEFINE l_ish11         LIKE ish_file.ish11
   DEFINE t_ish11         LIKE ish_file.ish11
   DEFINE l_ish12         LIKE ish_file.ish12
   DEFINE t_ish13         LIKE ish_file.ish11
   DEFINE l_ish13         LIKE ish_file.ish13
   DEFINE l_isg02         LIKE isg_file.isg02

   IF cl_null(g_isa.isa04) THEN RETURN END IF

   LET g_action_choice = " "

   SELECT isg02 INTO l_isg02 FROM isg_file WHERE isg01 = g_isa.isa04
   DISPLAY l_isg02 TO isg02
   
  #重新計算折扣未稅金額
   SELECT SUM(ish11 / (1 +ish09 / 100)) INTO t_ish11 FROM ish_file WHERE ish01=g_isa.isa04
   LET t_ish11 = cl_digcut(t_ish11,g_azi04)
  #重新計算折扣含稅金額
   SELECT SUM(ish11) INTO t_ish13 FROM ish_file WHERE ish01=g_isa.isa04
   LET t_ish13 = t_ish13 - t_ish11
   
   LET g_forupd_sql = "SELECT * FROM isg_file WHERE isg01 = '",g_isa.isa04,"' FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i100_cl_isg CURSOR FROM g_forupd_sql
   
   LET g_forupd_sql = "SELECT ish02,ish03,ish04,ish06,ish05,ish07,ish08,",
                      "       ish09,ish10,ish11,ish12,ish13,ish14,ish15,ish16 FROM ish_file",
                      " WHERE ish01 = '",g_isa.isa04,"'",
                      "   AND ish02 = ?",
                      "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i100_cl_ish CURSOR FROM g_forupd_sql

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   
   INPUT ARRAY g_ish WITHOUT DEFAULTS FROM s_ish.*
      ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()

         BEGIN WORK
         OPEN i100_cl_isg
         IF STATUS THEN
            CALL cl_err("OPEN i100_cl_isg:", STATUS, 1)
            CLOSE i100_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH i100_cl_isg INTO g_isg.*               # 對DB鎖定
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_isa.isa04,SQLCA.sqlcode,0)
            ROLLBACK WORK RETURN
         END IF

         IF g_rec_b1 >= l_ac THEN
            LET g_ish_t.* = g_ish[l_ac].*  #BACKUP
            LET p_cmd='u'

            OPEN i100_cl_ish USING g_ish_t.ish02
            IF STATUS THEN
               CALL cl_err("OPEN i100_cl_ish:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i100_cl_ish INTO g_ish[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ish_t.ish02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_ish[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_ish[l_ac].* TO s_isb.*
            CALL g_ish.deleteElement(g_rec_b1+1)
            ROLLBACK WORK
            EXIT INPUT
         END IF
         INSERT INTO ish_file VALUES(g_isg.isg01,      g_ish[l_ac].ish02,
                                     g_ish[l_ac].ish03,g_ish[l_ac].ish04,
                                     g_ish[l_ac].ish05,g_ish[l_ac].ish06,
                                     g_ish[l_ac].ish07,g_ish[l_ac].ish08,
                                     g_ish[l_ac].ish09,g_ish[l_ac].ish10,
                                     g_ish[l_ac].ish11,g_ish[l_ac].ish12,
                                     g_ish[l_ac].ish13,g_ish[l_ac].ish14,
                                     g_ish[l_ac].ish15,g_ish[l_ac].ish16)
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ish_file",g_isg.isg01,g_ish[l_ac].ish02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            UPDATE isg_file SET isg02 = isg02 + 1
             WHERE isg01 = g_isg.isg01
            LET l_isg02 = l_isg02 + 1
            LET g_rec_b1=g_rec_b1 + 1
            DISPLAY l_isg02 TO isg02
            COMMIT WORK
         END IF
        #重新計算折扣未稅金額
         SELECT SUM(ish11) INTO t_ish11 FROM ish_file WHERE ish01=g_isg.isg01
        #重新計算折扣稅額
         SELECT SUM(ish11 * ish09 / 100) INTO t_ish13 FROM ish_file WHERE ish01=g_isg.isg01

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ish[l_ac].* TO NULL
         LET g_ish_t.* = g_ish[l_ac].*         #新輸入資料
         LET g_ish[l_ac].ish07 = 0
         LET g_ish[l_ac].ish08 = 0
         LET g_ish[l_ac].ish11 = 0
         LET g_ish[l_ac].ish12 = 0
         LET g_ish[l_ac].ish13 = 0
         LET g_ish[l_ac].ish15 = 0
         LET g_ish[l_ac].ish16 = '0'
         DISPLAY BY NAME g_ish[l_ac].ish07,g_ish[l_ac].ish08,g_ish[l_ac].ish11,
                         g_ish[l_ac].ish12,g_ish[l_ac].ish13,g_ish[l_ac].ish15,
                         g_ish[l_ac].ish16
         CALL cl_show_fld_cont()
         NEXT FIELD ish02

      BEFORE FIELD ish02
         IF cl_null(g_ish[l_ac].ish02) THEN
            SELECT MAX(ish02) INTO g_ish[l_ac].ish02 FROM ish_file
             WHERE ish01 = g_isg.isg01
            IF cl_null(g_ish[l_ac].ish02) THEN LET g_ish[l_ac].ish02=0 END IF
            LET g_ish[l_ac].ish02 = g_ish[l_ac].ish02 + 1
         END IF

      AFTER FIELD ish02
         IF NOT cl_null(g_ish[l_ac].ish02) THEN
             IF p_cmd = 'a' OR
               (p_cmd = 'u' AND g_ish[l_ac].ish02 != g_ish_t.ish02) THEN
                SELECT COUNT(*) INTO l_n FROM ish_file
                 WHERE ish01 = g_isg.isg01 AND ish02 = g_ish[l_ac].ish02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_ish[l_ac].ish02 = g_ish_t.ish02
                   DISPLAY BY NAME g_ish[l_ac].ish02
                   NEXT FIELD ish02
                END IF
             END IF
         END IF

      AFTER FIELD ish03
         IF NOT cl_null(g_ish[l_ac].ish03) THEN
             IF p_cmd = 'a' OR
               (p_cmd = 'u' AND g_ish[l_ac].ish03 != g_ish_t.ish03) THEN
                CALL i100_isb04(p_cmd)##############
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ish[l_ac].ish03,g_errno,0) NEXT FIELD ish03
                END IF
             END IF
         END IF

      AFTER FIELD ish05
         IF NOT cl_null(g_ish[l_ac].ish05) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ish[l_ac].ish05 != g_ish_t.ish05) THEN
               SELECT gfe01 FROM gfe_file
                WHERE gfe01 = g_ish[l_ac].ish05 AND gfeacti = 'Y'
               IF STATUS THEN
                  CALL cl_err3("sel","gfe_file",g_ish[l_ac].ish05,"","aoo-012","","",1)  
                  NEXT FIELD ish05
               END IF
            END IF
            IF NOT cl_null(g_ish[l_ac].ish07) THEN
               LET g_ish[l_ac].ish07 = s_digqty(g_ish[l_ac].ish07,g_ish[l_ac].ish05)
               DISPLAY BY NAME g_ish[l_ac].ish07
            END IF
         END IF

      AFTER FIELD ish07
         IF NOT cl_null(g_ish[l_ac].ish07) AND NOT cl_null(g_ish[l_ac].ish05) THEN
            LET g_ish[l_ac].ish07 = s_digqty(g_ish[l_ac].ish07,g_ish[l_ac].ish05)
            DISPLAY BY NAME g_ish[l_ac].ish07
         END IF

      AFTER FIELD ish08
         IF NOT cl_null(g_ish[l_ac].ish08) THEN
           #重新計算稅額
            LET g_ish[l_ac].ish12 = g_ish[l_ac].ish08 * g_ish[l_ac].ish09 /100
            LET g_ish[l_ac].ish12 = cl_digcut(g_ish[l_ac].ish12,g_azi04)
            DISPLAY BY NAME g_ish[l_ac].ish12
            IF cl_null(g_ish[l_ac].ish09) THEN LET g_ish[l_ac].ish09 = 0 END IF
            IF cl_null(g_ish[l_ac].ish11) THEN LET g_ish[l_ac].ish11 = 0 END IF
            LET l_ish11 = t_ish11 + g_ish[l_ac].ish11 * g_ish[l_ac].ish09 / 100
            LET l_ish11 = cl_digcut(l_ish11,g_azi04)
           #判斷單身總金額是否大於單頭未稅金額
            SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file WHERE oaz00='0'
            IF g_oaz.oaz92='Y' THEN
               SELECT SUM(ish08) INTO l_ish08 FROM ish_file
                WHERE ish01=g_isg.isg01 AND ish02<>g_ish[l_ac].ish02
               IF cl_null(l_ish08) THEN LET l_ish08 = 0 END IF
               IF g_ish[l_ac].ish08 + l_ish08 - l_ish11 > g_isa.isa08  THEN
                  CALL cl_err(g_ish[l_ac].ish08+l_ish08-l_ish11,'gis-003',1)
                  NEXT FIELD ish08
               END IF
            END IF
         END IF

      AFTER FIELD ish11
         IF NOT cl_null(g_ish[l_ac].ish11) THEN
            IF NOT cl_null(g_ish[l_ac].ish08) AND NOT cl_null(g_ish[l_ac].ish12) THEN
               IF g_ish[l_ac].ish11 > g_ish[l_ac].ish08 + g_ish[l_ac].ish12 THEN
                  CALL cl_err(g_ish[l_ac].ish11,"gis-008",1)
                  NEXT FIELD ish11
               END IF
            END IF
         END IF
         
      AFTER FIELD ish12
         IF NOT cl_null(g_ish[l_ac].ish12) THEN
            IF cl_null(g_ish[l_ac].ish09) THEN LET g_ish[l_ac].ish09 = 0 END IF
            IF cl_null(g_ish[l_ac].ish11) THEN LET g_ish[l_ac].ish11 = 0 END IF
            LET l_ish13 = t_ish13 + g_ish[l_ac].ish11 * (1 - g_ish[l_ac].ish09) / 100 * g_ish[l_ac].ish09
            LET t_ish13 = cl_digcut(t_ish13,g_azi04)
           #判斷單身總稅額是否大於單頭稅額
            SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file WHERE oaz00='0'
            IF g_oaz.oaz92='Y' THEN
               SELECT SUM(ish12) INTO l_ish12 FROM ish_file
                WHERE ish01=g_isg.isg01 AND ish02<>g_ish[l_ac].ish02
               IF cl_null(l_ish12) THEN LET l_ish12 = 0 END IF
               IF g_ish[l_ac].ish12 + l_ish12 - l_ish13 > g_isa.isa08x  THEN
                  CALL cl_err(g_ish[l_ac].ish12+l_ish12-l_ish13,'gis-004',1)
                  NEXT FIELD ish12
               END IF
            END IF
         END IF
         
      BEFORE DELETE                            #是否取消單身
         IF g_ish_t.ish02 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
            END IF
            DELETE FROM ish_file WHERE ish01 = g_isg.isg01
                                   AND ish02 = g_ish_t.ish02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ish_file",g_isg.isg01,g_ish_t.ish02,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            UPDATE isg_file SET isg02 = isg02 - 1
             WHERE isg01 = g_isg.isg01
            LET l_isg02 = l_isg02 - 1
            LET g_rec_b1=g_rec_b1 - 1
            DISPLAY l_isg02 TO isg02
            COMMIT WORK
           #重新計算折扣未稅金額
            SELECT SUM(ish11) INTO t_ish11 FROM ish_file WHERE ish01=g_isg.isg01
           #重新計算折扣稅額
            SELECT SUM(ish11 * ish09 / 100) INTO t_ish13 FROM ish_file WHERE ish01=g_isg.isg01
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ish[l_ac].* = g_ish_t.*
            CLOSE i100_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ish[l_ac].ish02,-263,1)
            LET g_ish[l_ac].* = g_ish_t.*
         ELSE
            UPDATE ish_file SET
                      ish03 = g_ish[l_ac].ish03,
                      ish04 = g_ish[l_ac].ish04,
                      ish05 = g_ish[l_ac].ish05,
                      ish06 = g_ish[l_ac].ish06,
                      ish07 = g_ish[l_ac].ish07,
                      ish08 = g_ish[l_ac].ish08,
                      ish09 = g_ish[l_ac].ish09,
                      ish10 = g_ish[l_ac].ish10,
                      ish11 = g_ish[l_ac].ish11,
                      ish12 = g_ish[l_ac].ish12,
                      ish13 = g_ish[l_ac].ish13,
                      ish14 = g_ish[l_ac].ish14,
                      ish15 = g_ish[l_ac].ish15,
                      ish16 = g_ish[l_ac].ish16
              WHERE ish01 = g_isg.isg01
                AND ish02 = g_ish_t.ish02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ish_file",g_isg.isg01,g_ish_t.ish02,SQLCA.sqlcode,"","",1)
               LET g_ish[l_ac].* = g_ish_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
           #重新計算折扣未稅金額
            SELECT SUM(ish11) INTO t_ish11 FROM ish_file WHERE ish01=g_isg.isg01
           #重新計算折扣稅額
            SELECT SUM(ish11 * ish09 / 100) INTO t_ish13 FROM ish_file WHERE ish01=g_isg.isg01
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()

         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ish[l_ac].* = g_ish_t.*
            ELSE
               CALL g_ish.deleteElement(l_ac)
            END IF
            CLOSE i100_cl_ish
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac
         CLOSE i100_cl_ish
         COMMIT WORK
         CALL g_ish.deleteElement(g_rec_b1+1)


      ON ACTION CONTROLR
         CALL cl_show_req_fields()
         
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLP
         IF INFIELD(ish03) THEN    #料號
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.default1 = g_ish[l_ac].ish03
            CALL cl_create_qry() RETURNING g_ish[l_ac].ish03
            DISPLAY g_ish[l_ac].ish03 TO ish03
            NEXT FIELD isb04
         END IF
         IF INFIELD(ish05) THEN    #單位
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gfe"
            LET g_qryparam.default1 = g_ish[l_ac].ish05
            CALL cl_create_qry() RETURNING g_ish[l_ac].ish05
            DISPLAY g_ish[l_ac].ish05 TO ish05
            NEXT FIELD isb07
         END IF
         IF INFIELD(ish10) THEN    #產品類別
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_oba"
            LET g_qryparam.default1 = g_ish[l_ac].ish10
            CALL cl_create_qry() RETURNING g_ish[l_ac].ish10
            DISPLAY g_ish[l_ac].ish10 TO ish10
            NEXT FIELD isb10
         END IF

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()
         
   END INPUT
   CLOSE i100_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i100_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ish TO s_ish.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()           

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION CANCEL
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about       
         CALL cl_about()       

      AFTER DISPLAY
         CONTINUE DISPLAY
         
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-D50034 ---Add--- End
