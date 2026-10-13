/*
================================================================================
檔案代號:ofc_file
檔案名稱:潜在客户等级资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ofc_file
(
ofc01       varchar2(1) NOT NULL,    /*潜在客户等级                           */
                                     /*潛在客戶等級                           */
ofc02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
ofc03       varchar2(1),             /*是否需要定期拜访                       */
                                     /*是否需要定期拜訪(Y/N)                  */
ofc04       number(5),               /*拜访周期-月                            */
                                     /*拜訪周期-月                            */
ofc05       number(5),               /*拜访周期-日                            */
                                     /*拜訪周期-日                            */
ofc06       number(5),               /*拜访次数                               */
                                     /*拜訪次數                               */
ofc07       varchar2(1),             /*DM行销                                 */
                                     /*DM行銷                                 */
ofc08       varchar2(1),             /*Fax行销                                */
                                     /*Fax行銷                                */
ofc09       varchar2(1),             /*Mail行销                               */
                                     /*Mail行銷                               */
ofc10       varchar2(1),             /*电话行销                               */
                                     /*電話行銷                               */
ofcacti     varchar2(1),             /*资料有效码                             */
ofcuser     varchar2(10),            /*资料所有者                             */
ofcgrup     varchar2(10),            /*资料所有群                             */
ofcmodu     varchar2(10),            /*资料更改者                             */
ofcdate     date,                    /*最近更改日                             */
ofcorig     varchar2(10),            /*资料建立部门                           */
ofcoriu     varchar2(10)             /*资料建立者                             */
);

alter table ofc_file add  constraint ofc_pk primary key  (ofc01) enable validate;
grant select on ofc_file to tiptopgp;
grant update on ofc_file to tiptopgp;
grant delete on ofc_file to tiptopgp;
grant insert on ofc_file to tiptopgp;
grant index on ofc_file to public;
grant select on ofc_file to ods;
