# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aooq050.4gl
# Descriptions...: 歷史報表列印
# Date & Author..: 97/07/31 By Raymon
# Modify.........: No.MOD-4A0258 04/10/25 By Echo 選擇程式代碼後結束程式
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-720042 07/02/27 By jamie 語法錯誤
# Modify.........: No.MOD-750043 07/05/11 By claire 為避免沒有p_zaa的設定產生lib-358錯誤
# Modify.........: No.MOD-750053 07/05/31 By pengu 列印時,會跳出報表輸出的視窗,此時"確認"的按鈕會不見
# Modify.........: No.MOD-790034 07/09/10 By Smapmin 筆數計算有誤
# Modify.........: No.FUN-920160 09/02/20 By alex 調整OPEN WINDOW關閉失敗
# Modify.........: No.MOD-940237 09/04/17 By Dido 程式名稱改用 gaz03
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE    g_buf   LIKE type_file.chr1000,       #No.FUN-680102CHAR(80), 
          g_n     LIKE type_file.num5,          #No.FUN-680102SMALLINT,
          g_rec_b LIKE type_file.num5,          #No.FUN-680102 SMALLINT,
          g_zz01  LIKE zz_file.zz01             #No.FUN-680102 VARCHAR(10)
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN    #FUN-920160
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW q050_w WITH FORM "aoo/42f/aooq050"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL q050()	
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CLOSE WINDOW q050_w
END MAIN
 
