# Prog. Version..: '5.25.04-11.09.15(00010)'     #
#
# Pattern name...: ghri0531.4gl
# Descriptions...: 材料單價維護作業
# Date & Author..: 13/06/03 by mengyye
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_hrcma_hd        RECORD                       #單頭變數
        hrcma01       LIKE hrcma_file.hrcma01,  
        hrcma04       LIKE hrcma_file.hrcma04,  
        hrcma08       LIKE hrcma_file.hrcma08,  
        hrcma10       LIKE hrcma_file.hrcma10,  
        hrcma05       LIKE hrcma_file.hrcma05,  
        hrcma06       LIKE hrcma_file.hrcma06,  
        hrcma07       LIKE hrcma_file.hrcma07,  
        hrcma09       LIKE hrcma_file.hrcma09,  
        hrcma11       LIKE hrcma_file.hrcma11,  
        hrcma12       LIKE hrcma_file.hrcma12,  
        hrcma14       LIKE hrcma_file.hrcma14,
        hrcma15       LIKE hrcma_file.hrcma15,
        hrcma13       LIKE hrcma_file.hrcma13
        END RECORD,
    g_hrcma_hd_t      RECORD                       #單頭變數
        hrcma01       LIKE hrcma_file.hrcma01,  
        hrcma04       LIKE hrcma_file.hrcma04,  
        hrcma08       LIKE hrcma_file.hrcma08,  
        hrcma10       LIKE hrcma_file.hrcma10,  
        hrcma05       LIKE hrcma_file.hrcma05,  
        hrcma06       LIKE hrcma_file.hrcma06,  
        hrcma07       LIKE hrcma_file.hrcma07,  
        hrcma09       LIKE hrcma_file.hrcma09,  
        hrcma11       LIKE hrcma_file.hrcma11,  
        hrcma12       LIKE hrcma_file.hrcma12,  
        hrcma14       LIKE hrcma_file.hrcma14,
        hrcma15       LIKE hrcma_file.hrcma15,
        hrcma13       LIKE hrcma_file.hrcma13 
        END RECORD,
    g_hrcma_hd_o      RECORD                       #單頭變數
        hrcma01       LIKE hrcma_file.hrcma01,  
        hrcma04       LIKE hrcma_file.hrcma04,  
        hrcma08       LIKE hrcma_file.hrcma08,  
        hrcma10       LIKE hrcma_file.hrcma10,  
        hrcma05       LIKE hrcma_file.hrcma05,  
        hrcma06       LIKE hrcma_file.hrcma06,  
        hrcma07       LIKE hrcma_file.hrcma07,  
        hrcma09       LIKE hrcma_file.hrcma09,  
        hrcma11       LIKE hrcma_file.hrcma11,  
        hrcma12       LIKE hrcma_file.hrcma12,  
        hrcma14       LIKE hrcma_file.hrcma14,
        hrcma15       LIKE hrcma_file.hrcma15,
        hrcma13       LIKE hrcma_file.hrcma13
        END RECORD,
    g_hrcma           DYNAMIC ARRAY OF RECORD      #程式變數(單身)
        hrcma01       LIKE hrcma_file.hrcma01, 
        hrcma03       LIKE hrcma_file.hrcma03,      
        hrat02       LIKE hrat_file.hrat02,       
        hrat04       LIKE type_file.chr50,       
        hrat05       LIKE type_file.chr50,
        hrat25       LIKE hrat_file.hrat25,       
        hrat19       LIKE type_file.chr50       
        END RECORD,
    g_hrcma_t         RECORD                       #程式變數(舊值)
        hrcma01       LIKE hrcma_file.hrcma01, 
        hrcma03       LIKE hrcma_file.hrcma03,      
        hrat02       LIKE hrat_file.hrat02,       
        hrat04       LIKE type_file.chr50,       
        hrat05       LIKE type_file.chr50,
        hrat25       LIKE hrat_file.hrat25,       
        hrat19       LIKE type_file.chr50      
        END RECORD,
    g_wc            string,                          #WHERE CONDITION  #No.FUN-580092 HCN
    g_sql           string,                          #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,             #單身筆數   #No.FUN-680061 SMALLINT
    l_ac            LIKE type_file.num5              #目前處理的ARRAY CNT #No.FUN-680061 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5     #No.FUN-680061 SMALLINT
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_sql_tmp    STRING   #No.TQC-720019
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   g_chr          LIKE type_file.chr1          #No.FUN-680061 VARCHAR(01)
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose  #No.FUN-680061 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03            #No.FUN-680061 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680061 SMALLINT  #No.FUN-6A0057 g_no_ask 
DEFINE   l_table        STRING                       #No.FUN-770033
DEFINE   g_str          STRING                       #No.FUN-770033
DEFINE   g_success      LIKE type_file.chr1                       #No.FUN-77003
DEFINE g_hrcm02 LIKE hrcm_file.hrcm02

