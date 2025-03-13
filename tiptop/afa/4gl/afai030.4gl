# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afai030.4gl
# Descriptions...: 多部門折舊費用分攤維護
# Date & Author..: 96/04/22 BY Sophia
# Modify.........: 97/08/29 By Sophia分攤類別為'2'時變動分子科目不可輸入
# Modify.........: No.MOD-470515 04/07/23 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0019 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-4C0029 04/12/07 By Nicola cl_doc參數傳遞錯誤
# Modify.........: No.FUN-4C0059 04/12/08 By Smapmin 加入權限控管
# Modify.........: No.FUN-510035 05/01/25 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530521 05/03/26 By Smapmin B單身時,原顯示的
#                                                    折舊科目名稱會消失,ENTER後才會再出現
# Modify.........: NO.FUN-550034 05/05/23 By jackie 單據編號加大
# Modify.........: No.MOD-570162 05/08/03 By Smapmin informix無法進入單身
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: NO.FUN-590002 05/12/27By Monster radio type 應都要給預設值
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/23 By zhuying 多套帳修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION i030_q()一開始應清空g_fad.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6C0009 06/12/08 By Rayven 表頭位置調整
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740026 07/04/11 By mike    會計科目加帳套
# Modify.........: No.MOD-740175 07/04/23 By hongmei 修改多部門折舊分攤新增后的資料，無法維護單身的資料
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770033 07/07/25 By destiny 報表改為使用crystal report
# Modify.........: No.MOD-780227 07/08/22 By jamie 新增資料時，單身的序號亂跳號
# Modify.........: No.TQC-780082 07/08/24 By judy 修正多帳套修改時引起的錯誤
# Modify.........: No.TQC-7B0056 07/11/12 By Rayven  復制時，單頭“資產科目編號”與“資產科目編號二”不能開窗，且錄入任意值無控管
# Modify.........: No.MOD-7B0241 07/11/28 By Smapmin 整批複製後，分攤比率的資料跑到變動比率分子科目編號的欄位了。
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.MOD-830157 08/03/22 By Pengu "U"修改時應先判斷aza63='Y'才去判斷fad031是否為NULL
# Modify.........: No.MOD-860312 08/07/08 By Sarah 整批複製時,判斷資料有沒有重複應加上fad03,fad04當條件
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.MOD-920032 09/02/03 By Sarah 單身不可維護兩筆相同部門
# Modify.........: No.TQC-950163 09/05/26 By xiaofeizhu 資料無效時，不可刪除
# Modify.........: No.TQC-960349 09/06/26 By liuxqa分攤類型的值取錯.
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0013 09/10/15 By sabrina 當fad05=1(固定比率)時，單身fae08(分攤比率)允許輸入〝0〞
# Modify.........: No.FUN-9C0077 10/01/05 By baofei 程式精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30165 10/04/02 by houlia 沒有選擇多帳套時，資產科目二的資料不能錄入 
# Modify.........: No.MOD-A90156 10/09/24 by Dido 批次複製錯誤時應 CLOSE WINDOW  
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
# Modify.........: No:FUN-B40004 11/04/13 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60210 11/06/21 By zhangweib AFTER FIELD fad03後根财签進行有效性檢查
# Modify.........: No.MOD-BB0158 11/11/15 By Dido 複製時增加 fae10 設定值 
# Modify.........: No:FUN-BB0113 11/11/22 By xuxz      處理固資財簽二重測BUG
# Modify.........: No.FUN-BA0083 12/01/13 By Sakura 整批複製的QBE條件，增加選項"類別"
# Modify.........: No:TQC-C10113 12/01/30 By wujie 查询时增加oriu，orig栏位 

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C40127 12/04/18 by Elise 類別為2財簽二時，單身折舊科目應參考afas010財簽二帳別(faa02c)
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-CB0030 12/11/05 By suncx 新增傳參，提供串聯查詢
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variafaes)
DEFINE
    g_fad           RECORD LIKE fad_file.*,       #資料年月 (假單頭)
    g_fad_t         RECORD LIKE fad_file.*,       #資料年月 (舊值)
    g_fad_o         RECORD LIKE fad_file.*,       #資料年月 (舊值)
    g_fae07         LIKE fae_file.fae07,
#   g_fae071        LIKE fae_file.fae071,         #FUN-680028   #No:FUN-AB0088 Mark
    g_fad07_t       LIKE fad_file.fad07,   #No:FUN-AB0088
    g_fad01_t       LIKE fad_file.fad01,          #
    g_fad02_t       LIKE fad_file.fad02,          #
    g_fad03_t       LIKE fad_file.fad03,          #
#   g_fad031_t      LIKE fad_file.fad031,         #FUN-680028   #No:FUN-AB0088 Mark
    g_fad04_t       LIKE fad_file.fad04,          #
    g_aaa           RECORD LIKE aaa_file.*,
    g_fae           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variafaes)
        fae05       LIKE fae_file.fae05,   #項次
        fae06       LIKE fae_file.fae06,   #分攤部門
        fae07       LIKE fae_file.fae07,   #折舊科目
        aag02_1     LIKE aag_file.aag02,   #科目名稱
   #    fae071      LIKE fae_file.fae071,  #FUN-680028     #No:FUN-AB0088 Mark
   #    aag02_11    LIKE aag_file.aag02,   #FUN-680028     #No:FUN-AB0088 Mark
        fae08       LIKE fae_file.fae08,   #分攤比率
        fae09       LIKE fae_file.fae09,   #變動比率分子科目
        aag02_2     LIKE aag_file.aag02    #子科目名稱
                    END RECORD,
    g_fae_t         RECORD                 #程式變數 (舊值)
        fae05       LIKE fae_file.fae05,   #項次
        fae06       LIKE fae_file.fae06,   #分攤部門
        fae07       LIKE fae_file.fae07,   #折舊科目
        aag02_1     LIKE aag_file.aag02,   #科目名稱
   #    fae071      LIKE fae_file.fae071,  #FUN-680028     #No:FUN-AB0088 Mark
   #    aag02_11    LIKE aag_file.aag02,   #FUN-680028     #No:FUN-AB0088 Mark
        fae08       LIKE fae_file.fae08,   #分攤比率
        fae09       LIKE fae_file.fae09,   #變動比率分子科目
        aag02_2     LIKE aag_file.aag02    #子科目名稱
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING   , #TQC-630166
    g_t1            LIKE type_file.chr5,        #No.FUN-550034          #No.FUN-680070 VARCHAR(5)
    g_statu         LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,                #單身筆數       #No.FUN-680070 SMALLINT
    g_cmd           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_str1          LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
DEFINE   g_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_bookno1       LIKE aza_file.aza81         #No.FUN-740026
DEFINE   g_bookno2       LIKE aza_file.aza82         #No.FUN-740026 
DEFINE   g_flag          LIKE type_file.chr1        #No.FUN-740026 
DEFINE   g_str           STRING                     #No.FUN-770033                                                                          
DEFINE   l_table         STRING                     #No.FUN-770033  
#No.MOD-CB0030  --Begin
DEFINE g_argv1  STRING    #g_wc查询条件
#No.MOD-CB0030  --End

MAIN
DEFINE
    l_sql               LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
DEFINE p_row,p_col      LIKE type_file.num5         #No.FUN-680070 SMALLINT
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
    IF INT_FLAG THEN EXIT PROGRAM END IF
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
        RETURNING g_time                                                       #NO.FUN-6A0069
   #No.MOD-CB0030  --Begin
   LET g_argv1 = ARG_VAL(1)     #g_wc查询条件
   #No.MOD-CB0030  --End
    LET g_sql="fad01.fad_file.fad01,",                                                                                              
              "fad02.fad_file.fad02,",                                                                                              
              "fad03.fad_file.fad03,",                                                                                              
              "fad031.fad_file.fad031,",                                                                                              
              "fad04.fad_file.fad04,",                                                                                              
              "fad05.fad_file.fad05,",                                                                                              
              "fae06.fae_file.fae06,",                                                                                              
              "fae07.fae_file.fae07,",                                                                                             
         #    "fae071.fae_file.fae071,",    #No:FUN-AB0088 Mark
              "fae08.fae_file.fae08,",
              "fae09.fae_file.fae09"                                                                                             
                                                                                                                                    
     LET l_table = cl_prt_temptable('afai030',g_sql) CLIPPED                                                                        
     IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                        
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,?,?,?,?,?,?)"                                                                                         
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                             
    END IF                                                                                                                          
 
    LET g_forupd_sql = " SELECT * FROM fad_file WHERE fad07 = ? AND fad01 = ? AND fad02 = ? AND fad03 = ? AND fad04 = ? ",
                      "  FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i030_cl CURSOR FROM g_forupd_sql
    LET p_row = 3 LET p_col = 3
    OPEN WINDOW i030_w AT p_row,p_col              #顯示畫面
          WITH FORM "afa/42f/afai030"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
   ##-----No:FUN-AB0088 Mark-----
   # IF g_aza.aza63 = 'Y' THEN
   #    CALL cl_set_comp_visible("fad031,aag021,fae071,aag02_11",TRUE)
   # ELSE
   #    CALL cl_set_comp_visible("fad031,aag021,fae071,aag02_11",FALSE)
   # END IF
   ##-----No:FUN-AB0088 Mark END-----
   #No.MOD-CB0030  --Begin
    IF NOT cl_null(g_argv1) THEN
       LET g_action_choice = "query"
       IF cl_chk_act_auth() THEN
          CALL i030_q()
       END IF
    END IF
    #No.MOD-CB0030  --End

    CALL i030_menu()
    CLOSE WINDOW i030_w                 #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                                               #NO.FUN-6A0069
END MAIN
 
