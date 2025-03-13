# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asri120.4gl
# Descriptions...: 生產計劃維護作業
# Date & Author..: 06/01/06 by kim
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-690022 06/09/19 By jamie 判斷imaacti
# Modify.........: No.CHI-6A0049 06/10/31 By kim 加強錯誤訊息的表示
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0166 06/11/09 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6B0031 06/11/14 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-780003 07/08/01 By kim 畫圖的page的Action在_bp()段不應該加 EXIT DISPLAY,否則會照成操作不正常
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.FUN-870041 08/07/08 By Nicola 重覆性生產加入特性代碼
# Modify.........: No.FUN-870097 08/07/24 By sherry 增加可修改 特性代碼(sre051)
# Modify.........: No.TQC-940103 09/05/08 By mike DISPLAY BY NAME g_srd03欄位不在畫面中
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A50010 10/08/27 By lilingyu 程序畫面無法run出來
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.CHI-B40058 11/05/16 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80063 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No:MOD-B90070 11/09/08 By johung 修正CHI-B40058
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_srd01         LIKE srd_file.srd01,  
    g_srd01_t       LIKE srd_file.srd01, 
    g_srd02         LIKE srd_file.srd02,  
    g_srd02_t       LIKE srd_file.srd02, 
    g_srd03         LIKE srd_file.srd03,  
    g_srd03_t       LIKE srd_file.srd03, 
    g_eci06         LIKE eci_file.eci06,
    g_eci03         LIKE eci_file.eci03,
    g_eca02         LIKE eca_file.eca02,
    g_srd           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
            srd04     LIKE srd_file.srd04 ,    
            ima02     LIKE ima_file.ima02 ,
            ima021    LIKE ima_file.ima02 ,
            sra03     LIKE sra_file.sra03 ,
            srd051    LIKE srd_file.srd051,   #No.FUN-870041
            srd05     LIKE srd_file.srd05 ,
            ecg02     LIKE ecg_file.ecg02 ,  
            srd01d    LIKE srd_file.srd01d,
            srd01e    LIKE srd_file.srd01e,
            srd02d    LIKE srd_file.srd02d,
            srd02e    LIKE srd_file.srd02e,
            srd03d    LIKE srd_file.srd03d,
            srd03e    LIKE srd_file.srd03e,
            srd04d    LIKE srd_file.srd04d,
            srd04e    LIKE srd_file.srd04e,
            srd05d    LIKE srd_file.srd05d,
            srd05e    LIKE srd_file.srd05e,
            srd06d    LIKE srd_file.srd06d,
            srd06e    LIKE srd_file.srd06e,
            Edit1     LIKE srd_file.srd07d,  #TQC-A50010  
            Edit2    LIKE srd_file.srd07e,  
            srd08d    LIKE srd_file.srd08d,
            srd08e    LIKE srd_file.srd08e,
            srd09d    LIKE srd_file.srd09d,
            srd09e    LIKE srd_file.srd09e,
            srd10d    LIKE srd_file.srd10d,
            srd10e    LIKE srd_file.srd10e,
            srd11d    LIKE srd_file.srd11d,
            srd11e    LIKE srd_file.srd11e,
            srd12d    LIKE srd_file.srd12d,
            srd12e    LIKE srd_file.srd12e,
            srd13d    LIKE srd_file.srd13d,
            srd13e    LIKE srd_file.srd13e,
            Edit3    LIKE srd_file.srd14d,   
            Edit4    LIKE srd_file.srd14e,   
            srd15d    LIKE srd_file.srd15d,
            srd15e    LIKE srd_file.srd15e,
            srd16d    LIKE srd_file.srd16d,
            srd16e    LIKE srd_file.srd16e,
            srd17d    LIKE srd_file.srd17d,
            srd17e    LIKE srd_file.srd17e,
            srd18d    LIKE srd_file.srd18d,
            srd18e    LIKE srd_file.srd18e,
            srd19d    LIKE srd_file.srd19d,
            srd19e    LIKE srd_file.srd19e,
            srd20d    LIKE srd_file.srd20d,
            srd20e    LIKE srd_file.srd20e,
            Edit5    LIKE srd_file.srd21d,  
            Edit6    LIKE srd_file.srd21e,  
            srd22d    LIKE srd_file.srd22d,
            srd22e    LIKE srd_file.srd22e,
            srd23d    LIKE srd_file.srd23d,
            srd23e    LIKE srd_file.srd23e,
            srd24d    LIKE srd_file.srd24d,
            srd24e    LIKE srd_file.srd24e,
            srd25d    LIKE srd_file.srd25d,
            srd25e    LIKE srd_file.srd25e,
            srd26d    LIKE srd_file.srd26d,
            srd26e    LIKE srd_file.srd26e,
            srd27d    LIKE srd_file.srd27d,
            srd27e    LIKE srd_file.srd27e,
            Edit7    LIKE srd_file.srd28d,  
            Edit8    LIKE srd_file.srd28e,  
            srd29d    LIKE srd_file.srd29d,
            srd29e    LIKE srd_file.srd29e,
            srd30d    LIKE srd_file.srd30d,
            srd30e    LIKE srd_file.srd30e,
            srd31d    LIKE srd_file.srd31d,
            srd31e    LIKE srd_file.srd31e,
            srd32d    LIKE srd_file.srd32d,
            srd32e    LIKE srd_file.srd32e,
            srd33d    LIKE srd_file.srd33d,
            srd33e    LIKE srd_file.srd33e,
            srd34d    LIKE srd_file.srd34d,
            srd34e    LIKE srd_file.srd34e,
            Edit9    LIKE srd_file.srd35d,  
            Edit10    LIKE srd_file.srd35e,  
            srd36d    LIKE srd_file.srd36d,
            srd36e    LIKE srd_file.srd36e,
            srd37d    LIKE srd_file.srd37d,
            srd37e    LIKE srd_file.srd37e,
            srd38d    LIKE srd_file.srd38d,
            srd38e    LIKE srd_file.srd38e,
            srd39d    LIKE srd_file.srd39d,
            srd39e    LIKE srd_file.srd39e,
            srd40d    LIKE srd_file.srd40d,
            srd40e    LIKE srd_file.srd40e,
            srd41d    LIKE srd_file.srd41d,
            srd41e    LIKE srd_file.srd41e ,
            Edit11    LIKE srd_file.srd42d, 
            Edit12    LIKE srd_file.srd42e  
                    END RECORD,
    g_srd_t         RECORD                 #程式變數 (舊值)
            srd04     LIKE srd_file.srd04 ,    
            ima02     LIKE ima_file.ima02 ,
            ima021    LIKE ima_file.ima02 ,
            sra03     LIKE sra_file.sra03 ,
            srd051    LIKE srd_file.srd051,   #No.FUN-870041
            srd05     LIKE srd_file.srd05 ,
            ecg02     LIKE ecg_file.ecg02 ,
            srd01d    LIKE srd_file.srd01d,
            srd01e    LIKE srd_file.srd01e,
            srd02d    LIKE srd_file.srd02d,
            srd02e    LIKE srd_file.srd02e,
            srd03d    LIKE srd_file.srd03d,
            srd03e    LIKE srd_file.srd03e,
            srd04d    LIKE srd_file.srd04d,
            srd04e    LIKE srd_file.srd04e,
            srd05d    LIKE srd_file.srd05d,
            srd05e    LIKE srd_file.srd05e,
            srd06d    LIKE srd_file.srd06d,
            srd06e    LIKE srd_file.srd06e,
            Edit1    LIKE srd_file.srd07d,
            Edit2    LIKE srd_file.srd07e,
            srd08d    LIKE srd_file.srd08d,
            srd08e    LIKE srd_file.srd08e,
            srd09d    LIKE srd_file.srd09d,
            srd09e    LIKE srd_file.srd09e,
            srd10d    LIKE srd_file.srd10d,
            srd10e    LIKE srd_file.srd10e,
            srd11d    LIKE srd_file.srd11d,
            srd11e    LIKE srd_file.srd11e,
            srd12d    LIKE srd_file.srd12d,
            srd12e    LIKE srd_file.srd12e,
            srd13d    LIKE srd_file.srd13d,
            srd13e    LIKE srd_file.srd13e,
            Edit3    LIKE srd_file.srd14d,
            Edit4    LIKE srd_file.srd14e,
            srd15d    LIKE srd_file.srd15d,
            srd15e    LIKE srd_file.srd15e,
            srd16d    LIKE srd_file.srd16d,
            srd16e    LIKE srd_file.srd16e,
            srd17d    LIKE srd_file.srd17d,
            srd17e    LIKE srd_file.srd17e,
            srd18d    LIKE srd_file.srd18d,
            srd18e    LIKE srd_file.srd18e,
            srd19d    LIKE srd_file.srd19d,
            srd19e    LIKE srd_file.srd19e,
            srd20d    LIKE srd_file.srd20d,
            srd20e    LIKE srd_file.srd20e,
            Edit5    LIKE srd_file.srd21d,
            Edit6    LIKE srd_file.srd21e,
            srd22d    LIKE srd_file.srd22d,
            srd22e    LIKE srd_file.srd22e,
            srd23d    LIKE srd_file.srd23d,
            srd23e    LIKE srd_file.srd23e,
            srd24d    LIKE srd_file.srd24d,
            srd24e    LIKE srd_file.srd24e,
            srd25d    LIKE srd_file.srd25d,
            srd25e    LIKE srd_file.srd25e,
            srd26d    LIKE srd_file.srd26d,
            srd26e    LIKE srd_file.srd26e,
            srd27d    LIKE srd_file.srd27d,
            srd27e    LIKE srd_file.srd27e,
            Edit7    LIKE srd_file.srd28d,
            Edit8    LIKE srd_file.srd28e,
            srd29d    LIKE srd_file.srd29d,
            srd29e    LIKE srd_file.srd29e,
            srd30d    LIKE srd_file.srd30d,
            srd30e    LIKE srd_file.srd30e,
            srd31d    LIKE srd_file.srd31d,
            srd31e    LIKE srd_file.srd31e,
            srd32d    LIKE srd_file.srd32d,
            srd32e    LIKE srd_file.srd32e,
            srd33d    LIKE srd_file.srd33d,
            srd33e    LIKE srd_file.srd33e,
            srd34d    LIKE srd_file.srd34d,
            srd34e    LIKE srd_file.srd34e,
            Edit9    LIKE srd_file.srd35d,
            Edit10    LIKE srd_file.srd35e,
            srd36d    LIKE srd_file.srd36d,
            srd36e    LIKE srd_file.srd36e,
            srd37d    LIKE srd_file.srd37d,
            srd37e    LIKE srd_file.srd37e,
            srd38d    LIKE srd_file.srd38d,
            srd38e    LIKE srd_file.srd38e,
            srd39d    LIKE srd_file.srd39d,
            srd39e    LIKE srd_file.srd39e,
            srd40d    LIKE srd_file.srd40d,
            srd40e    LIKE srd_file.srd40e,
            srd41d    LIKE srd_file.srd41d,
            srd41e    LIKE srd_file.srd41e,
            Edit11    LIKE srd_file.srd42d,
            Edit12    LIKE srd_file.srd42e
                    END RECORD,
    g_sre           DYNAMIC ARRAY OF RECORD
            sre04    LIKE sre_file.sre04,
            ima02_b  LIKE ima_file.ima02,
            ima021_b LIKE ima_file.ima021,
            ima55_b  LIKE ima_file.ima55,
            sre05    LIKE sre_file.sre05,
            ecg02_b  LIKE ecg_file.ecg02,
            sre08    LIKE sre_file.sre08,
            sre051   LIKE sre_file.sre051,    #No.FUN-870097
            sre07    LIKE sre_file.sre07,
            sre09    LIKE sre_file.sre09,
            sre10    LIKE sre_file.sre10,
            sre11    LIKE sre_file.sre11,
            sre12    LIKE sre_file.sre12
                    END RECORD,    
    g_wc,g_sql,g_wc2    string, 
    g_rec_b,g_rec_b1    LIKE type_file.num5,     #單身筆數   #No.FUN-680130 SMALLINT
    l_ac                LIKE type_file.num5      #目前處理的ARRAY CNT    #No.FUN-680130 SMALLINT
 
DEFINE   g_forupd_sql    STRING  #SELECT ... FOR UPDATE SQL 
DEFINE   g_sql_tmp       STRING  #No.TQC-720019
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680130 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680130 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680130 VARCHAR(72) 
DEFINE   g_row_count     LIKE type_file.num10    #No.FUN-680130 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #No.FUN-680130 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #No.FUN-680130 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #No.FUN-680130 SMALLINT 
DEFINE   g_before_input_done   LIKE type_file.num5          #No.FUN-680130 SMALLINT
DEFINE   g_show_day      LIKE type_file.dat    #顯示日排程的日期   #No.FUN-680130 DATE
DEFINE   g_draw_day      LIKE type_file.dat    #畫統計圖用的日期   #No.FUN-680130 DATE
DEFINE   g_draw_x,g_draw_y,g_draw_dx,g_draw_dy,g_draw_width,g_draw_multiple LIKE type_file.num10    #No.FUN-680130 INTEGER
DEFINE   g_draw_start_y  LIKE type_file.num10                      #No.FUN-680130 INTEGER
DEFINE   g_action_flag STRING
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_srd01_t = NULL

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6B0014

    OPEN WINDOW i120_w WITH FORM "asr/42f/asri120" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()

   IF g_sma.sma118 = "N" THEN
      CALL cl_set_comp_visible("srd051",FALSE)
      CALL cl_set_comp_visible("sre051",FALSE)    #No.FUN-870097
   END IF
 
    CALL i120_menu()
    CLOSE FORM i120_w                      #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6B0014
END MAIN
 