FUNCTION i0531_main(p_hrcm02)
   
   DEFINE p_hrcm02 LIKE hrcm_file.hrcm02
 
   WHENEVER ERROR CALL cl_err_msg_log     #遇錯則記錄log檔
   INITIALIZE g_hrcma_hd.* to NULL
   INITIALIZE g_hrcma_hd_t.* to NULL
   INITIALIZE g_hrcma_hd_o.* to NULL
   LET g_hrcm02 = p_hrcm02

   CALL i0531_tmp()
   OPEN WINDOW i0531_w AT 4,2
       WITH FORM "ghr/42f/ghri053_1" ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_locale("ghri053_1")
   CALL i0531_a() 
   CALL i0531_ins_hrcma()
   CLOSE WINDOW i0531_w                          #結束畫面
   DROP TABLE i0531_temp
   DROP TABLE i0531_t
END FUNCTION

FUNCTION i0531_a()
    IF s_shut(0) THEN  RETURN END IF
 
    MESSAGE ""
    CLEAR FORM
    CALL g_hrcma.clear()     #MOD-530524
    CALL cl_opmsg('a')
    WHILE TRUE
       LET g_hrcma_hd.hrcma04 =  g_today          
       LET g_hrcma_hd.hrcma05 =  '00:00'         
       LET g_hrcma_hd.hrcma06 =  g_today    
       LET g_hrcma_hd.hrcma07 =  '00:00'       
       LET g_hrcma_hd.hrcma11 = 'N'  
       LET g_hrcma_hd.hrcma12 = 'N'
       LET g_hrcma_hd.hrcma14 = 'N'
       LET g_hrcma_hd.hrcma15 = 'Y'  
       CALL i0531_i("a")                         #輸入單頭
       IF INT_FLAG THEN                         #使用者不玩了
          LET INT_FLAG = 0
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF
          
       IF cl_null(g_hrcm02)  THEN
          CONTINUE WHILE
       END IF
       CALL g_hrcma.clear()
       LET g_rec_b=0
       CALL i0531_b()                               #輸入單身
       LET g_hrcma_hd_t.* = g_hrcma_hd.*            #保留舊值
       LET g_hrcma_hd_o.* = g_hrcma_hd.*            #保留舊值
       LET g_wc=" hrcma02='",g_hrcm02,"' "
       EXIT WHILE
    END WHILE
END FUNCTION