#QBE 查詢資料
FUNCTION i030_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
  DEFINE   l_flag      LIKE type_file.chr1        #判斷單身是否給條件       #No.FUN-680070 VARCHAR(1)
    CLEAR FORM                             #清除畫面
   CALL g_fae.clear()
 
    LET l_flag = 'N'
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_fad.* TO NULL    #No.FUN-750051
   IF cl_null(g_argv1) THEN      #MOD-CB0030 add
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
     #  fad01,fad02,fad03,fad04,fad031,fad05,     #FUN-680028 
        fad07,fad01,fad02,fad03,fad04,fad05,     #FUN-680028     #No:FUN-AB0088 
        faduser,fadgrup,fadoriu,fadorig,fadmodu,faddate,fadacti  #No.TQC-C10113 add oriu,orig
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
           CASE
              WHEN INFIELD(fad03) #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fad03
                 NEXT FIELD fad03
           ##-----No:FUN-AB0088 Mark-----
           #   WHEN INFIELD(fad031)
           #      CALL cl_init_qry_var()
           #      LET g_qryparam.form = "q_aag"
           #      LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
           #      LET g_qryparam.state = "c"
           #      CALL cl_create_qry() RETURNING g_qryparam.multiret
           #      DISPLAY g_qryparam.multiret TO fad031
           #      NEXT FIELD fad031
           ##-----No:FUN-AB0088 Mark END-----
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
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('faduser', 'fadgrup')
 
 
  # CONSTRUCT g_wc2 ON fae05,fae06,fae07,fae071,fae08,fae09      #FUN-680028
  #         FROM s_fae[1].fae05,s_fae[1].fae06,s_fae[1].fae07,s_fae[1].fae071,    #FUN-680028
    CONSTRUCT g_wc2 ON fae05,fae06,fae07,fae08,fae09   #No:FUN-AB0088      #FUN-680028
            FROM s_fae[1].fae05,s_fae[1].fae06,s_fae[1].fae07,    #No:FUN-AB0088   #FUN-680028
                 s_fae[1].fae08,s_fae[1].fae09
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp
           CASE
            WHEN INFIELD(fae06)      #查詢部門資料
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fae06
                 NEXT FIELD fae06
 
            WHEN INFIELD(fae07)      #查詢科目代號不為統制帳戶'1'
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fae07
                 NEXT FIELD fae07
          ##-----No:FUN-AB0088 Mark----- 
          #  WHEN INFIELD(fae071)
          #       CALL cl_init_qry_var()
          #       LET g_qryparam.state = "c"
          #       LET g_qryparam.form = "q_aag"
          #       LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
          #       CALL cl_create_qry() RETURNING g_qryparam.multiret
          #       DISPLAY g_qryparam.multiret TO fae071
          #       NEXT FIELD fae071
          ##-----No:FUN-AB0088 Mark END-----

            WHEN INFIELD(fae09)      #查詢科目代號不為統制帳戶'1'
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fae09
                 NEXT FIELD fae09
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
 
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
    #MOD-CB0030 add begin---------
    ELSE
       LET g_wc=g_argv1
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('faduser', 'fadgrup')
    END IF
    #MOD-CB0030 add end-----------
    IF g_wc2 != " 1=1" THEN LET l_flag = 'Y' END IF
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF l_flag = 'N'  THEN  #若單身未輸入條件
       LET g_sql = " SELECT fad07,fad01,fad02,fad03,fad04 ",
                   " FROM fad_file",
                   " WHERE ", g_wc CLIPPED
    ELSE                    # 若單身有輸入條件
       LET g_sql = " SELECT DISTINCT fad07,fad01,fad02,fad03,fad04",
                   "  FROM fad_file, fae_file ",
                   " WHERE fad01 = fae01",
                   "   AND fad02 = fae02",
                   "   AND fad03 = fae03",
                   "   AND fad04 = fae04",
                   "   AND fae05 != 0   ",
                   "   AND fae10 = fad07",   #No:FUN-AB0088
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
    END IF
 
    PREPARE i030_prepare FROM g_sql
    DECLARE i030_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i030_prepare
 
    IF l_flag = 'N' THEN          #取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fad_file ",
                  " WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*)",
                  "  FROM fad_file,fae_file ",
                  " WHERE fad01 = fae01 ",
                  "   AND fad02 = fae02 ",
                  "   AND fad03 = fae03 ",
                  "   AND fad04 = fae04 ",
                  "   AND fae10 = fad07",   #No:FUN-AB0088
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i030_count_pre FROM g_sql
    DECLARE i030_count CURSOR FOR i030_count_pre #CKP
END FUNCTION
 