#QBE 查詢資料
FUNCTION i120_cs()
  DEFINE l_sql STRING                      #No.FUN-680130
    CLEAR FORM                             #清除畫面
    CALL g_srd.clear()
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_srd01 TO NULL    #No.FUN-750051
   INITIALIZE g_srd02 TO NULL    #No.FUN-750051
   INITIALIZE g_srd03 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON srd01,srd02,srd03,srd04,srd051,srd05    #No.FUN-870041
       FROM srd01,srd02,srd03,s_srd[1].srd04,s_srd[1].srd051,s_srd[1].srd05  #螢幕上取條件   #No.FUN-870041
 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP
       CASE
          WHEN INFIELD(srd03)  
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_eci"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_srd03
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO srd03
               NEXT FIELD srd03
          WHEN INFIELD(srd04)
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_ima17"
#              LET g_qryparam.state = "c"
#              LET g_qryparam.default1 = g_srd[1].srd04
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima(TRUE, "q_ima17","",g_srd[1].srd04,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
               DISPLAY g_qryparam.multiret TO srd04
               NEXT FIELD srd04
          #-----No.FUN-870041-----
          WHEN INFIELD(srd051)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_bma7"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO srd051
          #-----No.FUN-870041 END-----
          WHEN INFIELD(srd05)  
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ecg"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO srd05
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
          CALL cl_qbe_select() 
      ON ACTION qbe_save
          CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN RETURN END IF
    LET g_sql = " SELECT srd01,srd02,srd03 ",
                " FROM srd_file",
                " WHERE ", g_wc CLIPPED,
                " GROUP BY srd01,srd02,srd03"
 
    LET l_sql=g_sql," ORDER BY srd01,srd02,srd03"
    PREPARE i120_prepare FROM l_sql
    DECLARE i120_bcs                       #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i120_prepare
        
    DROP TABLE i120_cnttmp
 
#   LET l_sql=g_sql," INTO TEMP i120_cnttmp"      #No.TQC-720019
    LET g_sql_tmp=g_sql," INTO TEMP i120_cnttmp"  #No.TQC-720019
#   PREPARE i120_cnttmp_sql FROM l_sql      #No.TQC-720019
    PREPARE i120_cnttmp_sql FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i120_cnttmp_sql
    IF SQLCA.sqlcode THEN
      CALL cl_err('crt tmp',SQLCA.sqlcode,1)
      RETURN
    END IF
 
    LET g_sql="SELECT COUNT(*) FROM i120_cnttmp"
    
    PREPARE i120_precount FROM g_sql
    DECLARE i120_count CURSOR FOR i120_precount
 
END FUNCTION
 
FUNCTION i120_menu()
 
   WHILE TRUE
      #CHI-780003...................begin
      CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "page02")
            CALL i120_bp("G")
         WHEN g_action_flag = "page03"
            CALL i120_bp1("G")
      #CHI-780003...................end
      END CASE

      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i120_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i120_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i120_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i120_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_srd01 IS NOT NULL THEN
                  LET g_doc.column1 = "srd01"
                  LET g_doc.value1 = g_srd01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_srd),'','')
            END IF
        #CHI-780003...............begin
        #WHEN "page03" 
        #   CALL i120_page03()
        #WHEN "prev_day" 
        #   CALL i120_prev_day()
        #WHEN "next_day" 
        #   CALL i120_next_day()
        #WHEN "page04" 
        #   CALL i120_draw()
        #CHI-780003...............end
         WHEN "modify_seq"
            IF cl_chk_act_auth() THEN
               CALL i120_t()
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i120_a()
    IF s_shut(0) THEN RETURN END IF                #判斷目前系統是否可用
    MESSAGE ""
    CLEAR FORM
    CALL g_srd.clear()
    INITIALIZE g_srd01 LIKE srd_file.srd01         #DEFAULT 設定
    INITIALIZE g_srd02 LIKE srd_file.srd02         #DEFAULT 設定
    INITIALIZE g_srd03 LIKE srd_file.srd03         #DEFAULT 設定
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i120_i("a")                           #輸入單頭
        IF INT_FLAG THEN                           #使用者不玩了
            LET g_srd01=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_srd01 IS NULL THEN # KEY 不可空白
            CONTINUE WHILE
        END IF
        CALL g_srd.clear()
        LET g_rec_b = 0 
        CALL i120_b()                              #輸入單身
        SELECT srd01,srd02,srd03 INTO g_srd01,g_srd02,g_srd03 FROM srd_file
            WHERE srd01 = g_srd01
              AND srd02 = g_srd02
              AND srd03 = g_srd03
        LET g_srd01_t = g_srd01                    #保留舊值
        LET g_srd02_t = g_srd02                    #保留舊值
        LET g_srd03_t = g_srd03                    #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i120_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入     #No.FUN-680130 VARCHAR(1)
    l_n1,l_n        LIKE type_file.num5,    #No.FUN-680130 SMALLINT
    p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改 #No.FUN-680130 VARCHAR(1)
    l_str           STRING, 
    l_dt            LIKE type_file.dat      #No.FUN-680130 DATE
 
    DISPLAY g_srd01 TO srd01 
    DISPLAY g_srd02 TO srd02
    DISPLAY g_srd03 TO srd03
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031 
    INPUT g_srd01,g_srd02,g_srd03 FROM srd01,srd02,srd03 #WITHOUT DEFAULTS 
 
        AFTER FIELD srd01
          IF NOT cl_null(g_srd01) THEN
            LET l_str=g_srd01,'/1/1'
            LET l_dt=DATE(l_str)
            IF (l_dt IS NULL) OR (Length(g_srd01)<>4)THEN
               CALL cl_err(g_srd01,"-1204",1)
               NEXT FIELD srd01
            END IF
          END IF 
 
        AFTER FIELD srd02
          IF NOT cl_null(g_srd02) THEN
            LET l_str='2000/',g_srd02,'/1'
            LET l_dt=DATE(l_str)
            IF l_dt IS NULL THEN
               CALL cl_err(g_srd02,"-1205",1)
               NEXT FIELD srd02
            END IF
          END IF 
          
        AFTER FIELD srd03
          IF g_srd03 != g_srd03_t OR cl_null(g_srd03_t) THEN
             CALL i120_set_srd03(g_srd03) RETURNING g_eci06,g_eci03,g_eca02
             DISPLAY g_eci06,g_eci03,g_eca02 TO eci06,eci03,eca02
             IF NOT cl_null(g_srd03) THEN 
                CALL i120_srd03(g_srd03)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD srd03
                END IF
             END IF
          END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(srd03)  
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_eci"
                CALL cl_create_qry() RETURNING g_srd03
               #DISPLAY BY NAME g_srd03    #TQC-940103 
                DISPLAY g_srd03 TO srd03   #TQC-940103     
                NEXT FIELD srd03
              OTHERWISE EXIT CASE
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i120_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_srd01,g_srd02,g_srd03 TO NULL  #NO.FUN-6A0166
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_srd.clear()
    CALL i120_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i120_bcs                          #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_srd01,g_srd02,g_srd03 TO NULL
    ELSE
        CALL i120_fetch('F')               #讀出TEMP第一筆並顯示
        OPEN i120_count
        FETCH i120_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i120_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式     #No.FUN-680130 VARCHAR(1)
    l_abso          LIKE type_file.num10   #絕對的筆數   #No.FUN-680130 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i120_bcs INTO g_srd01,g_srd02,g_srd03
        WHEN 'P' FETCH PREVIOUS i120_bcs INTO g_srd01,g_srd02,g_srd03
        WHEN 'F' FETCH FIRST    i120_bcs INTO g_srd01,g_srd02,g_srd03
        WHEN 'L' FETCH LAST     i120_bcs INTO g_srd01,g_srd02,g_srd03
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i120_bcs INTO g_srd01,g_srd02,g_srd03
            LET mi_no_ask = FALSE
    END CASE
    SELECT unique srd01,srd02,srd03 FROM srd_file WHERE srd01 = g_srd01
                                                    AND srd02 = g_srd02
                                                    AND srd03 = g_srd03
    IF SQLCA.sqlcode THEN                         #有麻煩
#       CALL cl_err(g_srd01,SQLCA.sqlcode,0)   #No.FUN-660138
        CALL cl_err3("sel","srd_file",g_srd01,g_srd02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
        INITIALIZE g_srd01 TO NULL  #TQC-6B0105
        INITIALIZE g_srd02 TO NULL  #TQC-6B0105
        INITIALIZE g_srd03 TO NULL  #TQC-6B0105
    ELSE
        CALL i120_show()
        CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1
           WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump
        END CASE
    
        CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i120_show()
 
    DISPLAY g_srd01 TO srd01           #單頭
    DISPLAY g_srd02 TO srd02           #單頭
    DISPLAY g_srd03 TO srd03           #單頭
    CALL i120_set_srd03(g_srd03) RETURNING g_eci06,g_eci03,g_eca02
    DISPLAY g_eci06,g_eci03,g_eca02 TO eci06,eci03,eca02
    CALL i120_b_fill(g_wc)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    CALL i120_page03()
    CALL i120_draw()
END FUNCTION
 
FUNCTION i120_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
    DEFINE l_cnt LIKE type_file.num10         #No.FUN-680130 INTEGER
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_srd01) OR 
       cl_null(g_srd02) OR
       cl_null(g_srd03) THEN
	     CALL cl_err('',-400,0) RETURN 
    END IF
    SELECT COUNT(*) INTO l_cnt FROM sre_file WHERE sre01=g_srd01
                                               AND sre02=g_srd02
                                               AND sre03=g_srd03
                                               AND (sre09<>0 OR sre10<>0 OR sre11<>0)
    IF l_cnt>0 THEN
       CALL cl_err('','asr-004',1)
       RETURN
    END IF
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "srd01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_srd01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        LET g_success='Y'
        BEGIN WORK
        DELETE FROM srd_file WHERE srd01=g_srd01
                               AND srd02=g_srd02
                               AND srd03=g_srd03
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#          CALL cl_err('del srd',SQLCA.sqlcode,0)   #No.FUN-660138
           CALL cl_err3("del","srd_file",g_srd01,g_srd02,SQLCA.sqlcode,"","del srd",1)  #No.FUN-660138
           ROLLBACK WORK
        ELSE 
           DELETE FROM sre_file WHERE sre01=g_srd01
                                  AND sre02=g_srd02
                                  AND sre03=g_srd03
        # FUN-B80063  增加五行空行   




           IF SQLCA.sqlcode THEN
#             CALL cl_err('del sre',SQLCA.sqlcode,0)   #No.FUN-660138
              CALL cl_err3("del","sre_file",g_srd01,g_srd02,SQLCA.sqlcode,"","del sre",1)  #No.FUN-660138
              ROLLBACK WORK
           ELSE
              COMMIT WORK
              CLEAR FORM
              CALL g_srd.clear()
              DROP TABLE i120_cnttmp                   #No.TQC-720019
              PREPARE i120_cnttmp_sql2 FROM g_sql_tmp  #No.TQC-720019
              EXECUTE i120_cnttmp_sql2                 #No.TQC-720019
              OPEN i120_count
              #FUN-B50064-add-start--
              IF STATUS THEN
                 CLOSE i120_bcs
                 CLOSE i120_count
                 COMMIT WORK
                 RETURN
              END IF
              #FUN-B50064-add-end-- 
              FETCH i120_count INTO g_row_count
              #FUN-B50064-add-start--
              IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
                 CLOSE i120_bcs
                 CLOSE i120_count
                 COMMIT WORK
                 RETURN
              END IF
              #FUN-B50064-add-end-- 
              DISPLAY g_row_count TO FORMONLY.cnt
              OPEN i120_bcs
              IF g_curs_index = g_row_count + 1 THEN
                 LET g_jump = g_row_count
                 CALL i120_fetch('L')
              ELSE
                 LET g_jump = g_curs_index
                 LET mi_no_ask = TRUE
                 CALL i120_fetch('/')
              END IF   
           END IF
        END IF
        COMMIT WORK
    END IF
END FUNCTION
 
