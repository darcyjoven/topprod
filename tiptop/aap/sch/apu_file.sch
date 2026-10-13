/*
================================================================================
檔案代號:apu_file
檔案名稱:应付账款使用会计科目档(当前不使用)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table apu_file
(
apu01       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*科目編號                               */
apu02       varchar2(255),           /*科目名称                               */
                                     /*科目名稱                               */
apuacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
apuuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
apugrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
apumodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
apudate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
apuorig     varchar2(10),            /*资料建立部门                           */
apuoriu     varchar2(10)             /*资料建立者                             */
);

alter table apu_file add  constraint apu_pk primary key  (apu01) enable validate;
grant select on apu_file to tiptopgp;
grant update on apu_file to tiptopgp;
grant delete on apu_file to tiptopgp;
grant insert on apu_file to tiptopgp;
grant index on apu_file to public;
grant select on apu_file to ods;
