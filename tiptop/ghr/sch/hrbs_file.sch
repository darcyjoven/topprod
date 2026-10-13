/*
================================================================================
檔案代號:hrbs_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbs_file
(
hrbs01      varchar2(20) NOT NULL,   /*编码                                   */
hrbs02      varchar2(100),           /*格式档名称                             */
hrbs03      varchar2(20),            /*所属银行                               */
hrbs04      varchar2(20),            /*银行代发性质                           */
hrbs05      varchar2(20),            /*所属公司                               */
hrbs06      number(5) NOT NULL,      /*序号                                   */
hrbs07      varchar2(20),            /*字段名称编码                           */
hrbs08      number(5),               /*长度                                   */
hrbs09      varchar2(1),             /*档案转出长度为实际长度                 */
hrbs10      varchar2(1),             /*字段类型                               */
hrbs11      number(5),               /*小数位                                 */
hrbs12      varchar2(1),             /*含分千位分隔符                         */
hrbs13      varchar2(1),             /*含小数点                               */
hrbs14      varchar2(20),            /*对齐方式                               */
hrbs15      varchar2(20),            /*补位符                                 */
hrbsacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrbsuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrbsgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrbsmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrbsdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrbsoriu    varchar2(10),            /*资料建立者                             */
hrbsorig    varchar2(10),            /*资料建立部门                           */
hrbsud01    varchar2(255),           /*自订栏位-Textedit                      */
hrbsud02    varchar2(40),            /*自订栏位-文字                          */
hrbsud03    varchar2(40),            /*自订栏位-文字                          */
hrbsud04    varchar2(40),            /*自订栏位-文字                          */
hrbsud05    varchar2(40),            /*自订栏位-文字                          */
hrbsud06    varchar2(40),            /*自订栏位-文字                          */
hrbsud07    number(15,3),            /*自订栏位-数值                          */
hrbsud08    number(15,3),            /*自订栏位-数值                          */
hrbsud09    number(15,3),            /*自订栏位-数值                          */
hrbsud10    number(10),              /*自订栏位-整数                          */
hrbsud11    number(10),              /*自订栏位-整数                          */
hrbsud12    number(10),              /*自订栏位-整数                          */
hrbsud13    date,                    /*自订栏位-日期                          */
hrbsud14    date,                    /*自订栏位-日期                          */
hrbsud15    date                     /*自订栏位-日期                          */
);

alter table hrbs_file add  constraint tpc_hrbs_pk primary key  (hrbs01,hrbs06) enable validate;
grant select on hrbs_file to tiptopgp;
grant update on hrbs_file to tiptopgp;
grant delete on hrbs_file to tiptopgp;
grant insert on hrbs_file to tiptopgp;
grant index on hrbs_file to public;
grant select on hrbs_file to ods;