#單身
FUNCTION i120_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680130 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,    #檢查重複用        #No.FUN-680130 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680130 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680130 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680130 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否          #No.FUN-680130 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    #CHI-780003
    IF cl_null(g_srd01) OR 
       cl_null(g_srd02) OR
       cl_null(g_srd03) THEN
	     CALL cl_err('',-400,0) RETURN 
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT srd04 ,''    ,''    ,''    ,srd051,srd05 ,'',",   #No.FUN-870041
        "srd01d,srd01e,srd02d,srd02e,srd03d,srd03e,",
        "srd04d,srd04e,srd05d,srd05e,srd06d,srd06e,",
        "srd07d,srd07e,srd08d,srd08e,srd09d,srd09e,",
        "srd10d,srd10e,srd11d,srd11e,srd12d,srd12e,",
        "srd13d,srd13e,srd14d,srd14e,srd15d,srd15e,",
        "srd16d,srd16e,srd17d,srd17e,srd18d,srd18e,",
        "srd19d,srd19e,srd20d,srd20e,srd21d,srd21e,",
        "srd22d,srd22e,srd23d,srd23e,srd24d,srd24e,",
        "srd25d,srd25e,srd26d,srd26e,srd27d,srd27e,",
        "srd28d,srd28e,srd29d,srd29e,srd30d,srd30e,",
        "srd31d,srd31e,srd32d,srd32e,srd33d,srd33e,",
        "srd34d,srd34e,srd35d,srd35e,srd36d,srd36e,",
        "srd37d,srd37e,srd38d,srd38e,srd39d,srd39e,",
        "srd40d,srd40e,srd41d,srd41e,srd42d,srd42e ",
        " FROM srd_file  WHERE srd01= ? AND srd02 = ?",
        " AND srd03 = ? AND srd04 = ? AND srd05 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i120_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_srd WITHOUT DEFAULTS FROM s_srd.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               CALL i120_set_entry(p_cmd)
               CALL i120_set_no_entry(p_cmd)
               LET g_before_input_done = TRUE
               LET g_srd_t.* = g_srd[l_ac].*  #BACKUP
               CALL i120_set_entry_b(p_cmd)
               OPEN i120_bcl USING g_srd01,g_srd02,g_srd03,
                                   g_srd_t.srd04,g_srd_t.srd05
               IF STATUS THEN
                  CALL cl_err("OPEN i120_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i120_bcl INTO g_srd[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               CALL i120_set_srd04(g_srd[l_ac].srd04) RETURNING g_srd[l_ac].ima02,
                                                                g_srd[l_ac].ima021,
                                                                g_srd[l_ac].sra03
               CALL i120_set_srd05(g_srd[l_ac].srd05) RETURNING g_srd[l_ac].ecg02                                                  
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE
            CALL i120_set_entry(p_cmd)
            CALL i120_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            INITIALIZE g_srd[l_ac].* TO NULL      #900423
            LET g_srd[l_ac].srd051 = " "   #No.FUN-870041
            LET g_srd_t.* = g_srd[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            CALL i120_gendetail()
            CALL i120_set_entry_b(p_cmd)
            NEXT FIELD srd04
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            LET g_success='Y'
            BEGIN WORK
            #-----No.FUN-870041-----
            IF cl_null(g_srd[l_ac].srd051) THEN
               LET g_srd[l_ac].srd051 = " "
            END IF
            #-----No.FUN-870041 END-----
            INSERT INTO srd_file (srd01 ,srd02 ,srd03 ,srd04 ,srd05 ,srd051,   #No.FUN-870041
                                  srd01d,srd01e,srd02d,srd02e,srd03d,srd03e,
                                  srd04d,srd04e,srd05d,srd05e,srd06d,srd06e,
                                  srd07d,srd07e,srd08d,srd08e,srd09d,srd09e,
                                  srd10d,srd10e,srd11d,srd11e,srd12d,srd12e,
                                  srd13d,srd13e,srd14d,srd14e,srd15d,srd15e,
                                  srd16d,srd16e,srd17d,srd17e,srd18d,srd18e,
                                  srd19d,srd19e,srd20d,srd20e,srd21d,srd21e,
                                  srd22d,srd22e,srd23d,srd23e,srd24d,srd24e,
                                  srd25d,srd25e,srd26d,srd26e,srd27d,srd27e,
                                  srd28d,srd28e,srd29d,srd29e,srd30d,srd30e,
                                  srd31d,srd31e,srd32d,srd32e,srd33d,srd33e,
                                  srd34d,srd34e,srd35d,srd35e,srd36d,srd36e,
                                  srd37d,srd37e,srd38d,srd38e,srd39d,srd39e,
                                  srd40d,srd40e,srd41d,srd41e,srd42d,srd42e,
                                  srdplant,srdlegal)   #FUN-980008 add
            VALUES(g_srd01,g_srd02,g_srd03,g_srd[l_ac].srd04,g_srd[l_ac].srd05,
                   g_srd[l_ac].srd051,g_srd[l_ac].srd01d,g_srd[l_ac].srd01e,   #No.FUN-870041
                   g_srd[l_ac].srd02d,g_srd[l_ac].srd02e,
                   g_srd[l_ac].srd03d,g_srd[l_ac].srd03e,
                   g_srd[l_ac].srd04d,g_srd[l_ac].srd04e,
                   g_srd[l_ac].srd05d,g_srd[l_ac].srd05e,
                   g_srd[l_ac].srd06d,g_srd[l_ac].srd06e,
                   g_srd[l_ac].Edit1,g_srd[l_ac].Edit2,
                   g_srd[l_ac].srd08d,g_srd[l_ac].srd08e,
                   g_srd[l_ac].srd09d,g_srd[l_ac].srd09e,
                   g_srd[l_ac].srd10d,g_srd[l_ac].srd10e,
                   g_srd[l_ac].srd11d,g_srd[l_ac].srd11e,
                   g_srd[l_ac].srd12d,g_srd[l_ac].srd12e,
                   g_srd[l_ac].srd13d,g_srd[l_ac].srd13e,
                   g_srd[l_ac].Edit3,g_srd[l_ac].Edit4,
                   g_srd[l_ac].srd15d,g_srd[l_ac].srd15e,
                   g_srd[l_ac].srd16d,g_srd[l_ac].srd16e,
                   g_srd[l_ac].srd17d,g_srd[l_ac].srd17e,
                   g_srd[l_ac].srd18d,g_srd[l_ac].srd18e,
                   g_srd[l_ac].srd19d,g_srd[l_ac].srd19e,
                   g_srd[l_ac].srd20d,g_srd[l_ac].srd20e,
                   g_srd[l_ac].Edit5,g_srd[l_ac].Edit6,
                   g_srd[l_ac].srd22d,g_srd[l_ac].srd22e,
                   g_srd[l_ac].srd23d,g_srd[l_ac].srd23e,
                   g_srd[l_ac].srd24d,g_srd[l_ac].srd24e,
                   g_srd[l_ac].srd25d,g_srd[l_ac].srd25e,
                   g_srd[l_ac].srd26d,g_srd[l_ac].srd26e,
                   g_srd[l_ac].srd27d,g_srd[l_ac].srd27e,
                   g_srd[l_ac].Edit7,g_srd[l_ac].Edit8,
                   g_srd[l_ac].srd29d,g_srd[l_ac].srd29e,
                   g_srd[l_ac].srd30d,g_srd[l_ac].srd30e,
                   g_srd[l_ac].srd31d,g_srd[l_ac].srd31e,
                   g_srd[l_ac].srd32d,g_srd[l_ac].srd32e,
                   g_srd[l_ac].srd33d,g_srd[l_ac].srd33e,
                   g_srd[l_ac].srd34d,g_srd[l_ac].srd34e,
                   g_srd[l_ac].Edit9,g_srd[l_ac].Edit10,
                   g_srd[l_ac].srd36d,g_srd[l_ac].srd36e,
                   g_srd[l_ac].srd37d,g_srd[l_ac].srd37e,
                   g_srd[l_ac].srd38d,g_srd[l_ac].srd38e,
                   g_srd[l_ac].srd39d,g_srd[l_ac].srd39e,
                   g_srd[l_ac].srd40d,g_srd[l_ac].srd40e,
                   g_srd[l_ac].srd41d,g_srd[l_ac].srd41e,
                   g_srd[l_ac].Edit11,g_srd[l_ac].Edit12,
                   g_plant,g_legal)   #FUN-980008 add
            IF SQLCA.sqlcode THEN
                LET g_success='N'
            #    ROLLBACK WORK                # FUN-B80063 下移三行
                CANCEL INSERT
#               CALL cl_err('ins srd',SQLCA.sqlcode,0)   #No.FUN-660138
                CALL cl_err3("ins","srd_file",g_srd01,g_srd02,SQLCA.sqlcode,"","ins srd",1)  #No.FUN-660138
                ROLLBACK WORK                # FUN-B80063
            ELSE
                LET g_success='Y'
                CALL i120_inssre()
                IF g_success='Y' THEN
                   COMMIT WORK
                   LET g_rec_b = g_rec_b + 1
                   DISPLAY g_rec_b TO FORMONLY.cn2  
                   MESSAGE 'INSERT O.K'    
                ELSE
                   ROLLBACK WORK   
                   CANCEL INSERT
                END IF   
            END IF
 
        AFTER FIELD srd04
            IF g_srd[l_ac].srd04 != g_srd_t.srd04 OR 
              (g_srd[l_ac].srd04 IS NOT NULL AND g_srd_t.srd04 IS NULL) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_srd[l_ac].srd04,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_srd[l_ac].srd04= g_srd_t.srd04
                  NEXT FIELD srd04
               END IF
#FUN-AA0059 ---------------------end-------------------------------
               CALL i120_srd04()
               IF NOT cl_null(g_errno) THEN                 
                 CALL cl_err(g_srd[l_ac].srd04,g_errno,1)
                 LET g_srd[l_ac].ima02 =g_srd_t.ima02
                 LET g_srd[l_ac].ima021=g_srd_t.ima021
                 LET g_srd[l_ac].sra03 =g_srd_t.sra03
                 DISPLAY BY NAME g_srd[l_ac].ima02
                 DISPLAY BY NAME g_srd[l_ac].ima021
                 DISPLAY BY NAME g_srd[l_ac].sra03
                 NEXT FIELD srd04
               END IF
               CALL i120_set_srd04(g_srd[l_ac].srd04) RETURNING g_srd[l_ac].ima02,
                                                                g_srd[l_ac].ima021,
                                                                g_srd[l_ac].sra03
               DISPLAY BY NAME g_srd[l_ac].ima02
               DISPLAY BY NAME g_srd[l_ac].ima021
               DISPLAY BY NAME g_srd[l_ac].sra03
            END IF
 
         #-----No.FUN-870041-----
         AFTER FIELD srd051
            IF NOT cl_null(g_srd[l_ac].srd051) THEN
               SELECT COUNT(*) INTO g_cnt FROM bma_file
                WHERE bma06 = g_srd[l_ac].srd051
                  AND bma01 = g_srd[l_ac].srd04
               IF g_cnt = 0 THEN
                  CALL cl_err(g_srd[l_ac].srd051,"abm-618",0)
                  NEXT FIELD srd051
               END IF
            END IF
         #-----No.FUN-870041 END-----
 
         AFTER FIELD srd05
            CALL i120_set_srd05(g_srd[l_ac].srd05) RETURNING g_srd[l_ac].ecg02
            DISPLAY BY NAME g_srd[l_ac].ecg02
            IF g_srd[l_ac].srd05 != g_srd_t.srd05 OR 
                 (g_srd[l_ac].srd05 IS NOT NULL AND g_srd_t.srd05 IS NULL) THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM ecg_file
                WHERE ecg01=g_srd[l_ac].srd05 AND ecgacti='Y'
               IF l_cnt=0 THEN
#                  CALL cl_err(g_srd[l_ac].srd05,'apy-014',0)   #CHI-B40058
                 #CALL cl_err(g_srd[l_ac].srd05,'aem052',0)    #CHI-B40058   #MOD-B90070 mark
                  CALL cl_err(g_srd[l_ac].srd05,'aem-052',0)   #MOD-B90070
                  LET g_srd[l_ac].srd05=g_srd_t.srd05
                  DISPLAY BY NAME g_srd[l_ac].srd05
                  NEXT FIELD srd05
               END IF
               #檢查鍵值不可重複
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM srd_file WHERE srd01=g_srd01 AND srd02=g_srd02
                                                          AND srd03=g_srd03
                                                          AND srd04=g_srd[l_ac].srd04
                                                          AND srd05=g_srd[l_ac].srd05
               IF l_cnt>0 THEN
                  CALL cl_err('','-239',1)
                  NEXT FIELD srd05                  
               END IF                                
            END IF
        
        BEFORE DELETE                            #是否取消單身
            IF (not cl_null(g_srd_t.srd04)) OR (not cl_null(g_srd_t.srd05)) THEN
 
                SELECT COUNT(*) INTO l_cnt FROM sre_file WHERE sre01=g_srd01
                                                           AND sre02=g_srd02
                                                           AND sre03=g_srd03
                                                           AND sre04=g_srd_t.srd04
                                                           AND sre05=g_srd_t.srd05
                                                           AND (sre09<>0 OR sre10<>0 OR sre11<>0)
                IF l_cnt>0 THEN
                   CALL cl_err('','asr-004',1)
                   CANCEL DELETE
                END IF
            
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM sre_file
                 WHERE sre01 = g_srd01 AND sre02 = g_srd02
                   AND sre03 = g_srd03 AND sre04 = g_srd_t.srd04
                   AND sre05 = g_srd_t.srd05
                IF SQLCA.sqlcode THEN
#                  CALL cl_err('del sre',SQLCA.sqlcode,0)   #No.FUN-660138
                   CALL cl_err3("del","sre_file",g_srd_t.srd04,g_srd_t.srd05,SQLCA.sqlcode,"","del sre",1)  #No.FUN-660138
                   ROLLBACK WORK
                   CANCEL DELETE
                ELSE                
                   DELETE FROM srd_file
                    WHERE srd01 = g_srd01 AND srd02 = g_srd02
                      AND srd03 = g_srd03 AND srd04 = g_srd_t.srd04
                      AND srd05 = g_srd_t.srd05
                   IF SQLCA.sqlcode THEN
#                     CALL cl_err('del srd',SQLCA.sqlcode,0)   #No.FUN-660138
                      CALL cl_err3("del","srd_file",g_srd_t.srd04,g_srd_t.srd05,SQLCA.sqlcode,"","del srd",1)  #No.FUN-660138
                      ROLLBACK WORK
                      CANCEL DELETE 
                   END IF
                   LET g_rec_b = g_rec_b-1
                   DISPLAY g_rec_b TO FORMONLY.cn2  
                END IF
            END IF
 
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_srd[l_ac].* = g_srd_t.*
               CLOSE i120_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err('',-263,1)
               LET g_srd[l_ac].* = g_srd_t.*
            ELSE
             LET g_success='Y'
             IF g_success='Y' THEN
               UPDATE srd_file SET
                      srd04  = g_srd[l_ac].srd04 ,srd05=g_srd[l_ac].srd05,
                      srd051=g_srd[l_ac].srd051,   #No.FUN-870041
                      srd01d = g_srd[l_ac].srd01d ,srd02d = g_srd[l_ac].srd02d ,
                      srd03d = g_srd[l_ac].srd03d ,srd04d = g_srd[l_ac].srd04d ,
                      srd05d = g_srd[l_ac].srd05d ,srd06d = g_srd[l_ac].srd06d ,
                      srd07d = g_srd[l_ac].Edit1 ,srd08d = g_srd[l_ac].srd08d ,
                      srd09d = g_srd[l_ac].srd09d ,srd10d = g_srd[l_ac].srd10d ,
                      srd11d = g_srd[l_ac].srd11d ,srd12d = g_srd[l_ac].srd12d ,
                      srd13d = g_srd[l_ac].srd13d ,srd14d = g_srd[l_ac].Edit3 ,
                      srd15d = g_srd[l_ac].srd15d ,srd16d = g_srd[l_ac].srd16d ,
                      srd17d = g_srd[l_ac].srd17d ,srd18d = g_srd[l_ac].srd18d ,
                      srd19d = g_srd[l_ac].srd19d ,srd20d = g_srd[l_ac].srd20d ,
                      srd21d = g_srd[l_ac].Edit5 ,srd22d = g_srd[l_ac].srd22d ,
                      srd23d = g_srd[l_ac].srd23d ,srd24d = g_srd[l_ac].srd24d ,
                      srd25d = g_srd[l_ac].srd25d ,srd26d = g_srd[l_ac].srd26d ,
                      srd27d = g_srd[l_ac].srd27d ,srd28d = g_srd[l_ac].Edit7 ,
                      srd29d = g_srd[l_ac].srd29d ,srd30d = g_srd[l_ac].srd30d ,
                      srd31d = g_srd[l_ac].srd31d ,srd32d = g_srd[l_ac].srd32d ,
                      srd33d = g_srd[l_ac].srd33d ,srd34d = g_srd[l_ac].srd34d ,
                      srd35d = g_srd[l_ac].Edit9 ,srd36d = g_srd[l_ac].srd36d ,
                      srd37d = g_srd[l_ac].srd37d ,srd38d = g_srd[l_ac].srd38d ,
                      srd39d = g_srd[l_ac].srd39d ,srd40d = g_srd[l_ac].srd40d ,
                      srd41d = g_srd[l_ac].srd41d ,srd42d = g_srd[l_ac].Edit11 ,                                                         
                      srd01e = g_srd[l_ac].srd01e ,srd02e = g_srd[l_ac].srd02e ,
                      srd03e = g_srd[l_ac].srd03e ,srd04e = g_srd[l_ac].srd04e ,
                      srd05e = g_srd[l_ac].srd05e ,srd06e = g_srd[l_ac].srd06e ,
                      srd07e = g_srd[l_ac].Edit2 ,srd08e = g_srd[l_ac].srd08e ,
                      srd09e = g_srd[l_ac].srd09e ,srd10e = g_srd[l_ac].srd10e ,
                      srd11e = g_srd[l_ac].srd11e ,srd12e = g_srd[l_ac].srd12e ,
                      srd13e = g_srd[l_ac].srd13e ,srd14e = g_srd[l_ac].Edit4 ,
                      srd15e = g_srd[l_ac].srd15e ,srd16e = g_srd[l_ac].srd16e ,
                      srd17e = g_srd[l_ac].srd17e ,srd18e = g_srd[l_ac].srd18e ,
                      srd19e = g_srd[l_ac].srd19e ,srd20e = g_srd[l_ac].srd20e ,
                      srd21e = g_srd[l_ac].Edit6 ,srd22e = g_srd[l_ac].srd22e ,
                      srd23e = g_srd[l_ac].srd23e ,srd24e = g_srd[l_ac].srd24e ,
                      srd25e = g_srd[l_ac].srd25e ,srd26e = g_srd[l_ac].srd26e ,
                      srd27e = g_srd[l_ac].srd27e ,srd28e = g_srd[l_ac].Edit8 ,
                      srd29e = g_srd[l_ac].srd29e ,srd30e = g_srd[l_ac].srd30e ,
                      srd31e = g_srd[l_ac].srd31e ,srd32e = g_srd[l_ac].srd32e ,
                      srd33e = g_srd[l_ac].srd33e ,srd34e = g_srd[l_ac].srd34e ,
                      srd35e = g_srd[l_ac].Edit10 ,srd36e = g_srd[l_ac].srd36e ,
                      srd37e = g_srd[l_ac].srd37e ,srd38e = g_srd[l_ac].srd38e ,
                      srd39e = g_srd[l_ac].srd39e ,srd40e = g_srd[l_ac].srd40e ,
                      srd41e = g_srd[l_ac].srd41e ,srd42e = g_srd[l_ac].Edit12
                      WHERE srd01=g_srd01
                        AND srd02=g_srd02
                        AND srd03=g_srd03
                        AND srd04=g_srd_t.srd04
                        AND srd05=g_srd_t.srd05 
               IF (SQLCA.sqlcode) OR (SQLCA.sqlerrd[3]=0) THEN
#                 CALL cl_err('upd srd',SQLCA.sqlcode,0) #FUN-660138
                  CALL cl_err3("upd","srd_file",g_srd_t.srd04,g_srd_t.srd05,SQLCA.sqlcode,"","upd srd",1) #FUN-660138
                  LET g_success='N'
               END IF                          
               IF g_success='Y' THEN
                  CALL i120_updatesre()
               END IF   
             END IF                          
             IF g_success='N' THEN
                ROLLBACK WORK
                LET g_srd[l_ac].* = g_srd_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac                #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN           #FUN-D40030 add
                  LET g_srd[l_ac].* = g_srd_t.*
               #FUN-D40030---add---str---
               ELSE
                  CALL g_srd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               END IF
               #FUN-D40030---add---end---
               CLOSE i120_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac                #FUN-D40030 add
            LET g_srd_t.* = g_srd[l_ac].*
            CLOSE i120_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(srd02) AND l_ac > 1 THEN
              LET g_srd[l_ac].* = g_srd[l_ac-1].*
              NEXT FIELD srd02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(srd04) 
#FUN-AA0059---------mod------------str----------------- 
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima17"
#                 LET g_qryparam.default1 = g_srd[l_ac].srd04
#                 CALL cl_create_qry() RETURNING g_srd[l_ac].srd04
                  CALL q_sel_ima(FALSE, "q_ima17","",g_srd[l_ac].srd04,"","","","","",'' ) 
                     RETURNING g_srd[l_ac].srd04  
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY BY NAME g_srd[l_ac].srd04
                  NEXT FIELD srd04
              #-----No.FUN-870041-----
              WHEN INFIELD(srd051)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_bma7"
                   LET g_qryparam.default1 = g_srd[l_ac].srd051
                   LET g_qryparam.arg1 = g_srd[l_ac].srd04
                   CALL cl_create_qry() RETURNING g_srd[l_ac].srd051
                   DISPLAY BY NAME g_srd[l_ac].srd051
                   NEXT FIELD srd051
              #-----No.FUN-870041 END-----
              WHEN INFIELD(srd05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecg"
                  LET g_qryparam.default1 = g_srd[l_ac].srd05
                  CALL cl_create_qry() RETURNING g_srd[l_ac].srd05
                  DISPLAY g_srd[l_ac].srd05 TO srd05
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
 
    CLOSE i120_bcl
    COMMIT WORK
    LET g_action_flag="page02"  #CHI-780003
END FUNCTION
   
FUNCTION i120_b_askkey()
DEFINE
    l_wc    LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(200)
 
    CLEAR FORM
    CALL g_srd.clear()
 
    CONSTRUCT l_wc ON srd04,srd051,srd05  #螢幕上取條件   #No.FUN-870041
       FROM s_srd[1].srd04,s_srd[1].srd051,s_srd[1].srd05   #No.FUN-870041
 
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
    
    IF INT_FLAG THEN RETURN END IF
    
    CALL i120_b_fill(l_wc)
    
END FUNCTION
 
FUNCTION i120_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc   LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(200)
 
    IF not cl_null(p_wc) THEN
       LET p_wc=" AND ",p_wc CLIPPED
    END IF  
    LET g_sql ="SELECT  srd04 ,''    ,''    ,''    ,srd051,srd05 ,'',",   #No.FUN-870041
               "srd01d,srd01e,srd02d,srd02e,srd03d,srd03e,",
               "srd04d,srd04e,srd05d,srd05e,srd06d,srd06e,",
               "srd07d,srd07e,srd08d,srd08e,srd09d,srd09e,",
               "srd10d,srd10e,srd11d,srd11e,srd12d,srd12e,",
               "srd13d,srd13e,srd14d,srd14e,srd15d,srd15e,",
               "srd16d,srd16e,srd17d,srd17e,srd18d,srd18e,",
               "srd19d,srd19e,srd20d,srd20e,srd21d,srd21e,",
               "srd22d,srd22e,srd23d,srd23e,srd24d,srd24e,",
               "srd25d,srd25e,srd26d,srd26e,srd27d,srd27e,",
               "srd28d,srd28e,srd29d,srd29e,srd30d,srd30e,",
               "srd31d,srd31e,srd32d,srd32e,srd33d,srd33e,",
               "srd34d,srd34e,srd35d,srd35e,srd36d,srd36e,",
               "srd37d,srd37e,srd38d,srd38e,srd39d,srd39e,",
               "srd40d,srd40e,srd41d,srd41e,srd42d,srd42e ",
               " FROM srd_file ",
               " WHERE srd01 = ",g_srd01," AND ",
               "       srd02 = ",g_srd02," AND ",
               "       srd03 ='",g_srd03,"' ",
               p_wc CLIPPED , " ORDER BY srd02"
          
    PREPARE i120_prepare2 FROM g_sql      #預備一下
    DECLARE srd_cs CURSOR FOR i120_prepare2
 
    CALL g_srd.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH srd_cs INTO g_srd[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
 
      CALL i120_set_srd04(g_srd[g_cnt].srd04) RETURNING g_srd[g_cnt].ima02,
                                                        g_srd[g_cnt].ima021,
                                                        g_srd[g_cnt].sra03
      CALL i120_set_srd05(g_srd[g_cnt].srd05) RETURNING g_srd[g_cnt].ecg02                                                  
 
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      
    END FOREACH
    CALL g_srd.deleteElement(g_cnt)
    LET g_rec_b=g_cnt -1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i120_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN        
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_srd TO s_srd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first 
         CALL i120_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i120_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL i120_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i120_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL i120_fetch('L')
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
 
#@    ON ACTION 修改生產順序
      ON ACTION modify_seq
         LET g_action_choice = "modify_seq"
         EXIT DISPLAY
 
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      #CHI-780003................begin
      ON ACTION page02
         LET g_action_flag="page02"
         EXIT DISPLAY
      #CHI-780003................end
 
      ON ACTION page03
        #CHI-780003................begin
        #LET g_action_choice="page03"
        #EXIT DISPLAY
         LET g_action_flag="page03"
         EXIT DISPLAY
        #CHI-780003................end
 
      ON ACTION prev_day
        #CHI-780003................begin
        #LET g_action_choice="prev_day"
        #EXIT DISPLAY
         CALL i120_prev_day()
        #CHI-780003................end
   
      ON ACTION next_day
        #CHI-780003................begin
        #LET g_action_choice="next_day"
        #EXIT DISPLAY
         CALL i120_next_day()
        #CHI-780003................end
 
      ON ACTION page04
        #CHI-780003................begin
        #LET g_action_choice="page04"
        #EXIT DISPLAY
         CALL i120_draw()
        #CHI-780003................end
 
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#CHI-780003...................begin
FUNCTION i120_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   CALL i120_page03()
 
   DISPLAY ARRAY g_sre TO s_sre.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
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
      ON ACTION first 
         CALL i120_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i120_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL i120_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i120_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL i120_fetch('L')
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
 
#@    ON ACTION 修改生產順序
      ON ACTION modify_seq
         LET g_action_choice = "modify_seq"
         EXIT DISPLAY
 
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION page02
         LET g_action_flag="page02"
         EXIT DISPLAY
 
      ON ACTION page03
         LET g_action_flag="page03"
         EXIT DISPLAY
        #CHI-780003................end
 
      ON ACTION prev_day
         CALL i120_prev_day()
   
      ON ACTION next_day
         CALL i120_next_day()
 
      ON ACTION page04
         CALL i120_draw()
 
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#CHI-780003...................end
 
FUNCTION i120_set_srd03(p_srd03)
  DEFINE p_srd03 LIKE srd_file.srd03
  DEFINE l_eci03 LIKE eci_file.eci03
  DEFINE l_eci06 LIKE eci_file.eci06
  DEFINE l_eca02 LIKE eca_file.eca02
  
  LET l_eci03=''
  LET l_eci06=''
  SELECT eci03,eci06 INTO l_eci03,l_eci06 FROM eci_file WHERE eci01=p_srd03
 
  LET l_eca02=''  
  SELECT eca02 INTO l_eca02 FROM eca_file WHERE eca01=l_eci03
  
  RETURN l_eci03,l_eci06,l_eci03
  
END FUNCTION
 
FUNCTION i120_set_srd04(p_srd04)
  DEFINE p_srd04 LIKE srd_file.srd04
  DEFINE l_ima02 LIKE ima_file.ima02
  DEFINE l_ima021 LIKE ima_file.ima021
  DEFINE l_ima55,l_sra03 LIKE ima_file.ima55
  LET l_ima02 =''
  LET l_ima021=''
  LET l_ima55 =''
  LET l_sra03 =''
  SELECT sra03 INTO l_sra03 FROM sra_file WHERE sra01=g_srd03 AND sra02=p_srd04
  
  SELECT ima02,ima021,ima55 INTO l_ima02,l_ima021,l_ima55 FROM ima_file
    WHERE ima01=p_srd04
  IF NOT cl_null(l_sra03) THEN
    LET l_ima55=l_sra03
  END IF
  RETURN l_ima02,l_ima02,l_ima55
 
END FUNCTION
 
 
FUNCTION i120_set_srd05(p_srd05)
  DEFINE p_srd05 LIKE srd_file.srd05
  DEFINE l_ecg02 LIKE ecg_file.ecg02
  
  LET l_ecg02=''
  SELECT ecg02 INTO l_ecg02 FROM ecg_file WHERE ecg01=p_srd05
  RETURN l_ecg02
END FUNCTION
 
FUNCTION i120_srd03(p_srd03)
 DEFINE p_srd03     LIKE srd_file.srd03,
        l_eciacti   LIKE eci_file.eciacti
 
 LET g_errno = ''
 SELECT eciacti INTO l_eciacti
    FROM eci_file WHERE eci01 = p_srd03
 CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
      WHEN l_eciacti='N' LET g_errno = '9028'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
 END CASE
END FUNCTION
 
FUNCTION i120_srd04()
  DEFINE l_imaacti LIKE ima_file.imaacti
  DEFINE l_ima911  LIKE ima_file.ima911 #CHI-6A0049
 
  LET g_errno = " "
  SELECT imaacti INTO l_imaacti
    FROM ima_file WHERE ima01 = g_srd[l_ac].srd04
                   #AND ima911='Y' ##CHI-6A0049
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
       WHEN l_imaacti='N' LET g_errno = '9028'
       WHEN l_ima911='N'  LET g_errno = 'asr-048' #CHI-6A0049
 #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
 #FUN-690022------mod-------       
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
 
FUNCTION i120_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("srd04,srd051,srd05",TRUE)   #No.FUN-870041
  END IF
END FUNCTION
 
FUNCTION i120_set_no_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
    CALL cl_set_comp_entry("srd04,srd051,srd05",FALSE)   #No.FUN-870041
  END IF
END FUNCTION
 
FUNCTION i120_set_entry_b(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
   CALL cl_set_comp_entry("srd01e",NOT cl_null(g_srd[l_ac].srd01d))
   CALL cl_set_comp_entry("srd02e",NOT cl_null(g_srd[l_ac].srd02d))
   CALL cl_set_comp_entry("srd03e",NOT cl_null(g_srd[l_ac].srd03d))
   CALL cl_set_comp_entry("srd04e",NOT cl_null(g_srd[l_ac].srd04d))
   CALL cl_set_comp_entry("srd05e",NOT cl_null(g_srd[l_ac].srd05d))
   CALL cl_set_comp_entry("srd06e",NOT cl_null(g_srd[l_ac].srd06d))
                                               
   CALL cl_set_comp_entry("Edit8",NOT cl_null(g_srd[l_ac].Edit7))
   CALL cl_set_comp_entry("srd29e",NOT cl_null(g_srd[l_ac].srd29d))
   CALL cl_set_comp_entry("srd30e",NOT cl_null(g_srd[l_ac].srd30d))
   CALL cl_set_comp_entry("srd31e",NOT cl_null(g_srd[l_ac].srd31d))
   CALL cl_set_comp_entry("srd32e",NOT cl_null(g_srd[l_ac].srd32d))
   CALL cl_set_comp_entry("srd33e",NOT cl_null(g_srd[l_ac].srd33d))
   CALL cl_set_comp_entry("srd34e",NOT cl_null(g_srd[l_ac].srd34d))
   CALL cl_set_comp_entry("Edit10",NOT cl_null(g_srd[l_ac].Edit9))
   CALL cl_set_comp_entry("srd36e",NOT cl_null(g_srd[l_ac].srd36d))
   CALL cl_set_comp_entry("srd37e",NOT cl_null(g_srd[l_ac].srd37d))
   CALL cl_set_comp_entry("srd38e",NOT cl_null(g_srd[l_ac].srd38d))
   CALL cl_set_comp_entry("srd39e",NOT cl_null(g_srd[l_ac].srd39d))
   CALL cl_set_comp_entry("srd40e",NOT cl_null(g_srd[l_ac].srd40d))
   CALL cl_set_comp_entry("srd41e",NOT cl_null(g_srd[l_ac].srd40d))
   CALL cl_set_comp_entry("Edit12",NOT cl_null(g_srd[l_ac].Edit11))
END FUNCTION
 
FUNCTION i120_gendetail()
  DEFINE l_week  LIKE type_file.num5         #No.FUN-680130 SMALLINT
  DEFINE l_dt    LIKE type_file.dat          #No.FUN-680130 DATE
  DEFINE l_str   STRING 
  
  LET l_str=g_srd01,'/',g_srd02,'/1'
  LET l_dt=DATE(l_str)
  LET l_week=WEEKDAY(l_dt)
 
  CASE l_week
     WHEN "1" CALL i120_setweek1() RETURNING l_week
     WHEN "2" CALL i120_setweek2() RETURNING l_week
     WHEN "3" CALL i120_setweek3() RETURNING l_week
     WHEN "4" CALL i120_setweek4() RETURNING l_week
     WHEN "5" CALL i120_setweek5() RETURNING l_week
     WHEN "6" CALL i120_setweek6() RETURNING l_week
     WHEN "0" CALL i120_setweek7() RETURNING l_week
  END CASE
  CALL i120_setsrd08(l_week)
  DISPLAY BY NAME g_srd[l_ac].*
END FUNCTION
 
FUNCTION i120_setsrd08(p_day)
  DEFINE p_day        LIKE type_file.num5          #No.FUN-680130 SMALLINT
  
  LET g_srd[l_ac].srd08d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd09d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd10d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd11d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd12d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd13d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].Edit3=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd15d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd16d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd17d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd18d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd19d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd20d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].Edit5=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd22d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd23d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd24d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd25d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd26d=p_day
  LET p_day=p_day+1
  LET g_srd[l_ac].srd27d=p_day
  
  LET g_srd[l_ac].srd08e=0
  LET g_srd[l_ac].srd09e=0
  LET g_srd[l_ac].srd10e=0
  LET g_srd[l_ac].srd11e=0
  LET g_srd[l_ac].srd12e=0
  LET g_srd[l_ac].srd13e=0
  LET g_srd[l_ac].Edit4=0
  LET g_srd[l_ac].srd15e=0
  LET g_srd[l_ac].srd16e=0
  LET g_srd[l_ac].srd17e=0
  LET g_srd[l_ac].srd18e=0
  LET g_srd[l_ac].srd19e=0
  LET g_srd[l_ac].srd20e=0
  LET g_srd[l_ac].Edit6=0
  LET g_srd[l_ac].srd22e=0
  LET g_srd[l_ac].srd23e=0
  LET g_srd[l_ac].srd24e=0
  LET g_srd[l_ac].srd25e=0
  LET g_srd[l_ac].srd26e=0
  LET g_srd[l_ac].srd27e=0
 
  LET p_day=p_day+1
  
  IF p_day<=31 THEN
     IF i120_setnextday(p_day) THEN
        LET g_srd[l_ac].Edit7=p_day
        LET g_srd[l_ac].Edit8=0
     ELSE
        RETURN
     END IF
  END IF
  LET p_day=p_day+1
 
  IF p_day<=31 THEN
     IF i120_setnextday(p_day) THEN
        LET g_srd[l_ac].srd29d=p_day
        LET g_srd[l_ac].srd29e=0
     ELSE
        RETURN
     END IF
  END IF
  LET p_day=p_day+1
 
  IF p_day<=31 THEN
     IF i120_setnextday(p_day) THEN
        LET g_srd[l_ac].srd30d=p_day
        LET g_srd[l_ac].srd30e=0
     ELSE
        RETURN
     END IF
  END IF
  LET p_day=p_day+1
 
  IF p_day<=31 THEN
     IF i120_setnextday(p_day) THEN
        LET g_srd[l_ac].srd31d=p_day
        LET g_srd[l_ac].srd31e=0
     ELSE
        RETURN
     END IF
  END IF
  LET p_day=p_day+1
 
  IF p_day<=31 THEN
     IF i120_setnextday(p_day) THEN
        LET g_srd[l_ac].srd32d=p_day
        LET g_srd[l_ac].srd32e=0
     ELSE
        RETURN
     END IF
  END IF
  LET p_day=p_day+1
 
  IF p_day<=31 THEN
     IF i120_setnextday(p_day) THEN
        LET g_srd[l_ac].srd33d=p_day
        LET g_srd[l_ac].srd33e=0
     ELSE
        RETURN
     END IF
  END IF
  LET p_day=p_day+1
 
  IF p_day<=31 THEN
     IF i120_setnextday(p_day) THEN
        LET g_srd[l_ac].srd34d=p_day
        LET g_srd[l_ac].srd34e=0
     ELSE
        RETURN
     END IF
  END IF
  LET p_day=p_day+1
 
  IF p_day<=31 THEN
     IF i120_setnextday(p_day) THEN
        LET g_srd[l_ac].Edit9=p_day
        LET g_srd[l_ac].Edit10=0
     ELSE
        RETURN
     END IF
  END IF
  LET p_day=p_day+1
 
  IF p_day<=31 THEN
     IF i120_setnextday(p_day) THEN
        LET g_srd[l_ac].srd36d=p_day
        LET g_srd[l_ac].srd36e=0
     ELSE
        RETURN   
     END IF
  END IF
  LET p_day=p_day+1
 
  IF p_day<=31 THEN
     IF i120_setnextday(p_day) THEN
        LET g_srd[l_ac].srd37d=p_day
        LET g_srd[l_ac].srd37e=0
     ELSE
        RETURN   
     END IF
  END IF
  LET p_day=p_day+1
 
  IF p_day<=31 THEN
     IF i120_setnextday(p_day) THEN
        LET g_srd[l_ac].srd38d=p_day
        LET g_srd[l_ac].srd38e=0
     ELSE
        RETURN   
     END IF
  END IF
  LET p_day=p_day+1
 
  IF p_day<=31 THEN
     IF i120_setnextday(p_day) THEN
        LET g_srd[l_ac].srd39d=p_day
        LET g_srd[l_ac].srd39e=0
     ELSE
        RETURN   
     END IF
  END IF
  LET p_day=p_day+1
 
  IF p_day<=31 THEN
     IF i120_setnextday(p_day) THEN
        LET g_srd[l_ac].srd40d=p_day
        LET g_srd[l_ac].srd40e=0
     ELSE
        RETURN   
     END IF
  END IF
  LET p_day=p_day+1
 
  IF p_day<=31 THEN
     IF i120_setnextday(p_day) THEN
        LET g_srd[l_ac].srd41d=p_day
        LET g_srd[l_ac].srd41e=0
     ELSE
        RETURN   
     END IF
  END IF
  LET p_day=p_day+1
 
  IF p_day<=31 THEN
     IF i120_setnextday(p_day) THEN
        LET g_srd[l_ac].Edit11=p_day
        LET g_srd[l_ac].Edit12=0
     ELSE
        RETURN   
     END IF
  END IF
  
END FUNCTION
 
FUNCTION i120_setnextday(p_day)
  DEFINE p_day,l_result LIKE type_file.num5        #No.FUN-680130 SMALLINT
  DEFINE l_date         LIKE type_file.dat         #No.FUN-680130 DATE
  DEFINE l_str,l_tmp    STRING 
  
  LET l_tmp=g_srd01,'/',g_srd02,'/'
  LET l_result=FALSE
  LET l_str=l_tmp,p_day
  LET l_date=DATE(l_str)
  IF NOT (l_date IS NULL) THEN
     LET l_result=TRUE
  END IF
  RETURN l_result
END FUNCTION
 
FUNCTION i120_setweek1()
  LET g_srd[l_ac].srd01d= 1
  LET g_srd[l_ac].srd02d= 2
  LET g_srd[l_ac].srd03d= 3
  LET g_srd[l_ac].srd04d= 4
  LET g_srd[l_ac].srd05d= 5
  LET g_srd[l_ac].srd06d= 6
  LET g_srd[l_ac].Edit1= 7   
  LET g_srd[l_ac].srd01e= 0
  LET g_srd[l_ac].srd02e= 0
  LET g_srd[l_ac].srd03e= 0
  LET g_srd[l_ac].srd04e= 0
  LET g_srd[l_ac].srd05e= 0
  LET g_srd[l_ac].srd06e= 0
  LET g_srd[l_ac].Edit2= 0
 
  RETURN 8
END FUNCTION  
 
FUNCTION i120_setweek2()
  LET g_srd[l_ac].srd02d= 1
  LET g_srd[l_ac].srd03d= 2
  LET g_srd[l_ac].srd04d= 3
  LET g_srd[l_ac].srd05d= 4
  LET g_srd[l_ac].srd06d= 5
  LET g_srd[l_ac].Edit1= 6
  LET g_srd[l_ac].srd02e= 0
  LET g_srd[l_ac].srd03e= 0
  LET g_srd[l_ac].srd04e= 0
  LET g_srd[l_ac].srd05e= 0
  LET g_srd[l_ac].srd06e= 0
  LET g_srd[l_ac].Edit2= 0
  RETURN 7
END FUNCTION  
 
FUNCTION i120_setweek3()
  LET g_srd[l_ac].srd03d= 1
  LET g_srd[l_ac].srd04d= 2
  LET g_srd[l_ac].srd05d= 3
  LET g_srd[l_ac].srd06d= 4
  LET g_srd[l_ac].Edit1= 5
  LET g_srd[l_ac].srd03e= 0
  LET g_srd[l_ac].srd04e= 0
  LET g_srd[l_ac].srd05e= 0
  LET g_srd[l_ac].srd06e= 0
  LET g_srd[l_ac].Edit2= 0
  RETURN 6                
END FUNCTION  
 
FUNCTION i120_setweek4()
  LET g_srd[l_ac].srd04d= 1
  LET g_srd[l_ac].srd05d= 2
  LET g_srd[l_ac].srd06d= 3
  LET g_srd[l_ac].Edit1= 4
  LET g_srd[l_ac].srd04e= 0
  LET g_srd[l_ac].srd05e= 0
  LET g_srd[l_ac].srd06e= 0
  LET g_srd[l_ac].Edit2= 0
  RETURN 5
END FUNCTION  
 
FUNCTION i120_setweek5()
  LET g_srd[l_ac].srd05d= 1
  LET g_srd[l_ac].srd06d= 2
  LET g_srd[l_ac].Edit1= 3
  LET g_srd[l_ac].srd05e= 0
  LET g_srd[l_ac].srd06e= 0
  LET g_srd[l_ac].Edit2= 0
  RETURN 4
END FUNCTION  
 
FUNCTION i120_setweek6()
  LET g_srd[l_ac].srd06d= 1
  LET g_srd[l_ac].Edit1= 2
  LET g_srd[l_ac].srd06e= 0
  LET g_srd[l_ac].Edit2= 0
  RETURN 3
END FUNCTION  
 
FUNCTION i120_setweek7()
  LET g_srd[l_ac].Edit1= 1
  LET g_srd[l_ac].Edit2= 0
  RETURN 2
END FUNCTION  
 
FUNCTION i120_inssre()
  IF NOT cl_null(g_srd[l_ac].srd01d) THEN CALL i120_getinssql(g_srd[l_ac].srd01d,g_srd[l_ac].srd01e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd02d) THEN CALL i120_getinssql(g_srd[l_ac].srd02d,g_srd[l_ac].srd02e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd03d) THEN CALL i120_getinssql(g_srd[l_ac].srd03d,g_srd[l_ac].srd03e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd04d) THEN CALL i120_getinssql(g_srd[l_ac].srd04d,g_srd[l_ac].srd04e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd05d) THEN CALL i120_getinssql(g_srd[l_ac].srd05d,g_srd[l_ac].srd05e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd06d) THEN CALL i120_getinssql(g_srd[l_ac].srd06d,g_srd[l_ac].srd06e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].Edit1) THEN CALL i120_getinssql(g_srd[l_ac].Edit1,g_srd[l_ac].Edit2) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd08d) THEN CALL i120_getinssql(g_srd[l_ac].srd08d,g_srd[l_ac].srd08e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd09d) THEN CALL i120_getinssql(g_srd[l_ac].srd09d,g_srd[l_ac].srd09e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd10d) THEN CALL i120_getinssql(g_srd[l_ac].srd10d,g_srd[l_ac].srd10e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd11d) THEN CALL i120_getinssql(g_srd[l_ac].srd11d,g_srd[l_ac].srd11e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd12d) THEN CALL i120_getinssql(g_srd[l_ac].srd12d,g_srd[l_ac].srd12e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd13d) THEN CALL i120_getinssql(g_srd[l_ac].srd13d,g_srd[l_ac].srd13e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].Edit3) THEN CALL i120_getinssql(g_srd[l_ac].Edit3,g_srd[l_ac].Edit4) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd15d) THEN CALL i120_getinssql(g_srd[l_ac].srd15d,g_srd[l_ac].srd15e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd16d) THEN CALL i120_getinssql(g_srd[l_ac].srd16d,g_srd[l_ac].srd16e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd17d) THEN CALL i120_getinssql(g_srd[l_ac].srd17d,g_srd[l_ac].srd17e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd18d) THEN CALL i120_getinssql(g_srd[l_ac].srd18d,g_srd[l_ac].srd18e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd19d) THEN CALL i120_getinssql(g_srd[l_ac].srd19d,g_srd[l_ac].srd19e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd20d) THEN CALL i120_getinssql(g_srd[l_ac].srd20d,g_srd[l_ac].srd20e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].Edit5) THEN CALL i120_getinssql(g_srd[l_ac].Edit5,g_srd[l_ac].Edit6) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd22d) THEN CALL i120_getinssql(g_srd[l_ac].srd22d,g_srd[l_ac].srd22e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd23d) THEN CALL i120_getinssql(g_srd[l_ac].srd23d,g_srd[l_ac].srd23e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd24d) THEN CALL i120_getinssql(g_srd[l_ac].srd24d,g_srd[l_ac].srd24e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd25d) THEN CALL i120_getinssql(g_srd[l_ac].srd25d,g_srd[l_ac].srd25e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd26d) THEN CALL i120_getinssql(g_srd[l_ac].srd26d,g_srd[l_ac].srd26e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd27d) THEN CALL i120_getinssql(g_srd[l_ac].srd27d,g_srd[l_ac].srd27e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].Edit7) THEN CALL i120_getinssql(g_srd[l_ac].Edit7,g_srd[l_ac].Edit8) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd29d) THEN CALL i120_getinssql(g_srd[l_ac].srd29d,g_srd[l_ac].srd29e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd30d) THEN CALL i120_getinssql(g_srd[l_ac].srd30d,g_srd[l_ac].srd30e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd31d) THEN CALL i120_getinssql(g_srd[l_ac].srd31d,g_srd[l_ac].srd31e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd32d) THEN CALL i120_getinssql(g_srd[l_ac].srd32d,g_srd[l_ac].srd32e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd33d) THEN CALL i120_getinssql(g_srd[l_ac].srd33d,g_srd[l_ac].srd33e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd34d) THEN CALL i120_getinssql(g_srd[l_ac].srd34d,g_srd[l_ac].srd34e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].Edit9) THEN CALL i120_getinssql(g_srd[l_ac].Edit9,g_srd[l_ac].Edit10) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd36d) THEN CALL i120_getinssql(g_srd[l_ac].srd36d,g_srd[l_ac].srd36e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd37d) THEN CALL i120_getinssql(g_srd[l_ac].srd37d,g_srd[l_ac].srd37e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd38d) THEN CALL i120_getinssql(g_srd[l_ac].srd38d,g_srd[l_ac].srd38e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd39d) THEN CALL i120_getinssql(g_srd[l_ac].srd39d,g_srd[l_ac].srd39e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd40d) THEN CALL i120_getinssql(g_srd[l_ac].srd40d,g_srd[l_ac].srd40e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd41d) THEN CALL i120_getinssql(g_srd[l_ac].srd41d,g_srd[l_ac].srd41e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].Edit11) THEN CALL i120_getinssql(g_srd[l_ac].Edit11,g_srd[l_ac].Edit12) END IF
  IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION i120_getinssql(p_sre06,p_sre07)