FUNCTION q050()
    DEFINE l_zz_t       RECORD
             zz01       LIKE zz_file.zz01,
            #zz02       LIKE zz_file.zz02,       #MOD-940237 mark
             gaz03      LIKE gaz_file.gaz03,     #MOD-940237 add
             cnt        LIKE type_file.num5           #No.FUN-680102 SMALLINT
			END RECORD,
   	l_zz DYNAMIC ARRAY OF RECORD
		zz01  LIKE zz_file.zz01,
               #zz02  LIKE zz_file.zz02,       #MOD-940237 mark
                gaz03 LIKE gaz_file.gaz03,     #MOD-940237 add
		cnt   LIKE type_file.num5           #No.FUN-680102SMALLINT
		END RECORD,
           l_n DYNAMIC ARRAY OF RECORD
                                i      LIKE type_file.chr1,          #No.FUN-680102CHAR(1),
                                cnt    LIKE type_file.num5           #No.FUN-680102SMALLINT
                        END RECORD,
                l_n1            LIKE type_file.num5,          #No.FUN-680102 SMALLINT
		i,j,l_ac,l_sl	LIKE type_file.num5,          #No.FUN-680102 SMALLINT
		l_exit_sw	LIKE type_file.chr1,          #No.FUN-680102CHAR(1),
 		l_flag,l_sw    	LIKE type_file.chr1,          #No.FUN-680102CHAR(1),               #MOD-4A0258
		l_wc  		LIKE type_file.chr1000,       #No.FUN-680102CHAR(1000),
		l_wc1  		LIKE type_file.chr20,         #No.FUN-680102CHAR(10),
		l_sql 		LIKE type_file.chr1000,       #No.FUN-680102CHAR(1000),
		l_str 		LIKE type_file.chr50,         #No.FUN-680102CHAR(30),
		l_priv		LIKE type_file.chr20          #No.FUN-680102CHAR(10),
 
   INPUT g_zz01 FROM zz01
 
      AFTER FIELD zz01
         IF g_zz01 IS NULL THEN
             NEXT FIELD azb01
         END IF
 
      ON ACTION CONTROLP
          CASE
              WHEN INFIELD(zz01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaz"
                  LET g_qryparam.default1 = g_zz01
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_zz01
                  DISPLAY g_zz01 TO FORMONLY.zz01
              OTHERWISE
                  EXIT CASE
          END CASE
 
      ON ACTION cancel
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
         EXIT PROGRAM
 
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
 
   LET l_str=NULL
   LET g_buf=NULL
   CALL l_n.clear()
   LET i=1
   LET j=1
   LET l_n1=1
   LET l_str=g_zz01
 
   RUN 'cd $TEMPDIR'
 
   SELECT zz06 INTO l_sw FROM zz_FILE WHERE zz01 = g_zz01
 
#  LET g_buf="chmod 777 a"                       #No.FUN-9C0009    
#  RUN g_buf                                     #No.FUN-9C0009
   IF os.Path.chrwx("a" CLIPPED,511) THEN END IF   #No.FUN-9C0009
 
   IF l_sw = '1'  THEN #
     LET g_buf="ls ",g_zz01 CLIPPED,".out >a"
     RUN g_buf
   ELSE
     LET g_buf="ls ",g_zz01 CLIPPED,".??r >a"
     RUN g_buf
   END IF
     DROP TABLE temp_out
     CREATE TEMP TABLE temp_out(
                t1 LIKE type_file.chr20)
     LOAD FROM 'a' INSERT INTO temp_out
 
    #-MOD-940237-add
    #LET l_sql = " SELECT UNIQUE SUBSTRING(t1,1,7),zz02,COUNT(*) FROM temp_out, zz_file
    #                WHERE SUBSTRING(t1,1,7)=zz01 GROUP BY SUBSTRING(t1,1,7),zz02"
    #No.TQC-9B0021  --Begin
    #LET l_sql = " SELECT SUBSTRING(t1,1,7),gaz03,COUNT(*) FROM temp_out,gaz_file ",
    #            "  WHERE SUBSTRING(t1,1,7) = gaz01 AND gaz02 = '",g_lang,"' GROUP BY SUBSTRING(t1,1,7),gaz03 "
     LET l_sql = " SELECT t1[1,7],gaz03,COUNT(*) FROM temp_out,gaz_file ",
                 "  WHERE t1[1,7] = gaz01 AND gaz02 = '",g_lang,"' GROUP BY t1[1,7],gaz03 "
    #No.TQC-9B0021  --End  
    #-MOD-940237-end
 
     PREPARE q050_pb FROM l_sql
     DECLARE q050_v1_c CURSOR FOR q050_pb
     LET l_ac=1
    #FOREACH q050_v1_c INTO l_zz[l_ac].zz01,l_zz[l_ac].zz02,l_zz[l_ac].cnt   #MOD-940237 mark
     FOREACH q050_v1_c INTO l_zz[l_ac].zz01,l_zz[l_ac].gaz03,l_zz[l_ac].cnt  #MOD-940237 add
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)    
            EXIT FOREACH
        END IF
        #SELECT COUNT(*) INTO l_zz[l_ac].cnt FROM temp_out   #MOD-790034
        LET l_ac=l_ac+1
     END FOREACH
 
     CALL SET_COUNT(l_ac-1)
     LET g_rec_b=l_ac-1
     MESSAGE ""
 
   OPEN WINDOW q050_w2 WITH FORM "aoo/42f/aooq050_2"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("aooq050_2")
 
   WHILE TRUE
     LET l_exit_sw = "y"
 
     CALL cl_set_act_visible("accept,cancel", FALSE)
     DISPLAY ARRAY l_zz TO s_zz.*
          BEFORE ROW
             LET l_ac = ARR_CURR()
             LET l_sl = SCR_LINE()
             IF l_zz[l_ac].zz01 IS NOT NULL THEN
                DISPLAY l_zz[l_ac].zz01 TO s_zz[l_sl].zz01
             END IF
 
          AFTER ROW
             DISPLAY l_zz[l_ac].zz01 TO s_zz[l_sl].zz01
 
        ON ACTION view_detail
             IF l_zz[l_ac].zz01 IS NOT NULL THEN
                 CALL q050_vout(l_zz[l_ac].zz01)
                 EXIT DISPLAY
             ELSE
                 CONTINUE DISPLAY
             END IF
 
        ON ACTION exit
          EXIT DISPLAY
 
        ON ACTION accept
           CONTINUE DISPLAY
 
        ON ACTION CONTROLG
           CALL cl_cmdask()    # Command execution
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
           CONTINUE DISPLAY
     END DISPLAY
     CALL cl_set_act_visible("accept,cancel", TRUE)
 
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
     IF l_exit_sw = "y" THEN EXIT WHILE  END IF
   END WHILE
 
   CLOSE WINDOW q050_w2
   RETURN
END FUNCTION
 
