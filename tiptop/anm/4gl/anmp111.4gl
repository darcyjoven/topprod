# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: anmp111.4gl
# Descriptions...: 應付票據銀行兌現作業
# Date & Author..: 95/10/10 By Roger
# Modify.........: 99/07/22 BY Carol:p111_b():after field nme17
#                                    select nme_file後資料不重新into給array變數
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6C0174 06/12/27 By Rayven 錄入時，字段“原到期日”，“付款銀行”，“廠商”，“票面金額”沒有顯示相應的值
# Modify.........: No.FUN-750141 07/05/31 By kim 查出未兌現資料後(nme02=NULL) 應只可修改 銀行兌現日,不可刪除,新增,票號不可改!
# Modify.........: No.MOD-960067 09/06/09 By baofei 4fd上沒有cn3欄位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.MOD-B80073 11/08/09 By Polly 以nmd01串nme12的SQL，多串npl_file與npm_file，取得npl01後再以此值串nme12
# Modify.........: No.MOD-C30799 12/03/20 By Polly 去除重覆性的資料
# Modify.........: No.MOD-C40165 12/04/20 By Elise PREPARE p111_pb應加入兌現票據的項次，nme21=npm02
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_nme          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        nme17       LIKE nme_file.nme17,       #
        nme02       LIKE nme_file.nme02,       #
        nmd05       LIKE nmd_file.nmd05,       #
        nme01       LIKE nme_file.nme01,       #
        nme13       LIKE nme_file.nme13,       #
        nme04       LIKE nme_file.nme04        #
                    END RECORD,
    g_nme_t         RECORD                     #程式變數 (舊值)
        nme17       LIKE nme_file.nme17,       #
        nme02       LIKE nme_file.nme02,       #
        nmd05       LIKE nmd_file.nmd05,       #
        nme01       LIKE nme_file.nme01,       #
        nme13       LIKE nme_file.nme13,       #
        nme04       LIKE nme_file.nme04        #
                    END RECORD,
    g_wc,g_sql      STRING,                    #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,       #單身筆數 #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT #No.FUN-680107 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5        #No.FUN-680107 SMALLINT
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680107 INTEGER
 
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
 
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
   CALL g_nme.clear()
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p111_w AT p_row,p_col WITH FORM "anm/42f/anmp111"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
#FUN-680107 --start
#  CREATE TEMP TABLE bbb_temp (bbb01 VARCHAR(100))
   CREATE TEMP TABLE bbb_temp(
         bbb01 LIKE type_file.chr1000)
#FUN-680107 --end
   CALL p111_menu()
 
   CLOSE WINDOW p111_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
FUNCTION p111_menu()
 
   WHILE TRUE
      CALL p111_bp("G")
 
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p111_q()
            END IF
 
         WHEN "input_cashing_detail"
            IF cl_chk_act_auth() THEN
               CALL p111_b()
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
END FUNCTION
 
 
FUNCTION p111_q()
   CALL p111_b_askkey()
END FUNCTION
 
FUNCTION p111_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680107 SMALLINT
    l_allow_insert  LIKE type_file.num5,      #可新增否          #No.FUN-680107 SMALLINT
    l_allow_delete  LIKE type_file.num5       #可刪除否          #No.FUN-680107 SMALLINT
 
    IF s_anmshut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET l_allow_insert = FALSE #FUN-750141
    LET l_allow_delete = FALSE #FUN-750141
 
    LET l_ac_t = 0
 
    INPUT ARRAY g_nme WITHOUT DEFAULTS FROM s_nme.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
        BEFORE INPUT
         IF g_rec_b!=0 THEN
           CALL fgl_set_arr_curr(l_ac)
         END IF
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
#            DISPLAY l_ac TO FORMONLY.cn3     #MOD-960067
            LET l_n  = ARR_COUNT()
           #NEXT FIELD nme17 #FUN-750141
            NEXT FIELD nme02 #FUN-750141
 
        BEFORE INSERT
            LET l_ac = ARR_CURR()
