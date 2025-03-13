# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: saemp200.4gl
# Descriptions...: 設備管理系統成本更新作業    
# Date & Author..: 04/07/28 By Elva   
# Modify.........: No.MOD-590421 05/09/27 By Sarah UPDATE後加上判斷STATUS OR SQLCA.SQLERRD[3]=0
# Modify.........: No.FUN-680072 06/08/25 By zdyllq 類型轉換
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A10010 10/02/05 By Smapmin 用fiw11回寫tlf21
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.CHI-B60093 11/06/30 By JoHung 依成本計算類別取得該料的成本

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_fiv    RECORD LIKE fiv_file.*,
    g_fiw    RECORD LIKE fiw_file.*,
    tm       RECORD                                                  
             yy     LIKE type_file.num5,   #No.FUN-680072SMALLINT            
             mm     LIKE type_file.num5,   #No.FUN-680072SMALLINT   #CHI-B60093 add ,
             type   LIKE type_file.chr1    #CHI-B60093 add
             END RECORD,
    g_chr    LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
    g_sql    STRING,                                                #No.FUN-580092 HCN
    g_flag   LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
    g_cnt    LIKE type_file.num5           #No.FUN-680072SMALLINT
 
#FUNCTION p200(p_argv1,p_argv2,p_argv3,p_argv4)          #CHI-B60093 mark
FUNCTION p200(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5)   #CHI-B60093
DEFINE p_argv1  RECORD LIKE fiv_file.*,
       p_argv2  RECORD LIKE fiw_file.*,
       p_argv3  LIKE type_file.num5,       #No.FUN-680072SMALLINT
       p_argv4  LIKE type_file.num5        #No.FUN-680072SMALLINT 
DEFINE p_argv5  LIKE type_file.chr1        #CHI-B60093 add
 
    IF cl_null(p_argv1.fiv01) OR cl_null(p_argv2.fiw02) THEN
       CALL cl_err('parameter error',SQLCA.sqlcode,0)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
    END IF
    LET g_fiv.*=p_argv1.*
    LET g_fiw.*=p_argv2.*
    LET tm.yy = p_argv3
    LET tm.mm = p_argv4
    LET tm.type = p_argv5    #CHI-B60093 add
    CALL p200_fiw_1(g_fiv.*,g_fiw.*)                                            
    IF g_success = 'N' THEN RETURN END IF                                       
    SELECT * INTO g_fiv.* FROM fiv_file WHERE fiv01=g_fiv.fiv01 
    SELECT * INTO g_fiw.* FROM fiw_file WHERE fiw01=g_fiw.fiw01 AND fiw02=g_fiw.fiw02
END FUNCTION
 
FUNCTION p200_fiw_1(p_fiv,p_fiw)
DEFINE   p_fiv    RECORD LIKE fiv_file.*,
         p_fiw    RECORD LIKE fiw_file.*,
         l_ccc23  LIKE ccc_file.ccc23,
         l_ima25  LIKE ima_file.ima25,
         l_fac    LIKE pml_file.pml09   #No.FUN-680072DEC(16,8)

#CHI-B60093 -- begin --
DEFINE   l_ccc08  LIKE ccc_file.ccc08

            CASE tm.type
               WHEN '1'  LET l_ccc08 = ' '
               WHEN '2'  LET l_ccc08 = ' '
               WHEN '3'  LET l_ccc08 = p_fiw.fiw06 
               WHEN '4'  LET l_ccc08 = ' '
               WHEN '5' 
                  SELECT imd09 INTO l_ccc08 FROM imd_file
                     WHERE imd01=p_fiw.fiw04
            END CASE 
#CHI-B60093 -- end --

#           SELECT ccc23 INTO l_ccc23 FROM ccc_file        #CHI-B60093 mark
            SELECT AVG(ccc23) INTO l_ccc23 FROM ccc_file   #CHI-B60093
             WHERE ccc01 = p_fiw.fiw03
               AND ccc02 = tm.yy
               AND ccc03 = tm.mm
#              AND ccc07 = '1'          #No.FUN-840041     #CHI-B60093 mark
               AND ccc07 = tm.type                         #CHI-B60093
               AND ccc08 = l_ccc08                         #CHI-B60093 add
             GROUP BY ccc01

            IF cl_null(l_ccc23) THEN LET l_ccc23 = 0 END IF
            SELECT ima25 INTO l_ima25 FROM ima_file                
             WHERE ima01 = p_fiw.fiw03
            LET l_fac = 1                                                  
            CALL s_umfchk(p_fiw.fiw03,p_fiw.fiw07,l_ima25)          
                 RETURNING g_cnt,l_fac                              
            IF g_cnt=1 THEN                                                   
               CALL cl_err('','abm-731',0)                                    
               LET l_fac = 1                                                  
            END IF 
            LET p_fiw.fiw10 = l_ccc23 * l_fac
            LET p_fiw.fiw11 = p_fiw.fiw10 * p_fiw.fiw08
            IF cl_null(p_fiw.fiw10) THEN LET p_fiw.fiw10 = 0 END IF
            IF cl_null(p_fiw.fiw11) THEN LET p_fiw.fiw11 = 0 END IF
            UPDATE fiw_file SET fiw10=p_fiw.fiw10,fiw11=p_fiw.fiw11
             WHERE fiw01 = p_fiw.fiw01
               AND fiw02 = p_fiw.fiw02
           #start MOD-590421
           #IF SQLCA.sqlcode THEN
            #   CALL cl_err('update fiw_1',SQLCA.sqlcode,0)  
           #   LET g_success = 'N' RETURN
           #END IF
            IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#              CALL cl_err('upd fiw',STATUS,1)  #No.FUN-660092
               CALL cl_err3("upd","fiw_file",p_fiw.fiw01,p_fiw.fiw02,STATUS,"","upd fiw",1)  #No.FUN-660092
               LET g_success='N' RETURN
            END IF
           #end MOD-590421
   
            CASE p_fiv.fiv00 
                 WHEN '1' UPDATE tlf_file set tlf21 = p_fiw.fiw11 ,   #CHI-A10010 fiw10-->fiw11
                          tlf221 = p_fiw.fiw11
                          WHERE tlf026=p_fiw.fiw01 AND tlf027=p_fiw.fiw02
                 WHEN '2' UPDATE tlf_file set tlf21 = p_fiw.fiw11 ,   #CHI-A10010 fiw10-->fiw11
                          tlf221 = p_fiw.fiw11
                          WHERE tlf036=p_fiw.fiw01 AND tlf037=p_fiw.fiw02
            END CASE
           #start MOD-590421
            IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err('upd tlf21',STATUS,1)
               LET g_success='N' RETURN
            END IF
           #end MOD-590421
END FUNCTION
 