#處理單身欄位輸入
FUNCTION i0531_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680061 SMALLINT 
    l_n             LIKE type_file.num5,    #檢查重複用 #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否 #No.FUN-680061 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態   #No.FUN-680061 VARCHAR(1)
    l_hratid        LIKE hrat_file.hratid,
    l_hratid_hrcm05  LIKE hrat_file.hratid,
    l_hrcm06         LIKE hrcm_file.hrcm06,    #儲存未經計算的hrcm06值
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680061 SMALLINT
    l_allow_delete  LIKE type_file.num5,     #可刪除否  #No.FUN-680061 SMALLINT
    l_hrcma01_t  LIKE hrcma_file.hrcma01,
    l_count         LIKE type_file.num5 
    LET g_action_choice = ""
    IF g_hrcm02 IS NULL THEN RETURN END IF
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT hrcma01,hrcma03,'','','','','' FROM hrcma_file ",
        "  WHERE hrcma02 = ? AND hrcma03 = ?  FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i0531_bcl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_hrcma WITHOUT DEFAULTS FROM s_hrcma.*
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
            LET l_lock_sw = 'N'                  #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_hrcma_t.* = g_hrcma[l_ac].*    #BACKUP
                SELECT hratid INTO g_hrcma[l_ac].hrcma03 FROM hrat_file WHERE hrat01 =g_hrcma[l_ac].hrcma03
                OPEN i0531_bcl USING g_hrcm02,g_hrcma[l_ac].hrcma03
                IF STATUS THEN
                   CALL cl_err("OPEN i0531_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i0531_bcl INTO g_hrcma[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_hrcma_t.hrcma03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL i0531_hrat_fill(g_hrcma[l_ac].hrcma03)
                   RETURNING  g_hrcma[l_ac].hrat02,
                             g_hrcma[l_ac].hrat04,g_hrcma[l_ac].hrat05, 
                             g_hrcma[l_ac].hrat25,g_hrcma[l_ac].hrat19
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_hrcma[l_ac].* TO NULL
            LET g_hrcma_t.* = g_hrcma[l_ac].*        #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF

            SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcma[l_ac].hrcma03
            CALL i0531_auto_hrcma01() RETURNING g_hrcma[l_ac].hrcma01
             INSERT INTO i0531_temp(hrcma01,hrcma02,hrcma03, hrcma04,                                       
                                   hrcma05, hrcma06, hrcma07,                   
                                   hrcma08, hrcma09, hrcma10,                   
                                   hrcma11, hrcma12, hrcma13,hrcma14,hrcma15)
                  VALUES(g_hrcma[l_ac].hrcma01,g_hrcm02,g_hrcma[l_ac].hrcma03, g_hrcma_hd.hrcma04,                                                                                     
                         g_hrcma_hd.hrcma05, g_hrcma_hd.hrcma06, g_hrcma_hd.hrcma07,                   
                         g_hrcma_hd.hrcma08, g_hrcma_hd.hrcma09, g_hrcma_hd.hrcma10,                   
                         g_hrcma_hd.hrcma11, g_hrcma_hd.hrcma12, g_hrcma_hd.hrcma13,'Y',g_hrcma_hd.hrcma15)

            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","hrcm_file",l_hrcma01_t,g_hrcma_t.hrcma03,SQLCA.sqlcode,"","",1) #FUN-660105
                CANCEL INSERT
            END IF
 
        AFTER FIELD hrcma03
            IF NOT cl_null(g_hrcma[l_ac].hrcma03) THEN
               IF  cl_null(g_hrcma[l_ac].hrcma03) THEN
	                 NEXT FIELD hrcma03
               END IF
               SELECT COUNT(*) INTO l_count FROM hrat_file
                WHERE hratconf ='Y' AND hrat01 = g_hrcma[l_ac].hrcma03
               IF cl_null(l_count) THEN LET l_count = 0  END IF
               IF l_count <=0 THEN
                  CALL cl_err('','mfg1312',1)
                  NEXT FIELD hrcma03
               END IF
               IF g_hrcma[l_ac].hrcma03 != g_hrcma_t.hrcma03 THEN
                  SELECT COUNT(*) INTO l_count FROM i0531_temp
                   WHERE hrcma03 = g_hrcma[l_ac].hrcma03 
                  IF cl_null(l_count) THEN LET l_count = 0  END IF
                  IF l_count >0 THEN
                     CALL cl_err('','ghr-048',1)
                     NEXT FIELD hrcma03
                  END IF
               END IF
               SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcma[l_ac].hrcma03
               CALL i0531_hrat_fill(l_hratid) 
                   RETURNING  g_hrcma[l_ac].hrat02,
                             g_hrcma[l_ac].hrat04,g_hrcma[l_ac].hrat05, 
                             g_hrcma[l_ac].hrat25,g_hrcma[l_ac].hrat19
               DISPLAY BY NAME g_hrcma[l_ac].hrat02,
                             g_hrcma[l_ac].hrat04,g_hrcma[l_ac].hrat05, 
                             g_hrcma[l_ac].hrat25,g_hrcma[l_ac].hrat19
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_hrcma_t.hrcma03) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM i0531_temp             #刪除該筆單身資料
                 WHERE hrcma02 = g_hrcm02
                   AND hrcma03 = g_hrcma_t.hrcma03
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","i0531_temp",g_hrcm02,g_hrcma_t.hrcma03,SQLCA.sqlcode,"","",1) #FUN-660105
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_hrcma[l_ac].* = g_hrcma_t.*
               CLOSE i0531_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_hrcma[l_ac].hrcma03,-263,1)
               LET g_hrcma[l_ac].* = g_hrcma_t.*
            ELSE
               UPDATE i0531_temp
                  SET hrcma03 = g_hrcma[l_ac].hrcma03
                WHERE hrcma01 = g_hrcma[l_ac].hrcma01
                  AND hrcma02 = g_hrcm02
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","i0531_temp",g_hrcma[l_ac].hrcma03,'',SQLCA.sqlcode,"","",1) #FUN-660105
                   LET g_hrcma[l_ac].* = g_hrcma_t.*
                   ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                  
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_hrcma[l_ac].* = g_hrcma_t.*
               END IF
               CLOSE i0531_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i0531_bcl
            COMMIT WORK
        ON ACTION CONTROLP  
         CASE     
           WHEN INFIELD(hrcma03)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_hrat01"
              LET g_qryparam.default1 = g_hrcma[l_ac].hrcma03
              CALL cl_create_qry() RETURNING g_hrcma[l_ac].hrcma03
              DISPLAY BY NAME g_hrcma[l_ac].hrcma03
              NEXT FIELD hrcma03 
         END CASE
 
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
 
    CLOSE i0531_bcl
    COMMIT WORK