#            DISPLAY l_ac TO FORMONLY.cn3     #MOD-960067
            LET l_n = ARR_COUNT()
            CALL cl_show_fld_cont()     #FUN-550037(smin)
           #NEXT FIELD nme17 #FUN-750141
            NEXT FIELD nme02 #FUN-750141
 
        AFTER FIELD nme02
            IF NOT cl_null(g_nme[l_ac].nme02) THEN
            #FUN-B50090 add begin-------------------------
            #重新抓取關帳日期
               LET g_sql ="SELECT nmz10 FROM nmz_file ",
                          " WHERE nmz00 = '0'"
               PREPARE nmz10_p FROM g_sql
               EXECUTE nmz10_p INTO g_nmz.nmz10
            #FUN-B50090 add -end--------------------------
               IF g_nme[l_ac].nme02 <= g_nmz.nmz10 THEN  #no.5261
                  CALL cl_err('','aap-176',1) NEXT FIELD nme02
               END IF
            END IF
 
        AFTER FIELD nme17
            IF NOT cl_null(g_nme[l_ac].nme17) THEN
#NO.0419.................................................................
               SELECT COUNT(*) INTO l_n
                #FROM nme_file,nmd_file                            #No.MOD-B80073 mark
                 FROM nme_file,nmd_file,npl_file,npm_file          #No.MOD-B80073 add
                WHERE nme17 = g_nme[l_ac].nme17
                 #AND nmd01 = nme12  AND nmd30='Y'        #No.MOD-B80073 mark
                  AND nme12 = npl01 AND npl01 = npm01     #No.MOD-B80073 add
                  AND npm03 = nmd01 AND nmd30='Y'         #No.MOD-B80073 add
                  AND nplconf = 'Y'                       #No.MOD-B80073 add
               IF l_n = 0  THEN
                  CALL cl_err('sel nme',STATUS,0)
                  #No.TQC-6C0174 --start--                                                                                          
                  LET g_nme[l_ac].nmd05 = NULL                                                                                      
                  LET g_nme[l_ac].nme01 = NULL                                                                                      
                  LET g_nme[l_ac].nme13 = NULL                                                                                      
                  LET g_nme[l_ac].nme04 = NULL                                                                                      
                  #No.TQC-6C0174 --end--
                  NEXT FIELD nme17
               #No.TQC-6C0174 --start--                                                                                             
               ELSE                                                                                                                 
                  SELECT nmd05,nme01,nme13,nme04                                                                                    
                    INTO g_nme[l_ac].nmd05,g_nme[l_ac].nme01,g_nme[l_ac].nme13,g_nme[l_ac].nme04
                   #FROM nme_file,nmd_file                   #No.MOD-B80073 mark
                    FROM nme_file,nmd_file,npl_file,npm_file #No.MOD-B80073 add
                   WHERE nme17 = g_nme[l_ac].nme17                                                                                  
                    #AND nmd01 = nme12 AND nmd30='Y'         #No.MOD-B80073 mark
                     AND nme12 = npl01 AND npl01 = npm01     #No.MOD-B80073 add
                     AND npm03 = nmd01 AND nmd30='Y'         #No.MOD-B80073 add
                     AND nplconf = 'Y'                       #No.MOD-B80073 add
               #No.TQC-6C0174 --end--
               END IF
#.......................................................................
            END IF
            #No.TQC-6C0174 --start--                                                                                                
            IF cl_null(g_nme[l_ac].nme17) THEN                                                                                      
               LET g_nme[l_ac].nmd05 = NULL                                                                                         
               LET g_nme[l_ac].nme01 = NULL                                                                                         
               LET g_nme[l_ac].nme13 = NULL                                                                                         
               LET g_nme[l_ac].nme04 = NULL                                                                                         
            END IF                                                                                                                  
            #No.TQC-6C0174 --end--
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF l_ac > 1 THEN
                LET g_nme[l_ac].nme02 = g_nme[l_ac-1].nme02
            END IF
 
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
 
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
    END INPUT
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    IF cl_sure(0,0) THEN
       FOR l_ac = 1 TO g_nme.getLength()
           IF cl_null(g_nme[l_ac].nme17) THEN
              CONTINUE FOR
           END IF
           MESSAGE "upd:",g_nme[l_ac].nme17,' ',g_nme[l_ac].nme02
           CALL ui.Interface.refresh()
           UPDATE nme_file SET nme02=g_nme[l_ac].nme02
            WHERE nme17=g_nme[l_ac].nme17
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#             CALL cl_err('upd nme',STATUS,1)   #No.FUN-660148
              CALL cl_err3("upd","nme_file",g_nme[l_ac].nme17,"",STATUS,"","upd nme",1) #No.FUN-660148
           END IF
       END FOR
    END IF