DEFINE p_sre06 LIKE srd_file.srd01d,
       p_sre07 LIKE srd_file.srd01e,
       l_str   STRING, 
       l_date  LIKE type_file.dat           #No.FUN-680130 DATE
 
  LET l_str=g_srd01,'/',g_srd02,'/',p_sre06
  LET l_date=DATE(l_str)
  IF cl_null(p_sre07) THEN
     LET p_sre07=0
  END IF
  INSERT INTO sre_file (sre01,sre02,sre03,sre04,sre05,sre051,sre06,   #No.FUN-870041
                        sre07,sre08,sre09,sre10,sre11,sre12,
                        sreplant,srelegal) #FUN-980008 add
                VALUES (g_srd01,g_srd02,g_srd03,g_srd[l_ac].srd04,
                        g_srd[l_ac].srd05,g_srd[l_ac].srd051,   #No.FUN-870041
                        l_date,p_sre07,null,0,0,0,'N',
                        g_plant,g_legal)   #FUN-980008 add
  IF SQLCA.sqlcode THEN
    LET g_success='N'
#   CALL cl_err('ins sre',SQLCA.sqlcode,0)   #No.FUN-660138
    CALL cl_err3("ins","sre_file",g_srd01,g_srd02,SQLCA.sqlcode,"","ins sre",1)  #No.FUN-660138
    RETURN
  END IF
