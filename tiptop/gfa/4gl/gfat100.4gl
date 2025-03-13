# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: gfat100.4gl
# Descriptions...: 每月工作資料維護作業
# Date & Author..: 03/12/11 By HAWK
# Modify.........: MOD-4A0248 04/10/26 Yuna QBE開窗開不出來
#                  FUN-4C0058 04/12/08 Smapmin 加入權限控管
#                  FUN-510035 05/01/25 Smapmin 報表轉XML格式
#                  MOD-530859 05/03/30 alex 修改 source 回到 CHAR
# Modify.........: No.FUN-5B0116 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.TQC-620120 06/03/02 By Smapmin 當附號為NULL時,LET 附號為空白
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-6A0150 06/10/27 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0097 06/10/31 By hongmei l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-7B0032 07/11/06 By Carrier cl_conf用cl_confirm來代替
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-850068 08/05/14 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-850011 08/05/05 By destiny 報表改為CR輸出
#                                08/09/26 By Cockroach cr 21-->31 
# Modify.........: No.MOD-8A0268 08/10/30 By Sarah t100_cs建立CURSOR時加上WITH HOLD
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
# Modify.........: No.TQC-960431 09/06/30 By xiaofeizhu 修改錄入時，資料有效碼欄位未賦值,查詢時，資料有效碼欄位無法下查詢條件的問題
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.TQC-9B0016 09/11/04 By liuxqa 标准SQL修改。
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/20 By bart 複製後停在新資料畫
# Modify.........: No:CHI-C80041 12/12/28 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_fgj    RECORD LIKE fgj_file.*,       #
    g_fgj_t  RECORD LIKE fgj_file.*,       #
    g_fgj_o  RECORD LIKE fgj_file.*,       #
    g_fgj01_t       LIKE fgj_file.fgj01,   #
    g_fgj02_t       LIKE fgj_file.fgj02,   #
    g_fgj03_t       LIKE fgj_file.fgj03,   #
    g_fgj04_t       LIKE fgj_file.fgj04,   #
 g_fgk           DYNAMIC ARRAY OF RECORD#
        fgk05       LIKE fgk_file.fgk05,   #部門編號
        gem02       LIKE gem_file.gem02,   #部門名稱
        fgk06       LIKE fgk_file.fgk06,   #本月工作量
        fgk07       LIKE fgk_file.fgk07,   #備注
        #FUN-850068 --start---
        fgkud01     LIKE fgk_file.fgkud01,
        fgkud02     LIKE fgk_file.fgkud02,
        fgkud03     LIKE fgk_file.fgkud03,
        fgkud04     LIKE fgk_file.fgkud04,
        fgkud05     LIKE fgk_file.fgkud05,
        fgkud06     LIKE fgk_file.fgkud06,
        fgkud07     LIKE fgk_file.fgkud07,
        fgkud08     LIKE fgk_file.fgkud08,
        fgkud09     LIKE fgk_file.fgkud09,
        fgkud10     LIKE fgk_file.fgkud10,
        fgkud11     LIKE fgk_file.fgkud11,
        fgkud12     LIKE fgk_file.fgkud12,
        fgkud13     LIKE fgk_file.fgkud13,
        fgkud14     LIKE fgk_file.fgkud14,
        fgkud15     LIKE fgk_file.fgkud15
        #FUN-850068 --end--
                    END RECORD,
 g_fgk_t         RECORD                 #
        fgk05       LIKE fgk_file.fgk05,   #部門編號
        gem02       LIKE gem_file.gem02,   #部門名稱
        fgk06       LIKE fgk_file.fgk06,   #本月工作量
        fgk07       LIKE fgk_file.fgk07,   #備注
        #FUN-850068 --start---
        fgkud01     LIKE fgk_file.fgkud01,
        fgkud02     LIKE fgk_file.fgkud02,
        fgkud03     LIKE fgk_file.fgkud03,
        fgkud04     LIKE fgk_file.fgkud04,
        fgkud05     LIKE fgk_file.fgkud05,
        fgkud06     LIKE fgk_file.fgkud06,
        fgkud07     LIKE fgk_file.fgkud07,
        fgkud08     LIKE fgk_file.fgkud08,
        fgkud09     LIKE fgk_file.fgkud09,
        fgkud10     LIKE fgk_file.fgkud10,
        fgkud11     LIKE fgk_file.fgkud11,
        fgkud12     LIKE fgk_file.fgkud12,
        fgkud13     LIKE fgk_file.fgkud13,
        fgkud14     LIKE fgk_file.fgkud14,
        fgkud15     LIKE fgk_file.fgkud15
        #FUN-850068 --end--
                    END RECORD,
    g_cmd           LIKE type_file.chr1000, #NO.FUN-690009 VARCHAR(200)
    g_azp01         LIKE azp_file.azp01,
    g_type          LIKE type_file.chr2,    #NO.FUN-690009 VARCHAR(2)
    g_t1            LIKE type_file.chr3,    #NO.FUN-690009 VARCHAR(3)
    g_wc,g_sql,g_wc2    STRING,
    g_rec_b         LIKE type_file.num5,    #NO.FUN-690009 SMALLINT     #單身筆數
    g_flag          LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(1)
    l_ac            LIKE type_file.num5     #NO.FUN-690009 SMALLINT     #目前處理的ARRAY CNT
DEFINE p_row,p_col  LIKE type_file.num5     #NO.FUN-690009 SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE   g_chr           LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #NO.FUN-690009 SMALLINT   #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #NO.FUN-690009 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5     #NO.FUN-690009 SMALLINT
DEFINE g_str             STRING                  #No.FUN-850011
DEFINE g_void            LIKE type_file.chr1      #CHI-C80041
 
MAIN
 
 
# DEFINE      l_time   LIKE type_file.chr8            #No.FUN-6A0097
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("GFA")) THEN
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)              #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
 
    LET p_row = 3 LET p_col = 15
    OPEN WINDOW t100_w AT p_row,p_col           #顯示畫面
        WITH FORM "gfa/42f/gfat100" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
 
 
    LET g_forupd_sql =
        "SELECT * FROM fgj_file WHERE fgj01=? AND fgj02=? AND fgj03=? AND fgj04=?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t100_cl CURSOR FROM g_forupd_sql
 
    CALL t100_menu()
    CLOSE WINDOW t100_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
         RETURNING g_time    #No.FUN-6A0097
END MAIN
 
