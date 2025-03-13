# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmp611.4gl
# Descriptions...: 排貨模擬
# Date & Author..: 95/02/08 by Roger
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.TQC-630107 06/03/10 By AlexStar 單身筆數限制
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-710046 07/01/18 By Carrier 錯誤訊息匯整
# Modify.........: No.TQC-780095 07/09/03 By Melody Primary key
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-8A0086 08/10/21 By lutingting完善錯誤訊息匯總
# Modify.........: No.FUN-980010 09/08/20 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-C50097 12/07/27 By SunLM 对ogc13赋值0
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_date		LIKE type_file.dat        #No.FUN-680137 DATE
   DEFINE g_dest		LIKE aab_file.aab02       #No.FUN-680137 VARCHAR(6)
   DEFINE order_sw		LIKE type_file.chr1       #No.FUN-680137 VARCHAR(1)
   DEFINE g_oga RECORD LIKE oga_file.*
   DEFINE g_ogb RECORD LIKE ogb_file.*
   DEFINE g_ogc RECORD LIKE ogc_file.*
   DEFINE g_img RECORD LIKE img_file.*
   DEFINE o_qty LIKE ogb_file.ogb16        #No.FUN-680137 DECIMAL(15,3) #TQC-840066
   DEFINE g_sr  DYNAMIC ARRAY OF RECORD
                oga17 LIKE oga_file.oga17,
                oga01 LIKE oga_file.oga01,
                oga032 LIKE oga_file.oga032,
                oga41 LIKE oga_file.oga41,
                oga42 LIKE oga_file.oga42,
                qty LIKE type_file.num10         #No.FUN-680137 INTEGER
                END RECORD
   DEFINE g_sr_s RECORD
                oga17 LIKE oga_file.oga17,
                oga01 LIKE oga_file.oga01,
                oga032 LIKE oga_file.oga032,
                oga41 LIKE oga_file.oga41,
                oga42 LIKE oga_file.oga42,
                qty  LIKE type_file.num10        #No.FUN-680137 INTEGER
                END RECORD
 
DEFINE   g_cnt,g_rec_b   LIKE type_file.num10    #No.FUN-680137 INTEGER 
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(72)
DEFINE   l_flag          LIKE type_file.num5     #No.FUN-680137 SMALLINT
DEFINE   i               LIKE type_file.num5     #No.FUN-680137 SMALLINT
DEFINE   j               LIKE type_file.num5     #No.FUN-680137 SMALLINT
 
 
MAIN
   OPTIONS 
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211 
   OPEN WINDOW p611_w WITH FORM "axm/42f/axmp611" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL cl_opmsg('f')
 
    WHILE TRUE
      LET g_action_choice = ''
      CALL p611()
      IF g_action_choice = 'locale' THEN 
         CALL cl_dynamic_locale() 
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF cl_sure(20,20) THEN
         LET g_success = 'Y'
         BEGIN WORK
         CALL p611_2()
         #No.FUN-710046  --Begin
         CALL s_showmsg()
         #No.FUN-710046  --End  
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
         ERROR ''
         IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
       END IF
    END WHILE
    CLOSE WINDOW p611_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION p611()
 
    
    CLEAR FORM                       #清除畫面
    CALL g_sr.clear()
    LET g_date=g_today
    LET order_sw=1
    CALL cl_set_head_visible("grid01,grid02","YES")       #No.FUN-6A0092
 
    INPUT BY NAME g_date,g_dest,order_sw WITHOUT DEFAULTS 
      AFTER FIELD g_date
         IF cl_null(g_date) THEN NEXT FIELD g_date END IF
      AFTER FIELD order_sw
         IF cl_null(order_sw) THEN NEXT FIELD order_sw END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON ACTION locale
         LET g_action_choice='locale'
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
    END INPUT
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW p611_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM 
    END IF
    IF g_action_choice = 'locale' THEN RETURN END IF
    CALL p611_b_fill('1')
    CALL p611_1()
