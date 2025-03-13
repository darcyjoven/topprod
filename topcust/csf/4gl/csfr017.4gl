# Prog. Version..:
#
# Pattern name...: csfr017.4gl
# Descriptions...: ????????
# Date & Author..: darcy:2024/12/18
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD                               
              wc      LIKE type_file.chr1000,      
              more    LIKE type_file.chr1          
              END RECORD  
 
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_i             LIKE type_file.num5       
DEFINE   g_msg           LIKE type_file.chr1000   
 
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql =  "sfb01.sfb_file.sfb01,",
                "line.type_file.num10,",
                "b_docno.type_file.chr100,",
                "b_dat.type_file.dat,",
                "b_tim.type_file.chr20,",
                "b_post.type_file.chr20,",
                "b_gen02.gen_file.gen02,",
                "b_crt.type_file.chr20,",
                "b_gen2.gen_file.gen02,",
                "c_docno.type_file.chr100,",
                "c_dat.type_file.dat,",
                "c_tim.type_file.chr20,",
                "c_post.type_file.chr20,",
                "c_gen02.gen_file.gen02,",
                "c_crt.type_file.chr20,",
                "c_gen2.gen_file.gen02,",
                "d_docno.type_file.chr100,",
                "d_dat.type_file.dat,",
                "d_tim.type_file.chr20,",
                "d_post.type_file.chr20,",
                "d_gen02.gen_file.gen02,",
                "d_crt.type_file.chr20,",
                "d_gen2.gen_file.gen02,",
                "e_docno.type_file.chr100,",
                "e_dat.type_file.dat,",
                "e_tim.type_file.chr20,",
                "e_post.type_file.chr20,",
                "e_gen02.gen_file.gen02,",
                "e_crt.type_file.chr20,",
                "e_gen2.gen_file.gen02,",
                "f_docno.type_file.chr100,",
                "f_dat.type_file.dat,",
                "f_tim.type_file.chr20,",
                "f_post.type_file.chr20,",
                "f_gen02.gen_file.gen02,",
                "f_crt.type_file.chr20,",
                "f_gen2.gen_file.gen02"             

   LET  l_table = cl_prt_temptable('csfr017',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"                     
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

    call csfr017_crt_tmp()
 
   INITIALIZE tm.* TO NULL 
   
   IF cl_null(tm.wc)
      THEN CALL csfr017_tm(0,0)          
      ELSE
           CALL csfr017()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION csfr017_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW csfr017_w AT p_row,p_col WITH FORM "csf/42f/csfr017"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON sfb01,sfb81,sfb05,sfb04
     
        BEFORE CONSTRUCT
            CALL cl_qbe_init() 
 
        ON ACTION locale 
            CALL cl_show_fld_cont()                    
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(sfb01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_sfb"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sfu01
                    NEXT FIELD sfb01

                WHEN INFIELD(sfb05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ima18"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sfb05
                    NEXT FIELD sfb05

               OTHERWISE
                  EXIT CASE
           END CASE
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         
         ON ACTION qbe_select
            CALL cl_qbe_select() 
    END CONSTRUCT
    IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
    END IF
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW csfr017_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM 
    END IF
    IF tm.wc=" 1=1" THEN
        CALL cl_err('','9046',0) CONTINUE WHILE
    END IF 
    
    CALL cl_wait()
    CALL csfr017()
    ERROR ""
END WHILE
   CLOSE WINDOW csfr017_w
END FUNCTION

FUNCTION csfr017()
    DEFINE l_name    LIKE type_file.chr20,
          l_sql     STRING ,
          l_za05    LIKE type_file.chr1000,
          l_zo041   LIKE zo_file.zo041,
          l_zo042   LIKE zo_file.zo042,
          l_zo05    LIKE zo_file.zo05,
          l_zo09    LIKE zo_file.zo09,
          sr        RECORD
            sfb01   varchar(40),
            line    integer,
            b_docno like type_file.chr100,
            b_dat   like type_file.dat,
            b_tim   like type_file.chr20,
            b_post  like type_file.chr20,
            b_gen02 like gen_file.gen02,
            b_crt   like type_file.chr20,
            b_gen2  like gen_file.gen02,
            c_docno like type_file.chr100,
            c_dat   like type_file.dat,
            c_tim   like type_file.chr20,
            c_post  like type_file.chr20,
            c_gen02 like gen_file.gen02,
            c_crt   like type_file.chr20,
            c_gen2  like gen_file.gen02,
            d_docno like type_file.chr100,
            d_dat   like type_file.dat,
            d_tim   like type_file.chr20,
            d_post  like type_file.chr20,
            d_gen02 like gen_file.gen02,
            d_crt   like type_file.chr20,
            d_gen2  like gen_file.gen02,
            e_docno like type_file.chr100,
            e_dat   like type_file.dat,
            e_tim   like type_file.chr20,
            e_post  like type_file.chr20,
            e_gen02 like gen_file.gen02,
            e_crt   like type_file.chr20,
            e_gen2  like gen_file.gen02,
            f_docno like type_file.chr100,
            f_dat   like type_file.dat,
            f_tim   like type_file.chr20,
            f_post  like type_file.chr20,
            f_gen02 like gen_file.gen02,
            f_crt   like type_file.chr20,
            f_gen2  like gen_file.gen02
                    END RECORD
    DEFINE l_cnt     LIKE type_file.num5       

    DEFINE l_img_blob     LIKE type_file.blob      
    CALL cl_del_data(l_table)  
    
    delete from csfr017_sfb
    delete from csfr017_doc
    LET tm.wc = tm.wc CLIPPED 
    -- 第一步 待处理的工单
    LET l_sql = "insert into csfr017_sfb select unique sfb01 from sfb_file where ",tm.wc clipped 
    prepare csfr017_sel_sfb01 from l_sql
    execute csfr017_sel_sfb01
    -- 报废
    let l_sql = "insert into csfr017_doc select shb05,'1',shb01,shb03,shb031,shboriu,shboriu ",
                " from shb_file,csfr017_sfb where shb05 = sfb01 and shb112 > 0"
    prepare csfr017_sel_baofei from l_sql
    execute csfr017_sel_baofei
    -- 下线
    let l_sql = "insert into csfr017_doc select substr(tsc14,1,12) tsc14,'2',tsc01,tlf06,tlf08,tlf09,tscuser ",
                " from tsc_file,tlf_file,csfr017_sfb where tlf905 = tscud05 and tlf906 = 1 and  substr(tsc14,1,12) = sfb01"
    prepare csfr017_sel_xiaxian from l_sql
    execute csfr017_sel_xiaxian
    -- 发料
    let l_sql = "insert into csfr017_doc select sfe01,'3',sfe02,sfe04,max(sfe05) sfe05,sfe25,sfe25 from sfe_file,csfr017_sfb ",
                " where sfe01 = sfb01 group by sfe01,'3',sfe02,sfe04,sfe25 "
    prepare csfr017_sel_faliao from l_sql
    execute csfr017_sel_faliao
    -- 入库 
    let l_sql = "insert into csfr017_doc select sfv11,'4',sfv01,tlf06,tlf08,tlf09,sfuuser ",
                " from ( select sfv01,sfv11,sfuuser,min(sfv03) sfv03 from sfv_file,sfu_file,csfr017_sfb ",
                "         where sfu01 = sfv01 and sfv11 = sfb01 group by sfv01,sfv11,sfuuser ),tlf_file ",
                " where sfv01 = tlf905 and sfv03 = tlf906"
    prepare csfr017_sel_ruku from l_sql
    execute csfr017_sel_ruku
    -- 报工
    let l_sql = "insert into csfr017_doc select a.shb05,'5',a.shb16,a.shb03,a.shb031,a.shb04,a.shb04 from shb_file a, ( ",
                " select shb16,shb05,max(shb06) shb06 from shb_file,csfr017_sfb  ",
                " where shb05 = sfb01 and shb111 > 0  ",
                " group by shb16,shb05) b ",
                " where a.shb16 = b.shb16 and a.shb05 = b.shb05 and a.shb06 = b.shb06"
    prepare csfr017_sel_baogong from l_sql
    execute csfr017_sel_baogong 

    let l_sql = "insert into ",g_cr_db_str CLIPPED,l_table CLIPPED ,
                " with a as (
                SELECT sfb01,ROW_NUMBER() over(partition by sfb01 order by sfb01 ) as line
                FROM ( select sfb01,max(cnt) cnt from  (
                select sfb01,typ,count(1) cnt from csfr017_doc group by sfb01,typ
                ) group by sfb01 ) t
                CONNECT BY LEVEL <= cnt
                AND PRIOR SYS_GUID() IS NOT NULL
                AND PRIOR sfb01= sfb01 ),
                b as (
                select sfb01,docno,dat,tim,post,crt,
                ROW_NUMBER() over(partition by sfb01 order by docno) as line
                from csfr017_doc where typ = '1' ),
                c as (
                select sfb01,docno,dat,tim,post,crt,
                ROW_NUMBER() over(partition by sfb01 order by docno) as line
                from csfr017_doc where typ = '2' ),
                d as (
                select sfb01,docno,dat,tim,post,crt,
                ROW_NUMBER() over(partition by sfb01 order by docno) as line
                from csfr017_doc where typ = '3' ),
                e as (
                select sfb01,docno,dat,tim,post,crt,
                ROW_NUMBER() over(partition by sfb01 order by docno) as line
                from csfr017_doc where typ = '4' ),
                f as (
                select sfb01,docno,dat,tim,post,crt,
                ROW_NUMBER() over(partition by sfb01 order by docno) as line
                from csfr017_doc where typ = '5' )
                select coalesce(a.sfb01,b.sfb01,c.sfb01,d.sfb01,e.sfb01,f.sfb01) as sfb01,a.line,
                b.docno,b.dat,b.tim,b.post,b1.gen02,b.crt,b2.gen02,
                c.docno,c.dat,c.tim,c.post,c1.gen02,c.crt,c2.gen02,
                d.docno,d.dat,d.tim,d.post,d1.gen02,d.crt,d2.gen02,
                e.docno,e.dat,e.tim,e.post,e1.gen02,e.crt,e2.gen02,
                f.docno,f.dat,f.tim,f.post,f1.gen02,f.crt,f2.gen02
                from  a
                left join b  on a.sfb01 = b.sfb01 and a.line = b.line
                left join c  on c.sfb01 = a.sfb01 and c.line = a.line
                left join d  on d.sfb01 = a.sfb01 and d.line = a.line
                left join e  on e.sfb01 = a.sfb01 and e.line = a.line
                left join f  on f.sfb01 = a.sfb01 and f.line = a.line
                left join gen_file b1 on b1.gen01 = b.post left join gen_file b2 on b2.gen01 = b.crt
                left join gen_file c1 on c1.gen01 = c.post left join gen_file c2 on c2.gen01 = c.crt
                left join gen_file d1 on d1.gen01 = d.post left join gen_file d2 on d2.gen01 = d.crt
                left join gen_file e1 on e1.gen01 = e.post left join gen_file e2 on e2.gen01 = e.crt
                left join gen_file f1 on f1.gen01 = f.post left join gen_file f2 on f2.gen01 = f.crt"
    PREPARE csfr017_parse FROM l_sql
    execute csfr017_parse
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED ," order by 1,2"

    call cl_fast_query_zat("tqrcsf0011", g_sql, true)
END FUNCTION

function csfr017_crt_tmp()
    -- 待处理订单清单
    drop table csfr017_sfb
    create temp table csfr017_sfb(
        sfb01   varchar(40)
    )
    -- 单据明细
    drop table csfr017_doc
    create temp table csfr017_doc(
        sfb01   varchar(40), -- 工单号
        typ     varchar(10), -- 类型
        docno   varchar(40),
        dat     date,
        tim     varchar(20),
        post    varchar(200),
        crt     varchar(200)
    )
end function