FUNCTION i030_menu()
 
   WHILE TRUE
      CALL i030_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i030_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i030_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i030_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i030_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i030_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i030_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i030_b(' ')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i030_out()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fad.fad01 IS NOT NULL THEN
                  LET g_doc.column1 = "fad01"
                  LET g_doc.value1 = g_fad.fad01
                  LET g_doc.column2 = "fad02"
                  LET g_doc.value2 = g_fad.fad02
                  LET g_doc.column3 = "fad03"
                  LET g_doc.value3 = g_fad.fad03
                  LET g_doc.column4 = "fad04"
                  LET g_doc.value4 = g_fad.fad04
                  LET g_doc.column5 = "fad07"   #No:FUN-AB0088
                  LET g_doc.value5 = g_fad.fad07   #No:FUN-AB0088
                  CALL cl_doc()
               END IF
            END IF
 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "batch_copy"
            IF cl_chk_act_auth() THEN
               CALL i030_g()
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fae),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i030_a()
DEFINE   l_str    LIKE type_file.chr20           #No.FUN-680070 VARCHAR(17)
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fae.clear()
    INITIALIZE g_fad.* LIKE fad_file.*             #DEFAULT 設定
    LET g_fad07_t = NULL   #No:FUN-AB0088
    LET g_fad01_t = NULL
    LET g_fad02_t = NULL
    LET g_fad03_t = NULL   
    LET g_fad04_t = NULL
 #  LET g_fad031_t= NULL          #FUN-680028   #No:FUN-AB0088 Mark
    LET g_fad_t.* = g_fad.*
    LET g_fad_o.* = g_fad.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fad.fad07 = '1'   #No:FUN-AB0088
        LET g_fad.fad05 = '1'
        LET g_fad.faduser=g_user
        LET g_fad.fadoriu = g_user #FUN-980030
        LET g_fad.fadorig = g_grup #FUN-980030
        LET g_fad.fadgrup=g_grup
        LET g_fad.faddate=g_today
        LET g_fad.fadacti='Y'              #資料有效
        CALL i030_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            INITIALIZE g_fad.* TO NULL
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        INSERT INTO fad_file VALUES (g_fad.*)
        IF SQLCA.sqlcode THEN               #置入資料庫不成功
            CALL cl_err3("ins","fad_file",g_fad.fad02,g_fad.fad03,SQLCA.sqlcode,"","Add:",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        LET g_fad_t.* = g_fad.*
        LET g_rec_b=0
        SELECT fad01,fad02,fad03,fad04 INTO g_fad.fad01,g_fad.fad02,g_fad.fad03,g_fad.fad04 FROM fad_file
            WHERE fad01 = g_fad.fad01
              AND fad02 = g_fad.fad02
              AND fad03 = g_fad.fad03
              AND fad04 = g_fad.fad04
              AND fad07 = g_fad.fad07   #No:FUN-AB0088
        LET g_fad07_t = g_fad.fad07   #No:FUN-AB0088
        LET g_fad01_t = g_fad.fad01        #保留舊值                                                                                
        LET g_fad02_t = g_fad.fad02                                                                                                 
        LET g_fad03_t = g_fad.fad03        #保留舊值                                                                                
  #     LET g_fad031_t= g_fad.fad031       #FUN-680028           #No:FUN-AB0088 Mark                                                                   
        LET g_fad04_t = g_fad.fad04 
        LET g_fad_t.* = g_fad.*            #FUN-680028
        LET g_fad_o.* = g_fad.*            #FUN-680028
        CALL g_fae.clear()                 #FUN-680028
 
        CALL i030_b('a')                   #輸入單身
 
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i030_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fad.fad01 IS NULL OR
       g_fad.fad02 IS NULL OR
       g_fad.fad03 IS NULL OR
       g_fad.fad04 IS NULL OR
       g_fad.fad07 IS NULL THEN   #No:FUN-AB0088 
        CALL cl_err('',-400,0)
        RETURN
    END IF
 ##-----No:FUN-AB0088 Mark-----
 #   IF g_aza.aza63 = 'Y' AND g_fad.fad031 IS NULL THEN   
 #      CALL cl_err('',-400,0)
 #      RETURN
 #   END IF     
 ##-----No:FUN-AB0088 Mark END-----

    SELECT * INTO g_fad.* FROM fad_file WHERE fad01 = g_fad.fad01
                                          AND fad02 = g_fad.fad02
                                          AND fad03 = g_fad.fad03
                                     #    AND fad031= g_fad.fad031       #FUN-680028 #TQC-780082 mark
                                          AND fad04 = g_fad.fad04
                                          AND fad07 = g_fad.fad07   #No:FUN-AB0088
    IF g_fad.fadacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err3("sel","fad_file",g_fad.fad02,g_fad.fad03,"9027","","",1)  #No.FUN-660136
       RETURN                                                                
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fad07_t = g_fad.fad07   #No:FUN-AB0088
    LET g_fad01_t = g_fad.fad01
    LET g_fad02_t = g_fad.fad02
    LET g_fad03_t = g_fad.fad03
 #  LET g_fad031_t= g_fad.fad031            #FUN-680028  #No:FUN-AB0088 Mark
    LET g_fad04_t = g_fad.fad04
    LET g_fad_o.* = g_fad.*
    BEGIN WORK
 
    OPEN i030_cl USING g_fad.fad07,g_fad.fad01,g_fad.fad02,g_fad.fad03,g_fad.fad04
    IF STATUS THEN
       CALL cl_err("OPEN i030_cl:", STATUS, 1)
       CLOSE i030_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i030_cl INTO g_fad.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fad.fad01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i030_cl ROLLBACK WORK RETURN
    END IF
    CALL i030_show()
    WHILE TRUE
        LET g_fad01_t = g_fad.fad01
        LET g_fad02_t = g_fad.fad02
        LET g_fad03_t = g_fad.fad03
    #   LET g_fad031_t= g_fad.fad031          #FUN-680028    #No:FUN-AB0088 Mark
        LET g_fad04_t = g_fad.fad04
        LET g_fad.fadmodu=g_user
        LET g_fad.faddate=g_today
        CALL i030_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fad.*=g_fad_t.*
            CALL i030_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_fad.fad01 != g_fad_t.fad01 OR                  # 更改單號
           g_fad.fad02 != g_fad_t.fad02 OR                  # 更改單號
        #  g_fad.fad031!= g_fad_t.fad031 OR                 #FUN-680028  #No:FUN-AB0088 Mark
           g_fad.fad04 != g_fad_t.fad04  OR                 # 更改單號
           g_fad.fad07 != g_fad_t.fad07 THEN    #No:FUN-AB0088
            UPDATE fae_file SET fae01 = g_fad.fad01,
                                fae02 = g_fad.fad02,
                           #    fae03 = g_fad.fad031,       #FUN-680028  #No:FUN-AB0088 Mark
                                fae04 = g_fad.fad04,
                                fae10 = g_fad.fad07   #No:FUN-AB0088
                WHERE fae01 = g_fad_t.fad01 AND fae02 = g_fad_t.fad02
                  AND fae04 = g_fad_t.fad04
                  AND fae10 = g_fad_t.fad07   #No:FUN-AB0088
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","fae_file",g_fad_t.fad02,g_fad_t.fad03,SQLCA.sqlcode,"","fae",1)  #No.FUN-660136
                CONTINUE WHILE                                         
            END IF
        END IF
        UPDATE fad_file SET fad_file.* = g_fad.*
 WHERE fad01 = g_fad01_t AND fad02 = g_fad02_t AND fad03 = g_fad03_t AND fad04 = g_fad04_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","fad_file",g_fad02_t,g_fad03_t,SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE                                   
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i030_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i030_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
    l_aca02         LIKE azn_file.azn02,
    l_azn04         LIKE azn_file.azn04,
    l_direct        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
   ,l_cmd           LIKE faa_file.faa02c  #TQC-B60210   Add
 
    DISPLAY BY NAME g_fad.faduser,g_fad.fadgrup,g_fad.fadmodu,g_fad.faddate,
                    g_fad.fadacti
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0029
  
    INPUT BY NAME g_fad.fadoriu,g_fad.fadorig,
     #  g_fad.fad01,g_fad.fad02,g_fad.fad03,g_fad.fad04,g_fad.fad031,g_fad.fad05,          #FUN-680028
        g_fad.fad07,g_fad.fad01,g_fad.fad02,g_fad.fad03,g_fad.fad04,g_fad.fad05,   #No:FUN-AB0088          #FUN-680028
        g_fad.faduser,g_fad.fadgrup,g_fad.fadmodu,
        g_fad.faddate,g_fad.fadacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i030_set_entry(p_cmd)
            CALL i030_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
        AFTER FIELD fad01
            IF NOT cl_null(g_fad.fad01) THEN
               CALL s_get_bookno(g_fad.fad01)  RETURNING g_flag,g_bookno1,g_bookno2
               IF g_flag='1' THEN #抓不到帳套
                   CALL cl_err(g_fad.fad01,'aoo-081',1)
                   NEXT FIELD fad01
               END IF
            END IF
        AFTER FIELD fad02
            IF NOT cl_null(g_fad.fad02) THEN
               IF (g_fad.fad02 < 1 OR g_fad.fad02 > 13) THEN
                  LET g_fad.fad02 = g_fad_o.fad02
                  DISPLAY BY NAME g_fad.fad02
                  NEXT FIELD fad02
               END IF
            END IF
            LET g_fad_o.fad02 = g_fad.fad02
 
        AFTER FIELD fad03
            IF NOT cl_null(g_fad.fad03) THEN
               #TQC-B60210   ---start   Add
               IF g_fad.fad07='1' THEN
                  LET l_cmd = g_bookno1
               ELSE
                  LET l_cmd = g_faa.faa02c
               END IF
               #TQC-B60210   ---end     Add
               CALL i030_fad03('a',l_cmd)     #No.FUN-740026   #TQC-B60210   g_bookno1  --> l_cmd
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_fad.fad03  
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = l_cmd       #TQC-B60210   g_bookno1  --> l_cmd 
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_fad.fad03 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_fad.fad03
                  DISPLAY BY NAME g_fad.fad03  
                  #FUN-B10049--end                      
                  NEXT FIELD fad03
               END IF
            END IF
            LET g_fad_o.fad03 = g_fad.fad03

     ##-----No:FUN-AB0088 Mark-----
     #   AFTER FIELD fad031
     #       IF NOT cl_null(g_fad.fad031) THEN
     #          CALL i030_fad031('a',g_bookno2)  #No.FUN-740026 
     #          IF NOT cl_null(g_errno) THEN
     #             CALL cl_err('',g_errno,0)
     #             #FUN-B10049--begin
     #             CALL cl_init_qry_var()                                         
     #             LET g_qryparam.form ="q_aag"                                   
     #             LET g_qryparam.default1 = g_fad.fad031  
     #             LET g_qryparam.construct = 'N'                
     #             LET g_qryparam.arg1 = g_bookno2 
     #             LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_fad.fad031 CLIPPED,"%' "                                                                        
     #             CALL cl_create_qry() RETURNING g_fad.fad031
     #             DISPLAY BY NAME g_fad.fad031  
     #             #FUN-B10049--end                     
     #             NEXT FIELD fad031
     #          END IF
     #       END IF
     #       LET g_fad_o.fad031 = g_fad.fad031
     ##-----No:FUN-AB0088 Mark END-----

        AFTER FIELD fad04
            IF NOT cl_null(g_fad.fad04) THEN
               IF g_fad.fad01 != g_fad_t.fad01 OR
                  g_fad_t.fad01 IS NULL THEN
                  SELECT COUNT(*) INTO g_cnt FROM fad_file
                   WHERE fad01 = g_fad.fad01
                     AND fad02 = g_fad.fad02
                     AND fad03 = g_fad.fad03
                     AND fad04 = g_fad.fad04
                     AND fad07 = g_fad.fad07   #No:FUN-AB0088
                  IF g_cnt > 0 THEN
                     CALL cl_err('',-239,0)           #資料重複
                     LET g_fad.fad04 = g_fad_t.fad04
                     DISPLAY BY NAME g_fad.fad04
                     NEXT FIELD fad04
                  END IF
               END IF
            END IF
            LET g_fad_o.fad04 = g_fad.fad04
 
        AFTER FIELD fad05
            IF NOT cl_null(g_fad.fad05) THEN
               IF g_fad.fad05 NOT MATCHES '[1-2]' THEN
                  NEXT FIELD fad05
               END IF
            END IF
 
        AFTER INPUT    #97/05/22 modify
           LET g_fad.faduser = s_get_data_owner("fad_file") #FUN-C10039
           LET g_fad.fadgrup = s_get_data_group("fad_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp   #ok
           CASE
              WHEN INFIELD(fad03) #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
                 LET g_qryparam.default1 = g_fad.fad03
                 #-----No:FUN-AB0088-----
                 IF g_fad.fad07='1' THEN
                    LET g_qryparam.arg1=g_bookno1  #No:FUN-740026
                 ELSE
                    LET g_qryparam.arg1 = g_faa.faa02c
                 END IF
                 #-----No:FUN-AB0088 END-----
     
                 CALL cl_create_qry() RETURNING g_fad.fad03
                 DISPLAY BY NAME g_fad.fad03
                 NEXT FIELD fad03

          ##-----No:FUN-AB0088 Mark-----
          #    WHEN INFIELD(fad031)
          #       CALL cl_init_qry_var()
          #       LET g_qryparam.form = "q_aag"
          #       LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
          #       LET g_qryparam.default1 = g_fad.fad031
          #       LET g_qryparam.arg1=g_bookno2  #No.FUN-740026 
          #       CALL cl_create_qry() RETURNING g_fad.fad031
          #       DISPLAY BY NAME g_fad.fad031
          #       NEXT FIELD fad031
          ##-----No:FUN-AB0088 Mark END-----

           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
        
 
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
FUNCTION i030_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fad07,fad01,fad02,fad03,fad04",TRUE)    #No:FUN-AB0088
    END IF                                         
 
END FUNCTION
FUNCTION i030_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fad07,fad01,fad02,fad03,fad04",FALSE)    #No:FUN-AB0088
    END IF                                         
 
    #-----No:FUN-AB0088-----
   IF g_faa.faa31='N' THEN
      CALL cl_set_comp_entry("fad07",FALSE)
   END IF
   #-----No:FUN-AB0088 END-----

END FUNCTION
 
FUNCTION i030_fad03(p_cmd,p_bookno)                #No.FUN-740026
DEFINE
    p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    p_bookno        LIKE aag_file.aag00,  #No.FUN-740026 
    l_aagacti       LIKE aag_file.aagacti,
    l_aag02         LIKE aag_file.aag02
 
    LET g_errno = ' '
    LET l_aag02=' '
    SELECT aag02,aagacti        #GENERO
        INTO l_aag02,l_aagacti
        FROM aag_file
        WHERE aag01 = g_fad.fad03
         AND  aag00 = p_bookno     #No.FUN-740026 
    CASE WHEN STATUS=100          LET g_errno = 'afa-085'  #No.7926
         WHEN l_aagacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    DISPLAY l_aag02 TO FORMONLY.aag02
END FUNCTION

##-----No:FUN-AB0088 Mark----- 
#FUNCTION i030_fad031(p_cmd,p_bookno)   #No.FUN-740026    #No.FUN-740026 
#DEFINE
#    p_cmd            LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#    p_bookno         LIKE aag_file.aag00,  #No.FUN-740026 
#    l_aagacti        LIKE aag_file.aagacti,
#    l_aag02          LIKE aag_file.aag02
# 
#    LET g_errno = ' '
#    LET l_aag02 = ' '
#    SELECT aag02,aagacti
#      INTO l_aag02,l_aagacti
#      FROM aag_file
#     WHERE aag01 = g_fad.fad031
#      AND  aag00 = p_bookno   #No.FUN-740026 
#    CASE WHEN STATUS=100     LET g_errno = 'afa-085'
#         WHEN l_aagacti='N'  LET g_errno = '9028'
#         OTHERWISE           LET g_errno = SQLCA.sqlcode USING '-------'
#    END CASE
#    DISPLAY l_aag02 TO FORMONLY.aag021
#END FUNCTION
##-----No:FUN-AB0088 Mark END-----

#Query 查詢
FUNCTION i030_q()
DEFINE
     l_fad01      LIKE fad_file.fad01,
     l_fad02      LIKE fad_file.fad02,
     l_fad03      LIKE fad_file.fad03,
#    l_fad031     LIKE fad_file.fad031,         #FUN-680028   #No:FUN-AB0088 Mark
     l_fad04      LIKE fad_file.fad04
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fad.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_fae.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i030_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i030_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fad.* TO NULL
    ELSE
        OPEN i030_count
        FETCH i030_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i030_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i030_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i030_cs INTO g_fad.fad07,g_fad.fad01,g_fad.fad02,g_fad.fad03,g_fad.fad04
        WHEN 'P' FETCH PREVIOUS i030_cs INTO g_fad.fad07,g_fad.fad01,g_fad.fad02,g_fad.fad03,g_fad.fad04
        WHEN 'F' FETCH FIRST    i030_cs INTO g_fad.fad07,g_fad.fad01,g_fad.fad02,g_fad.fad03,g_fad.fad04
        WHEN 'L' FETCH LAST     i030_cs INTO g_fad.fad07,g_fad.fad01,g_fad.fad02,g_fad.fad03,g_fad.fad04
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
         FETCH ABSOLUTE g_jump  i030_cs INTO g_fad.fad07,g_fad.fad01,g_fad.fad02,g_fad.fad03,g_fad.fad04
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fad.fad01,SQLCA.sqlcode,0)
        INITIALIZE g_fad.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_fad.* FROM fad_file WHERE fad07=g_fad.fad07 AND fad01 = g_fad.fad01 AND fad02 = g_fad.fad02 AND fad03 = g_fad.fad03 AND fad04 = g_fad.fad04
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","fad_file",g_fad.fad01,g_fad.fad02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
        INITIALIZE g_fad.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fad.faduser  #FUN-4C0059
    LET g_data_group = g_fad.fadgrup  #FUN-4C0059
    CALL s_get_bookno(g_fad.fad01)  RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag='1' THEN  #抓不到帳套
       CALL cl_err(g_fad.fad01,'aoo-081',1)
    END IF
    CALL i030_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i030_show()
    LET g_fad_t.* = g_fad.*                #保存單頭舊值
    DISPLAY BY NAME                         # 顯示單頭值
        g_fad.fad07,g_fad.fad01,g_fad.fad02,g_fad.fad03,
        g_fad.fad04,g_fad.fad05,         #FUN-680028   #No:FUN-AB0088
        g_fad.fadoriu,g_fad.fadorig,
        g_fad.faduser,g_fad.fadgrup,
        g_fad.fadmodu,g_fad.faddate,g_fad.fadacti
 
    CALL i030_fad03('d',g_bookno1)      #No.FUN-740026 
 #  CALL i030_fad031('d',g_bookno2)      #No.FUN-740026 #No:FUN-AB0088 Mark
    CALL i030_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i030_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_fad.fad01 IS NULL OR
       g_fad.fad02 IS NULL OR
       g_fad.fad03 IS NULL OR
       g_fad.fad04 IS NULL OR
       g_fad.fad07 IS NULL THEN   #No:FUN-AB0088
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i030_cl USING g_fad.fad07,g_fad.fad01,g_fad.fad02,g_fad.fad03,g_fad.fad04
    IF STATUS THEN
       CALL cl_err("OPEN i030_cl:", STATUS, 1)
       CLOSE i030_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i030_cl INTO g_fad.*           # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fad.fad01,SQLCA.sqlcode,0)        #資料被他人LOCK
        CLOSE i030_cl ROLLBACK WORK RETURN
    END IF
    CALL i030_show()
    IF cl_exp(0,0,g_fad.fadacti) THEN                   #確認一下
        LET g_chr=g_fad.fadacti
        IF g_fad.fadacti='Y' THEN
            LET g_fad.fadacti='N'
        ELSE
            LET g_fad.fadacti='Y'
        END IF
        UPDATE fad_file                    #更改有效碼
            SET fadacti=g_fad.fadacti
            WHERE fad01=g_fad.fad01
              AND fad02=g_fad.fad02
              AND fad03=g_fad.fad03
              AND fad04=g_fad.fad04
              AND fad07=g_fad.fad07   #No:FUN-AB0088
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","fad_file",g_fad.fad02,g_fad.fad03,SQLCA.sqlcode,"","",1)  #No.FUN-660136
            LET g_fad.fadacti=g_chr                                     
        END IF
        DISPLAY BY NAME g_fad.fadacti
    END IF
    CLOSE i030_cl
    COMMIT WORK
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i030_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_fad.fad01 IS NULL OR
       g_fad.fad02 IS NULL OR
       g_fad.fad03 IS NULL OR
       g_fad.fad04 IS NULL OR
       g_fad.fad07 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_fad.fadacti = 'N' THEN                                                                                                     
        CALL cl_err('','abm-950',0)                                                                                                 
        RETURN                                                                                                                      
    END IF                                                                                                                          
    BEGIN WORK
 
    OPEN i030_cl USING g_fad.fad07,g_fad.fad01,g_fad.fad02,g_fad.fad03,g_fad.fad04
    IF STATUS THEN
       CALL cl_err("OPEN i030_cl:", STATUS, 1)
       CLOSE i030_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i030_cl INTO g_fad.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fad.fad01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i030_cl ROLLBACK WORK RETURN
    END IF
    CALL i030_show()
  IF cl_delh(0,0) THEN                   #確認一下
      INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
      LET g_doc.column1 = "fad01"         #No.FUN-9B0098 10/02/24
      LET g_doc.value1 = g_fad.fad01      #No.FUN-9B0098 10/02/24
      LET g_doc.column2 = "fad02"         #No.FUN-9B0098 10/02/24
      LET g_doc.value2 = g_fad.fad02      #No.FUN-9B0098 10/02/24
      LET g_doc.column3 = "fad03"         #No.FUN-9B0098 10/02/24
      LET g_doc.value3 = g_fad.fad03      #No.FUN-9B0098 10/02/24
      LET g_doc.column4 = "fad04"         #No.FUN-9B0098 10/02/24
      LET g_doc.value4 = g_fad.fad04      #No.FUN-9B0098 10/02/24
      LET g_doc.column5 = "fad07"       #No:FUN-AB0088
      LET g_doc.value5 = g_fad.fad07    #No:FUN-AB0088
      CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
    DELETE FROM fad_file WHERE fad01 = g_fad.fad01
                           AND fad02 = g_fad.fad02
                           AND fad03 = g_fad.fad03
                           AND fad04 = g_fad.fad04
                           AND fad07 = g_fad.fad07   #No:FUN-AB0088
    IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","fad_file",g_fad.fad02,g_fad.fad03,SQLCA.sqlcode,"","",1)  #No.FUN-660136
    ELSE                                                        
        CLEAR FORM
        CALL g_fae.clear()
        DELETE FROM fae_file WHERE fae01 = g_fad.fad01
                               AND fae02 = g_fad.fad02
                               AND fae03 = g_fad.fad03
                               AND fae04 = g_fad.fad04
                               AND fae10 = g_fad.fad07   #No:FUN-AB0088
        CLEAR FORM
        CALL g_fae.clear()
        #CKP3
        OPEN i030_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i030_cs
             CLOSE i030_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        FETCH i030_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i030_cs
             CLOSE i030_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i030_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i030_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL i030_fetch('/')
        END IF
    END IF
  END IF
    CLOSE i030_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i030_b(p_key)
DEFINE
    p_key           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(100)
    l_direct        LIKE type_file.chr1,                #FTER       #No.FUN-680070 VARCHAR(01)
    l_aag02_1       LIKE aag_file.aag02,
  # l_aag02_11      LIKE aag_file.aag02,   #FUN-680028   #No:FUN-AB0088 Mark
    l_aag02_2       LIKE aag_file.aag02,
    l_cnt           LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    l_cnt1          LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    l_fae05         LIKE fae_file.fae05,
    l_check         LIKE fae_file.fae05, #為check AFTER FIELD fae05時對項次的
    l_check_t       LIKE fae_file.fae05,#判斷是否跳過AFTER ROW的處理
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
DEFINE  l_aag05     LIKE aag_file.aag05                  #No.FUN-B40004
DEFINE  l_bookno    LIKE aza_file.aza81  #MOD-C40127 add
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
   ##-----No:FUN-AB0088 Mark-----
   # IF g_aza.aza63 = 'N' THEN  
       IF g_fad.fad01 IS NULL OR
         g_fad.fad02 IS NULL OR                                                                                                       
         g_fad.fad03 IS NULL OR
         g_fad.fad04 IS NULL OR
         g_fad.fad07 IS NULL THEN 
         RETURN 
       END IF  
  #  ELSE
  #     IF g_fad.fad01 IS NULL OR
  #       g_fad.fad02 IS NULL OR
  #       g_fad.fad03 IS NULL OR
  #       g_fad.fad031 IS NULL OR              #FUN-680028  
  #       g_fad.fad04 IS NULL THEN
  #       RETURN
  #
  #   END IF
  #  END IF
  ##-----No:FUN-AB0088 Mark END-----
    IF g_fad.fadacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_fad.fad01,'aom-000',0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
 #   LET g_forupd_sql = " SELECT fae05,fae06,fae07,'',fae071,'',fae08,fae09,'' ",   #MOD-570162      #FUN-680028  
     LET g_forupd_sql = " SELECT fae05,fae06,fae07,'',fae08,fae09,'' ",   #No:FUN-AB0088   #MOD-570162      #FUN-680028
                        " FROM fae_file ",   #MOD-570162
                       " WHERE fae01 = ? ",
                       "   AND fae02 = ? ",
                       "   AND fae03 = ? ",
                       "   AND fae04 = ? ",
                       "   AND fae05 = ? ",
                       "   AND fae10 = ? ",   #No:FUN-AB0088
                       " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i030_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_fae.clear() END IF
 
 
        INPUT ARRAY g_fae WITHOUT DEFAULTS FROM s_fae.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
--CKP, 當單身有資料時才跳至指定列
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL i030_set_entry_b()
            CALL i030_set_no_entry_b()
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN i030_cl USING g_fad.fad07,g_fad.fad01,g_fad.fad02,g_fad.fad03,g_fad.fad04   #No:FUN-AB0088
            IF STATUS THEN
               CALL cl_err("OPEN i030_cl:", STATUS, 1)
               CLOSE i030_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i030_cl INTO g_fad.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fad.fad01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i030_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_fae_t.* = g_fae[l_ac].*  #BACKUP
 
                OPEN i030_bcl USING g_fad.fad01,g_fad.fad02,g_fad.fad03,g_fad.fad04,g_fae_t.fae05,g_fad.fad07   #No:FUN-AB0088
                IF STATUS THEN                                               
                   CALL cl_err("OPEN i030_bcl:", STATUS, 1)
                   CLOSE i030_bcl
                   LET l_lock_sw = "Y"
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i030_bcl INTO g_fae[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_fae_t.fae05,SQLCA.sqlcode,0)
                       LET l_lock_sw = "Y"
                   END IF
                    CALL i030_fae07('d',g_bookno1)   #MOD-570162  #No.FUN-740026  
                #   CALL i030_fae071('d',g_bookno2)  #FUN-680028   #No.FUN-740026  #No:FUN-AB0088 Mark
                    CALL i030_fae09('d',g_bookno1)   #MOD-570162     #No.FUN-740026  
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              INITIALIZE g_fae[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fae[l_ac].* TO s_fae.*
              CALL g_fae.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
            END IF
            INSERT INTO fae_file(fae01,fae02,fae03,fae04,fae05,
                             #   fae06,fae07,fae071,fae08,fae09)   
                                 fae06,fae07,fae08,fae09,fae10)    #No:FUN-AB0088
            VALUES(g_fad.fad01,g_fad.fad02,g_fad.fad03,g_fad.fad04,
                   g_fae[l_ac].fae05,g_fae[l_ac].fae06,
              #     g_fae[l_ac].fae07,g_fae[l_ac].fae071,g_fae[l_ac].fae08,         #FUN-680028
                    g_fae[l_ac].fae07,g_fae[l_ac].fae08,   #No:FUN-AB0088
                     g_fae[l_ac].fae09,g_fad.fad07)        #No:FUN-AB0088
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","fae_file",g_fad.fad03,g_fae[l_ac].fae05,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                COMMIT WORK
              CALL g_fae.deleteElement(g_rec_b+1)
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
                INITIALIZE g_fae[l_ac].* TO NULL      #900423
            LET g_fae_t.* = g_fae[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fae05
 
        BEFORE FIELD fae05                        #default 序號
            IF cl_null(g_fae[l_ac].fae05) OR
               g_fae[l_ac].fae05 = 0 THEN
                SELECT max(fae05)+1
                   INTO g_fae[l_ac].fae05
                   FROM fae_file
                   WHERE fae01 = g_fad.fad01
                     AND fae02 = g_fad.fad02
                     AND fae03 = g_fad.fad03
                     AND fae04 = g_fad.fad04
                     AND fae10 = g_fad.fad07   #No:FUN-AB0088
                IF g_fae[l_ac].fae05 IS NULL THEN
                    LET g_fae[l_ac].fae05 = 1
                END IF
            END IF
 
        AFTER FIELD fae05                        #check 序號是否重複
           IF NOT cl_null(g_fae[l_ac].fae05) THEN
              IF g_fae[l_ac].fae05 <= 0  THEN
                 CALL cl_err(g_fae[l_ac].fae05,'afa-037',0)
                 NEXT FIELD fae05
              END IF
           END IF
            IF g_fae[l_ac].fae05 IS NOT NULL AND
               (g_fae[l_ac].fae05 != g_fae_t.fae05 OR
                g_fae_t.fae05 IS NULL)  THEN
                SELECT count(*)
                    INTO l_n
                    FROM fae_file
                    WHERE fae01 = g_fad.fad01
                      AND fae02 = g_fad.fad02
                      AND fae03 = g_fad.fad03
                      AND fae04 = g_fad.fad04
                      AND fae10 = g_fad.fad07   #No:FUN-AB0088
                      AND fae05 = g_fae[l_ac].fae05
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_fae[l_ac].fae05 = g_fae_t.fae05
                    NEXT FIELD fae05
                END IF
            END IF
 
        AFTER FIELD fae06
            IF NOT cl_null(g_fae[l_ac].fae06) THEN   # 重要欄位不可空白
               CALL i030_fae06('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fae[l_ac].fae06,g_errno,0)
                  LET g_fae[l_ac].fae06 = g_fae_t.fae06
                  DISPLAY g_fae[l_ac].fae06 TO fae06
                  NEXT FIELD fae06
               END IF
              #單身不可維護兩筆相同部門
               LET l_n = 0
               SELECT COUNT(*) INTO l_n
                 FROM fae_file
                WHERE fae01 = g_fad.fad01
                  AND fae02 = g_fad.fad02
                  AND fae03 = g_fad.fad03
                  AND fae04 = g_fad.fad04
                  AND fae10 = g_fad.fad07   #No:FUN-AB0088
                  AND fae06 = g_fae[l_ac].fae06  
  
               IF cl_null(l_n) THEN LET l_n=0 END IF
               IF (p_cmd = 'a' AND l_n > 0) OR
                  (p_cmd = 'u' AND l_n > 1) THEN
                  CALL cl_err(g_fae[l_ac].fae06,'afa-193',0)
                  LET g_fae[l_ac].fae06 = g_fae_t.fae06
                  DISPLAY g_fae[l_ac].fae06 TO fae06
                  NEXT FIELD fae06
               END IF
               IF p_cmd = 'a' THEN
                  IF g_faa.faa20 = '1' THEN
                     DECLARE i030_fab
                         CURSOR FOR SELECT fab13 FROM fab_file
                                          WHERE fab11= g_fae[l_ac].fae06
                     FOREACH i030_fab INTO g_fae07
                       IF SQLCA.sqlcode THEN EXIT FOREACH END IF
                       EXIT FOREACH
                     END FOREACH
                   ##-----No:FUN-AB0088 Mark----- 
                   #  FOREACH i030_fab INTO g_fae071                        #FUN-680028
                   #    IF SQLCA.sqlcode THEN EXIT FOREACH END IF           #FUN-680028
                   #    EXIT FOREACH                                        #FUN-680028
                   #  END FOREACH     #FUN-680028
                   ##-----No:FUN-AB0088 Mark END-----   
                  ELSE
                     DECLARE i030_fbi
                         CURSOR FOR SELECT fbi02 FROM fbi_file
                                          WHERE fbi01= g_fae[l_ac].fae06
                     FOREACH i030_fbi INTO g_fae07
                       IF SQLCA.sqlcode THEN EXIT FOREACH END IF
                       IF not cl_null(g_fae07) THEN EXIT FOREACH END IF
                     END FOREACH
                   ##-----No:FUN-AB0088 Mark-----
                   #  FOREACH i030_fbi SELECT fbi021 INTO g_fae071          #FUN-680028
                   #     FROM fbi_file WHERE fbi01 = g_fae[l_ac].fae06
                   #    IF SQLCA.sqlcode THEN EXIT FOREACH END IF           #FUN-680028
                   #    IF not cl_null(g_fae071)THEN EXIT FOREACH END IF    #FUN-680028
                   #  END FOREACH                                           #FUN-680028
                   ##-----No:FUN-AB0088 Mark END-----                 
                  END IF
                  LET g_fae[l_ac].fae07 = g_fae07
                  DISPLAY g_fae[l_ac].fae07 TO fae07
                # LET g_fae[l_ac].fae071= g_fae071          #FUN-680028   #No:FUN-AB0088 Mark
                # DISPLAY g_fae[l_ac].fae071 TO fae071      #FUN-680028   #No:FUN-AB0088 Mark
               END IF
            END IF
 
        AFTER FIELD fae07
            IF NOT cl_null(g_fae[l_ac].fae07) THEN   # 重要欄位不可空白
              #MOD-C40127---str---
               IF g_fad.fad07 ='1' THEN
                  LET l_bookno = g_bookno1
               ELSE
                  LET l_bookno = g_faa.faa02c
               END IF
              #MOD-C40127---end---
              #CALL i030_fae07('a',g_bookno1)  #No.FUN-740026  #MOD-C40127 mark
               CALL i030_fae07('a',l_bookno)   #MOD-C40127 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fae[l_ac].fae07,g_errno,0)
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_fae[l_ac].fae07  
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_bookno1  
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_fae[l_ac].fae07 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_fae[l_ac].fae07            
                  #LET g_fae[l_ac].fae07 = g_fae_t.fae07
                  #FUN-B10049--end 
                  DISPLAY g_fae[l_ac].fae07 TO fae07
                  NEXT FIELD fae07
               END IF
               #98/12/16 單身如為相同分攤部門,相同折舊科目,則show message
               IF ((g_fae_t.fae06 IS NULL OR g_fae[l_ac].fae06 != g_fae_t.fae06) OR
                   (g_fae_t.fae07 IS NULL OR  g_fae[l_ac].fae07 != g_fae_t.fae07)) THEN
                  SELECT COUNT(*) INTO l_cnt FROM fae_file
                   WHERE fae01=g_fad.fad01
                     AND fae02=g_fad.fad02
                     AND fae03=g_fad.fad03
                     AND fae04=g_fad.fad04
                     AND fae06=g_fae[l_ac].fae06
                     AND fae07=g_fae[l_ac].fae07
                  IF l_cnt>0 THEN
                     LET g_msg=g_fae[l_ac].fae06,'+',g_fae[l_ac].fae07
                     CALL cl_err(g_msg,-239,1)
                  END IF
               END IF
               #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_fae[l_ac].fae07
                  AND aag00 = g_aza.aza81
               IF l_aag05 = 'Y' THEN
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_fae[l_ac].fae07,g_fae[l_ac].fae06,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fae[l_ac].fae07,g_errno,0)
                  DISPLAY BY NAME g_fae[l_ac].fae07
                  NEXT FIELD fae07
               END IF
               #No.FUN-B40004  --End
               
            END IF

      ##-----No:FUN-AB0088 Mark-----
      #  AFTER FIELD fae071
      #      IF NOT cl_null(g_fae[l_ac].fae071) THEN
      #         CALL i030_fae071('a',g_bookno2)   #No.FUN-740026  
      #         IF NOT cl_null(g_errno) THEN
      #            CALL cl_err(g_fae[l_ac].fae071,g_errno,0)
      #            #FUN-B10049--begin
      #            CALL cl_init_qry_var()                                         
      #            LET g_qryparam.form ="q_aag"                                   
      #            LET g_qryparam.default1 = g_fae[l_ac].fae071  
      #            LET g_qryparam.construct = 'N'                
      #            LET g_qryparam.arg1 = g_bookno2  
      #            LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_fae[l_ac].fae071 CLIPPED,"%' "                                                                        
      #            CALL cl_create_qry() RETURNING g_fae[l_ac].fae071                         
      #            #LET g_fae[l_ac].fae071 = g_fae_t.fae071
      #            #FUN-B10049--end   
      #            DISPLAY g_fae[l_ac].fae071 TO fae071
      #            NEXT FIELD fae071
      #         END IF
      #         IF ((g_fae_t.fae06 IS NULL OR g_fae[l_ac].fae06 != g_fae_t.fae06) OR
      #             (g_fae_t.fae071 IS NULL OR g_fae[l_ac].fae071 != g_fae_t.fae071)) THEN
      #            SELECT COUNT(*) INTO l_cnt FROM fae_file
      #             WHERE fae01 = g_fad.fad01
      #               AND fae02 = g_fad.fad02
      #               AND fae03 = g_fad.fad03
      #               AND fae04 = g_fad.fad04
      #               AND fae06 = g_fae[l_ac].fae06
      #               AND fae071= g_fae[l_ac].fae071
      #            IF l_cnt > 0 THEN
      #               LET g_msg=g_fae[l_ac].fae06,'+',g_fae[l_ac].fae071
      #               CALL cl_err(g_msg,-239,1)
      #            END IF
      #         END IF
      #      END IF
      ##-----No:FUN-AB0088-----

        AFTER FIELD fae08
            IF NOT cl_null(g_fae[l_ac].fae08) THEN
               IF g_fae[l_ac].fae08 < 0  THEN                      #CHI-9A0013 modify <= 改為 <
                  CALL cl_err(g_fae[l_ac].fae08,'amm-110',0)       #CHI-9A0013 modify afa-037 改為amm-110
                  LET g_fae[l_ac].fae08 = g_fae_t.fae08
                  DISPLAY g_fae[l_ac].fae08 TO fae08
                  NEXT FIELD fae08
               END IF
            END IF
 
        AFTER FIELD fae09
           IF NOT cl_null(g_fae[l_ac].fae09) THEN   # 重要欄位不可空白
              CALL i030_fae09('a',g_bookno1)   #No.FUN-740026  
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fae[l_ac].fae09,g_errno,0)
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fae[l_ac].fae09  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_bookno1  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aagacti='Y' AND aag01 LIKE '",g_fae[l_ac].fae09 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fae[l_ac].fae09                                             
                 #LET g_fae[l_ac].fae09 = g_fae_t.fae09
                 #FUN-B10049--end 
                 NEXT FIELD fae09
                 DISPLAY BY NAME g_fae[l_ac].fae09
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_fae_t.fae05 > 0 AND
               g_fae_t.fae05 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM fae_file
                    WHERE fae01 = g_fad.fad01
                      AND fae02 = g_fad.fad02
                      AND fae03 = g_fad.fad03
                      AND fae04 = g_fad.fad04
                      AND fae10 = g_fad.fad07   #No:FUN-AB0088
                      AND fae05 = g_fae_t.fae05
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","fae_file",g_fad.fad03,g_fae_t.fae05,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                    ROLLBACK WORK                            
                    CANCEL DELETE
                  ELSE COMMIT WORK
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fae[l_ac].* = g_fae_t.*
               CLOSE i030_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fae[l_ac].fae05,-263,1)
               LET g_fae[l_ac].* = g_fae_t.*
            ELSE
                UPDATE fae_file SET
                 fae05=g_fae[l_ac].fae05,fae06=g_fae[l_ac].fae06,
              #  fae07=g_fae[l_ac].fae07,fae071=g_fae[l_ac].fae071,         #FUN-680028
                 fae07=g_fae[l_ac].fae07,    #No:FUN-AB0088 
                 fae08=g_fae[l_ac].fae08,fae09=g_fae[l_ac].fae09
                WHERE fae01 = g_fad.fad01
                  AND fae02 = g_fad.fad02
                  AND fae03 = g_fad.fad03
                  AND fae04 = g_fad.fad04
                  AND fae10 = g_fad.fad07   #No:FUN-AB0088
                  AND fae05 = g_fae_t.fae05
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","fae_file",g_fad.fad03,g_fae_t.fae05,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                   LET g_fae[l_ac].* = g_fae_t.*            
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac     #FUN-D30032 mark
            IF INT_FLAG THEN
               IF g_fad.fad05 = '1' THEN
                  SELECT SUM(fae08) INTO g_cnt
                    FROM fae_file
                   WHERE fae01 = g_fad.fad01
                     AND fae02 = g_fad.fad02
                     AND fae03 = g_fad.fad03
                     AND fae04 = g_fad.fad04
                     AND fae10 = g_fad.fad07   #No:FUN-AB0088
                  IF g_cnt <> 100 THEN
                     CALL cl_err('','afa-030',1)
                     LET INT_FLAG=FALSE
                     NEXT FIELD fae08
                  ELSE
                     CALL cl_err('',9001,0)
                     LET INT_FLAG = 0
                     IF p_cmd='u' THEN
                        LET g_fae[l_ac].* = g_fae_t.*
                #FUN-D30032--add--str--
                     ELSE
                        CALL g_fae.deleteElement(l_ac)
                        IF g_rec_b != 0 THEN
                           LET g_action_choice = "detail"
                           LET l_ac = l_ac_t
                        END IF
                #FUN-D30032--add--end--
                     END IF
                     CLOSE i030_bcl
                     ROLLBACK WORK
                     EXIT INPUT
                  END IF
               END IF
            END IF
            LET l_ac_t = l_ac     #FUN-D30032  add
            CLOSE i030_bcl
            COMMIT WORK
 
        AFTER INPUT
            IF g_fad.fad05 = '1' THEN
               SELECT SUM(fae08) INTO g_cnt
                 FROM fae_file
                WHERE fae01 = g_fad.fad01
                  AND fae02 = g_fad.fad02
                  AND fae03 = g_fad.fad03
                  AND fae04 = g_fad.fad04
                  AND fae10 = g_fad.fad07   #No:FUN-AB0088
               IF g_cnt <> 100 THEN
                  CALL cl_err('','afa-030',1)
                  NEXT FIELD fae08
               END IF
            END IF
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
        ON ACTION controlp   #ok
           CASE
            WHEN INFIELD(fae06)      #查詢部門資料
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fae[l_ac].fae06
                 CALL cl_create_qry() RETURNING g_fae[l_ac].fae06
                 DISPLAY g_fae[l_ac].fae06 TO fae06
            WHEN INFIELD(fae07)      #查詢科目代號不為統制帳戶'1'
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
                 LET g_qryparam.default1 = g_fae[l_ac].fae07
                 #-----No:FUN-AB0088-----
                 IF g_fad.fad07='1' THEN
                    LET g_qryparam.arg1=g_bookno1  #No:FUN-740026
                 ELSE
                    LET g_qryparam.arg1 = g_faa.faa02c
                 END IF
                 #-----No:FUN-AB0088 END-----
             #   LET g_qryparam.arg1=g_bookno1   #No.FUN-740026 
                 CALL cl_create_qry() RETURNING g_fae[l_ac].fae07
                 DISPLAY g_fae[l_ac].fae07 TO fae07
                 CALL i030_fae07('d',g_bookno1)  #No.FUN-740026 
          ##-----No:FUN-AB0088 Mark----- 
          #  WHEN INFIELD(fae071)
          #       CALL cl_init_qry_var()
          #       LET g_qryparam.form = "q_aag"
          #       LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
          #       LET g_qryparam.default1 = g_fae[l_ac].fae071
          #       LET g_qryparam.arg1=g_bookno2   #No.FUN-740026
          #       CALL cl_create_qry() RETURNING g_fae[l_ac].fae071
          #       DISPLAY g_fae[l_ac].fae071 TO fae071
          #       CALL i030_fae071('d',g_bookno2)   #No.FUN-740026  
          ##-----No:FUN-AB0088 Mark END-----

            WHEN INFIELD(fae09)      #查詢科目代號不為統制帳戶'1'
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
                 LET g_qryparam.default1 = g_fae[l_ac].fae09
                 #-----No:FUN-AB0088-----
                 IF g_fad.fad07='1' THEN
                    LET g_qryparam.arg1=g_bookno1  #No:FUN-740026
                 ELSE
                    LET g_qryparam.arg1 = g_faa.faa02c
                 END IF
                 #-----No:FUN-AB0088 END-----
             #   LET g_qryparam.arg1=g_bookno1   #No.FUN-740026
                 CALL cl_create_qry() RETURNING g_fae[l_ac].fae09
                 DISPLAY g_fae[l_ac].fae09 TO fae09
                 CALL i030_fae09('d',g_bookno1)  #No.FUN-740026  
            OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fae05) AND l_ac > 1 THEN
                LET g_fae[l_ac].* = g_fae[l_ac-1].*
                LET g_fae[l_ac].fae05 = NULL   #TQC-620018
                NEXT FIELD fae05
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
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT
 
    LET g_fad.fadmodu = g_user
    LET g_fad.faddate = g_today
    UPDATE fad_file SET fadmodu = g_fad.fadmodu,faddate = g_fad.faddate
     WHERE fad01 = g_fad.fad01 AND fad02 = g_fad.fad02
       AND fad03 = g_fad.fad03 AND fad04 = g_fad.fad04 
       AND fad07 = g_fad.fad07   #No:FUN-AB0088
    DISPLAY BY NAME g_fad.fadmodu,g_fad.faddate
 
    CLOSE i030_bcl
    COMMIT WORK
    CALL i030_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i030_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM fad_file WHERE fad01 = g_fad.fad01 AND fad02 = g_fad.fad02
                                AND fad03 = g_fad.fad03 AND fad04 = g_fad.fad04
                                AND fad07 = g_fad.fad07
         INITIALIZE g_fad.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i030_set_entry_b()
    CALL cl_set_comp_entry("fae08,fae09",TRUE)