END FUNCTION
 
FUNCTION i120_updatesre()
  
  IF NOT cl_null(g_srd[l_ac].srd01d) THEN CALL i120_updatesre1(g_srd[l_ac].srd01d,g_srd[l_ac].srd01e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd02d) THEN CALL i120_updatesre1(g_srd[l_ac].srd02d,g_srd[l_ac].srd02e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd03d) THEN CALL i120_updatesre1(g_srd[l_ac].srd03d,g_srd[l_ac].srd03e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd04d) THEN CALL i120_updatesre1(g_srd[l_ac].srd04d,g_srd[l_ac].srd04e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd05d) THEN CALL i120_updatesre1(g_srd[l_ac].srd05d,g_srd[l_ac].srd05e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd06d) THEN CALL i120_updatesre1(g_srd[l_ac].srd06d,g_srd[l_ac].srd06e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].Edit1) THEN CALL i120_updatesre1(g_srd[l_ac].Edit1,g_srd[l_ac].Edit2) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd08d) THEN CALL i120_updatesre1(g_srd[l_ac].srd08d,g_srd[l_ac].srd08e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd09d) THEN CALL i120_updatesre1(g_srd[l_ac].srd09d,g_srd[l_ac].srd09e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd10d) THEN CALL i120_updatesre1(g_srd[l_ac].srd10d,g_srd[l_ac].srd10e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd11d) THEN CALL i120_updatesre1(g_srd[l_ac].srd11d,g_srd[l_ac].srd11e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd12d) THEN CALL i120_updatesre1(g_srd[l_ac].srd12d,g_srd[l_ac].srd12e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd13d) THEN CALL i120_updatesre1(g_srd[l_ac].srd13d,g_srd[l_ac].srd13e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].Edit3) THEN CALL i120_updatesre1(g_srd[l_ac].Edit3,g_srd[l_ac].Edit4) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd15d) THEN CALL i120_updatesre1(g_srd[l_ac].srd15d,g_srd[l_ac].srd15e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd16d) THEN CALL i120_updatesre1(g_srd[l_ac].srd16d,g_srd[l_ac].srd16e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd17d) THEN CALL i120_updatesre1(g_srd[l_ac].srd17d,g_srd[l_ac].srd17e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd18d) THEN CALL i120_updatesre1(g_srd[l_ac].srd18d,g_srd[l_ac].srd18e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd19d) THEN CALL i120_updatesre1(g_srd[l_ac].srd19d,g_srd[l_ac].srd19e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd20d) THEN CALL i120_updatesre1(g_srd[l_ac].srd20d,g_srd[l_ac].srd20e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].Edit5) THEN CALL i120_updatesre1(g_srd[l_ac].Edit5,g_srd[l_ac].Edit6) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd22d) THEN CALL i120_updatesre1(g_srd[l_ac].srd22d,g_srd[l_ac].srd22e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd23d) THEN CALL i120_updatesre1(g_srd[l_ac].srd23d,g_srd[l_ac].srd23e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd24d) THEN CALL i120_updatesre1(g_srd[l_ac].srd24d,g_srd[l_ac].srd24e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd25d) THEN CALL i120_updatesre1(g_srd[l_ac].srd25d,g_srd[l_ac].srd25e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd26d) THEN CALL i120_updatesre1(g_srd[l_ac].srd26d,g_srd[l_ac].srd26e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd27d) THEN CALL i120_updatesre1(g_srd[l_ac].srd27d,g_srd[l_ac].srd27e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].Edit7) THEN CALL i120_updatesre1(g_srd[l_ac].Edit7,g_srd[l_ac].Edit8) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd29d) THEN CALL i120_updatesre1(g_srd[l_ac].srd29d,g_srd[l_ac].srd29e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd30d) THEN CALL i120_updatesre1(g_srd[l_ac].srd30d,g_srd[l_ac].srd30e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd31d) THEN CALL i120_updatesre1(g_srd[l_ac].srd31d,g_srd[l_ac].srd31e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd32d) THEN CALL i120_updatesre1(g_srd[l_ac].srd32d,g_srd[l_ac].srd32e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd33d) THEN CALL i120_updatesre1(g_srd[l_ac].srd33d,g_srd[l_ac].srd33e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd34d) THEN CALL i120_updatesre1(g_srd[l_ac].srd34d,g_srd[l_ac].srd34e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].Edit9) THEN CALL i120_updatesre1(g_srd[l_ac].Edit9,g_srd[l_ac].Edit10) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd36d) THEN CALL i120_updatesre1(g_srd[l_ac].srd36d,g_srd[l_ac].srd36e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd37d) THEN CALL i120_updatesre1(g_srd[l_ac].srd37d,g_srd[l_ac].srd37e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd38d) THEN CALL i120_updatesre1(g_srd[l_ac].srd38d,g_srd[l_ac].srd38e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd39d) THEN CALL i120_updatesre1(g_srd[l_ac].srd39d,g_srd[l_ac].srd39e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd40d) THEN CALL i120_updatesre1(g_srd[l_ac].srd40d,g_srd[l_ac].srd40e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].srd41d) THEN CALL i120_updatesre1(g_srd[l_ac].srd41d,g_srd[l_ac].srd41e) END IF
  IF g_success='N' THEN RETURN END IF
  IF NOT cl_null(g_srd[l_ac].Edit11) THEN CALL i120_updatesre1(g_srd[l_ac].Edit11,g_srd[l_ac].Edit12) END IF
  IF g_success='N' THEN RETURN END IF
