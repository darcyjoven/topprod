# Prog. Version..: '5.25.04-11.09.15(00010)'     #
#
# Pattern name...: ghri0532.4gl
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
    g_hrck           DYNAMIC ARRAY OF RECORD      #程式變數(單身)
        hrckno       LIKE type_file.num10,
        hrck01       LIKE hrck_file.hrck01, 
        hrck02       LIKE hrck_file.hrck02          
        END RECORD,
    g_hrck_t         RECORD                       #程式變數(舊值)
        hrckno       LIKE type_file.num10,
        hrck01       LIKE hrck_file.hrck01, 
        hrck02       LIKE hrck_file.hrck02      
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

FUNCTION i0532_main(p_hrcm02)
   
   DEFINE p_hrcm02 LIKE hrcm_file.hrcm02
 
   WHENEVER ERROR CALL cl_err_msg_log     #遇錯則記錄log檔
   INITIALIZE g_hrcma_hd.* to NULL
   INITIALIZE g_hrcma_hd_t.* to NULL
   INITIALIZE g_hrcma_hd_o.* TO NULL
   LET g_hrcm02 = p_hrcm02

   CALL i0532_tmp()
   OPEN WINDOW i0532_w AT 4,2
       WITH FORM "ghr/42f/ghri053_2" ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_locale("ghri053_2")
   CALL i0532_a() 
   CALL i0532_ins_hrcma()
   CLOSE WINDOW i0532_w                          #結束畫面
   DROP TABLE i0532_temp
   DROP TABLE i0532_temp2
END FUNCTION

FUNCTION i0532_a()
    IF s_shut(0) THEN  RETURN END IF
 
    MESSAGE ""
    CLEAR FORM
    CALL g_hrck.clear()     #MOD-530524
    CALL cl_opmsg('a')
    WHILE TRUE
       LET g_hrcma_hd.hrcma04 =  g_today          
       LET g_hrcma_hd.hrcma05 =  '00:00'         
       LET g_hrcma_hd.hrcma06 =  g_today    
       LET g_hrcma_hd.hrcma07 =  '00:00'       
       LET g_hrcma_hd.hrcma11 = 'N'  
       LET g_hrcma_hd.hrcma12 = 'N'
       LET g_hrcma_hd.hrcma14 = 'N'
       LET g_hrcma_hd.hrcma15 = 'N'  
       CALL i0532_i("a")                         #輸入單頭
       IF INT_FLAG THEN                         #使用者不玩了
          LET INT_FLAG = 0
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF
          
       IF cl_null(g_hrcm02)  THEN
          CONTINUE WHILE
       END IF
       INSERT INTO i0532_temp(hrcma02,hrcma04,                                       
                      hrcma05, hrcma06, hrcma07,                   
                      hrcma08, hrcma09, hrcma10,                   
                      hrcma11, hrcma12, hrcma13,hrcma14,hrcma15)
       VALUES(g_hrcm02,g_hrcma_hd.hrcma04,                                                                                     
              g_hrcma_hd.hrcma05, g_hrcma_hd.hrcma06, g_hrcma_hd.hrcma07,                   
              g_hrcma_hd.hrcma08, g_hrcma_hd.hrcma09, g_hrcma_hd.hrcma10,                   
              g_hrcma_hd.hrcma11, g_hrcma_hd.hrcma12, g_hrcma_hd.hrcma13,'Y',g_hrcma_hd.hrcma15)
       CALL g_hrck.clear()
       LET g_rec_b=0
       CALL i0532_b()                               #輸入單身
       LET g_hrcma_hd_t.* = g_hrcma_hd.*            #保留舊值
       LET g_hrcma_hd_o.* = g_hrcma_hd.*            #保留舊值

       EXIT WHILE
    END WHILE
END FUNCTION