END FUNCTION
 
FUNCTION p611_1()
   DEFINE l_sql    	LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(300)
 
      INPUT ARRAY g_sr WITHOUT DEFAULTS FROM s_oga.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
         BEFORE ROW
            LET i=ARR_CURR()
         ON ROW CHANGE
            UPDATE oga_file SET oga17=g_sr[i].oga17 
             WHERE oga01=g_sr[i].oga01
            IF STATUS THEN CALL cl_err('',STATUS,1) END IF
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("grid01,grid02","AUTO")           #No.FUN-6A0092
 
         ON ACTION locale
            LET g_action_choice='locale'
            EXIT INPUT
      
      END INPUT
      IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW p611_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM 
      END IF
      IF g_action_choice = 'locale' THEN RETURN END IF
      CALL p611_b_fill('2') 
      DISPLAY ARRAY g_sr TO s_oga.* ATTRIBUTE(COUNT=g_rec_b)
        BEFORE DISPLAY
          EXIT DISPLAY
      END DISPLAY
 
END FUNCTION
 
FUNCTION p611_b_fill(p_cmd)
   DEFINE l_sql    	LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(300)
   DEFINE p_cmd         LIKE type_file.chr1    #2:重show單身        #No.FUN-680137 VARCHAR(1)
 
   LET l_sql="SELECT oga17,oga01,oga032,oga41,oga42,0 FROM oga_file",
             " WHERE oga02 = '",g_date,"' AND ogaconf='Y' AND ogapost='N'"
   IF NOT cl_null(g_dest) THEN
      LET l_sql=l_sql CLIPPED," AND oga41='",g_dest,"'"
   END IF
   IF p_cmd = '1' THEN
      CASE WHEN order_sw='1' LET l_sql=l_sql CLIPPED," ORDER BY oga01"
           WHEN order_sw='2' LET l_sql=l_sql CLIPPED," ORDER BY oga42,oga01"
           OTHERWISE         LET l_sql=l_sql CLIPPED," ORDER BY oga17"
      END CASE
   ELSE
      LET l_sql=l_sql CLIPPED," ORDER BY oga17"
   END IF
   PREPARE p611_p1 FROM l_sql
   DECLARE p611_c1 CURSOR WITH HOLD FOR p611_p1
   CALL g_sr.clear()
   LET i = 1
   FOREACH p611_c1 INTO g_sr[i].*
     IF STATUS THEN EXIT FOREACH END IF
     SELECT SUM(ogb16) INTO g_sr[i].qty FROM ogb_file WHERE ogb01=g_sr[i].oga01
     LET i = i + 1
     
     #TQC-630107---add---
      IF i > g_max_rec THEN   
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
     #TQC-630107---end---
     
   END FOREACH
   CALL g_sr.deleteElement(i)
   LET g_rec_b=i-1
 
END FUNCTION
 
FUNCTION p611_2()
   DEFINE l_sql    	LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(300)
 
   CALL cl_wait()
#  MESSAGE 'CREATE TEMP TABLE'
   CALL ui.Interface.refresh()
   DROP TABLE p611
#No.FUN-680137-----Begin-----
#  CREATE TEMP TABLE p611(img01 VARCHAR(40),img02 VARCHAR(10),img03 VARCHAR(10),   #FUN-560011
#                         img04 VARCHAR(10),img10 integer, img28 smallint)
   CREATE TEMP TABLE p611(
           img01 LIKE img_file.img01,
           img02 LIKE img_file.img02,
           img03 LIKE img_file.img03,
           img04 LIKE img_file.img04,
           img10 LIKE img_file.img10, 
           img28 LIKE img_file.img28)
 
