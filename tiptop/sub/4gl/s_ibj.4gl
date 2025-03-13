# Prog. Version..: '5.30.06-13.04.22(00004)'     #
# Program name...: s_ibj.4gl
# Descriptions...: 將条码異動資料放入条码異動記錄檔中(製造管理)
# Date & Author..: No:DEV-D10013 2013/01/31 By Nina 新增FUNCTION s_insibj()
#                  No:DEV-D10021 2013/01/31 By Nina 新增FUNCTION s_chkibj()
# Usage..........: CALL s_ibj(p_argv1,p_argv2,p_argv3,p_argv4,p_plant) RETURNING g_success
# Input Parameter: p_argv1   备用   
#                  p_argv2   备用 
#                  p_argv3   备用 
#                  p_argv4   备用 
#                  p_plant   异动营运中心
# Return Code....: g_success 
# Modify.........: No.DEV-D30025 2013/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---
# Modify.........: No:DEV-D30047 13/04/12 By TSD.sophy 掃描後將數量分配至項次
# Modify.........: No:DEV-D40014 13/04/12 By Mandy 新增ibb17
# Modify.........: No:DEV-D30046 13/04/19 By TSD.sophy 調整SQL錯誤


#DEV-D10013 add str-----------------------
DATABASE ds
 
GLOBALS "../../config/top.global" 
GLOBALS "../../aba/4gl/barcode.global"
 
DEFINE   g_chr           LIKE type_file.chr1  
DEFINE   g_i             LIKE type_file.num5  
DEFINE   g_sql           STRING
DEFINE   g_argv1         LIKE type_file.chr20
DEFINE   g_argv2         LIKE type_file.chr10 
DEFINE   g_argv3         LIKE type_file.chr50
DEFINE   g_argv4         LIKE type_file.num10
DEFINE   g_plant_new     LIKE type_file.chr10 
DEFINE   g_legal_new     LIKE type_file.chr10