#處理單身欄位輸入
FUNCTION i0532_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680061 SMALLINT 
    l_n             LIKE type_file.num5,    #檢查重複用 #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否 #No.FUN-680061 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態   #No.FUN-680061 VARCHAR(1)
    l_hrckno        LIKE type_file.num10,
    l_hratid        LIKE hrat_file.hratid,
    l_hratid_hrcm05  LIKE hrat_file.hratid,
    l_hrcm06         LIKE hrcm_file.hrcm06,    #儲存未經計算的hrcm06值
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680061 SMALLINT
    l_allow_delete  LIKE type_file.num5,     #可刪除否  #No.FUN-680061 SMALLINT
    l_hrck02  LIKE hrck_file.hrck02,
    l_count         LIKE type_file.num5 
    LET g_action_choice = ""
    IF g_hrcm02 IS NULL THEN RETURN END IF
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT hrckno,hrck01,hrck02 FROM i0532_temp2 ",
        "  WHERE hrckno = ? "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i0532_bcl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_hrck WITHOUT DEFAULTS FROM s_hrck.*
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
                LET g_hrck_t.* = g_hrck[l_ac].*    #BACKUP
                OPEN i0532_bcl USING g_hrck[l_ac].hrckno
                IF STATUS THEN
                   CALL cl_err("OPEN i0532_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i0532_bcl INTO g_hrck[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_hrck[l_ac].hrck01,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
               
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_hrck[l_ac].* TO NULL
            LET g_hrck_t.* = g_hrck[l_ac].*        #新輸入資料
            CALL cl_show_fld_cont()    
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            SELECT MAX(hrckno) INTO l_hrckno FROM i0532_temp2
            IF cl_null(l_hrckno) THEN 
                LET l_hrckno = 1 
            ELSE
            	  LET l_hrckno = l_hrckno +1   
            END IF
            INSERT INTO i0532_temp2(hrckno,hrck01)
                  VALUES(l_hrckno,g_hrck[l_ac].hrck01)

            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","i0532_temp2",g_hrck[l_ac].hrck01,l_hrckno,SQLCA.sqlcode,"","",1) #FUN-660105
                CANCEL INSERT
            END IF
 
        AFTER FIELD hrck01
            IF NOT cl_null(g_hrck[l_ac].hrck01) THEN
               IF  cl_null(g_hrck[l_ac].hrck01) THEN
	                 NEXT FIELD hrck01
               END IF
               SELECT COUNT(*) INTO l_count FROM hrck_file
                WHERE hrckacti ='Y' AND hrck01 = g_hrck[l_ac].hrck01
               IF cl_null(l_count) THEN LET l_count = 0  END IF
               IF l_count <=0 THEN
                  CALL cl_err('','mfg1312',1)
                  NEXT FIELD hrck01
               END IF
               IF g_hrck[l_ac].hrck01 != g_hrck_t.hrck01 THEN
                  SELECT COUNT(*) INTO l_count FROM i0532_temp
                   WHERE hrck01 = g_hrck[l_ac].hrck01 
                  IF cl_null(l_count) THEN LET l_count = 0  END IF
                  IF l_count >0 THEN
                     CALL cl_err('','ghr-101',1)
                     NEXT FIELD hrck01
                  END IF
               END IF
                SELECT hrck02 INTO l_hrck02 FROM hrck_file
                WHERE hrckacti ='Y' AND hrck01 = g_hrck[l_ac].hrck01
                LET g_hrck[l_ac].hrck02 = l_hrck02
               DISPLAY BY NAME g_hrck[l_ac].hrck02
                            
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_hrck_t.hrck01) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM i0532_temp2             #刪除該筆單身資料
                 WHERE hrck01 = g_hrck_t.hrck01
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","i0532_temp2",g_hrcm02,g_hrck_t.hrck01,SQLCA.sqlcode,"","",1) #FUN-660105
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_hrck[l_ac].* = g_hrck_t.*
               CLOSE i0532_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_hrck[l_ac].hrck01,-263,1)
               LET g_hrck[l_ac].* = g_hrck_t.*
            ELSE
               UPDATE i0532_temp2
                  SET hrck01 = g_hrck[l_ac].hrck01
                WHERE hrckno = g_hrck[l_ac].hrckno
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","i0532_temp2",g_hrck[l_ac].hrckno,'',SQLCA.sqlcode,"","",1) #FUN-660105
                   LET g_hrck[l_ac].* = g_hrck_t.*
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
                  LET g_hrck[l_ac].* = g_hrck_t.*
               END IF
               CLOSE i0532_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i0532_bcl
            COMMIT WORK
        ON ACTION CONTROLP  
         CASE     
           WHEN INFIELD(hrck01)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_hrck01"
              LET g_qryparam.default1 = g_hrck[l_ac].hrck01
              CALL cl_create_qry() RETURNING g_hrck[l_ac].hrck01
              DISPLAY BY NAME g_hrck[l_ac].hrck01
              NEXT FIELD hrck01
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
 
    CLOSE i0532_bcl
    COMMIT WORK