END FUNCTION

#處理單頭欄位(hrcm01, hrcma03, hrcm04, hrcm05)INPUT
FUNCTION i0531_i(p_cmd)
DEFINE
    p_cmd   LIKE type_file.chr1,    #a:輸入 u:更改  #No.FUN-680061 VARCHAR(1)
    l_n     LIKE type_file.num5,     #No.FUN-680061 SMALLINT
    l_count LIKE type_file.num5 
 DEFINE l_hrcma09_desc LIKE type_file.chr20 
DEFINE  g_h,g_m   LIKE  type_file.num5,
      g_x      STRING
DEFINE  l_hrcma04_05   LIKE type_file.chr50
DEFINE  l_hrcma06_07   LIKE type_file.chr50
DEFINE  l_hrcma08      LIKE hrcp_file.hrcp11
DEFINE l_string   STRING
DEFINE  g_h_05,g_m_05   LIKE  type_file.num5

    LET l_n = 0
 
     DISPLAY g_hrcma_hd.hrcma04,
             g_hrcma_hd.hrcma05, g_hrcma_hd.hrcma06, g_hrcma_hd.hrcma07,  
             g_hrcma_hd.hrcma08, g_hrcma_hd.hrcma09, g_hrcma_hd.hrcma10,
             g_hrcma_hd.hrcma11, g_hrcma_hd.hrcma12, g_hrcma_hd.hrcma13, g_hrcma_hd.hrcma15   
          TO hrcma04,
             hrcma05, hrcma06, hrcma07,  
             hrcma08, hrcma09, hrcma10,
             hrcma11, hrcma12, hrcma13, hrcma15  	
    CALL cl_set_head_visible("","YES")   
    INPUT BY NAME g_hrcma_hd.hrcma04,
             g_hrcma_hd.hrcma05, g_hrcma_hd.hrcma06, g_hrcma_hd.hrcma07,  
             g_hrcma_hd.hrcma08, g_hrcma_hd.hrcma09, g_hrcma_hd.hrcma10,
             g_hrcma_hd.hrcma11, g_hrcma_hd.hrcma12, g_hrcma_hd.hrcma13, g_hrcma_hd.hrcma15   
     WITHOUT DEFAULTS
        AFTER FIELD hrcma05
            IF NOT cl_null(g_hrcma_hd.hrcma05) THEN
               LET g_h=''
               LET g_m=''
               LET g_h=g_hrcma_hd.hrcma05[1,2]
               LET g_m=g_hrcma_hd.hrcma05[4,5]
               LET g_x = g_hrcma_hd.hrcma05
               IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
                  CALL cl_err('时间录入错误','!',0)
                  NEXT FIELD hrcma05
               END IF
               IF g_hrcma_hd.hrcma05[1] =' ' OR g_hrcma_hd.hrcma05[2] =' ' OR 
                  g_hrcma_hd.hrcma05[4] =' ' OR g_hrcma_hd.hrcma05[5] =' ' OR g_x.getLength()<>5 THEN
                   CALL cl_err('时间录入错误','!',0)
                  NEXT FIELD hrcma05
               END IF
            END IF
        AFTER FIELD hrcma07
            IF NOT cl_null(g_hrcma_hd.hrcma07) THEN
               LET g_h=''
               LET g_m=''
               LET g_h=g_hrcma_hd.hrcma07[1,2]
               LET g_m=g_hrcma_hd.hrcma07[4,5]
               LET g_x = g_hrcma_hd.hrcma07
               IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
                  CALL cl_err('时间录入错误','!',0)
                  NEXT FIELD hrcma07
               END IF
               IF g_hrcma_hd.hrcma07[1] =' ' OR g_hrcma_hd.hrcma07[2] =' ' OR       
                  g_hrcma_hd.hrcma07[4] =' ' OR g_hrcma_hd.hrcma07[5] =' ' OR g_x.getLength() <> 5 THEN 
                  CALL cl_err('时间录入错误','!',0)
                  NEXT FIELD hrcma07
               END IF
               IF g_hrcma_hd.hrcma06  = g_hrcma_hd.hrcma04 AND g_hrcma_hd.hrcma05 >= g_hrcma_hd.hrcma07 THEN 
               	  CALL cl_err('','ghr-120',0)
                  NEXT FIELD hrcma07
               END IF 
                 LET l_string = " SELECT TO_NUMBER(to_date('",g_hrcma_hd.hrcma07,"','HH24:MI') - ",
               	                " to_date('",g_hrcma_hd.hrcma05,"','HH24:MI')) * 24 FROM dual"
               	 PREPARE l_string_cs FROM l_string
               	 EXECUTE l_string_cs INTO l_hrcma08
               	 IF g_hrcma_hd.hrcma05 < g_hrcma_hd.hrcma07 THEN
               	     LET g_hrcma_hd.hrcma08 = l_hrcma08
               	     DISPLAY g_hrcma_hd.hrcma08 TO hrcma08
               	 ELSE
               	    LET g_hrcma_hd.hrcma08 = l_hrcma08+24
               	     DISPLAY g_hrcma_hd.hrcma08 TO hrcma08
               	 END IF	
            END IF 	 	
         AFTER FIELD hrcma04
           IF NOT cl_null(g_hrcma_hd.hrcma04) THEN
              IF g_hrcma_hd.hrcma04 > g_hrcma_hd.hrcma06  THEN
                 CALL cl_err('','ghr-120',0)
                 NEXT FIELD hrcma04
              END IF
           END IF
         AFTER FIELD hrcma06
           IF NOT cl_null(g_hrcma_hd.hrcma06) THEN 
              IF g_hrcma_hd.hrcma04 > g_hrcma_hd.hrcma06  THEN
                 CALL cl_err('','ghr-120',0)
                 NEXT FIELD hrcma06
              END IF
           END IF
           