END FUNCTION
 
FUNCTION i120_updatesre1(p_sre06,p_sre07)
DEFINE p_sre06 LIKE srd_file.srd01d,
       p_sre07 LIKE srd_file.srd01e,
       l_str   STRING, 
       l_date  LIKE type_file.dat            #No.FUN-680130 DATE
 
   LET l_str=g_srd01,'/',g_srd02,'/',p_sre06
   LET l_date=DATE(l_str)
   IF NOT (l_date IS NULL) THEN
      UPDATE sre_file SET sre07=p_sre07
                    WHERE sre01=g_srd01
                      AND sre02=g_srd02
                      AND sre03=g_srd03
                      AND sre04=g_srd[l_ac].srd04
                      AND sre05=g_srd[l_ac].srd05
                      AND sre051=g_srd[l_ac].srd051   #No.FUN-870041
                      AND sre06=l_date
      IF (SQLCA.sqlcode) OR (SQLCA.sqlerrd[3]=0) THEN
         CALL cl_err('upd sre','9050',0)
         LET g_success='N'
      END IF
   END IF
END FUNCTION
 
FUNCTION i120_page03()
DEFINE l_yy,l_mm LIKE type_file.num5           #No.FUN-680130 SMALLINT
DEFINE l_str     STRING 
 
  IF cl_null(g_srd01) OR cl_null(g_srd02) THEN
     RETURN
  END IF
 
  IF (g_show_day IS NULL) OR (g_show_day='1899/12/31') THEN
    LET l_yy=g_srd01
    LET l_mm=g_srd02
    LET l_str=l_yy,'/',l_mm,'/',DAY(TODAY)
    LET g_show_day=DATE(l_str) USING "YYYY-MM-DD"
    CALL i120_show_sre()
  ELSE
    LET l_str=g_srd01,'/',g_srd02,'/',DAY(g_show_day)
    LET g_show_day=DATE(l_str) USING "YYYY-MM-DD"
    CALL i120_show_sre()
  END IF