END FUNCTION

#處理單頭欄位(hrcm01, hrcma03, hrcm04, hrcm05)INPUT
FUNCTION i0532_i(p_cmd)
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
                  g_hrcma_hd.hrcma05[4] =' ' OR g_hrcma_hd.hrcma05[5] =' ' OR g_x.getLength() <> 5  THEN
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
                  g_hrcma_hd.hrcma07[4] =' ' OR g_hrcma_hd.hrcma07[5] =' ' OR g_x.getLength() <> 5  THEN
                   CALL cl_err('时间录入错误','!',0)
                  NEXT FIELD hrcma07
               END IF
              IF g_hrcma_hd.hrcma06  = g_hrcma_hd.hrcma04 AND g_hrcma_hd.hrcma05 > g_hrcma_hd.hrcma07 THEN
                  CALL cl_err('','ghr-120',0)
                  NEXT FIELD hrcma07
              END IF
              #add by lijun130905------begin-------
              IF NOT cl_null(g_hrcma_hd.hrcma04) AND NOT cl_null(g_hrcma_hd.hrcma05)
                 AND NOT cl_null(g_hrcma_hd.hrcma06) THEN
                 LET l_hrcma04_05 = g_hrcma_hd.hrcma04 CLIPPED,' ',g_hrcma_hd.hrcma05 CLIPPED
                 LET l_hrcma06_07 = g_hrcma_hd.hrcma06 CLIPPED,' ',g_hrcma_hd.hrcma07 CLIPPED
                 LET l_hrcma08 = ''	
               	 LET l_string = " SELECT TO_NUMBER(to_date('",l_hrcma06_07,"','YYYY/MM/DD HH24:MI') - ",
               	                " to_date('",l_hrcma04_05,"','YYYY/MM/DD HH24:MI')) * 24 FROM dual"
               	 PREPARE l_string_cs FROM l_string
               	 EXECUTE l_string_cs INTO l_hrcma08
               	 IF l_hrcma08 > 0 THEN
               	     LET g_hrcma_hd.hrcma08 = l_hrcma08
               	     DISPLAY g_hrcma_hd.hrcma08 TO hrcma08
               	 ELSE
               	     CALL cl_err('经计算加班时长小于等于0','!',1)
               	     NEXT FIELD hrcma07
               	 END IF
              END IF
              IF NOT cl_null(g_hrcma_hd.hrcma05) THEN
              	LET g_h_05=''
                LET g_m_05=''
                LET g_h_05=g_hrcma_hd.hrcma05[1,2]
                LET g_m_05=g_hrcma_hd.hrcma05[4,5]
                IF g_h_05 > g_h THEN
                	LET g_hrcma_hd.hrcma15 = 'Y'
                ELSE
                  IF g_h_05 = g_h THEN
                	   IF g_m_05 > g_m THEN
                	 	    LET g_hrcma_hd.hrcma15 = 'Y'
                	   END IF
                  END IF	 
                END IF 
              END IF
              DISPLAY g_hrcma_hd.hrcma15 TO hrcma15
              #add by lijun130905------end-------
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

       #add by lijun130906-----begin------    
        BEFORE FIELD hrcma08
             IF NOT cl_null(g_hrcma_hd.hrcma04) AND NOT cl_null(g_hrcma_hd.hrcma05)
                 AND NOT cl_null(g_hrcma_hd.hrcma06) AND NOT cl_null(g_hrcma_hd.hrcma07) THEN
                 LET l_hrcma04_05 = g_hrcma_hd.hrcma04 CLIPPED,' ',g_hrcma_hd.hrcma05 CLIPPED
                 LET l_hrcma06_07 = g_hrcma_hd.hrcma06 CLIPPED,' ',g_hrcma_hd.hrcma07 CLIPPED
                 LET l_hrcma08 = ''   	
               	 LET l_string = " SELECT TO_NUMBER(to_date('",l_hrcma06_07,"','YYYY/MM/DD HH24:MI') - ",
               	                " to_date('",l_hrcma04_05,"','YYYY/MM/DD HH24:MI')) * 24 FROM dual"
               	 PREPARE l_string_cs_1 FROM l_string
               	 EXECUTE l_string_cs_1 INTO l_hrcma08
               	 IF l_hrcma08 > 0 THEN
               	     LET g_hrcma_hd.hrcma08 = l_hrcma08
               	     DISPLAY g_hrcma_hd.hrcma08 TO hrcma08
               	 ELSE
               	     CALL cl_err('经计算加班时长小于等于0','!',1)
               	     NEXT FIELD hrcma07
               	 END IF
              END IF
        #add by lijun130906-----end------
              
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

