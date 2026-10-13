/*
================================================================================
檔案代號:hrah_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrah_file
(
hrah00      varchar2(6) NOT NULL,    /*固定值 000000                          */
hrah01      varchar2(1),             /*触发人事跟踪                           */
hrah02      varchar2(1),             /*电子卡是否注销标                       */
hrah03      varchar2(1),             /*判别依据                               */
hrah04      varchar2(1),             /*控制方式                               */
hrahacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrahuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrahgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrahmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrahdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrahoriu    varchar2(10),            /*资料建立者                             */
hrahorig    varchar2(10)             /*资料建立部门                           */
);

alter table hrah_file add  constraint tpc_hrah_pk primary key  (hrah00) enable validate;
grant select on hrah_file to tiptopgp;
grant update on hrah_file to tiptopgp;
grant delete on hrah_file to tiptopgp;
grant insert on hrah_file to tiptopgp;
grant index on hrah_file to public;
grant select on hrah_file to ods;