FUNCTION q050_vout(p_prog)
  DEFINE p_prog		LIKE zz_file.zz01            #No.FUN-680102CHAR(10)
  DEFINE str		LIKE type_file.chr1000       #No.FUN-680102CHAR(80)
  DEFINE l_cmd		LIKE type_file.chr1000       #No.FUN-680102CHAR(80)
  DEFINE l_name	        LIKE type_file.chr20         #No.FUN-680102 VARCHAR(20)
  DEFINE i,j,k,m,n	LIKE type_file.num5          #No.FUN-680102 SMALLINT
  DEFINE vout DYNAMIC ARRAY OF RECORD
                        x       LIKE type_file.chr1,          #No.FUN-680102CHAR(1),
  			t1	LIKE type_file.chr20,         #No.FUN-680102CHAR(20),
  			t2	LIKE type_file.num10          #No.FUN-680102INTEGER
  			END RECORD
   DEFINE l_cnt          LIKE type_file.num10          #No.FUN-680102INTEGER          # MOD-4A0258
   DEFINE l_sw           LIKE type_file.chr1           #No.FUN-680102CHAR(1)           # MOD-4A0258
 
  RUN 'cd $TEMPDIR'
 
   SELECT zz06 INTO l_sw FROM zz_FILE WHERE zz01 = p_prog
   IF l_sw = '1' THEN  #
      LET l_cmd='wc -l ',p_prog CLIPPED,'.out > a'
      RUN l_cmd
   ELSE
      LET l_cmd='wc -l ',p_prog CLIPPED,'.??r > a'
      RUN l_cmd
   END IF
 
  OPEN WINDOW q050_w1 WITH FORM "aoo/42f/aooq050_1"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
  CALL cl_ui_locale("aooq050_1")
 
  IF STATUS THEN CALL cl_err('open w:',STATUS,1) RETURN END IF
  DROP TABLE temp_out
  CREATE TEMP TABLE temp_out(
     t1 LIKE type_file.chr20)
  LOAD FROM 'a' INSERT INTO temp_out
  DECLARE q050_vout_c CURSOR FOR SELECT * FROM temp_out
  LET i=1
  FOREACH q050_vout_c INTO str
     FOR j=1 TO 40
        LET k=j+1
        IF cl_null(str[j]) AND NOT cl_null(str[k]) THEN
           LET vout[i].t2=str[1,j]
           LET vout[i].t1=str[k,40]
            LET vout[i].x='N'                     # MOD-4A0258
        END IF
     END FOR
 
     LET i=i+1
     IF i>100 THEN EXIT FOREACH END IF
  END FOREACH
 
  LET l_cnt=vout[vout.getLength()].t2
  DISPLAY l_cnt TO FORMONLY.cnt2
  CALL vout.deleteElement(vout.getLength())
  CALL SET_COUNT(i-1)
  DISPLAY vout.getLength() TO FORMONLY.cnt
  MESSAGE ""
  CALL cl_set_act_visible("accept,cancel", FALSE)
  LET l_name = 'aooq050'  #MOD-750043 add
 
  DISPLAY ARRAY vout TO s_vout.*   #TQC-720042 mod
 
  INPUT ARRAY vout WITHOUT DEFAULTS FROM s_vout.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
             INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
     BEFORE ROW
        LET i=ARR_CURR()
        LET j=SCR_LINE()
        IF NOT cl_null(vout[i].t1) THEN
           DISPLAY vout[i].t1 TO s_vout[j].t1
        END IF
 
     AFTER ROW
        DISPLAY vout[i].t1 TO s_vout[j].t1
 
     ON ACTION output
        LET n=0
        CALL cl_set_act_visible("accept,cancel", TRUE)   #No.MOD-750053 add
        FOR m=1 TO vout.getLength()
            IF cl_null(vout[m].t1) THEN EXIT FOR END IF
            IF vout[m].x='Y' THEN LET n=n+1 END IF
            CASE
              WHEN vout[m].x='Y' AND n=1
                #   CALL cl_outnam('aooq050') RETURNING l_name
                   LET l_cmd='cat ',vout[m].t1 CLIPPED,' >',l_name
                   RUN l_cmd
              WHEN vout[m].x='Y' AND n>1
                   LET l_cmd='cat ',vout[m].t1 CLIPPED,' >>',l_name
                   RUN l_cmd
            END CASE
        END FOR
        IF n>0 THEN
           CALL cl_prt(l_name,' ','1',g_len)
           LET l_cmd='rm ',l_name CLIPPED
           RUN l_cmd
           FOR m=1 TO vout.getLength()
               LET vout[m].x='N'
               DISPLAY vout[m].x TO s_vout[m].x
           END FOR
        CALL fgl_set_arr_curr(1)
        END IF
        CALL cl_set_act_visible("accept,cancel", FALSE)     #No.MOD-750053 add
 
     ON ACTION exit
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211  
        EXIT PROGRAM
 
     ON ACTION cancel
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211  
        EXIT PROGRAM
 
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
 
  CALL cl_set_act_visible("accept,cancel", TRUE)
  CLOSE WINDOW q050_w1
  RETURN
 
END FUNCTION
 
 
