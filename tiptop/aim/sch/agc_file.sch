/*
================================================================================
檔案代號:agc_file
檔案名稱:属性资料主档
檔案目的:记录多属性料件机制中定义的属性资料
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table agc_file
(
agc01       varchar2(10) NOT NULL,   /*属性代码                               */
agc02       varchar2(80) NOT NULL,   /*属性名称                               */
agc03       number(5) NOT NULL,      /*使用长度                               */
agc04       varchar2(1) NOT NULL,    /*使用方式                               */
                                     /* 1.Dynamic entry                       */
                                     /* 2.Pre-define value                    */
                                     /* 3.Pre-define range                    */
agc05       varchar2(20),            /*起始范围                               */
agc06       varchar2(20),            /*截至范围                               */
agcacti     varchar2(1),             /*资料有效码                             */
agcdate     date,                    /*最近更改日                             */
agcgrup     varchar2(10),            /*资料所有部门                           */
agcmodu     varchar2(10),            /*资料更改者                             */
agcuser     varchar2(10),            /*资料所有者                             */
agcorig     varchar2(10),            /*资料建立部门                           */
agcoriu     varchar2(10),            /*资料建立者                             */
agc07       varchar2(1)              /*属性                                   */
);

alter table agc_file add  constraint agc_pk primary key  (agc01) enable validate;
grant select on agc_file to tiptopgp;
grant update on agc_file to tiptopgp;
grant delete on agc_file to tiptopgp;
grant insert on agc_file to tiptopgp;
grant index on agc_file to public;
grant select on agc_file to ods;