#QBE 查詢資料
FUNCTION t100_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_fgk.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_fgj.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON
                  fgj01,fgj02,fgj03,fgj04,fgj06,fgj05,
                  fgjconf,fgjuser,fgjgrup,fgjmodu,fgjdate,
                  #FUN-850068   ---start---
                  fgjud01,fgjud02,fgjud03,fgjud04,fgjud05,
                  fgjud06,fgjud07,fgjud08,fgjud09,fgjud10,
                  fgjud11,fgjud12,fgjud13,fgjud14,fgjud15
                  #FUN-850068    ----end----
                  ,fgjacti                                           #TQC-960431
             #--No.MOD-4A0248--------
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
            ON ACTION CONTROLP
              CASE WHEN INFIELD(fgj03) #財產編號
                        CALL cl_init_qry_var()
                        LET g_qryparam.state= "c"
                        LET g_qryparam.form = "q_fgj"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO fgj03
                        NEXT FIELD fgj03
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
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON fgk05,fgk06,fgk07   #螢幕上取單身條件
                       #No.FUN-850068 --start--
                       ,fgkud01,fgkud02,fgkud03,fgkud04,fgkud05
                       ,fgkud06,fgkud07,fgkud08,fgkud09,fgkud10
                       ,fgkud11,fgkud12,fgkud13,fgkud14,fgkud15
                       #No.FUN-850068 ---end---
                  FROM s_fgk[1].fgk05,s_fgk[1].fgk06,s_fgk[1].fgk07
                       #No.FUN-850068 --start--
                       ,s_fgk[1].fgkud01,s_fgk[1].fgkud02,s_fgk[1].fgkud03
                       ,s_fgk[1].fgkud04,s_fgk[1].fgkud05,s_fgk[1].fgkud06
                       ,s_fgk[1].fgkud07,s_fgk[1].fgkud08,s_fgk[1].fgkud09
                       ,s_fgk[1].fgkud10,s_fgk[1].fgkud11,s_fgk[1].fgkud12
                       ,s_fgk[1].fgkud13,s_fgk[1].fgkud14,s_fgk[1].fgkud15
                       #No.FUN-850068 ---end---
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
           CASE WHEN INFIELD(fgk05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fgk05
                    NEXT FIELD fgk05
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
    IF INT_FLAG THEN  RETURN END IF
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #       LET g_wc = g_wc CLIPPED," AND fgjuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #      LET g_wc = g_wc CLIPPED," AND fgjgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #      LET g_wc = g_wc CLIPPED," AND fgjgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fgjuser', 'fgjgrup')
    #End:FUN-980030
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT fgj01,fgj02,fgj03,fgj04 FROM fgj_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY fgj01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE fgj01,fgj02,fgj03,fgj04 ",
                  "  FROM fgj_file, fgk_file ",
                  " WHERE fgj01 = fgk01 AND fgj02 = fgk02 ",
                  "   AND fgj03 = fgk03 AND fgj04 = fgk04 ",
                  "   AND ",g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY fgj01"
    END IF
    PREPARE t100_prepare FROM g_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,0) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
    DECLARE t100_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t100_prepare   #MOD-8A0268 mod
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fgj_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*)",
                  "  FROM fgj_file,fgk_file ",
                  " WHERE fgj01 = fgk01 AND fgj02 = fgk02 ",
                  "   AND fgj03 = fgk03 AND fgj04 = fgk04 ",
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
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
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t100_copy()
            END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL t100_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL t100_b()
           ELSE
              LET g_action_choice = NULL
           END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t100_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t100_z()
            END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL t100_out()
           END IF
        WHEN "help"
           CALL SHOWHELP(1)
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        #No.FUN-6A0150-------add--------str----
        WHEN "related_document"  #相關文件
           IF cl_chk_act_auth() THEN
              IF g_fgj.fgj01 IS NOT NULL THEN
                LET g_doc.column1 = "fgj01"
                LET g_doc.value1 = g_fgj.fgj01
                CALL cl_doc()
              END IF
          END IF
        #No.FUN-6A0150-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t100_v()
            END IF
         #CHI-C80041---end 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t100_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM
    CALL g_fgk.clear()
    INITIALIZE g_fgj.* LIKE fgj_file.*
    LET g_fgj01_t = NULL
    LET g_fgj_t.* = g_fgj.*
    LET g_fgj_o.* = g_fgj.*
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fgj.fgj01 = YEAR(g_today)
        LET g_fgj.fgj02 = MONTH(g_today)
        LET g_fgj.fgjconf ='N'                   #有效的資料
        LET g_fgj.fgjuser = g_user
        LET g_fgj.fgjoriu = g_user #FUN-980030
        LET g_fgj.fgjorig = g_grup #FUN-980030
        LET g_fgj.fgjgrup = g_grup               #使用者所屬群
        LET g_fgj.fgjdate = g_today
        LET g_fgj.fgjacti ='Y'                   #TQC-960431  
        LET g_fgj.fgjlegal = g_legal #FUN-980011 add
 
        CALL t100_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_fgj.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           CALL g_fgk.clear()
           EXIT WHILE
        END IF
        IF g_fgj.fgj01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK
        INSERT INTO fgj_file VALUES(g_fgj.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_fgj.fgj01,SQLCA.sqlcode,0)   #No.FUN-660146
           CALL cl_err3("ins","fgj_file",g_fgj.fgj01,g_fgj.fgj02,SQLCA.sqlcode,"","",1)  #No.FUN-660146
           CONTINUE WHILE
        END IF
        COMMIT WORK
        SELECT fgj01,fgj02,fgj03,fgj04 INTO g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03,g_fgj.fgj04 FROM fgj_file
         WHERE fgj01 = g_fgj.fgj01 AND fgj02 = g_fgj.fgj02 AND
               fgj03 = g_fgj.fgj03 AND fgj04 = g_fgj.fgj04
 
        LET g_fgj01_t = g_fgj.fgj01        #保留舊值
        LET g_fgj_t.* = g_fgj.*
        CALL g_fgk.clear()
        LET g_rec_b=0
        CALL t100_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t100_i(p_cmd)
    DEFINE
        l_sw            LIKE type_file.chr1,    #NO.FUN-690009  VARCHAR(1) #檢查必要欄位是否空白
        p_cmd           LIKE type_file.chr1,    #NO.FUN-690009  VARCHAR(1)
        l_n             LIKE type_file.num5,    #NO.FUN-690009  SMALLINT
        l_cnt           LIKE type_file.num5     #NO.FUN-690009  SMALLINT
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03, g_fgj.fgjoriu,g_fgj.fgjorig,
                  g_fgj.fgj04,g_fgj.fgj06,g_fgj.fgj05,
                  g_fgj.fgjconf,g_fgj.fgjuser,g_fgj.fgjgrup,
                  g_fgj.fgjmodu,g_fgj.fgjdate,
                  #FUN-850068     ---start---
                  g_fgj.fgjud01,g_fgj.fgjud02,g_fgj.fgjud03,g_fgj.fgjud04,
                  g_fgj.fgjud05,g_fgj.fgjud06,g_fgj.fgjud07,g_fgj.fgjud08,
                  g_fgj.fgjud09,g_fgj.fgjud10,g_fgj.fgjud11,g_fgj.fgjud12,
                  g_fgj.fgjud13,g_fgj.fgjud14,g_fgj.fgjud15 
                  #FUN-850068     ----end----
                  ,g_fgj.fgjacti                                          #TQC-960431 
                  WITHOUT DEFAULTS HELP 1
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t100_set_entry(p_cmd)
           CALL t100_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD fgj02
           IF NOT cl_null(g_fgj.fgj02) THEN
              IF g_fgj.fgj02 >12 OR g_fgj.fgj02 < 1 THEN NEXT FIELD fgj02 END IF  
           END IF
 
        AFTER FIELD fgj03
           IF NOT cl_null(g_fgj.fgj03) THEN
              IF p_cmd = 'a' OR
                (p_cmd = 'u' AND g_fgj.fgj03 != g_fgj_t.fgj03) THEN
                 SELECT COUNT(*) INTO l_cnt FROM faj_file
                  WHERE faj02 = g_fgj.fgj03
                 IF l_cnt = 0 THEN
                    CALL cl_err(g_fgj.fgj03,'afa-911',0) NEXT FIELD fgj03
                 END IF
              END IF
           END IF
 
        AFTER FIELD fgj04
           IF g_fgj.fgj04 IS NULL THEN LET g_fgj.fgj04 = ' ' END IF
           IF NOT cl_null(g_fgj.fgj03) THEN
              IF p_cmd = 'a' OR
                (p_cmd = 'u' AND (g_fgj.fgj03 != g_fgj_t.fgj03 OR
                                  g_fgj.fgj04 != g_fgj_t.fgj04)) THEN
                 CALL t100_fgj04('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fgj.fgj04,g_errno,0) NEXT FIELD fgj04
                 END IF
                 SELECT COUNT(*) INTO l_cnt FROM fgj_file
                  WHERE fgj01 = g_fgj.fgj01 AND fgj02 = g_fgj.fgj02
                    AND fgj03 = g_fgj.fgj03 AND fgj04 = g_fgj.fgj04
                 IF l_cnt > 0  THEN
                    CALL cl_err('',-239,0) NEXT FIELD fgj01
                 END IF
              END IF
           END IF
 
        #FUN-850068     ---start---
        AFTER FIELD fgjud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgjud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgjud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgjud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgjud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgjud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgjud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgjud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgjud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgjud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgjud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgjud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgjud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgjud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgjud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-850068     ----end----
 
        AFTER INPUT
           LET g_fgj.fgjuser = s_get_data_owner("fgj_file") #FUN-C10039
           LET g_fgj.fgjgrup = s_get_data_group("fgj_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(fgj01) THEN
      #          LET g_fgj.* = g_fgj_t.*
      #          DISPLAY BY NAME g_fgj.* ATTRIBUTE(YELLOW)
      #          NEXT FIELD fgj01
      #      END IF
      #MOD-650015 --end
        ON ACTION CONTROLP
           CASE WHEN INFIELD(fgj03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_faj"
                    LET g_qryparam.default1 = g_fgj.fgj03
                    LET g_qryparam.default2 = g_fgj.fgj04
                    CALL cl_create_qry() RETURNING g_fgj.fgj03,g_fgj.fgj04
                    DISPLAY BY NAME g_fgj.fgj03,g_fgj.fgj04
                    NEXT FIELD fgj04
                OTHERWISE EXIT CASE
            END CASE
 
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
END FUNCTION
 
FUNCTION t100_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1     #NO.FUN-690009  VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fgj01,fgj02,fgj03,fgj04",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t100_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #NO.FUN-690009  VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fgj01,fgj02,fgj03,fgj04",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t100_fgj04(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1000, #NO.FUN-690009  VARCHAR(1)
       l_faj06    LIKE faj_file.faj06,
       l_faj106   LIKE faj_file.faj106,
       l_faj107   LIKE faj_file.faj107,
       l_fajconf  LIKE faj_file.fajconf
 
       LET g_errno = ''
       SELECT faj06,faj106,faj107,fajconf
         INTO l_faj06,l_faj106,l_faj107,l_fajconf FROM faj_file
        WHERE faj02 = g_fgj.fgj03 AND faj022 = g_fgj.fgj04
       CASE
         WHEN SQLCA.SQLCODE = 100    LET g_errno = 'afa-041'
         WHEN l_fajconf  = 'N'       LET g_errno = '9029'
         OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
 
       IF cl_null(g_errno) OR p_cmd = 'd' THEN
          DISPLAY l_faj06 TO faj06
          DISPLAY l_faj106 TO faj106
          DISPLAY l_faj107 TO faj107
       END IF
END FUNCTION
 
FUNCTION t100_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fgj.* TO NULL              #No.FUN-6A0150
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(GREEN)
    CALL t100_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE "Waiting...." ATTRIBUTE(REVERSE)
    OPEN t100_count
    FETCH t100_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fgj.fgj01,SQLCA.sqlcode,0)
        INITIALIZE g_fgj.* TO NULL
    ELSE
        CALL t100_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t100_fetch(p_flag)
    DEFINE
        p_flag          LIKE type_file.chr1,    #NO.FUN-690009  VARCHAR(1)
        l_abso          LIKE type_file.num10    #NO.FUN-690009  INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t100_cs INTO g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03,g_fgj.fgj04
        WHEN 'P' FETCH PREVIOUS t100_cs INTO g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03,g_fgj.fgj04
        WHEN 'F' FETCH FIRST    t100_cs INTO g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03,g_fgj.fgj04
        WHEN 'L' FETCH LAST     t100_cs INTO g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03,g_fgj.fgj04
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
                  PROMPT g_msg CLIPPED || ': ' FOR g_jump
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
            FETCH ABSOLUTE g_jump t100_cs INTO g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03,g_fgj.fgj04
            LET mi_no_ask = FALSE
 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fgj.* TO NULL  #TQC-6B0105
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
 
    SELECT * INTO g_fgj.* FROM fgj_file            # 重讀DB,因TEMP有不被更新特性
       WHERE fgj01= g_fgj.fgj01 AND fgj02= g_fgj.fgj02 AND fgj03= g_fgj.fgj03 AND fgj04= g_fgj.fgj04 
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fgj.fgj01,SQLCA.sqlcode,0)   #No.FUN-660146
        CALL cl_err3("sel","fgj_file",g_fgj.fgj01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660146
    ELSE
        LET g_data_owner = g_fgj.fgjuser  #FUN-4C0058
        LET g_data_group = g_fgj.fgjgrup  #FUN-4C0058
        CALL t100_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t100_show()
    LET g_fgj_t.* = g_fgj.*
    DISPLAY BY NAME g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03, g_fgj.fgjoriu,g_fgj.fgjorig,
                    g_fgj.fgj04,g_fgj.fgj06,g_fgj.fgj05,
                    g_fgj.fgjconf,g_fgj.fgjuser,g_fgj.fgjgrup,
                    g_fgj.fgjmodu,g_fgj.fgjdate,
                    #FUN-850068     ---start---
                    g_fgj.fgjud01,g_fgj.fgjud02,g_fgj.fgjud03,g_fgj.fgjud04,
                    g_fgj.fgjud05,g_fgj.fgjud06,g_fgj.fgjud07,g_fgj.fgjud08,
                    g_fgj.fgjud09,g_fgj.fgjud10,g_fgj.fgjud11,g_fgj.fgjud12,
                    g_fgj.fgjud13,g_fgj.fgjud14,g_fgj.fgjud15 
                    #FUN-850068     ----end----
                    ,g_fgj.fgjacti                                           #TQC-960431
    CALL t100_fgj04('d')
    CALL t100_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t100_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fgj.fgj01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_fgj.* FROM fgj_file
     WHERE fgj01 = g_fgj.fgj01 AND fgj02 = g_fgj.fgj02
       AND fgj03 = g_fgj.fgj03 AND fgj04 = g_fgj.fgj04
    IF g_fgj.fgjconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_fgj.fgjconf ='Y' THEN    #檢查資料是否為審核
       CALL cl_err(g_fgj.fgj01,'9022',0) RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fgj01_t = g_fgj.fgj01
    LET g_fgj02_t = g_fgj.fgj02
    LET g_fgj03_t = g_fgj.fgj03
    LET g_fgj04_t = g_fgj.fgj04
    LET g_fgj_t.* = g_fgj.*
    LET g_fgj_o.* = g_fgj.*
    BEGIN WORK
    OPEN t100_cl USING g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03,g_fgj.fgj04
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fgj.fgj01,SQLCA.sqlcode,0)
       CLOSE t100_cl ROLLBACK WORK RETURN
    END IF
    FETCH t100_cl INTO g_fgj.*               # 對DB鎖定
    LET g_fgj.fgjmodu=g_user                     #修改者
    LET g_fgj.fgjdate = g_today                  #修改日期
    CALL t100_show()                             # 顯示最新資料
    WHILE TRUE
        CALL t100_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fgj.*=g_fgj_t.*
            CALL t100_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF (g_fgj.fgj01 != g_fgj01_t OR g_fgj.fgj02 != g_fgj02_t OR
            g_fgj.fgj03 != g_fgj03_t OR g_fgj.fgj04 != g_fgj04_t) THEN
            UPDATE fgk_file SET fgk01= g_fgj.fgj01,
                                fgk02= g_fgj.fgj02,
                                fgk03= g_fgj.fgj03,
                                fgk04= g_fgj.fgj04
             WHERE fgk01 = g_fgj01_t AND fgk02 = g_fgk02_t
               AND fgk03 = g_fgj03_t AND fgk04 = g_fgk04_t
            IF SQLCA.sqlcode THEN
#              CALL cl_err('update fgk:',SQLCA.sqlcode,0)   #No.FUN-660146
              CALL cl_err3("upd","fgk_file",g_fgj01_t,g_fgj03_t,SQLCA.sqlcode,"","update fgk",1)  #No.FUN-660146
               CONTINUE WHILE
            END IF
        END IF
        UPDATE fgj_file SET fgj_file.* = g_fgj.*    # 更新DB
        WHERE fgj01= g_fgj01_t AND fgj02= g_fgj02_t AND fgj03= g_fgj03_t AND fgj04= g_fgj04_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_fgj.fgj01,SQLCA.sqlcode,0)   #No.FUN-660146
            CALL cl_err3("upd","fgj_file",g_fgj01_t,g_fgj02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660146
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t100_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t100_r()
    DEFINE l_chr LIKE type_file.chr1     #NO.FUN-690009  VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fgj.fgj01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_fgj.fgjconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_fgj.fgjconf ='Y' THEN    #檢查資料是否為審核
       CALL cl_err(g_fgj.fgj01,'9022',0) RETURN
    END IF
    BEGIN WORK
    OPEN t100_cl USING g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03,g_fgj.fgj04
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fgj.fgj01,SQLCA.sqlcode,0)
        RETURN
    END IF
    FETCH t100_cl INTO g_fgj.*               # 對DB鎖定
    CALL t100_show()
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fgj01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fgj.fgj01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM fgj_file WHERE fgj01= g_fgj.fgj01 AND fgj02= g_fgj.fgj02 AND fgj03= g_fgj.fgj03 AND fgj04= g_fgj.fgj04 
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_fgj.fgj01,SQLCA.sqlcode,0)   #No.FUN-660146
           CALL cl_err3("del","fgj_file",g_fgj.fgj01,g_fgj.fgj02,SQLCA.sqlcode,"","",1)  #No.FUN-660146
        ELSE
           DELETE FROM fgk_file
            WHERE fgk01 = g_fgj.fgj01 AND fgk02 = g_fgj.fgj02
              AND fgk03 = g_fgj.fgj03 AND fgk04 = g_fgj.fgj04
           CLEAR FORM
           CALL g_fgk.clear()
        END IF
        OPEN t100_count
