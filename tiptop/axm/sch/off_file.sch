/*
================================================================================
檔案代號:off_file
檔案名稱:潜在客户竞争厂商资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table off_file
(
off01       varchar2(10) NOT NULL,   /*潜在客户编号                           */
                                     /*潛在客戶編號                           */
off02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
off03       varchar2(10),            /*竞争厂商编号                           */
                                     /*競爭廠商編號                           */
off04       varchar2(40),            /*厂商简称                               */
                                     /*廠商簡稱                               */
off05       varchar2(255),           /*竞争过程                               */
                                     /*競爭過程                               */
off051      varchar2(255),           /*竞争过程                               */
                                     /*競爭過程                               */
off052      varchar2(255),           /*竞争过程                               */
                                     /*競爭過程                               */
off053      varchar2(255),           /*竞争过程                               */
                                     /*競爭過程                               */
off054      varchar2(255),           /*竞争过程                               */
                                     /*競爭過程                               */
off06       varchar2(255),           /*优势                                   */
                                     /*優勢                                   */
off061      varchar2(255),           /*优势                                   */
                                     /*優勢                                   */
off07       varchar2(255),           /*劣势                                   */
                                     /*劣勢                                   */
off071      varchar2(255),           /*劣势                                   */
                                     /*劣勢                                   */
offacti     varchar2(1),             /*资料有效码                             */
offuser     varchar2(10),            /*资料所有者                             */
offgrup     varchar2(10),            /*资料所有部门                           */
offmodu     varchar2(10),            /*资料更改者                             */
offdate     date,                    /*最近更改日                             */
offoriu     varchar2(10),            /*资料建立者                             */
offorig     varchar2(10)             /*资料建立部门                           */
);

alter table off_file add  constraint off_pk primary key  (off01,off02) enable validate;
grant select on off_file to tiptopgp;
grant update on off_file to tiptopgp;
grant delete on off_file to tiptopgp;
grant insert on off_file to tiptopgp;
grant index on off_file to public;
grant select on off_file to ods;