FUNCTION s_insibj(p_argv1,p_argv2,p_argv3,p_argv4,p_plant_new)
    DEFINE p_argv1  LIKE  type_file.chr20
    DEFINE p_argv2  LIKE  type_file.chr10
    DEFINE p_argv3  LIKE  type_file.chr50
    DEFINE p_argv4  LIKE  type_file.num10
    DEFINE p_plant_new  LIKE  type_file.chr10     #营运中心
    DEFINE l_slip   LIKE  type_file.chr10         #流水号中的日期(YYYYMMDD)
    #DEV-D30047 --add--begin
    DEFINE l_ibb06  LIKE ibb_file.ibb06
    DEFINE l_count  LIKE type_file.num10
    DEFINE l_seqno  LIKE type_file.num10
    DEFINE l_qty    LIKE ibj_file.ibj05
    DEFINE l_ibj    RECORD LIKE ibj_file.*
    DEFINE l_ibj15  LIKE ibj_file.ibj15
    #DEV-D30047 --add--end
    #DEV-D30046 --add--str
    DEFINE l_ibj05  LIKE ibj_file.ibj05
    DEFINE l_ibj05_t LIKE ibj_file.ibj05
    #DEV-D30046 --add--end
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    LET g_argv1 = p_argv1
    LET g_argv2 = p_argv2
    LET g_argv3 = p_argv3
    LET g_argv4 = p_argv4
    LET g_plant_new = p_plant_new
    IF cl_null(g_plant_new) THEN 
       LET g_plant_new = g_plant
    END IF 
    SELECT azw02 INTO g_legal_new FROM azw_file
     WHERE azw01 = g_plant_new

    #NOT NULL欄位給預設值
    IF cl_null(g_ibj.ibj03) THEN
       LET g_ibj.ibj03 =  ' '
    END IF 
    IF cl_null(g_ibj.ibj04) THEN
       LET g_ibj.ibj04 =  ' '
    END IF 
    IF cl_null(g_ibj.ibj05) THEN #異動數量不分正負數皆直接存值於ibj05(ex:-500或300)
       LET g_ibj.ibj05 = 0
    END IF 
    IF cl_null(g_ibj.ibj10) THEN
       LET g_ibj.ibj10 = 'N'
    END IF
    IF cl_null(g_ibj.ibj11) THEN
       LET g_ibj.ibj11 = g_prog
    END IF
    IF cl_null(g_ibj.ibj12) THEN
       LET g_ibj.ibj12 = FGL_GETPID()
    END IF
    IF cl_null(g_ibj.ibj13) THEN
       LET g_ibj.ibj13 = g_user
    END IF
    IF cl_null(g_ibj.ibj14) THEN
       LET g_ibj.ibj14 = TODAY
    END IF
    IF cl_null(g_ibj.ibj15) THEN
       LET g_ibj.ibj15 = CURRENT HOUR TO FRACTION(3)
    END IF
    IF cl_null(g_ibj.ibj16) THEN
       LET g_ibj.ibj16 = cl_used_ap_hostname() #AP Server
    END IF
    #DEV-D40014---add---str--
    IF cl_null(g_ibj.ibj17) THEN
       LET g_ibj.ibj17 = 0 
    END IF
    #DEV-D40014---add---end--

    LET g_ibj.ibjuser = g_user 
    LET g_ibj.ibjgrup = g_grup
    LET g_ibj.ibjplant = g_plant_new
    LET g_ibj.ibjlegal = g_legal_new
    
    LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'ibj_file'),
                " (ibj01,ibj02,ibj03,ibj04,ibj05, ",
                "  ibj06,ibj07,ibj08,ibj09,ibj10,ibj11, ",
                "  ibj12,ibj13,ibj14,ibj15,ibj16, ",
                "  ibj17, ", #DEV-D40014 add
                "  ibjuser,ibjgrup,ibjplant,ibjlegal)     ",
                "VALUES(?,?,?,?,?,  ?,?,?,?,?,    ",
                "       ?,?,?,?,?,  ?,?,?,?,?,    ",
                "       ?  )  "  #DEV-D40014 add 一個?
    PREPARE ins_prep FROM g_sql
    EXECUTE ins_prep USING 
          g_ibj.ibj01,g_ibj.ibj02,
          g_ibj.ibj03,g_ibj.ibj04,g_ibj.ibj05,g_ibj.ibj06,
          g_ibj.ibj07,g_ibj.ibj08,g_ibj.ibj09,g_ibj.ibj10,
          g_ibj.ibj11,g_ibj.ibj12,g_ibj.ibj13,g_ibj.ibj14,
          g_ibj.ibj15,g_ibj.ibj16,
          g_ibj.ibj17, #DEV-D40014 add
          g_ibj.ibjuser,g_ibj.ibjgrup,g_ibj.ibjplant,g_ibj.ibjlegal
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
       IF g_bgerr THEN
          CALL s_errmsg('ibj12',g_ibj.ibj12,'s_ibj:ins ibj',STATUS,1)
       ELSE
           CALL cl_err3("ins","ibj_file",g_ibj.ibj01,"",STATUS,"","",1) 
       END IF
       LET g_success='N'
       RETURN
    END IF

    #DEV-D30047 --add--begin
    IF cl_null(g_ibj.ibj07) THEN 
       SELECT * INTO g_ibd.* FROM ibd_file WHERE ibd01 = '0'
     
       #依據條碼編號，取出料件編號(ibb06)
       LET l_ibb06 = ''
       LET g_sql = "SELECT ibb06 FROM ibb_file WHERE ibb01 = ? "
       DECLARE get_itemno_cs SCROLL CURSOR FROM g_sql
       OPEN get_itemno_cs USING g_ibj.ibj02
       FETCH FIRST get_itemno_cs INTO l_ibb06
       CLOSE get_itemno_cs
     
       #==================================
       #依據該筆條碼資料的來源單號(ibj06)+倉庫(ibj03)+儲位(ibj04)+料號(ibb06)，
       #找出對應table的資料筆數。
       #1.若資料筆數=1，則直接update單據項次欄位(ibj_file)
       #2.若資料筆數>1，則SQL依據abas010的排序方式，取出單據單身項次，
       #  新增掃描異動記錄檔(ibj_file)，新增後刪除原掃描資料。
       #==================================
     
       LET l_ibj15 = CURRENT HOUR TO FRACTION(3)
       
       LET l_count = 0 
       CASE 
          #收貨
          WHEN g_ibj.ibj11="abat170" OR g_ibj.ibj11="wmbt170"
             SELECT COUNT(*) INTO l_count FROM rvb_file
              WHERE rvb01 = g_ibj.ibj06
                AND rvb05 = l_ibb06
                AND rvb36 = g_ibj.ibj03
                AND rvb37 = g_ibj.ibj04
          #出通
          WHEN g_ibj.ibj11="abat163" OR g_ibj.ibj11="wmbt163"
             SELECT COUNT(*) INTO l_count FROM ogb_file
              WHERE ogb01 = g_ibj.ibj06
                AND ogb04 = l_ibb06
                AND ogb09 = g_ibj.ibj03
                AND ogb091 = g_ibj.ibj04
       END CASE 
       IF cl_null(l_count) THEN LET l_count = 0 END IF    
       
       IF l_count=1 THEN 
          LET l_seqno = ''
          CASE 
             #收貨
             WHEN g_ibj.ibj11="abat170" OR g_ibj.ibj11="wmbt170"
                SELECT rvb02 INTO l_seqno FROM rvb_file
                 WHERE rvb01 = g_ibj.ibj06
                   AND rvb05 = l_ibb06
                   AND rvb36 = g_ibj.ibj03
                   AND rvb37 = g_ibj.ibj04
             #出通
             WHEN g_ibj.ibj11="abat163" OR g_ibj.ibj11="wmbt163"
                SELECT ogb03 INTO l_seqno FROM ogb_file
                 WHERE ogb01 = g_ibj.ibj06
                   AND ogb04 = l_ibb06
                   AND ogb09 = g_ibj.ibj03
                   AND ogb091 = g_ibj.ibj04
          END CASE 
          
          UPDATE ibj_file SET ibj07 = l_seqno 
           WHERE ibj01 = g_ibj.ibj01
             AND ibj02 = g_ibj.ibj02
             AND ibj03 = g_ibj.ibj03
             AND ibj04 = g_ibj.ibj04
             AND ibj05 = g_ibj.ibj05
             AND ibj06 = g_ibj.ibj06
             AND ibj10 = g_ibj.ibj10
             AND ibj11 = g_ibj.ibj11
             AND ibj12 = g_ibj.ibj12
             AND ibj13 = g_ibj.ibj13
             AND ibj14 = g_ibj.ibj14
             AND ibj15 = g_ibj.ibj15
             AND ibj16 = g_ibj.ibj16
             AND ibjlegal = g_ibj.ibjlegal
             AND ibjplant = g_ibj.ibjplant
       ELSE 
          LET l_seqno = ''
          LET l_qty = 0
          CASE 
             #收貨
             WHEN g_ibj.ibj11="abat170" OR g_ibj.ibj11="wmbt170"
                #DEV-D30046 --mark--str 
                #LET g_sql = "SELECT rvb02,rvb07-SUM(ibj05) ",
                #            "  FROM ibj_file,ibb_file,rvb_file",
                #            " WHERE ibj06 = rvb01 ",
                #            "   AND ibj07 = rvb02 ", 
                #            "   AND ibj02 = ibb01 ",
                #            "   AND ibj01 = '1' ",
                #            "   AND ibj06 = '",g_ibj.ibj06,"'",
                #            "   AND ibb06 = '",l_ibb06,"'",
                #            "   AND ibj03 = '",g_ibj.ibj03,"'",
                #            "   AND ibj04 = '",g_ibj.ibj04,"'",
                #            " GROUP BY rvb02,rvb04,rvb07 ",    
                #            " HAVING (rvb07-SUM(ibj05)) > 0 "  
                #DEV-D30046 --mark--end 
                #DEV-D30046 --add--str 
                LET g_sql = "SELECT rvb02,rvb07 ",
                            "  FROM rvb_file ",
                            " WHERE rvb01 = '",g_ibj.ibj06,"'",
                            "   AND rvb05 = '",l_ibb06,"'",
                            "   AND rvb36 = '",g_ibj.ibj03,"'",
                            "   AND rvb37 = '",g_ibj.ibj04,"'" 
                #DEV-D30046 --add--end 
                CASE g_ibd.ibd08
                   WHEN '1' #單據項次
                      LET g_sql = g_sql CLIPPED," ORDER BY rvb02"
                   WHEN '2' #單據來源單號 
                      LET g_sql = g_sql CLIPPED," ORDER BY rvb04"
                END CASE  
             #出通
             WHEN g_ibj.ibj11="abat163" OR g_ibj.ibj11="wmbt163"
                #DEV-D30046 --mark--str
                #LET g_sql = "SELECT ogb03,ogb12-SUM(ibj05) ", 
                #            "  FROM ibj_file,ibb_file,ogb_file",
                #            " WHERE ibj06 = ogb01 ",
                #            "   AND ibj07 = ogb03 ",  
                #            "   AND ibj02 = ibb01 ",
                #            "   AND ibj01 = '1' ",
                #            "   AND ibj06 = '",g_ibj.ibj06,"'",
                #            "   AND ibb06 = '",l_ibb06,"'",
                #            "   AND ibj03 = '",g_ibj.ibj03,"'",
                #            "   AND ibj04 = '",g_ibj.ibj04,"'",
                #            " GROUP BY ogb03,ogb31,ogb12 ",   
                #            " HAVING (ogb12-SUM(ibj05)) > 0 " 
                #DEV-D30046 --mark--end 
                #DEV-D30046 --add--str 
                LET g_sql = "SELECT ogb03,ogb12 ", 
                            "  FROM ogb_file",
                            " WHERE ogb01 = '",g_ibj.ibj06,"'",
                            "   AND ogb04 = '",l_ibb06,"'",
                            "   AND ogb09 = '",g_ibj.ibj03,"'",
                            "   AND ogb091 = '",g_ibj.ibj04,"'" 
                #DEV-D30046 --add--end 
                CASE g_ibd.ibd08
                   WHEN '1' #單據項次
                      LET g_sql = g_sql CLIPPED," ORDER BY ogb03"
                   WHEN '2' #單據來源單號 
                      LET g_sql = g_sql CLIPPED," ORDER BY ogb31"
                END CASE  
          END CASE 
          DECLARE ibj_seq_cs CURSOR FROM g_sql
           
          LET l_ibj05_t = g_ibj.ibj05   #DEV-D30046 --add
          FOREACH ibj_seq_cs INTO l_seqno,l_qty  
             IF SQLCA.SQLCODE THEN 
                IF g_bgerr THEN
                   CALL s_errmsg('','','foreach ibj_seq_no:',SQLCA.SQLCODE,1)
                ELSE
                    CALL cl_err('foreach ibj_seq_no:',SQLCA.SQLCODE,1) 
                END IF
                LET g_success='N'
                RETURN
             END IF
               
             IF cl_null(l_qty) THEN LET l_qty = 0 END IF 
               
             #DEV-D30046 --add--str
             LET l_ibj05 = 0
             SELECT SUM(ibj05) INTO l_ibj05 FROM ibj_file
              WHERE ibj01 = '1' 
                AND ibj06 = g_ibj.ibj06
                AND ibj07 = l_seqno
                AND ibj03 = g_ibj.ibj03
                AND ibj04 = g_ibj.ibj04
                AND ibj11 = g_ibj.ibj11
                AND EXISTS (SELECT UNIQUE ibb06 FROM ibb_file 
                             WHERE ibb01 = ibj02 AND ibb06 = l_ibb06)
             IF cl_null(l_ibj05) THEN LET l_ibj05 = 0 END IF  
             #DEV-D30046 --add--end
             
             INITIALIZE l_ibj.* TO NULL
             LET l_ibj.* = g_ibj.*
              
             #DEV-D30046 --add--str
             IF (l_qty-l_ibj05) = 0 THEN 
                CONTINUE FOREACH 
             END IF  
             #DEV-D30046 --add--end
             
             #DEV-D30046 --mark--str
             #IF l_qty < g_ibj.ibj05 THEN 
             #   LET l_ibj.ibj05 = l_qty
             #END IF  
             #DEV-D30046 --mark--end
             
             #DEV-D30046 --add--str
             IF (l_qty-l_ibj05) < l_ibj05_t THEN 
                LET l_ibj.ibj05 = l_qty-l_ibj05
             ELSE 
                LET l_ibj.ibj05 = l_ibj05_t
             END IF  
             #DEV-D30046 --add--end
               
             LET l_ibj.ibj07 = l_seqno
             LET l_ibj.ibj15 = l_ibj15
              
             INSERT INTO ibj_file VALUES (l_ibj.*)
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                IF g_bgerr THEN
                   CALL s_errmsg('ibj12',g_ibj.ibj12,'s_ibj:ins ibj',SQLCA.SQLCODE,1)
                ELSE
                    CALL cl_err3("ins","ibj_file",g_ibj.ibj02,"",SQLCA.SQLCODE,"","",1) 
                END IF
                LET g_success='N'
                RETURN
             #DEV-D30046 --add--str
             ELSE 
                LET l_ibj05_t = l_ibj05_t - l_ibj.ibj05
                IF l_ibj05_t > 0 THEN 
                   CONTINUE FOREACH
                ELSE 
                   EXIT FOREACH 
                END IF 
             END IF
             #DEV-D30046 --add--end
          END FOREACH 
          
          DELETE FROM ibj_file 
           WHERE ibj01 = g_ibj.ibj01
             AND ibj02 = g_ibj.ibj02
             AND ibj03 = g_ibj.ibj03
             AND ibj04 = g_ibj.ibj04
             AND ibj05 = g_ibj.ibj05
             AND ibj06 = g_ibj.ibj06
             AND ibj10 = g_ibj.ibj10
             AND ibj11 = g_ibj.ibj11
             AND ibj12 = g_ibj.ibj12
             AND ibj13 = g_ibj.ibj13
             AND ibj14 = g_ibj.ibj14
             AND ibj15 = g_ibj.ibj15
             AND ibj16 = g_ibj.ibj16
             AND ibjlegal = g_ibj.ibjlegal
             AND ibjplant = g_ibj.ibjplant
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
             IF g_bgerr THEN
                CALL s_errmsg('ibj12',g_ibj.ibj12,'s_ibj:ins ibj',SQLCA.SQLCODE,1)
             ELSE
                 CALL cl_err3("ins","ibj_file",g_ibj.ibj02,"",SQLCA.SQLCODE,"","",1) 
             END IF
             LET g_success='N'
             RETURN
          END IF
       END IF  
       
       LET g_ibj.ibj15 = l_ibj15
       
       UPDATE ibj_file SET ibj15 = l_ibj15
        WHERE ibj06 = g_ibj.ibj06
          AND ibj11 = g_ibj.ibj11
       IF SQLCA.SQLCODE THEN
          IF g_bgerr THEN
             CALL s_errmsg('ibj12',g_ibj.ibj12,'s_ibj:upd ibj',SQLCA.SQLCODE,1)
          ELSE
              CALL cl_err3("upd","ibj_file",g_ibj.ibj02,"",SQLCA.SQLCODE,"","",1) 
          END IF
          LET g_success='N'
          RETURN
       END IF
    END IF 
    #DEV-D30047 --add--end
END FUNCTION
#DEV-D10013 add end------------------------------

#DEV-D10021 add str------------------------------
#-----------------------------------
#功能：檢查是否有欠料數量需進行分配
#傳入參數：發料單據編號
#回傳參數：布林值(TRUE/FALSE)
#-----------------------------------
FUNCTION s_chkibj(p_argv1) 
   DEFINE l_cnt    LIKE  type_file.num5
   DEFINE p_argv1  LIKE  type_file.chr20

   LET g_argv1 = p_argv1

   SELECT COUNT(*) 				
     INTO l_cnt				
     FROM ibj_file  				
    WHERE ibj01 = '2'      #發料掃描作業				
      AND ibj06 = g_argv1  #過濾本張發料單				
      AND ibj10 = 'N'      #未進行分配	

   IF l_cnt > 0 THEN
      RETURN TRUE
   ELSE
      RETURN FALSE
   END IF
END FUNCTION
#DEV-D10021 add end------------------------------
#DEV-D30025--add


