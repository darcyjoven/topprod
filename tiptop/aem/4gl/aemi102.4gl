# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aemi102.4gl
# Descriptions...: 設備保修項目維護作業
# Date & Author..: 04/07/13 By Elva
# Modify.........: No.FUN-4C0069 04/12/13 By Smapmin 加入權限控管
# Modify.........: No.FUN-540030 05/04/18 By saki 多table顯示
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.MOD-670139 06/07/31 By day 工種說明不顯示,報錯信息修改
# Modify.........: No.FUN-680072 06/08/22 By zdyllq 類型轉換
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0050 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750214 07/05/29 By jamie 1.新增時 '停機' default 'N'
#                                                  2.備件編號輸入後自動default '單位' 為庫存單位(ima25)
#                                                  3.' 必需' 欄位default 'N'
# Modify.........: No.FUN-760085 07/07/03 By sherry 報表改寫由Crystal Report產出
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-920109 09/02/27 By chenyu 無效的資料不可以刪除
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
# Modify.........: No.TQC-970079 09/07/09 By lilingyu "保養周期""保修規模"輸入無效值,提示信息有誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990124 09/10/09 By lilingyu  "預計工時 人數 數量"沒有控管負數
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80026 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_fio           RECORD LIKE fio_file.*,       #付款單   (假單頭)
    g_fio_t         RECORD LIKE fio_file.*,       #付款單   (舊值)
    g_fio_o         RECORD LIKE fio_file.*,       #付款單   (舊值)
    g_fio01_t       LIKE fio_file.fio01,   # Pay No.     (舊值)
    g_fip           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fip02            LIKE fip_file.fip02,
        fip03            LIKE fip_file.fip03,
        fid02            LIKE fid_file.fid02,
        fid03            LIKE fid_file.fid03,
        fid04            LIKE fid_file.fid04
                    END RECORD,
    g_fip_t         RECORD                 #程式變數 (舊值)
 
        fip02            LIKE fip_file.fip02,
        fip03            LIKE fip_file.fip03,
        fid02            LIKE fid_file.fid02,
        fid03            LIKE fid_file.fid03,
        fid04            LIKE fid_file.fid04
                    END RECORD,
    g_fix           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fix02            LIKE fix_file.fix02,
        fix03            LIKE fix_file.fix03,
        trw02            LIKE trw_file.trw02,
        fix04            LIKE fix_file.fix04,
        fix05            LIKE fix_file.fix05,
        fix06            LIKE fix_file.fix06
                    END RECORD,
    g_fix_t         RECORD                 #程式變數 (舊值)
        fix02            LIKE fix_file.fix02,
        fix03            LIKE fix_file.fix03,
        trw02            LIKE trw_file.trw02,
        fix04            LIKE fix_file.fix04,
        fix05            LIKE fix_file.fix05,
        fix06            LIKE fix_file.fix06
                    END RECORD,
    g_fiy           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fiy02            LIKE fiy_file.fiy02,
        fiy03            LIKE fiy_file.fiy03,
        ima02            LIKE ima_file.ima02,
        fiy04            LIKE fiy_file.fiy04,
        fiy05            LIKE fiy_file.fiy05,
        fiy06            LIKE fiy_file.fiy06
                    END RECORD,
    g_fiy_t         RECORD
        fiy02            LIKE fiy_file.fiy02,
        fiy03            LIKE fiy_file.fiy03,
        ima02            LIKE ima_file.ima02,
        fiy04            LIKE fiy_file.fiy04,
        fiy05            LIKE fiy_file.fiy05,
        fiy06            LIKE fiy_file.fiy06
                    END RECORD,
    g_fiy2          RECORD LIKE fiy_file.*,
    g_fiy_o         RECORD LIKE fiy_file.*,
    g_wc,g_wc2,g_wc3,g_wc4,g_sql    STRING,  #No.FUN-580092 HCN   
    g_rec_b,g_rec_b2,g_rec_b3    LIKE type_file.num5,            #單身筆數        #No.FUN-680072 SMALLINT
    m_fio           RECORD LIKE fio_file.*,
    m_fix           RECORD LIKE fix_file.*,
    m_fiy           RECORD LIKE fiy_file.*,
    g_buf           LIKE type_file.chr1000,             #        #No.FUN-680072CHAR(78)
    g_aptype        LIKE aba_file.aba18,                         #No.FUN-680072CHAR(2)
    g_dbs_nm        LIKE type_file.chr21,                        #No.FUN-680072CHAR(21)
 
    g_tot,g_qty1,g_qty2,g_qty3,g_qty4,g_qty5 LIKE alh_file.alh33,     #No.FUN-680122 DECIMAL(13,3),
    g_statu         LIKE type_file.chr1,                         #No.FUN-680072 VARCHAR(1)
    g_t1            LIKE type_file.chr3,                         #No.FUN-680072 VARCHAR(3)
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-680072 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680072 SMALLINT
#FUN-760085--start                                                              
   DEFINE  l_table    STRING                                                    
   DEFINE  g_str      STRING                                                    
#FUN-760085--end      
#No: FUN-540030 --start--
DEFINE g_action_flag   STRING                      #No.FUN-680072
#No: FUN-540030 ---end---
 
#主程式開始
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL 
DEFINE  g_before_input_done  LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE  g_chr           LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
DEFINE  g_cnt           LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE  g_msg           LIKE ze_file.ze03        #No.FUN-680072CHAR(72)
 
DEFINE  g_row_count    LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_curs_index   LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_jump         LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  mi_no_ask      LIKE type_file.num5          #No.FUN-680072 SMALLINT
 