#FUN-B50065------begin---
        IF STATUS THEN
           CLOSE t100_count
           CLOSE t100_cl
           COMMIT WORK
           RETURN
        END IF
#FUN-B50065------end------
        FETCH t100_count INTO g_row_count
#FUN-B50065------begin---
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t100_count
           CLOSE t100_cl
           COMMIT WORK
           RETURN
        END IF
#FUN-B50065------end------
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
    END IF
    CLOSE t100_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION t100_b()
DEFINE
    l_buf           LIKE type_file.chr1000, #NO.FUN-690009  VARCHAR(80)  #儲存尚在使用中之下游檔案之檔名
    l_ac_t          LIKE type_file.num5,    #NO.FUN-690009  SMALLINT  #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,    #NO.FUN-690009  SMALLINT  #檢查重複用
    l_lock_sw       LIKE type_file.chr1,    #NO.FUN-690009  VARCHAR(1)   #單身鎖住否
    p_cmd           LIKE type_file.chr1,    #NO.FUN-690009  VARCHAR(1)   #處理狀態
    l_bcur          LIKE type_file.chr1,    #NO.FUN-690009  VARCHAR(1)   #'1':表存放位置有值,'2':則為NULL
    l_no            LIKE type_file.chr2,    #NO.FUN-690009  VARCHAR(2)
    l_fgk05         LIKE fgk_file.fgk05,
    l_allow_insert  LIKE type_file.num5,    #NO.FUN-690009  SMALLINT  #可新增否
    l_allow_delete  LIKE type_file.num5     #NO.FUN-690009  SMALLINT  #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fgj.fgj01 IS NULL THEN RETURN END IF
 
    SELECT * INTO g_fgj.* FROM fgj_file
     WHERE fgj01=g_fgj.fgj01 AND fgj02 = g_fgj.fgj02
       AND fgj03=g_fgj.fgj03 AND fgj04 = g_fgj.fgj04
    IF g_fgj.fgjconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_fgj.fgjconf ='Y' THEN    #檢查資料是否為審核
       CALL cl_err(g_fgj.fgj01,'9022',0) RETURN
    END IF
 
    CALL cl_opmsg('b')
    LET g_forupd_sql =
        "SELECT fgk05,'',fgk06,fgk07,", 
        #No.FUN-850068 --start--
        "       fgkud01,fgkud02,fgkud03,fgkud04,fgkud05,",
        "       fgkud06,fgkud07,fgkud08,fgkud09,fgkud10,",
        "       fgkud11,fgkud12,fgkud13,fgkud14,fgkud15 ", 
        #No.FUN-850068 ---end---
        "  FROM fgk_file ",
        " WHERE fgk01 = ? AND fgk02 = ? AND fgk03 = ? ",
        "   AND fgk04 = ? AND fgk05 = ?  FOR UPDATE "
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE t100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_fgk WITHOUT DEFAULTS FROM s_fgk.*
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
            OPEN t100_cl USING g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03,g_fgj.fgj04
            IF STATUS THEN
               CALL cl_err("OPEN t100_cl:", STATUS, 1)
               CLOSE t100_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_fgj.fgj01,SQLCA.sqlcode,0)
                CLOSE t100_cl ROLLBACK WORK RETURN
            END IF
            FETCH t100_cl INTO g_fgj.*               # 對DB鎖定
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_fgk_t.* = g_fgk[l_ac].*  #BACKUP
                OPEN t100_bcl USING g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03,
                                    g_fgj.fgj04,g_fgk_t.fgk05
                IF STATUS THEN
                   CALL cl_err("OPEN t100_bcl:", STATUS, 1)
                   LET l_lock_sw='Y'
                ELSE
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_fgk_t.fgk05,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   FETCH t100_bcl INTO g_fgk[l_ac].*
                   SELECT gem02 INTO g_fgk[l_ac].gem02 FROM gem_file
                    WHERE gem01 = g_fgk[l_ac].fgk05
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_fgk[l_ac].* TO NULL      #900423
            LET g_fgk_t.* = g_fgk[l_ac].*     #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fgk05
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
         #-----TQC-620120---------
         IF cl_null(g_fgj.fgj04) THEN
            LET g_fgj.fgj04 = ' '
         END IF
         #-----END TQC-620120-----
         INSERT INTO fgk_file(fgk01,fgk02,fgk03,fgk04,fgk05,
                                 fgk06,fgk07,
                              #FUN-850068 --start--
                              fgkud01,fgkud02,fgkud03,
                              fgkud04,fgkud05,fgkud06,
                              fgkud07,fgkud08,fgkud09,
                              fgkud10,fgkud11,fgkud12,
                              fgkud13,fgkud14,fgkud15,
                              #FUN-850068 --end--
                              fgklegal)     #FUN-980011 add
                          VALUES(g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03,
                                 g_fgj.fgj04,g_fgk[l_ac].fgk05,
                                 g_fgk[l_ac].fgk06,g_fgk[l_ac].fgk07,
                                 #FUN-850068 --start--
                                 g_fgk[l_ac].fgkud01,g_fgk[l_ac].fgkud02,
                                 g_fgk[l_ac].fgkud03,g_fgk[l_ac].fgkud04,
                                 g_fgk[l_ac].fgkud05,g_fgk[l_ac].fgkud06,
                                 g_fgk[l_ac].fgkud07,g_fgk[l_ac].fgkud08,
                                 g_fgk[l_ac].fgkud09,g_fgk[l_ac].fgkud10,
                                 g_fgk[l_ac].fgkud11,g_fgk[l_ac].fgkud12,
                                 g_fgk[l_ac].fgkud13,g_fgk[l_ac].fgkud14,
                                 g_fgk[l_ac].fgkud15,
                                 #FUN-850068 --end--
                                 g_legal) #FUN-980011 add
            IF SQLCA.SQLcode  THEN