END FUNCTION
 
FUNCTION p111_b_askkey()
    CLEAR FORM
   CALL g_nme.clear()
    CALL cl_opmsg('q')
    CONSTRUCT g_wc ON nme17,nmd05,nme01,nme13,nme04
            FROM s_nme[1].nme17,s_nme[1].nmd05,s_nme[1].nme01,
                 s_nme[1].nme13,s_nme[1].nme04
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmeuser', 'nmegrup') #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL p111_b_fill(g_wc)
END FUNCTION
 
FUNCTION p111_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2   LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(200)
 
    LET g_sql =
       #"SELECT nme17,nme02,nmd05,nme01,nme13,nme04",            #MOD-C30799 mark
        "SELECT DISTINCT nme17,nme02,nmd05,nme01,nme13,nme04",   #MOD-C30799 add
       #" FROM nme_file,nmd_file ",                           #No.MOD-B80073 mark
        " FROM nme_file,nmd_file,npl_file,npm_file ",         #No.MOD-B80073 add
        " WHERE nme02 IS NULL AND ", p_wc2 CLIPPED,           #單身
       #"   AND nmd01 = nme12 AND nmd30='Y'",                 #No.MOD-B80073 mark
        "   AND nme12 = npl01 AND npl01 = npm01",             #No.MOD-B80073 add
        "   AND npm03 = nmd01 AND nmd30='Y'",                 #No.MOD-B80073 add
        "   AND nplconf = 'Y'",                               #No.MOD-B80073 add
        "   AND nmd12 = '8'",
        "   AND nme21 = npm02",                          #MOD-C40165 add
        " ORDER BY 1"
    PREPARE p111_pb FROM g_sql
    DECLARE nme_curs CURSOR FOR p111_pb
 
    FOR g_cnt = 1 TO g_nme.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_nme[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    MESSAGE "Searching!"
    CALL ui.Interface.refresh()
    FOREACH nme_curs INTO g_nme[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
 
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
 	 EXIT FOREACH
       END IF
 
    END FOREACH
    CALL g_nme.deleteElement(g_cnt)
 
    MESSAGE ""
    CALL ui.Interface.refresh()
    LET g_rec_b = g_cnt-1
 
END FUNCTION
 
FUNCTION p111_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
#   IF p_ud <> "G" OR g_action_choice = "detail" THEN   #No.TQC-6C0174 mark
    IF p_ud <> "G" THEN  #No.TQC-6C0174
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
 
    DISPLAY ARRAY g_nme TO s_nme.* ATTRIBUTE(COUNT=g_rec_b)
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION input_cashing_detail
           LET g_action_choice="input_cashing_detail"
           EXIT DISPLAY
 
        ON ACTION query
           LET g_action_choice="query"
           EXIT DISPLAY
 
        ON ACTION help
           LET g_action_choice="help"
           EXIT DISPLAY
 
#No.TQC-6C0174 --start--
#       ON ACTION accept
#          LET g_action_choice="detail"
#          LET l_ac = ARR_CURR()
#          EXIT DISPLAY
#No.TQC-6C0174 --end--
 
        ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice="exit"
           EXIT DISPLAY
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           EXIT DISPLAY
 
        ON ACTION controlg
           LET g_action_choice="controlg"
           EXIT DISPLAY
 
        ON ACTION exit
           LET g_action_choice="exit"
           EXIT DISPLAY
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
    END DISPLAY
 
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#Patch....NO.TQC-610036 <001> #