FUNCTION i0532_hrat_fill(p_hrcma03)
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

FUNCTION i0532_tmp()
   DEFINE l_sql STRING
    
   DROP TABLE i0532_temp  
   CREATE TEMP TABLE i0532_temp
    (  
      hrcma02   VARCHAR(20),
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
       
   DROP TABLE i0532_temp2  
   CREATE TEMP TABLE i0532_temp2
    (  
      hrckno  DECIMAL(20,10),
      hrck01   VARCHAR(20)
      )
      DROP TABLE i0532_t  
   CREATE TEMP TABLE i0532_t
    (  
      hrcma04   DATE,
      hrcma05   VARCHAR(20),
      hrcma06   DATE,  
      hrcma07   VARCHAR(20)
      )
END FUNCTION


FUNCTION i0532_auto_hrcma01()
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
   
   LET l_sql ="SELECT MAX(hrcma01) FROM i0532_temp ",
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


FUNCTION i0532_ins_hrcma() 
   DEFINE l_hrcma04 LIKE hrcma_file.hrcma04,
          l_hrcma04_t LIKE hrcma_file.hrcma04,
          l_hrcma05 LIKE hrcma_file.hrcma05,
          l_hrcma06 LIKE hrcma_file.hrcma06, 
          l_hrcma07 LIKE hrcma_file.hrcma07,
          l_hrcma15 LIKE hrcma_file.hrcma15,
          l_hrat01 LIKE hrat_file.hrat01,
          l_hratid LIKE hrat_file.hratid,
          l_hrcma01_t LIKE hrcma_file.hrcma01,
          l_hrck01_t LIKE hrck_file.hrck01,
          l_hrcka RECORD LIKE hrcka_file.*,
          l_sql_t     STRING,
          l_sql     STRING
   DEFINE sr RECORD
              hrcma02    LIKE hrcma_file.hrcma02,
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
      
   SELECT UNIQUE hrcma04,hrcma05,hrcma06,hrcma07,hrcma15 INTO l_hrcma04,l_hrcma05,l_hrcma06,l_hrcma07,l_hrcma15 FROM i0532_temp
   LET l_hrcma04_t = l_hrcma04 
   IF l_hrcma15 = 'Y' THEN
      WHILE TRUE
         LET l_hrcma04 = l_hrcma04 + 1
         IF l_hrcma04_t = l_hrcma06  THEN
            INSERT INTO i0532_t(hrcma04,hrcma05, hrcma06, hrcma07)
                       VALUES(l_hrcma04_t,l_hrcma05,l_hrcma06,l_hrcma07)	
            EXIT WHILE
         END IF
           
         IF l_hrcma04 >l_hrcma06 THEN 
            IF l_hrcma05 < l_hrcma07 THEN
               INSERT INTO i0532_t(hrcma04,hrcma05, hrcma06, hrcma07)
                       VALUES(l_hrcma04-1,l_hrcma05,l_hrcma06,l_hrcma07)	
            END IF   
            EXIT WHILE 
         END IF
      
         IF l_hrcma05 >= l_hrcma07 THEN 
          	 INSERT INTO i0532_t(hrcma04,hrcma05, hrcma06, hrcma07)
                    VALUES(l_hrcma04-1,l_hrcma05,l_hrcma04,l_hrcma07)
             CONTINUE WHILE
         ELSE 
             INSERT INTO i0532_t(hrcma04,hrcma05, hrcma06, hrcma07)
                    VALUES(l_hrcma04-1,l_hrcma05,l_hrcma04-1,l_hrcma07)	
             CONTINUE WHILE
         END IF
               
      END WHILE
   END IF
   IF l_hrcma15 = 'N' OR cl_null(l_hrcma15 ) THEN
      INSERT INTO i0532_t(hrcma04,hrcma05, hrcma06, hrcma07)
                    VALUES(l_hrcma04,l_hrcma05,l_hrcma06,l_hrcma07)	
   END IF
   LET l_sql = "SELECT * FROM i0532_t"
   PREPARE i0532_p1 FROM l_sql
   DECLARE i0532_cs1 CURSOR FOR i0532_p1 
   
   SELECT * INTO sr.* FROM i0532_temp
   
   LET l_sql = "SELECT hrcka_file.* FROM i0532_temp2,hrcka_file WHERE hrcka01 = hrck01 ORDER BY hrck01"
   PREPARE i0532_p3 FROM l_sql
   DECLARE i0532_cs3 CURSOR FOR i0532_p3
   FOREACH i0532_cs3 INTO l_hrcka.*
      LET l_sql = " (",l_hrcka.hrcka03,l_hrcka.hrcka04,"'",l_hrcka.hrcka05,"'",
                  "   AND 1=1 ",l_hrcka.hrcka06,l_hrcka.hrcka07,"'",l_hrcka.hrcka08,"'",
                  "   AND 1=1 ",l_hrcka.hrcka09,l_hrcka.hrcka10,"'",l_hrcka.hrcka11,"'",
                  "   AND 1=1 ",l_hrcka.hrcka12,l_hrcka.hrcka13,"'",l_hrcka.hrcka14,"'",
                  ")"
      IF l_sql_t IS NULL THEN LET l_sql_t = l_sql END IF
      IF l_hrck01_t IS NOT NULL THEN
         IF l_hrcka.hrcka01 = l_hrck01_t THEN            
            LET l_sql_t = l_sql_t," OR ",l_sql  
         ELSE
            LET l_sql_t = l_sql_t," UNION ",l_sql        
         END IF      
      END IF         
      LET l_hrck01_t = l_hrcka.hrcka01
   END FOREACH
    
   LET l_sql_t =  cl_replace_str(l_sql_t, "UNION", "UNION SELECT hrat01,hratid FROM hrat_file WHERE ")
   LET l_sql_t = "SELECT hrat01,hratid FROM hrat_file WHERE ",l_sql_t
   PREPARE i0532_p2 FROM l_sql_t
   DECLARE i0532_cs2 CURSOR FOR i0532_p2  
   
   SELECT * INTO sr.* FROM i0532_temp
    
   FOREACH i0532_cs2 INTO l_hrat01,l_hratid
     FOREACH i0532_cs1 INTO sr1.*
          CALL i053_auto_hrcma01() RETURNING l_hrcma01_t
          INSERT INTO hrcma_file(hrcma01,hrcma02,hrcma03,hrcma04,hrcma05,hrcma06,
                                hrcma07,hrcma08,hrcma09,hrcma10,hrcma11,hrcma12,hrcma13,hrcma14,hrcma15,ta_hrcma01) 
           VALUES(l_hrcma01_t,g_hrcm02,l_hratid,sr1.hrcma04,sr1.hrcma05,sr1.hrcma06,
                                sr1.hrcma07,sr.hrcma08,sr.hrcma09,sr.hrcma10,sr.hrcma11,sr.hrcma12,sr.hrcma13,'Y',sr.hrcma15,'N')
     END FOREACH
   END FOREACH
   
END FUNCTION
##################
