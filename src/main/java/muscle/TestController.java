package muscle;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
@RequestMapping("/test")
public class TestController {
    public ModelAndView test() {
        ModelAndView mv = new ModelAndView("/test/test");
        return mv;
    }
}