END FUNCTION
 
FUNCTION i030_set_no_entry_b()
 
    DISPLAY "g_fad.fad05=",g_fad.fad05
    IF g_fad.fad05 = '1' THEN
        CALL cl_set_comp_entry("fae09",FALSE)
    END IF
    IF g_fad.fad05 = '2' THEN
        CALL cl_set_comp_entry("fae08",FALSE)
    END IF
END FUNCTION
 
FUNCTION i030_delall()
 
     SELECT COUNT(*) INTO g_cnt
       FROM fae_file
      WHERE fae01 = g_fad.fad01
        AND fae02 = g_fad.fad02
        AND fae03 = g_fad.fad03
        AND fae04 = g_fad.fad04
        AND fae10 = g_fad.fad07   #No:FUN-AB0088
     IF g_cnt = 0 THEN
        CALL cl_getmsg('9044',g_lang) RETURNING g_msg
        ERROR g_msg CLIPPED
        DELETE FROM fad_file
         WHERE fad01 = g_fad.fad01
           AND fad02 = g_fad.fad02
           AND fad03 = g_fad.fad03
           AND fad04 = g_fad.fad04
           AND fad07 = g_fad.fad07   #No:FUN-AB0088
     END IF
END FUNCTION
 
FUNCTION i030_fae06(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_gemacti       LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gemacti INTO l_gemacti
      FROM gem_file
     WHERE gem01 = g_fae[l_ac].fae06
    CASE WHEN STATUS=100         LET g_errno = 'afa-038'  #No.7926
         WHEN l_gemacti = 'N' LET g_errno = '9028'
         OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
END FUNCTION
 
#檢查科目名稱
FUNCTION  i030_fae07(p_cmd,p_bookno)     #No.FUN-740026  #No.FUN-740026 
DEFINE
    p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    p_bookno        LIKE aag_file.aag00,  #No.FUN-740026 
    l_aag02_1       LIKE aag_file.aag02,
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02,aagacti
      INTO l_aag02_1,l_aagacti
      FROM aag_file
     WHERE aag01 = g_fae[l_ac].fae07
      AND  aag00 =p_bookno  #No.FUN-740026  
    CASE WHEN STATUS=100          LET g_errno = 'afa-085'  #No.7926
                                  LET l_aag02_1 = NULL
          WHEN l_aagacti = 'N' LET g_errno = '9028'
          OTHERWISE LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
    IF cl_null(g_errno) OR  p_cmd = 'd' THEN
       LET g_fae[l_ac].aag02_1 = l_aag02_1
       DISPLAY g_fae[l_ac].aag02_1 TO aag02_1
    END IF
END FUNCTION
 
##-----No:FUN-AB0088 Mark-----
#FUNCTION i030_fae071(p_cmd,p_bookno)   #No.FUN-740026          #No.FUN-740026
#DEFINE
#     p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#     l_aag02_11      LIKE aag_file.aag02,
#     p_bookno        LIKE aag_file.aag00, #No.FUN-740026 
#     l_aagacti       LIKe aag_file.aagacti
# 
#     LET g_errno = ' '
#     SELECT aag02,aagacti
#       INTO l_aag02_11,l_aagacti
#       FROM aag_file
#      WHERE aag01 = g_fae[l_ac].fae071
#       AND  aag00 = p_bookno    #No.FUN-740026
#     CASE WHEN STATUS=100     LET g_errno = 'afa-085'
#                              LET l_aag02_11 = NULL
#          WHEN l_aagacti='N'  LET g_errno ='9028'
#          OTHERWISE           LET g_errno = SQLCA.sqlcode USING '-------'
#     END CASE
#     IF cl_null(g_errno) OR p_cmd = 'd' THEN
#        LET g_fae[l_ac].aag02_11 = l_aag02_11
#        DISPLAY g_fae[l_ac].aag02_11 To aag02_11
#     END IF 
#END FUNCTION
##-----No:FUN-AB0088 Mark----- 
FUNCTION i030_fae09(p_cmd,p_bookno) #No.FUN-740026        #No.FUN-740026  
DEFINE
    p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_aag02_2       LIKE aag_file.aag02,
    p_bookno        LIKE aag_file.aag00,  #No.FUN-740026 
    l_aagacti       LIKE aag_file.aagacti
 
    LET g_errno = ' '
    SELECT aag02,aagacti
        INTO l_aag02_2,l_aagacti
        FROM aag_file
        WHERE aag01 = g_fae[l_ac].fae09
         AND  aag00 =p_bookno     #No.FUN-740026  
    CASE WHEN STATUS=100          LET g_errno = 'afa-085'  #No.7926
                                  LET l_aag02_2 = NULL
          WHEN l_aagacti = 'N' LET g_errno = '9028'
          OTHERWISE LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
    IF cl_null(g_errno) OR  p_cmd = 'd' THEN
       LET g_fae[l_ac].aag02_2 = l_aag02_2
       DISPLAY BY NAME g_fae[l_ac].aag02_2
    END IF
END FUNCTION
 
FUNCTION i030_b_askkey()
DEFINE
    l_wc2           STRING    #TQC-630166
 
    CONSTRUCT l_wc2 ON fae05,fae06
            FROM s_fae[1].fae05,s_fae[1].fae06
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
        RETURN
    END IF
    CALL i030_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i030_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING    #TQC-630166
 
    LET g_sql =
     #   " SELECT fae05,fae06,fae07,'',fae071,'',fae08,fae09,'' ",   #MOD-570162  #FUN-680028
         " SELECT fae05,fae06,fae07,'',fae08,fae09,'' ",    #No:FUN-AB0088  #MOD-570162  #FUN-680028
         " FROM fae_file ",   #MOD-570162
        " WHERE fae01 ='",g_fad.fad01,"'",  #單頭
        "   AND fae02 ='",g_fad.fad02,"'",
        "   AND fae03 ='",g_fad.fad03,"'",
        "   AND fae04 ='",g_fad.fad04,"'",
        "   AND fae10 ='",g_fad.fad07,"'"   #No:FUN-AB0088
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED 
    DISPLAY g_sql
 
    PREPARE i030_pb FROM g_sql
    DECLARE fae_curs                       #SCROLL CURSOR
        CURSOR FOR i030_pb
 
    CALL g_fae.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fae_curs INTO g_fae[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,0)
            EXIT FOREACH
        END IF
        SELECT aag02 INTO g_fae[g_cnt].aag02_1
          FROM aag_file
         WHERE aag01 = g_fae[g_cnt].fae07
         AND   aag00=g_bookno1  #No.FUN-740026  
      ##-----No:FUN-AB0088 Mark-----
      #  SELECT aag02 INTO g_fae[g_cnt].aag02_11
      #    FROM aag_file
      #   WHERE aag01 = g_fae[g_cnt].fae071
      #    AND  aag00=g_bookno2  #No.FUN-740026
      ##-----No:FUN-AB0088 Mark END-----
 
        SELECT aag02 INTO g_fae[g_cnt].aag02_2
          FROM aag_file
         WHERE aag01 = g_fae[g_cnt].fae09
          AND  aag00=g_bookno1  #No.FUN-740026 
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
--CKP, 填充單身最後一筆為 NULL array, 故要刪掉
    CALL g_fae.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i030_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fae TO s_fae.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION first
         CALL i030_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i030_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i030_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i030_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i030_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 整批複製
      ON ACTION batch_copy
         LET g_action_choice="batch_copy"
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#---------- G. 整批複製---------
 
FUNCTION i030_g()                     # 整批複製
DEFINE new_yy,old_yy LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       new_mm,old_mm LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       fad03      LIKE fad_file.fad03,
  #    fad031     LIKE fad_file.fad031,        #FUN-680028   #No:FUN-AB0088 Mark
       fad04      LIKE fad_file.fad04,
       fad05      LIKE fad_file.fad05,
       l_wc       STRING   , #TQC-630166
       l_sql      STRING   , #TQC-630166
       y          RECORD LIKE fad_file.*,
    #  x          RECORD LIKE fae_file.*       #No.FUN-AB0088-MARK
   
       x         RECORD                    #No.FUN-AB0088
          fae01   LIKE fae_file.fae01,     #No.FUN-AB0088
          fae02   LIKE fae_file.fae02,     #No.FUN-AB0088
          fae03   LIKE fae_file.fae03,     #No.FUN-AB0088
          fae04   LIKE fae_file.fae04,     #No.FUN-AB0088
          fae05   LIKE fae_file.fae05,     #No.FUN-AB0088
          fae06   LIKE fae_file.fae06,     #No.FUN-AB0088
          fae07   LIKE fae_file.fae07,     #No.FUN-AB0088
          fae08   LIKE fae_file.fae08,     #No.FUN-AB0088
          fae09   LIKE fae_file.fae09,     #No.FUN-AB0088
          fae10   LIKE fae_file.fae10      #No.FUN-AB0088
                 END RECORD
DEFINE p_row,p_col LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE ls_tmp STRING
   IF s_shut(0) THEN RETURN END IF
   LET p_row = 8 LET p_col = 24
   OPEN WINDOW i030_w3 AT p_row,p_col WITH FORM "afa/42f/afai030_2"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("afai030_2")
 
#   CONSTRUCT  l_wc ON fad03,fad04,fad031,fad05       #FUN-680028
#         FROM fad03,fad04,fad031,fad05               #FUN-680028
    CONSTRUCT  l_wc ON fad03,fad04,fad05,fad07       #FUN-680028   #No:FUN-AB0088 #FUN-BA0083 add fad07
          FROM fad03,fad04,fad05,fad07               #FUN-680028   #No:FUN-AB0088 #FUN-BA0083 add fad07
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
             #    CALL cl_set_comp_visible("fad031",g_aza.aza63 ='Y')  #No:FUN-AB0088 Mark    #No.TQC-A30165
             #    CALL cl_set_comp_visible("fad05",g_aza.aza63 ='Y')    #No:FUN-AB0088 Mark   #No.TQC-A30165
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
   IF INT_FLAG  THEN LET INT_FLAG = 0 CLOSE WINDOW i030_w3 RETURN END IF
   LET old_yy = g_fad.fad01 LET new_yy = NULL
   LET old_mm = g_fad.fad02 LET new_mm = NULL
   INPUT BY NAME old_yy,old_mm,new_yy,new_mm
               WITHOUT DEFAULTS
 
 
      AFTER FIELD old_mm
         IF NOT cl_null(old_mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = old_yy
            IF g_azm.azm02 = 1 THEN
               IF old_mm > 12 OR old_mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD old_mm
               END IF
            ELSE
               IF old_mm > 13 OR old_mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD old_mm
               END IF
            END IF
         END IF
        IF NOT cl_null(old_mm) THEN
           SELECT count(*) INTO g_cnt FROM fad_file
            WHERE fad01 = old_yy AND fad02 = old_mm
           IF g_cnt=0 THEN CALL cl_err('fad_file',100,0) NEXT FIELD old_yy END IF
        END IF
 
 
      AFTER FIELD new_mm
         IF NOT cl_null(new_mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = new_yy
            IF g_azm.azm02 = 1 THEN
               IF new_mm > 12 OR new_mm < 1 THEN
                  NEXT FIELD new_mm
                  CALL cl_err('','agl-020',0)
               END IF
            ELSE
               IF new_mm > 13 OR new_mm < 1 THEN
                  NEXT FIELD new_mm
                  CALL cl_err('','agl-020',0)
               END IF
            END IF
         END IF
        IF NOT cl_null(new_mm) THEN
           LET l_sql = "SELECT COUNT(*) FROM fad_file",
                       " WHERE fad01=",new_yy," AND fad02=",new_mm,
                       "   AND ",l_wc CLIPPED
           PREPARE i030_prepare_c FROM l_sql
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('prepare:',SQLCA.sqlcode,0)
              CLOSE WINDOW i030_w3                     #MOD-A90156 
              ROLLBACK WORK RETURN
           END IF
           DECLARE i030_curs_c CURSOR FOR i030_prepare_c
           OPEN i030_curs_c
           FETCH i030_curs_c INTO g_cnt
           IF g_cnt>0 THEN CALL cl_err('fad_file',-239,0) NEXT FIELD new_yy END IF
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
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW i030_w3 RETURN END IF
   MESSAGE ' COPY.... '
   BEGIN WORK
   LET l_sql = "SELECT *",
               "  FROM fad_file",
               " WHERE ",l_wc CLIPPED,
               "   AND fad01 = '",old_yy,"'",
               "   AND fad02 = '",old_mm,"'"
   PREPARE i030_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,0)
      CLOSE WINDOW i030_w3                     #MOD-A90156 
      ROLLBACK WORK RETURN
   END IF
   DECLARE i030_curs2 CURSOR FOR i030_prepare1
   FOREACH i030_curs2 INTO y.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,0)
        ROLLBACK WORK EXIT FOREACH
     END IF
     LET y.fad01 = new_yy
     LET y.fad02 = new_mm
     LET y.faduser = g_user    #資料所有者
     LET y.fadgrup = g_grup    #資料所有者所屬群
     LET y.fadmodu = NULL      #資料修改日期
     LET y.faddate = g_today  #資料建立日期
     LET y.fadacti = 'Y'       #有效資料
     LET y.fadoriu = g_user      #No.FUN-980030 10/01/04
     LET y.fadorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO fad_file VALUES (y.*)
       IF STATUS THEN 
          CALL cl_err3("ins","fad_file",y.fad02,y.fad03,SQLCA.sqlcode,"","ins fad:",1)  #No.FUN-660136
          CLOSE WINDOW i030_w3               #MOD-A90156 
          ROLLBACK WORK  RETURN END IF
   END FOREACH
 
   LET l_sql = "SELECT fae01,fae02,fae03,fae04,",
           #   "       fae05,fae06,fae07,fae08,fae09,fae071",         #MOD-7B0241
               "       fae05,fae06,fae07,fae08,fae09,fae10",       #No:FUN-AB0088
               "  FROM fad_file,fae_file",
               " WHERE ",l_wc CLIPPED,
               "   AND fad01 = fae01",
               "   AND fad02 = fae02",
               "   AND fad03 = fae03",
               "   AND fad04 = fae04",
               "   AND fad07 = fae10",   #No:FUN-AB0088
               "   AND fad01 = '",old_yy,"'",
               "   AND fad02 = '",old_mm,"'"
   PREPARE i030_prepare2 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,0)
      CLOSE WINDOW i030_w3               #MOD-A90156 
      ROLLBACK WORK RETURN
   END IF
   DECLARE i030_curs3 CURSOR FOR i030_prepare2
   FOREACH i030_curs3 INTO x.*
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('foreachx:',SQLCA.sqlcode,0)
        ROLLBACK WORK  EXIT FOREACH
     END IF
     LET x.fae01 = new_yy
     LET x.fae02 = new_mm
     INSERT INTO fae_file(fae01,fae02,fae03,fae04,fae05,fae06,fae07,fae08,fae09,fae10)       #No:FUN-AB0088
            VALUES (x.fae01,x.fae02,x.fae03,x.fae04,x.fae05,x.fae06,x.fae07,x.fae08,x.fae09,x.fae10)   #No:FUN-AB0088
       IF STATUS THEN 
         CALL cl_err3("ins","fae_file",x.fae03,x.fae05,SQLCA.sqlcode,"","ins fae:",1)  #No.FUN-660136
         CLOSE WINDOW i030_w3               #MOD-A90156 
         ROLLBACK WORK RETURN END IF
   END FOREACH
   CLOSE WINDOW i030_w3
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',new_yy,'/',new_mm,') O.K'
   COMMIT WORK