END FUNCTION
 
FUNCTION i120_show_sre()
DEFINE l_sql STRING 
DEFINE l_i   LIKE type_file.num10           #No.FUN-680130 INTEGER 
DEFINE l_yy,l_mm  LIKE type_file.num5       #No.FUN-680130 SMALLINT
                         
  IF g_show_day IS NULL THEN RETURN END IF
  LET l_yy=YEAR(g_show_day)
  LET l_mm=MONTH(g_show_day)
  LET l_sql="SELECT sre04,'','','',sre05,'',sre08,sre051,",  #No.FUN-870097 add sre051
            "sre07,sre09,sre10,sre11,sre12 FROM",
            " sre_file where sre01=",l_yy," AND sre02=",l_mm,
            " AND sre03='",g_srd03,"' AND sre07<>0 AND sre07 IS NOT NULL",
            " AND sre06='",g_show_day,"'",
            " ORDER BY sre03,sre05,sre08,sre04"
  PREPARE i120_show_sre_c_pre FROM l_sql
  DECLARE i120_show_sre_c CURSOR FOR i120_show_sre_c_pre
  CALL g_sre.clear()
  LET l_i=1
  FOREACH i120_show_sre_c INTO g_sre[l_i].*
    IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      EXIT FOREACH
    END IF
    LET g_sre[l_i].ima02_b=''
    LET g_sre[l_i].ima021_b=''
    LET g_sre[l_i].ima55_b=''
    LET g_sre[l_i].ecg02_b=''
    SELECT ima02,ima021,ima55 INTO g_sre[l_i].ima02_b,
                                   g_sre[l_i].ima021_b,
                                   g_sre[l_i].ima55_b
       FROM ima_file WHERE ima01=g_sre[l_i].sre04
    SELECT ecg02 INTO g_sre[l_i].ecg02_b FROM ecg_file 
                          WHERE ecg01=g_sre[l_i].sre05   
    LET l_i=l_i+1
  END FOREACH
  CALL g_sre.deleteElement(l_i)
  
  LET g_rec_b1=l_i-1
  DISPLAY g_rec_b1 TO FORMONLY.cn3
  DISPLAY DAY(g_show_day) TO FORMONLY.day
 
  DISPLAY ARRAY g_sre TO s_sre.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
 
    #MOD-860081------add-----str---
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
     
     ON ACTION about         
        CALL cl_about()      
     
     ON ACTION controlg      
        CALL cl_cmdask()     
     
     ON ACTION help          
        CALL cl_show_help()  
    #MOD-860081------add-----end---
 
  END DISPLAY
  
END FUNCTION                                        
                                                          
FUNCTION i120_prev_day()
DEFINE l_dd LIKE type_file.num5        #No.FUN-680130 SMALLINT
DEFINE l_str  STRING
 
  IF cl_null(g_srd01) OR cl_null(g_srd02) THEN
     CALL g_sre.clear()
     LET g_rec_b1=0
     DISPLAY ARRAY g_sre TO s_sre.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
        BEFORE DISPLAY
           EXIT DISPLAY
 
    #MOD-860081------add-----str---
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
     
     ON ACTION about         
        CALL cl_about()      
     
     ON ACTION controlg      
        CALL cl_cmdask()     
     
     ON ACTION help          
        CALL cl_show_help()  
    #MOD-860081------add-----end---
 
     END DISPLAY
     RETURN
  END IF
  IF (g_show_day IS NULL) OR (g_show_day='1899/12/31') THEN
     LET l_dd=1
  END IF
  LET g_show_day=g_show_day-1
  IF (YEAR(g_show_day)<>g_srd01) OR (MONTH(g_show_day)<>g_srd02) THEN
    #LET g_show_day=MDY(g_srd02+1,1,g_srd01)-1
     LET g_show_day=i120_GETLASTDAY(MDY(g_srd02,1,g_srd01))
  ELSE
     LET l_dd=DAY(g_show_day)
     LET l_str=g_srd01,'/',g_srd02,'/',l_dd
     LET g_show_day=DATE(l_str) USING 'YYYY-MM-DD'
  END IF   
  CALL i120_show_sre()
END FUNCTION
                                                          
FUNCTION i120_next_day()
DEFINE l_dd LIKE type_file.num5           #No.FUN-680130 SMALLINT
DEFINE l_str STRING 
  IF cl_null(g_srd01) OR cl_null(g_srd02) THEN
     CALL g_sre.clear()
     LET g_rec_b1=0
     DISPLAY ARRAY g_sre TO s_sre.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
        BEFORE DISPLAY
           EXIT DISPLAY
 
    #MOD-860081------add-----str---
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
     
     ON ACTION about         
        CALL cl_about()      
     
     ON ACTION controlg      
        CALL cl_cmdask()     
     
     ON ACTION help          
        CALL cl_show_help()  
    #MOD-860081------add-----end---
 
     END DISPLAY
     RETURN
  END IF
  LET g_show_day=g_show_day+1
  IF (g_show_day IS NULL) OR (g_show_day=0) OR
     (YEAR(g_show_day)<>g_srd01) OR (MONTH(g_show_day)<>g_srd02) THEN
     LET l_dd=1
  ELSE
     LET l_dd=DAY(g_show_day)
  END IF
  LET l_str=g_srd01,'/',g_srd02,'/',l_dd
  LET g_show_day=DATE(l_str) USING 'YYYY-MM-DD'
  CALL i120_show_sre()
END FUNCTION
 
FUNCTION i120_draw()
DEFINE l_sql STRING 
DEFINE id    LIKE type_file.num10        #No.FUN-680130 INTEGER
DEFINE l_qty LIKE sre_file.sre07
DEFINE l_sra04 LIKE sra_file.sra04,
       l_sre04 LIKE sre_file.sre04,
       l_sre06 LIKE sre_file.sre06,
       l_sre07 LIKE sre_file.sre07,
       l_sre08 LIKE sre_file.sre08
 
  CALL drawselect("c01")
  CALL drawClear()
  IF cl_null(g_srd01) OR cl_null(g_srd02) THEN
     RETURN
  END IF
 
  LET g_draw_day=MDY(g_srd02,1,g_srd01)
  
  LET g_draw_x=0   #起始x軸位置
  LET g_draw_y=45  #起始y軸位置
  LET g_draw_dx=0  #起始dx軸位置
  LET g_draw_dy=10 #起始dy軸位置
  LET g_draw_width=15 #每條長條圖寬度
  LET g_draw_multiple=35 #時間的放大倍數(一個小時,在長條圖上的刻度比例)
  LET g_draw_start_y=100      #起始y軸位置
  CALL i120_draw_axis()
  WHILE NOT (g_draw_day IS NULL)
    IF MONTH(g_draw_day)<>g_srd02 THEN EXIT WHILE END IF
    CALL DrawFillColor("black")
    LET id=DrawText(60,g_draw_y+5,DAY(g_draw_day)) #日期
 
    LET g_draw_x=g_draw_start_y #起始x軸位置
    LET g_draw_dx=0
    LET l_sql="SELECT sre04,SUM(sre07) FROM sre_file",
              " WHERE sre01=",g_srd01," AND sre02=",g_srd02,
              " AND sre03='",g_srd03,"' AND sre06='",g_draw_day,"'",
              " GROUP BY sre08,sre01,sre02,sre03,sre04,sre06", #CHI-6A0049
              " ORDER BY sre08,sre04,sre06,sre01,sre02,sre03"  #CHI-6A0049
    PREPARE i120_draw_c_pre FROM l_sql
    DECLARE i120_draw_c CURSOR FOR i120_draw_c_pre
    FOREACH i120_draw_c INTO l_sre04,l_sre07
      SELECT sra04 INTO l_sra04 FROM sra_file WHERE sra01=g_srd03
                                                AND sra02=l_sre04 
                                                AND sraacti='Y'
      IF (SQLCA.sqlcode) OR (l_sra04<=0) THEN
        #CALL cl_err('get sra04 err:',"asr-010",1)
        #CALL drawClear()
        #EXIT WHILE
        CONTINUE FOREACH
      END IF
      LET l_qty=l_sre07/l_sra04
      CALL i120_draw_product(l_sre04,l_qty)
      LET g_draw_x=g_draw_x+g_draw_dx
    
    END FOREACH
    
    
    CALL i120_draw_changeline()
    CALL i120_draw_maintain()
    
    LET g_draw_x=g_draw_start_y #起始x軸位置
    LET g_draw_dx=0
    CALL i120_draw_fact()
    CALL i120_draw_standard()
      
    CLOSE i120_draw_c
    LET g_draw_y=g_draw_y+g_draw_width
    LET g_draw_day=g_draw_day+1
      
  END WHILE
  
  CALL i120_draw_max()
END FUNCTION
 
FUNCTION i120_draw_product(l_sre04,l_qty) #生產計畫
DEFINE id LIKE type_file.num10         #No.FUN-680130 INTEGER
DEFINE l_str   STRING 
DEFINE l_sre04 LIKE sre_file.sre04,
       l_qty   LIKE sre_file.sre07
  CALL DrawFillColor("blue")
  LET g_draw_dx=l_qty*g_draw_multiple
  LET id=DrawRectangle(g_draw_x,g_draw_y,g_draw_dx,g_draw_dy) #(Y軸起點,X軸起點,線高度,線寬度)
  LET l_str=l_qty
  LET l_str=l_str.trim()
  LET l_str=l_sre04," : ",l_str
  CALL drawSetComment(id,l_str)
 
END FUNCTION
 
FUNCTION i120_draw_changeline() #換線時間
DEFINE l_src03 LIKE src_file.src03,
       l_src04,l_src04_t LIKE src_file.src04
DEFINE l_str,l_tmp  STRING 
DEFINE id,l_i,l_j LIKE type_file.num10           #No.FUN-680130 INTEGER
DEFINE l_sre DYNAMIC ARRAY OF RECORD
               sre04 LIKE sre_file.sre04,
               sre08 LIKE sre_file.sre08
             END RECORD
DEFINE l_ima131a,l_ima131b LIKE ima_file.ima131
 
   LET l_i=1
   DECLARE changeline_cur CURSOR FOR SELECT sre04,sre08 FROM sre_file
                                       WHERE sre03=g_srd03
                                         AND sre06=g_draw_day
                                         AND sre08 IS NOT NULL
                                         ORDER BY sre08
   FOREACH changeline_cur INTO l_sre[l_i].sre04,l_sre[l_i].sre08
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET l_i=l_i+1
   END FOREACH
 
   LET l_str=''
   LET l_src04_t=0
   FOR l_j=1 TO l_i-1
      IF cl_null(l_sre[l_j].sre04) OR cl_null(l_sre[l_j].sre08) THEN
         CONTINUE FOR
      END IF
      IF NOT (l_i-1>l_j) THEN #沒有下一順序的料號
         EXIT FOR
      ELSE
         SELECT src04 INTO l_src04 FROM src_file
                                       WHERE src01=g_srd03
                                         AND src02=l_sre[l_j].sre04   #本順序料號
                                         AND src03=l_sre[l_j+1].sre04 #下一順序料號
                                         AND srcacti='Y'
         IF NOT SQLCA.sqlcode THEN
            IF l_src04>0 THEN
               LET l_src04=l_src04/60
               LET l_src04_t=l_src04_t+l_src04
               LET l_tmp=l_src04
               LET l_tmp=l_tmp.trim()
               LET l_str=l_str,l_sre[l_j].sre04,"→",l_sre[l_j+1].sre04," : ",l_tmp,"\n"
            END IF
         ELSE  #沒有設定料號的換線時間,找本料號產品別對下一料號產品別的換線時間
            SELECT ima131 INTO l_ima131a FROM ima_file 
                 WHERE ima01=l_sre[l_j].sre04
            IF SQLCA.sqlcode THEN
               LET l_ima131a=NULL
            END IF
            SELECT ima131 INTO l_ima131b FROM ima_file 
                 WHERE ima01=l_sre[l_j+1].sre04
            IF SQLCA.sqlcode THEN
               LET l_ima131b=NULL
            END IF
            IF (NOT cl_null(l_ima131a)) AND (NOT cl_null(l_ima131b)) THEN
 
                SELECT src04 INTO l_src04 FROM src_file
                                       WHERE src01=g_srd03
                                         AND src02=l_ima131a   #本順序料號產品別
                                         AND src03=l_ima131b   #下一順序料號產品別
                                         AND srcacti='Y'
                IF (NOT SQLCA.sqlcode) AND (l_src04>0) THEN
                   LET l_src04=l_src04/60
                   LET l_src04_t=l_src04_t+l_src04
                   LET l_tmp=l_src04
                   LET l_tmp=l_tmp.trim()
                   LET l_str=l_str,l_sre[l_j].sre04,"→",l_sre[l_j+1].sre04," : ",l_tmp,"\n"
                END IF
            END IF
         END IF
      END IF
   END FOR
 
   IF l_src04_t>0 THEN
      CALL DrawFillColor("red")
      LET g_draw_dx=l_src04_t*g_draw_multiple
      LET id=DrawRectangle(g_draw_x,g_draw_y,g_draw_dx,g_draw_dy)
      LET l_str=l_str.trim()
      CALL drawSetComment(id,l_str)
   END IF
