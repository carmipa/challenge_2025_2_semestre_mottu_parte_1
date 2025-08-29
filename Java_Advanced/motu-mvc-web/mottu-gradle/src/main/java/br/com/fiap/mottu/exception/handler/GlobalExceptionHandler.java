package br.com.fiap.mottu.exception.handler;

import br.com.fiap.mottu.exception.DuplicatedResourceException;
import br.com.fiap.mottu.exception.InvalidInputException;
import br.com.fiap.mottu.exception.ResourceNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ModelAndView handleResourceNotFoundException(HttpServletRequest req, ResourceNotFoundException ex) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("errorMessage", ex.getMessage());
        mav.addObject("url", req.getRequestURL());
        mav.setViewName("error/404"); // -> /templates/error/404.html
        mav.setStatus(HttpStatus.NOT_FOUND);
        return mav;
    }

    @ExceptionHandler(DuplicatedResourceException.class)
    public ModelAndView handleDuplicatedResourceException(HttpServletRequest req, DuplicatedResourceException ex) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("errorMessage", ex.getMessage());
        mav.addObject("url", req.getRequestURL());
        mav.setViewName("error/409"); // -> /templates/error/409.html
        mav.setStatus(HttpStatus.CONFLICT);
        return mav;
    }

    @ExceptionHandler(InvalidInputException.class)
    public ModelAndView handleInvalidInputException(HttpServletRequest req, InvalidInputException ex) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("errorMessage", ex.getMessage());
        mav.addObject("url", req.getRequestURL());
        mav.setViewName("error/400"); // -> /templates/error/400.html
        mav.setStatus(HttpStatus.BAD_REQUEST);
        return mav;
    }

    @ExceptionHandler(Exception.class)
    public ModelAndView handleGenericException(HttpServletRequest req, Exception ex) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("errorMessage", "Ocorreu um erro inesperado no sistema.");
        mav.addObject("exception", ex.getMessage());
        mav.addObject("url", req.getRequestURL());
        mav.setViewName("error/500"); // -> /templates/error/500.html
        mav.setStatus(HttpStatus.INTERNAL_SERVER_ERROR);
        return mav;
    }
}