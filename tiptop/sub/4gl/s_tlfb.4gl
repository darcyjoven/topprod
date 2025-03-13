# Prog. Version..: '5.30.06-13.04.24(00004)'     #
#
# Program name...: s_tlfb.4gl
# Descriptions...: 將条码異動資料放入条码異動記錄檔中(製造管理)
# Date & Author..: No:DEV-CA0011 2012/10/29 By TSD.JIE #KEY沒值會幫忙預設
# Usage..........: CALL s_tlfb(p_argv1,p_argv2,p_argv3,p_argv4,p_plant)
# Input Parameter: p_argv1   备用   
#                  p_argv2   备用 
#                  p_argv3   备用 
#                  p_argv4   备用 
#                  p_plant   异动营运中心
# Return Code....: None
# Modify.........: No.DEV-D30025 2013/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---
# Modify.........: No:DEV-D30047 13/04/12 By TSD.sophy 掃描後將數量分配至項次
# Modify.........: No:WEB-D40011 13/04/19 By Mandy 新增tlfb19 扣帳資料否
# Modify.........: No:DEV-D30046 13/04/19 By TSD.sophy 調整SQL錯誤
# Modify.........: No:DEV-D40019 13/04/23 By TSD.sophy 調整產生tlfb_file邏輯錯誤


DATABASE ds
 
GLOBALS "../../config/top.global" 
GLOBALS "../../aba/4gl/barcode.global"
 
DEFINE   g_chr           LIKE type_file.chr1  
DEFINE   g_i             LIKE type_file.num5  
DEFINE   g_sql           STRING
DEFINE   g_argv1         LIKE type_file.chr10
DEFINE   g_argv2         LIKE type_file.chr10 
DEFINE   g_argv3         LIKE type_file.chr50
DEFINE   g_argv4         LIKE type_file.num10
DEFINE   g_plant_new     LIKE type_file.chr10 
DEFINE   g_legal_new     LIKE type_file.chr10