#              CALL cl_err(g_fgk[l_ac].fgk05,SQLCA.sqlcode,0)   #No.FUN-660146
               CALL cl_err3("ins","fgk_file",g_fgj.fgj01,g_fgk[l_ac].fgk05,SQLCA.sqlcode,"","",1)  #No.FUN-660146
               CANCEL INSERT
            ELSE
               CALL t100_fgj05()
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            END IF
 
        AFTER FIELD fgk05
            IF NOT cl_null(g_fgk[l_ac].fgk05) THEN
               IF g_fgk[l_ac].fgk05 IS NOT NULL AND
                  (g_fgk[l_ac].fgk05 != g_fgk_t.fgk05 OR
                   g_fgk_t.fgk05 IS NULL) THEN
                   SELECT COUNT(*) INTO l_n FROM fgk_file
                    WHERE fgk01 = g_fgj.fgj01 AND fgk02 = g_fgj.fgj02 AND
                          fgk03 = g_fgj.fgj03 AND fgk04 = g_fgj.fgj04 AND
                          fgk05 = g_fgk[l_ac].fgk05
                   IF l_n > 0 THEN
                       CALL cl_err(g_fgk[l_ac].fgk05,-239,0)
                       LET g_fgk[l_ac].fgk05 = g_fgk_t.fgk05
                       NEXT FIELD fgk05
                   END IF
                   SELECT gem02 INTO g_fgk[l_ac].gem02 FROM gem_file
                    WHERE gem01 = g_fgk[l_ac].fgk05 AND gemacti = 'Y'
                   IF STATUS THEN