#No.FUN-680137-----End----- 
   FOR i = 1 TO 100
     IF cl_null(g_sr[i].oga01) THEN CONTINUE FOR END IF
     IF cl_null(g_sr[i].oga17) THEN CONTINUE FOR END IF
     MESSAGE 'ins temp-img:',i,' ',g_sr[i].oga01
     CALL ui.Interface.refresh()
	 LET g_msg=g_sr[i].oga01
     INSERT INTO p611 SELECT img01,img02,img03,img04,img10,img28 FROM img_file
			           WHERE img01 IN (SELECT ogb04 FROM ogb_file
			                              WHERE ogb01 = g_msg)
			             AND img10 > 0 AND img23='Y'
 			           GROUP BY img01,img02,img03,img04,img10,img28
   END FOR
   SELECT * FROM p611 GROUP BY img01,img02,img03,img04,img10,img28 INTO TEMP x
   DELETE FROM p611
   INSERT INTO p611 SELECT * FROM x
 
   CALL s_showmsg_init()   #No.FUN-710046
   FOR i = 1 TO 100
     #No.FUN-710046  --Begin
     IF g_success = "N" THEN
        LET g_totsuccess = "N"
        LET g_success = "Y"
     END IF
     #No.FUN-710046  --End
     IF cl_null(g_sr[i].oga01) THEN CONTINUE FOR END IF
     IF cl_null(g_sr[i].oga17) THEN CONTINUE FOR END IF
     MESSAGE 'arrange:',i,' ',g_sr[i].oga01
     CALL ui.Interface.refresh()
     DECLARE p611_c2 CURSOR WITH HOLD FOR
          SELECT * FROM ogb_file WHERE ogb01=g_sr[i].oga01
     FOREACH p611_c2 INTO g_ogb.*
       IF STATUS THEN 
          LET g_success = 'N'               #No.FUN-8A0086
          EXIT FOREACH 
       END IF
       DELETE FROM ogc_file WHERE ogc01=g_ogb.ogb01 AND ogc03=g_ogb.ogb03
       LET o_qty=g_ogb.ogb16
       LET l_sql="SELECT img02,img03,img04,img10,img28 FROM p611",
			     "  WHERE img01 = '",g_ogb.ogb04 CLIPPED,"' AND img10 > 0",
			     "  ORDER BY img28"
	   IF NOT cl_null(g_ogb.ogb092) THEN
	 	  LET l_sql=l_sql CLIPPED," AND img04 ='",g_ogb.ogb092 CLIPPED,"'"
	   END IF
	   PREPARE p611_p3 FROM l_sql
	   DECLARE p611_c3 CURSOR WITH HOLD FOR p611_p3
	   FOREACH p611_c3 INTO g_img.img02,g_img.img03,g_img.img04,
                            g_img.img10,g_img.img28
	      IF STATUS THEN EXIT FOREACH END IF
	      IF g_img.img10 >= g_ogb.ogb16
	         THEN LET g_ogc.ogc16 = g_ogb.ogb16
	              CALL p611_update()
	              EXIT FOREACH
	         ELSE LET g_ogc.ogc16 = g_img.img10
	              LET g_ogb.ogb16 = g_ogb.ogb16 - g_img.img10
	              CALL p611_update()
	              CONTINUE FOREACH
	      END IF
	   END FOREACH
     END FOREACH
   END FOR
   #No.FUN-710046  --Begin
   IF g_totsuccess = 'N' THEN
      LET g_success = 'N'
   END IF
   #No.FUN-710046  --End
END FUNCTION
 
FUNCTION p611_update()
   UPDATE p611 SET img10 = img10 - g_ogc.ogc16
          WHERE img01=g_ogb.ogb04 AND img02=g_img.img02
            AND img03=g_img.img03 AND img04=g_img.img04
   IF g_ogc.ogc16=o_qty
      THEN UPDATE ogb_file SET 
                  ogb09=g_img.img02,ogb091=g_img.img03,ogb17='N'
                  WHERE ogb01=g_ogb.ogb01 AND ogb03=g_ogb.ogb03
           IF SQLCA.SQLCODE THEN