FUNCTION s_tlfb(p_argv1,p_argv2,p_argv3,p_argv4,p_plant_new)
    DEFINE p_argv1  LIKE  type_file.chr10
    DEFINE p_argv2  LIKE  type_file.chr10
    DEFINE p_argv3  LIKE  type_file.chr50
    DEFINE p_argv4  LIKE  type_file.num10
    DEFINE p_plant_new  LIKE  type_file.chr10     #营运中心
    DEFINE l_slip   LIKE  type_file.chr10         #流水号中的日期(YYYYMMDD)
    #DEV-D30047 --add--begin
    DEFINE l_ibb06  LIKE ibb_file.ibb06
    DEFINE l_count  LIKE type_file.num10
    DEFINE l_seqno  LIKE type_file.num10
    DEFINE l_qty    LIKE tlfb_file.tlfb05
    DEFINE l_tlfb   RECORD LIKE tlfb_file.*
    DEFINE l_smyb03 LIKE smyb_file.smyb03
    DEFINE l_t1     LIKE smy_file.smyslip
    DEFINE l_tlfb15 LIKE tlfb_file.tlfb15
    #DEV-D30047 --add--end
    #DEV-D30046 --add--str
    DEFINE l_tlfb05 LIKE tlfb_file.tlfb05
    DEFINE l_tlfb05_t LIKE tlfb_file.tlfb05
    DEFINE l_ins_flag LIKE type_file.chr1
    DEFINE l_cnt      LIKE type_File.num10
    #DEV-D30046 --add--end
    #DEV-D40019 --add--str 
    DEFINE l_tlfb02   LIKE tlfb_file.tlfb02
    DEFINE l_tlfb03   LIKE tlfb_file.tlfb03
    #DEV-D40019 --add--end 
 
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

    IF cl_null(g_tlfb.tlfb03) THEN
       LET g_tlfb.tlfb03 =  ' '
    END IF 
    IF cl_null(g_tlfb.tlfb04) THEN
       LET g_tlfb.tlfb04 =  ' '
    END IF 
    
  #异动数量为负，则将数量调为正，异动类型取反
    IF g_tlfb.tlfb05 < 0 THEN 
       LET g_tlfb.tlfb05 = -1 * g_tlfb.tlfb05
       LET g_tlfb.tlfb06 = -1 * g_tlfb.tlfb06
    END IF   

    #No:DEV-CA0011--add--begin  #KEY 所以沒值就這裡預設
    IF cl_null(g_tlfb.tlfb11) THEN
       LET g_tlfb.tlfb11 = g_prog
    END IF
    IF cl_null(g_tlfb.tlfb12) THEN
       LET g_tlfb.tlfb12 = FGL_GETPID()
    END IF
    IF cl_null(g_tlfb.tlfb13) THEN
       LET g_tlfb.tlfb13 = g_user
    END IF
    IF cl_null(g_tlfb.tlfb14) THEN
       LET g_tlfb.tlfb14 = TODAY
    END IF
    IF cl_null(g_tlfb.tlfb15) THEN
       LET g_tlfb.tlfb15 = CURRENT HOUR TO FRACTION(3)
    END IF
    IF cl_null(g_tlfb.tlfb16) THEN
       LET g_tlfb.tlfb16 = cl_used_ap_hostname() #AP Server
    END IF
    #No:DEV-CA0011--add--end

    #No:WEB-D40011--add--str
    IF cl_null(g_tlfb.tlfb19) THEN
       LET g_tlfb.tlfb19 = 'Y'
    END IF
    #No:WEB-D40011--add--end

    LET g_tlfb.tlfbuser = g_user 
    LET g_tlfb.tlfbgrup = g_grup
    LET g_tlfb.tlfbplant = g_plant_new
    LET g_tlfb.tlfblegal = g_legal_new
    
   #No:DEV-CA0011--mark--begin
   #SELECT TO_CHAR(SYSDATE,'yyyymmdd') INTO l_slip FROM DUAL
   #
   #LET g_sql = "SELECT TO_CHAR(MAX(tlfb12)+1) FROM ",
   #             cl_get_target_table(g_plant_new,'tlfb_file'),
   #            " WHERE tlfb11 = '",g_tlfb.tlfb11,"' ",
   #            "   AND tlfb12 LIKE '",l_slip,"%' "
   #PREPARE get_sn FROM g_sql
   #EXECUTE get_sn INTO g_tlfb.tlfb12
   #IF cl_null(g_tlfb.tlfb12) THEN 
   #   LET g_tlfb.tlfb12 = l_slip,'0000000001'
   #END IF 
   #No:DEV-CA0011--mark--end

    #DEV-D40019 --add--str
    #調撥塞中介倉部分，因在塞撥出撥入倉時已同時塞中介倉資料，
    #故先讓倉儲給空白，避免刪除到之前已塞入的中介資料。
    LET l_tlfb02 = g_tlfb.tlfb02  
    LET l_tlfb03 = g_tlfb.tlfb03  
    IF g_tlfb.tlfb11="abat151" OR g_tlfb.tlfb11="wmbt151" OR 
       g_tlfb.tlfb11="abat153" OR g_tlfb.tlfb11="wmbt153" THEN 
       IF g_tlfb.tlfb06 = 1 THEN  
          LET g_tlfb.tlfb02 = ' '  
          LET g_tlfb.tlfb03 = ' '  
       END IF 
    END IF  
    IF g_tlfb.tlfb11="abat152" OR g_tlfb.tlfb11="wmbt152" OR 
       g_tlfb.tlfb11="abat154" OR g_tlfb.tlfb11="wmbt154" THEN 
       IF g_tlfb.tlfb06 = -1 THEN  
          LET g_tlfb.tlfb02 = ' '  
          LET g_tlfb.tlfb03 = ' '  
       END IF 
    END IF 
    #DEV-D40019 --add--end
    
    LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'tlfb_file'),
                " (tlfb01,tlfb02,tlfb03,tlfb04,tlfb05, ",
                "  tlfb06,tlfb07,tlfb08,tlfb09,tlfb10,tlfb11, ",
                "  tlfb12,tlfb13,tlfb14,tlfb15,tlfb16,tlfb17, ",
                "  tlfb18,                                    ",
                "  tlfb19, ",   #WEB-D40011 add
                "  tlfbuser,tlfbgrup,tlfbplant,tlfblegal)     ",
                "VALUES(?,?,?,?,?,  ?,?,?,?,?,    ",
                "       ?,?,?,?,?,  ?,?,?,?,?,    ",
                "       ?,?,?    )                "  #WEB-D40011 add ?
    PREPARE ins_prep FROM g_sql
    EXECUTE ins_prep USING 
          g_tlfb.tlfb01,g_tlfb.tlfb02,
          g_tlfb.tlfb03,g_tlfb.tlfb04,g_tlfb.tlfb05,g_tlfb.tlfb06,
          g_tlfb.tlfb07,g_tlfb.tlfb08,g_tlfb.tlfb09,g_tlfb.tlfb10,
          g_tlfb.tlfb11,g_tlfb.tlfb12,g_tlfb.tlfb13,g_tlfb.tlfb14,
          g_tlfb.tlfb15,g_tlfb.tlfb16,g_tlfb.tlfb17,g_tlfb.tlfb18,
          g_tlfb.tlfb19,   #WEB-D40011 add
          g_tlfb.tlfbuser,g_tlfb.tlfbgrup,g_tlfb.tlfbplant,g_tlfb.tlfblegal
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
       IF g_bgerr THEN
          CALL s_errmsg('tlfb12',g_tlfb.tlfb12,'s_tlfb:ins tlfb',STATUS,1)
       ELSE
           CALL cl_err3("ins","tlfb_file",g_tlfb.tlfb01,"",STATUS,"","",1) 
       END IF
       LET g_success='N'
       RETURN
    END IF

    #DEV-D30047 --add--begin
    LET l_tlfb15 = CURRENT HOUR TO FRACTION(3)
       
    IF cl_null(g_tlfb.tlfb08) THEN 
       SELECT * INTO g_ibd.* FROM ibd_file WHERE ibd01 = '0' 
        
       #依據條碼編號，取出料件編號(ibb06)
       LET l_ibb06 = ''
       LET g_sql = "SELECT ibb06 FROM ibb_file WHERE ibb01 = ? "
       DECLARE get_itemno_cs SCROLL CURSOR FROM g_sql
       OPEN get_itemno_cs USING g_tlfb.tlfb01
       FETCH FIRST get_itemno_cs INTO l_ibb06
       CLOSE get_itemno_cs  
 
       #單別設定直接調撥時是否做上/下架流程
       LET l_t1 = s_get_doc_no(g_tlfb.tlfb07)
       LET l_smyb03 = ''
       SELECT smyb03 INTO l_smyb03 FROM smyb_file
        WHERE smybslip = l_t1
       IF cl_null(l_smyb03) THEN LET l_smyb03 = 'N' END IF
       
       #==================================
       #依據該筆條碼資料的來源單號(tlfb07)+倉庫(tlfb02)+儲位(tlfb03)+料號(ibb06)，
       #找出對應table的資料筆數。
       #1.若資料筆數=1，則直接update單據項次欄位(tlfb_file)
       #2.若資料筆數>1，則SQL依據abas010的排序方式，取出單據單身項次，
       #  新增掃描異動記錄檔(tlfb_file)，新增後刪除原掃描資料。
       #==================================
 
       LET l_count = 0  
       CASE 
          #發料、退料
          WHEN g_tlfb.tlfb11="abat021" OR g_tlfb.tlfb11="wmbt021" OR
               g_tlfb.tlfb11="abat123" OR g_tlfb.tlfb11="wmbt123" 
             SELECT COUNT(*) INTO l_count FROM sfs_file
              WHERE sfs01 = g_tlfb.tlfb07
                AND sfs04 = l_ibb06
                AND sfs07 = g_tlfb.tlfb02
                AND sfs08 = g_tlfb.tlfb03
 
          #完工入庫
          WHEN g_tlfb.tlfb11="abat122" OR g_tlfb.tlfb11="wmbt122" 
             SELECT COUNT(*) INTO l_count FROM sfv_file
              WHERE sfv01 = g_tlfb.tlfb07
                AND sfv04 = l_ibb06
                AND sfv05 = g_tlfb.tlfb02
                AND sfv06 = g_tlfb.tlfb03
         
          #出貨
          WHEN g_tlfb.tlfb11="abat161" OR g_tlfb.tlfb11="wmbt161" 
             SELECT COUNT(*) INTO l_count FROM ogb_file 
              WHERE ogb01 = g_tlfb.tlfb07
                AND ogb04 = l_ibb06
                AND ogb09 = g_tlfb.tlfb02
                AND ogb091 = g_tlfb.tlfb03
          
          #銷退
          WHEN g_tlfb.tlfb11="abat164" OR g_tlfb.tlfb11="wmbt164" 
             SELECT COUNT(*) INTO l_count FROM ohb_file
              WHERE ohb01 = g_tlfb.tlfb07
                AND ohb04 = l_ibb06
                AND ohb09 = g_tlfb.tlfb02
                AND ohb091 = g_tlfb.tlfb03
 
          #雜收、雜發
          WHEN g_tlfb.tlfb11="abat132" OR g_tlfb.tlfb11="wmbt132" OR 
               g_tlfb.tlfb11="abat131" OR g_tlfb.tlfb11="wmbt131" 
             SELECT COUNT(*) INTO l_count FROM inb_file
              WHERE inb01 = g_tlfb.tlfb07
                AND inb04 = l_ibb06
                AND inb05 = g_tlfb.tlfb02
                AND inb06 = g_tlfb.tlfb03
           
          #採購入庫、採購驗退
          WHEN g_tlfb.tlfb11="abat171" OR g_tlfb.tlfb11="wmbt171" OR
               g_tlfb.tlfb11="abat172" OR g_tlfb.tlfb11="wmbt172" 
             SELECT COUNT(*) INTO l_count FROM rvv_file 
              WHERE rvv01 = g_tlfb.tlfb07
                AND rvv31 = l_ibb06
                AND rvv32 = g_tlfb.tlfb02
                AND rvv33 = g_tlfb.tlfb03
          
          #直接調撥-撥出
          WHEN g_tlfb.tlfb11="abat151" OR g_tlfb.tlfb11="wmbt151" 
             IF g_tlfb.tlfb06 = -1 THEN 
                SELECT COUNT(*) INTO l_count FROM imn_file 
                 WHERE imn01 = g_tlfb.tlfb07
                   AND imn03 = l_ibb06
                   AND imn04 = g_tlfb.tlfb02
                   AND imn05 = g_tlfb.tlfb03
             ELSE 
                #DEV-D40019 --mark--str
                #IF l_smyb03 = 'Y' THEN
                #   #中介倉 
                #   SELECT COUNT(*) INTO l_count FROM imn_file
                #    WHERE imn01 = g_tlfb.tlfb07
                #      AND imn03 = l_ibb06
                #END IF 
                #DEV-D40019 --mark--end
             END IF 
           
          #直接調撥-撥入
          WHEN g_tlfb.tlfb11="abat152" OR g_tlfb.tlfb11="wmbt152" 
             IF g_tlfb.tlfb06 = 1 THEN 
                SELECT COUNT(*) INTO l_count FROM imn_file 
                 WHERE imn01 = g_tlfb.tlfb07
                   AND imn03 = l_ibb06
                   AND imn15 = g_tlfb.tlfb02
                   AND imn16 = g_tlfb.tlfb03
             ELSE 
                #DEV-D40019 --mark--str
                #IF l_smyb03 = 'Y' THEN 
                #   #中介倉
                #   SELECT COUNT(*) INTO l_count FROM imn_file
                #    WHERE imn01 = g_tlfb.tlfb07
                #      AND imn03 = l_ibb06
                #END IF   
                #DEV-D40019 --mark--end
             END IF 
          
          #兩階段調撥-撥出
          WHEN g_tlfb.tlfb11="abat153" OR g_tlfb.tlfb11="wmbt153" 
             IF g_tlfb.tlfb06 = -1 THEN 
                SELECT COUNT(*) INTO l_count FROM imn_file 
                 WHERE imn01 = g_tlfb.tlfb07
                   AND imn03 = l_ibb06
                   AND imn04 = g_tlfb.tlfb02
                   AND imn05 = g_tlfb.tlfb03
             ELSE 
                #DEV-D40019 --mark--str
                ##在途倉
                #SELECT COUNT(*) INTO l_count FROM imn_file 
                # WHERE imn01 = g_tlfb.tlfb07
                #   AND imn03 = l_ibb06
                #DEV-D40019 --mark--end
             END IF 
          
          #兩階段調撥-撥入
          WHEN g_tlfb.tlfb11="abat154" OR g_tlfb.tlfb11="wmbt154" 
             IF g_tlfb.tlfb06 = 1 THEN 
                SELECT COUNT(*) INTO l_count FROM imn_file 
                 WHERE imn01 = g_tlfb.tlfb07
                   AND imn03 = l_ibb06
                   AND imn15 = g_tlfb.tlfb02
                   AND imn16 = g_tlfb.tlfb03
             ELSE 
                #DEV-D40019 --mark--str
                ##在途倉
                #SELECT COUNT(*) INTO l_count FROM imn_file 
                # WHERE imn01 = g_tlfb.tlfb07
                #   AND imn03 = l_ibb06
                #DEV-D40019 --mark--end
             END IF 
       END CASE 
       IF cl_null(l_count) THEN LET l_count = 0 END IF 
 
       IF l_count=1 THEN 
          LET l_seqno = ''
          CASE 
             #發料、退料
             WHEN g_tlfb.tlfb11="abat021" OR g_tlfb.tlfb11="wmbt021" OR
                  g_tlfb.tlfb11="abat123" OR g_tlfb.tlfb11="wmbt123" 
                SELECT sfs02 INTO l_seqno FROM sfs_file
                 WHERE sfs01 = g_tlfb.tlfb07
                   AND sfs04 = l_ibb06
                   AND sfs07 = g_tlfb.tlfb02
                   AND sfs08 = g_tlfb.tlfb03
           
             #完工入庫
             WHEN g_tlfb.tlfb11="abat122" OR g_tlfb.tlfb11="wmbt122" 
                SELECT sfv03 INTO l_seqno FROM sfv_file
                 WHERE sfv01 = g_tlfb.tlfb07
                   AND sfv04 = l_ibb06
                   AND sfv05 = g_tlfb.tlfb02
                   AND sfv06 = g_tlfb.tlfb03
            
             #出貨
             WHEN g_tlfb.tlfb11="abat161" OR g_tlfb.tlfb11="wmbt161" 
                SELECT ogb03 INTO l_seqno FROM ogb_file 
                 WHERE ogb01 = g_tlfb.tlfb07
                   AND ogb04 = l_ibb06
                   AND ogb09 = g_tlfb.tlfb02
                   AND ogb091 = g_tlfb.tlfb03
             
             #銷退
             WHEN g_tlfb.tlfb11="abat164" OR g_tlfb.tlfb11="wmbt164" 
                SELECT ohb03 INTO l_seqno FROM ohb_file
                 WHERE ohb01 = g_tlfb.tlfb07
                   AND ohb04 = l_ibb06
                   AND ohb09 = g_tlfb.tlfb02
                   AND ohb091 = g_tlfb.tlfb03
           
             #雜收、雜發
             WHEN g_tlfb.tlfb11="abat132" OR g_tlfb.tlfb11="wmbt132" OR 
                  g_tlfb.tlfb11="abat131" OR g_tlfb.tlfb11="wmbt131" 
                SELECT inb03 INTO l_seqno FROM inb_file
                 WHERE inb01 = g_tlfb.tlfb07
                   AND inb04 = l_ibb06
                   AND inb05 = g_tlfb.tlfb02
                   AND inb06 = g_tlfb.tlfb03
              
             #採購入庫、採購驗退
             WHEN g_tlfb.tlfb11="abat171" OR g_tlfb.tlfb11="wmbt171" OR
                  g_tlfb.tlfb11="abat172" OR g_tlfb.tlfb11="wmbt172" 
                SELECT rvv02 INTO l_seqno FROM rvv_file 
                 WHERE rvv01 = g_tlfb.tlfb07
                   AND rvv31 = l_ibb06
                   AND rvv32 = g_tlfb.tlfb02
                   AND rvv33 = g_tlfb.tlfb03
             
             #直接調撥-撥出
             WHEN g_tlfb.tlfb11="abat151" OR g_tlfb.tlfb11="wmbt151" 
                IF g_tlfb.tlfb06 = -1 THEN 
                   SELECT imn02 INTO l_seqno FROM imn_file 
                    WHERE imn01 = g_tlfb.tlfb07
                      AND imn03 = l_ibb06
                      AND imn04 = g_tlfb.tlfb02
                      AND imn05 = g_tlfb.tlfb03
                END IF 
              
             #直接調撥-撥入
             WHEN g_tlfb.tlfb11="abat152" OR g_tlfb.tlfb11="wmbt152" 
                IF g_tlfb.tlfb06 = 1 THEN 
                   SELECT imn02 INTO l_seqno FROM imn_file 
                    WHERE imn01 = g_tlfb.tlfb07
                      AND imn03 = l_ibb06
                      AND imn15 = g_tlfb.tlfb02
                      AND imn16 = g_tlfb.tlfb03
                END IF 
             
             #兩階段調撥-撥出
             WHEN g_tlfb.tlfb11="abat153" OR g_tlfb.tlfb11="wmbt153" 
                IF g_tlfb.tlfb06 = -1 THEN 
                   SELECT imn02 INTO l_seqno FROM imn_file 
                    WHERE imn01 = g_tlfb.tlfb07
                      AND imn03 = l_ibb06
                      AND imn04 = g_tlfb.tlfb02
                      AND imn05 = g_tlfb.tlfb03
                END IF 
             
             #兩階段調撥-撥入
             WHEN g_tlfb.tlfb11="abat154" OR g_tlfb.tlfb11="wmbt154" 
                IF g_tlfb.tlfb06 = 1 THEN 
                   SELECT imn02 INTO l_seqno FROM imn_file 
                    WHERE imn01 = g_tlfb.tlfb07
                      AND imn03 = l_ibb06
                      AND imn15 = g_tlfb.tlfb02
                      AND imn16 = g_tlfb.tlfb03
                END IF 
          END CASE 
          
          #DEV-D30046 --mark--str
          #UPDATE tlfb_file SET tlfb08 = l_seqno
          # WHERE tlfb01 = g_tlfb.tlfb01
          #   AND tlfb02 = g_tlfb.tlfb02
          #   AND tlfb03 = g_tlfb.tlfb03
          #   AND tlfb04 = g_tlfb.tlfb04
          #   AND tlfb05 = g_tlfb.tlfb05
          #   AND tlfb06 = g_tlfb.tlfb06
          #   AND tlfb07 = g_tlfb.tlfb07
          #   AND tlfb11 = g_tlfb.tlfb11
          #   AND tlfb13 = g_tlfb.tlfb13
          #   AND tlfb14 = g_tlfb.tlfb14
          #   AND tlfb15 = g_tlfb.tlfb15
          #   AND tlfb16 = g_tlfb.tlfb16
          #   AND tlfblegal = g_tlfb.tlfblegal
          #   AND tlfbplant = g_tlfb.tlfbplant
          #DEV-D30046 --mark--end
          #DEV-D30046 --add--str
          INITIALIZE l_tlfb.* TO NULL
          LET l_tlfb.* = g_tlfb.*
          LET l_tlfb.tlfb08 = l_seqno
          LET l_tlfb.tlfb15 = l_tlfb15
          #DEV-D40019 --mark--str
          #IF g_tlfb.tlfb11="abat153" OR g_tlfb.tlfb11="wmbt153" THEN 
          #   LET l_tlfb.tlfb19 = 'N' 
          #END IF 
          #DEV-D40019 --mark--str
          INSERT INTO tlfb_file VALUES (l_tlfb.*)
          #DEV-D30046 --add--end
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
             IF g_bgerr THEN
                CALL s_errmsg('tlfb12',g_tlfb.tlfb12,'s_tlfb:upd tlfb',SQLCA.SQLCODE,1)
             ELSE
                 CALL cl_err3("upd","tlfb_file",g_tlfb.tlfb01,"",SQLCA.SQLCODE,"","",1) 
             END IF
             LET g_success='N'
             RETURN
          #DEV-D30046 --add--str
          ELSE 
             IF g_tlfb.tlfb11="abat151" OR g_tlfb.tlfb11="wmbt151" OR 
                g_tlfb.tlfb11="abat152" OR g_tlfb.tlfb11="wmbt152" OR 
                g_tlfb.tlfb11="abat153" OR g_tlfb.tlfb11="wmbt153" OR
                g_tlfb.tlfb11="abat154" OR g_tlfb.tlfb11="wmbt154" THEN 
                LET l_ins_flag = 'N' 
                INITIALIZE l_tlfb.* TO NULL
                LET l_tlfb.* = g_tlfb.*
                LET l_tlfb.tlfb08 = l_seqno
                LET l_tlfb.tlfb15 = l_tlfb15
                CASE 
                   #直接調撥-撥出
                   WHEN g_tlfb.tlfb11="abat151" OR g_tlfb.tlfb11="wmbt151" 
                      IF l_smyb03 = 'Y' THEN 
                         LET l_ins_flag = 'Y'
                         LET l_tlfb.tlfb02 = l_t1 
                         LET l_tlfb.tlfb03 = ' ' 
                         LET l_tlfb.tlfb06 = 1
                         LET l_tlfb.tlfb19 = 'N'
                      END IF 
                   #直接調撥-撥入
                   WHEN g_tlfb.tlfb11="abat152" OR g_tlfb.tlfb11="wmbt152" 
                      IF l_smyb03 = 'Y' THEN 
                         LET l_ins_flag = 'Y'
                         LET l_tlfb.tlfb02 = l_t1
                         LET l_tlfb.tlfb03 = ' '
                         LET l_tlfb.tlfb06 = -1
                         LET l_tlfb.tlfb19 = 'N'
                      ELSE 
                         LET l_ins_flag = 'Y'
                         SELECT imn04,imn05 
                           INTO l_tlfb.tlfb02,l_tlfb.tlfb03
                           FROM imn_file 
                          WHERE imn01 = l_tlfb.tlfb07
                            AND imn02 = l_tlfb.tlfb08
                         LET l_tlfb.tlfb06 = -1
                         LET l_tlfb.tlfb19 = 'N'
                      END IF 
                   #兩階段調撥-撥出
                   WHEN g_tlfb.tlfb11="abat153" OR g_tlfb.tlfb11="wmbt153" 
                      LET l_ins_flag = 'Y'
                      SELECT imm08 INTO l_tlfb.tlfb02
                        FROM imm_file
                       WHERE imm01 = l_tlfb.tlfb07
                      LET l_tlfb.tlfb03 = ' '
                      LET l_tlfb.tlfb06 = 1
                      LET l_tlfb.tlfb19 = 'N'
                   #兩階段調撥-撥入
                   WHEN g_tlfb.tlfb11="abat154" OR g_tlfb.tlfb11="wmbt154" 
                      LET l_ins_flag = 'Y'
                      SELECT imm08 INTO l_tlfb.tlfb02
                        FROM imm_file
                       WHERE imm01 = l_tlfb.tlfb07
                      LET l_tlfb.tlfb03 = ' '
                      LET l_tlfb.tlfb06 = -1
                      LET l_tlfb.tlfb19 = 'N'
                END CASE    
                IF l_ins_flag = 'Y' THEN 
                   INSERT INTO tlfb_file VALUES (l_tlfb.*)
                   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                      IF g_bgerr THEN
                         CALL s_errmsg('tlfb12',g_tlfb.tlfb12,'s_tlfb:ins tlfb',SQLCA.SQLCODE,1)
                      ELSE
                          CALL cl_err3("ins","tlfb_file",g_tlfb.tlfb01,"",SQLCA.SQLCODE,"","",1) 
                      END IF
                      LET g_success='N'
                      RETURN
                   ELSE
                      IF g_tlfb.tlfb11="abat152" OR g_tlfb.tlfb11="wmbt152"  THEN  
                         IF l_smyb03 = 'N' THEN  #不使用上/下架流程
                            LET l_cnt = 0
                            SELECT COUNT(*) INTO l_cnt FROM imgb_file
                             WHERE imgb01 = l_tlfb.tlfb01
                               AND imgb02 = l_tlfb.tlfb02 
                               AND imgb03 = l_tlfb.tlfb03
                               AND imgb04 = l_tlfb.tlfb04
                            IF l_cnt = 0 THEN #没有imgb_file，新增imgb_file
                               CALL s_ins_imgb(l_tlfb.tlfb01,
                                               l_tlfb.tlfb02,l_tlfb.tlfb03,l_tlfb.tlfb04,
                                               0,'','') 
                            END IF   
                            IF g_success = 'Y' THEN
                               CALL s_up_imgb(l_tlfb.tlfb01,
                                              l_tlfb.tlfb02,l_tlfb.tlfb03,l_tlfb.tlfb04,
                                              l_tlfb.tlfb05,l_tlfb.tlfb06,'')
                            END IF
                         END IF  
                      END IF 
                   END IF 
                END IF 
             END IF  
          #DEV-D30046 --add--end
          END IF  
       ELSE
          LET l_seqno = ''
          LET l_qty = 0 
          CASE 
             #發料、退料
             WHEN g_tlfb.tlfb11="abat021" OR g_tlfb.tlfb11="wmbt021" OR
                  g_tlfb.tlfb11="abat123" OR g_tlfb.tlfb11="wmbt123" 
                #DEV-D30046 --mark--str
                #LET g_sql = "SELECT sfs02,(sfs05-SUM(tlfb05)) ", 
                #            "  FROM tlfb_file,ibb_file,sfs_file ",
                #            " WHERE tlfb07 = sfs01 ",
                #            "   AND tlfb08 = sfs02 ",
                #            "   AND tlfb01 = ibb01 ",
                #            "   AND tlfb07 = '",g_tlfb.tlfb07,"'",
                #            "   AND ibb06 = '",l_ibb06,"'",
                #            "   AND tlfb02 = '",g_tlfb.tlfb02,"'",
                #            "   AND tlfb03 = '",g_tlfb.tlfb03,"'",
                #            " GROUP BY sfs02,sfs03,sfs05 ",
                #            " HAVING (sfs05-SUM(tlfb05)) > 0 "
                #DEV-D30046 --mark--end
                #DEV-D30046 --add--str
                LET g_sql = "SELECT sfs02,sfs05 ", 
                            "  FROM sfs_file ",
                            " WHERE sfs01 = '",g_tlfb.tlfb07,"'",
                            "   AND sfs05 = '",l_ibb06,"'",
                            "   AND sfs07 = '",g_tlfb.tlfb02,"'",
                            "   AND sfs08 = '",g_tlfb.tlfb03,"'" 
                #DEV-D30046 --add--end
                CASE g_ibd.ibd08
                   WHEN '1'   #單據項次
                      LET g_sql = g_sql CLIPPED," ORDER BY sfs02"
                   WHEN '2'   #單據的來源單號 
                      LET g_sql = g_sql CLIPPED," ORDER BY sfs03"
                END CASE             
                
             #完工入庫
             WHEN g_tlfb.tlfb11="abat122" OR g_tlfb.tlfb11="wmbt122" 
                #DEV-D30046 --mark--str
                #LET g_sql = "SELECT sfv03,(sfv09-SUM(tlfb05)) ",  
                #            "  FROM tlfb_file,ibb_file,sfv_file ",
                #            " WHERE tlfb07 = sfv01 ",
                #            "   AND tlfb08 = sfv03 ",
                #            "   AND tlfb01 = ibb01 ", 
                #            "   AND tlfb07 = '",g_tlfb.tlfb07,"'",
                #            "   AND ibb06 = '",l_ibb06,"'",
                #            "   AND tlfb02 = '",g_tlfb.tlfb02,"'",
                #            "   AND tlfb03 = '",g_tlfb.tlfb03,"'",
                #            " GROUP BY sfv03,sfv11,sfv09 ", 
                #            " HAVING (sfv09-SUM(tlfb05)) > 0 "
                #DEV-D30046 --mark--end
                #DEV-D30046 --add--str
                LET g_sql = "SELECT sfv03,sfv09 ",  
                            "  FROM sfv_file ",
                            " WHERE sfv01 = '",g_tlfb.tlfb07,"'",
                            "   AND sfv04 = '",l_ibb06,"'",
                            "   AND sfv05 = '",g_tlfb.tlfb02,"'",
                            "   AND sfv06 = '",g_tlfb.tlfb03,"'" 
                #DEV-D30046 --add--end
                CASE g_ibd.ibd08
                   WHEN '1'   #單據項次
                      LET g_sql = g_sql CLIPPED," ORDER BY sfv03"
                   WHEN '2'   #單據的來源單號 
                      LET g_sql = g_sql CLIPPED," ORDER BY sfv11"
                END CASE             
            
             #出貨
             WHEN g_tlfb.tlfb11="abat161" OR g_tlfb.tlfb11="wmbt161" 
                #DEV-D30046 --mark--str
                #LET g_sql = "SELECT ogb03,(ogb12-SUM(tlfb05)) ",  
                #            "  FROM tlfb_file,ibb_file,ogb_file ",
                #            " WHERE tlfb07 = ogb01 ",
                #            "   AND tlfb08 = ogb03 ",
                #            "   AND tlfb01 = ibb01 ", 
                #            "   AND tlfb07 = '",g_tlfb.tlfb07,"'",
                #            "   AND ibb06 = '",l_ibb06,"'",
                #            "   AND tlfb02 = '",g_tlfb.tlfb02,"'",
                #            "   AND tlfb03 = '",g_tlfb.tlfb03,"'",
                #            " GROUP BY ogb03,ogb31,ogb12 ", 
                #            " HAVING (ogb12-SUM(tlfb05)) > 0 "
                #DEV-D30046 --mark--end
                #DEV-D30046 --add--str
                LET g_sql = "SELECT ogb03,ogb12 ",  
                            "  FROM ogb_file ",
                            " WHERE ogb01 = '",g_tlfb.tlfb07,"'",
                            "   AND ogb04 = '",l_ibb06,"'",
                            "   AND ogb09 = '",g_tlfb.tlfb02,"'",
                            "   AND ogb091 = '",g_tlfb.tlfb03,"'" 
                #DEV-D30046 --add--str
                CASE g_ibd.ibd08
                   WHEN '1'   #單據項次
                      LET g_sql = g_sql CLIPPED," ORDER BY ogb03"
                   WHEN '2'   #單據的來源單號 
                      LET g_sql = g_sql CLIPPED," ORDER BY ogb31"
                END CASE             
             
             #銷退
             WHEN g_tlfb.tlfb11="abat164" OR g_tlfb.tlfb11="wmbt164" 
                #DEV-D30046 --mark--str
                #LET g_sql = "SELECT ohb03,(ohb12-SUM(tlfb05)) ", 
                #            "  FROM tlfb_file,ibb_file,ohb_file ",
                #            " WHERE tlfb07 = ohb01 ",
                #            "   AND tlfb08 = ohb03 ",
                #            "   AND tlfb01 = ibb01 ", 
                #            "   AND tlfb07 = '",g_tlfb.tlfb07,"'",
                #            "   AND ibb06 = '",l_ibb06,"'",
                #            "   AND tlfb02 = '",g_tlfb.tlfb02,"'",
                #            "   AND tlfb03 = '",g_tlfb.tlfb03,"'",
                #            " GROUP BY ohb03,ohb31,ohb12 ", 
                #            " HAVING (ohb12-SUM(tlfb05)) > 0 "
                #DEV-D30046 --mark--end
                #DEV-D30046 --add--str
                LET g_sql = "SELECT ohb03,ohb12 ", 
                            "  FROM ohb_file ",
                            " WHERE ohb01 = '",g_tlfb.tlfb07,"'",
                            "   AND ohb04 = '",l_ibb06,"'",
                            "   AND ohb09 = '",g_tlfb.tlfb02,"'",
                            "   AND ohb091 = '",g_tlfb.tlfb03,"'" 
                #DEV-D30046 --add--end
                CASE g_ibd.ibd08
                   WHEN '1'   #單據項次
                      LET g_sql = g_sql CLIPPED," ORDER BY ohb03"
                   WHEN '2'   #單據的來源單號 
                      LET g_sql = g_sql CLIPPED," ORDER BY ohb31"
                END CASE             
        
             #雜收、雜發
             WHEN g_tlfb.tlfb11="abat132" OR g_tlfb.tlfb11="wmbt132" OR 
                  g_tlfb.tlfb11="abat131" OR g_tlfb.tlfb11="wmbt131" 
                #DEV-D30046 --mark--str
                #LET g_sql = "SELECT inb03,(inb16-SUM(tlfb05)) ",  
                #            "  FROM tlfb_file,ibb_file,inb_file ",
                #            " WHERE tlfb07 = inb01 ",
                #            "   AND tlfb08 = inb03 ",
                #            "   AND tlfb01 = ibb01 ", 
                #            "   AND tlfb07 = '",g_tlfb.tlfb07,"'",
                #            "   AND ibb06 = '",l_ibb06,"'",
                #            "   AND tlfb02 = '",g_tlfb.tlfb02,"'",
                #            "   AND tlfb03 = '",g_tlfb.tlfb03,"'",
                #            " GROUP BY inb03,inb44,inb16 ", 
                #            " HAVING (inb16-SUM(tlfb05)) > 0 "
                #DEV-D30046 --mark--end
                #DEV-D30046 --add--str
                LET g_sql = "SELECT inb03,inb16 ",  
                            "  FROM inb_file ",
                            " WHERE inb01 = '",g_tlfb.tlfb07,"'",
                            "   AND inb04 = '",l_ibb06,"'",
                            "   AND inb05 = '",g_tlfb.tlfb02,"'",
                            "   AND inb06 = '",g_tlfb.tlfb03,"'" 
                #DEV-D30046 --add--end
                CASE g_ibd.ibd08
                   WHEN '1'   #單據項次
                      LET g_sql = g_sql CLIPPED," ORDER BY inb03"
                   WHEN '2'   #單據的來源單號 
                      LET g_sql = g_sql CLIPPED," ORDER BY inb44"
                END CASE             
              
             #採購入庫、採購驗退
             WHEN g_tlfb.tlfb11="abat171" OR g_tlfb.tlfb11="wmbt171" OR
                  g_tlfb.tlfb11="abat172" OR g_tlfb.tlfb11="wmbt172" 
                #DEV-D30046 --mark--str
                #LET g_sql = "SELECT rvv02,(rvv17-SUM(tlfb05)) ", 
                #            "  FROM tlfb_file,ibb_file,rvv_file ",
                #            " WHERE tlfb07 = rvv01 ",
                #            "   AND tlfb08 = rvv02 ",
                #            "   AND tlfb01 = ibb01 ", 
                #            "   AND tlfb07 = '",g_tlfb.tlfb07,"'",
                #            "   AND ibb06 = '",l_ibb06,"'",
                #            "   AND tlfb02 = '",g_tlfb.tlfb02,"'",
                #            "   AND tlfb03 = '",g_tlfb.tlfb03,"'",
                #            " GROUP BY rvv02,rvv04,rvv17 ", 
                #            " HAVING (rvv17-SUM(tlfb05)) > 0 "
                #DEV-D30046 --mark--end
                #DEV-D30046 --add--str
                LET g_sql = "SELECT rvv02,rvv17 ", 
                            "  FROM rvv_file ",
                            " WHERE rvv01 = '",g_tlfb.tlfb07,"'",
                            "   AND rvv31 = '",l_ibb06,"'",
                            "   AND rvv32 = '",g_tlfb.tlfb02,"'",
                            "   AND rvv33 = '",g_tlfb.tlfb03,"'" 
                #DEV-D30046 --add--end
                CASE g_ibd.ibd08
                   WHEN '1'   #單據項次
                      LET g_sql = g_sql CLIPPED," ORDER BY rvv02"
                   WHEN '2'   #單據的來源單號 
                      LET g_sql = g_sql CLIPPED," ORDER BY rvv04"
                END CASE             
             
             #直接調撥-撥出
             WHEN g_tlfb.tlfb11="abat151" OR g_tlfb.tlfb11="wmbt151" 
                #DEV-D30046 --mark--str
                #LET g_sql = "SELECT imn02,(imn10-SUM(tlfb05)) ", 
                #            "  FROM tlfb_file,ibb_file,imn_file ",
                #            " WHERE tlfb07 = imn01 ",
                #            "   AND tlfb08 = imn02 ",
                #            "   AND tlfb01 = ibb01 ", 
                #            "   AND tlfb07 = '",g_tlfb.tlfb07,"'",
                #            "   AND ibb06 = '",l_ibb06,"'",
                #            "   AND tlfb02 = '",g_tlfb.tlfb02,"'",
                #            "   AND tlfb03 = '",g_tlfb.tlfb03,"'",
                #            "   AND tlfb06 = '",g_tlfb.tlfb06,"'",
                #            " GROUP BY imn02,imn10 ", 
                #            " HAVING (imn10-SUM(tlfb05)) > 0 ",
                #            " ORDER BY imn02"
                #DEV-D30046 --mark--end
                #DEV-D30046 --add--str
                LET g_sql = "SELECT imn02,imn10 ", 
                            "  FROM imn_file ",
                            " WHERE imn01 = '",g_tlfb.tlfb07,"'",
                            "   AND imn03 = '",l_ibb06,"'",
                            "   AND imn04 = '",g_tlfb.tlfb02,"'",
                            "   AND imn05 = '",g_tlfb.tlfb03,"'",
                            " ORDER BY imn02"
                #DEV-D30046 --add--end
              
             #直接調撥-撥入
             WHEN g_tlfb.tlfb11="abat152" OR g_tlfb.tlfb11="wmbt152" 
                #DEV-D30046 --mark--str
                #LET g_sql = "SELECT imn02,(imn22-SUM(tlfb05)) ", 
                #            "  FROM tlfb_file,ibb_file,imn_file ",
                #            " WHERE tlfb07 = imn01 ",
                #            "   AND tlfb08 = imn02 ",
                #            "   AND tlfb01 = ibb01 ", 
                #            "   AND tlfb07 = '",g_tlfb.tlfb07,"'",
                #            "   AND ibb06 = '",l_ibb06,"'",
                #            "   AND tlfb02 = '",g_tlfb.tlfb02,"'",
                #            "   AND tlfb03 = '",g_tlfb.tlfb03,"'",
                #            "   AND tlfb06 = '",g_tlfb.tlfb06,"'",
                #            " GROUP BY imn02,imn22 ", 
                #            " HAVING (imn22-SUM(tlfb05)) > 0 ",
                #            " ORDER BY imn02"
                #DEV-D30046 --mark--end
                #DEV-D30046 --add--str
                LET g_sql = "SELECT imn02,imn22 ", 
                            "  FROM imn_file ",
                            " WHERE imn01 = '",g_tlfb.tlfb07,"'",
                            "   AND imn03 = '",l_ibb06,"'",
                            "   AND imn15 = '",g_tlfb.tlfb02,"'",
                            "   AND imn16 = '",g_tlfb.tlfb03,"'",
                            " ORDER BY imn02"
                #DEV-D30046 --add--end
                
             #兩階段調撥-撥出
             WHEN g_tlfb.tlfb11="abat153" OR g_tlfb.tlfb11="wmbt153" 
                #DEV-D30046 --mark--str
                #LET g_sql = "SELECT imn02,(imn10-SUM(tlfb05)) ",  
                #            "  FROM tlfb_file,ibb_file,imn_file ",
                #            " WHERE tlfb07 = imn01 ",
                #            "   AND tlfb08 = imn02 ",
                #            "   AND tlfb01 = ibb01 ", 
                #            "   AND tlfb07 = '",g_tlfb.tlfb07,"'",
                #            "   AND ibb06 = '",l_ibb06,"'",
                #            "   AND tlfb02 = '",g_tlfb.tlfb02,"'",
                #            "   AND tlfb03 = '",g_tlfb.tlfb03,"'",
                #            "   AND tlfb06 = '",g_tlfb.tlfb06,"'",
                #            " GROUP BY imn02,imn10 ",  
                #            " HAVING (imn10-SUM(tlfb05)) > 0 ",
                #            " ORDER BY imn02"
                #DEV-D30046 --mark--end
                #DEV-D30046 --add--str
                LET g_sql = "SELECT imn02,imn10 ", 
                            "  FROM imn_file ",
                            " WHERE imn01 = '",g_tlfb.tlfb07,"'",
                            "   AND imn03 = '",l_ibb06,"'",
                            "   AND imn04 = '",g_tlfb.tlfb02,"'",
                            "   AND imn05 = '",g_tlfb.tlfb03,"'",
                            " ORDER BY imn02"
                #DEV-D30046 --add--end
             
             #兩階段調撥-撥入
             WHEN g_tlfb.tlfb11="abat154" OR g_tlfb.tlfb11="wmbt154" 
                #DEV-D30046 --mark--str
                #LET g_sql = "SELECT imn02,(imn22-SUM(tlfb05)) ", 
                #            "  FROM tlfb_file,ibb_file,imn_file ",
                #            " WHERE tlfb07 = imn01 ",
                #            "   AND tlfb08 = imn02 ",
                #            "   AND tlfb01 = ibb01 ", 
                #            "   AND tlfb07 = '",g_tlfb.tlfb07,"'",
                #            "   AND ibb06 = '",l_ibb06,"'",
                #            "   AND tlfb02 = '",g_tlfb.tlfb02,"'",
                #            "   AND tlfb03 = '",g_tlfb.tlfb03,"'",
                #            "   AND tlfb06 = '",g_tlfb.tlfb06,"'",
                #            " GROUP BY imn02,imn22 ",  
                #            " HAVING (imn22-SUM(tlfb05)) > 0 ",
                #            " ORDER BY imn02"
                #DEV-D30046 --mark--end
                #DEV-D30046 --add--str
                LET g_sql = "SELECT imn02,imn22 ", 
                            "  FROM imn_file ",
                            " WHERE imn01 = '",g_tlfb.tlfb07,"'",
                            "   AND imn03 = '",l_ibb06,"'",
                            "   AND imn15 = '",g_tlfb.tlfb02,"'",
                            "   AND imn16 = '",g_tlfb.tlfb03,"'",
                            " ORDER BY imn02"
                #DEV-D30046 --add--end
          END CASE 
          DECLARE tlfb_seq_cs CURSOR FROM g_sql
          
          LET l_tlfb05_t = g_tlfb.tlfb05   #DEV-D30046 --add
          FOREACH tlfb_seq_cs INTO l_seqno,l_qty 
             IF SQLCA.SQLCODE THEN 
                IF g_bgerr THEN
                   CALL s_errmsg('','','foreach tlfb_seq_no:',SQLCA.SQLCODE,1)
                ELSE
                    CALL cl_err('foreach tlfb_seq_no:',SQLCA.SQLCODE,1) 
                END IF
                LET g_success='N'
                RETURN
             END IF 
               
             IF cl_null(l_qty) THEN LET l_qty = 0 END IF 
              
             #DEV-D30046 --add--str
             LET l_tlfb05 = 0
             SELECT SUM(tlfb05) INTO l_tlfb05 FROM tlfb_file
              WHERE tlfb07 = g_tlfb.tlfb07
                AND tlfb08 = l_seqno
                AND tlfb02 = g_tlfb.tlfb02
                AND tlfb03 = g_tlfb.tlfb03
                AND tlfb11 = g_tlfb.tlfb11
                AND tlfb06 = g_tlfb.tlfb06
                AND EXISTS (SELECT UNIQUE ibb06 FROM ibb_file
                             WHERE ibb01 = tlfb01 AND ibb06 = l_ibb06)
             IF cl_null(l_tlfb05) THEN LET l_tlfb05 = 0 END IF
             #DEV-D30046 --add--end
             
             INITIALIZE l_tlfb.* TO NULL
             LET l_tlfb.* = g_tlfb.*
              
             #DEV-D30046 --add--str
             IF (l_qty-l_tlfb05) = 0 THEN
                CONTINUE FOREACH
             END IF
             #DEV-D30046 --add--end
             
             #DEV-D30046 --mark--str
             #IF l_qty < g_tlfb.tlfb05 THEN 
             #   LET l_tlfb.tlfb05 = l_qty
             #END IF 
             #DEV-D30046 --mark--str
             
             #DEV-D30046 --add--str
             IF (l_qty-l_tlfb05) < l_tlfb05_t THEN
                LET l_tlfb.tlfb05 = l_qty-l_tlfb05
             ELSE  
                LET l_tlfb.tlfb05 = l_tlfb05_t
             END IF
             #DEV-D30046 --add--end
              
             LET l_tlfb.tlfb08 = l_seqno
             LET l_tlfb.tlfb15 = l_tlfb15
             #DEV-D40019 --mark--str
             ##DEV-D30046 --add--str
             #IF g_tlfb.tlfb11="abat153" OR g_tlfb.tlfb11="wmbt153" THEN 
             #   LET l_tlfb.tlfb19 = 'N' 
             #END IF 
             ##DEV-D30046 --add--end
             #DEV-D40019 --mark--end
               
             INSERT INTO tlfb_file VALUES (l_tlfb.*)
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                IF g_bgerr THEN
                   CALL s_errmsg('tlfb12',g_tlfb.tlfb12,'s_tlfb:ins tlfb',SQLCA.SQLCODE,1)
                ELSE
                    CALL cl_err3("ins","tlfb_file",g_tlfb.tlfb01,"",SQLCA.SQLCODE,"","",1) 
                END IF
                LET g_success='N'
                RETURN
             #DEV-D30046 --add--str
             ELSE
                IF g_tlfb.tlfb11="abat151" OR g_tlfb.tlfb11="wmbt151" OR 
                   g_tlfb.tlfb11="abat152" OR g_tlfb.tlfb11="wmbt152" OR 
                   g_tlfb.tlfb11="abat153" OR g_tlfb.tlfb11="wmbt153" OR
                   g_tlfb.tlfb11="abat154" OR g_tlfb.tlfb11="wmbt154" THEN 
                   LET l_ins_flag = 'N' 
                   CASE 
                      #直接調撥-撥出
                      WHEN g_tlfb.tlfb11="abat151" OR g_tlfb.tlfb11="wmbt151" 
                         IF l_smyb03 = 'Y' THEN 
                            LET l_ins_flag = 'Y'
                            LET l_tlfb.tlfb02 = l_t1 
                            LET l_tlfb.tlfb03 = ' ' 
                            LET l_tlfb.tlfb06 = 1
                            LET l_tlfb.tlfb19 = 'N'
                         END IF 
                      #直接調撥-撥入
                      WHEN g_tlfb.tlfb11="abat152" OR g_tlfb.tlfb11="wmbt152" 
                         IF l_smyb03 = 'Y' THEN 
                            LET l_ins_flag = 'Y'
                            LET l_tlfb.tlfb02 = l_t1
                            LET l_tlfb.tlfb03 = ' '
                            LET l_tlfb.tlfb06 = -1
                            LET l_tlfb.tlfb19 = 'N'
                         ELSE 
                            LET l_ins_flag = 'Y'
                            SELECT imn04,imn05 
                              INTO l_tlfb.tlfb02,l_tlfb.tlfb03
                              FROM imn_file 
                             WHERE imn01 = l_tlfb.tlfb07
                               AND imn02 = l_tlfb.tlfb08
                            LET l_tlfb.tlfb06 = -1
                            LET l_tlfb.tlfb19 = 'N'
                         END IF 
                      #兩階段調撥-撥出
                      WHEN g_tlfb.tlfb11="abat153" OR g_tlfb.tlfb11="wmbt153" 
                         LET l_ins_flag = 'Y'
                         SELECT imm08 INTO l_tlfb.tlfb02
                           FROM imm_file
                          WHERE imm01 = l_tlfb.tlfb07
                         LET l_tlfb.tlfb03 = ' '
                         LET l_tlfb.tlfb06 = 1
                         LET l_tlfb.tlfb19 = 'N'
                      #兩階段調撥-撥入
                      WHEN g_tlfb.tlfb11="abat154" OR g_tlfb.tlfb11="wmbt154" 
                         LET l_ins_flag = 'Y'
                         SELECT imm08 INTO l_tlfb.tlfb02
                           FROM imm_file
                          WHERE imm01 = l_tlfb.tlfb07
                         LET l_tlfb.tlfb03 = ' '
                         LET l_tlfb.tlfb06 = -1
                         LET l_tlfb.tlfb19 = 'N'
                   END CASE    
                   IF l_ins_flag = 'Y' THEN 
                      INSERT INTO tlfb_file VALUES (l_tlfb.*)
                      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                         IF g_bgerr THEN
                            CALL s_errmsg('tlfb12',g_tlfb.tlfb12,'s_tlfb:ins tlfb',SQLCA.SQLCODE,1)
                         ELSE
                             CALL cl_err3("ins","tlfb_file",g_tlfb.tlfb01,"",SQLCA.SQLCODE,"","",1) 
                         END IF
                         LET g_success='N'
                         RETURN
                      ELSE 
                         IF g_tlfb.tlfb11="abat152" OR g_tlfb.tlfb11="wmbt152"  THEN 
                            IF l_smyb03 = 'N' THEN  #不使用上/下架流程
                               LET l_cnt = 0
                               SELECT COUNT(*) INTO l_cnt FROM imgb_file
                                WHERE imgb01 = l_tlfb.tlfb01
                                  AND imgb02 = l_tlfb.tlfb02 
                                  AND imgb03 = l_tlfb.tlfb03
                                  AND imgb04 = l_tlfb.tlfb04
                               IF l_cnt = 0 THEN #没有imgb_file，新增imgb_file
                                  CALL s_ins_imgb(l_tlfb.tlfb01,
                                                  l_tlfb.tlfb02,l_tlfb.tlfb03,l_tlfb.tlfb04,
                                                  0,'','') 
                               END IF   
                               IF g_success = 'Y' THEN
                                  CALL s_up_imgb(l_tlfb.tlfb01,
                                                 l_tlfb.tlfb02,l_tlfb.tlfb03,l_tlfb.tlfb04,
                                                 l_tlfb.tlfb05,l_tlfb.tlfb06,'')
                               END IF
                            END IF  
                         END IF 
                      END IF 
                   END IF 
                END IF  
                 
                LET l_tlfb05_t = l_tlfb05_t - l_tlfb.tlfb05
                IF l_tlfb05_t > 0 THEN
                   CONTINUE FOREACH
                ELSE
                   EXIT FOREACH
                END IF
             #DEV-D30046 --add--end
             END IF
          END FOREACH 
          
          #DEV-D30046 --mark--str
          #DELETE FROM tlfb_file 
          # WHERE tlfb01 = g_tlfb.tlfb01
          #   AND tlfb02 = g_tlfb.tlfb02
          #   AND tlfb03 = g_tlfb.tlfb03
          #   AND tlfb04 = g_tlfb.tlfb04
          #   AND tlfb05 = g_tlfb.tlfb05
          #   AND tlfb06 = g_tlfb.tlfb06
          #   AND tlfb07 = g_tlfb.tlfb07
          #   AND tlfb11 = g_tlfb.tlfb11
          #   AND tlfb13 = g_tlfb.tlfb13
          #   AND tlfb14 = g_tlfb.tlfb14
          #   AND tlfb15 = g_tlfb.tlfb15
          #   AND tlfb16 = g_tlfb.tlfb16
          #   AND tlfblegal = g_tlfb.tlfblegal
          #   AND tlfbplant = g_tlfb.tlfbplant
          #IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          #   IF g_bgerr THEN
          #      CALL s_errmsg('tlfb12',g_tlfb.tlfb12,'s_tlfb:del tlfb',SQLCA.SQLCODE,1)
          #   ELSE
          #       CALL cl_err3("del","tlfb_file",g_tlfb.tlfb01,"",SQLCA.SQLCODE,"","",1) 
          #   END IF
          #   LET g_success='N'
          #   RETURN
          #END IF
          #DEV-D30046 --mark--str
       END IF 
         
       #DEV-D30046 --add--str 
       DELETE FROM tlfb_file 
        WHERE tlfb01 = g_tlfb.tlfb01
          AND tlfb02 = g_tlfb.tlfb02
          AND tlfb03 = g_tlfb.tlfb03
          AND tlfb04 = g_tlfb.tlfb04
          AND tlfb05 = g_tlfb.tlfb05
          AND tlfb06 = g_tlfb.tlfb06
          AND tlfb07 = g_tlfb.tlfb07
          AND tlfb11 = g_tlfb.tlfb11
          AND tlfb13 = g_tlfb.tlfb13
          AND tlfb14 = g_tlfb.tlfb14
          AND tlfb15 = g_tlfb.tlfb15
          AND tlfb16 = g_tlfb.tlfb16
          AND tlfblegal = g_tlfb.tlfblegal
          AND tlfbplant = g_tlfb.tlfbplant
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          IF g_bgerr THEN
             CALL s_errmsg('tlfb12',g_tlfb.tlfb12,'s_tlfb:del tlfb',SQLCA.SQLCODE,1)
          ELSE
              CALL cl_err3("del","tlfb_file",g_tlfb.tlfb01,"",SQLCA.SQLCODE,"","",1) 
          END IF
          LET g_success='N'
          RETURN
       END IF
       #DEV-D30046 --add--end 
       
       LET g_tlfb.tlfb15 = l_tlfb15
       
       UPDATE tlfb_file SET tlfb15 = l_tlfb15
        WHERE tlfb07 = g_tlfb.tlfb07
          AND tlfb11 = g_tlfb.tlfb11
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          IF g_bgerr THEN
             CALL s_errmsg('tlfb12',g_tlfb.tlfb12,'s_tlfb:upd tlfb',SQLCA.SQLCODE,1)
          ELSE
              CALL cl_err3("upd","tlfb_file",g_tlfb.tlfb01,"",SQLCA.SQLCODE,"","",1) 
          END IF
          LET g_success='N'
          RETURN
       END IF
       #DEV-D30047 --add--end
         
       #DEV-D40019 --add--str 
       #還原倉儲資料，供後續imgb_file更新用
       LET g_tlfb.tlfb02 = l_tlfb02
       LET g_tlfb.tlfb03 = l_tlfb03
       #DEV-D40019 --add--end 
    END IF 
END FUNCTION
#DEV-CA0011
#DEV-D30025--add

