﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MSSCargarClientes.BE;
using System.Data;
using System.Configuration;

namespace MSSCargarClientes.BL
{
    public static class DetalleVentaBL
    {
        //db.obtenerDetalleDocumentos(cabeceraDoc.tipdoc, cabeceraDoc.seriedoc, cabeceraDoc.nrodoc).ToList<DETALLEVENTA>();
        public static List<DetalleVentaBE> obtenerDetalleDocumentos(string tipdoc, string seriedoc, string nrodoc) {
            BDREP helper = BDREP.GetInstance();
            List<DetalleVentaBE> ls = new List<DetalleVentaBE>();

            IDataReader reader = helper.CargarDataReaderProc("obtenerDetalleDocumentos", tipdoc, seriedoc, nrodoc);
            if (reader == null) throw helper.MensajeErrorReal;
            ls = Util.ConvertirAEntidades<DetalleVentaBE>(reader);

            return ls;
        
        }
        public static void modificarDetalleDocumento(string TipDoc, string NroDoc, string SerieDoc, string CodArticulo, string estado, string nroLote, string observacion, int asientoContable){
            BDREP helper = BDREP.GetInstance();
            try
            {

                int resp = helper.Ejecute("modificarDetalleDocumento", TipDoc, NroDoc, SerieDoc, CodArticulo, estado, nroLote, observacion, asientoContable);
                if (resp == -2)
                {
                    throw helper.MensajeErrorReal;
                }

            }
            catch (DataException ex)
            {
                throw ex;
            }
        
        }


        public static void insertarDetalleDocumento(DetalleVentaBE d)
        {
            BDREP helper = BDREP.GetInstance();
            try
            {

                int resp = helper.Ejecute("insertarDetalleDocumento", d.TipDoc, d.Nrodoc, d.Seriedoc, d.Seriecaseta,
                    d.Seriedetraccion, d.Nrodetraccion, d.Nomcliente, d.Idcliente, d.Sentido, d.Placa, d.Codestacion,  d.Fecdoc,
                    d.FecProceso, d.Codarticulo, d.Cantidad, d.Preuni, d.Total, d.Igv, d.TotalDetraccion,  d.Nrodocasociado,
                    d.FechaVencimientoVale, d.NroTag, d.Turno, d.TipoDocsunat, d.DestinoOperacion, d.NroAsientoCont, d.Estado, d.Observacion, d.CodLote);


                if (resp == -2)
                {
                    throw helper.MensajeErrorReal;
                }

            }
            catch (DataException ex)
            {
                throw ex;
            }

        }
        // INSERTAR DETALLE
        
        public static void almacenarHistorico() {
            BDREP helper = BDREP.GetInstance();
            try
            {

                int resp = helper.Ejecute("almacenarHistorico");
                if (resp == -2)
                {
                    throw helper.MensajeErrorReal;
                }

            }
            catch (DataException ex)
            {
                throw ex;
            }
        
        }

        // db.modificarDetalleDocumento(d.tipdoc, d.nrodoc, d.seriedoc, d.codarticulo, 'P', nroLote, "", 0);
    }
}