MAIN
#     DEFINE  l_time LIKE type_file.chr8            #No.FUN-6A0068
    OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEM")) THEN
      EXIT PROGRAM
   END IF
   
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
   #No.FUN-760085---Begin
   LET g_sql = "fio01.fio_file.fio01,",
               "fio02.fio_file.fio02,",
               "fio05.fio_file.fio05,",
               "chr8.type_file.chr8,",
               "fio06.fio_file.fio06,",
               "fiu02.fiu_file.fiu02,",
               "fio07.fio_file.fio07,",
               "fja02.fja_file.fja02,",
               "fio03.fio_file.fio03,",
               "fio04.fio_file.fio04,",
               "fio08.fio_file.fio08,",
               "fip02.fip_file.fip02,",
               "fip03.fip_file.fip03,",
               "fid02.fid_file.fid02,",
               "fid03.fid_file.fid03,",
               "fid04.fid_file.fid04,"
 
   LET l_table = cl_prt_temptable('aemi102',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "                                     
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                  
             
   #No.FUN-760085---End
 
   LET g_forupd_sql = "SELECT * FROM fio_file WHERE fio01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i102_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   LET p_row = 4 LET p_col = 5
   OPEN WINDOW i102_w33 AT 2,2 WITH FORM "aem/42f/aemi102"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL i102_menu()
   CLOSE WINDOW i102_w33
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION i102_cs()
 
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_fip.clear()
   CALL g_fix.clear()
   CALL g_fiy.clear()
   CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_fio.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON
                fio01,fio02,fio03,fio04,
                fio05,fio06,fio07,fio08,
                fiouser,fiogrup,fiomodu,fiodate,fioacti
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(fio06) #查詢設備保養周期
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_fiu"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fio06
                    NEXT FIELD fio06
              WHEN INFIELD(fio07) #查詢設備保修規模
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_fja"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fio07
                    NEXT FIELD fio07
           OTHERWISE EXIT CASE
        END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
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
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #         LET g_wc = g_wc clipped," AND fiouser = '",g_user,"'"
      #      END IF
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #         LET g_wc = g_wc clipped," AND fiogrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
 
      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #         LET g_wc = g_wc clipped," AND fiogrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fiouser', 'fiogrup')
      #End:FUN-980030
 
      LET g_wc2 = " 1=1"
      CONSTRUCT g_wc2 ON fip02,fip03
           FROM s_fip[1].fip02,s_fip[1].fip03
 
                #No.FUN-580031 --start--     HCN
                BEFORE CONSTRUCT
                   CALL cl_qbe_display_condition(lc_qbe_sn)
                #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fip03)    #查詢作業資料單頭檔
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fid"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_fip[1].fip03
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
 
      END CONSTRUCT
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
      LET g_wc3 = " 1=1"
      CONSTRUCT g_wc3 ON fix02,fix03,fix04,fix05,fix06
           FROM s_fix[1].fix02,s_fix[1].fix03,s_fix[1].fix04,s_fix[1].fix05,
                s_fix[1].fix06
 
                #No.FUN-580031 --start--     HCN
                BEFORE CONSTRUCT
                   CALL cl_qbe_display_condition(lc_qbe_sn)
                #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(fix03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_trw"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO fix03
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
 
      END CONSTRUCT
 
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
      LET g_wc4 = " 1=1"
      CONSTRUCT g_wc4 ON fiy02,fiy03,fiy04,fiy05,fiy06
            FROM s_fiy[1].fiy02,s_fiy[1].fiy03,s_fiy[1].fiy04,s_fiy[1].fiy05,
                 s_fiy[1].fiy06
 
                #No.FUN-580031 --start--     HCN
                BEFORE CONSTRUCT
                   CALL cl_qbe_display_condition(lc_qbe_sn)
                #No.FUN-580031 --end--       HCN
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(fiy03)
#FUN-AA0059 --Begin--
               #  CALL cl_init_qry_var()
               #  LET g_qryparam.state = "c"
               #  LET g_qryparam.form ="q_ima"
               #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                 DISPLAY g_qryparam.multiret TO s_fiy[1].fiy03
          #      NEXT FIELD fiy03
              WHEN INFIELD(fiy04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_fiy[1].fiy04
          #      NEXT FIELD fiy04
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
   IF g_wc4=" 1=1" THEN
      IF g_wc3 = " 1=1" THEN                  # 若單身未輸入條件
         IF g_wc2 = " 1=1" THEN
            LET g_sql = "SELECT fio01 FROM fio_file ",
                        " WHERE ", g_wc CLIPPED,
                        " ORDER BY fio01"
         ELSE                                 # 若單身有輸入條件
            LET g_sql = "SELECT UNIQUE fio01 ",
                        "  FROM fio_file,fip_file ",
                        " WHERE fio01 = fip01",
                        "   AND ",g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                        " ORDER BY fio01"
         END IF
      ELSE
         IF g_wc2 = " 1=1" THEN
            LET g_sql = "SELECT UNIQUE fio01 ",
                        "  FROM fio_file, fix_file ",
                        " WHERE fio01 = fix01",
                        "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                        " ORDER BY fio01"
         ELSE                                 # 若單身有輸入條件
            LET g_sql = "SELECT UNIQUE fio01 ",
                        "  FROM fio_file,fip_file,fix_file ",
                        " WHERE fio01 = fip01 AND fio01 = fix01",
                        "   AND ",g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                        "   AND ",g_wc3 CLIPPED,
                        " ORDER BY fio01"
         END IF
      END IF
   ELSE
      IF g_wc3 = " 1=1" THEN                  # 若單身未輸入條件
         IF g_wc2 = " 1=1" THEN
            LET g_sql = "SELECT UNIQUE fio01 ",
                        "  FROM fio_file,fiy_file ",
                        " WHERE fio01=fiy01 AND ", g_wc CLIPPED,
                        "   AND ",g_wc4 CLIPPED,
                        " ORDER BY fio01"
         ELSE
            LET g_sql = "SELECT UNIQUE fio01 ",
                        "  FROM fio_file,fip_file,fiy_file ",
                        " WHERE fio01=fiy01 AND fio01=fip01", g_wc CLIPPED,
                        "   AND ",g_wc4 CLIPPED," AND ",g_wc2 CLIPPED,
                        " ORDER BY fio01"
         END IF
 
      ELSE                              # 若單身有輸入條件
         IF g_wc2 = " 1=1" THEN
            LET g_sql = "SELECT UNIQUE fio01 ",
                        "  FROM fio_file, fix_file,fiy_file ",
                        " WHERE fio01 = fix01 AND fio01=fiy01 ",
                        "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                        "   AND ",g_wc4 CLIPPED,
                        " ORDER BY fio01"
         ELSE
            LET g_sql = "SELECT UNIQUE fio01 ",
                        "  FROM fio_file,fip_file,fix_file,fiy_file ",
                        " WHERE fio01=fiy01 AND fio01=fip01",
                        "   AND fio01=fix01 AND ",g_wc CLIPPED,
                        "   AND ",g_wc4 CLIPPED," AND ",g_wc2 CLIPPED,
                        "   AND ",g_wc3 CLIPPED,
                        " ORDER BY fio01"
         END IF
      END IF
   END IF
 
   PREPARE i102_prepare FROM g_sql
   DECLARE i102_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i102_prepare
 
   IF g_wc4=" 1=1" THEN
      IF g_wc3 = " 1=1" THEN                  # 取合乎條件筆數
         IF g_wc2 = " 1=1" THEN
            LET g_sql="SELECT COUNT(*) FROM fio_file WHERE ",g_wc CLIPPED
         ELSE
            LET g_sql="SELECT COUNT(DISTINCT fio01) FROM fio_file,fip_file ",
                      " WHERE fip01=fio01 AND ",g_wc CLIPPED,
                      " AND ",g_wc2 CLIPPED
         END IF
      ELSE
         IF g_wc2 = " 1=1" THEN
            LET g_sql="SELECT COUNT(DISTINCT fio01) FROM fio_file,fix_file ",
                      " WHERE fix01=fio01 AND ",g_wc CLIPPED,
                      " AND ",g_wc3 CLIPPED
         ELSE
            LET g_sql="SELECT COUNT(DISTINCT fio01) FROM fio_file,fix_file,",
                      "fip_file ",
                      " WHERE fix01=fio01 AND fip01=fio01",g_wc CLIPPED,
                      " AND ",g_wc3 CLIPPED," AND ",g_wc2 CLIPPED
         END IF
      END IF
   ELSE
      IF g_wc3 = " 1=1" THEN                  # 取合乎條件筆數
         IF g_wc2 = " 1=1" THEN
            LET g_sql="SELECT COUNT(DISTINCT fio01) ",
                      "   FROM fio_file,fiy_file  WHERE ",g_wc CLIPPED,
                      "   AND fio01=fiy01 AND ",g_wc4 CLIPPED
         ELSE
            LET g_sql="SELECT COUNT(DISTINCT fio01) ",
                      "   FROM fio_file,fiy_file,fip_file  WHERE ",g_wc CLIPPED,
                      "   AND fio01=fiy01 AND fio01=fip01 AND ",g_wc4 CLIPPED,
                      "   AND ",g_wc2 CLIPPED
         END IF
      ELSE
         IF g_wc2 = " 1=1" THEN
            LET g_sql="SELECT COUNT(DISTINCT fio01) ",
                      "  FROM fio_file,fix_file,fiy_file  ",
                      "  WHERE fix01=fio01 AND fio01=fiy01 ",
                      "    AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED,
                      "    AND ",g_wc4 CLIPPED
         ELSE
            LET g_sql="SELECT COUNT(DISTINCT fio01) ",
                      "  FROM fio_file,fix_file,fiy_file,fip_file  ",
                      "  WHERE fix01=fio01 AND fio01=fiy01 AND fio01=fip01",
                      "    AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED,
                      "    AND ",g_wc4 CLIPPED," AND ",g_wc2 CLIPPED
         END IF
      END IF
   END IF
   PREPARE i102_precount FROM g_sql
   DECLARE i102_count CURSOR FOR i102_precount
END FUNCTION
 
FUNCTION i102_menu()
   WHILE TRUE
      #No: FUN-540030 --start--
#     CALL i102_bp("G")
      CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "task_main")
            CALL i102_bp1("G")
         WHEN (g_action_flag = "user_main")
            CALL i102_bp2("G")
         WHEN (g_action_flag = "sparepart_main")
            CALL i102_bp3("G")
      END CASE
      #No: FUN-540030 ---end---
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
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i102_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i102_copy()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i102_u()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i102_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #No.FUN-540030 --start--
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CASE
                  WHEN (g_action_flag IS NULL) OR (g_action_flag = "task_main")
                     CALL i102_b()
                  WHEN (g_action_flag = "user_main")
                     CALL i102_b2()
                  WHEN (g_action_flag = "sparepart_main")
                     CALL i102_b3()
               END CASE
            ELSE
               LET g_action_choice = NULL
            END IF
#        WHEN "task_detail"
#           IF cl_chk_act_auth() THEN
#              CALL i102_b()
#           ELSE
#              LET g_action_choice = NULL
#           END IF
#        WHEN "user_detail"
#           IF cl_chk_act_auth() THEN
#              CALL i102_b2()
#           ELSE
#              LET g_action_choice = NULL
#           END IF
#        WHEN "spare_part_detail"
#           IF cl_chk_act_auth() THEN
#              CALL i102_b3()
#           ELSE
#              LET g_action_choice = NULL
#           END IF
         #No.FUN-540030 ---end---
         #No.FUN-6B0050-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_fio.fio01 IS NOT NULL THEN
                 LET g_doc.column1 = "fio01"
                 LET g_doc.value1 = g_fio.fio01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0050-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i102_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_fip.clear()
   CALL g_fix.clear()
   CALL g_fiy.clear()
   INITIALIZE g_fio.* LIKE fio_file.*             #DEFAULT 設定
   LET g_fio01_t = NULL
   #預設值及將數值類變數清成零
   LET g_fio.fiouser=g_user
   LET g_fio.fiooriu = g_user #FUN-980030
   LET g_fio.fioorig = g_grup #FUN-980030
   LET g_fio.fiogrup=g_grup
   LET g_fio.fiodate=g_today
   LET g_fio.fioacti='Y'              #資料有效
   LET g_fio.fio08='N'                #停機    #TQC-750214 add
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i102_i("a")                #輸入單頭
      IF INT_FLAG THEN                #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_fio.* TO NULL
         EXIT WHILE
      END IF
      IF g_fio.fio01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK
      INSERT INTO fio_file VALUES (g_fio.*)
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","fio_file",g_fio.fio01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092 #No.FUN-B80026---調整至回滾事務前---
         ROLLBACK WORK  #
#        CALL cl_err(g_fio.fio01,SQLCA.sqlcode,1)   #No.FUN-660092
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
      SELECT fio01 INTO g_fio.fio01 FROM fio_file
       WHERE fio01 = g_fio.fio01
      LET g_fio01_t = g_fio.fio01        #保留舊值
      LET g_fio_t.* = g_fio.*
      CALL g_fip.clear()
      LET g_rec_b=0
      CALL i102_b()                   #輸入單身-1
 
      LET g_rec_b2=0
      CALL g_fix.clear()
      CALL i102_b2()                   #輸入單身-2
 
  #   SELECT COUNT(*) INTO g_cnt FROM fix_file WHERE fix01 = g_fio.fio01
  #   IF g_cnt = 0 THEN RETURN END IF
      CALL g_fiy.clear()
      LET g_rec_b3=0
      CALL i102_b3()                   #輸入單身-3
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i102_u()
   IF s_shut(0) THEN RETURN END IF
   IF g_fio.fio01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_fio.* FROM fio_file
    WHERE fio01=g_fio.fio01
   IF g_fio.fioacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_fio.fio01,9027,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_fio01_t = g_fio.fio01
   LET g_fio_o.* = g_fio.*
   BEGIN WORK
   LET g_success = 'Y'
   OPEN i102_cl USING g_fio.fio01
   IF STATUS THEN
      CALL cl_err("OPEN i102_cl:", STATUS, 1)
      CLOSE i102_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i102_cl INTO g_fio.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fio.fio01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i102_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL i102_show()
   WHILE TRUE
      LET g_fio01_t = g_fio.fio01
      LET g_fio.fiomodu=g_user
      LET g_fio.fiodate=g_today
      CALL i102_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         LET g_fio.*=g_fio_t.*
         CALL i102_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_fio.fio01 != g_fio01_t THEN            # 更改單號
         UPDATE fip_file SET fip01 = g_fio.fio01 WHERE fip01 = g_fio01_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('upd fip',SQLCA.sqlcode,0)   #No.FUN-660092
            CALL cl_err3("upd","fip_file",g_fio01_t,"",SQLCA.sqlcode,"","upd fip",1)  #No.FUN-660092
            CONTINUE WHILE
         END IF
         UPDATE fix_file SET fix01 = g_fio.fio01 WHERE fix01 = g_fio01_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('upd fix',SQLCA.sqlcode,0)   #No.FUN-660092
            CALL cl_err3("upd","fix_file",g_fio01_t,"",SQLCA.sqlcode,"","upd fix",1)  #No.FUN-660092
            CONTINUE WHILE
         END IF
         UPDATE fiy_file SET fiy01 = g_fio.fio01 WHERE fiy01 = g_fio01_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('upd fiy',SQLCA.sqlcode,0)   #No.FUN-660092
            CALL cl_err3("upd","fiy_file",g_fio01_t,"",SQLCA.sqlcode,"","upd fiy",1)  #No.FUN-660092
            CONTINUE WHILE
         END IF
      END IF
      UPDATE fio_file SET fio_file.* = g_fio.* WHERE fio01 = g_fio01_t
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_fio.fio01,SQLCA.sqlcode,0)   #No.FUN-660092
         CALL cl_err3("upd","fio_file",g_fio01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i102_cl
   COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i102_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改                 #No.FUN-680072 VARCHAR(1)
    l_paydate       LIKE type_file.dat,                                                 #No.FUN-680072DATE
    l_yy,l_mm       LIKE type_file.num5                                                 #No.FUN-680072SMALLINT
    CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029
 
    INPUT BY NAME g_fio.fiooriu,g_fio.fioorig,
          g_fio.fio01,g_fio.fio02,  #   g_fio.fio03,g_fio.fio4,
          g_fio.fio05,g_fio.fio06,g_fio.fio07,g_fio.fio08,
          g_fio.fiouser,g_fio.fiogrup,g_fio.fiomodu,g_fio.fiodate,g_fio.fioacti
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i102_set_entry(p_cmd)
         CALL i102_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
        AFTER FIELD fio01
           IF g_fio.fio01 != g_fio01_t OR g_fio01_t IS NULL THEN
              SELECT count(*) INTO g_cnt FROM fio_file
               WHERE fio01 = g_fio.fio01
              IF g_cnt > 0 THEN   #資料重複
                 CALL cl_err(g_fio.fio01,-239,0)
                 LET g_fio.fio01 = g_fio01_t
                 DISPLAY BY NAME g_fio.fio01
                 NEXT FIELD fio01
              END IF
           END IF
 
        AFTER FIELD fio06
           IF NOT cl_null(g_fio.fio06) THEN
              IF p_cmd = 'a' OR g_fio.fio06 != g_fio_o.fio06 THEN
                 CALL i102_fio06('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fio.fio06,g_errno,0)
                    LET g_fio.fio06 = g_fio_o.fio06
                    DISPLAY BY NAME g_fio.fio06
                    NEXT FIELD fio06
                 END IF
              END IF
           END IF
           LET g_fio_o.fio06 = g_fio.fio06
 
        AFTER FIELD fio07
           IF NOT cl_null(g_fio.fio07) THEN
              IF p_cmd = 'a' OR g_fio.fio07 != g_fio_o.fio07 THEN
                 CALL i102_fio07('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fio.fio07,g_errno,0)
                    LET g_fio.fio07 = g_fio_o.fio07
                    DISPLAY BY NAME g_fio.fio07
                    NEXT FIELD fio07
                 END IF
              END IF
           END IF
           LET g_fio_o.fio07 = g_fio.fio07
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(fio06) #查詢設備保養周期
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_fiu"
                    LET g_qryparam.default1 = g_fio.fio06
                    CALL cl_create_qry() RETURNING g_fio.fio06
                    DISPLAY BY NAME g_fio.fio06
                    NEXT FIELD fio06
              WHEN INFIELD(fio07) #查詢設備保修規模
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_fja"
                    LET g_qryparam.default1 = g_fio.fio07
                    CALL cl_create_qry() RETURNING g_fio.fio07
                    DISPLAY BY NAME g_fio.fio07
                    NEXT FIELD fio07
           OTHERWISE EXIT CASE
        END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #MOD-650015 --start 
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #    IF INFIELD(fio01) THEN
       #       LET g_fio.* = g_fio_t.*
       #       DISPLAY BY NAME g_fio.*
       #       NEXT FIELD fio01
       #    END IF
        #MOD-650015 --end
 
        ON ACTION CONTROLR
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
 
FUNCTION i102_fio06(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_fiu02   LIKE fiu_file.fiu02
   DEFINE l_fiuacti LIKE fiu_file.fiuacti
 
   SELECT fiu02,fiuacti INTO l_fiu02,l_fiuacti
     FROM fiu_file WHERE fiu01 = g_fio.fio06
   LET g_errno = ' '
  #CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'  #TQC-970079
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aem-041'  #TQC-970079
        WHEN l_fiuacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
   DISPLAY l_fiu02 TO FORMONLY.fiu02
END FUNCTION
 
FUNCTION i102_fio07(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_fja02   LIKE fja_file.fja02
   DEFINE l_fjaacti LIKE fja_file.fjaacti
 
   SELECT fja02,fjaacti INTO l_fja02,l_fjaacti
     FROM fja_file WHERE fja01 = g_fio.fio07
   LET g_errno = ' '
#   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038' #TQC-970079
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aem-041' #TQC-970079
        WHEN l_fjaacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
   DISPLAY l_fja02 TO FORMONLY.fja02
END FUNCTION
 
FUNCTION i102_fip03(p_cmd)
 DEFINE l_fid02   LIKE fid_file.fid02,
        l_fid03   LIKE fid_file.fid03,
        l_fid04   LIKE fid_file.fid04,
        l_fidacti LIKE fid_file.fidacti,
        p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
  LET g_errno = " "
  SELECT fid02,fid03,fid04,fidacti
    INTO l_fid02,l_fid03,l_fid04,l_fidacti
    FROM fid_file  WHERE fid01 = g_fip[l_ac].fip03
 
# CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'  #No.MOD-670139
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-129   #No.MOD-670139'
                                 LET g_fip[l_ac].fid02 = NULL
                                 LET g_fip[l_ac].fid03 = NULL
                                 LET g_fip[l_ac].fid04 = NULL
       WHEN l_fidacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF NOT cl_null(g_errno) THEN RETURN END IF
  LET g_fip[l_ac].fid02 = l_fid02
  LET g_fip[l_ac].fid03 = l_fid03
  LET g_fip[l_ac].fid04 = l_fid04
  #------MOD-5A0095 START----------
  DISPLAY BY NAME g_fip[l_ac].fid02
  DISPLAY BY NAME g_fip[l_ac].fid03
  DISPLAY BY NAME g_fip[l_ac].fid04
  #------MOD-5A0095 END------------
END FUNCTION
 
FUNCTION i102_fix03(p_cmd,p_i)
 DEFINE l_trw02   LIKE trw_file.trw02,
        l_trwacti LIKE trw_file.trwacti,
        p_i       LIKE type_file.num5,         #No.FUN-680072 SMALLINT
        p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
  LET g_errno = " "
  SELECT trw02,trwacti
    INTO l_trw02,l_trwacti
    FROM trw_file  WHERE trw01 = g_fix[p_i].fix03
 
# CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'  #No.MOD-670139
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-129'  #No.MOD-670139
                                 LET g_fix[p_i].trw02 = NULL
       WHEN l_trwacti='N'        LET g_errno = '9028'
       WHEN l_trwacti IS NULL    LET g_errno = '9028'     #No.MOD-670139
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF NOT cl_null(g_errno) THEN RETURN END IF
  LET g_fix[p_i].trw02 = l_trw02 #No.MOD-670139
END FUNCTION
 
FUNCTION i102_fiy03(p_cmd)
 DEFINE l_ima02   LIKE ima_file.ima02,
        l_imaacti LIKE ima_file.imaacti,
        l_ima25   LIKE ima_file.ima25,         #TQC-750214 add
        p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
  LET g_errno = " "
  SELECT ima02,imaacti,ima25          #TQC-750214 add ima25
    INTO l_ima02,l_imaacti,l_ima25    #TQC-750214 add l_ima25
    FROM ima_file  WHERE ima01 = g_fiy[l_ac].fiy03
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 LET g_fiy[l_ac].ima02 = NULL
       WHEN l_imaacti='N'               LET g_errno = '9028'
       WHEN l_imaacti MATCHES '[PH]'    LET g_errno = '9038'    #FUN-690022 add
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  IF NOT cl_null(g_errno) THEN RETURN END IF
  LET g_fiy[l_ac].ima02 = l_ima02
  #------MOD-5A0095 START----------
  DISPLAY BY NAME g_fiy[l_ac].ima02
  #------MOD-5A0095 END------------
 
  #TQC-750214---add---str--- 
  IF p_cmd = 'a' AND cl_null(g_errno) THEN
     LET g_fiy[l_ac].fiy04 = l_ima25
     DISPLAY BY NAME g_fiy[l_ac].fiy04
  END IF
  #TQC-750214---add---end--- 
 
END FUNCTION
 
FUNCTION i102_fiy04(p_cmd,p_key)
 DEFINE l_gfeacti LIKE gfe_file.gfeacti,
        l_ima25   LIKE ima_file.ima25  ,
        l_ima01   LIKE ima_file.ima01  ,
        p_key     LIKE fiy_file.fiy04,
        p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti
    FROM gfe_file  WHERE gfe01 = p_key
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0019'
                                 LET l_gfeacti = NULL
       WHEN l_gfeacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
END FUNCTION
 
FUNCTION i102_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_fio.* TO NULL              #NO.FUN-6B0050
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_fip.clear()
   CALL g_fix.clear()
   CALL g_fiy.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i102_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN i102_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_fio.* TO NULL
   ELSE
      OPEN i102_count
      FETCH i102_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i102_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i102_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680072 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i102_cs INTO g_fio.fio01
      WHEN 'P' FETCH PREVIOUS i102_cs INTO g_fio.fio01
      WHEN 'F' FETCH FIRST    i102_cs INTO g_fio.fio01
      WHEN 'L' FETCH LAST     i102_cs INTO g_fio.fio01
      WHEN '/'
         IF NOT mi_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump i102_cs INTO g_fio.fio01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fio.fio01,SQLCA.sqlcode,0)
      INITIALIZE g_fio.* TO NULL  #TQC-6B0105
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
   SELECT * INTO g_fio.* FROM fio_file WHERE fio01 = g_fio.fio01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_fio.fio01,SQLCA.sqlcode,0)   #No.FUN-660092
      CALL cl_err3("sel","fio_file",g_fio.fio01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
      INITIALIZE g_fio.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_fio.fiouser   #FUN-4C0069
   LET g_data_group = g_fio.fiogrup   #FUN-4C0069
   CALL i102_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i102_show()
   LET g_fio_t.* = g_fio.*                #保存單頭舊值
   DISPLAY BY NAME g_fio.fiooriu,g_fio.fioorig,
          g_fio.fio01,g_fio.fio02,g_fio.fio03,g_fio.fio04,
          g_fio.fio05,g_fio.fio06,g_fio.fio07,g_fio.fio08,
          g_fio.fiouser,g_fio.fiogrup,g_fio.fiomodu,g_fio.fiodate,g_fio.fioacti
   CALL i102_fio06('d')
   CALL i102_fio07('d')
   CALL i102_b_fill(g_wc2)                 #單身
   CALL i102_b2_fill(g_wc3)                 #單身
   CALL i102_b3_fill(g_wc4)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i102_r()
   IF s_shut(0) THEN RETURN END IF
   IF g_fio.fio01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_fio.* FROM fio_file
    WHERE fio01=g_fio.fio01
   #No.TQC-920109 add --begin
   IF g_fio.fioacti = 'N' THEN
      CALL cl_err('','abm-950',0)
      RETURN
   END IF
   #No.TQC-920109 add --end
   LET g_success = 'Y'
   BEGIN WORK
   OPEN i102_cl USING g_fio.fio01
   IF STATUS THEN
      CALL cl_err("OPEN i102_cl:", STATUS, 1)   
      CLOSE i102_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i102_cl INTO g_fio.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fio.fio01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL i102_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "fio01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_fio.fio01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM fip_file WHERE fip01 = g_fio.fio01
      IF STATUS THEN
#        CALL cl_err('del fip:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","fip_file",g_fio.fio01,"",STATUS,"","del fip:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM fix_file WHERE fix01 = g_fio.fio01
      IF STATUS THEN
#        CALL cl_err('del fix:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","fix_file",g_fio.fio01,"",STATUS,"","del fix:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM fiy_file WHERE fiy01 = g_fio.fio01
      IF STATUS THEN
#        CALL cl_err('del fiy:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","fiy_file",g_fio.fio01,"",STATUS,"","del fiy:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM fio_file WHERE fio01 = g_fio.fio01
      IF STATUS THEN
#        CALL cl_err('del fio:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","fio_file",g_fio.fio01,"",STATUS,"","del fio:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      INITIALIZE g_fio.* TO NULL
      CLEAR FORM
      CALL g_fip.clear()
      CALL g_fix.clear()
      CALL g_fiy.clear()
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
END FUNCTION
 
FUNCTION i102_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680072 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680072 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680072 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680072 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680072 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680072 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_fio.fio01 IS NULL THEN RETURN END IF
   SELECT * INTO g_fio.* FROM fio_file
    WHERE fio01=g_fio.fio01
   IF g_fio.fioacti ='N' THEN CALL cl_err(g_fio.fio01,'9027',0) RETURN END IF
 
 # SELECT COUNT(*) INTO g_rec_b FROM fip_file WHERE fip01=g_fio.fio01
 # IF g_rec_b = 0 THEN
 #    CALL i102_b_fill(' 1=1')
 # END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT fip02,fip03,'','',''",
                      " FROM fip_file",
                      " WHERE fip01=? AND fip02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i102_b3cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 # LET g_fio.fiomodu=g_user
 # LET g_fio.fiodate=g_today
 # DISPLAY BY NAME g_fio.fiomodu,g_fio.fiodate
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_fip WITHOUT DEFAULTS FROM s_fip.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          BEGIN WORK
       #  LET g_success = 'Y'
          OPEN i102_cl USING g_fio.fio01
          IF STATUS THEN
             CALL cl_err("OPEN i102_cl:", STATUS, 1)
             CLOSE i102_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i102_cl INTO g_fio.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_fio.fio01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE i102_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_fip_t.* = g_fip[l_ac].*  #BACKUP
             OPEN i102_b3cl USING g_fio.fio01,g_fip_t.fip02 IF STATUS THEN CALL cl_err("OPEN i102_b3cl:", STATUS, 1) LET l_lock_sw = "Y"
             END IF
             FETCH i102_b3cl INTO g_fip[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_fip_t.fip02,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             LET g_fip[l_ac].fid02 = g_fip_t.fid02
             LET g_fip[l_ac].fid03 = g_fip_t.fid03
             LET g_fip[l_ac].fid04 = g_fip_t.fid04
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_fip[l_ac].* TO NULL      #900423
          LET g_fip_t.* = g_fip[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD fip02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO fip_file(fip01,fip02,fip03)
            VALUES(g_fio.fio01,g_fip[l_ac].fip02,g_fip[l_ac].fip03)
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_fip[l_ac].fip02,SQLCA.sqlcode,0)   #No.FUN-660092
             CALL cl_err3("ins","fip_file",g_fio.fio01,g_fip[l_ac].fip02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
             CANCEL INSERT
             ROLLBACK WORK
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
             COMMIT WORK
          END IF
 
       BEFORE FIELD fip02                        #default 序號
          IF g_fip[l_ac].fip02 IS NULL OR g_fip[l_ac].fip02 = 0 THEN
             SELECT max(fip02)+1
               INTO g_fip[l_ac].fip02
               FROM fip_file
              WHERE fip01 = g_fio.fio01
             IF g_fip[l_ac].fip02 IS NULL THEN
                LET g_fip[l_ac].fip02 = 1
             END IF
          END IF
 
       AFTER FIELD fip02                        #check 序號是否重複
           IF g_fip[l_ac].fip02 IS NULL THEN
              LET g_fip[l_ac].fip02 = g_fip_t.fip02
              NEXT FIELD fip02
           END IF
           IF g_fip[l_ac].fip02 != g_fip_t.fip02 OR
              g_fip_t.fip02 IS NULL THEN
               SELECT count(*)
                   INTO l_n
                   FROM fip_file
                   WHERE fip01 = g_fio.fio01
                     AND fip02 = g_fip[l_ac].fip02
               IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_fip[l_ac].fip02 = g_fip_t.fip02
                   NEXT FIELD fip02
               END IF
           END IF
 
       AFTER FIELD fip03
           IF NOT cl_null(g_fip[l_ac].fip03) THEN
              IF g_fip_t.fip03 IS NULL OR
                  g_fip[l_ac].fip03 != g_fip_t.fip03 THEN
                  CALL i102_fip03('a')
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_fip[l_ac].fip03=g_fip_t.fip03
                      #------MOD-5A0095 START----------
                      DISPLAY BY NAME g_fip[l_ac].fip03
                      #------MOD-5A0095 END------------
                      NEXT FIELD fip03
                  END IF
              END IF
           END IF
 
       BEFORE DELETE                            #是否取消單身
          IF g_fip_t.fip02 > 0 AND
             g_fip_t.fip02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM fip_file
              WHERE fip01 = g_fio.fio01
                AND fip02 = g_fip_t.fip02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fip_t.fip02,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("del","fip_file",g_fio.fio01,g_fip_t.fip02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
             CALL i102_b_tot()
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_fip[l_ac].* = g_fip_t.*
             CLOSE i102_b3cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_fip[l_ac].fip02,-263,1)
             LET g_fip[l_ac].* = g_fip_t.*
          ELSE
             UPDATE fip_file SET fip02 = g_fip[l_ac].fip02,
                                 fip03 = g_fip[l_ac].fip03
              WHERE fip01=g_fio.fio01 AND fip02=g_fip_t.fip02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fip[l_ac].fip02,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("upd","fip_file",g_fio.fio01,g_fip_t.fip02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                LET g_fip[l_ac].* = g_fip_t.*
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D40030
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_fip[l_ac].* = g_fip_t.*
             #FUN-D40030--add--str--
             ELSE
                CALL g_fip.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET g_action_flag = "task_main"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030--add--end--
             END IF
             CLOSE i102_b3cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D40030
          CLOSE i102_b3cl
          COMMIT WORK
          CALL i102_b_tot()
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fip03)    #查詢作業資料單頭檔
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_fid"
                LET g_qryparam.default1 = g_fip[l_ac].fip03
                CALL cl_create_qry() RETURNING g_fip[l_ac].fip03
             OTHERWISE
                EXIT CASE
       END CASE
 
       ON ACTION CONTROLN
          CALL i102_b_askkey()
          EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(fip02) AND l_ac > 1 THEN
               LET g_fip[l_ac].* = g_fip[l_ac-1].*
               NEXT FIELD fip02
           END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CASE
             WHEN INFIELD(fip02) CALL cl_fldhlp('fip02')
             WHEN INFIELD(fip03) CALL cl_fldhlp('fip03')
             OTHERWISE          CALL cl_fldhlp('    ')
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("folder01","AUTO")                    
#No.FUN-6B0029--end                
 
   END INPUT
 
  #start FUN-5A0029
   LET g_fio.fiomodu = g_user
   LET g_fio.fiodate = g_today
  #end FUN-5A0029
   UPDATE fio_file SET fiomodu=g_fio.fiomodu,
                       fiodate=g_fio.fiodate
    WHERE fio01=g_fio.fio01
   DISPLAY BY NAME g_fio.fiomodu,g_fio.fiodate   #FUN-5A0029
 
   CLOSE i102_b3cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i102_b2()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680072 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680072 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680072 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680072 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680072 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680072 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_fio.fio01 IS NULL THEN RETURN END IF
   SELECT * INTO g_fio.* FROM fio_file
    WHERE fio01=g_fio.fio01
   IF g_fio.fioacti ='N' THEN CALL cl_err(g_fio.fio01,'9027',0) RETURN END IF
 
   #SELECT COUNT(*) INTO g_rec_b2 FROM fix_file WHERE fix01=g_fio.fio01
   #IF g_rec_b2 = 0 THEN
   #   CALL i102_b2_fill(' 1=1')
   #END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT fix02,fix03,'',fix04,fix05,fix06",
                      " FROM fix_file",
                      " WHERE fix01=? AND fix02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i102_b2cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   #LET g_fio.fiomodu=g_user
   #LET g_fio.fiodate=g_today
   #DISPLAY BY NAME g_fio.fiomodu,g_fio.fiodate
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_fix WITHOUT DEFAULTS FROM s_fix.*
         ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          BEGIN WORK
      #   LET g_success = 'Y'
          OPEN i102_cl USING g_fio.fio01
          IF STATUS THEN
             CALL cl_err("OPEN i102_cl:", STATUS, 1)
             CLOSE i102_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i102_cl INTO g_fio.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_fio.fio01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE i102_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b2 >= l_ac THEN
             LET p_cmd='u'
             LET g_fix_t.* = g_fix[l_ac].*  #BACKUP
             OPEN i102_b2cl USING g_fio.fio01,g_fix_t.fix02
             IF STATUS THEN
                CALL cl_err("OPEN i102_b2cl:", STATUS, 1)
                LET l_lock_sw = "Y"
             END IF
             FETCH i102_b2cl INTO g_fix[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_fix_t.fix02,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             LET g_fix[l_ac].trw02 = g_fix_t.trw02
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_fix[l_ac].* TO NULL      #900423
          LET g_fix[l_ac].fix04 = 0
          LET g_fix_t.* = g_fix[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD fix02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO fix_file(fix01,fix02,fix03,fix04,fix05,fix06)
            VALUES(g_fio.fio01,g_fix[l_ac].fix02,g_fix[l_ac].fix03,
                   g_fix[l_ac].fix04,g_fix[l_ac].fix05,g_fix[l_ac].fix06)
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_fix[l_ac].fix02,SQLCA.sqlcode,0)   #No.FUN-660092
             CALL cl_err3("ins","fix_file",g_fio.fio01,g_fix[l_ac].fix02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
             CANCEL INSERT
             ROLLBACK WORK
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b2=g_rec_b2+1
             DISPLAY g_rec_b2 TO FORMONLY.cn4
             COMMIT WORK
          END IF
 
       BEFORE FIELD fix02                        #default 序號
          IF g_fix[l_ac].fix02 IS NULL OR g_fix[l_ac].fix02 = 0 THEN
             SELECT max(fix02)+1
               INTO g_fix[l_ac].fix02
               FROM fix_file
              WHERE fix01 = g_fio.fio01
             IF g_fix[l_ac].fix02 IS NULL THEN
                LET g_fix[l_ac].fix02 = 1
             END IF
          END IF
 
       AFTER FIELD fix02                        #check 序號是否重複
           IF g_fix[l_ac].fix02 IS NULL THEN
              LET g_fix[l_ac].fix02 = g_fix_t.fix02
              NEXT FIELD fix02
           END IF
           IF g_fix[l_ac].fix02 != g_fix_t.fix02 OR
              g_fix_t.fix02 IS NULL THEN
               SELECT count(*)
                   INTO l_n
                   FROM fix_file
                   WHERE fix01 = g_fio.fio01
                     AND fix02 = g_fix[l_ac].fix02
               IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_fix[l_ac].fix02 = g_fix_t.fix02
                   NEXT FIELD fix02
               END IF
           END IF
 
       AFTER FIELD fix03
           IF NOT cl_null(g_fix[l_ac].fix03) THEN
#             IF g_fix_t.fix03 IS NULL OR   #No.MOD-670139
#                 g_fix[l_ac].fix03 != g_fix_t.fix03 THEN   #No.MOD-670139
                  CALL i102_fix03('a',l_ac)
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_fix[l_ac].fix03=g_fix_t.fix03
                      #------MOD-5A0095 START----------
                      DISPLAY BY NAME g_fix[l_ac].fix03
                      #------MOD-5A0095 END------------
                      NEXT FIELD fix03
                  END IF
#             END IF   #No.MOD-670139
           END IF
 
#TQC-990124 --begin--
       AFTER FIELD fix04
          IF NOT cl_null(g_fix[l_ac].fix04) THEN 
             IF g_fix[l_ac].fix04 < 0 THEN 
                CALL cl_err('','aec-020',0)
                NEXT FIELD fix04
             END IF 
          END IF 
          
       AFTER FIELD fix05
          IF NOT cl_null(g_fix[l_ac].fix05) THEN 
             IF g_fix[l_ac].fix05 < 0 THEN 
                CALL cl_err('','aec-020',0)
                NEXT FIELD fix05
             END IF 
          END IF        
#TQC-990124 --end--
 
       BEFORE DELETE                            #是否取消單身
          IF g_fix_t.fix02 > 0 AND
             g_fix_t.fix02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM fix_file
              WHERE fix01 = g_fio.fio01
                AND fix02 = g_fix_t.fix02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fix_t.fix02,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("del","fix_file",g_fio.fio01,g_fix_t.fix02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b2=g_rec_b2-1
             DISPLAY g_rec_b2 TO FORMONLY.cn4
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_fix[l_ac].* = g_fix_t.*
             CLOSE i102_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_fix[l_ac].fix02,-263,1)
             LET g_fix[l_ac].* = g_fix_t.*
          ELSE
             UPDATE fix_file SET fix02 = g_fix[l_ac].fix02,
                                 fix03 = g_fix[l_ac].fix03,
                                 fix04 = g_fix[l_ac].fix04,
                                 fix05 = g_fix[l_ac].fix05,
                                 fix06 = g_fix[l_ac].fix06
              WHERE fix01=g_fio.fio01 AND fix02=g_fix_t.fix02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fix[l_ac].fix02,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("upd","fix_file",g_fio.fio01,g_fix_t.fix02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                LET g_fix[l_ac].* = g_fix_t.*
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D40030
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_fix[l_ac].* = g_fix_t.*
             #FUN-D40030--add--str--
             ELSE
                CALL g_fix.deleteElement(l_ac)
                IF g_rec_b2 != 0 THEN
                   LET g_action_choice = "detail"
                   LET g_action_flag = "user_main"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030--add--end--
             END IF
             CLOSE i102_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D40030
          CLOSE i102_b2cl
          COMMIT WORK
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fix03)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_trw"
                LET g_qryparam.default1 = g_fix[l_ac].fix03
                CALL cl_create_qry() RETURNING g_fix[l_ac].fix03
                DISPLAY g_fix[l_ac].fix03 TO fix03
             OTHERWISE
                EXIT CASE
       END CASE
 
       ON ACTION CONTROLN
          CALL i102_b2_askkey()
          EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(fix02) AND l_ac > 1 THEN
               LET g_fix[l_ac].* = g_fix[l_ac-1].*
               NEXT FIELD fix02
           END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CASE
             WHEN INFIELD(fix02) CALL cl_fldhlp('fix02')
             WHEN INFIELD(fix03) CALL cl_fldhlp('fix03')
             WHEN INFIELD(fix04) CALL cl_fldhlp('fix04')
             WHEN INFIELD(fix05) CALL cl_fldhlp('fix05')
             OTHERWISE          CALL cl_fldhlp('    ')
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("folder01","AUTO")                    
#No.FUN-6B0029--end      
           
   END INPUT
 
  #start FUN-5A0029
   LET g_fio.fiomodu = g_user
   LET g_fio.fiodate = g_today
  #end FUN-5A0029
   UPDATE fio_file SET fiomodu=g_fio.fiomodu,
                       fiodate=g_fio.fiodate
    WHERE fio01=g_fio.fio01
   DISPLAY BY NAME g_fio.fiomodu,g_fio.fiodate   #FUN-5A0029
 
   CLOSE i102_b2cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i102_b_tot()
 
   SELECT SUM(fid03),SUM(fid04) INTO g_fio.fio03,g_fio.fio04
     FROM fip_file,fid_file WHERE fid01=fip03
      AND fip01 = g_fio.fio01
 
   IF g_fio.fio03 IS NULL THEN LET g_fio.fio03 =0 END IF
   IF g_fio.fio04 IS NULL THEN LET g_fio.fio04 =0 END IF
   DISPLAY BY NAME g_fio.fio03,g_fio.fio04
   UPDATE fio_file SET fio03 =g_fio.fio03,
                       fio04 =g_fio.fio04
    WHERE fio01=g_fio.fio01
END FUNCTION
 
 
FUNCTION i102_b3()
DEFINE
    p_cmd           LIKE type_file.chr1,         #處理狀態          #No.FUN-680072 VARCHAR(1)
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT #No.FUN-680072 SMALLINT
    l_n             LIKE type_file.num5,         #檢查重複用        #No.FUN-680072 SMALLINT
    l_apa41,l_apa42 LIKE type_file.chr1,                            #No.FUN-680072 VARCHAR(1)
    l_cnt           LIKE type_file.num5,                            #No.FUN-680072 SMALLINT
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否        #No.FUN-680072 VARCHAR(1)
    l_fiy05         LIKE fiy_file.fiy05,
    l_allow_insert  LIKE type_file.num5,         #可新增否          #No.FUN-680072 SMALLINT
    l_allow_delete  LIKE type_file.num5          #可刪除否          #No.FUN-680072 SMALLINT
 
 
    LET g_action_choice = ""              #No.FUN-540030
    IF s_shut(0) THEN RETURN END IF
    IF g_fio.fio01 IS NULL THEN RETURN END IF
    SELECT * INTO g_fio.* FROM fio_file
     WHERE fio01=g_fio.fio01
    IF g_fio.fioacti ='N' THEN CALL cl_err(g_fio.fio01,'9027',0) RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT fiy02,fiy03,'',fiy04,fiy05,fiy06 FROM fiy_file",
                       " WHERE fiy01=? AND fiy02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i102_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET g_fio.fiomodu=g_user
    LET g_fio.fiodate=g_today
    DISPLAY BY NAME g_fio.fiomodu,g_fio.fiodate
    CALL i102_b3_fill(g_wc4)                 #單身
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_fiy WITHOUT DEFAULTS FROM s_fiy.*
          ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b3 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           BEGIN WORK
       #   LET g_success = 'Y'
           OPEN i102_cl USING g_fio.fio01
           IF STATUS THEN
              CALL cl_err("OPEN i102_cl:", STATUS, 1)
              CLOSE i102_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i102_cl INTO g_fio.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_fio.fio01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i102_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b3 >= l_ac THEN
              LET p_cmd='u'
              LET g_fiy_t.* = g_fiy[l_ac].*  #BACKUP
              OPEN i102_bcl USING g_fio.fio01,g_fiy_t.fiy02
              IF STATUS THEN
                 CALL cl_err("OPEN i102_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH i102_bcl INTO g_fiy[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_fiy_t.fiy02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              CALL i102_fiy03('d')
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_fiy[l_ac].* TO NULL
           LET g_fiy[l_ac].fiy05 = 0
           LET g_fiy_t.* = g_fiy[l_ac].*         #新輸入資料
           LET g_fiy[l_ac].fiy06='N'             #TQC-750214 add
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD fiy02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO fiy_file(fiy01,fiy02,fiy03,fiy04,fiy05,fiy06)
            VALUES(g_fio.fio01,g_fiy[l_ac].fiy02,g_fiy[l_ac].fiy03,
                   g_fiy[l_ac].fiy04,g_fiy[l_ac].fiy05,g_fiy[l_ac].fiy06)
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_fiy[l_ac].fiy02,SQLCA.sqlcode,0)   #No.FUN-660092
              CALL cl_err3("ins","fiy_file",g_fio.fio01,g_fiy[l_ac].fiy02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
              CANCEL INSERT
              ROLLBACK WORK
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b3=g_rec_b3+1
              DISPLAY g_rec_b3 TO FORMONLY.cn6
              COMMIT WORK
           END IF
 
        BEFORE FIELD fiy02                        #default 序號
           IF g_fiy[l_ac].fiy02 IS NULL OR g_fiy[l_ac].fiy02 = 0 THEN
              SELECT max(fiy02)+1
                INTO g_fiy[l_ac].fiy02
                FROM fiy_file
               WHERE fiy01 = g_fio.fio01
              IF g_fiy[l_ac].fiy02 IS NULL THEN
                 LET g_fiy[l_ac].fiy02 = 1
              END IF
           END IF
 
        AFTER FIELD fiy02                        #check 序號是否重複
           IF NOT cl_null(g_fiy[l_ac].fiy02) THEN
              IF g_fiy[l_ac].fiy02 != g_fiy_t.fiy02 OR g_fiy_t.fiy02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM fiy_file
                  WHERE fiy01 = g_fio.fio01
                    AND fiy02 = g_fiy[l_ac].fiy02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_fiy[l_ac].fiy02 = g_fiy_t.fiy02
                    NEXT FIELD fiy02
                 END IF
              END IF
           END IF
 
        AFTER FIELD fiy03
            IF NOT cl_null(g_fiy[l_ac].fiy03) THEN
             #FUN-AA0059 -------------------add start--------------
              IF NOT s_chk_item_no(g_fiy[l_ac].fiy03,'') THEN
                 CALL cl_err('',g_errno,1)
                 LET g_fiy[l_ac].fiy03=g_fiy_t.fiy03
                 DISPLAY BY NAME g_fiy[l_ac].fiy03
                 NEXT FIELD fiy03
              END IF 
             #FUN-AA0059 --------------------add end------------------
              IF g_fiy_t.fiy03 IS NULL OR
                  g_fiy[l_ac].fiy03 != g_fiy_t.fiy03 THEN
                  CALL i102_fiy03('a')
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_fiy[l_ac].fiy03=g_fiy_t.fiy03
                      #------MOD-5A0095 START----------
                      DISPLAY BY NAME g_fiy[l_ac].fiy03
                      #------MOD-5A0095 END------------
                      NEXT FIELD fiy03
                  END IF
              END IF
            END IF
 
        AFTER FIELD fiy04
            IF NOT cl_null(g_fiy[l_ac].fiy04) THEN
               CALL i102_fiy04('d', g_fiy[l_ac].fiy04)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD fiy04
                END IF
            END IF
 
#TQC-990124 --begin--
        AFTER FIELD fiy05
            IF NOT cl_null(g_fiy[l_ac].fiy05) THEN
               IF g_fiy[l_ac].fiy05 < 0 THEN 
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD fiy05
               END IF
            END IF
#TQC-990124 --end--
 
        #No.TQC-920109 add --begin
        AFTER FIELD fiy06
            IF cl_null(g_fiy[l_ac].fiy06) THEN
               NEXT FIELD fiy06
            END IF
        #No.TQC-920109 add --end
 
        BEFORE DELETE                            #是否取消單身
           IF g_fiy_t.fiy02 > 0 AND g_fiy_t.fiy02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM fiy_file
               WHERE fiy01 = g_fio.fio01
                 AND fiy02 = g_fiy_t.fiy02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_fiy_t.fiy02,SQLCA.sqlcode,0)   #No.FUN-660092
                 CALL cl_err3("del","fiy_file",g_fio.fio01,g_fiy_t.fiy02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                 CANCEL DELETE
              END IF
              LET g_rec_b3=g_rec_b3-1
              DISPLAY g_rec_b3 TO FORMONLY.cn6
              COMMIT WORK
           END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fiy[l_ac].* = g_fiy_t.*
               CLOSE i102_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fiy[l_ac].fiy02,-263,1)
               LET g_fiy[l_ac].* = g_fiy_t.*
            ELSE
               UPDATE fiy_file SET fiy02 = g_fiy[l_ac].fiy02,
                                   fiy03 = g_fiy[l_ac].fiy03,
                                   fiy04 = g_fiy[l_ac].fiy04,
                                   fiy05 = g_fiy[l_ac].fiy05,
                                   fiy06 = g_fiy[l_ac].fiy06
                WHERE fiy01=g_fio.fio01
                  AND fiy02=g_fiy_t.fiy02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_fiy[l_ac].fiy02,SQLCA.sqlcode,0)   #No.FUN-660092
                  CALL cl_err3("upd","fiy_file",g_fio.fio01,g_fiy_t.fiy02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                  LET g_fiy[l_ac].* = g_fiy_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  UPDATE fio_file SET fiomodu=g_user,fiodate=g_today
                   WHERE fio01=g_fio.fio01
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_fiy[l_ac].* = g_fiy_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_fiy.deleteElement(l_ac)
                  IF g_rec_b3 != 0 THEN
                     LET g_action_choice = "detail"
                     LET g_action_flag = "sparepart_main"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i102_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i102_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(fiy03)
#FUN-AA0059 --Begin--
                # CALL cl_init_qry_var()
                # LET g_qryparam.form ="q_ima"
                # LET g_qryparam.default1 = g_fiy[l_ac].fiy03
                # CALL cl_create_qry() RETURNING g_fiy[l_ac].fiy03
                CALL q_sel_ima(FALSE, "q_ima", "", g_fiy[l_ac].fiy03, "", "", "", "" ,"",'' )  RETURNING g_fiy[l_ac].fiy03
#FUN-AA0059 --End--
              WHEN INFIELD(fiy04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_fiy[l_ac].fiy04
                 CALL cl_create_qry() RETURNING g_fiy[l_ac].fiy04
              OTHERWISE
                 EXIT CASE
        END CASE
 
        ON ACTION CONTROLN
           CALL i102_b3_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(fiy02) AND l_ac > 1 THEN
               LET g_fiy[l_ac].* = g_fiy[l_ac-1].*
               NEXT FIELD fiy02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CASE
              WHEN INFIELD(fiy02) CALL cl_fldhlp('fiy02')
              WHEN INFIELD(fiy03) CALL cl_fldhlp('fiy03')
              WHEN INFIELD(fiy04) CALL cl_fldhlp('fiy04')
              WHEN INFIELD(fiy05) CALL cl_fldhlp('fiy05')
              WHEN INFIELD(fiy05) CALL cl_fldhlp('fiy06')
              OTHERWISE          CALL cl_fldhlp('    ')
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("folder01","AUTO")                    
#No.FUN-6B0029--end                
 
    END INPUT
 
   #start FUN-5A0029
    LET g_fio.fiomodu = g_user
    LET g_fio.fiodate = g_today
   #end FUN-5A0029
    UPDATE fio_file SET fiomodu=g_fio.fiomodu,
                        fiodate=g_fio.fiodate
     WHERE fio01=g_fio.fio01
    DISPLAY BY NAME g_fio.fiomodu,g_fio.fiodate   #FUN-5A0029
 
    CLOSE i102_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i102_b_askkey()
    DEFINE l_wc2           LIKE type_file.chr1000      #No.FUN-680072CHAR(200)
 
    CONSTRUCT l_wc2 ON fip02,fip03
            FROM s_fip[1].fip02,s_fip[1].fip03
 
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
    CALL i102_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i102_b2_askkey()
    DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    CONSTRUCT l_wc2 ON fix02,fix03,fix04,fix05,fix06
            FROM s_fix[1].fix02,s_fix[1].fix03,s_fix[1].fix04,s_fix[1].fix05,
                 s_fix[1].fix06
 
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
    CALL i102_b2_fill(l_wc2)
END FUNCTION
 
FUNCTION i102_b3_askkey()
    DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    CONSTRUCT l_wc2 ON fiy02,fiy03,fiy04,fiy05,fiy06
            FROM s_fiy[1].fiy02,s_fiy[1].fiy03,s_fiy[1].fiy04,s_fiy[1].fiy05,
                 s_fiy[1].fiy06
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
    CALL i102_b3_fill(l_wc2)
END FUNCTION
 
FUNCTION i102_b2_fill(p_wc2)
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
    LET g_sql = "SELECT fix02,fix03,'',fix04,fix05,fix06",
                "  FROM fix_file",
                " WHERE fix01 ='",g_fio.fio01,"'",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY fix02"
    PREPARE i102_pb2 FROM g_sql
    DECLARE fix_curs CURSOR FOR i102_pb2
 
    CALL g_fix.clear()
    LET g_rec_b2=0
    LET g_cnt = 1
    FOREACH fix_curs INTO g_fix[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      CALL i102_fix03('d',g_cnt)
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_fix.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn4
END FUNCTION
 
FUNCTION i102_b_fill(p_wc2)
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    LET g_sql = "SELECT fip02,fip03,fid02,fid03,fid04",
                "  FROM fip_file LEFT OUTER JOIN fid_file ON fip_file.fip03 = fid_file.fid01  ",
                " WHERE fip01 ='",g_fio.fio01,"'",
                "   AND fid01 = fip03 "
    #No.FUN-8B0123---Begin
    #           "   AND ",p_wc2 CLIPPED,
    #           " ORDER BY fip02"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY fip02" 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE i102_pb FROM g_sql
    DECLARE fip_curs CURSOR FOR i102_pb
 
    CALL g_fip.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH fip_curs INTO g_fip[g_cnt].*   #單身 ARRAY 填充
 
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
    # CALL i102_fip03('d')
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_fip.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
#No: FUN-540030 --start--
FUNCTION i102_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   #FUN-D40030--add--str--
   IF p_ud <> "G" OR g_action_choice = "detail" THEN  
      RETURN
   END IF
   #FUN-D40030--add--edn--
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fip TO s_fip.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      #No.FUN-540030 --start--
      ON ACTION user_main
         LET g_action_flag="user_main"
         EXIT DISPLAY
      ON ACTION sparepart_main
         LET g_action_flag="sparepart_main"
         EXIT DISPLAY
      #No.FUN-540030 ---end---
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
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION first
         CALL i102_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL i102_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL i102_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL i102_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL i102_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #No.FUN-540030 --start--
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
#     ON ACTION user_detail
#        LET g_action_choice="user_detail"
#        EXIT DISPLAY
#     ON ACTION spare_part_detail
#        LET g_action_choice="spare_part_detail"
#        EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      #No.FUN-540030 ---end---
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("folder01","AUTO")                    
#No.FUN-6B0029--end 
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i102_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   #FUN-D40030--add--str--
   IF p_ud <> "G" OR g_action_choice = "detail" THEN    
      RETURN
   END IF
   #FUN-D40030--add--edn-- 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fix TO s_fix.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      #No.FUN-540030 --start--
      ON ACTION task_main
         LET g_action_flag="task_main"
         EXIT DISPLAY
      ON ACTION sparepart_main
         LET g_action_flag="sparepart_main"
         EXIT DISPLAY
      #No.FUN-540030 ---end---
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
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION first
         CALL i102_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL i102_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL i102_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL i102_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL i102_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #No.FUN-540030 --start--
#     ON ACTION task_detail
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
#     ON ACTION user_detail
#        LET g_action_choice="user_detail"
#        EXIT DISPLAY
#     ON ACTION spare_part_detail
#        LET g_action_choice="spare_part_detail"
#        EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      #No.FUN-540030 ---end---
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("folder01","AUTO")                    
#No.FUN-6B0029--end             
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No: FUN-540030 ---end---
 
FUNCTION i102_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #No: FUN-540030 --start--
#  DISPLAY ARRAY g_fix TO s_fix.* ATTRIBUTE(COUNT=g_rec_b2)
#     BEFORE DISPLAY
#        EXIT DISPLAY
 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#
 #    ON ACTION about         #MOD-4C0121
 #       CALL cl_about()      #MOD-4C0121
#
 #    ON ACTION help          #MOD-4C0121
 #       CALL cl_show_help()  #MOD-4C0121
#
 #    ON ACTION controlg      #MOD-4C0121
 #       CALL cl_cmdask()     #MOD-4C0121
#
 
#  END DISPLAY
 
#  DISPLAY ARRAY g_fip TO s_fip.* ATTRIBUTE(COUNT=g_rec_b)
#     BEFORE DISPLAY
#        EXIT DISPLAY
 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#
 #    ON ACTION about         #MOD-4C0121
 #       CALL cl_about()      #MOD-4C0121
#
 #    ON ACTION help          #MOD-4C0121
 #       CALL cl_show_help()  #MOD-4C0121
#
 #    ON ACTION controlg      #MOD-4C0121
 #       CALL cl_cmdask()     #MOD-4C0121
#
 
#  END DISPLAY
   #No: FUN-540030 ---end---
   DISPLAY ARRAY g_fiy TO s_fiy.* ATTRIBUTE(COUNT=g_rec_b3)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      #No: FUN-540030 --start--
      ON ACTION task_main
         LET g_action_flag="task_main"
         EXIT DISPLAY
      ON ACTION user_main
         LET g_action_flag="user_main"
         EXIT DISPLAY
      #No: FUN-540030 ---end---
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
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION first
         CALL i102_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL i102_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL i102_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL i102_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL i102_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 作業維護
      #No.FUN-540030 --start--
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      #@ON ACTION 人員維護
#     ON ACTION user_detail
#        LET g_action_choice="user_detail"
#        EXIT DISPLAY
#     #@ON ACTION 備件維護
#     ON ACTION spare_part_detail
#        LET g_action_choice="spare_part_detail"
#        EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      #No.FUN-540030 ---end---
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("folder01","AUTO")                    
#No.FUN-6B0029--end              
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i102_b3_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
    LET g_sql = "SELECT fiy02,fiy03,ima02,fiy04,fiy05,fiy06 ",
                " FROM fiy_file LEFT OUTER JOIN ima_file ON fiy_file.fiy03=ima_file.ima01 ",
                " WHERE fiy01 ='",g_fio.fio01,"'",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY fiy02"
    PREPARE i102_pb3 FROM g_sql
    DECLARE fiy_curs CURSOR FOR i102_pb3
 
    CALL g_fiy.clear()
    LET g_cnt = 1
    FOREACH fiy_curs INTO g_fiy[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
           CALL cl_err('','9035',0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fiy.deleteElement(g_cnt)
    LET g_rec_b3 = g_cnt-1
    DISPLAY g_rec_b3 TO FORMONLY.cn6
END FUNCTION
 
FUNCTION i102_x()
   IF s_shut(0) THEN RETURN END IF
   IF g_fio.fio01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_fio.* FROM fio_file
    WHERE fio01=g_fio.fio01
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN i102_cl USING g_fio.fio01
   IF STATUS THEN
      CALL cl_err("OPEN i102_cl:", STATUS, 1)   
      CLOSE i102_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i102_cl INTO g_fio.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_fio.fio01,SQLCA.sqlcode,0)          #資料被他人LOCK
       ROLLBACK WORK
       RETURN
   END IF
   IF cl_exp(0,0,g_fio.fioacti) THEN
        LET g_chr=g_fio.fioacti
        IF g_fio.fioacti='Y' THEN
            LET g_fio.fioacti='N'
        ELSE
            LET g_fio.fioacti='Y'
        END IF
        UPDATE fio_file
            SET fioacti=g_fio.fioacti,
                fiomodu=g_user, fiodate=g_today
            WHERE fio01=g_fio.fio01
        IF STATUS=100 THEN
            CALL cl_err(g_fio.fio01,SQLCA.sqlcode,0)   
            LET g_fio.fioacti=g_chr
        END IF
        DISPLAY BY NAME g_fio.fioacti #ATTRIBUTE(RED)    #No.FUN-940135
    END IF
   CLOSE i102_cl
   COMMIT WORK
END FUNCTION
{
FUNCTION i102_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("fio01",TRUE)
    END IF
 
    IF INFIELD(fio03) THEN
      CALL cl_set_comp_entry("fio12,fio13",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i102_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fio01",FALSE)
    END IF
 
    IF INFIELD(fio03) THEN
       IF g_fio.fio03 != 'MISC' AND g_fio.fio03 != 'EMPL' THEN
          CALL cl_set_comp_entry("fio12",FALSE)
       END IF
       IF g_fio.fio03 != 'MISC' THEN
          CALL cl_set_comp_entry("fio13",FALSE)
       END IF
    END IF
 
END FUNCTION
 
FUNCTION i102_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   CALL cl_set_comp_entry("fix03",TRUE)
 
END FUNCTION
 
FUNCTION i102_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    IF g_apz.apz26 = 'N' THEN
       CALL cl_set_comp_entry("fix03",FALSE)
    END IF
 
END FUNCTION
}
FUNCTION i102_copy()
DEFINE
    l_newno         LIKE fio_file.fio01,
    l_oldno         LIKE fio_file.fio01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fio.fio01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    LET g_before_input_done = FALSE
    CALL i102_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029
 
    INPUT l_newno FROM fio01
        AFTER FIELD fio01
            IF l_newno IS NULL THEN
                NEXT FIELD fio01
            END IF
            SELECT COUNT(*) INTO g_cnt FROM fio_file WHERE fio01 = l_newno
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD fio01
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
    IF INT_FLAG OR l_newno IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM fio_file
        WHERE fio01=g_fio.fio01
        INTO TEMP y
    UPDATE y
        SET y.fio01=l_newno,    #資料鍵值
            y.fiouser = g_user,
            y.fiogrup = g_grup,
            y.fiodate = g_today,
            y.fioacti = 'Y'
    INSERT INTO fio_file  #復制單頭
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_newno,SQLCA.sqlcode,0) #No.FUN-660092
       CALL cl_err3("ins","fio_file",l_newno,"",SQLCA.sqlcode,"","",1) #No.FUN-660092
    END IF
    DROP TABLE x
    SELECT * FROM fip_file
       WHERE fip01 = g_fio.fio01
       INTO TEMP x
    UPDATE x
       SET fip01 = l_newno
    INSERT INTO fip_file    #復制單身
       SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL  cl_err(l_newno,SQLCA.sqlcode,0) #No.FUN-660092
       CALL cl_err3("ins","fip_file",l_newno,g_fip_t.fip02,SQLCA.sqlcode,"","",1) #No.FUN-660092
    END IF
    DROP TABLE y
    SELECT * FROM fix_file
       WHERE fix01 = g_fio.fio01
       INTO TEMP y
    UPDATE y
       SET fix01 = l_newno
    INSERT INTO fix_file    #復制單身
       SELECT * FROM y
    IF SQLCA.sqlcode THEN
#      CALL  cl_err(l_newno,SQLCA.sqlcode,0) #No.FUN-660092
       CALL cl_err3("ins","fix_file",l_newno,g_fix_t.fix02,SQLCA.sqlcode,"","",1)  #No.FUN-660092    
    END IF
    DROP TABLE z
    SELECT * FROM fiy_file
       WHERE fiy01 = g_fio.fio01
       INTO TEMP z
    UPDATE z
       SET fiy01 = l_newno
    INSERT INTO fiy_file    #復制單身
       SELECT * FROM z
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("ins","fiy_file",l_newno,g_fiy_t.fiy02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K' ATTRIBUTE(REVERSE)
        LET l_oldno = g_fio.fio01
        SELECT fio_file.* INTO g_fio.* FROM fio_file
               WHERE fio01 =  l_newno
        CALL i102_u()
        CALL i102_b()
        CALL i102_b2()
        CALL i102_b3()
        #FUN-C30027---begin
        #LET g_fio.fio01 = l_oldno
        #SELECT fio_file.* INTO g_fio.* FROM fio_file
        #       WHERE fio01 = g_fio.fio01
        #CALL i102_show()
        #FUN-C30027---end
    END IF
    DISPLAY BY NAME g_fio.fio01
END FUNCTION
 
FUNCTION i102_out()
DEFINE
    l_i             LIKE type_file.num5,           #No.FUN-680072 SMALLINT
    sr              RECORD
        fio01       LIKE fio_file.fio01,
        fio02       LIKE fio_file.fio02,
        fio05       LIKE fio_file.fio05,
        desc        LIKE type_file.chr8,           #No.FUN-680072CHAR(8)
        fio06       LIKE fio_file.fio06,
        fiu02       LIKE fiu_file.fiu02,
        fio07       LIKE fio_file.fio07,
        fja02       LIKE fja_file.fja02,
        fio03       LIKE fio_file.fio03,
        fio04       LIKE fio_file.fio04,
        fio08       LIKE fio_file.fio08,
        fip02       LIKE fip_file.fip02,
        fip03       LIKE fip_file.fip03,
        fid02       LIKE fid_file.fid02,
        fid03       LIKE fid_file.fid03,
        fid04       LIKE fid_file.fid04
       END RECORD,
    l_name          LIKE type_file.chr20,                              #No.FUN-680072 VARCHAR(20)
    l_za05          LIKE type_file.chr1000,                            #No.FUN-680072 VARCHAR(40)
    l_sql           LIKE type_file.chr1000       #No.FUN-760085                          
#   IF g_wc IS NULL THEN
#      CALL cl_err('','9057',0) RETURN
#   END IF
    IF cl_null(g_wc) AND NOT cl_null(g_fio.fio01) THEN
       LET g_wc = " fio01 = '",g_fio.fio01,"' "
    END IF
    IF cl_null(g_wc2) THEN LET g_wc2 = " 1= 1 " END IF
    IF cl_null(g_wc3) THEN LET g_wc3 = " 1= 1 " END IF
    IF cl_null(g_wc4) THEN LET g_wc4 = " 1= 1 " END IF
    CALL cl_wait()
#   CALL cl_outnam('aemi102') RETURNING l_name        #No.FUN-760085
    CALL cl_del_data(l_table)                         #No.FUN-760085
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT fio01,fio02,fio05,'',fio06,fiu02,fio07,fja02,",
              "       fio03,fio04,fio08,fip02,fip03,fid02,fid03,fid04 ",
              "  FROM fio_file,fip_file,OUTER fiu_file,OUTER fja_file, ",
              " OUTER fid_file ",
              " WHERE fip01 = fio01 AND fio_file.fio06 = fiu_file.fiu01 ",
              "   AND fio_file.fio07 = fja_file.fja01 AND fip_file.fip03 = fid_file.fid01 AND ",g_wc CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY fio01"
    PREPARE i102_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i102_co CURSOR FOR i102_p1
 
#   START REPORT i102_rep TO l_name           #No.FUN-760085
 
    FOREACH i102_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        CASE sr.fio05
             WHEN  '1' CALL cl_getmsg('axd-051',g_lang) RETURNING sr.desc
             WHEN  '2' CALL cl_getmsg('axd-052',g_lang) RETURNING sr.desc
             OTHERWISE  LET sr.desc = ''
        END CASE
    #No.FUN-760085---Begin  
    #   OUTPUT TO REPORT i102_rep(sr.*)
        EXECUTE insert_prep USING sr.fio01,sr.fio02,sr.fio05,sr.desc,sr.fio06,
                                  sr.fiu02,sr.fio07,sr.fja02,sr.fio03,sr.fio03,
                                  sr.fio08,sr.fip02,sr.fip03,sr.fid02,sr.fid03,
                                  sr.fid04
    #No.FUN-760085---End
    END FOREACH
 
    #No.FUN-760085---Begin
  # FINISH REPORT i102_rep
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'fio01,fio02,fio03,fio04,fio05,fio06,fio07,fio08')         
            RETURNING g_wc                                                     
       LET g_str = g_wc                                                        
    END IF
    LET g_str = g_wc                                                        
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED 
    CLOSE i102_co
    ERROR ""
  # CALL cl_prt(l_name,' ','1',g_len)
    CALL cl_prt_cs3('aemi102','aemi102',l_sql,g_str)
    #No.FUN-760085---End
END FUNCTION
 
#No.FUN-760085---Begin
{
REPORT i102_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680072CHAR(1)
    l_i             LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    sr              RECORD
        fio01       LIKE fio_file.fio01,
        fio02       LIKE fio_file.fio02,
        fio05       LIKE fio_file.fio05,
        desc        LIKE type_file.chr8,          #No.FUN-680072CHAR(8)
        fio06       LIKE fio_file.fio06,
        fiu02       LIKE fiu_file.fiu02,
        fio07       LIKE fio_file.fio07,
        fja02       LIKE fja_file.fja02,
        fio03       LIKE fio_file.fio03,
        fio04       LIKE fio_file.fio04,
        fio08       LIKE fio_file.fio08,
        fip02       LIKE fip_file.fip02,
        fip03       LIKE fip_file.fip03,
        fid02       LIKE fid_file.fid02,
        fid03       LIKE fid_file.fid03,
        fid04       LIKE fid_file.fid04
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.fio01,sr.fip02
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<', "/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1, g_x[1]
            PRINT
            PRINT g_dash[1,g_len]
            PRINT g_x[31], g_x[32], g_x[33], g_x[34],
                  g_x[35], g_x[36], g_x[37], g_x[38],
                  g_x[39], g_x[40], g_x[41], g_x[42],
                  g_x[43]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.fio01,
                  COLUMN g_c[32],sr.fio02,
                  COLUMN g_c[33],sr.fio05,sr.desc,
                  COLUMN g_c[34],sr.fio06,sr.fiu02,
                  COLUMN g_c[35],sr.fio07,sr.fja02,
                  COLUMN g_c[36],sr.fio03 USING '---&.&&&',
                  COLUMN g_c[37],sr.fio03 USING '---&.&&&',
                  COLUMN g_c[38],sr.fio08,
                  COLUMN g_c[39],sr.fip02 USING '<<<<<<',
                  COLUMN g_c[40],sr.fip03,
                  COLUMN g_c[41],sr.fid02,
                  COLUMN g_c[42],sr.fid03 USING '---&.&&&',
                  COLUMN g_c[43],sr.fid04 USING '---&.&&&'
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-760085---End
 
FUNCTION i102_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("fio01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i102_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("fio01",FALSE)
       END IF
   END IF
 
END FUNCTION
#Patch....NO.MOD-5A0095 <001,002,003,004,005,006> #
#Patch....NO.TQC-610035 <001> #