#       #add by lijun130906-----begin------    
#        BEFORE FIELD hrcma08
#             IF NOT cl_null(g_hrcma_hd.hrcma04) AND NOT cl_null(g_hrcma_hd.hrcma05)
#                 AND NOT cl_null(g_hrcma_hd.hrcma06) AND NOT cl_null(g_hrcma_hd.hrcma07) THEN
#                 LET l_hrcma04_05 = g_hrcma_hd.hrcma04 CLIPPED,' ',g_hrcma_hd.hrcma05 CLIPPED
#                 LET l_hrcma06_07 = g_hrcma_hd.hrcma06 CLIPPED,' ',g_hrcma_hd.hrcma07 CLIPPED
#                 LET l_hrcma08 = ''   	
#               	 LET l_string = " SELECT TO_NUMBER(to_date('",l_hrcma06_07,"','YYYY/MM/DD HH24:MI') - ",
#               	                " to_date('",l_hrcma04_05,"','YYYY/MM/DD HH24:MI')) * 24 FROM dual"
#               	 PREPARE l_string_cs_1 FROM l_string
#               	 EXECUTE l_string_cs_1 INTO l_hrcma08
#               	 IF l_hrcma08 > 0 THEN
#               	     LET g_hrcma_hd.hrcma08 = l_hrcma08
#               	     DISPLAY g_hrcma_hd.hrcma08 TO hrcma08
#               	 ELSE
#               	     CALL cl_err('经计算加班时长小于等于0','!',1)
#               	     NEXT FIELD hrcma07
#               	 END IF
#              END IF
#        #add by lijun130906-----end------
              
        AFTER FIELD hrcma09
             IF NOT cl_null(g_hrcma_hd.hrcma09) THEN
               SELECT COUNT(*) INTO l_count FROM hrbm_file,hraa_file 
                WHERE hrbm07 ='Y' AND hrbm02  ='008' AND hraa01 = hrbm01  AND hrbm03 = g_hrcma_hd.hrcma09
               IF cl_null(l_count) THEN LET l_count = 0  END IF
               IF l_count <=0 THEN  
                  CALL cl_err('','mfg1306',1)            
                  NEXT FIELD hrcma09 
               END IF
               SELECT hrbm04,hrbm23 INTO l_hrcma09_desc,g_hrcma_hd.hrcma12 FROM hrbm_file,hraa_file
                WHERE hrbm07 ='Y' AND hrbm02  ='008' AND hraa01 = hrbm01 AND hrbm03 = g_hrcma_hd.hrcma09
                DISPLAY l_hrcma09_desc TO FORMONLY.hrcma09_desc
                DISPLAY g_hrcma_hd.hrcma12 TO hrcma12
             END IF
             
 
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(hrcma09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_hrbm03"
                 LET g_qryparam.arg1 = '008'
                 LET g_qryparam.default1 = g_hrcma_hd.hrcma09
                 CALL cl_create_qry() RETURNING g_hrcma_hd.hrcma09
                 DISPLAY BY NAME  g_hrcma_hd.hrcma09         
            END CASE
 
        ON ACTION CONTROLZ
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

FUNCTION i0531_hrat_fill(p_hrcma03)
  DEFINE p_hrcma03    LIKE hrcma_file.hrcma03
  DEFINE l_key       LIKE type_file.chr1
  DEFINE l_hrad03  LIKE type_file.chr50
  DEFINE l_hrat04_name  LIKE type_file.chr50 
  DEFINE l_hrat05_name  LIKE type_file.chr50
  DEFINE l_hrat RECORD LIKE hrat_file.* 
  
  SELECT hrat02,hrat03,hrat04,hrat05,hrat25,hrat19 
    INTO l_hrat.hrat02,l_hrat.hrat03,l_hrat.hrat04,l_hrat.hrat05,l_hrat.hrat25,l_hrat.hrat19
    FROM hrat_file
   WHERE hratid = p_hrcma03 AND hratconf ='Y'
   
  SELECT hrao02 INTO l_hrat04_name FROM hrao_file WHERE hrao01 = l_hrat.hrat04 AND hrao00 = l_hrat.hrat03 AND hraoacti = 'Y' 
  SELECT hrap02 INTO l_hrat05_name FROM hrap_file WHERE hrap01 = l_hrat.hrat04 AND hrap05 = l_hrat.hrat05 AND hrapacti = 'Y'
  SELECT hrat02 INTO l_hrat.hrat02 FROM hrat_file WHERE hratconf ='Y' AND hrat01 = p_hrcma03
  SELECT hrad03 INTO l_hrad03 FROM hrad_file WHERE hradacti= 'Y' AND hrad02 = l_hrat.hrat19
  RETURN l_hrat.hrat02,
         l_hrat04_name,l_hrat05_name,
         l_hrat.hrat25,l_hrad03 
    
END FUNCTION

FUNCTION i0531_tmp()
   DEFINE l_sql STRING
    
   DROP TABLE i0531_temp  
   CREATE TEMP TABLE i0531_temp
    (  
      hrcma01   VARCHAR(20),
      hrcma02   VARCHAR(20), 
      hrcma03   VARCHAR(20),
      hrcma04   DATE,
      hrcma05   VARCHAR(20),
      hrcma06   DATE,  
      hrcma07   VARCHAR(20),
      hrcma08   DECIMAL(20,10),
      hrcma09   VARCHAR(20),
      hrcma10   DECIMAL(20,10),
      hrcma11   VARCHAR(1),
      hrcma12   VARCHAR(1), 
      hrcma13   VARCHAR(255),
      hrcma14   VARCHAR(1),
      hrcma15   VARCHAR(1)
      )
   DROP TABLE i0531_t  
   CREATE TEMP TABLE i0531_t
    (  
      hrcma04   DATE,
      hrcma05   VARCHAR(20),
      hrcma06   DATE,  
      hrcma07   VARCHAR(20)
      )
       
END FUNCTION


FUNCTION i0531_auto_hrcma01()
   DEFINE l_yy                 SMALLINT
   DEFINE l_mm                 SMALLINT
   DEFINE l_dd,i                 SMALLINT
   DEFINE ls_date              STRING
   DEFINE l_max_no             LIKE hrcma_file.hrcma01 
   DEFINE ls_max_no            STRING
   DEFINE l_max_no_1            LIKE hrcma_file.hrcma01
   DEFINE l_max_no_2            LIKE hrcma_file.hrcma01
   DEFINE ls_format            STRING
   DEFINE ls_max_pre           STRING
   DEFINE li_max_num           LIKE type_file.num20
   DEFINE li_max_comp          LIKE type_file.num20
   DEFINE l_hrcma01             LIKE hrcma_file.hrcma01
   DEFINE l_sql             STRING
   
   LET ls_max_pre = '9999999999'
   LET li_max_num=0
   LET li_max_comp= 0
   LET l_yy   = YEAR(g_today)
   LET l_mm   = MONTH(g_today)
   LET l_dd   = DAY(g_today)
   LET ls_date = l_yy USING "&&&&",l_mm USING "&&",l_dd USING "&&" 
   LET ls_date = ls_date.substring(3,8)

   LET l_sql ="SELECT MAX(hrcma01) FROM hrcma_file ",
              " WHERE hrcma01 LIKE '",ls_date CLIPPED,"%'",
              "   AND hrcma02 =",g_hrcm02 CLIPPED
   PREPARE auto_no_pre FROM l_sql
   EXECUTE auto_no_pre INTO l_max_no_1
   
   LET l_sql ="SELECT MAX(hrcma01) FROM i0531_temp ",
              " WHERE hrcma01 LIKE '",ls_date CLIPPED,"%'",
              "   AND hrcma02 =",g_hrcm02 CLIPPED
   PREPARE auto_no_pre1 FROM l_sql
   EXECUTE auto_no_pre1 INTO l_max_no_2
    
   IF l_max_no_2 IS NOT NULL AND l_max_no_1 IS NOT NULL THEN
      LET l_max_no = l_max_no_2
   END IF
   IF l_max_no_2 IS NULL AND l_max_no_1 IS NOT NULL THEN
      LET l_max_no = l_max_no_1
   END IF
   IF l_max_no_2 IS NOT NULL AND l_max_no_1 IS NULL THEN
      LET l_max_no = l_max_no_2
   END IF  
   IF l_max_no_2 IS NULL AND l_max_no_1 IS NULL THEN
      LET l_max_no = NULL
   END IF
     
   IF l_max_no IS NULL THEN
      LET l_hrcma01 = ls_date CLIPPED,'000001'
   ELSE
      LET ls_max_no = l_max_no[7,12]
      LET li_max_num = ls_max_pre.subString(1,6)  #最大編號值
      FOR i=1 TO 6
          LET ls_format = ls_format,"&"
      END FOR
      LET li_max_comp = ls_max_no + 1
      IF li_max_comp > li_max_num THEN
         CALL cl_err("","sub-518",1)
      ELSE
         LET l_hrcma01 = ls_date CLIPPED,li_max_comp USING ls_format
      END IF
    END IF    
    RETURN l_hrcma01
END FUNCTION 


FUNCTION i0531_ins_hrcma()
   DEFINE l_hrcma04 LIKE hrcma_file.hrcma04,
          l_hrcma04_t LIKE hrcma_file.hrcma04,
          l_hrcma05 LIKE hrcma_file.hrcma05,
          l_hrcma06 LIKE hrcma_file.hrcma06, 
          l_hrcma07 LIKE hrcma_file.hrcma07,
          l_hrcma15 LIKE hrcma_file.hrcma15,
          l_hrcma01_t LIKE hrcma_file.hrcma01,
          l_sql     STRING
   DEFINE sr RECORD
              hrcma01    LIKE hrcma_file.hrcma01,
              hrcma02    LIKE hrcma_file.hrcma02,
              hrcma03    LIKE hrcma_file.hrcma03,
              hrcma04    LIKE hrcma_file.hrcma04,
              hrcma05    LIKE hrcma_file.hrcma05,
              hrcma06    LIKE hrcma_file.hrcma06,
              hrcma07    LIKE hrcma_file.hrcma07,
              hrcma08    LIKE hrcma_file.hrcma08,
              hrcma09    LIKE hrcma_file.hrcma09,
              hrcma10    LIKE hrcma_file.hrcma10,
              hrcma11    LIKE hrcma_file.hrcma11,
              hrcma12    LIKE hrcma_file.hrcma12,
              hrcma13    LIKE hrcma_file.hrcma13,
              hrcma14    LIKE hrcma_file.hrcma14,
              hrcma15    LIKE hrcma_file.hrcma15
          END RECORD
    DEFINE sr1 RECORD
              hrcma04    LIKE hrcma_file.hrcma04,
              hrcma05    LIKE hrcma_file.hrcma05,
              hrcma06    LIKE hrcma_file.hrcma06,
              hrcma07    LIKE hrcma_file.hrcma07
           END RECORD
      
   SELECT UNIQUE hrcma04,hrcma05,hrcma06,hrcma07,hrcma15 INTO l_hrcma04,l_hrcma05,l_hrcma06,l_hrcma07,l_hrcma15 FROM i0531_temp
   LET l_hrcma04_t = l_hrcma04 
   IF l_hrcma15 = 'Y' THEN
      WHILE TRUE
         LET l_hrcma04 = l_hrcma04 + 1
         IF l_hrcma04_t = l_hrcma06  THEN
            INSERT INTO i0531_t(hrcma04,hrcma05, hrcma06, hrcma07)
                       VALUES(l_hrcma04_t,l_hrcma05,l_hrcma06,l_hrcma07)	
            EXIT WHILE
         END IF
           
         IF l_hrcma04 >l_hrcma06 THEN 
            IF l_hrcma05 < l_hrcma07 THEN
               INSERT INTO i0531_t(hrcma04,hrcma05, hrcma06, hrcma07)
                       VALUES(l_hrcma04-1,l_hrcma05,l_hrcma06,l_hrcma07)	
            END IF   
            EXIT WHILE 
         END IF
      
         IF l_hrcma05 >= l_hrcma07 THEN 
          	 INSERT INTO i0531_t(hrcma04,hrcma05, hrcma06, hrcma07)
                    VALUES(l_hrcma04-1,l_hrcma05,l_hrcma04,l_hrcma07)
             CONTINUE WHILE
         ELSE 
             INSERT INTO i0531_t(hrcma04,hrcma05, hrcma06, hrcma07)
                    VALUES(l_hrcma04-1,l_hrcma05,l_hrcma04-1,l_hrcma07)	
             CONTINUE WHILE
         END IF
               
      END WHILE
   END IF
   IF l_hrcma15 = 'N' OR cl_null(l_hrcma15 ) THEN
      INSERT INTO i0531_t(hrcma04,hrcma05, hrcma06, hrcma07)
                    VALUES(l_hrcma04,l_hrcma05,l_hrcma06,l_hrcma07)	
   END IF
   LET l_sql = "SELECT * FROM i0531_t"
   PREPARE i0531_p1 FROM l_sql
   DECLARE i0531_cs1 CURSOR FOR i0531_p1 
   
   LET l_sql = "SELECT * FROM i0531_temp"
   PREPARE i0531_p2 FROM l_sql
   DECLARE i0531_cs2 CURSOR FOR i0531_p2
   
   FOREACH i0531_cs2 INTO sr.*
     FOREACH i0531_cs1 INTO sr1.*
          CALL i053_auto_hrcma01() RETURNING l_hrcma01_t
          INSERT INTO hrcma_file(hrcma01,hrcma02,hrcma03,hrcma04,hrcma05,hrcma06,
                                hrcma07,hrcma08,hrcma09,hrcma10,hrcma11,hrcma12,hrcma13,hrcma14,hrcma15,ta_hrcma01) 
           VALUES(l_hrcma01_t,sr.hrcma02,sr.hrcma03,sr1.hrcma04,sr1.hrcma05,sr1.hrcma06,
                                sr1.hrcma07,sr.hrcma08,sr.hrcma09,sr.hrcma10,sr.hrcma11,sr.hrcma12,sr.hrcma13,'Y',sr.hrcma15,'N')
     END FOREACH
   END FOREACH
   
END FUNCTION
##################