END FUNCTION
 
FUNCTION i030_copy()
DEFINE
    l_fad        RECORD LIKE fad_file.*,
    l_oldno1,l_newno1   LIKE fad_file.fad01,
    l_oldno2,l_newno2   LIKE fad_file.fad02,
    l_oldno3,l_newno3   LIKE fad_file.fad03,
#   l_oldno31,l_newno31 LIKE fad_file.fad031,           #FUN-680028   #No:FUN-AB0088 Mark
    l_oldno4,l_newno4   LIKE fad_file.fad04,
    l_oldno7,l_newno7   LIKE fad_file.fad07   #No:FUN-AB0088
DEFINE l_aag02   LIKE aag_file.aag02   #No.TQC-7B0056
DEFINE l_aagacti LIKE aag_file.aagacti #No.TQC-7B0056
DEFINE l_cmd     LIKE faa_file.faa02c  #TQC-B60210   Add
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fad.fad01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL i030_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
 #  INPUT l_newno1,l_newno2,l_newno3,l_newno4,l_newno31 FROM fad01,fad02,fad03,fad04,fad031     #FUN-680028
    INPUT l_newno7,l_newno1,l_newno2,l_newno3,l_newno4 FROM fad07,fad01,fad02,fad03,fad04    #No:FUN-AB0088    #FUN-680028 
        AFTER FIELD fad01
            IF NOT cl_null(l_newno1) THEN
               CALL s_get_bookno(l_newno1)  RETURNING g_flag,g_bookno1,g_bookno2
               IF g_flag='1' THEN #抓不到帳套
                   CALL cl_err(l_newno1,'aoo-081',1)
                   NEXT FIELD fad01
               END IF
            END IF
 
        AFTER FIELD fad02
            IF NOT cl_null(l_newno2) THEN
               IF (l_newno2 < 1 OR l_newno2 > 13) THEN
                  NEXT FIELD fad02
               END IF
            END IF
 
        AFTER FIELD fad03
            IF NOT cl_null(l_newno3) THEN
               #TQC-B60210   ---start   Add
               IF g_fad.fad07='1' THEN
                  LET l_cmd = g_bookno1
               ELSE
                  LET l_cmd = g_faa.faa02c
               END IF
               #TQC-B60210   ---end     Add
               LET g_errno = ' '
               LET l_aag02 = ' '
               SELECT aag02,aagacti
                 INTO l_aag02,l_aagacti
                 FROM aag_file
                WHERE aag01 = l_newno3
                 AND  aag00 = l_cmd     #TQC-B60210   Add
               CASE WHEN STATUS=100     LET g_errno = 'afa-085'
                    WHEN l_aagacti='N'  LET g_errno = '9028'
                    OTHERWISE           LET g_errno = SQLCA.sqlcode USING '-------'
               END CASE
               DISPLAY l_aag02 TO FORMONLY.aag02
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD fad03
               END IF
            END IF
     ##-----No:FUN-AB0088 Mark-----
     #   AFTER FIELD fad031
     #       IF NOT cl_null(l_newno31) THEN
     #          LET g_errno = ' '
     #          LET l_aag02 = ' '
     #          SELECT aag02,aagacti
     #            INTO l_aag02,l_aagacti
     #            FROM aag_file
     #           WHERE aag01 = l_newno31
     #            AND  aag00 = g_bookno2
     #          CASE WHEN STATUS=100     LET g_errno = 'afa-085'
     #               WHEN l_aagacti='N'  LET g_errno = '9028'
     #               OTHERWISE           LET g_errno = SQLCA.sqlcode USING '-------'
     #          END CASE
     #          DISPLAY l_aag02 TO FORMONLY.aag021
     #          IF NOT cl_null(g_errno) THEN
     #             CALL cl_err('',g_errno,0)
     #             NEXT FIELD fad031
     #          END IF
     #       END IF
     ##-----No:FUN-AB0088 Mark END-----

        AFTER FIELD fad04
            IF NOT cl_null(l_newno4) THEN
                SELECT count(*) INTO g_cnt FROM fad_file
                       WHERE fad01 = l_newno1 AND fad02 = l_newno2
                         AND fad03 = l_newno3
                         AND fad04 = l_newno4
                         AND fad07 = l_newno7   #No:FUN-AB0088
                IF g_cnt > 0 THEN
                   CALL cl_err(l_newno1,-239,0)
                   NEXT FIELD fad01
                END IF
            END IF
        ON ACTION controlp
           CASE
              WHEN INFIELD(fad03) #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
                 LET g_qryparam.default1 = l_newno3
                 #-----No:FUN-AB0088-----
                 IF g_fad.fad07='1' THEN
                    LET g_qryparam.arg1=g_bookno1  #No:FUN-740026
                 ELSE
                    LET g_qryparam.arg1 = g_faa.faa02c
                 END IF
                 #-----No:FUN-AB0088 END-----
             #   LET g_qryparam.arg1=g_bookno1  #No.TQC-7B0056
                 CALL cl_create_qry() RETURNING l_newno3
                 DISPLAY  BY NAME l_newno3
                 NEXT FIELD fad03

           #-----No:FUN-AB0088 Mark-----
           #   WHEN INFIELD(fad031)
           #      CALL cl_init_qry_var()
           #      LET g_qryparam.form = "q_aag"
           #      LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 IN ('2') "
           #      LET g_qryparam.default1 = l_newno31
           #      LET g_qryparam.arg1=g_bookno2  #No.TQC-7B0056
           #      CALl cl_create_qry() RETURNING l_newno31
           #      DISPLAY BY NAME l_newno31
           #      NEXT FIELD fad031
           ##-----No:FUN-AB0088-----
           END CASE
 
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
        DISPLAY BY NAME g_fad.fad07   #No:FUN-AB0088
        DISPLAY BY NAME g_fad.fad01
        DISPLAY BY NAME g_fad.fad02
        DISPLAY BY NAME g_fad.fad03
        DISPLAY BY NAME g_fad.fad04
 #      DISPLAY BY NAME g_fad.fad031         #FUN-680028  #No:FUN-AB0088 Mark
        RETURN
    END IF
    LET l_fad.* = g_fad.*
    LET l_fad.fad01  =l_newno1  #新的鍵值
    LET l_fad.fad02  = l_newno2
    LET l_fad.fad03  = l_newno3
    LET l_fad.fad04  = l_newno4
    LET l_fad.fad07  = l_newno7   #No:FUN-AB0088
 #  LET l_fad.fad031 = l_newno31             #FUN-680028   #No:FUN-AB0088 Mark
    LET l_fad.faduser=g_user    #資料所有者
    LET l_fad.fadgrup=g_grup    #資料所有者所屬群
    LET l_fad.fadmodu=NULL      #資料修改日期
    LET l_fad.faddate=g_today   #資料建立日期
    LET l_fad.fadacti='Y'       #有效資料
    LET l_fad.fadoriu = g_user      #No.FUN-980030 10/01/04
    LET l_fad.fadorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO fad_file VALUES (l_fad.*)
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","fad_file",l_fad.fad02,l_fad.fad03,SQLCA.sqlcode,"","fad:",1)  #No.FUN-660136
        RETURN                                               
    END IF
 
    DROP TABLE x
    SELECT * FROM fae_file         #單身複製
        WHERE fae01=g_fad.fad01
          AND fae02=g_fad.fad02
          AND fae03=g_fad.fad03
          AND fae04=g_fad.fad04
          AND fae10=g_fad.fad07   #No:FUN-AB0088
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","x",g_fad.fad02,g_fad.fad03,SQLCA.sqlcode,"","",1)  #No.FUN-660136
        RETURN                                         
    END IF
    UPDATE x
        SET fae01=l_newno1,fae02=l_newno2,
            fae03=l_newno3,fae04=l_newno4,
            fae10=l_newno7                   #MOD-BB0158
 
    INSERT INTO fae_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","fae_file",l_newno2,l_newno3,SQLCA.sqlcode,"","fae:",1)  #No.FUN-660136
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
 
     LET l_oldno1 = g_fad.fad01
     LET l_oldno2 = g_fad.fad02
     LET l_oldno3 = g_fad.fad03
     LET l_oldno4 = g_fad.fad04
     LET l_oldno7 = g_fad.fad07   #No:FUN-AB0088
     SELECT fad_file.* INTO g_fad.* FROM fad_file
                     WHERE fad01 = l_newno1
                       AND fad02 = l_newno2
                       AND fad03 = l_newno3
                       AND fad04 = l_newno4
                       AND fad07 = l_newno7   #No:FUN-AB0088
     CALL i030_u()
     CALL i030_b('u')
     #FUN-C30027---begin
     #SELECT fad_file.* INTO g_fad.* FROM fad_file
     #                WHERE fad01 = l_oldno1
     #                  AND fad02 = l_oldno2
     #                  AND fad03 = l_oldno3
     #                  AND fad04 = l_oldno4
     #                  AND fad07 = l_oldno7   #No:FUN-AB0088
     #CALL i030_show()
     #FUN-C30027---end