#                     CALL cl_err(g_fgk[l_ac].fgk05,'aoo-005',0)   #No.FUN-660146
                      CALL cl_err3("sel","gem_file",g_fgk[l_ac].fgk05,"","aoo-005","","",1)  #No.FUN-660146
                      NEXT FIELD fgk05
                   END IF
               END IF
            END IF
 
        AFTER FIELD fgk06
            IF g_fgk[l_ac].fgk06 < 0 THEN NEXT FIELD fgk06 END IF
            IF cl_null(g_fgk[l_ac].fgk06) THEN
                LET g_fgk[l_ac].fgk06 = 0
            END IF
 
        #No.FUN-850068 --start--
        AFTER FIELD fgkud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgkud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgkud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgkud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgkud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgkud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgkud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgkud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgkud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgkud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgkud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgkud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgkud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgkud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fgkud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-850068 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_fgk_t.fgk05 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM fgk_file
                 WHERE fgk01=g_fgj.fgj01 AND fgk02=g_fgj.fgj02
                   AND fgk03=g_fgj.fgj03 AND fgk04=g_fgj.fgj04
                   AND fgk05=g_fgk_t.fgk05
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_fgk_t.fgk05,SQLCA.sqlcode,0)   #No.FUN-660146
                    CALL cl_err3("del","fgk_file",g_fgj.fgj01,g_fgk_t.fgk05,SQLCA.sqlcode,"","",1)  #No.FUN-660146
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                MESSAGE "Delete Ok"
                CLOSE t100_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fgk[l_ac].* = g_fgk_t.*
               CLOSE t100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fgk[l_ac].fgk05,-263,1)
               LET g_fgk[l_ac].* = g_fgk_t.*
            ELSE
               UPDATE fgk_file SET fgk05=g_fgk[l_ac].fgk05,
                                   fgk06=g_fgk[l_ac].fgk06,
                                   fgk07=g_fgk[l_ac].fgk07,
                                   #FUN-850068 --start--
                                   fgkud01 = g_fgk[l_ac].fgkud01,
                                   fgkud02 = g_fgk[l_ac].fgkud02,
                                   fgkud03 = g_fgk[l_ac].fgkud03,
                                   fgkud04 = g_fgk[l_ac].fgkud04,
                                   fgkud05 = g_fgk[l_ac].fgkud05,
                                   fgkud06 = g_fgk[l_ac].fgkud06,
                                   fgkud07 = g_fgk[l_ac].fgkud07,
                                   fgkud08 = g_fgk[l_ac].fgkud08,
                                   fgkud09 = g_fgk[l_ac].fgkud09,
                                   fgkud10 = g_fgk[l_ac].fgkud10,
                                   fgkud11 = g_fgk[l_ac].fgkud11,
                                   fgkud12 = g_fgk[l_ac].fgkud12,
                                   fgkud13 = g_fgk[l_ac].fgkud13,
                                   fgkud14 = g_fgk[l_ac].fgkud14,
                                   fgkud15 = g_fgk[l_ac].fgkud15
                                   #FUN-850068 --end-- 
                WHERE CURRENT OF t100_bcl
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_fgk[l_ac].fgk05,SQLCA.sqlcode,0)   #No.FUN-660146
                   CALL cl_err3("upd","fgk_file",g_fgj.fgj01,g_fgk_t.fgk05,SQLCA.sqlcode,"","",1)  #No.FUN-660146
                   LET g_fgk[l_ac].* = g_fgk_t.*
                   CLOSE t100_bcl
                   ROLLBACK WORK
               ELSE
                   CALL t100_fgj05()
                   MESSAGE 'UPDATE O.K'
                   CLOSE t100_bcl
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
                  LET g_fgk[l_ac].* = g_fgk_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_fgk.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end-- 
               END IF
               CLOSE t100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D30032 Add   
            CLOSE t100_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL t100_b_askkey()
            EXIT INPUT
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(fgk05) AND l_ac > 1 THEN
                LET g_fgk[l_ac].* = g_fgk[l_ac-1].*
                NEXT FIELD fgk05
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(fgk05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem"
                  LET g_qryparam.default1 = g_fgk[l_ac].fgk05
                  CALL cl_create_qry() RETURNING g_fgk[l_ac].fgk05
                  NEXT FIELD fgk05
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
 
        END INPUT
 
 
   #FUN-5B0116-begin
    LET g_fgj.fgjmodu = g_user
    LET g_fgj.fgjdate = g_today
    UPDATE fgj_file SET fgjmodu = g_fgj.fgjmodu,fgjdate = g_fgj.fgjdate
     WHERE fgj01 = g_fgj.fgj01
       AND fgj02 = g_fgj.fgj02
       AND fgj03 = g_fgj.fgj03
       AND fgj04 = g_fgj.fgj04
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err('upd fgj',SQLCA.SQLCODE,1)   #No.FUN-660146
       CALL cl_err3("upd","fgj_file",g_fgj.fgj01,g_fgj.fgj02,SQLCA.sqlcode,"","upd fgj",1)  #No.FUN-660146
    END IF
    DISPLAY BY NAME g_fgj.fgjmodu,g_fgj.fgjdate
   #FUN-5B0116-end
 
    CLOSE t100_bcl
    CLOSE t100_cl
    COMMIT WORK
    CALL t100_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t100_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
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
         CALL t100_v()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN #CHI-C80041
         DELETE FROM fgj_file  WHERE fgj01 = g_fgj.fgj01
                                 AND fgj02 = g_fgj.fgj02
                                 AND fgj03 = g_fgj.fgj03
                                 AND fgj04 = g_fgj.fgj04
         INITIALIZE g_fgj.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t100_fgj05()
DEFINE  l_fgj05  LIKE fgj_file.fgj05
 
    LET l_fgj05 = 0
    SELECT SUM(fgk06) INTO l_fgj05 FROM fgk_file
     WHERE fgk01 = g_fgj.fgj01 AND fgk02 = g_fgj.fgj02
       AND fgk03 = g_fgj.fgj03 AND fgk04 = g_fgj.fgj04
    IF cl_null(l_fgj05) THEN LET l_fgj05 = 0 END IF
 
    UPDATE fgj_file SET fgj05 = l_fgj05
     WHERE fgj01=g_fgj.fgj01 AND fgj02=g_fgj.fgj02
       AND fgj03=g_fgj.fgj03 AND fgj04=g_fgj.fgj04
    IF STATUS THEN
#      CALL cl_err('upd fgjconf',STATUS,0)   #No.FUN-660146
       CALL cl_err3("upd","fgj_file",g_fgj.fgj01,g_fgj.fgj02,STATUS,"","upd fgjconf",1)  #No.FUN-660146
    END IF
    LET g_fgj.fgj05 = l_fgj05
    DISPLAY BY NAME g_fgj.fgj05
END FUNCTION
 
FUNCTION t100_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000  #NO.FUN-690009  VARCHAR(200)
 
    CONSTRUCT l_wc ON fgk05,fgk06,fgk07            #螢幕上取單身條件
                      #No.FUN-850068 --start--
                      ,fgkud01,fgkud02,fgkud03,fgkud04,fgkud05
                      ,fgkud06,fgkud07,fgkud08,fgkud09,fgkud10
                      ,fgkud11,fgkud12,fgkud13,fgkud14,fgkud15
                      #No.FUN-850068 ---end---
                 FROM s_fgk[1].fgk05,s_fgk[1].fgk06,s_fgk[1].fgk07
                      #No.FUN-850068 --start--
                      ,s_fgk[1].fgkud01,s_fgk[1].fgkud02,s_fgk[1].fgkud03
                      ,s_fgk[1].fgkud04,s_fgk[1].fgkud05,s_fgk[1].fgkud06
                      ,s_fgk[1].fgkud07,s_fgk[1].fgkud08,s_fgk[1].fgkud09
                      ,s_fgk[1].fgkud10,s_fgk[1].fgkud11,s_fgk[1].fgkud12
                      ,s_fgk[1].fgkud13,s_fgk[1].fgkud14,s_fgk[1].fgkud15
                      #No.FUN-850068 ---end---
 
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
    CALL t100_b_fill(l_wc)
END FUNCTION
 
FUNCTION t100_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000  #NO.FUN-690009  VARCHAR(400)
 
    LET g_sql = "SELECT fgk05,gem02,fgk06,fgk07,",
                #No.FUN-850068 --start--
                "       fgkud01,fgkud02,fgkud03,fgkud04,fgkud05,",
                "       fgkud06,fgkud07,fgkud08,fgkud09,fgkud10,",
                "       fgkud11,fgkud12,fgkud13,fgkud14,fgkud15 ", 
                #No.FUN-850068 ---end---
                "  FROM fgk_file,gem_file",
                " WHERE fgk01 = '",g_fgj.fgj01,"'",
                "   AND fgk02 = '",g_fgj.fgj02,"'",
                "   AND fgk03 = '",g_fgj.fgj03,"'",
                "   AND fgk04 = '",g_fgj.fgj04,"'",
                "   AND gem01 = fgk05 ",
                "   AND ",p_wc CLIPPED ,
                " ORDER BY 1"
    PREPARE t100_prepare2 FROM g_sql      #預備一下
    DECLARE fgk_cs CURSOR FOR t100_prepare2
    CALL g_fgk.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH fgk_cs INTO g_fgk[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('','9035',0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fgk.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t100_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1000  #NO.FUN-690009  VARCHAR(1)
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fgk TO s_fgk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
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
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
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
 
      ON ACTION related_document                #No.FUN-6A0150  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
      #FUN-810046
      &include "qry_string.4gl"
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t100_copy()
DEFINE
    l_newno          LIKE fgj_file.fgj01,
    l_newno2         LIKE fgj_file.fgj02,
    l_newno3         LIKE fgj_file.fgj03,
    l_newno4         LIKE fgj_file.fgj04,
    l_oldno          LIKE fgj_file.fgj01,
    l_oldno2         LIKE fgj_file.fgj02,
    l_oldno3         LIKE fgj_file.fgj03,
    l_oldno4         LIKE fgj_file.fgj04,
    l_cnt            LIKE type_file.num5     #NO.FUN-690009  SMALLINT
 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fgj.fgj01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    CALL cl_getmsg('copy',g_lang) RETURNING g_msg
    LET g_before_input_done = FALSE
    CALL t100_set_entry('a')
    LET g_before_input_done = TRUE
    DISPLAY g_msg AT 2,1 #ATTRIBUTE(RED)    #No.FUN-940135
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT l_newno,l_newno2,l_newno3,l_newno4 FROM fgj01,fgj02,fgj03,fgj04
        AFTER FIELD fgj02
           IF l_newno2 >12 OR l_newno2 < 1 THEN NEXT FIELD fgj02 END IF
        AFTER FIELD fgj03
            IF NOT cl_null(l_newno3) THEN
               SELECT COUNT(*) INTO l_cnt FROM faj_file
                WHERE faj02 = l_newno3
               IF l_cnt = 0 THEN
                  CALL cl_err(l_newno3,'afa-911',0) NEXT FIELD fgj03
               END IF
            END IF
        AFTER FIELD fgj04
            IF l_newno4 IS NULL THEN LET l_newno4 = ' ' END IF
            SELECT COUNT(*) INTO l_cnt FROM fgj_file
             WHERE fgj01 = l_newno  AND fgj02 = l_newno2
               AND fgj03 = l_newno3 AND fgj04 = l_newno4
            IF l_cnt > 0  THEN
               CALL cl_err('',-239,0) NEXT FIELD fgj01
            END IF
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(fgj03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_faj"
                    LET g_qryparam.default1 = l_newno3
                    LET g_qryparam.default2 = l_newno4
                    CALL cl_create_qry() RETURNING l_newno3,l_newno4
                    DISPLAY l_newno3 TO fgj03
                    DISPLAY l_newno4 TO fgj04
                    NEXT FIELD fgj04
                OTHERWISE EXIT CASE
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
    IF INT_FLAG OR l_newno IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM fgj_file
     WHERE fgj01=g_fgj.fgj01 AND fgj02=g_fgj.fgj02
       AND fgj03=g_fgj.fgj03 AND fgj04=g_fgj.fgj04
      INTO TEMP y
    UPDATE y
        SET y.fgj01=l_newno,    #資料鍵值
            y.fgj02=l_newno2,
            y.fgj03=l_newno3,
            y.fgj04=l_newno4,
            y.fgjuser = g_user,
            y.fgjgrup = g_grup,
            y.fgjdate = g_today,
            y.fgjconf = 'N'
    INSERT INTO fgj_file  #複製單頭
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
#      CALL  cl_err(l_newno,SQLCA.sqlcode,0)  #No.FUN-660146
       CALL cl_err3("ins","fgj_file",l_newno,l_newno2,SQLCA.sqlcode,"","",1)  #No.FUN-660146
    END IF
    DROP TABLE x
    SELECT * FROM fgk_file
       WHERE fgk01 = g_fgj.fgj01 AND fgk02 = g_fgj.fgj02
         AND fgk03 = g_fgj.fgj03 AND fgk04 = g_fgj.fgj04
        INTO TEMP x
    UPDATE x
       SET fgk01 = l_newno,
           fgk02 = l_newno2,
           fgk03 = l_newno3,
           fgk04 = l_newno4
 
    INSERT INTO fgk_file    #複製單身
       SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660146
        CALL cl_err3("ins","fgk_file",l_newno,l_newno2,SQLCA.sqlcode,"","",1)  #No.FUN-660146
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K' ATTRIBUTE(REVERSE)
        LET l_oldno  = g_fgj.fgj01
        LET l_oldno2 = g_fgj.fgj02
        LET l_oldno3 = g_fgj.fgj03
        LET l_oldno4 = g_fgj.fgj04
 
        SELECT fgj_file.* INTO g_fgj.* FROM fgj_file
         WHERE fgj01 = l_newno  AND fgj02 = l_newno2
           AND fgj03 = l_newno3 AND fgj04 = l_newno4
        CALL t100_u()
        #FUN-C80046---begin
        #SELECT fgj_file.* INTO g_fgj.* FROM fgj_file
        # WHERE fgj01 = l_oldno  AND fgj02 = l_oldno2
        #   AND fgj03 = l_oldno3 AND fgj04 = l_oldno4
        #CALL t100_show()
        #FUN-C80046---end
    END IF
END FUNCTION
 
FUNCTION t100_y() #確認
    DEFINE l_faj107    LIKE faj_file.faj107
 
    IF g_fgj.fgj01 IS NULL THEN RETURN END IF
#CHI-C30107 --------------- add ----------------- begin
    IF g_fgj.fgjconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_fgj.fgjconf='Y' THEN RETURN END IF
    IF (g_fgj.fgj01*12 + g_fgj.fgj02) < (g_faa.faa07*12 +g_faa.faa08) THEN
       CALL cl_err('','afa-308',0)
       RETURN
    END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 --------------- add ----------------- end
    SELECT * INTO g_fgj.* FROM fgj_file
     WHERE fgj01=g_fgj.fgj01 AND fgj02 = g_fgj.fgj02
       AND fgj03=g_fgj.fgj03 AND fgj04 = g_fgj.fgj04
    IF g_fgj.fgjconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_fgj.fgjconf='Y' THEN RETURN END IF
    IF (g_fgj.fgj01*12 + g_fgj.fgj02) < (g_faa.faa07*12 +g_faa.faa08) THEN
       CALL cl_err('','afa-308',0)
       RETURN
    END IF
 
    #No.TQC-7B0032  --Begin
    #IF NOT cl_conf(17,12,'axm-108') THEN RETURN END IF
#   IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
    #No.TQC-7B0032  --End  
    LET g_success='Y'
    BEGIN WORK
    OPEN t100_cl USING g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03,g_fgj.fgj04
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fgj.fgj01,SQLCA.sqlcode,0)
        CLOSE t100_cl
        ROLLBACK WORK
        RETURN
    END IF
    FETCH t100_cl INTO g_fgj.*  # 對DB鎖定
    UPDATE fgj_file SET fgjconf='Y'
     WHERE fgj01 = g_fgj.fgj01 AND fgj02 = g_fgj.fgj02
       AND fgj03 = g_fgj.fgj03 AND fgj04 = g_fgj.fgj04
    IF STATUS THEN
#      CALL cl_err('upd fgjconf',STATUS,0)   #No.FUN-660146
       CALL cl_err3("upd","fgj_file",g_fgj.fgj01,g_fgj.fgj02,STATUS,"","upd fgjconf",1)  #No.FUN-660146
       LET g_success = 'N'
    END IF
    #更新資產主檔的已耗工作量
    SELECT SUM(fgj05) INTO l_faj107 FROM fgj_file
     WHERE fgj03 = g_fgj.fgj03
       AND fgj04 = g_fgj.fgj04
       AND fgjconf = 'Y'
    IF cl_null(l_faj107) THEN LET l_faj107 = 0 END IF
 
    UPDATE faj_file SET faj107 = l_faj107,
                        faj111 = l_faj107
     WHERE faj02 = g_fgj.fgj03 AND faj022 = g_fgj.fgj04
    IF STATUS THEN
#      CALL cl_err('upd faj107',STATUS,0)   #No.FUN-660146
       CALL cl_err3("upd","faj_file",g_fgj.fgj03,g_fgj.fgj04,STATUS,"","upd faj107",1)  #No.FUN-660146
       LET g_success = 'N' 
    END IF
 
    IF g_success = 'Y' THEN
       COMMIT WORK CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK CALL cl_rbmsg(1)
    END IF
 
    SELECT fgjconf INTO g_fgj.fgjconf FROM fgj_file
     WHERE fgj01 = g_fgj.fgj01 AND fgj02 = g_fgj.fgj02
       AND fgj03 = g_fgj.fgj03 AND fgj04 = g_fgj.fgj04
    DISPLAY BY NAME g_fgj.fgjconf
    DISPLAY l_faj107 TO faj107
END FUNCTION
 
FUNCTION t100_z() #取消確認
    DEFINE l_faj107    LIKE faj_file.faj107
 
    IF g_fgj.fgj01 IS NULL THEN RETURN END IF
 
    SELECT * INTO g_fgj.* FROM fgj_file
     WHERE fgj01 = g_fgj.fgj01 AND fgj02 = g_fgj.fgj02
       AND fgj03 = g_fgj.fgj03 AND fgj04 = g_fgj.fgj04
    IF g_fgj.fgjconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_fgj.fgjconf='N' THEN RETURN END IF
    IF (g_fgj.fgj01*12 + g_fgj.fgj02) < (g_faa.faa07*12 +g_faa.faa08) THEN
       CALL cl_err('','afa-308',0) RETURN
    END IF
    #No.TQC-7B0032  --Begin
    #IF NOT cl_conf(17,12,'axm-109') THEN RETURN END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF
    #No.TQC-7B0032  --End  
    LET g_success='Y'
    BEGIN WORK
    OPEN t100_cl USING g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03,g_fgj.fgj04
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t100_cl INTO g_fgj.*               # 對DB鎖定
    UPDATE fgj_file SET fgjconf='N'
     WHERE fgj01 = g_fgj.fgj01 AND fgj02 = g_fgj.fgj02
       AND fgj03 = g_fgj.fgj03 AND fgj04 = g_fgj.fgj04
    IF STATUS THEN
#      CALL cl_err('upd cofconf',STATUS,0)   #No.FUN-660146
       CALL cl_err3("upd","fgj_file",g_fgj.fgj01,g_fgj.fgj02,STATUS,"","upd cofconf",1)  #No.FUN-660146
       LET g_success='N' 
    END IF
    #更新資產主檔的已耗工作量
    SELECT SUM(fgj05) INTO l_faj107 FROM fgj_file
     WHERE fgj03 = g_fgj.fgj03
       AND fgj04 = g_fgj.fgj04
       AND fgjconf = 'Y'
    IF cl_null(l_faj107) THEN LET l_faj107 = 0 END IF
 
    UPDATE faj_file SET faj107 = l_faj107,
                        faj111 = l_faj107
     WHERE faj02 = g_fgj.fgj03 AND faj022 = g_fgj.fgj04
    IF STATUS THEN
#      CALL cl_err('upd faj107',STATUS,0)  #No.FUN-660146
       CALL cl_err3("upd","faj_file",g_fgj.fgj03,g_fgj.fgj04,STATUS,"","upd faj107",1)  #No.FUN-660146
       LET g_success = 'N'  
    END IF
 
    IF g_success = 'Y' THEN
       COMMIT WORK CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK CALL cl_rbmsg(1)
    END IF
 
    SELECT fgjconf INTO g_fgj.fgjconf FROM fgj_file
     WHERE fgj01 = g_fgj.fgj01 AND fgj02 = g_fgj.fgj02
       AND fgj03 = g_fgj.fgj03 AND fgj04 = g_fgj.fgj04
    DISPLAY BY NAME g_fgj.fgjconf
    DISPLAY l_faj107 TO faj107
END FUNCTION
 
FUNCTION t100_out()
DEFINE
    l_i             LIKE type_file.num5,    #NO.FUN-690009  SMALLINT
    sr              RECORD
                    fgj01       LIKE fgj_file.fgj01,    #工作年
                    fgj02       LIKE fgj_file.fgj02,    #工作月
                    fgj03       LIKE fgj_file.fgj03,    #財產編號
                    fgj04       LIKE fgj_file.fgj04,    #附號
                    faj06       LIKE faj_file.faj06,    #
                    faj106      LIKE faj_file.faj106,   #預計總工作量
                    faj107      LIKE faj_file.faj107,   #已使用工作量
                    fgk05       LIKE fgk_file.fgk05,    #部門編號
                    gem02       LIKE gem_file.gem02,    #部門名稱
                    fgk06       LIKE fgk_file.fgk06,    #本月工作量
                    fgj05       LIKE fgj_file.fgj05     #本月工作量
                    END RECORD,
    l_name          LIKE type_file.chr20    #NO.FUN-690009  VARCHAR(20)   #External(Disk) file name
 
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
#    CALL cl_outnam('gfat100') RETURNING l_name                  #No.FUN-850011
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog      #No.FUN-850011
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT fgj01,fgj02,fgj03,fgj04,faj06,faj106,",
              "       faj107,fgk05,gem02,fgk06,fgj05 ",
              "   FROM fgj_file,fgk_file LEFT OUTER JOIN faj_file ON fgk03 = faj02 AND fgk04 = faj022 ,gem_file",  #TQC-9B0016 mod
              " WHERE fgj01=fgk01 AND fgj02=fgk02 ",
              "   AND fgj03=fgk03 AND fgj04=fgk04 ",
              "   AND gem01 = fgk05 ",
              #"   AND fgk03=faj02(+) AND fgk04=faj022(+) ",   #No.TQC-9B0016 mod
              "   AND ",g_wc CLIPPED," AND ", g_wc2 CLIPPED ,
              " ORDER BY fgj01,fgj02,fgj03"
#No.FUN-850011--begin--
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(g_wc,'fgj01,fgj02,fgj03,fgj04,fgj06,fgj05,fgjconf,fgjuser,fgjgrup,fgjmodu,fgjdate')                                                                              
        RETURNING g_wc                                                                                                              
        LET g_str = g_wc                                                                                                            
     END IF                                                                                                                         
   LET g_str =g_str                                                                                                                 
   CALL cl_prt_cs1('gfat100','gfat100',g_sql,g_str) 
#    PREPARE t100_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE t100_co                         # CURSOR
#       CURSOR FOR t100_p1
 
#   START REPORT t100_rep TO l_name
 
#   FOREACH t100_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT t100_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT t100_rep
 
#   CLOSE t100_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-850011--end--
END FUNCTION
 
#No.FUN-850011--begin--
#REPORT t100_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,    #NO.FUN-690009   VARCHAR(1)
#   l_str           STRING,
#   g_head1         STRING,
#   sr              RECORD
#                   fgj01       LIKE fgj_file.fgj01,    #工作年
#                   fgj02       LIKE fgj_file.fgj02,    #工作月
#                   fgj03       LIKE fgj_file.fgj03,    #財產編號
#                   fgj04       LIKE fgj_file.fgj04,    #附號
#                   faj06       LIKE faj_file.faj06,    #
#                   faj106      LIKE faj_file.faj106,   #預計總工作量
#                   faj107      LIKE faj_file.faj107,   #已使用工作量
#                   fgk05       LIKE fgk_file.fgk05,    #部門編號
#                   gem02       LIKE gem_file.gem02,    #部門名稱
#                   fgk06       LIKE fgk_file.fgk06,    #本月工作量
#                   fgj05       LIKE fgj_file.fgj05     #本月工作量
#                   END RECORD
#  OUTPUT
#      TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#   ORDER BY sr.fgj01,sr.fgj02,sr.fgj03,sr.fgj04
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED, pageno_total
#           LET g_head1 = g_x[10] CLIPPED,sr.fgj01 USING '###&','  ',
#                         g_x[11] CLIPPED,sr.fgj02 USING '#&'
#           PRINT g_head1
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       BEFORE GROUP OF sr.fgj02
#           SKIP TO TOP OF PAGE
 
#       BEFORE GROUP OF sr.fgj03
#           LET l_str = sr.fgj03 CLIPPED,'/',sr.fgj04 CLIPPED
#           PRINT COLUMN g_c[31],l_str,
#                 COLUMN g_c[32],sr.faj06 CLIPPED;
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[33],cl_numfor(sr.faj106,33,2),
#                 COLUMN g_c[34],cl_numfor(sr.faj107,33,2),
#                 COLUMN g_c[35],sr.fgk05,
#                 COLUMN g_c[36],sr.gem02,
#                 COLUMN g_c[37],cl_numfor(sr.fgk06,33,2)
 
#       AFTER GROUP OF sr.fgj03
#           PRINT COLUMN g_c[37],g_dash2[1,g_w[37]]
#           PRINT COLUMN g_c[35],g_x[9] CLIPPED,
#                 COLUMN g_c[37],cl_numfor(sr.fgj05,37,2)
#           PRINT
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
#
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-850011--end--
#CHI-C80041---begin
FUNCTION t100_v()
DEFINE l_chr LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_fgj.fgj01) OR cl_null(g_fgj.fgj02) OR cl_null(g_fgj.fgj03) THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t100_cl USING g_fgj.fgj01,g_fgj.fgj02,g_fgj.fgj03,g_fgj.fgj04
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t100_cl INTO g_fgj.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fgj.fgj01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t100_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_fgj.fgjconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_fgj.fgjconf)   THEN 
        LET l_chr=g_fgj.fgjconf
        IF g_fgj.fgjconf='N' THEN 
            LET g_fgj.fgjconf='X' 
        ELSE
            LET g_fgj.fgjconf='N'
        END IF
        UPDATE fgj_file
            SET fgjconf=g_fgj.fgjconf,  
                fgjmodu=g_user,
                fgjdate=g_today
            WHERE fgj01=g_fgj.fgj01
              AND fgj02=g_fgj.fgj02
              AND fgj03=g_fgj.fgj03
              AND fgj04=g_fgj.fgj04
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","fgj_file",g_fgj.fgj01,"",SQLCA.sqlcode,"","",1)  
            LET g_fgj.fgjconf=l_chr 
        END IF
        DISPLAY BY NAME g_fgj.fgjconf
   END IF
 
   CLOSE t100_cl
   COMMIT WORK
   CALL cl_flow_notify(g_fgj.fgj01,'V')
 
END FUNCTION
#CHI-C80041---end