#             CALL cl_err('upd ogb:',STATUS,1)   #No.FUN-660167
              #No.FUN-710046  --Begin
              #CALL cl_err3("upd","ogb_file",g_ogb.ogb01,g_ogb.ogb03,STATUS,"","upd ogb",1)   #No.FUN-660167
              LET g_showmsg=g_ogb.ogb01,"/",g_ogb.ogb03
              CALL s_errmsg("ogb01,ogb03",g_showmsg,"upd ogb:",SQLCA.sqlcode,1)
              #No.FUN-710046  --End  
              LET g_success = 'N'
           END IF
      ELSE UPDATE ogb_file SET ogb17='Y'
                  WHERE ogb01=g_ogb.ogb01 AND ogb03=g_ogb.ogb03
           IF SQLCA.SQLCODE THEN
#             CALL cl_err('upd ogb:',STATUS,1)   #No.FUN-660167
              #No.FUN-710046  --Begin
              #CALL cl_err3("upd","ogb_file",g_ogb.ogb01,g_ogb.ogb03,STATUS,"","upd ogb",1)   #No.FUN-660167
              LET g_showmsg=g_ogb.ogb01,"/",g_ogb.ogb03
              CALL s_errmsg("ogb01,ogb03",g_showmsg,"upd ogb:",SQLCA.sqlcode,1)
              #No.FUN-710046  --End  
              LET g_success = 'N'
           END IF
           LET g_ogc.ogc01 = g_ogb.ogb01
           LET g_ogc.ogc03 = g_ogb.ogb03
           LET g_ogc.ogc09 = g_img.img02
           LET g_ogc.ogc091= g_img.img03
           LET g_ogc.ogc092= g_img.img04
           LET g_ogc.ogc12 = g_ogb.ogb12
           LET g_ogc.ogc15 = g_ogb.ogb15
           LET g_ogc.ogc15_fac = g_ogb.ogb15_fac
           LET g_ogc.ogc16 = g_ogb.ogb16
          #TQC-780095
           IF cl_null(g_ogc.ogc01) THEN LET g_ogc.ogc01=' ' END IF
           IF cl_null(g_ogc.ogc03) THEN LET g_ogc.ogc03=0 END IF
           IF cl_null(g_ogc.ogc09) THEN LET g_ogc.ogc09=' ' END IF
           IF cl_null(g_ogc.ogc091) THEN LET g_ogc.ogc091=' ' END IF
           IF cl_null(g_ogc.ogc092) THEN LET g_ogc.ogc092=' ' END IF
           IF cl_null(g_ogc.ogc17) THEN LET g_ogc.ogc17=' ' END IF
          #TQC-780095
           #FUN-980010 add plant & legal 
           LET g_ogc.ogcplant = g_plant 
           LET g_ogc.ogclegal = g_legal 
           #FUN-980010 end plant & legal 
           IF cl_null(g_ogc.ogc13) THEN LET g_ogc.ogc13=0 END IF #FUN-C50097
 
           INSERT INTO ogc_file VALUES (g_ogc.*)
           IF SQLCA.SQLCODE THEN
#             CALL cl_err('ins ogc:',STATUS,1)   #No.FUN-660167
              #No.FUN-710046  --Begin
              #CALL cl_err3("ins","ogc_file","","",STATUS,"","ins ogc",1)   #No.FUN-660167
              LET g_showmsg=g_ogc.ogc01,"/",g_ogc.ogc03,"/",g_ogc.ogc09,"/",g_ogc.ogc091,"/",g_ogc.ogc092,"/",g_ogc.ogc17
              CALL s_errmsg("ogc01,ogc03,ogc09,ogc091,ogc092,ogc17",g_showmsg,"ins ogc",SQLCA.sqlcode,1)
              #No.FUN-710046  --End  
              LET g_success = 'N'
           END IF
   END IF
END FUNCTION
