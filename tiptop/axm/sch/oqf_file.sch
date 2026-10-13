/*
================================================================================
檔案代號:oqf_file
檔案名稱:工作中心资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oqf_file
(
oqf01       varchar2(10) NOT NULL,   /*工作中心                               */
oqf02       number(12,3),            /*每小时工资率                           */
                                     /*每小時工資率                           */
oqf03       number(12,3),            /*每小时间接制费分摊率                   */
                                     /*每小時間接製費分攤率                   */
oqfacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
oqfuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
oqfgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
oqfmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
oqfdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
oqforiu     varchar2(10),            /*资料建立者                             */
oqforig     varchar2(10)             /*资料建立部门                           */
);

alter table oqf_file add  constraint oqf_pk primary key  (oqf01) enable validate;
grant select on oqf_file to tiptopgp;
grant update on oqf_file to tiptopgp;
grant delete on oqf_file to tiptopgp;
grant insert on oqf_file to tiptopgp;
grant index on oqf_file to public;
grant select on oqf_file to ods;