END FUNCTION
 
FUNCTION i120_draw_maintain() #維修時間
DEFINE l_str STRING 
DEFINE id    LIKE type_file.num10        #No.FUN-680130 INTEGER
DEFINE l_srb03 LIKE srb_file.srb03,
       l_srb04 LIKE srb_file.srb04,
       l_srb05 LIKE srb_file.srb05,
       l_srb06 LIKE srb_file.srb06
 
  DECLARE i120_draw_maintain_c CURSOR FOR      
     SELECT srb03,srb04,srb05,srb06 FROM srb_file
       WHERE srb01=g_draw_day AND srb02=g_srd03 AND srbacti='Y'
         AND srb05>0 AND srb05 IS NOT NULL
  FOREACH i120_draw_maintain_c INTO l_srb03,l_srb04,l_srb05,l_srb06
    CALL DrawFillColor("yellow")
    LET g_draw_dx=l_srb05*g_draw_multiple
    LET id=DrawRectangle(g_draw_x,g_draw_y,g_draw_dx,g_draw_dy)
    LET l_str=l_srb05
    LET l_str=l_str.trim()
    LET l_str=l_srb06," : ",l_str
    CALL drawSetComment(id,l_str)
  END FOREACH
END FUNCTION
 
FUNCTION i120_draw_fact() #實績(報工時數)
DEFINE id LIKE type_file.num10        #No.FUN-680130 INTEGER
DEFINE l_str STRING 
DEFINE l_srg10 LIKE srg_file.srg10
  
  LET g_draw_y=g_draw_y+g_draw_width     
  LET l_srg10=0
  SELECT SUM(srg10) INTO l_srg10 FROM srg_file,srf_file 
                                WHERE srg01=srf01
                                  AND srf03=g_srd03
                                  AND srf05=g_draw_day
                                  AND srg10<>0
                                  AND srg10 IS NOT NULL
                                  AND srfconf='Y'
  IF l_srg10>0 THEN                     
    CALL DrawFillColor("purple")
    LET l_srg10=l_srg10/60
    LET g_draw_dx=l_srg10*g_draw_multiple
    LET id=DrawRectangle(g_draw_x,g_draw_y,g_draw_dx,g_draw_dy) #(Y軸起點,X軸起點,線高度,線寬度)
    LET l_str=l_srg10
    LET l_str=l_str.trim()
    LET l_str=l_srg10
    CALL drawSetComment(id,l_str)
  END IF
END FUNCTION
 
FUNCTION i120_draw_standard() #日標準產能
DEFINE l_ecn04 LIKE ecn_file.ecn04
DEFINE l_draw_x,l_draw_dy LIKE type_file.num10        #No.FUN-680130 INTEGER
DEFINE l_str,l_sql    STRING 
DEFINE id LIKE type_file.num10                        #No.FUN-680130 INTEGER
    
   LET l_sql="SELECT ecn04 FROM ecn_file",
             " WHERE ecn02='",g_draw_day,"'",
             " ORDER BY ecn03 DESC"
   PREPARE i120_draw_std_pre FROM l_sql
   DECLARE i120_draw_std CURSOR FOR i120_draw_std_pre
   OPEN i120_draw_std
   FETCH i120_draw_std INTO l_ecn04
   CLOSE i120_draw_std
   
   IF (NOT SQLCA.sqlcode) AND (l_ecn04>0) THEN
      CALL DrawFillColor("pink")
      LET l_draw_x=g_draw_start_y+l_ecn04*g_draw_multiple
      LET l_draw_dy=g_draw_dy*2
      LET id=DrawRectangle(l_draw_x-3,g_draw_y-g_draw_width,6,l_draw_dy+5) #(Y軸起點,X軸起點,線高度,線寬度)
      LET l_str=l_ecn04
      LET l_str=l_str.trim()
      CALL drawSetComment(id,l_str)
   END IF
END FUNCTION
 
FUNCTION i120_draw_max() #最大產能
DEFINE id LIKE type_file.num10           #No.FUN-680130 INTEGER
DEFINE l_eci05 LIKE eci_file.eci05,
       l_eci09 LIKE eci_file.eci09,
       l_eca06 LIKE eca_file.eca06
 
  SELECT eca06,eci05,eci09 INTO l_eca06,l_eci05,l_eci09 
     FROM eca_file,eci_file WHERE eca01=eci03 
                              AND eci01=g_srd03
  IF NOT SQLCA.sqlcode THEN
     CASE l_eca06
        WHEN "1" #機器產能
           CALL DrawFillColor("green")
           LET id=DrawRectangle(l_eci05*g_draw_multiple+g_draw_start_y-3,35,6,1000)
        WHEN "2" #人工產能
           CALL DrawFillColor("green")
           LET id=DrawRectangle(l_eci09*g_draw_multiple+g_draw_start_y-3,35,6,1000)
     END CASE
  END IF
END FUNCTION
 
FUNCTION i120_draw_axis() #座標
DEFINE id,l_h LIKE type_file.num10      #NO.FUN-680130 INTEGER
DEFINE l_i LIKE type_file.num5          #No.FUN-680130 SMALLINT
DEFINE l_msg  STRING 
DEFINE l_dist LIKE type_file.num10,     #每個圖例說明的間距     #No.FUN-680130 INTEGER
       l_draw_x LIKE type_file.num10,   #每個圖例說明的x軸位置  #No.FUN-680130 INTEGER
       l_draw_y LIKE type_file.num10    #每個圖例說明的y軸位置  #No.FUN-680130 INTEGER
       
  CALL DrawFillColor("black")
  LET id=DrawRectangle(g_draw_start_y-5,35,2,1000) #(橫軸)
  LET id=DrawRectangle(g_draw_start_y-5,35,870,2)  #(縱軸)
  LET l_h=(g_draw_start_y-5)+g_draw_multiple
  FOR l_i=1 TO 24 #(縱軸刻度)
    CALL DrawFillColor("black")
   #LET id=DrawRectangle(l_h,35,7,6)
    LET id=DrawRectangle(l_h,35,4,4)
    CALL DrawFillColor("black")
    LET id=DrawText(l_h-15,25,l_i)
    LET l_h=l_h+g_draw_multiple
  END FOR
 
  CALL DrawFillColor("black")
  LET id=DrawText((g_draw_start_y-5)/4,950,"(DAY)") #日期
  CALL DrawFillColor("black")
  LET id=DrawText(950,20,"(HR)") #小時
  
  #圖例
  #計畫量
  LET l_dist=60
  LET l_draw_x=(g_draw_start_y-5)/4
  LET l_draw_y=g_draw_y
  CALL DrawFillColor("blue")
  LET id=DrawRectangle(l_draw_x,l_draw_y,20,20)
  
  LET l_draw_y=l_draw_y+l_dist
  CALL cl_getmsg('asr-027',g_lang) RETURNING l_msg
  LET l_msg=l_msg.trim()
  CALL DrawFillColor("black")
  LET id=DrawText(l_draw_x-3,l_draw_y,l_msg)
 
  #換線時間
  LET l_draw_y=l_draw_y+l_dist
  CALL DrawFillColor("red")
  LET id=DrawRectangle(l_draw_x,l_draw_y,20,20)
  
  LET l_draw_y=l_draw_y+l_dist
  CALL cl_getmsg('asr-028',g_lang) RETURNING l_msg
  LET l_msg=l_msg.trim()
  CALL DrawFillColor("black")
  LET id=DrawText(l_draw_x-3,l_draw_y,l_msg)
  
  #維修時間
  LET l_draw_y=l_draw_y+l_dist
  CALL DrawFillColor("yellow")
  LET id=DrawRectangle(l_draw_x,l_draw_y,20,20)
  
  LET l_draw_y=l_draw_y+l_dist
  CALL cl_getmsg('asr-029',g_lang) RETURNING l_msg
  LET l_msg=l_msg.trim()
  CALL DrawFillColor("black")
  LET id=DrawText(l_draw_x-3,l_draw_y,l_msg)
  
  #報工時間
  LET l_draw_y=l_draw_y+l_dist
  CALL DrawFillColor("purple")
  LET id=DrawRectangle(l_draw_x,l_draw_y,20,20)
  
  LET l_draw_y=l_draw_y+l_dist
  CALL cl_getmsg('asr-030',g_lang) RETURNING l_msg
  LET l_msg=l_msg.trim()
  CALL DrawFillColor("black")
  LET id=DrawText(l_draw_x-3,l_draw_y,l_msg)
  
  #標準產能
  LET l_draw_y=l_draw_y+l_dist
  CALL DrawFillColor("pink")
  LET id=DrawRectangle(l_draw_x,l_draw_y,20,20)
  
  LET l_draw_y=l_draw_y+l_dist
  CALL cl_getmsg('asr-031',g_lang) RETURNING l_msg
  LET l_msg=l_msg.trim()
  CALL DrawFillColor("black")
  LET id=DrawText(l_draw_x-3,l_draw_y,l_msg)
 
  #最大產能
  LET l_draw_y=l_draw_y+l_dist
  CALL DrawFillColor("green")
  LET id=DrawRectangle(l_draw_x,l_draw_y,20,20)
  
  LET l_draw_y=l_draw_y+l_dist
  CALL cl_getmsg('asr-032',g_lang) RETURNING l_msg
  LET l_msg=l_msg.trim()
  CALL DrawFillColor("black")
  LET id=DrawText(l_draw_x-3,l_draw_y,l_msg)
END FUNCTION
 
FUNCTION i120_t()
DEFINE l_i LIKE type_file.num10          #No.FUN-680130 INTEGER
   CALL i120_page03() #CHI-780003
   IF (g_rec_b1=0) OR (cl_null(g_rec_b1)) OR 
      (g_show_day IS NULL) OR (g_show_day='1899/12/31') THEN
      RETURN
   END IF
   #CALL cl_set_act_visible("accept", FALSE)
   #CHI-780003...................begin
   LET g_action_flag="page03"
   #CALL i120_bp1("G")
   #CHI-780003...................end
   WHILE TRUE
      INPUT ARRAY g_sre WITHOUT DEFAULTS FROM s_sre.*
            ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=FALSE,DELETE ROW=FALSE,
                      APPEND ROW=FALSE)
          
          #No.FUN-870097---Begin
          AFTER FIELD sre051
            IF NOT cl_null(g_sre[l_ac].sre051) THEN
               SELECT COUNT(*) INTO g_cnt FROM bma_file
                WHERE bma06 = g_sre[l_ac].sre051
                  AND bma01 = g_sre[l_ac].sre04
               IF g_cnt = 0 THEN
                  CALL cl_err(g_sre[l_ac].sre051,"abm-618",0)
                  NEXT FIELD sre051
               END IF
            END IF
          
                       
          ON ACTION CONTROLP
             CASE
               WHEN INFIELD(sre051)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_bma7"
                   LET g_qryparam.default1 = g_sre[l_ac].sre051
                   LET g_qryparam.arg1 = g_sre[l_ac].sre04
                   CALL cl_create_qry() RETURNING g_sre[l_ac].sre051
                   DISPLAY  BY NAME g_sre[l_ac].sre051
                   NEXT FIELD sre051
               OTHERWISE EXIT CASE
             END CASE
           #No.FUN-870097---End  
      
         ON ACTION CONTROLG
            CALL cl_cmdask()
       
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
       
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
       
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
            
         ON ACTION prev_day
            LET g_action_choice="prev_day"
            EXIT INPUT
         
         ON ACTION next_day
            LET g_action_choice="next_day"
            EXIT INPUT
         #ON ACTION accept
            #LET g_action_choice=NULL
            #EXIT INPUT
                        
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         RETURN 
      END IF
      
      LET g_success='Y'
      BEGIN WORK
      FOR l_i=1 TO g_rec_b1
         UPDATE sre_file set sre08=g_sre[l_i].sre08,
                             sre051=g_sre[l_i].sre051  #No.FUN-870097 
               WHERE sre03=g_srd03
                 AND sre04=g_sre[l_i].sre04
                 AND sre05=g_sre[l_i].sre05
                 AND sre06=g_show_day
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
#           CALL cl_err('upd sre08','9050',1)   #No.FUN-660138
            CALL cl_err3("upd","sre_file",g_sre[l_i].sre04,g_sre[l_i].sre05,"9050","","upd sre08",1)  #No.FUN-660138
            EXIT FOR
         END IF
      END FOR
      IF (g_success='Y') AND (g_rec_b1>0) THEN
         COMMIT WORK
         CALL cl_err('','9062',0)
      ELSE
         ROLLBACK WORK
         MESSAGE ""
      END IF
 
      CASE g_action_choice
         WHEN "prev_day" 
            CALL i120_prev_day()
            CONTINUE WHILE
         WHEN "next_day" 
            CALL i120_next_day()
            CONTINUE WHILE
         OTHERWISE
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i120_GETLASTDAY(p_date)
DEFINE p_date LIKE type_file.dat        #No.FUN-680130 DATE
   IF p_date IS NULL OR p_date=0 THEN
      RETURN 0
   END IF
   IF MONTH(p_date)=12 THEN
      RETURN MDY(1,1,YEAR(p_date)+1)-1
   ELSE                                                                         
      RETURN MDY(MONTH(p_date)+1,1,YEAR(p_date))-1                              
   END IF                                                                       
END FUNCTION 
  
