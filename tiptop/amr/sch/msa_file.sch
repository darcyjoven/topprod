/*
================================================================================
檔案代號:msa_file
檔案名稱:MPS 计划单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table msa_file
(
msa01       varchar2(20) NOT NULL,   /*MPS 计划编号                           */
                                     /*MPS 計劃編號                           */
msa02       varchar2(80),            /*计划说明                               */
                                     /*計劃說明                               */
msa03       varchar2(1),             /*结案码                                 */
                                     /*結案碼(Y/N)                            */
msa04       date,                    /*结案日期                               */
                                     /*結案日期                               */
msa05       varchar2(1),             /*确认码                                 */
msa06       varchar2(1),             /*No Use                                 */
msa07       varchar2(1),             /*No Use                                 */
msauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
msadate     date,                    /*资料录入日                             */
                                     /*資料輸入日                             */
msamodu     varchar2(10) DEFAULT ' ',/*最近更改者                             */
                                     /*最近修改者                             */
msamodd     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
msa08       date,                    /*单据日期                               */
msaud01     varchar2(255),           /*自订字段-Textedit                      */
msaud02     varchar2(40),            /*自订字段-文字                          */
msaud03     varchar2(40),            /*自订字段-文字                          */
msaud04     varchar2(40),            /*自订字段-文字                          */
msaud05     varchar2(40),            /*自订字段-文字                          */
msaud06     varchar2(40),            /*自订字段-文字                          */
msaud07     number(15,3),            /*自订字段-数值                          */
msaud08     number(15,3),            /*自订字段-数值                          */
msaud09     number(15,3),            /*自订字段-数值                          */
msaud10     number(10),              /*自订字段-整数                          */
msaud11     number(10),              /*自订字段-整数                          */
msaud12     number(10),              /*自订字段-整数                          */
msaud13     date,                    /*自订字段-日期                          */
msaud14     date,                    /*自订字段-日期                          */
msaud15     date,                    /*自订字段-日期                          */
msaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
msalegal    varchar2(10) NOT NULL,   /*所属法人                               */
msaoriu     varchar2(10),            /*资料建立者                             */
msaorig     varchar2(10),            /*资料建立部门                           */
msagrup     varchar2(10)             /*资料所有部门                           */
);

alter table msa_file add  constraint msa_pk primary key  (msa01) enable validate;
grant select on msa_file to tiptopgp;
grant update on msa_file to tiptopgp;
grant delete on msa_file to tiptopgp;
grant insert on msa_file to tiptopgp;
grant index on msa_file to public;
grant select on msa_file to ods;
