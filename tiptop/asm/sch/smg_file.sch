/*
================================================================================
檔案代號:smg_file
檔案名稱:成本项目资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table smg_file
(
smg01       varchar2(10) NOT NULL,   /*成本项目编号                           */
                                     /*成本項目編號                           */
smg02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
smg03       varchar2(1),             /*成本归类                               */
                                     /*成本歸類                               */
                                     /* 1:直接材料成本                        */
                                     /* 2:附加材料成本                        */
                                     /* 3:生產成本                            */
                                     /* 4:附加生產成本                        */
                                     /* 5:一般附加成本                        */
                                     /* 9:其它成本                            */
smguser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
smggrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
smgmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
smgdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
smgacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
smgoriu     varchar2(10),            /*资料建立者                             */
smgorig     varchar2(10)             /*资料建立部门                           */
);

alter table smg_file add  constraint smg_pk primary key  (smg01) enable validate;
grant select on smg_file to tiptopgp;
grant update on smg_file to tiptopgp;
grant delete on smg_file to tiptopgp;
grant insert on smg_file to tiptopgp;
grant index on smg_file to public;
grant select on smg_file to ods;