END FUNCTION
 
FUNCTION i030_out()
DEFINE
    l_i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    sr              RECORD
        fad01       LIKE fad_file.fad01,   #資料年度
        fad02       LIKE fad_file.fad02,   #資料月份
        fad03       LIKE fad_file.fad03,   #資產科目
        fad031      LIKE fad_file.fad031,  #FUN-680028
        fad04       LIKE fad_file.fad04,   #分攤類別
        fad05       LIKE fad_file.fad05,   #分攤方式
        fae05       LIKE fae_file.fae05,   #項次
        fae06       LIKE fae_file.fae06,   #分攤部門
        fae07       LIKE fae_file.fae07,   #折舊會計科目
       # fae071      LIKE fae_file.fae071,  #FUN-680028  #FUN-BB0113 mark
        fae08       LIKE fae_file.fae08,   #分攤比率
        fae09       LIKE fae_file.fae09    #變動比率分子科目
                    END RECORD,
    l_msg           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(24)
    l_name          LIKE type_file.chr20,        #External(Disk) file name       #No.FUN-680070 VARCHAR(20)
    l_za05          LIKE za_file.za05            #No.FUN-680070 VARCHAR(40)
DEFINE
    l_fad03_t       LIKE fad_file.fad03,                                                                                            
    l_fad031_t      LIKE fad_file.fad031,                                                                               
    l_fad04_t       LIKE fad_file.fad04,                                                                                            
    l_fad05_t       LIKE fad_file.fad05
 
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-770033   
    SELECT zo02 INTO g_company FROM zo_file
     WHERE zo01 = g_lang
    CALL cl_del_data(l_table)                                   #No.FUN-770033
    LET g_sql="SELECT fad01,fad02,fad03,fad031,fad04,fad05,",   #FUN-680028   #No.TQC-960349 mod
              #"       fae05,fae06,fae07,fae071,fae08,fae09",    #FUN-680028#FUN-BB0113 mark
              "       fae05,fae06,fae07,fae08,fae09", #FUN-BB0113 add
              "  FROM fad_file, fae_file",
              " WHERE fad01 = fae01 AND fad02 = fae02 ",
              "   AND fad03 = fae03 AND fad04 = fae04 ",
              "   AND ",g_wc CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY 1,2,3,4,6,7"                         #FUN-680028
    PREPARE i030_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i030_co                         # SCROLL CURSOR
         CURSOR FOR i030_p1

    IF g_aza.aza63 = 'Y' THEN

       LET l_name = 'afai030'
    ELSE

       LET l_name = 'afai030_1'  
    END IF
    CALL cl_prt_pos_len()
 
    FOREACH i030_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,0) 
           EXIT FOREACH
        END IF
        LET l_fad03_t = ' '                                                                                                     
        LET l_fad04_t = ' '                                                                                                     
        LET l_fad031_t= ' '                                                                                         
        LET l_fad05_t = ' '       
        IF  l_fad03_t = sr.fad03[1,16] AND l_fad04_t = sr.fad04 AND                                                             
            l_fad031_t= sr.fad031[1,16]AND l_fad05_t = sr.fad05  THEN                                            
            LET l_fad03_t = ' '                                                                                                 
            LET l_fad04_t = ' '                                                                                                 
            LET l_fad031_t= ' '                                                                              
            LET l_fad05_t = ' ' 
            EXECUTE insert_prep USING
                    sr.fad01,sr.fad02,l_fad03_t,l_fad031_t,l_fad04_t,l_fad05_t,
                    #sr.fae06,sr.fae07,sr.fae071,sr.fae08,sr.fae09 # FUN-BB0113 mark
                    sr.fae06,sr.fae07,sr.fae08,sr.fae09 # FUN-BB0113 add
        ELSE 
            EXECUTE insert_prep USING
                    sr.fad01,sr.fad02,sr.fad03,sr.fad031,sr.fad04,sr.fad05,
                    #sr.fae06,sr.fae07,sr.fae071,sr.fae08,sr.fae09 # FUN-BB0113 mark
                    sr.fae06,sr.fae07,sr.fae08,sr.fae09 # FUN-BB0113 add
        END IF
        LET l_fad03_t = sr.fad03[1,16]                                                                                         
        LET l_fad031_t= sr.fad031[1,16]                                                            
        LET l_fad04_t = sr.fad04                                                                                               
        LET l_fad05_t = sr.fad05
        
    END FOREACH
 
    CLOSE i030_co
    ERROR ""
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'fad01,fad02,fad03,fad04,fad031,fad05')                                                                  
        RETURNING g_wc                                                                                                             
        LET g_str = g_str CLIPPED,";",g_wc                                                                                         
     END IF                                                                                                                         
     LET g_str = g_wc                                                                                                              
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
     CALL cl_prt_cs3('afai030',l_name,g_sql,g_str)
END FUNCTION
 
#No.FUN-9C0077 程式精簡

