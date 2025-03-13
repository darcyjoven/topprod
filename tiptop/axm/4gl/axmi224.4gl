# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# axmi221.4gl  客戶Remark/Shipping Mark 資料維護
# Modify.........: No.FUN-570109 05/07/15 By jackie 修正建檔程式key值是否可更改  
# Modify.........: No.MOD-590065 05/09/07 By kevin 修正寫入remark不完整
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.MOD-750033 07/05/09 By claire 修正寫入remark不完整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_chr	       LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_forupd_sql    STRING        #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5     #No.FUN-570109             #No.FUN-680137 SMALLINT
 
FUNCTION axmi224(p_cust,p_cmd)
   DEFINE p_cust        LIKE occ_file.occ01         #客戶代號
   DEFINE p_cmd		LIKE type_file.chr1     	# u:update d:display only   #No.FUN-680137 VARCHAR(1)
   DEFINE i,j,s	        LIKE type_file.num5             #No.FUN-680137 SMALLINT
   DEFINE 
    l_rec_b         LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT          #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否                 #No.FUN-680137 VARCHAR(1)
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複                   #No.FUN-680137 SMALLINT
    l_allow_insert  LIKE type_file.num5,                #可新增否                   #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否                   #No.FUN-680137 SMALLINT
   DEFINE l_oci     DYNAMIC ARRAY OF RECORD
                    oci03		LIKE oci_file.oci03,
                    oci11		LIKE oci_file.oci11,
                    oci12		LIKE oci_file.oci12,
                    oci13		LIKE oci_file.oci13,
                    oci14		LIKE oci_file.oci14,
                    oci15		LIKE oci_file.oci15,
                    oci16		LIKE oci_file.oci16,
                    oci17		LIKE oci_file.oci17,
                    oci18		LIKE oci_file.oci18
                    END RECORD,
          l_oci_t   RECORD
                    oci03		LIKE oci_file.oci03,
                    oci11		LIKE oci_file.oci11,
                    oci12		LIKE oci_file.oci12,
                    oci13		LIKE oci_file.oci13,
                    oci14		LIKE oci_file.oci14,
                    oci15		LIKE oci_file.oci15,
                    oci16		LIKE oci_file.oci16,
                    oci17		LIKE oci_file.oci17,
                    oci18		LIKE oci_file.oci18
                    END RECORD,
          l_oci03_t   LIKE oci_file.oci03
   WHENEVER ERROR CONTINUE
 
   IF p_cust IS NULL OR p_cust=' '  THEN RETURN END IF
   LET p_row = 8 LET p_col = 5
 
   OPEN WINDOW axmi224_w AT p_row,p_col WITH FORM "axm/42f/axmi224"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_locale("axmi224")
 
       
   DECLARE axmi224_c CURSOR FOR
    SELECT oci03,oci11,oci12,oci13,oci14,oci15,oci16,oci17,oci18
       FROM oci_file
      WHERE oci01 = p_cust
        AND oci02 ='10'    #只針對Reamrk
      ORDER BY oci03
 
   CALL l_oci.clear()
   LET i = 1
   LET l_rec_b = 0
 
   FOREACH axmi224_c INTO l_oci[i].*
      IF STATUS THEN CALL cl_err('foreach oci',STATUS,0) EXIT FOREACH END IF 
      LET i = i + 1
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
   END FOREACH
   CALL l_oci.deleteElement(i)
 
   LET l_rec_b = i - 1
   IF p_cmd = 'd' THEN
      CALL cl_set_act_visible("accept,cancel", FALSE)
      DISPLAY ARRAY l_oci TO s_oci.* ATTRIBUTE(COUNT=l_rec_b)
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      
      END DISPLAY
      CLOSE WINDOW axmi224_w 
      RETURN 
   END IF
 
   LET g_forupd_sql = "SELECT oci03,oci11,oci12,oci13,oci14, ",
                      "       oci15,oci16,oci17,oci18  FROM oci_file ",
                      " WHERE oci01=? AND oci02='10' AND oci03=? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i224_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_oci WITHOUT DEFAULTS FROM s_oci.* 
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF l_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF l_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET l_oci_t.* = l_oci[l_ac].*  #BACKUP
#No.FUN-570109 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i224_set_entry_b(p_cmd)                                                                                         
               CALL i224_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--    
               BEGIN WORK
 
               OPEN i224_bcl USING p_cust,l_oci_t.oci03
               IF STATUS THEN
                  CALL cl_err("OPEN i224_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i224_bcl INTO l_oci[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock oci',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               LET l_oci_t.* = l_oci[l_ac].*  #BACKUP
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
#MOD-590065 begin
            #INSERT INTO oci_file(oci01,oci02,oci03,oci11)
            #        VALUES(p_cust,'10',
            #           l_oci[l_ac].oci03,l_oci[l_ac].oci11)
            INSERT INTO oci_file(oci01,oci02,oci03,oci11,oci12,oci13,oci14
                                ,oci15,oci16,oci17,oci18)
                    VALUES(p_cust,'10',
                       l_oci[l_ac].oci03,l_oci[l_ac].oci11,l_oci[l_ac].oci12,
                       l_oci[l_ac].oci13,l_oci[l_ac].oci14,l_oci[l_ac].oci15,
                       l_oci[l_ac].oci18,l_oci[l_ac].oci17,l_oci[l_ac].oci18)
#MOD-590065 end
            IF SQLCA.sqlcode THEN
#              CALL cl_err('ins oci',SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("ins","oci_file",p_cust,l_oci[l_ac].oci03,SQLCA.sqlcode,"","ins oci",1)  #No.FUN-660167
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET i = i + 1
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                      
            CALL i224_set_entry_b(p_cmd)                                                                                         
            CALL i224_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--    
            INITIALIZE l_oci[l_ac].* TO NULL      #900423
            LET l_oci_t.* = l_oci[l_ac].*             #新輸入資料
            NEXT FIELD oci03
 
        BEFORE FIELD oci03                            #default 序號
            IF l_oci[l_ac].oci03 IS NULL OR l_oci[l_ac].oci03 = 0 THEN
                SELECT max(oci03)+1 INTO l_oci[l_ac].oci03
                   FROM oci_file 
                  WHERE oci01 = p_cust
                    AND oci02 = '10'
                IF l_oci[l_ac].oci03 IS NULL THEN
                    LET l_oci[l_ac].oci03 = 1
                END IF
            END IF
        AFTER FIELD oci03                        #check 序號是否重複
          IF NOT cl_null(l_oci[l_ac].oci03) THEN
            IF l_oci[l_ac].oci03 != l_oci_t.oci03 OR
               l_oci_t.oci03 IS NULL THEN
                LET l_n=0
                SELECT count(*) INTO l_n FROM oci_file
                    WHERE oci01 = p_cust
                      AND oci02 = '10'
                      AND oci03 = l_oci[l_ac].oci03
                IF l_n > 0 THEN
                    LET l_oci[l_ac].oci03 = l_oci_t.oci03
                    CALL cl_err('',-239,0) NEXT FIELD oci03
                END IF
            END IF
          END IF
 
        BEFORE DELETE                            #是否取消單身
            IF l_oci_t.oci03 > 0 AND l_oci_t.oci03 IS NOT NULL  THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM oci_file
                 WHERE oci01 = p_cust 
                   AND oci02 = '10'
                   AND oci03 = l_oci_t.oci03
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(l_oci_t.oci03,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("del","oci_file",p_cust,l_oci_t.oci03,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET l_oci[l_ac].* = l_oci_t.*
               CLOSE i224_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(l_oci[l_ac].oci03,-263,1)
               LET l_oci[l_ac].* = l_oci_t.*
            ELSE
               UPDATE oci_file SET
                      oci03=l_oci[l_ac].oci03,
                      oci11=l_oci[l_ac].oci11,
                      oci12=l_oci[l_ac].oci12,
                      oci13=l_oci[l_ac].oci13,
                      oci14=l_oci[l_ac].oci14,
                     #MOD-750033-begin-add
                      oci15=l_oci[l_ac].oci15,
                      oci16=l_oci[l_ac].oci16,
                      oci17=l_oci[l_ac].oci17,
                      oci18=l_oci[l_ac].oci18
                     #MOD-750033-end-add
                WHERE oci01=p_cust 
                  AND oci02='10'
                  AND oci03=l_oci_t.oci03
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('upd oci',SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("upd","oci_file",p_cust,l_oci_t.oci03,SQLCA.sqlcode,"","upd oci",1)  #No.FUN-660167
                  LET l_oci[l_ac].* = l_oci_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i224_bcl
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
                  LET l_oci[l_ac].* = l_oci_t.*
               END IF
               CLOSE i224_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i224_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            #IF INFIELD(oci03) AND l_ac > 1 THEN  #MOD-590065
            IF l_ac>1 THEN
                LET l_oci[l_ac].* = l_oci[l_ac-1].*
                LET l_oci[l_ac].oci03 = NULL
                DISPLAY BY NAME l_oci[l_ac].* #.MOD-590065
                NEXT FIELD oci03
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
 
        
        END INPUT
 
    CLOSE i224_bcl 
    COMMIT WORK
    LET INT_FLAG=0
    CLOSE WINDOW axmi224_w 
            IF cl_chk_act_auth() THEN
            END IF
END FUNCTION
 
#No.FUN-570109 --start--                                                                                                            
FUNCTION i224_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1              #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("oci01,oci02,oci03",TRUE)                                                                               
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i224_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1             #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("oci01,oci02,oci03",FALSE)                                                                              
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--    
